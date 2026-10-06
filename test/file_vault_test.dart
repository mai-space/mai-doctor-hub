import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/repositories/records_repository.dart';
import 'package:mai_doctor_hub/services/file_vault.dart';
import 'package:mai_doctor_hub/services/report_import_service.dart';

import 'helpers/test_env.dart';

const _dbKey =
    '00112233445566778899aabbccddeeff00112233445566778899aabbccddeeff';

Uint8List _random(int length, [int seed = 1]) {
  final r = Random(seed);
  return Uint8List.fromList(List.generate(length, (_) => r.nextInt(256)));
}

void main() {
  late Directory dir;
  late AesFileVault vault;

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('vault');
    useFakePathProvider(dir.path);
    vault = await AesFileVault.fromDatabaseKey(_dbKey);
  });
  tearDown(() async {
    FileVault.current = const PlainFileVault();
    await dir.delete(recursive: true);
  });

  String path(String name) => '${dir.path}/$name';

  test('round trip across block boundaries; no plaintext on disk', () async {
    const chunk = AesFileVault.chunkSize;
    for (final size in [0, 1, 1000, chunk - 1, chunk, chunk + 1, 2 * chunk]) {
      final plain = _random(size, size);
      await vault.writeBytes(path('f'), plain);
      expect(await isVaultFile(path('f')), isTrue, reason: '$size');
      expect(await vault.readBytes(path('f')), plain, reason: '$size');

      File(path('src')).writeAsBytesSync(plain);
      await vault.encryptFile(path('src'), path('g'));
      await vault.decryptTo(path('g'), path('h'));
      expect(File(path('h')).readAsBytesSync(), plain, reason: '$size');
    }
    final marker = Uint8List.fromList('GEHEIMER BEFUND TSH 3,1'.codeUnits);
    await vault.writeBytes(path('m'), marker);
    final stored = File(path('m')).readAsBytesSync();
    expect(String.fromCharCodes(stored), isNot(contains('GEHEIMER')));
  });

  test('tampering, truncation and a wrong key are detected', () async {
    final plain = _random(AesFileVault.chunkSize + 500);
    await vault.writeBytes(path('f'), plain);
    final good = File(path('f')).readAsBytesSync();

    final flipped = Uint8List.fromList(good)..[good.length ~/ 2] ^= 1;
    File(path('t')).writeAsBytesSync(flipped);
    await expectLater(vault.readBytes(path('t')), throwsA(anything));

    // Letzten Block abschneiden: vorher nicht als „letzter“ markiert.
    File(path('t')).writeAsBytesSync(
      good.sublist(0, AesFileVault.headerSize + AesFileVault.chunkSize + 16),
    );
    await expectLater(vault.readBytes(path('t')), throwsA(anything));

    final other = await AesFileVault.fromDatabaseKey('ff${_dbKey.substring(2)}');
    await expectLater(other.readBytes(path('f')), throwsA(anything));
    // Gleicher Datenbankschlüssel → gleicher Dateischlüssel.
    final same = await AesFileVault.fromDatabaseKey(_dbKey);
    expect(await same.readBytes(path('f')), plain);
  });

  test('legacy plaintext is readable and migrated in place', () async {
    final reports = Directory(path('reports'))..createSync();
    final legacy = File('${reports.path}/a.pdf')
      ..writeAsBytesSync('%PDF-1.4 alt'.codeUnits);
    File('${reports.path}/b.pdf.enc.tmp').writeAsBytesSync([1, 2]);

    expect(await vault.readBytes(legacy.path), '%PDF-1.4 alt'.codeUnits);
    expect(await vault.migrate(reports), 1);
    expect(await isVaultFile(legacy.path), isTrue);
    expect(await vault.readBytes(legacy.path), '%PDF-1.4 alt'.codeUnits);
    expect(File('${reports.path}/b.pdf.enc.tmp').existsSync(), isFalse);
    expect(await vault.migrate(reports), 0); // idempotent

    final temp = await vault.decryptToTemp(legacy.path);
    expect(temp.readAsStringSync(), '%PDF-1.4 alt');
    expect(temp.path, contains('vault_tmp'));
  });

  test('import stores reports encrypted', () async {
    FileVault.current = vault;
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final service = ReportImportService(
      RecordsRepository(db),
      baseDir: () async => dir,
    );
    final imported = await service.importFile(
      name: 'Befund.pdf',
      sourcePath: 'test/fixtures/befund.pdf',
      readBytes: () => File('test/fixtures/befund.pdf').readAsBytes(),
    );
    final report = await (db.select(
      db.reports,
    )..where((t) => t.id.equals(imported.reportId))).getSingle();
    expect(await isVaultFile(report.localPath), isTrue);
    expect(
      await vault.readBytes(report.localPath),
      File('test/fixtures/befund.pdf').readAsBytesSync(),
    );
    // Keine Klartext-Arbeitskopie bleibt im Berichtsordner.
    expect(Directory('${dir.path}/reports').listSync(), hasLength(1));
  });
}
