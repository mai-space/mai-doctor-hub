import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/repositories/records_repository.dart';
import 'package:mai_doctor_hub/services/app_lock.dart';
import 'package:mai_doctor_hub/services/temp_files.dart';

import 'app_lock_test.dart' show FakeAuthenticator;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('turning the app lock off needs authentication', () async {
    final auth = FakeAuthenticator()..succeed = false;
    final lock = AppLockController(authenticator: auth, enabled: true);
    expect(await lock.disableWithConfirmation(), isFalse);
    expect(lock.enabled, isTrue);

    auth.succeed = true;
    expect(await lock.disableWithConfirmation(), isTrue);
    expect(lock.enabled, isFalse);
    expect(auth.calls, 2);
  });

  test('search treats FTS syntax in user input as plain words', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final records = RecordsRepository(db);
    await records.createNote(body: 'Impfung gegen Covid-19 im März');
    for (final query in [
      'Covid-19',
      'OR',
      'a:b',
      'NOT "x',
      '*',
      '(Impfung',
      'covid-19*',
    ]) {
      await expectLater(records.search(query), completes, reason: query);
    }
    expect(await records.search('Covid-19'), hasLength(1));
    expect(await records.search('covid-19*'), hasLength(1));
  });

  test('temp purge removes plaintext copies, keeps the rest', () async {
    final cache = await Directory.systemTemp.createTemp('cache_');
    addTearDown(() => cache.delete(recursive: true));
    final doomed = [
      'file_picker/123/befund.pdf',
      'share_plus/summary.pdf',
      'scans/photo1.jpg',
      'scan123.pdf',
      'ocr_abc/page.png',
      'dokumente_1.zip',
      'export_1.maibackup',
      'import_1.maibackup',
    ];
    for (final path in [...doomed, 'flutter_engine/keep.txt', 'keep.txt']) {
      await File('${cache.path}/$path').create(recursive: true);
    }
    final removed = await TempFiles.purge(cache: cache);
    expect(removed, 8);
    final left = cache
        .listSync(recursive: true)
        .whereType<File>()
        .map((f) => f.path.substring(cache.path.length + 1))
        .toSet();
    expect(left, {'flutter_engine/keep.txt', 'keep.txt'});
  });
}
