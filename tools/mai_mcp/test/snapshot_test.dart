import 'dart:io';

import 'package:mai_backup_format/mai_backup_format.dart';
import 'package:mai_mcp/mai_mcp.dart';
import 'package:test/test.dart';

import 'fixture.dart';

void main() {
  late Directory dir;

  setUp(() => dir = Directory.systemTemp.createTempSync('mai_snapshot'));
  tearDown(() => dir.deleteSync(recursive: true));

  test('opens encrypted backup; temp copy removed on close', () async {
    final backup = File('${dir.path}/akte.maibackup')
      ..writeAsBytesSync(
        await buildFixtureBackup(buildFixtureDb(dir), 'geheim-genug'),
      );
    final before = Directory.systemTemp
        .listSync()
        .where((e) => e.path.contains('mai_mcp_'))
        .length;
    final snapshot = await MaiSnapshot.openBackup(backup.path, 'geheim-genug');
    expect(snapshot.createdAt, DateTime.utc(2026, 10, 5));
    expect(MaiRecords(snapshot.db).listAppointments(), hasLength(2));
    await snapshot.close();
    final after = Directory.systemTemp
        .listSync()
        .where((e) => e.path.contains('mai_mcp_'))
        .length;
    expect(after, before);
  });

  test('opens streamed (v2) backups as written by the app', () async {
    final db = buildFixtureDb(dir);
    final pdf = File('${dir.path}/r.pdf')..writeAsStringSync('%PDF');
    final zip = '${dir.path}/backup.zip';
    await BackupStream.writeZip(
      zip,
      databasePath: db,
      manifest: {
        'format': 2,
        'createdAt': DateTime.utc(2026, 10, 6).toIso8601String(),
        'reports': {'r1': 'reports/r1.pdf'},
      },
      files: {'reports/r1.pdf': pdf.path},
    );
    final sealed = '${dir.path}/akte.maibackup';
    await BackupStream.encryptFile(
      zip,
      sealed,
      'geheim-genug',
      iterations: 1000,
      chunkSize: 4096,
    );
    final snapshot = await MaiSnapshot.openBackup(sealed, 'geheim-genug');
    addTearDown(snapshot.close);
    expect(snapshot.createdAt, DateTime.utc(2026, 10, 6));
    expect(MaiRecords(snapshot.db).listAppointments(), hasLength(2));
  });

  test('wrong passphrase is rejected', () async {
    final backup = File('${dir.path}/akte.maibackup')
      ..writeAsBytesSync(
        await buildFixtureBackup(buildFixtureDb(dir), 'geheim-genug'),
      );
    expect(
      () => MaiSnapshot.openBackup(backup.path, 'falsch-falsch'),
      throwsA(isA<BackupException>()),
    );
  });

  test('snapshot is read-only', () async {
    final snapshot = MaiSnapshot.openSqlite(buildFixtureDb(dir));
    addTearDown(snapshot.close);
    expect(() => snapshot.db.execute("DELETE FROM notes"), throwsA(anything));
  });

  test('unknown schema versions are rejected', () {
    expect(
      () => MaiSnapshot.openSqlite(buildFixtureDb(dir, userVersion: 99)),
      throwsStateError,
    );
  });
}
