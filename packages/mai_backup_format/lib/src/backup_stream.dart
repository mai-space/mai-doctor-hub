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
      final key = await _deriveKey(
        passphrase,
        base64Decode(meta['salt'] as String),
        meta['iterations'] as int,
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
  static Future<ExtractedBackup> extractZip(
    String zipPath,
    String dir, {
    bool databaseOnly = false,
  }) async {
    final input = InputFileStream(zipPath);
    try {
      final Archive archive;
      try {
        archive = ZipDecoder().decodeStream(input);
      } catch (e) {
        throw BackupException('Sicherung ist beschädigt.', e);
      }
      Map<String, dynamic>? manifest;
      String? databasePath;
      final files = <String, String>{};
      for (final entry in archive.files) {
        if (!entry.isFile) continue;
        if (entry.name == 'manifest.json') {
          manifest =
              jsonDecode(utf8.decode(entry.content)) as Map<String, dynamic>;
          continue;
        }
        if (databaseOnly && entry.name != 'db.sqlite') continue;
        // Keine Pfade außerhalb von [dir] (Zip-Slip).
        final safe = entry.name
            .split('/')
            .where((p) => p.isNotEmpty && p != '..' && p != '.')
            .join('_');
        final target = '$dir/$safe';
        final out = OutputFileStream(target);
        entry.writeContent(out);
        await out.close();
        if (entry.name == 'db.sqlite') {
          databasePath = target;
        } else {
          files[entry.name] = target;
        }
      }
      if (manifest == null || databasePath == null) {
        throw const BackupException('Sicherung ist unvollständig.');
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

  int get schemaVersion => manifest['schemaVersion'] as int? ?? 0;

  DateTime? get createdAt =>
      DateTime.tryParse(manifest['createdAt'] as String? ?? '');

  Map<String, String> get reportEntries =>
      (manifest['reports'] as Map<String, dynamic>? ?? const {})
          .cast<String, String>();
}
