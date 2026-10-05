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
    expect(
      () => snapshot.db.execute("DELETE FROM notes"),
      throwsA(anything),
    );
  });

  test('unknown schema versions are rejected', () {
    expect(
      () => MaiSnapshot.openSqlite(buildFixtureDb(dir, userVersion: 99)),
      throwsStateError,
    );
  });
}
