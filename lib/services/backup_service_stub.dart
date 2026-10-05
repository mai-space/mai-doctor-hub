import 'dart:io' show Directory, File;

import 'package:mai_backup_format/mai_backup_format.dart';

import '../data/app_database.dart';

export 'package:mai_backup_format/mai_backup_format.dart'
    show BackupException, BackupCrypto, BackupStream;

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

  Future<File> createBackupFile(String passphrase) =>
      throw const BackupException('Sicherung ist im Web nicht verfügbar.');

  Future<RestoreResult> restoreFile(String path, String passphrase) =>
      throw const BackupException('Sicherung ist im Web nicht verfügbar.');
}
