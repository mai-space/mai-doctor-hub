import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:intl/date_symbol_data_local.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/database_provider.dart';
import 'package:mai_doctor_hub/data/repositories/records_repository.dart';
import 'package:mai_doctor_hub/features/records/entity_forms.dart';
import 'package:mai_doctor_hub/services/ocr/document_scanner.dart';
import 'package:mai_doctor_hub/services/ocr/ocr_service.dart';
import 'package:mai_doctor_hub/services/report_import_service.dart';
import 'package:pdfrx/pdfrx.dart';

import 'helpers/test_env.dart';

final _pdfium = Platform.environment['PDFIUM_PATH'];

/// Erkennt „Text“ = Dateiname + Bildgröße; merkt sich die Aufrufe.
class FakeRecognizer implements TextRecognizerApi {
  final calls = <String>[];

  @override
  bool get isSupported => true;

  @override
  Future<String?> recognizeFile(String imagePath) async {
    calls.add(imagePath);
    final image = img.decodeImage(await File(imagePath).readAsBytes());
    return 'Laborbefund Seite ${calls.length} (${image!.width}x${image.height})';
  }

  @override
  Future<void> close() async {}
}

class FakeScanner implements DocumentScannerApi {
  FakeScanner(this.result, {this.photo});

  final ScannedDocument? result;
  final String? photo;

  @override
  Future<String?> takePhoto() async => photo;

  @override
  bool get isSupported => true;

  @override
  Future<ScannedDocument?> scan() async => result;
}

class _UnavailableScanner implements DocumentScannerApi {
  @override
  bool get isSupported => true;

  @override
  Future<ScannedDocument?> scan() =>
      throw const ScannerUnavailable('Waiting for module download');

  @override
  Future<String?> takePhoto() async => photo;

  String? photo;
}

Uint8List pngBytes() => img.encodePng(img.Image(width: 40, height: 30));

void main() {
  late AppDatabase db;
  late Directory dir;
  late FakeRecognizer recognizer;
  late ReportImportService service;

  setUpAll(() async {
    await initializeDateFormatting('de');
    if (_pdfium != null) {
      Pdfrx.pdfiumModulePath = _pdfium;
      await pdfrxInitialize();
    }
  });
  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    dir = await Directory.systemTemp.createTemp('ocr_test');
    recognizer = FakeRecognizer();
    service = ReportImportService(
      RecordsRepository(db),
      baseDir: () async => dir,
      ocr: OcrService(recognizer, tempDir: () async => dir),
    );
  });
  tearDown(() async {
    await db.close();
    await dir.delete(recursive: true);
  });

  test('photo import is recognised and searchable', () async {
    final imported = await service.importFile(
      name: 'Rezept.png',
      readBytes: () async => pngBytes(),
    );
    expect(imported.extractedText, 'Laborbefund Seite 1 (40x30)');
    expect(await RecordsRepository(db).search('Laborbefund'), isNotEmpty);
  });

  test('scan uses page images and is stored as source scan', () async {
    final page1 = File('${dir.path}/p1.png')..writeAsBytesSync(pngBytes());
    final page2 = File('${dir.path}/p2.png')..writeAsBytesSync(pngBytes());
    final imported = await service.importFile(
      name: 'Scan.pdf',
      sourcePath: 'test/fixtures/scan_no_text.pdf',
      readBytes: () => File('test/fixtures/scan_no_text.pdf').readAsBytes(),
      source: ReportSource.scan,
      ocrImages: [page1.path, page2.path],
    );
    expect(recognizer.calls, [page1.path, page2.path]);
    expect(imported.extractedText, contains('Seite 2'));
    final report = await RecordsRepository(db).getReport(imported.reportId);
    expect(report!.source, ReportSource.scan);
  });

  test('reindex recognises older photo reports', () async {
    final photo = File('${dir.path}/alt.png')..writeAsBytesSync(pngBytes());
    final id = await RecordsRepository(db).createReport(
      title: 'Alt',
      mimeType: 'image/png',
      localPath: photo.path,
      source: ReportSource.image,
    );
    expect(await service.reindexMissing(), 1);
    expect(
      (await RecordsRepository(db).getReport(id))!.extractedText,
      isNotNull,
    );
  });

  test('ocr errors never block the import', () async {
    final failing = ReportImportService(
      RecordsRepository(db),
      baseDir: () async => dir,
      ocr: OcrService(_Throwing()),
    );
    final imported = await failing.importFile(
      name: 'x.jpg',
      readBytes: () async => pngBytes(),
    );
    expect(imported.extractedText, isNull);
    expect(await RecordsRepository(db).getReport(imported.reportId), isNotNull);
  });

  test('PDF without text layer is rendered and recognised', () async {
    final imported = await service.importFile(
      name: 'Fax.pdf',
      sourcePath: 'test/fixtures/scan_no_text.pdf',
      readBytes: () => File('test/fixtures/scan_no_text.pdf').readAsBytes(),
    );
    expect(recognizer.calls, hasLength(1));
    // A4 hochkant, lange Kante = renderSize.
    expect(imported.extractedText, contains('x${OcrService.renderSize})'));
  }, skip: _pdfium == null ? 'PDFIUM_PATH nicht gesetzt' : null);

  testWidgets('add report offers scan; scan flow stores a scan report', (
    tester,
  ) async {
    late String pdfPath;
    late String imagePath;
    await tester.runAsync(() async {
      pdfPath = '${dir.path}/scan.pdf';
      await File('test/fixtures/scan_no_text.pdf').copy(pdfPath);
      imagePath = '${dir.path}/page.png';
      await File(imagePath).writeAsBytes(pngBytes());
    });
    useFakePathProvider(dir.path);
    TextRecognizerApi.current = recognizer;
    DocumentScannerApi.current = FakeScanner(
      ScannedDocument(pdfPath: pdfPath, imagePaths: [imagePath]),
    );
    await tester.pumpWidget(
      DatabaseScope(
        database: db,
        child: MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => importReport(context),
                child: const Text('add'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('add'));
    await tester.pumpAndSettle();
    expect(find.text('Dokument scannen'), findsOneWidget);
    expect(find.text('Dateien wählen'), findsOneWidget);
    await tester.tap(find.text('Dokument scannen'));
    List<Report>? reports;
    for (var i = 0; i < 50 && (reports?.isEmpty ?? true); i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump(const Duration(milliseconds: 50));
      reports = await tester.runAsync(() => db.select(db.reports).get());
    }
    expect(reports!.single.source, ReportSource.scan);
    expect(reports.single.title, startsWith('Scan '));
    expect(reports.single.extractedText, contains('Laborbefund'));
    TextRecognizerApi.current = MlKitTextRecognizer();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('scanner failure is explained with a file fallback', (
    tester,
  ) async {
    DocumentScannerApi.current = _UnavailableScanner();
    addTearDown(() => DocumentScannerApi.current = MlKitDocumentScanner());
    await tester.pumpWidget(
      DatabaseScope(
        database: db,
        child: MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => importReport(context),
                child: const Text('add'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('add'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dokument scannen'));
    await tester.pumpAndSettle();
    expect(find.text('Scanner startet nicht'), findsOneWidget);
    expect(find.textContaining('Waiting for module download'), findsOneWidget);
    expect(find.text('Datei wählen'), findsOneWidget);
    expect(find.text('Foto aufnehmen'), findsOneWidget);
    await tester.tap(find.text('Abbrechen'));
    await tester.pumpAndSettle();
    expect(find.text('Scanner startet nicht'), findsNothing);
  });

  testWidgets('scanner failure: photo fallback stores a scan report', (
    tester,
  ) async {
    late String photo;
    await tester.runAsync(() async {
      photo = '${dir.path}/photo.png';
      await File(photo).writeAsBytes(pngBytes());
    });
    useFakePathProvider(dir.path);
    TextRecognizerApi.current = recognizer;
    DocumentScannerApi.current = _UnavailableScanner()..photo = photo;
    addTearDown(() {
      DocumentScannerApi.current = MlKitDocumentScanner();
      TextRecognizerApi.current = MlKitTextRecognizer();
    });
    await tester.pumpWidget(
      DatabaseScope(
        database: db,
        child: MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => importReport(context),
                child: const Text('add'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('add'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dokument scannen'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Foto aufnehmen'));
    List<Report>? reports;
    for (var i = 0; i < 50 && (reports?.isEmpty ?? true); i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 20)),
      );
      await tester.pump(const Duration(milliseconds: 50));
      reports = await tester.runAsync(() => db.select(db.reports).get());
    }
    expect(reports!.single.source, ReportSource.scan);
    expect(reports.single.mimeType, 'application/pdf');
    expect(reports.single.extractedText, contains('Laborbefund'));
    expect(recognizer.calls, [photo]);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 5));
  });
}

class _Throwing implements TextRecognizerApi {
  @override
  bool get isSupported => true;

  @override
  Future<String?> recognizeFile(String imagePath) => throw StateError('boom');

  @override
  Future<void> close() async {}
}
