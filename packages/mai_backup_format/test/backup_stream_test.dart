import 'dart:io';
import 'dart:typed_data';

import 'package:mai_backup_format/mai_backup_format.dart';
import 'package:test/test.dart';

const _pass = 'korrekt-pferd-batterie';

void main() {
  late Directory dir;
  setUp(() async => dir = await Directory.systemTemp.createTemp('stream'));
  tearDown(() => dir.delete(recursive: true));

  String path(String name) => '${dir.path}/$name';

  Future<Uint8List> plainFile(String name, int size) async {
    final bytes = Uint8List.fromList(List.generate(size, (i) => i * 7 % 253));
    await File(path(name)).writeAsBytes(bytes);
    return bytes;
  }

  Future<void> expectFails(String file, String message) => expectLater(
    BackupStream.decryptFile(file, path('out'), _pass),
    throwsA(
      isA<BackupException>().having(
        (e) => e.message,
        'message',
        contains(message),
      ),
    ),
  );

  test('v2 round-trip over many chunks', () async {
    final plain = await plainFile('plain', 10000);
    await BackupStream.encryptFile(
      path('plain'),
      path('sealed'),
      _pass,
      iterations: 1000,
      chunkSize: 1000,
    );
    expect(await BackupStream.versionOf(path('sealed')), 2);
    await BackupStream.decryptFile(path('sealed'), path('out'), _pass);
    expect(await File(path('out')).readAsBytes(), plain);
  });

  test('empty file round-trips', () async {
    await plainFile('plain', 0);
    await BackupStream.encryptFile(
      path('plain'),
      path('sealed'),
      _pass,
      iterations: 1000,
    );
    await BackupStream.decryptFile(path('sealed'), path('out'), _pass);
    expect(await File(path('out')).readAsBytes(), isEmpty);
  });

  group('rejects', () {
    late Uint8List sealed;
    setUp(() async {
      await plainFile('plain', 3000);
      await BackupStream.encryptFile(
        path('plain'),
        path('sealed'),
        _pass,
        iterations: 1000,
        chunkSize: 1000,
      );
      sealed = await File(path('sealed')).readAsBytes();
    });

    test('wrong password', () async {
      await expectLater(
        BackupStream.decryptFile(path('sealed'), path('out'), 'falsch-falsch'),
        throwsA(
          isA<BackupException>().having(
            (e) => e.message,
            'message',
            contains('Falsches Passwort'),
          ),
        ),
      );
    });

    test('tampered bytes', () async {
      final copy = Uint8List.fromList(sealed);
      copy[copy.length - 30] ^= 1;
      await File(path('bad')).writeAsBytes(copy);
      await expectFails(path('bad'), 'beschädigt');
    });

    test('truncated after a whole chunk', () async {
      // Letzten Chunk (4 + 1000 + 16 Byte) komplett abschneiden.
      await File(
        path('bad'),
      ).writeAsBytes(sealed.sublist(0, sealed.length - 1020));
      await expectFails(path('bad'), 'beschädigt');
    });

    test('truncated mid-chunk', () async {
      await File(
        path('bad'),
      ).writeAsBytes(sealed.sublist(0, sealed.length - 5));
      await expectFails(path('bad'), 'unvollständig');
    });

    test('swapped chunks', () async {
      const chunk = 4 + 1000 + 16;
      final start = sealed.length - 3 * chunk;
      final copy = Uint8List.fromList(sealed);
      copy.setRange(start, start + chunk, sealed, start + chunk);
      copy.setRange(start + chunk, start + 2 * chunk, sealed, start);
      await File(path('bad')).writeAsBytes(copy);
      await expectFails(path('bad'), 'beschädigt');
    });

    test('foreign files', () async {
      await File(path('bad')).writeAsString('hallo welt');
      expect(await BackupStream.versionOf(path('bad')), 0);
      await expectFails(path('bad'), 'Keine');
    });
  });

  test('still reads v1 backups', () async {
    final zip = BackupArchive.build(
      database: Uint8List.fromList([1, 2, 3]),
      manifest: {'schemaVersion': 1, 'reports': <String, String>{}},
    );
    await File(
      path('v1'),
    ).writeAsBytes(await BackupCrypto.encrypt(zip, _pass, iterations: 1000));
    expect(await BackupStream.versionOf(path('v1')), 1);
    final work = await Directory(path('work')).create();
    final opened = await BackupStream.open(path('v1'), _pass, work.path);
    expect(await File(opened.databasePath).readAsBytes(), [1, 2, 3]);
  });

  test('zip with files; databaseOnly skips them', () async {
    await File(path('db')).writeAsBytes([4, 5, 6]);
    await File(path('r1.pdf')).writeAsString('%PDF');
    await BackupStream.writeZip(
      path('backup.zip'),
      databasePath: path('db'),
      manifest: {
        'schemaVersion': 9,
        'createdAt': '2026-10-05T10:00:00.000Z',
        'reports': {'r1': 'reports/r1.pdf'},
      },
      files: {'reports/r1.pdf': path('r1.pdf')},
    );
    await BackupStream.encryptFile(
      path('backup.zip'),
      path('sealed'),
      _pass,
      iterations: 1000,
    );

    final work = await Directory(path('work')).create();
    final full = await BackupStream.open(path('sealed'), _pass, work.path);
    expect(full.schemaVersion, 9);
    expect(full.createdAt, DateTime.utc(2026, 10, 5, 10));
    expect(full.reportEntries, {'r1': 'reports/r1.pdf'});
    expect(await File(full.files['reports/r1.pdf']!).readAsString(), '%PDF');
    expect(File('${work.path}/backup.zip').existsSync(), isFalse);

    final small = await Directory(path('small')).create();
    final dbOnly = await BackupStream.open(
      path('sealed'),
      _pass,
      small.path,
      databaseOnly: true,
    );
    expect(dbOnly.files, isEmpty);
    expect(await File(dbOnly.databasePath).readAsBytes(), [4, 5, 6]);
  });

  test('zip entries cannot escape the target directory', () async {
    await File(path('db')).writeAsBytes([1]);
    await File(path('evil')).writeAsString('x');
    await BackupStream.writeZip(
      path('backup.zip'),
      databasePath: path('db'),
      manifest: {'reports': <String, String>{}},
      files: {'../../evil.txt': path('evil')},
    );
    final work = await Directory(path('work')).create();
    final extracted = await BackupStream.extractZip(
      path('backup.zip'),
      work.path,
    );
    final target = extracted.files['../../evil.txt']!;
    expect(File(target).parent.path, work.path);
    expect(File('${dir.parent.path}/evil.txt').existsSync(), isFalse);
  });
}
