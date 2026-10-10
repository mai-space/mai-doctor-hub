import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/repositories/appointment_repository.dart';
import 'package:mai_doctor_hub/data/repositories/cycle_repository.dart';
import 'package:mai_doctor_hub/data/repositories/doctor_repository.dart';
import 'package:mai_doctor_hub/data/repositories/medication_repository.dart';
import 'package:mai_doctor_hub/data/repositories/symptom_repository.dart';
import 'package:mai_doctor_hub/data/repositories/vaccination_repository.dart';
import 'package:mai_doctor_hub/data/symptom_measure.dart';
import 'package:mai_doctor_hub/features/check_in/check_in_sheet.dart';
import 'package:mai_doctor_hub/features/cycle/cycle_day_page.dart';
import 'package:mai_doctor_hub/features/home/add_appointment_sheet.dart';
import 'package:mai_doctor_hub/main.dart';
import 'package:mai_doctor_hub/services/ocr/document_scanner.dart';

import 'helpers/test_env.dart';

/// Scanner-Attrappe: zählt Aufrufe, liefert „abgebrochen“.
class _CountingScanner implements DocumentScannerApi {
  int scans = 0;

  @override
  bool get isSupported => true;

  @override
  Future<ScannedDocument?> scan() async {
    scans++;
    return null;
  }

  @override
  Future<String?> takePhoto() async => null;
}

void main() {
  late AppDatabase db;

  setUpAll(() => initializeDateFormatting('de'));
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 6; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 10)),
      );
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    useFakePermissions();
    await tester.runAsync(() => markOnboarded(db));
    await tester.pumpWidget(MaiDoctorHubApp(database: db));
    await settle(tester);
  }

  Future<void> disposeApp(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 100));
  }

  Future<void> openCapture(WidgetTester tester) async {
    await tester.tap(find.byKey(const ValueKey('home-capture-fab')));
    await settle(tester);
  }

  Future<void> tapAction(WidgetTester tester, String name) async {
    await tester.tap(find.byKey(ValueKey('capture-$name')));
    await settle(tester);
  }

  DateTime today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  group('Erfassen', () {
    testWidgets('FAB opens sheet; "Periode" only with cycle tracking', (
      tester,
    ) async {
      await pumpApp(tester);
      expect(find.text('Erfassen'), findsOneWidget);
      // Alte Knöpfe sind weg.
      expect(find.text('Termin hinzufügen'), findsNothing);

      await openCapture(tester);
      for (final label in [
        'Wie geht\'s?',
        'Neues Symptom',
        'Befund scannen',
        'Datei / PDF',
        'Foto · Audio',
        'Termin',
        'Tagebuch',
      ]) {
        expect(find.text(label), findsOneWidget, reason: label);
      }
      expect(find.text('Periode'), findsNothing);
      await tester.tapAt(const Offset(20, 20)); // Sheet schließen
      await settle(tester);

      await tester.runAsync(() => CycleRepository(db).setCycleTracking(true));
      await settle(tester);
      await openCapture(tester);
      expect(find.text('Periode'), findsOneWidget);
      await tapAction(tester, 'period');
      await tester.pump(const Duration(seconds: 1));
      final page = tester.widget<CycleDayPage>(find.byType(CycleDayPage));
      expect(page.day, today());
      await disposeApp(tester);
    });

    testWidgets('"Wie geht\'s?" opens the check-in sheet', (tester) async {
      await tester.runAsync(
        () => SymptomRepository(db).create(label: 'Kopfschmerz'),
      );
      await pumpApp(tester);
      await openCapture(tester);
      await tapAction(tester, 'checkIn');
      expect(find.byType(CheckInSheet), findsOneWidget);
      expect(
        tester.widget<CheckInSheet>(find.byType(CheckInSheet)).symptomIds,
        isEmpty,
        reason: 'alle offenen Symptome',
      );
      await disposeApp(tester);
    });

    testWidgets('"Befund scannen" starts the document scanner', (tester) async {
      final scanner = _CountingScanner();
      DocumentScannerApi.current = scanner;
      addTearDown(() => DocumentScannerApi.current = MlKitDocumentScanner());
      await pumpApp(tester);
      await openCapture(tester);
      await tapAction(tester, 'scan');
      expect(scanner.scans, 1);
      await disposeApp(tester);
    });

    testWidgets('"Termin" opens the appointment sheet', (tester) async {
      await pumpApp(tester);
      await openCapture(tester);
      await tapAction(tester, 'appointment');
      expect(find.byType(AddAppointmentSheet), findsOneWidget);
      await disposeApp(tester);
    });

    testWidgets('"Tagebuch" without mood symptom offers to create one', (
      tester,
    ) async {
      await pumpApp(tester);
      await openCapture(tester);
      await tapAction(tester, 'journal');
      expect(find.text('Tagebuch beginnen?'), findsOneWidget);
      await tester.tap(find.text('Anlegen'));
      await settle(tester);

      final symptoms = await tester.runAsync(
        () => SymptomRepository(db).watchOpen().first,
      );
      expect(symptoms!.single.label, 'Stimmung');
      expect(isPsychSymptom(symptoms.single), isTrue);
      final sheet = tester.widget<CheckInSheet>(find.byType(CheckInSheet));
      expect(sheet.symptomIds, [symptoms.single.id]);
      await disposeApp(tester);
    });

    testWidgets('"Foto · Audio" asks for the symptom, then the media kind', (
      tester,
    ) async {
      await tester.runAsync(
        () => SymptomRepository(db).create(label: 'Ausschlag'),
      );
      await pumpApp(tester);
      await openCapture(tester);
      await tapAction(tester, 'media');
      expect(find.text('Beleg zu welchem Symptom?'), findsOneWidget);
      expect(find.text('Neues Symptom anlegen'), findsOneWidget);
      await tester.tap(find.text('Ausschlag'));
      await settle(tester);
      expect(find.text('Beleg zu „Ausschlag“'), findsOneWidget);
      expect(find.text('Sprachnotiz'), findsOneWidget);
      await disposeApp(tester);
    });
  });

  group('Heute', () {
    testWidgets('meds progress with quick check, open check-ins, next '
        'appointment, due vaccination', (tester) async {
      final t = today();
      await tester.runAsync(() async {
        final meds = MedicationRepository(db);
        await meds.save(
          name: 'Ibuprofen',
          schedules: const [
            ScheduleInput(hour: 0, minute: 1),
            ScheduleInput(hour: 23, minute: 58),
          ],
        );
        final symptoms = SymptomRepository(db);
        await symptoms.create(label: 'Kopfschmerz');
        await symptoms.create(label: 'Übelkeit');
        final done = await symptoms.create(label: 'Husten');
        await symptoms.addObservation(
          symptomId: done,
          kind: ObservationKind.scale_1_10,
          valueNumber: 3,
        );
        final doctor = await DoctorRepository(db).create(name: 'Dr. X');
        await AppointmentRepository(db).create(
          doctorId: doctor,
          scheduledAt: t.add(const Duration(days: 3, hours: 9, minutes: 30)),
        );
        await VaccinationRepository(db).save(
          vaccine: 'Tetanus',
          administeredAt: DateTime(2016, 1, 1),
          nextDueAt: t.add(const Duration(days: 10)),
        );
      });
      await pumpApp(tester);

      final card = find.byKey(const ValueKey('home-today-card'));
      expect(card, findsOneWidget);
      Finder inCard(Finder f) => find.descendant(of: card, matching: f);
      expect(inCard(find.text('Heute')), findsOneWidget);
      expect(inCard(find.text('0 von 2 genommen')), findsOneWidget);
      expect(
        inCard(find.text('Kopfschmerz, Übelkeit noch nicht erfasst')),
        findsOneWidget,
      );
      expect(inCard(find.text('in 3 Tagen · Dr. X · 09:30')), findsOneWidget);
      expect(inCard(find.text('Tetanus')), findsOneWidget);

      // Schnell abhaken: nächste offene Dosis.
      await tester.tap(
        find.byTooltip('Ibuprofen (00:01) als genommen markieren'),
      );
      await settle(tester);
      expect(inCard(find.text('1 von 2 genommen')), findsOneWidget);

      // Antippen öffnet den Check-in nur für die offenen Symptome.
      await tester.tap(find.byKey(const ValueKey('today-checkins')));
      await settle(tester);
      final sheet = tester.widget<CheckInSheet>(find.byType(CheckInSheet));
      expect(sheet.symptomIds, hasLength(2));
      await disposeApp(tester);
    });

    testWidgets('all done when nothing is open', (tester) async {
      await tester.runAsync(() async {
        final symptoms = SymptomRepository(db);
        final id = await symptoms.create(label: 'Kopfschmerz');
        await symptoms.addObservation(
          symptomId: id,
          kind: ObservationKind.scale_1_10,
          valueNumber: 2,
        );
      });
      await pumpApp(tester);
      expect(find.text('Alles erledigt für heute ✓'), findsOneWidget);
      await disposeApp(tester);
    });

    testWidgets('brand-new user: no card, empty state points to "Erfassen"', (
      tester,
    ) async {
      await pumpApp(tester);
      expect(find.byKey(const ValueKey('home-today-card')), findsNothing);
      expect(find.text('Noch keine Termine'), findsOneWidget);
      expect(find.textContaining('Tippe auf „Erfassen“'), findsOneWidget);
      await disposeApp(tester);
    });
  });
}
