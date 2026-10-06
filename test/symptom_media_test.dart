import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:intl/date_symbol_data_local.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/database_provider.dart';
import 'package:mai_doctor_hub/data/repositories/symptom_media_repository.dart';
import 'package:mai_doctor_hub/data/repositories/symptom_repository.dart';
import 'package:mai_doctor_hub/l10n/l10n.dart';
import 'package:mai_doctor_hub/services/backup_service_io.dart';
import 'package:mai_doctor_hub/services/file_vault.dart';
import 'package:mai_doctor_hub/services/media/media_capture.dart';
import 'package:mai_doctor_hub/services/visit_summary.dart';
import 'package:mai_doctor_hub/widgets/symptom_media_section.dart';

import 'helpers/test_env.dart';

Uint8List _jpeg() => Uint8List.fromList(
  img.encodeJpg(img.Image(width: 40, height: 30)..clear(img.ColorRgb8(200, 0, 0))),
);

class FakeCapture implements MediaCapture {
  FakeCapture(this.dir);

  final Directory dir;
  int picks = 0;

  @override
  Future<CapturedMedia?> pick(MediaKind kind, {required bool camera}) async {
    picks++;
    final file = File('${dir.path}/scan_photo_$picks.jpg')
      ..writeAsBytesSync(_jpeg());
    return CapturedMedia(path: file.path, kind: kind, mimeType: 'image/jpeg');
  }

  @override
  Future<bool> startAudio() async => true;

  @override
  Future<CapturedMedia?> stopAudio() async {
    final file = File('${dir.path}/audio_1.m4a')..writeAsBytesSync([1, 2, 3]);
    return CapturedMedia(
      path: file.path,
      kind: MediaKind.audio,
      mimeType: 'audio/mp4',
      durationMs: 4200,
    );
  }

  @override
  Future<void> cancelAudio() async {}

  @override
  Stream<double> get audioLevel => const Stream.empty();
}

void main() {
  late Directory root;
  late Directory docs;
  late AppDatabase db;
  late AesFileVault vault;

  setUpAll(() => initializeDateFormatting('de'));
  setUp(() async {
    root = await Directory.systemTemp.createTemp('media');
    docs = await Directory('${root.path}/docs').create();
    useFakePathProvider(root.path);
    db = AppDatabase(NativeDatabase.memory());
    vault = await AesFileVault.fromDatabaseKey('c3' * 32);
    FileVault.current = vault;
  });
  tearDown(() async {
    FileVault.current = const PlainFileVault();
    MediaCapture.current = DeviceMediaCapture();
    await db.close();
    await root.delete(recursive: true);
  });

  Future<String> addPhoto(String symptomId, {String? note}) async {
    final src = File('${root.path}/p_${DateTime.now().microsecondsSinceEpoch}.jpg')
      ..writeAsBytesSync(_jpeg());
    return SymptomMediaRepository(db).add(
      symptomId: symptomId,
      note: note,
      captured: CapturedMedia(
        path: src.path,
        kind: MediaKind.photo,
        mimeType: 'image/jpeg',
      ),
    );
  }

  test('stored encrypted in media/, plaintext capture removed', () async {
    final symptomId = await SymptomRepository(db).create(label: 'Ausschlag');
    final src = File('${root.path}/cap.jpg')..writeAsBytesSync(_jpeg());
    await SymptomMediaRepository(db).add(
      symptomId: symptomId,
      captured: CapturedMedia(
        path: src.path,
        kind: MediaKind.photo,
        mimeType: 'image/jpeg',
      ),
    );
    expect(src.existsSync(), isFalse);
    final item = (await SymptomMediaRepository(db).forSymptom(symptomId)).single;
    expect(item.localPath, startsWith('${docs.path}/media/'));
    expect(await isVaultFile(item.localPath), isTrue);
    expect(await vault.readBytes(item.localPath), _jpeg());
  });

  test('deleting the symptom removes its media rows and files', () async {
    final repo = SymptomRepository(db);
    final symptomId = await repo.create(label: 'Ausschlag');
    await addPhoto(symptomId);
    final obs = await repo.addObservation(
      symptomId: symptomId,
      kind: ObservationKind.scale_1_10,
      valueNumber: 5,
    );
    final media = SymptomMediaRepository(db);
    final item = (await media.forSymptom(symptomId)).single;
    await (db.update(db.symptomMedia)..where((t) => t.id.equals(item.id)))
        .write(SymptomMediaCompanion(observationId: Value(obs)));

    await repo.deleteObservation(obs); // Beleg bleibt, Zuordnung fällt weg
    expect((await media.forSymptom(symptomId)).single.observationId, isNull);

    await repo.delete(symptomId);
    expect(await media.all(), isEmpty);
    expect(File(item.localPath).existsSync(), isFalse);
  });

  test('backup carries media to another device', () async {
    final symptomId = await SymptomRepository(db).create(label: 'Husten');
    await addPhoto(symptomId, note: 'Morgens');
    final tmp = await Directory('${root.path}/tmp').create();
    final service = BackupService(
      db,
      baseDir: () async => docs,
      tempDir: () async => tmp,
      iterations: 1000,
    );
    final sealed = await service.createBackupFile('passwort123');
    final peek = await Directory('${root.path}/peek').create();
    final opened = await BackupStream.open(sealed.path, 'passwort123', peek.path);
    expect(opened.mediaEntries, hasLength(1));

    final dbB = AppDatabase(NativeDatabase.memory());
    addTearDown(dbB.close);
    final docsB = await Directory('${root.path}/b/docs').create(recursive: true);
    final vaultB = await AesFileVault.fromDatabaseKey('d4' * 32);
    FileVault.current = vaultB;
    await BackupService(
      dbB,
      baseDir: () async => docsB,
      tempDir: () async => tmp,
      iterations: 1000,
    ).restoreFile(sealed.path, 'passwort123');
    final item = (await dbB.select(dbB.symptomMedia).get()).single;
    expect(item.note, 'Morgens');
    expect(item.localPath, startsWith('${docsB.path}/media/'));
    expect(await vaultB.readBytes(item.localPath), _jpeg());
  });

  test('doctor PDF data includes photos and counts', () async {
    final symptomId = await SymptomRepository(db).create(label: 'Ausschlag');
    await addPhoto(symptomId, note: 'Arm links');
    final audio = File('${root.path}/a.m4a')..writeAsBytesSync([1, 2]);
    await SymptomMediaRepository(db).add(
      symptomId: symptomId,
      captured: CapturedMedia(
        path: audio.path,
        kind: MediaKind.audio,
        mimeType: 'audio/mp4',
      ),
    );
    final data = await VisitSummaryBuilder(
      db,
    ).build(const VisitSummaryOptions());
    final trend = data.symptoms.single;
    expect(trend.photos, hasLength(1));
    expect(trend.photos.single.note, 'Arm links');
    expect(trend.audioCount, 1);
    final pdf = await VisitSummaryPdf.render(data);
    expect(pdf.length, greaterThan(1000));
  });

  test('mime types fall back by kind', () {
    expect(mimeFor(MediaKind.photo, '.jpg'), 'image/jpeg');
    expect(mimeFor(MediaKind.video, '.mov'), 'video/quicktime');
    expect(mimeFor(MediaKind.audio, '.xyz'), 'audio/mp4');
  });

  testWidgets('section: take a photo, record a voice note', (tester) async {
    final symptomId = (await tester.runAsync(
      () => SymptomRepository(db).create(label: 'Ausschlag'),
    ))!;
    final capture = FakeCapture(root);
    MediaCapture.current = capture;
    await tester.pumpWidget(
      DatabaseScope(
        database: db,
        child: MaterialApp(
          locale: const Locale('de'),
          supportedLocales: AppLocale.supported,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: SingleChildScrollView(
              child: SymptomMediaSection(symptomId: symptomId),
            ),
          ),
        ),
      ),
    );
    Future<void> settle() async {
      for (var i = 0; i < 6; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 30)),
        );
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    await settle();
    expect(find.text('Noch keine Belege.'), findsOneWidget);
    await tester.tap(find.text('Foto'));
    await settle();
    await tester.tap(find.text('Sprachnotiz'));
    await settle();
    await tester.tap(find.text('Stopp & speichern'));
    await settle();
    final items = (await tester.runAsync(
      () => SymptomMediaRepository(db).forSymptom(symptomId),
    ))!;
    expect(items.map((m) => m.kind).toSet(), {MediaKind.photo, MediaKind.audio});
    expect(items.firstWhere((m) => m.kind == MediaKind.audio).durationMs, 4200);
    expect(find.text('2 Belege'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
