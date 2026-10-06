import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../data/connection/database_key.dart';

/// Verschlüsselt Dateien der Akte (Berichte, Scans, Medien) auf dem Gerät.
///
/// Format „MAIV“ v1: Kopf (Magic, Version, Blockgröße, 8 Byte Nonce-Präfix),
/// danach Blöcke à [chunkSize] Klartext mit AES-256-GCM. Nonce = Präfix +
/// Blockzähler; Kopf, Zähler und „letzter Block“ sind authentifiziert —
/// Vertauschen, Kürzen oder Anhängen fällt auf.
///
/// Der Schlüssel wird per HKDF aus dem Datenbankschlüssel abgeleitet (der im
/// Android Keystore verpackt ist): kein zweites Geheimnis, gleicher Schutz.
/// Lesen versteht auch unverschlüsselte Altdateien; [migrate] verschlüsselt
/// sie nachträglich.
abstract interface class FileVault {
  /// Ohne Schlüssel (Tests, Desktop): Dateien bleiben unverschlüsselt.
  static FileVault current = const PlainFileVault();

  /// Android: Schlüssel aus dem Datenbankschlüssel; sonst [PlainFileVault].
  static Future<FileVault> open({DatabaseKeyStore? keys}) async {
    final hex = await (keys ?? const PlatformDatabaseKeyStore()).getOrCreate();
    if (hex == null) return const PlainFileVault();
    return AesFileVault.fromDatabaseKey(hex);
  }

  bool get encrypts;

  /// Schreibt [source] (Klartext) verschlüsselt nach [target].
  Future<void> encryptFile(String source, String target);

  /// Schreibt [bytes] verschlüsselt nach [target].
  Future<void> writeBytes(String target, Uint8List bytes);

  /// Inhalt im Klartext (verschlüsselt oder Altdatei).
  Future<Uint8List> readBytes(String path);

  /// Schreibt den Klartext von [path] nach [target] (blockweise, auch für
  /// große Videos).
  Future<void> decryptTo(String path, String target);

  /// Klartext-Kopie im Cache für Plugins, die einen Pfad brauchen (OCR,
  /// Videos). Aufrufer löscht sie; Reste räumt `TempFiles.purge` ab.
  Future<File> decryptToTemp(String path);

  /// Verschlüsselt eine Klartextdatei an Ort und Stelle (atomar).
  Future<void> encryptInPlace(String path);

  /// Verschlüsselt alle Altdateien in [dir]; gibt die Anzahl zurück.
  Future<int> migrate(Directory dir);
}

/// Prüft am Dateianfang, ob eine Datei im Vault-Format vorliegt.
Future<bool> isVaultFile(String path) async {
  final file = File(path);
  if (!await file.exists() || await file.length() < AesFileVault.headerSize) {
    return false;
  }
  final raf = await file.open();
  try {
    final head = await raf.read(5);
    return _startsWithMagic(head);
  } finally {
    await raf.close();
  }
}

bool _startsWithMagic(List<int> head) =>
    head.length >= 5 &&
    head[0] == 0x4d && // M
    head[1] == 0x41 && // A
    head[2] == 0x49 && // I
    head[3] == 0x56 && // V
    head[4] == 1;

Future<Directory> _vaultTempDir() async {
  final base = await getTemporaryDirectory();
  return Directory(p.join(base.path, 'vault_tmp')).create(recursive: true);
}

/// Keine Verschlüsselung (Tests, Plattformen ohne Keystore).
class PlainFileVault implements FileVault {
  const PlainFileVault();

  @override
  bool get encrypts => false;

  @override
  Future<void> encryptFile(String source, String target) async {
    await File(source).copy(target);
  }

  @override
  Future<void> writeBytes(String target, Uint8List bytes) =>
      File(target).writeAsBytes(bytes, flush: true);

  @override
  Future<Uint8List> readBytes(String path) => File(path).readAsBytes();

  @override
  Future<void> decryptTo(String path, String target) async {
    await File(path).copy(target);
  }

  @override
  Future<File> decryptToTemp(String path) async {
    final dir = await _vaultTempDir();
    return File(path).copy(
      p.join(dir.path, '${_stamp()}${p.extension(path)}'),
    );
  }

  @override
  Future<void> encryptInPlace(String path) async {}

  @override
  Future<int> migrate(Directory dir) async => 0;
}

class AesFileVault implements FileVault {
  AesFileVault(this._key) : assert(_key.length == 32);

  /// HKDF-SHA256 aus dem Datenbankschlüssel (64 Hex-Zeichen).
  static Future<AesFileVault> fromDatabaseKey(String hex) async {
    final secret = SecretKey([
      for (var i = 0; i < hex.length; i += 2)
        int.parse(hex.substring(i, i + 2), radix: 16),
    ]);
    final derived = await Hkdf(
      hmac: Hmac.sha256(),
      outputLength: 32,
    ).deriveKey(
      secretKey: secret,
      nonce: utf8.encode('mai-doctor-hub'),
      info: utf8.encode('files/v1'),
    );
    return AesFileVault(Uint8List.fromList(await derived.extractBytes()));
  }

  static const chunkSize = 1 << 20;
  static const headerSize = 4 + 1 + 4 + 8;
  static const _macLength = 16;

  final Uint8List _key;

  @override
  bool get encrypts => true;

  @override
  Future<void> encryptFile(String source, String target) {
    final key = _key;
    return Isolate.run(() => _encrypt(key, File(source).openRead(), target));
  }

  @override
  Future<void> writeBytes(String target, Uint8List bytes) {
    final key = _key;
    return Isolate.run(
      () => _encrypt(key, Stream.value(bytes), target),
    );
  }

  @override
  Future<Uint8List> readBytes(String path) {
    final key = _key;
    return Isolate.run(() async {
      final out = BytesBuilder(copy: false);
      await _decrypt(key, path, out.add);
      return out.takeBytes();
    });
  }

  @override
  Future<void> decryptTo(String path, String target) {
    final key = _key;
    return Isolate.run(() async {
      final sink = File(target).openWrite();
      try {
        await _decrypt(key, path, sink.add);
      } finally {
        await sink.close();
      }
    });
  }

  @override
  Future<File> decryptToTemp(String path) async {
    final dir = await _vaultTempDir();
    final target = p.join(dir.path, '${_stamp()}${p.extension(path)}');
    try {
      await decryptTo(path, target);
    } catch (_) {
      // Keine halben Klartext-Reste liegen lassen.
      await File(target).delete().catchError((Object _) => File(target));
      rethrow;
    }
    return File(target);
  }

  @override
  Future<void> encryptInPlace(String path) async {
    if (await isVaultFile(path)) return;
    final tmp = '$path.enc.tmp';
    await encryptFile(path, tmp);
    await File(tmp).rename(path);
  }

  @override
  Future<int> migrate(Directory dir) async {
    if (!await dir.exists()) return 0;
    var count = 0;
    await for (final entry in dir.list(followLinks: false)) {
      if (entry is! File) continue;
      // Reste eines abgebrochenen Laufs: das Original ist noch da.
      if (entry.path.endsWith('.enc.tmp')) {
        await entry.delete();
        continue;
      }
      if (await isVaultFile(entry.path)) continue;
      try {
        await encryptInPlace(entry.path);
        count++;
      } catch (e) {
        debugPrint('Datei nicht verschlüsselt: $e');
      }
    }
    return count;
  }
}

String _stamp() =>
    '${DateTime.now().microsecondsSinceEpoch}_${Random.secure().nextInt(1 << 32)}';

Uint8List _aad(Uint8List header, int index, bool last) {
  final aad = Uint8List(header.length + 5)..setAll(0, header);
  ByteData.sublistView(aad).setUint32(header.length, index);
  aad[header.length + 4] = last ? 1 : 0;
  return aad;
}

Uint8List _nonce(Uint8List prefix, int index) {
  final nonce = Uint8List(12)..setAll(0, prefix);
  ByteData.sublistView(nonce).setUint32(8, index);
  return nonce;
}

/// Liest [input] in Blöcken und schreibt verschlüsselt nach [target].
Future<void> _encrypt(
  Uint8List key,
  Stream<List<int>> input,
  String target,
) async {
  final algorithm = AesGcm.with256bits();
  final secret = SecretKey(key);
  final random = Random.secure();
  final prefix = Uint8List.fromList(
    List.generate(8, (_) => random.nextInt(256)),
  );
  final header = Uint8List(AesFileVault.headerSize)
    ..setAll(0, const [0x4d, 0x41, 0x49, 0x56, 1]);
  ByteData.sublistView(header).setUint32(5, AesFileVault.chunkSize);
  header.setAll(9, prefix);

  final sink = File(target).openWrite();
  try {
    sink.add(header);
    var index = 0;
    final pending = BytesBuilder(copy: false);

    Future<void> seal(Uint8List plain, {required bool last}) async {
      final box = await algorithm.encrypt(
        plain,
        secretKey: secret,
        nonce: _nonce(prefix, index),
        aad: _aad(header, index, last),
      );
      sink
        ..add(box.cipherText)
        ..add(box.mac.bytes);
      index++;
    }

    await for (final data in input) {
      pending.add(data);
      while (pending.length > AesFileVault.chunkSize) {
        final all = pending.takeBytes();
        await seal(
          Uint8List.sublistView(all, 0, AesFileVault.chunkSize),
          last: false,
        );
        pending.add(Uint8List.sublistView(all, AesFileVault.chunkSize));
      }
    }
    // Letzter Block (ggf. leer) trägt die Ende-Markierung.
    await seal(pending.takeBytes(), last: true);
    await sink.flush();
  } finally {
    await sink.close();
  }
}

/// Entschlüsselt [path] blockweise; Altdateien ohne Kopf werden durchgereicht.
Future<void> _decrypt(
  Uint8List key,
  String path,
  void Function(List<int>) emit,
) async {
  final raf = await File(path).open();
  try {
    final length = await raf.length();
    final header = await raf.read(AesFileVault.headerSize);
    if (!_startsWithMagic(header)) {
      // Unverschlüsselte Altdatei (vor der Migration).
      await raf.setPosition(0);
      while (true) {
        final data = await raf.read(1 << 20);
        if (data.isEmpty) break;
        emit(data);
      }
      return;
    }
    final chunk = ByteData.sublistView(header).getUint32(5);
    if (chunk <= 0 || chunk > 16 << 20) {
      throw const FormatException('Ungültige Blockgröße');
    }
    final prefix = Uint8List.sublistView(header, 9, 17);
    final algorithm = AesGcm.with256bits();
    final secret = SecretKey(key);
    final block = chunk + AesFileVault._macLength;
    final body = length - AesFileVault.headerSize;
    if (body < AesFileVault._macLength) {
      throw const FormatException('Datei unvollständig');
    }
    // Letzter Block ist kürzer (oder genau leer + MAC).
    final count = (body + block - 1) ~/ block;
    for (var index = 0; index < count; index++) {
      final data = await raf.read(block);
      if (data.length < AesFileVault._macLength) {
        throw const FormatException('Datei unvollständig');
      }
      final last = index == count - 1;
      final plain = await algorithm.decrypt(
        SecretBox(
          Uint8List.sublistView(data, 0, data.length - AesFileVault._macLength),
          nonce: _nonce(prefix, index),
          mac: Mac(
            Uint8List.sublistView(data, data.length - AesFileVault._macLength),
          ),
        ),
        secretKey: secret,
        aad: _aad(header, index, last),
      );
      emit(plain);
    }
  } finally {
    await raf.close();
  }
}
