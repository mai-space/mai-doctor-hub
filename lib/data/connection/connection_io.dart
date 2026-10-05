import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/common.dart' show CommonDatabase;
import 'package:sqlite3/sqlite3.dart';

import 'connection.dart';
import 'database_key.dart';

/// Öffnet die verschlüsselte App-Datenbank (SQLite3 Multiple Ciphers).
DatabaseConnection openAppDatabase({
  DatabaseKeyStore keys = const PlatformDatabaseKeyStore(),
}) {
  return DatabaseConnection.delayed(
    Future(() async {
      final path = p.join(
        (await getApplicationDocumentsDirectory()).path,
        'mai_doctor_hub.sqlite',
      );
      final (key, status) = await prepareDatabase(path, keys);
      databaseOpenStatus.value = status;
      return driftDatabase(
        name: 'mai_doctor_hub',
        native: DriftNativeOptions(
          databasePath: () async => path,
          setup: key == null ? null : (db) => applyKey(db, key),
        ),
      );
    }),
  );
}

/// Setzt den Schlüssel — muss die erste Anweisung auf der Verbindung sein.
void applyKey(CommonDatabase db, String key) {
  if (!RegExp(r'^[0-9a-f]{64}$').hasMatch(key)) {
    throw ArgumentError('Ungültiger Datenbankschlüssel');
  }
  db.execute("PRAGMA key = '$key'");
}

/// Bereitet die Datei unter [path] vor und liefert den Schlüssel:
///
/// - unverschlüsselte Bestandsdatenbank → wird an Ort und Stelle
///   verschlüsselt (einmalig nach dem Update);
/// - nicht entschlüsselbar (Schlüssel verloren, fremde Datei) → wird
///   beiseitegelegt, die App startet leer und bittet um Wiederherstellung.
@visibleForTesting
Future<(String?, DatabaseOpenStatus)> prepareDatabase(
  String path,
  DatabaseKeyStore keys,
) async {
  String? key;
  String? unreadable;
  try {
    key = await keys.getOrCreate();
  } on DatabaseKeyLost catch (e) {
    debugPrint('$e');
    unreadable = await _moveAside(path);
    await keys.reset();
    key = await keys.getOrCreate();
  }
  if (key == null) return (null, const DatabaseOpenStatus(encrypted: false));

  final file = File(path);
  if (await file.exists() && await file.length() > 0) {
    if (await _isPlaintext(file)) {
      _encryptInPlace(path, key);
    } else if (!_canOpen(path, key)) {
      unreadable = await _moveAside(path);
    }
  }
  return (key, DatabaseOpenStatus(encrypted: true, unreadableCopy: unreadable));
}

Future<bool> _isPlaintext(File file) async {
  final raf = await file.open();
  try {
    final head = await raf.read(16);
    return String.fromCharCodes(head) == 'SQLite format 3\u0000';
  } finally {
    await raf.close();
  }
}

void _encryptInPlace(String path, String key) {
  final db = sqlite3.open(path);
  try {
    // Offenes WAL zuerst in die Hauptdatei übernehmen.
    db.execute('PRAGMA wal_checkpoint(TRUNCATE)');
    db.execute("PRAGMA rekey = '$key'");
  } finally {
    db.close();
  }
}

bool _canOpen(String path, String key) {
  final db = sqlite3.open(path);
  try {
    applyKey(db, key);
    db.select('SELECT count(*) FROM sqlite_master');
    return true;
  } on SqliteException {
    return false;
  } finally {
    db.close();
  }
}

/// Benennt die Datei (samt -wal/-journal) um; liefert den neuen Pfad.
Future<String?> _moveAside(String path) async {
  final file = File(path);
  if (!await file.exists()) return null;
  final stamp = DateTime.now().millisecondsSinceEpoch;
  final target = p.join(
    p.dirname(path),
    '${p.basenameWithoutExtension(path)}.unlesbar-$stamp.sqlite',
  );
  await file.rename(target);
  for (final suffix in ['-wal', '-shm', '-journal']) {
    final extra = File('$path$suffix');
    if (await extra.exists()) await extra.delete();
  }
  return target;
}
