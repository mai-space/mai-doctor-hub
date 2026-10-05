import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/repositories/appointment_repository.dart';
import 'package:mai_doctor_hub/data/repositories/archive_repository.dart';
import 'package:mai_doctor_hub/data/repositories/doctor_repository.dart';
import 'package:mai_doctor_hub/data/repositories/records_repository.dart';
import 'package:mai_doctor_hub/services/document_export_service.dart';

void main() {
  late Directory root;
  late AppDatabase db;
  late RecordsRepository records;

  setUp(() async {
    root = await Directory.systemTemp.createTemp('doc_export');
    db = AppDatabase(NativeDatabase.memory());
    records = RecordsRepository(db);
  });
  tearDown(() async {
    await db.close();
    await root.delete(recursive: true);
  });

  Future<String> report(
    String title,
    String file, {
    String? appointmentId,
    ReportSource source = ReportSource.pdf,
  }) async {
    final path = '${root.path}/$file';
    File(path).writeAsStringSync('inhalt $title');
    return records.createReport(
      title: title,
      mimeType: file.endsWith('.pdf') ? 'application/pdf' : 'image/jpeg',
      localPath: path,
      source: source,
      appointmentId: appointmentId,
    );
  }

  test(
    'exports readable names, CSV overview; skips archived/missing',
    () async {
      final doctorId = await DoctorRepository(db).create(name: 'Dr. Nord/Süd');
      final appointmentId = await AppointmentRepository(db).create(
        doctorId: doctorId,
        scheduledAt: DateTime(2026, 3, 1, 9),
        title: 'Kontrolle',
      );
      await report('Arztbrief', 'a.pdf', appointmentId: appointmentId);
      await report('Arztbrief', 'b.pdf', appointmentId: appointmentId);
      await report('=Befund', 'c.jpg', source: ReportSource.scan);
      final archived = await report('Alt', 'd.pdf');
      await ArchiveRepository(db).archive('report', archived);
      await records.createReport(
        title: 'Weg',
        mimeType: 'application/pdf',
        localPath: '${root.path}/fehlt.pdf',
        source: ReportSource.pdf,
      );

      final export = await DocumentExportService(
        db,
        tempDir: () async => root,
      ).export();
      expect(export, isNotNull);
      expect(export!.count, 3);

      final archive = ZipDecoder().decodeBytes(export.file.readAsBytesSync());
      final names = archive.files.map((f) => f.name).toList();
      expect(
        names,
        containsAll([
          '2026-03-01_Dr. Nord-Süd_Arztbrief.pdf',
          '2026-03-01_Dr. Nord-Süd_Arztbrief (2).pdf',
          'Übersicht.csv',
        ]),
      );
      expect(names.where((n) => n.endsWith('_=Befund.jpg')), hasLength(1));
      expect(names.any((n) => n.contains('Alt') || n.contains('Weg')), isFalse);

      final first = archive.findFile('2026-03-01_Dr. Nord-Süd_Arztbrief.pdf')!;
      expect(utf8.decode(first.content), startsWith('inhalt Arztbrief'));

      final bytes = archive.findFile('Übersicht.csv')!.content;
      expect(bytes.take(3), [0xEF, 0xBB, 0xBF]); // BOM für Excel
      final csv = utf8.decode(bytes);
      expect(csv, contains('Datum;Titel;Arzt;Termin;Quelle;Seiten;Datei\r\n'));
      expect(
        csv,
        contains('2026-03-01;Arztbrief;Dr. Nord/Süd;Kontrolle;PDF;;'),
      );
      // Formel-Injection entschärft.
      expect(csv, contains(";'=Befund;;;Scan;"));
    },
  );

  test('nothing to export returns null', () async {
    final export = await DocumentExportService(
      db,
      tempDir: () async => root,
    ).export();
    expect(export, isNull);
  });
}
