import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/repositories/records_repository.dart';
import 'package:mai_doctor_hub/services/report_import_service.dart';

void main() {
  late AppDatabase database;
  late Directory tempDir;
  late ReportImportService service;

  setUp(() async {
    database = AppDatabase(NativeDatabase.memory());
    tempDir = await Directory.systemTemp.createTemp('reports_test');
    service = ReportImportService(
      RecordsRepository(database),
      baseDir: () async => tempDir,
    );
  });

  tearDown(() async {
    await database.close();
    await tempDir.delete(recursive: true);
  });

  final pdfBytes = Uint8List.fromList('%PDF-1.4 test'.codeUnits);

  test('copies picked PDF into a fresh reports dir', () async {
    final source = File('${tempDir.path}/picked.pdf');
    await source.writeAsBytes(pdfBytes);

    final imported = await service.importFile(
      name: 'Befund MRT.pdf',
      sourcePath: source.path,
      readBytes: () async => throw StateError('should copy from path'),
    );

    final report = await (database.select(
      database.reports,
    )..where((t) => t.id.equals(imported.reportId))).getSingle();
    expect(report.mimeType, 'application/pdf');
    expect(report.source, ReportSource.pdf);
    expect(report.localPath, contains('${Platform.pathSeparator}reports'));
    expect(await File(report.localPath).readAsBytes(), pdfBytes);
  });

  test('falls back to bytes when no local path exists', () async {
    final imported = await service.importFile(
      name: 'scan.pdf',
      readBytes: () async => pdfBytes,
      sourcePath: 'content://provider/doc/1',
    );

    final report = await (database.select(
      database.reports,
    )..where((t) => t.id.equals(imported.reportId))).getSingle();
    expect(await File(report.localPath).readAsBytes(), pdfBytes);
  });

  test('attaches report to appointment', () async {
    final imported = await service.importFile(
      name: 'brief.pdf',
      readBytes: () async => pdfBytes,
      appointmentId: 'appt-1',
    );

    final reports = await RecordsRepository(database)
        .reportsForAppointment('appt-1');
    expect(reports.single.id, imported.reportId);
  });

  test('rejects unsupported file types', () async {
    expect(
      () => service.importFile(name: 'x.exe', readBytes: () async => pdfBytes),
      throwsA(isA<ReportImportException>()),
    );
  });

  test('bulk import keeps going after a bad file', () async {
    final result = await service.importAll([
      (name: 'Brief 1.pdf', path: null, readBytes: () async => pdfBytes),
      (name: 'notizen.txt', path: null, readBytes: () async => Uint8List(0)),
      (name: 'Brief 2.pdf', path: null, readBytes: () async => pdfBytes),
    ]);
    expect(result.imported.map((r) => r.title), ['Brief 1.pdf', 'Brief 2.pdf']);
    expect(result.failed.keys, ['notizen.txt']);
    expect(await database.select(database.reports).get(), hasLength(2));
  });
}
