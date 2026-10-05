import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

import 'package:mai_backup_format/mai_backup_format.dart';

import '../data/app_database.dart';

export 'package:mai_backup_format/mai_backup_format.dart'
    show BackupException, BackupCrypto, BackupStream;

const backupSupported = true;

class RestoreResult {
  const RestoreResult({
    required this.createdAt,
    required this.reportCount,
    required this.missingFiles,
  });

  final DateTime createdAt;
  final int reportCount;

  /// Berichte, deren Datei nicht in der Sicherung war (z. B. Web-Einträge).
  final int missingFiles;
}

/// Verschlüsselte Komplettsicherung: Datenbank + Berichtsdateien.
class BackupService {
  BackupService(
    this._db, {
    Future<Directory> Function()? baseDir,
    Future<Directory> Function()? tempDir,
    this.iterations = BackupCrypto.defaultIterations,
  }) : _baseDir = baseDir ?? getApplicationDocumentsDirectory,
       _tempDir = tempDir ?? getTemporaryDirectory;

  final AppDatabase _db;
  final Future<Directory> Function() _baseDir;
  final Future<Directory> Function() _tempDir;

  /// PBKDF2-Runden; in Tests reduziert.
  final int iterations;

  static String suggestedFileName(DateTime now) =>
      'mai-doctor-hub-${now.year}-${_two(now.month)}-${_two(now.day)}'
      '.maibackup';

  /// Schreibt die verschlüsselte Sicherung Datei für Datei in den
  /// Temp-Ordner — auch mit vielen PDFs nie komplett im Speicher.
  /// Aufrufer teilt/kopiert die Datei und löscht sie danach.
  Future<File> createBackupFile(String passphrase) async {
    final work = await _workDir();
    try {
      final snapshot = p.join(work.path, 'db.sqlite');
      // Konsistente Kopie, auch während die App die DB offen hat.
      await _db.customStatement('VACUUM INTO ?', [snapshot]);

      final reports = await _db.select(_db.reports).get();
      final files = <String, String>{};
      final entries = <String, String>{};
      for (final report in reports) {
        if (report.localPath.startsWith('web-memory://') ||
            !await File(report.localPath).exists()) {
          continue;
        }
        final entry = 'reports/${report.id}${p.extension(report.localPath)}';
        files[entry] = report.localPath;
        entries[report.id] = entry;
      }
      final zip = p.join(work.path, 'backup.zip');
      await BackupStream.writeZip(
        zip,
        databasePath: snapshot,
        files: files,
        manifest: {
          'format': 2,
          'schemaVersion': _db.schemaVersion,
          'createdAt': DateTime.now().toUtc().toIso8601String(),
          'reports': entries,
        },
      );
      final out = File(
        p.join(
          (await _tempDir()).path,
          'export_${DateTime.now().microsecondsSinceEpoch}.maibackup',
        ),
      );
      await BackupStream.encryptFile(
        zip,
        out.path,
        passphrase,
        iterations: iterations,
      );
      return out;
    } finally {
      await work.delete(recursive: true);
    }
  }

  /// Ersetzt **alle** Daten durch den Inhalt der Sicherung unter [path]
  /// (Format v1 oder v2).
  ///
  /// Gerätespezifisches (Kalender-Verknüpfungen, gewählter Kalender) wird
  /// zurückgesetzt, weil Event-IDs auf einem anderen Gerät nicht gelten.
  Future<RestoreResult> restoreFile(String path, String passphrase) async {
    final work = await _workDir();
    try {
      final contents = await BackupStream.open(path, passphrase, work.path);
      final restorePath = contents.databasePath;
      await _migrateSnapshot(restorePath);

      final reportsDir = Directory(p.join((await _baseDir()).path, 'reports'));
      final oldFiles = await _listFiles(reportsDir);
      await reportsDir.create(recursive: true);

      // Dateien zuerst verschieben: scheitert das, bleibt die DB unverändert.
      final newPaths = <String, String>{};
      final stamp = DateTime.now().millisecondsSinceEpoch;
      for (final MapEntry(key: reportId, value: entry)
          in contents.reportEntries.entries) {
        final extracted = contents.files[entry];
        if (extracted == null) continue;
        final target = p.join(
          reportsDir.path,
          'restored_${stamp}_${p.basename(entry)}',
        );
        await _move(File(extracted), target);
        newPaths[reportId] = target;
      }

      await _replaceData(restorePath, newPaths);

      // Alte Berichtsdateien entfernen, die nicht mehr referenziert sind.
      final keep = newPaths.values.toSet();
      for (final file in oldFiles) {
        if (!keep.contains(file.path)) {
          try {
            await file.delete();
          } catch (_) {}
        }
      }

      final reportCount = await _db.select(_db.reports).get();
      return RestoreResult(
        createdAt: contents.createdAt ?? DateTime.now(),
        reportCount: reportCount.length,
        missingFiles: reportCount.length - newPaths.length,
      );
    } finally {
      await work.delete(recursive: true);
    }
  }

  /// Umbenennen; über Dateisystemgrenzen hinweg kopieren.
  static Future<void> _move(File source, String target) async {
    try {
      await source.rename(target);
    } on FileSystemException {
      await source.copy(target);
    }
  }

  /// Bringt eine ältere Sicherung auf das aktuelle Schema; lehnt neuere ab.
  Future<void> _migrateSnapshot(String path) async {
    final raw = sqlite.sqlite3.open(path);
    final int version;
    try {
      version = raw.userVersion;
    } finally {
      raw.close();
    }
    if (version > _db.schemaVersion) {
      throw const BackupException(
        'Sicherung stammt aus einer neueren App-Version — bitte App '
        'aktualisieren.',
      );
    }
    final snapshot = AppDatabase(NativeDatabase(File(path)));
    try {
      await snapshot.customSelect('SELECT 1').get(); // öffnet + migriert
    } finally {
      await snapshot.close();
    }
  }

  Future<void> _replaceData(
    String restorePath,
    Map<String, String> newPaths,
  ) async {
    final tables = _db.allTables.toList();
    await _db.customStatement('ATTACH DATABASE ? AS bk', [restorePath]);
    try {
      await _db.transaction(() async {
        for (final table in tables) {
          await _db.customStatement('DELETE FROM "${table.actualTableName}"');
        }
        for (final table in tables) {
          final columns = table.$columns.map((c) => '"${c.name}"').join(', ');
          final name = table.actualTableName;
          await _db.customStatement(
            'INSERT INTO main."$name" ($columns) SELECT $columns FROM bk."$name"',
          );
        }
        await _db.customStatement('DELETE FROM records_fts');
        await _db.customStatement(
          'INSERT INTO records_fts(entity_type, entity_id, title, body) '
          'SELECT entity_type, entity_id, title, body FROM bk.records_fts',
        );

        // Gerätespezifisches zurücksetzen.
        await _db.delete(_db.calendarLinks).go();
        await _db
            .update(_db.appSettings)
            .write(
              const AppSettingsCompanion(
                calendarSyncEnabled: Value(false),
                calendarId: Value(null),
              ),
            );
        await _db.customStatement(
          'INSERT OR IGNORE INTO app_settings (id) VALUES (1)',
        );

        // Berichtspfade auf dieses Gerät umbiegen.
        for (final MapEntry(key: id, value: path) in newPaths.entries) {
          await (_db.update(_db.reports)..where((t) => t.id.equals(id))).write(
            ReportsCompanion(localPath: Value(path)),
          );
        }
      });
    } finally {
      await _db.customStatement('DETACH DATABASE bk');
    }
    _db.markTablesUpdated(tables);
  }

  Future<Directory> _workDir() async {
    final dir = Directory(
      p.join(
        (await _tempDir()).path,
        'backup_${DateTime.now().microsecondsSinceEpoch}',
      ),
    );
    return dir.create(recursive: true);
  }

  Future<List<File>> _listFiles(Directory dir) async {
    if (!await dir.exists()) return const [];
    return [
      await for (final e in dir.list())
        if (e is File) e,
    ];
  }

  static String _two(int v) => v.toString().padLeft(2, '0');
}
