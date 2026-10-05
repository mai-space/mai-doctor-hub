import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/database_provider.dart';
import 'package:mai_doctor_hub/data/repositories/appointment_repository.dart';
import 'package:mai_doctor_hub/data/repositories/doctor_repository.dart';
import 'package:mai_doctor_hub/data/repositories/medication_repository.dart';
import 'package:mai_doctor_hub/data/repositories/records_repository.dart';
import 'package:mai_doctor_hub/data/repositories/symptom_repository.dart';
import 'package:mai_doctor_hub/data/repositories/vaccination_repository.dart';
import 'package:mai_doctor_hub/features/records/detail_pages.dart';
import 'package:mai_doctor_hub/features/summary/visit_summary_page.dart';
import 'package:mai_doctor_hub/services/visit_summary.dart';
import 'package:pdfrx/pdfrx.dart';

final _pdfium = Platform.environment['PDFIUM_PATH'];

void main() {
  late AppDatabase db;
  late String doctorId;
  late String appointmentId;
  late String nauseaId;
  late String healedId;
  final now = DateTime(2026, 3, 15, 12);

  setUpAll(() async {
    await initializeDateFormatting('de');
    if (_pdfium != null) {
      Pdfrx.pdfiumModulePath = _pdfium;
      await pdfrxInitialize();
    }
  });

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    doctorId = await DoctorRepository(db).create(name: 'Dr. Müller');
    final appointments = AppointmentRepository(db);
    await appointments.create(doctorId: doctorId, scheduledAt: DateTime(2026, 2, 1));
    final symptoms = SymptomRepository(db);
    nauseaId = await symptoms.create(label: 'Übelkeit', bodyRegion: 'Bauch');
    healedId = await symptoms.create(label: 'Husten');
    await symptoms.markHealed(healedId);
    appointmentId = await appointments.create(
      doctorId: doctorId,
      scheduledAt: DateTime(2026, 3, 20, 9),
      symptomIds: [nauseaId],
    );
    for (final (day, v) in [(5, 6.0), (10, 4.0), (14, 2.0)]) {
      await symptoms.addObservation(
        symptomId: nauseaId,
        kind: ObservationKind.scale_1_10,
        valueNumber: v,
        recordedAt: DateTime(2026, 2, day),
      );
    }
    await symptoms.addObservation(
      symptomId: nauseaId,
      kind: ObservationKind.scale_1_10,
      valueNumber: 9,
      recordedAt: DateTime(2026, 1, 20), // vor dem Zeitraum
    );
    await RecordsRepository(db).createNote(
      body: 'Soll ich die Dosis reduzieren?',
      relatedAppointmentId: appointmentId,
    );
    await RecordsRepository(db).createDiagnosis(title: 'Reizmagen');
    await MedicationRepository(db).save(
      name: 'Pantoprazol',
      strength: '20 mg',
      form: MedicationForm.tablet,
      doseAmount: 1,
      doseUnit: 'Stück',
      startedAt: DateTime(2026, 1, 1),
      schedules: const [ScheduleInput(hour: 7, minute: 30)],
    );
    await MedicationRepository(db).save(
      name: 'Alt',
      startedAt: DateTime(2025, 1, 1),
      endedAt: DateTime(2025, 2, 1),
    );
    final vaccinations = VaccinationRepository(db);
    await vaccinations.save(
      vaccine: 'Tetanus/Diphtherie (Td)',
      administeredAt: DateTime(2016, 4, 1),
      nextDueAt: DateTime(2026, 4, 1),
      batch: 'AB123',
    );
    await vaccinations.save(
      vaccine: 'Influenza (Grippe)',
      administeredAt: DateTime(2024, 10, 1),
      nextDueAt: DateTime(2025, 10, 1),
    );
    await vaccinations.save(
      vaccine: 'Influenza (Grippe)',
      administeredAt: DateTime(2025, 10, 5),
      nextDueAt: DateTime(2026, 10, 1),
    );
  });
  tearDown(() => db.close());

  test('due vaccinations: only the latest per vaccine counts', () async {
    final due = await VaccinationRepository(db).due(now: now);
    expect(due.map((v) => v.vaccine), ['Tetanus/Diphtherie (Td)']);
    expect(await RecordsRepository(db).search('AB123'), isNotEmpty);
  });

  test('builder: appointment window, notes as questions, active items', () async {
    final data = await VisitSummaryBuilder(db).build(
      VisitSummaryOptions(
        appointmentId: appointmentId,
        questions: 'Wie lange noch?\n\n  Sport erlaubt? ',
      ),
      now: now,
    );
    expect(data.from, DateTime(2026, 2, 1));
    expect(data.questions, [
      'Wie lange noch?',
      'Sport erlaubt?',
      'Soll ich die Dosis reduzieren?',
    ]);
    expect(data.symptoms.map((s) => s.symptom.label), ['Übelkeit']);
    expect(data.symptoms.single.scale, [6, 4, 2]);
    expect(data.symptoms.single.average, 4);
    expect(data.medications.map((m) => m.medication.name), ['Pantoprazol']);
    expect(data.diagnoses.map((d) => d.title), ['Reizmagen']);
    expect(data.vaccinations, hasLength(3));
    expect(data.dueVaccinations, hasLength(1));
  });

  test('builder: explicit selection and toggles', () async {
    final data = await VisitSummaryBuilder(db).build(
      VisitSummaryOptions(
        symptomIds: {healedId},
        medicationIds: const {},
        includeDiagnoses: false,
        includeVaccinations: false,
      ),
      now: now,
    );
    expect(data.symptoms.single.symptom.label, 'Husten');
    expect(data.medications, isEmpty);
    expect(data.diagnoses, isEmpty);
    expect(data.vaccinations, isEmpty);
    expect(data.from, now.subtract(const Duration(days: 30)));
  });

  test('renders a PDF', () async {
    final data = await VisitSummaryBuilder(db).build(
      VisitSummaryOptions(appointmentId: appointmentId, patientName: 'Joel'),
      now: now,
    );
    final bytes = await VisitSummaryPdf.render(data);
    expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    expect(VisitSummaryPdf.fileName(data), 'Arztbesuch_2026-03-20.pdf');
  });

  test('PDF text contains all sections incl. umlauts', () async {
    final data = await VisitSummaryBuilder(db).build(
      VisitSummaryOptions(
        appointmentId: appointmentId,
        questions: 'Darf ich Kaffee trinken?',
      ),
      now: now,
    );
    final bytes = await VisitSummaryPdf.render(data);
    final doc = await PdfDocument.openData(bytes);
    final text = StringBuffer();
    for (final page in doc.pages) {
      text.write((await page.loadText())?.fullText ?? '');
    }
    await doc.dispose();
    final all = text.toString();
    for (final expected in [
      'Zusammenfassung für den Arztbesuch',
      'Dr. Müller',
      'Darf ich Kaffee trinken?',
      'Übelkeit',
      'Ø 4,0/10',
      'Pantoprazol 20 mg Tablette',
      'Tetanus/Diphtherie (Td)',
      'Fällig: Tetanus',
      'Reizmagen',
    ]) {
      expect(all, contains(expected));
    }
  }, skip: _pdfium == null ? 'PDFIUM_PATH nicht gesetzt' : null);

  group('widgets', () {
    Future<void> settle(WidgetTester tester) async {
      for (var i = 0; i < 6; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 10)),
        );
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    testWidgets('summary page lists choices', (tester) async {
      tester.view.physicalSize = const Size(1080, 3000);
      tester.view.devicePixelRatio = 2.5;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        DatabaseScope(
          database: db,
          child: MaterialApp(
            home: VisitSummaryPage(appointmentId: appointmentId),
          ),
        ),
      );
      await settle(tester);
      expect(find.text('Für den Arztbesuch'), findsOneWidget);
      await tester.tap(find.text('Alle offenen Symptome'));
      await settle(tester);
      expect(find.widgetWithText(FilterChip, 'Übelkeit'), findsOneWidget);
      expect(find.text('PDF teilen'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('vaccination detail shows overdue booster', (tester) async {
      final v = (await tester.runAsync(
        () => VaccinationRepository(db).all(),
      ))!.firstWhere((v) => v.vaccine.startsWith('Tetanus'));
      await tester.pumpWidget(
        DatabaseScope(
          database: db,
          child: MaterialApp(home: VaccinationDetailPage(vaccinationId: v.id)),
        ),
      );
      await settle(tester);
      expect(find.text('Tetanus/Diphtherie (Td)'), findsOneWidget);
      expect(find.text('AB123'), findsOneWidget);
      // Fälligkeit 1.4.2026 liegt (realer Kalender) in der Vergangenheit.
      expect(find.text('Auffrischung überfällig'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 100));
    });
  });
}
