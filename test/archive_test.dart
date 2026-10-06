import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/database_provider.dart';
import 'package:mai_doctor_hub/data/repositories/appointment_repository.dart';
import 'package:mai_doctor_hub/data/repositories/archive_repository.dart';
import 'package:mai_doctor_hub/data/repositories/doctor_repository.dart';
import 'package:mai_doctor_hub/data/repositories/medication_repository.dart';
import 'package:mai_doctor_hub/data/repositories/records_repository.dart';
import 'package:mai_doctor_hub/data/repositories/settings_repository.dart';
import 'package:mai_doctor_hub/features/archive/archive_page.dart';
import 'package:mai_doctor_hub/services/calendar/calendar_sync_service.dart';
import 'package:mai_doctor_hub/services/notifications/medication_reminders.dart';

import 'helpers/fake_calendar.dart';
import 'helpers/test_env.dart';

void main() {
  late AppDatabase db;
  late ArchiveRepository archive;
  late RecordsRepository records;
  late AppointmentRepository appointments;
  late String doctorId;

  setUpAll(() => initializeDateFormatting('de'));
  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    archive = ArchiveRepository(db);
    records = RecordsRepository(db);
    appointments = AppointmentRepository(db);
    doctorId = await DoctorRepository(db).create(name: 'Dr. Ost');
  });
  tearDown(() => db.close());

  test('appointment takes its reports along; undo restores both', () async {
    final id = await appointments.create(
      doctorId: doctorId,
      scheduledAt: DateTime(2030, 1, 1),
      title: 'Kontrolle',
    );
    final reportId = await records.createReport(
      title: 'Befund',
      mimeType: 'application/pdf',
      localPath: '/x.pdf',
      source: ReportSource.pdf,
      appointmentId: id,
      extractedText: 'Cholesterin',
    );
    final otherReport = await records.createReport(
      title: 'Lose',
      mimeType: 'application/pdf',
      localPath: '/y.pdf',
      source: ReportSource.pdf,
    );

    await archive.archive('appointment', id);
    expect(await appointments.watchUpcomingSummaries().first, isEmpty);
    expect(await records.reportsForAppointment(id), isEmpty);
    expect(await records.search('Cholesterin'), isEmpty);
    final listed = await records.listAll(sort: RecordSort.name);
    expect(listed.map((i) => i.title), isNot(contains('Befund')));
    expect(listed.map((i) => i.title), contains('Lose'));
    expect(
      (await archive.archived()).map((i) => (i.entityType, i.id)),
      unorderedEquals([('appointment', id), ('report', reportId)]),
    );

    await archive.restore('appointment', id);
    expect(await appointments.watchUpcomingSummaries().first, hasLength(1));
    expect(await records.reportsForAppointment(id), hasLength(1));
    expect(await records.search('Cholesterin'), isNotEmpty);
    expect(await archive.archived(), isEmpty);
    expect(otherReport, isNotEmpty);
  });

  test('report archived before keeps its own archive state', () async {
    final id = await appointments.create(
      doctorId: doctorId,
      scheduledAt: DateTime(2030),
    );
    final reportId = await records.createReport(
      title: 'Früher gelöscht',
      mimeType: 'application/pdf',
      localPath: '/x.pdf',
      source: ReportSource.pdf,
      appointmentId: id,
    );
    await archive.archive('report', reportId);
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    await archive.archive('appointment', id);
    await archive.restore('appointment', id);
    expect((await records.getReport(reportId))!.archivedAt, isNotNull);
  });

  test('doctor with active appointments cannot be archived', () async {
    final id = await appointments.create(
      doctorId: doctorId,
      scheduledAt: DateTime(2030),
    );
    expect(
      () => archive.archive('doctor', doctorId),
      throwsA(isA<ArchiveBlocked>()),
    );
    await archive.archive('appointment', id);
    await archive.archive('doctor', doctorId);
    expect(await DoctorRepository(db).watchAll().first, isEmpty);
  });

  test('purge deletes for good incl. files; purgeAll orders doctors last', () async {
    final dir = await Directory.systemTemp.createTemp('archive');
    addTearDown(() => dir.delete(recursive: true));
    // Gelöscht werden nur Dateien im eigenen Berichte-Ordner.
    useFakePathProvider(dir.path);
    final file = File('${dir.path}/docs/reports/r.pdf')
      ..createSync(recursive: true)
      ..writeAsStringSync('%PDF');
    final id = await appointments.create(
      doctorId: doctorId,
      scheduledAt: DateTime(2030),
    );
    await records.createReport(
      title: 'Datei',
      mimeType: 'application/pdf',
      localPath: file.path,
      source: ReportSource.pdf,
      appointmentId: id,
    );
    await archive.archive('appointment', id);
    await archive.archive('doctor', doctorId);
    final noteId = await records.createNote(body: 'weg');
    await archive.archive('note', noteId);

    expect(await archive.purgeAll(), 4);
    expect(await archive.archived(), isEmpty);
    expect(file.existsSync(), isFalse);
    expect(await DoctorRepository(db).getById(doctorId), isNull);
  });

  test('archived appointments leave the calendar; archived meds stop reminders', () async {
    final calendar = FakeCalendar();
    final id = await appointments.create(
      doctorId: doctorId,
      scheduledAt: DateTime(2030, 1, 1, 9),
    );
    await SettingsRepository(db).updateCalendarExport(
      enabled: true,
      calendarId: 'g1',
      includeTitle: false,
    );
    final sync = CalendarSyncService(db, calendar);
    await sync.syncAll();
    expect(calendar.all('g1'), hasLength(1));
    await archive.archive('appointment', id);
    await sync.syncAll();
    expect(calendar.all('g1'), isEmpty);

    final medId = await MedicationRepository(db).save(
      name: 'Tabletten',
      schedules: const [ScheduleInput(hour: 8, minute: 0)],
    );
    await archive.archive('medication', medId);
    final plans = MedicationReminderPlanner.plan(
      await MedicationRepository(db).all(),
      now: DateTime(2030),
    );
    expect(plans, isEmpty);
  });

  testWidgets('archive page restores and purges', (tester) async {
    late String noteId;
    late String diagnosisId;
    await tester.runAsync(() async {
      noteId = await records.createNote(body: 'Alte Notiz');
      diagnosisId = await records.createDiagnosis(title: 'Alte Diagnose');
      await archive.archive('note', noteId);
      await archive.archive('diagnosis', diagnosisId);
    });
    Future<void> settle() async {
      for (var i = 0; i < 6; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 10)),
        );
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    await tester.pumpWidget(
      DatabaseScope(
        database: db,
        child: const MaterialApp(home: ArchivePage()),
      ),
    );
    await settle();
    expect(find.text('Alte Notiz'), findsOneWidget);
    expect(find.text('Alte Diagnose'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.widgetWithText(ListTile, 'Alte Notiz'),
        matching: find.byTooltip('Wiederherstellen'),
      ),
    );
    await settle();
    expect(find.text('Alte Notiz'), findsNothing);
    final note = await tester.runAsync(() => records.getNote(noteId));
    expect(note!.archivedAt, isNull);

    await tester.tap(find.byTooltip('Endgültig löschen'));
    await settle();
    await tester.tap(find.widgetWithText(FilledButton, 'Endgültig löschen'));
    await settle();
    final diagnosis = await tester.runAsync(
      () => records.getDiagnosis(diagnosisId),
    );
    expect(diagnosis, isNull);
    expect(find.textContaining('Das Archiv ist leer'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 100));
  });
}
