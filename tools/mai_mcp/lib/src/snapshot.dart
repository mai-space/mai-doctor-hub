import 'dart:io';

import 'package:mai_backup_format/mai_backup_format.dart';
import 'package:sqlite3/sqlite3.dart';

/// Höchste Schema-Version der App, die dieser Server versteht.
const supportedSchemaVersion = 18;

/// Read-only-Zugriff auf einen Akten-Snapshot.
///
/// Der Snapshot stammt aus einer verschlüsselten `.maibackup`-Sicherung; die
/// entschlüsselte Datenbank liegt nur für die Laufzeit in einer temporären
/// Datei (0600) und wird beim [close] gelöscht. Bleibt sie nach einem
/// harten Abbruch liegen, räumt [deleteStale] sie beim nächsten Start weg.
class MaiSnapshot {
  MaiSnapshot._(this.db, this._tempDir, this.createdAt, [this._lock]);

  final Database db;
  final Directory? _tempDir;
  final DateTime? createdAt;

  /// Sperre auf [_lockName], solange der Snapshot offen ist — daran erkennt
  /// [deleteStale] Ordner noch laufender Server.
  final RandomAccessFile? _lock;
  bool _closed = false;

  static const _prefix = 'mai_mcp_';
  static const _lockName = '.lock';

  /// Dateien, die ein Snapshot-Ordner enthalten kann (auch ältere Versionen
  /// und abgebrochene Entschlüsselungen).
  static const _snapshotFiles = {
    _lockName,
    'backup.zip',
    '.manifest.json',
    'database.sqlite',
    'db.sqlite',
  };

  static Future<MaiSnapshot> openBackup(String path, String passphrase) async {
    final dir = await Directory.systemTemp.createTemp(_prefix);
    if (!Platform.isWindows) {
      await Process.run('chmod', ['700', dir.path]);
    }
    RandomAccessFile? lock;
    try {
      lock = await File('${dir.path}/$_lockName').open(mode: FileMode.append);
      await lock.lock(FileLock.exclusive);
      // Gestreamt entschlüsseln; Berichtsdateien werden nicht gebraucht.
      final contents = await BackupStream.open(
        path,
        passphrase,
        dir.path,
        databaseOnly: true,
      );
      return MaiSnapshot._(
        _open(contents.databasePath),
        dir,
        contents.createdAt,
        lock,
      );
    } catch (_) {
      await lock?.close();
      await dir.delete(recursive: true);
      rethrow;
    }
  }

  /// Löscht liegengebliebene Snapshot-Ordner abgebrochener Läufe in
  /// [tempDir] (Standard: System-Temp) und gibt ihre Anzahl zurück.
  ///
  /// Konservativ: nur `mai_mcp_*`-Ordner (unter POSIX mit Rechten 0700, wie
  /// [openBackup] sie anlegt), die ausschließlich bekannte Snapshot-Dateien
  /// enthalten und deren Sperre kein Prozess mehr hält. Ordner älterer
  /// Versionen ohne Sperrdatei erst nach einem Tag.
  static Future<int> deleteStale({Directory? tempDir}) async {
    var removed = 0;
    final candidates = [
      await for (final e in (tempDir ?? Directory.systemTemp).list(
        followLinks: false,
      ))
        if (e is Directory && _basename(e.path).startsWith(_prefix)) e,
    ];
    for (final dir in candidates) {
      try {
        if (await _isStale(dir)) {
          await dir.delete(recursive: true);
          removed++;
        }
      } on FileSystemException {
        // Fremder oder gerade verschwundener Ordner — nicht unser Problem.
      }
    }
    return removed;
  }

  static Future<bool> _isStale(Directory dir) async {
    if (!Platform.isWindows && (await dir.stat()).mode & 0x1FF != 0x1C0) {
      return false; // nicht 0700
    }
    final entries = await dir.list(followLinks: false).toList();
    // Nur die Sperrdatei: Ordner wird gerade angelegt.
    if (entries.every((e) => _basename(e.path) == _lockName)) return false;
    for (final e in entries) {
      if (e is! File || !_snapshotFiles.contains(_basename(e.path))) {
        return false;
      }
    }
    final lockFile = File('${dir.path}/$_lockName');
    if (!await lockFile.exists()) {
      final cutoff = DateTime.now().subtract(const Duration(days: 1));
      for (final e in entries) {
        if ((await e.stat()).modified.isAfter(cutoff)) return false;
      }
      return true;
    }
    final lock = await lockFile.open(mode: FileMode.append);
    try {
      await lock.lock(FileLock.exclusive); // wirft, solange gesperrt
      return true;
    } on FileSystemException {
      return false;
    } finally {
      await lock.close();
    }
  }

  static String _basename(String path) =>
      path.split(Platform.pathSeparator).last;

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
    _hideArchived(db);
    return db;
  }

  /// Tabellen mit Archiv (Soft Delete, App-Schema ≥ 9).
  static const archivableTables = [
    'doctors',
    'diagnoses',
    'symptoms',
    'appointments',
    'reports',
    'medications',
    'notes',
    'pharmacies',
    'vaccinations',
  ];

  /// Archivierte Einträge sind „gelöscht“: TEMP-Views gleichen Namens
  /// verdecken die Tabellen (SQLite sucht unqualifizierte Namen zuerst im
  /// temp-Schema) — so filtern alle Abfragen automatisch.
  static void _hideArchived(Database db) {
    for (final table in archivableTables) {
      final columns = db.select('PRAGMA main.table_info("$table")');
      if (!columns.any((c) => c['name'] == 'archived_at')) continue;
      db.execute(
        'CREATE TEMP VIEW "$table" AS '
        'SELECT * FROM main."$table" WHERE archived_at IS NULL',
      );
    }
  }

  /// Mehrfacher Aufruf (Signal + regulär) ist unschädlich.
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    db.close();
    await _lock?.close();
    await _tempDir?.delete(recursive: true);
  }
}
