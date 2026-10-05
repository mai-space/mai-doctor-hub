import 'dart:io';

import 'package:mai_backup_format/mai_backup_format.dart';
import 'package:sqlite3/sqlite3.dart';

/// Höchste Schema-Version der App, die dieser Server versteht.
const supportedSchemaVersion = 6;

/// Read-only-Zugriff auf einen Akten-Snapshot.
///
/// Der Snapshot stammt aus einer verschlüsselten `.maibackup`-Sicherung; die
/// entschlüsselte Datenbank liegt nur für die Laufzeit in einer temporären
/// Datei (0600) und wird beim [close] gelöscht.
class MaiSnapshot {
  MaiSnapshot._(this.db, this._tempDir, this.createdAt);

  final Database db;
  final Directory? _tempDir;
  final DateTime? createdAt;

  static Future<MaiSnapshot> openBackup(String path, String passphrase) async {
    final contents = await BackupArchive.open(
      await File(path).readAsBytes(),
      passphrase,
    );
    final dir = await Directory.systemTemp.createTemp('mai_mcp_');
    if (!Platform.isWindows) {
      await Process.run('chmod', ['700', dir.path]);
    }
    final dbPath = '${dir.path}/snapshot.sqlite';
    await File(dbPath).writeAsBytes(contents.database, flush: true);
    try {
      return MaiSnapshot._(_open(dbPath), dir, contents.createdAt);
    } catch (_) {
      await dir.delete(recursive: true);
      rethrow;
    }
  }

  /// Unverschlüsselte SQLite-Datei (z. B. für Entwicklung/Tests).
  static MaiSnapshot openSqlite(String path) =>
      MaiSnapshot._(_open(path), null, null);

  static Database _open(String path) {
    final db = sqlite3.open(path, mode: OpenMode.readOnly);
    final version = db.userVersion;
    if (version < 1 || version > supportedSchemaVersion) {
      db.close();
      throw StateError(
        'Schema-Version $version wird nicht unterstützt '
        '(erwartet 1–$supportedSchemaVersion). mai_mcp aktualisieren?',
      );
    }
    return db;
  }

  Future<void> close() async {
    db.close();
    await _tempDir?.delete(recursive: true);
  }
}
