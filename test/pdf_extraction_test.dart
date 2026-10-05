import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/repositories/records_repository.dart';
import 'package:mai_doctor_hub/services/pdf_extractor.dart';
import 'package:mai_doctor_hub/services/report_import_service.dart';
import 'package:pdfrx/pdfrx.dart';

/// Benötigt eine PDFium-Bibliothek für den Host (CI lädt sie herunter):
/// `PDFIUM_PATH=/pfad/libpdfium.so flutter test`
final _pdfiumPath = Platform.environment['PDFIUM_PATH'];

void main() {
  setUpAll(() async {
    if (_pdfiumPath == null) return;
    Pdfrx.pdfiumModulePath = _pdfiumPath;
    await pdfrxInitialize();
  });

  final skip = _pdfiumPath == null
      ? 'PDFIUM_PATH nicht gesetzt — PDF-Extraktion übersprungen'
      : null;

  test('extracts text of all pages', () async {
    final result = await extractPdfText('test/fixtures/befund.pdf');
    expect(result.pageCount, 2);
    expect(result.text, contains('Ferritin niedrig'));
    expect(result.text, contains('Empfehlung Kontrolle'));
  }, skip: skip);

  test('imported PDF becomes searchable; reindex fills old reports', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final dir = await Directory.systemTemp.createTemp('pdf_import');
    addTearDown(() => dir.delete(recursive: true));
    final records = RecordsRepository(db);
    final service = ReportImportService(records, baseDir: () async => dir);

    await service.importFile(
      name: 'Labor.pdf',
      sourcePath: 'test/fixtures/befund.pdf',
      readBytes: () => File('test/fixtures/befund.pdf').readAsBytes(),
    );
    expect(await records.search('Ferritin'), isNotEmpty);

    // Bericht aus I1: ohne Text gespeichert.
    final legacyPath = '${dir.path}/legacy.pdf';
    await File('test/fixtures/befund.pdf').copy(legacyPath);
    final legacyId = await records.createReport(
      title: 'Alt',
      mimeType: 'application/pdf',
      localPath: legacyPath,
      source: ReportSource.pdf,
    );
    expect(await service.reindexMissing(), 1);
    final legacy = await records.getReport(legacyId);
    expect(legacy!.pageCount, 2);
    final hits = await records.search('Empfehlung');
    expect(hits.map((r) => r.read<String>('entity_id')), contains(legacyId));
  }, skip: skip);
}
