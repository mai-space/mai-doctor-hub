import 'dart:io' show Directory;
import 'dart:typed_data';

import 'package:mai_backup_format/mai_backup_format.dart';

import '../data/app_database.dart';

export 'package:mai_backup_format/mai_backup_format.dart'
    show BackupException, BackupCrypto;

/// Web: keine Sicherung (Dateien liegen dort nicht dauerhaft vor).
const backupSupported = false;

class RestoreResult {
  const RestoreResult({
    required this.createdAt,
    required this.reportCount,
    required this.missingFiles,
  });

  final DateTime createdAt;
  final int reportCount;
  final int missingFiles;
}

class BackupService {
  BackupService(
    AppDatabase db, {
    Future<Directory> Function()? baseDir,
    Future<Directory> Function()? tempDir,
    int iterations = BackupCrypto.defaultIterations,
  });

  static String suggestedFileName(DateTime now) => 'mai-doctor-hub.maibackup';

  Future<Uint8List> createBackup(String passphrase) =>
      throw const BackupException('Sicherung ist im Web nicht verfügbar.');

  Future<RestoreResult> restore(Uint8List data, String passphrase) =>
      throw const BackupException('Sicherung ist im Web nicht verfügbar.');
}
