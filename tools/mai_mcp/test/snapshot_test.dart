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

  group('deleteStale', () {
    late Directory temp;
    setUp(() => temp = Directory('${dir.path}/tmp')..createSync());

    Directory snapshotDir(
      String name, {
      List<String> files = const ['.lock', 'database.sqlite'],
    }) {
      final d = Directory('${temp.path}/$name')..createSync();
      if (!Platform.isWindows) Process.runSync('chmod', ['700', d.path]);
      for (final f in files) {
        File('${d.path}/$f').writeAsStringSync('x');
      }
      return d;
    }

    test('removes abandoned snapshots, keeps everything else', () async {
      final abandoned = snapshotDir('mai_mcp_tot');
      final fresh = snapshotDir('mai_mcp_neu', files: ['.lock']);
      final foreign = snapshotDir(
        'mai_mcp_fremd',
        files: ['.lock', 'database.sqlite', 'notizen.txt'],
      );
      final other = snapshotDir('anderes');
      final legacyNew = snapshotDir('mai_mcp_altneu', files: ['db.sqlite']);
      final legacyOld = snapshotDir('mai_mcp_altalt', files: ['db.sqlite']);
      File(
        '${legacyOld.path}/db.sqlite',
      ).setLastModifiedSync(DateTime.now().subtract(const Duration(days: 2)));

      expect(await MaiSnapshot.deleteStale(tempDir: temp), 2);
      expect(abandoned.existsSync(), isFalse);
      expect(legacyOld.existsSync(), isFalse);
      for (final kept in [fresh, foreign, other, legacyNew]) {
        expect(kept.existsSync(), isTrue, reason: kept.path);
      }
    });

    test('keeps snapshots whose lock is held by a running server', () async {
      final live = snapshotDir('mai_mcp_lebt');
      // fcntl-Sperren gelten pro Prozess → Sperre in einem Kindprozess.
      final script = File('${dir.path}/hold_lock.dart')
        ..writeAsStringSync("""
import 'dart:io';
Future<void> main(List<String> args) async {
  final lock = File(args.single).openSync(mode: FileMode.append);
  lock.lockSync(FileLock.exclusive);
  print('gesperrt');
  await stdin.drain<void>();
}
""");
      final child = await Process.start(Platform.resolvedExecutable, [
        script.path,
        '${live.path}/.lock',
      ]);
      addTearDown(child.kill);
      await child.stdout.first;

      expect(await MaiSnapshot.deleteStale(tempDir: temp), 0);
      expect(live.existsSync(), isTrue);

      await child.stdin.close();
      await child.exitCode;
      expect(await MaiSnapshot.deleteStale(tempDir: temp), 1);
      expect(live.existsSync(), isFalse);
    });
  });

  test(
    'server removes its snapshot on SIGTERM',
    () async {
      final temp = Directory('${dir.path}/tmp')..createSync();
      final backup = File('${dir.path}/akte.maibackup')
        ..writeAsBytesSync(
          await buildFixtureBackup(buildFixtureDb(dir), 'geheim-genug'),
        );
      final server = await Process.start(
        Platform.resolvedExecutable,
        ['run', 'bin/mai_mcp.dart', '--backup', backup.path],
        environment: {
          'TMPDIR': temp.path,
          'MAI_BACKUP_PASSPHRASE': 'geheim-genug',
        },
      );
      addTearDown(server.kill);
      final ready = server.stderr
          .transform(const SystemEncoding().decoder)
          .firstWhere((line) => line.contains('bereit'));
      await ready;
      List<FileSystemEntity> snapshots() =>
          temp.listSync().where((e) => e.path.contains('mai_mcp_')).toList();
      expect(snapshots(), hasLength(1));

      server.kill(ProcessSignal.sigterm);
      expect(await server.exitCode, 128 + ProcessSignal.sigterm.signalNumber);
      expect(snapshots(), isEmpty);
    },
    testOn: '!windows',
    timeout: const Timeout(Duration(minutes: 2)),
  );
}
