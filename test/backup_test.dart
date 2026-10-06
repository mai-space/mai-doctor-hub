import 'dart:io';

import 'package:mai_backup_format/mai_backup_format.dart';
import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/services/file_vault.dart';
import 'package:mai_doctor_hub/data/connection/connection_io.dart';
import 'package:mai_doctor_hub/data/repositories/appointment_repository.dart';
import 'package:mai_doctor_hub/data/repositories/doctor_repository.dart';
import 'package:mai_doctor_hub/data/repositories/records_repository.dart';
import 'package:mai_doctor_hub/services/backup_service_io.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

const _pass = 'korrekt-pferd-batterie';

void main() {
  late Directory root;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('backup_test');
  });
  tearDown(() => root.delete(recursive: true));

  /// Ein „Gerät“: eigene DB + eigener Dokumentenordner.
  Future<(AppDatabase, BackupService, Directory)> device(String name) async {
    final docs = await Directory('${root.path}/$name/docs')
        .create(recursive: true);
    final tmp = await Directory('${root.path}/$name/tmp')
        .create(recursive: true);
    // Jedes Gerät mit eigener, verschlüsselter Datenbank.
    final key = (name.codeUnitAt(0).toRadixString(16).padLeft(2, '0')) * 32;
    final db = AppDatabase(
      NativeDatabase(
        File('${root.path}/$name/db.sqlite'),
        setup: (raw) => applyKey(raw, key),
      ),
    );
    addTearDown(db.close);
    return (
      db,
      BackupService(
        db,
        baseDir: () async => docs,
        tempDir: () async => tmp,
        iterations: 1000,
      ),
      docs,
    );
  }

  test('crypto round-trip; wrong password and tampering fail', () async {
    final plain = Uint8List.fromList(List.generate(5000, (i) => i % 251));
    final sealed = await BackupCrypto.encrypt(plain, _pass, iterations: 1000);
    expect(BackupCrypto.looksLikeBackup(sealed), isTrue);
    expect(await BackupCrypto.decrypt(sealed, _pass), plain);

    expect(
      () => BackupCrypto.decrypt(sealed, 'falsches-passwort'),
      throwsA(
        isA<BackupException>().having(
          (e) => e.message,
          'message',
          contains('Falsches Passwort'),
        ),
      ),
    );

    final tampered = Uint8List.fromList(sealed);
    tampered[tampered.length - 40] ^= 0xFF;
    expect(
      () => BackupCrypto.decrypt(tampered, _pass),
      throwsA(isA<BackupException>()),
    );
    expect(
      () => BackupCrypto.encrypt(plain, 'kurz'),
      throwsA(isA<BackupException>()),
    );
    expect(
      () => BackupCrypto.decrypt(Uint8List.fromList([1, 2, 3]), _pass),
      throwsA(isA<BackupException>()),
    );
  });

  test('encrypted report files move between devices with their keys', () async {
    final vaultA = await AesFileVault.fromDatabaseKey('a1' * 32);
    final vaultB = await AesFileVault.fromDatabaseKey('b2' * 32);
    addTearDown(() => FileVault.current = const PlainFileVault());

    final (dbA, backupA, docsA) = await device('a');
    final pdf = '${docsA.path}/reports/brief.pdf';
    Directory('${docsA.path}/reports').createSync(recursive: true);
    await vaultA.writeBytes(pdf, Uint8List.fromList('%PDF-Brief'.codeUnits));
    await RecordsRepository(dbA).createReport(
      title: 'Arztbrief',
      mimeType: 'application/pdf',
      localPath: pdf,
      source: ReportSource.pdf,
    );
    FileVault.current = vaultA;
    final sealed = await backupA.createBackupFile(_pass);

    // In der Sicherung liegt die Datei lesbar (geschützt durch das Passwort).
    final peek = await Directory('${root.path}/peek2').create();
    final opened = await BackupStream.open(sealed.path, _pass, peek.path);
    expect(
      File(opened.files.values.single).readAsStringSync(),
      '%PDF-Brief',
    );

    final (dbB, backupB, _) = await device('b');
    FileVault.current = vaultB;
    await backupB.restoreFile(sealed.path, _pass);
    final report = (await dbB.select(dbB.reports).get()).single;
    expect(await isVaultFile(report.localPath), isTrue);
    expect(await vaultB.readBytes(report.localPath), '%PDF-Brief'.codeUnits);
    await expectLater(vaultA.readBytes(report.localPath), throwsA(anything));
  });

  test('backup on device A restores everything on device B', () async {
    final (dbA, backupA, docsA) = await device('a');
    final doctorId = await DoctorRepository(dbA).create(name: 'Dr. Nord');
    final appointmentId = await AppointmentRepository(dbA).create(
      doctorId: doctorId,
      scheduledAt: DateTime(2030, 3, 1, 9),
      title: 'Kontrolle',
    );
    final pdf = File('${docsA.path}/reports/brief.pdf')
      ..createSync(recursive: true)
      ..writeAsStringSync('%PDF-Brief');
    await RecordsRepository(dbA).createReport(
      title: 'Arztbrief',
      mimeType: 'application/pdf',
      localPath: pdf.path,
      source: ReportSource.pdf,
      appointmentId: appointmentId,
      extractedText: 'Schilddrüse unauffällig',
    );
    await dbA
        .update(dbA.appSettings)
        .write(
          const AppSettingsCompanion(
            morningHour: Value(6),
            calendarSyncEnabled: Value(true),
            calendarId: Value('device-a-calendar'),
          ),
        );
    await dbA
        .into(dbA.calendarLinks)
        .insert(
          CalendarLinksCompanion.insert(
            appointmentId: appointmentId,
            calendarId: 'device-a-calendar',
          ),
        );

    final sealed = await backupA.createBackupFile(_pass);
    expect(await BackupStream.versionOf(sealed.path), 2);
    // In der Sicherung liegt die DB ohne Geräteschlüssel (nur das
    // Sicherungspasswort schützt sie) — lesbar auf jedem Gerät und für mai_mcp.
    final peek = await Directory('${root.path}/peek').create();
    final opened = await BackupStream.open(sealed.path, _pass, peek.path);
    final snapshot = sqlite.sqlite3.open(opened.databasePath);
    expect(snapshot.select('SELECT title FROM appointments').single['title'],
        'Kontrolle');
    snapshot.close();
    expect(File('${root.path}/a/db.sqlite').readAsBytesSync().take(6),
        isNot('SQLite'.codeUnits));

    final (dbB, backupB, docsB) = await device('b');
    // Vorhandene Daten auf B werden ersetzt.
    await RecordsRepository(dbB).createNote(body: 'wird ersetzt');
    final stale = File('${docsB.path}/reports/alt.pdf')
      ..createSync(recursive: true)
      ..writeAsStringSync('alt');

    final result = await backupB.restoreFile(sealed.path, _pass);
    expect(result.reportCount, 1);
    expect(result.missingFiles, 0);

    final records = RecordsRepository(dbB);
    expect(await dbB.select(dbB.notes).get(), isEmpty);
    expect(
      (await AppointmentRepository(dbB).getById(appointmentId))!.title,
      'Kontrolle',
    );
    final report = (await records.reportsForAppointment(appointmentId)).single;
    expect(report.localPath, startsWith(docsB.path));
    expect(File(report.localPath).readAsStringSync(), '%PDF-Brief');
    expect(stale.existsSync(), isFalse);

    expect(await records.search('Schilddrüse'), isNotEmpty);
    expect(await records.search('ersetzt'), isEmpty);

    final settings = await dbB.select(dbB.appSettings).getSingle();
    expect(settings.morningHour, 6);
    expect(settings.calendarSyncEnabled, isFalse);
    expect(settings.calendarId, isNull);
    expect(await dbB.select(dbB.calendarLinks).get(), isEmpty);
  });

  test('restore drops report paths outside the reports folder', () async {
    final (dbA, backupA, _) = await device('a');
    final (dbB, backupB, docsB) = await device('b');
    // Präparierte Sicherung: Bericht zeigt auf den Schlüssel von Gerät B.
    final secret = File('${root.path}/b/no_backup/db.key')
      ..createSync(recursive: true)
      ..writeAsStringSync('geheim');
    final id = await RecordsRepository(dbA).createReport(
      title: 'Fremd',
      mimeType: 'application/pdf',
      localPath: secret.path,
      source: ReportSource.pdf,
    );

    final sealed = await backupA.createBackupFile(_pass);
    // Datei außerhalb des Berichtsordners wird nicht mitgesichert.
    final peek = await Directory('${root.path}/peek').create();
    final opened = await BackupStream.open(sealed.path, _pass, peek.path);
    expect(opened.reportEntries, isEmpty);

    final result = await backupB.restoreFile(sealed.path, _pass);
    expect(result.missingFiles, 1);
    final records = RecordsRepository(dbB, baseDir: () async => docsB);
    expect((await records.getReport(id))!.localPath, isEmpty);
    await records.deleteReport(id);
    expect(secret.readAsStringSync(), 'geheim');
  });

  test('restores a v1 backup through migration', () async {
    final (dbB, backupB, _) = await device('b');

    // v1-Datenbank wie aus I1.
    final v1Path = '${root.path}/v1.sqlite';
    final raw = sqlite.sqlite3.open(v1Path);
    final sql = File('test/migrations/v1.sql').readAsStringSync();
    for (final statement in sql.split('---')) {
      if (statement.trim().isNotEmpty) raw.execute(statement);
    }
    raw
      ..execute('INSERT INTO app_settings (id) VALUES (1)')
      ..execute(
        "INSERT INTO diagnoses VALUES ('x', 'Asthma', NULL, NULL, NULL, 0, 0, 0)",
      )
      ..execute(
        "INSERT INTO records_fts VALUES ('diagnosis', 'x', 'Asthma', '')",
      )
      ..execute('PRAGMA user_version = 1')
      ..close();

    final sealed = File('${root.path}/v1.maibackup');
    await sealed.writeAsBytes(
      await BackupCrypto.encrypt(
        BackupArchive.build(
          database: File(v1Path).readAsBytesSync(),
          manifest: const {
            'format': 1,
            'schemaVersion': 1,
            'createdAt': '2026-01-01T00:00:00Z',
            'reports': <String, String>{},
          },
        ),
        _pass,
        iterations: 1000,
      ),
    );

    await backupB.restoreFile(sealed.path, _pass);
    final records = RecordsRepository(dbB);
    expect((await records.getDiagnosis('x'))!.title, 'Asthma');
    expect(await records.search('Asthma'), isNotEmpty);
    final settings = await dbB.select(dbB.appSettings).getSingle();
    expect(settings.appLockEnabled, isFalse);
  });

  test('rejects backups from a newer schema', () async {
    final (dbA, backupA, _) = await device('a');
    final (_, backupB, _) = await device('b');
    await dbA.customStatement('PRAGMA user_version = 99');
    final sealed = await backupA.createBackupFile(_pass);
    expect(
      () => backupB.restoreFile(sealed.path, _pass),
      throwsA(
        isA<BackupException>().having(
          (e) => e.message,
          'message',
          contains('neueren App-Version'),
        ),
      ),
    );
  });
}
