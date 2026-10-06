import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:cryptography/cryptography.dart';

import 'backup_crypto.dart';

/// Gestreamtes Sicherungsformat v2 — für große Sicherungen (viele PDFs):
///
/// ```
/// "MAIBK" 0x02 | uint32 Header-Länge | Header-JSON
/// { uint32 Länge | AES-GCM(Chunk) + MAC(16) }*
/// ```
///
/// Header: `{v: 2, kdf, iterations, salt, nonce (8 Byte Präfix), chunk}`.
/// Chunk i: Nonce = Präfix ‖ uint32(i); AAD = Header ‖ uint64(i) ‖ final.
/// Das „final“-Flag am letzten Chunk erkennt abgeschnittene Dateien,
/// der Index vertauschte Chunks.
abstract final class BackupStream {
  static const _magicV1 = [0x4D, 0x41, 0x49, 0x42, 0x4B, 0x01];
  static const _magicV2 = [0x4D, 0x41, 0x49, 0x42, 0x4B, 0x02];
  static const defaultChunk = 1 << 20; // 1 MiB

  // Obergrenzen für Werte aus der (noch ungeprüften) Datei: Längenfelder
  // bis 4 GiB dürfen nicht ungeprüft Speicher anfordern.
  static const maxHeaderLength = 64 * 1024;
  static const maxChunk = 16 << 20; // 16 MiB

  // Obergrenzen beim Entpacken (Zip-Bomben, volle Platte).
  static const maxManifestSize = 16 << 20; // 16 MiB
  static const maxEntrySize = 2 << 30; // 2 GiB
  static const maxTotalSize = 4 << 30; // 4 GiB

  /// 1 = v1 (im Speicher), 2 = v2 (gestreamt), 0 = keine Sicherung.
  static Future<int> versionOf(String path) async {
    final raf = await File(path).open();
    try {
      final head = await raf.read(6);
      if (_same(head, _magicV2)) return 2;
      if (_same(head, _magicV1)) return 1;
      return 0;
    } finally {
      await raf.close();
    }
  }

  static Future<void> encryptFile(
    String plainPath,
    String outPath,
    String passphrase, {
    int iterations = BackupCrypto.defaultIterations,
    int chunkSize = defaultChunk,
  }) async {
    if (passphrase.length < BackupCrypto.minPassphraseLength) {
      throw const BackupException(
        'Passwort zu kurz (mindestens ${BackupCrypto.minPassphraseLength} Zeichen).',
      );
    }
    final random = Random.secure();
    List<int> bytes(int n) => [for (var i = 0; i < n; i++) random.nextInt(256)];
    final salt = bytes(16);
    final prefix = bytes(8);
    final header = utf8.encode(
      jsonEncode({
        'v': 2,
        'kdf': 'pbkdf2-sha256',
        'iterations': iterations,
        'salt': base64Encode(salt),
        'nonce': base64Encode(prefix),
        'chunk': chunkSize,
      }),
    );
    final key = await _deriveKey(passphrase, salt, iterations);
    final algorithm = AesGcm.with256bits();

    final input = await File(plainPath).open();
    final output = File(outPath).openWrite();
    try {
      output
        ..add(_magicV2)
        ..add(_uint32(header.length))
        ..add(header);
      final total = await input.length();
      var index = 0;
      var offset = 0;
      do {
        final chunk = await input.read(chunkSize);
        offset += chunk.length;
        final last = offset >= total;
        final box = await algorithm.encrypt(
          chunk,
          secretKey: key,
          nonce: [...prefix, ..._uint32(index)],
          aad: _aad(header, index, last),
        );
        output
          ..add(_uint32(box.cipherText.length + 16))
          ..add(box.cipherText)
          ..add(box.mac.bytes);
        index++;
      } while (offset < total);
    } finally {
      await input.close();
      await output.close();
    }
  }

  /// Entschlüsselt v1 oder v2 nach [outPath] (Klartext-ZIP).
  static Future<void> decryptFile(
    String inPath,
    String outPath,
    String passphrase,
  ) async {
    switch (await versionOf(inPath)) {
      case 1:
        // Alte Sicherungen: klein genug für den Speicher.
        final plain = await BackupCrypto.decrypt(
          await File(inPath).readAsBytes(),
          passphrase,
        );
        await File(outPath).writeAsBytes(plain, flush: true);
        return;
      case 2:
        await _decryptV2(inPath, outPath, passphrase);
        return;
      default:
        throw const BackupException('Keine Mai-Doctor-Hub-Sicherung.');
    }
  }

  static Future<void> _decryptV2(
    String inPath,
    String outPath,
    String passphrase,
  ) async {
    final input = await File(inPath).open();
    final output = File(outPath).openWrite();
    try {
      final total = await input.length();
      await input.setPosition(6);
      final headerLength = _readUint32(await input.read(4));
      if (headerLength > maxHeaderLength) {
        throw const BackupException('Sicherung ist beschädigt.');
      }
      final header = await input.read(headerLength);
      if (header.length != headerLength) {
        throw const BackupException('Sicherung ist beschädigt.');
      }
      final Map<String, dynamic> meta;
      try {
        meta = jsonDecode(utf8.decode(header)) as Map<String, dynamic>;
      } catch (e) {
        throw BackupException('Sicherung ist beschädigt.', e);
      }
      if (meta['v'] != 2 || meta['kdf'] != 'pbkdf2-sha256') {
        throw const BackupException(
          'Sicherungsformat wird nicht unterstützt — App aktualisieren.',
        );
      }
      final chunk = meta['chunk'];
      if (chunk is! int || chunk < 1 || chunk > maxChunk) {
        throw const BackupException('Sicherung ist beschädigt.');
      }
      final key = await _deriveKey(
        passphrase,
        base64Decode(meta['salt'] as String),
        BackupCrypto.iterationsOf(meta),
      );
      final prefix = base64Decode(meta['nonce'] as String);
      final algorithm = AesGcm.with256bits();

      var index = 0;
      var sawFinal = false;
      while (await input.position() < total) {
        if (sawFinal) {
          throw const BackupException('Sicherung ist beschädigt.');
        }
        final length = _readUint32(await input.read(4));
        if (length > chunk + 16) {
          throw const BackupException('Sicherung ist beschädigt.');
        }
        final sealed = await input.read(length);
        if (sealed.length != length || length < 16) {
          throw const BackupException('Sicherung ist unvollständig.');
        }
        final last = await input.position() >= total;
        final box = SecretBox(
          sealed.sublist(0, length - 16),
          nonce: [...prefix, ..._uint32(index)],
          mac: Mac(sealed.sublist(length - 16)),
        );
        try {
          output.add(
            await algorithm.decrypt(
              box,
              secretKey: key,
              aad: _aad(header, index, last),
            ),
          );
        } on SecretBoxAuthenticationError catch (e) {
          throw BackupException(
            index == 0
                ? 'Falsches Passwort oder beschädigte Datei.'
                : 'Sicherung ist beschädigt.',
            e,
          );
        }
        sawFinal = last;
        index++;
      }
      if (!sawFinal) {
        throw const BackupException('Sicherung ist unvollständig.');
      }
    } finally {
      await input.close();
      await output.close();
    }
  }

  // --- ZIP auf der Platte --------------------------------------------------

  /// Schreibt Datenbank, Dateien und Manifest Datei für Datei als ZIP.
  static Future<void> writeZip(
    String zipPath, {
    required String databasePath,
    required Map<String, Object?> manifest,
    Map<String, String> files = const {},
  }) async {
    final encoder = ZipFileEncoder()..create(zipPath);
    await encoder.addFile(File(databasePath), 'db.sqlite');
    for (final MapEntry(key: name, value: path) in files.entries) {
      // PDFs/Bilder sind schon komprimiert → nur speichern.
      await encoder.addFile(File(path), name, ZipFileEncoder.store);
    }
    encoder.addArchiveFile(
      ArchiveFile.string('manifest.json', jsonEncode(manifest)),
    );
    await encoder.close();
  }

  /// Entpackt eine Klartext-Sicherung nach [dir], Eintrag für Eintrag.
  /// Mit [databaseOnly] werden Berichtsdateien übersprungen.
  ///
  /// Entpackt werden nur die Datenbank und die im Manifest genannten
  /// Berichte, jeweils unter erzeugten Namen — Eintragsnamen aus dem Archiv
  /// landen nie im Dateisystem (Zip-Slip, Kollisionen, `backup.zip`).
  static Future<ExtractedBackup> extractZip(
    String zipPath,
    String dir, {
    bool databaseOnly = false,
  }) async {
    final input = InputFileStream(zipPath);
    try {
      final decoder = ZipDecoder();
      final Archive archive;
      try {
        archive = decoder.decodeStream(input);
      } catch (e) {
        throw BackupException('Sicherung ist beschädigt.', e);
      }
      // Doppelte Namen (das Archive behält still nur einen): unklar,
      // welcher gilt → ablehnen.
      final names = decoder.directory.fileHeaders.map((h) => h.filename);
      if (names.toSet().length != names.length) {
        throw const BackupException('Sicherung ist beschädigt.');
      }
      final entries = {
        for (final entry in archive.files)
          if (entry.isFile) entry.name: entry,
      };
      final manifestEntry = entries['manifest.json'];
      final databaseEntry = entries['db.sqlite'];
      if (manifestEntry == null || databaseEntry == null) {
        throw const BackupException('Sicherung ist unvollständig.');
      }

      var budget = maxTotalSize;
      int extract(ArchiveFile entry, String target, int limit) {
        final written = _extractEntry(entry, target, min(limit, budget));
        budget -= written;
        return written;
      }

      final manifestPath = '$dir/.manifest.json';
      extract(manifestEntry, manifestPath, maxManifestSize);
      final Map<String, dynamic> manifest;
      try {
        manifest =
            jsonDecode(await File(manifestPath).readAsString())
                as Map<String, dynamic>;
      } catch (e) {
        throw BackupException('Sicherung ist beschädigt.', e);
      } finally {
        await File(manifestPath).delete();
      }

      final databasePath = '$dir/database.sqlite';
      extract(databaseEntry, databasePath, maxEntrySize);

      final files = <String, String>{};
      if (!databaseOnly) {
        final wanted = _reportEntriesOf(manifest).values;
        for (final name in wanted.toSet()) {
          final entry = entries[name];
          if (entry == null) continue;
          final target = '$dir/file_${files.length}';
          extract(entry, target, maxEntrySize);
          files[name] = target;
        }
      }
      return ExtractedBackup(
        databasePath: databasePath,
        manifest: manifest,
        files: files,
      );
    } finally {
      await input.close();
    }
  }

  /// Schreibt [entry] nach [target]; bricht ab, sobald mehr als [limit]
  /// Byte entpackt würden (die Größe im ZIP-Header ist nicht verlässlich).
  static int _extractEntry(ArchiveFile entry, String target, int limit) {
    if (entry.size > limit) {
      throw const BackupException('Sicherung ist zu groß.');
    }
    final out = _LimitedOutputFileStream(target, limit);
    try {
      entry.writeContent(out);
    } on BackupException {
      rethrow;
    } catch (e) {
      throw BackupException('Sicherung ist beschädigt.', e);
    } finally {
      out.closeSync();
    }
    return out.length;
  }

  /// Entschlüsseln + entpacken nach [workDir] (Klartext-ZIP wird gelöscht).
  static Future<ExtractedBackup> open(
    String path,
    String passphrase,
    String workDir, {
    bool databaseOnly = false,
  }) async {
    final zipPath = '$workDir/backup.zip';
    await decryptFile(path, zipPath, passphrase);
    try {
      return await extractZip(zipPath, workDir, databaseOnly: databaseOnly);
    } finally {
      await File(zipPath).delete();
    }
  }

  static Future<SecretKey> _deriveKey(
    String passphrase,
    List<int> salt,
    int iterations,
  ) => Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: iterations,
    bits: 256,
  ).deriveKeyFromPassword(password: passphrase, nonce: salt);

  static List<int> _aad(List<int> header, int index, bool last) => [
    ...header,
    ...(ByteData(8)..setUint64(0, index)).buffer.asUint8List(),
    last ? 1 : 0,
  ];

  static List<int> _uint32(int v) =>
      (ByteData(4)..setUint32(0, v)).buffer.asUint8List();

  static int _readUint32(List<int> bytes) {
    if (bytes.length != 4) {
      throw const BackupException('Sicherung ist unvollständig.');
    }
    return ByteData.sublistView(Uint8List.fromList(bytes)).getUint32(0);
  }

  static bool _same(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Entpackte Sicherung auf der Platte.
class ExtractedBackup {
  const ExtractedBackup({
    required this.databasePath,
    required this.manifest,
    required this.files,
  });

  final String databasePath;
  final Map<String, dynamic> manifest;

  /// Pfad im Archiv → entpackte Datei.
  final Map<String, String> files;

  // Das Manifest kann aus einer präparierten Sicherung stammen — Typen
  // nicht blind vertrauen.
  int get schemaVersion => switch (manifest['schemaVersion']) {
    final int v => v,
    _ => 0,
  };

  DateTime? get createdAt => switch (manifest['createdAt']) {
    final String v => DateTime.tryParse(v),
    _ => null,
  };

  Map<String, String> get reportEntries => _reportEntriesOf(manifest);
}

/// Bericht-ID → Pfad im Archiv; Einträge mit falschem Typ entfallen.
Map<String, String> _reportEntriesOf(Map<String, dynamic> manifest) => {
  if (manifest['reports'] case final Map<String, dynamic> reports)
    for (final MapEntry(:key, :value) in reports.entries)
      if (value is String) key: value,
};

/// [OutputFileStream], der nach [limit] Byte mit [BackupException] abbricht.
class _LimitedOutputFileStream extends OutputFileStream {
  _LimitedOutputFileStream(String path, this.limit)
    : super.withFileHandle(FileHandle(path, mode: FileAccess.write));

  final int limit;

  void _check(int more) {
    if (length + more > limit) {
      throw const BackupException('Sicherung ist zu groß.');
    }
  }

  @override
  void writeByte(int value) {
    _check(1);
    super.writeByte(value);
  }

  @override
  void writeBytes(List<int> bytes, {int? length}) {
    _check(length ?? bytes.length);
    super.writeBytes(bytes, length: length);
  }
}
