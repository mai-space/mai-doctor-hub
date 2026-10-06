import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/connection/connection_io.dart';
import 'package:mai_doctor_hub/data/connection/database_key.dart';
import 'package:mai_doctor_hub/data/repositories/records_repository.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite;

const _keyA =
    '00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff';
const _keyB =
    'ffeeddccbbaa99887766554433221100ffeeddccbbaa99887766554433221100';

class FakeKeys implements DatabaseKeyStore {
  FakeKeys(this.key, {this.lost = false, this.unavailable = 0});

  String key;
  bool lost;

  /// So viele Aufrufe scheitern vorübergehend, bevor es klappt.
  int unavailable;
  int resets = 0;
  int calls = 0;

  @override
  Future<String?> getOrCreate() async {
    calls++;
    if (unavailable > 0) {
      unavailable--;
      throw const DatabaseKeyUnavailable('Keystore belegt');
    }
    if (lost) throw const DatabaseKeyLost('weg');
    return key;
  }

  @override
  Future<void> reset() async {
    resets++;
    lost = false;
    key = _keyB;
  }
}

AppDatabase openEncrypted(String path, String key) =>
    AppDatabase(NativeDatabase(File(path), setup: (db) => applyKey(db, key)));

bool isPlaintext(String path) =>
    String.fromCharCodes(File(path).readAsBytesSync().take(15)) ==
    'SQLite format 3';

void main() {
  late Directory dir;
  late String path;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('db_crypt');
    path = '${dir.path}/mai_doctor_hub.sqlite';
  });
  tearDown(() => dir.deleteSync(recursive: true));

  test('new database is encrypted and unreadable without the key', () async {
    final (key, status) = await prepareDatabase(path, FakeKeys(_keyA));
    expect(key, _keyA);
    expect(status.encrypted, isTrue);
    expect(status.unreadableCopy, isNull);

    final db = openEncrypted(path, key!);
    await RecordsRepository(db).createNote(body: 'Geheime Notiz');
    await db.close();

    expect(isPlaintext(path), isFalse);
    expect(
      File(path).readAsStringSync(encoding: latin1),
      isNot(contains('Geheime')),
    );
    final raw = sqlite.sqlite3.open(path);
    expect(() => raw.select('SELECT * FROM notes'), throwsA(anything));
    raw.close();

    final again = openEncrypted(path, _keyA);
    expect(
      (await again.select(again.notes).get()).single.body,
      'Geheime Notiz',
    );
    await again.close();
  });

  test('existing plaintext database is encrypted in place', () async {
    final plain = AppDatabase(NativeDatabase(File(path)));
    await RecordsRepository(plain).createNote(body: 'aus Version 1');
    await plain.close();
    expect(isPlaintext(path), isTrue);

    final (key, status) = await prepareDatabase(path, FakeKeys(_keyA));
    expect(status.unreadableCopy, isNull);
    expect(isPlaintext(path), isFalse);

    final db = openEncrypted(path, key!);
    expect((await db.select(db.notes).get()).single.body, 'aus Version 1');
    expect(await RecordsRepository(db).search('Version'), isNotEmpty);
    await db.close();
  });

  test('database with a foreign key is moved aside', () async {
    final other = openEncrypted(path, _keyB);
    await RecordsRepository(other).createNote(body: 'fremd');
    await other.close();

    final (key, status) = await prepareDatabase(path, FakeKeys(_keyA));
    expect(key, _keyA);
    expect(File(path).existsSync(), isFalse);
    expect(File(status.unreadableCopy!).existsSync(), isTrue);

    final fresh = openEncrypted(path, key!);
    expect(await fresh.select(fresh.notes).get(), isEmpty);
    await fresh.close();
  });

  test('lost keystore key: data moved aside, new key issued', () async {
    final old = openEncrypted(path, _keyA);
    await RecordsRepository(old).createNote(body: 'alt');
    await old.close();

    final keys = FakeKeys(_keyA, lost: true);
    final (key, status) = await prepareDatabase(path, keys);
    expect(keys.resets, 1);
    expect(key, _keyB);
    expect(status.unreadableCopy, isNotNull);
    expect(File(path).existsSync(), isFalse);
  });

  group('transient key errors', () {
    const noDelay = [Duration.zero, Duration.zero, Duration.zero];

    Future<List<int>> seed() async {
      final old = openEncrypted(path, _keyA);
      await RecordsRepository(old).createNote(body: 'bleibt');
      await old.close();
      return File(path).readAsBytesSync();
    }

    test('retry succeeds: nothing moved aside, no reset', () async {
      final before = await seed();
      final keys = FakeKeys(_keyA, unavailable: 2);

      final (key, status) = await prepareDatabase(
        path,
        keys,
        retryDelays: noDelay,
      );
      expect(keys.calls, 3);
      expect(keys.resets, 0);
      expect(key, _keyA);
      expect(status.unreadableCopy, isNull);
      expect(File(path).readAsBytesSync(), before);

      final db = openEncrypted(path, key!);
      expect((await db.select(db.notes).get()).single.body, 'bleibt');
      await db.close();
    });

    test('persistent error: throws, database untouched', () async {
      final before = await seed();
      final keys = FakeKeys(_keyA, unavailable: 99);

      await expectLater(
        prepareDatabase(path, keys, retryDelays: noDelay),
        throwsA(isA<DatabaseKeyUnavailable>()),
      );
      expect(keys.calls, noDelay.length + 1);
      expect(keys.resets, 0);
      expect(File(path).readAsBytesSync(), before);
      expect(dir.listSync().where((f) => f.path.contains('unlesbar')), isEmpty);
    });

    test('KEY_LOST after a transient error still moves aside', () async {
      await seed();
      final keys = FakeKeys(_keyA, lost: true, unavailable: 1);

      final (key, status) = await prepareDatabase(
        path,
        keys,
        retryDelays: noDelay,
      );
      expect(keys.resets, 1);
      expect(key, _keyB);
      expect(File(status.unreadableCopy!).existsSync(), isTrue);
      expect(File(path).existsSync(), isFalse);
    });
  });
}
