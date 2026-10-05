import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/database_provider.dart';
import 'package:mai_doctor_hub/data/repositories/doctor_repository.dart';
import 'package:mai_doctor_hub/data/repositories/medication_repository.dart';
import 'package:mai_doctor_hub/data/repositories/records_repository.dart';
import 'package:mai_doctor_hub/features/medications/intake_widgets.dart';
import 'package:mai_doctor_hub/features/medications/medication_form_page.dart';
import 'package:mai_doctor_hub/features/records/detail_pages.dart';
import 'package:mai_doctor_hub/services/notifications/medication_reminders.dart';
import 'package:mai_doctor_hub/services/notifications/notification_plan.dart';

import 'helpers/test_env.dart';

void main() {
  late AppDatabase db;
  late MedicationRepository meds;

  setUpAll(() => initializeDateFormatting('de'));
  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    meds = MedicationRepository(db);
  });
  tearDown(() => db.close());

  group('repository', () {
    test('save with prescriber, pharmacy, schedules and summary', () async {
      final doctor = await DoctorRepository(db).create(name: 'Dr. Herz');
      final pharmacy = await PharmacyRepository(db).save(name: 'Löwen-Apotheke');
      final id = await meds.save(
        name: 'Ramipril',
        strength: '5 mg',
        form: MedicationForm.tablet,
        doseAmount: 1,
        doseUnit: 'Stück',
        instructions: 'morgens nüchtern',
        prescriberId: doctor,
        pharmacyId: pharmacy,
        schedules: const [
          ScheduleInput(hour: 20, minute: 0, doseAmount: 0.5),
          ScheduleInput(hour: 8, minute: 0, weekdays: 31),
        ],
      );
      final d = (await meds.get(id))!;
      expect(d.prescriber!.name, 'Dr. Herz');
      expect(d.pharmacy!.name, 'Löwen-Apotheke');
      expect(d.schedules.map((s) => s.hour), [8, 20]);
      expect(d.doseFor(d.schedules.last), '0,5 Stück');
      expect(d.doseFor(d.schedules.first), '1 Stück');
      expect(d.medication.scheduleText, '08:00 (werktags), 20:00');
      expect(await RecordsRepository(db).search('nüchtern'), isNotEmpty);

      // Bearbeiten ersetzt Einnahmezeiten.
      await meds.save(
        id: id,
        name: 'Ramipril',
        schedules: const [ScheduleInput(hour: 7, minute: 30)],
      );
      expect((await meds.get(id))!.schedules.single.hour, 7);
    });

    test('doses per day respect weekdays and period; intake replaces', () async {
      final id = await meds.save(
        name: 'Antibiotikum',
        startedAt: DateTime(2030, 3, 2),
        endedAt: DateTime(2030, 3, 8),
        schedules: const [
          ScheduleInput(hour: 8, minute: 0),
          ScheduleInput(hour: 20, minute: 0, weekdays: 1), // nur Montag
        ],
      );
      expect(await meds.dosesOn(DateTime(2030, 3, 1)), isEmpty, reason: 'vor Start');
      expect(await meds.dosesOn(DateTime(2030, 3, 9)), isEmpty, reason: 'nach Ende');
      expect((await meds.dosesOn(DateTime(2030, 3, 4))).length, 2, reason: 'Montag');
      final tuesday = await meds.dosesOn(DateTime(2030, 3, 5));
      expect(tuesday.single.at, DateTime(2030, 3, 5, 8));

      await meds.recordIntake(
        medicationId: id,
        scheduledFor: DateTime(2030, 3, 5, 8),
        status: IntakeStatus.skipped,
      );
      await meds.recordIntake(medicationId: id, scheduledFor: DateTime(2030, 3, 5, 8));
      final after = await meds.dosesOn(DateTime(2030, 3, 5));
      expect(after.single.intake!.status, IntakeStatus.taken);
      expect(await meds.intakes(id), hasLength(1), reason: 'ersetzt, nicht doppelt');
    });

    test('adherence over past days', () async {
      final id = await meds.save(
        name: 'Vitamin D',
        startedAt: DateTime(2030, 1, 1),
        schedules: const [ScheduleInput(hour: 9, minute: 0)],
      );
      final now = DateTime(2030, 1, 11, 12);
      for (var day = 1; day <= 10; day++) {
        if (day.isEven) {
          await meds.recordIntake(
            medicationId: id,
            scheduledFor: DateTime(2030, 1, day, 9),
          );
        }
      }
      expect(await meds.adherence(id, days: 10, now: now), 0.5);
    });

    test('deleting cascades; pharmacy/doctor delete only unlinks', () async {
      final doctor = await DoctorRepository(db).create(name: 'Dr. X');
      final pharmacy = await PharmacyRepository(db).save(name: 'A');
      final id = await meds.save(
        name: 'M',
        prescriberId: doctor,
        pharmacyId: pharmacy,
        schedules: const [ScheduleInput(hour: 8, minute: 0)],
      );
      await meds.recordIntake(medicationId: id);
      await PharmacyRepository(db).delete(pharmacy);
      await DoctorRepository(db).delete(doctor);
      final d = (await meds.get(id))!;
      expect(d.pharmacy, isNull);
      expect(d.prescriber, isNull);

      await RecordsRepository(db).deleteMedication(id);
      expect(await db.select(db.medicationSchedules).get(), isEmpty);
      expect(await db.select(db.medicationIntakes).get(), isEmpty);
    });
  });

  group('reminders', () {
    final now = DateTime(2030, 3, 10, 12); // Sonntag

    test('open-ended: repeating; limited: one-shots until the end', () async {
      await meds.save(
        name: 'Dauer',
        schedules: const [
          ScheduleInput(hour: 8, minute: 0),
          ScheduleInput(hour: 20, minute: 0, weekdays: 1 | 16), // Mo, Fr
        ],
      );
      await meds.save(
        name: 'Kur',
        startedAt: DateTime(2030, 3, 9),
        endedAt: DateTime(2030, 3, 12),
        doseAmount: 2,
        doseUnit: 'Tropfen',
        schedules: const [ScheduleInput(hour: 18, minute: 0)],
      );
      await meds.save(
        name: 'Stumm',
        remindersEnabled: false,
        schedules: const [ScheduleInput(hour: 8, minute: 0)],
      );
      await meds.save(
        name: 'Vorbei',
        endedAt: DateTime(2030, 3, 1),
        schedules: const [ScheduleInput(hour: 8, minute: 0)],
      );

      final plans = MedicationReminderPlanner.plan(await meds.all(), now: now);
      final dauer = plans.where((p) => p.title == 'Einnahme: Dauer').toList();
      expect(dauer.every((p) => p.isRepeating), isTrue);
      expect(dauer.map((p) => p.weekday), [null, 1, 5]);

      final kur = plans.where((p) => p.title == 'Einnahme: Kur').toList();
      expect(kur.map((p) => p.at), [
        DateTime(2030, 3, 10, 18),
        DateTime(2030, 3, 11, 18),
        DateTime(2030, 3, 12, 18),
      ]);
      expect(kur.first.body, '2 Tropfen');
      expect(
        MedicationPayload.decode(kur.first.payload)!.$2,
        DateTime(2030, 3, 10, 18),
      );

      expect(plans.where((p) => p.title.contains('Stumm')), isEmpty);
      expect(plans.where((p) => p.title.contains('Vorbei')), isEmpty);
      final ids = plans.map((p) => p.id).toList();
      expect(ids.toSet(), hasLength(ids.length));
      expect(ids.every(NotificationGroup.medications.contains), isTrue);
    });

    test('payload round trip', () {
      final at = DateTime(2030, 3, 10, 8);
      expect(MedicationPayload.decode(MedicationPayload.encode('m@1', at)), (
        'm@1',
        at,
      ));
      expect(MedicationPayload.decode('check_in'), isNull);
    });
  });

  group('widgets', () {
    Future<void> settle(WidgetTester tester) async {
      for (var i = 0; i < 6; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 10)),
        );
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    Widget app(Widget home) => DatabaseScope(
      database: db,
      child: MaterialApp(home: home),
    );

    testWidgets('form creates a medication with an intake time', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1080, 4000);
      tester.view.devicePixelRatio = 2.5;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(app(const MedicationFormPage()));
      await settle(tester);

      await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Ibuprofen');
      await tester.enterText(
        find.widgetWithText(TextField, 'Dosis je Einnahme'),
        '1',
      );
      await tester.tap(find.widgetWithText(ActionChip, 'Stück'));
      await tester.tap(find.text('Einnahmezeit hinzufügen'));
      await settle(tester);
      await tester.tap(find.text('OK'));
      await settle(tester);
      await tester.tap(find.text('Tage'));
      await settle(tester);
      await tester.tap(find.widgetWithText(FilledButton, 'Speichern'));
      await settle(tester);

      final all = await tester.runAsync(() => meds.all());
      final d = all!.single;
      expect(d.medication.name, 'Ibuprofen');
      expect(d.schedules.single.hour, 8);
      expect(d.doseFor(null), '1 Stück');
      expect(
        d.medication.endedAt!.difference(d.medication.startedAt!).inDays,
        6,
        reason: '7 Tage inkl. Starttag',
      );
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('today sheet marks a dose as taken; detail shows log', (
      tester,
    ) async {
      useFakePermissions();
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 2.5;
      addTearDown(tester.view.reset);
      late String id;
      await tester.runAsync(() async {
        id = await meds.save(
          name: 'Metformin',
          doseAmount: 1,
          doseUnit: 'Stück',
          schedules: const [ScheduleInput(hour: 0, minute: 1)],
        );
      });
      await tester.pumpWidget(
        app(
          Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => showTodayMedicationsSheet(context),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await settle(tester);
      expect(find.text('1 von 1 offen'), findsOneWidget);
      await tester.tap(find.byTooltip('Eingenommen'));
      await settle(tester);
      expect(find.text('Alles erledigt.'), findsOneWidget);
      expect(find.text('Genommen'), findsOneWidget);

      await tester.pumpWidget(app(MedicationDetailPage(medicationId: id)));
      await settle(tester);
      expect(find.text('Einnahme-Protokoll'), findsOneWidget);
      expect(find.textContaining('Genommen · 1 Stück'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 100));
    });
  });
}
