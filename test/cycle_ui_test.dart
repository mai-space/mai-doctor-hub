import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/database_provider.dart';
import 'package:mai_doctor_hub/data/repositories/appointment_repository.dart';
import 'package:mai_doctor_hub/data/repositories/cycle_repository.dart';
import 'package:mai_doctor_hub/data/repositories/doctor_repository.dart';
import 'package:mai_doctor_hub/data/repositories/settings_repository.dart';
import 'package:mai_doctor_hub/features/cycle/cycle_page.dart';
import 'package:mai_doctor_hub/features/cycle/cycle_settings_section.dart';
import 'package:mai_doctor_hub/features/summary/visit_summary_page.dart';
import 'package:mai_doctor_hub/main.dart';
import 'package:mai_doctor_hub/services/cycle/cycle_dates.dart';

import 'helpers/test_env.dart';

void main() {
  late AppDatabase db;

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

  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 100));
  }

  void tallScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2600);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
  }

  Widget host(Widget child) => DatabaseScope(
    database: db,
    child: MaterialApp(home: child),
  );

  group('onboarding', () {
    Future<void> toCycleStep(WidgetTester tester) async {
      useFakePermissions(granted: false);
      await tester.pumpWidget(MaiDoctorHubApp(database: db));
      await settle(tester);
      for (var i = 0; i < 2; i++) {
        await tester.tap(find.text('Weiter'));
        await settle(tester);
      }
      expect(find.text('Zyklus & Frauengesundheit'), findsOneWidget);
    }

    testWidgets('choosing period tracking creates the gynecologist once', (
      tester,
    ) async {
      tallScreen(tester);
      await toCycleStep(tester);
      expect(find.text('Gynäkologie als Ärztin/Arzt anlegen'), findsNothing);
      await tester.tap(find.byKey(const ValueKey('onboarding-cycle')));
      await settle(tester);
      // Zyklus-Start fragt nach der letzten Periode — hier „Später“.
      expect(find.text('Wann hat deine letzte Periode begonnen?'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('cycle-start-later')));
      await settle(tester);
      // Standard: Gynäkologie mit anlegen.
      final checkbox = tester.widget<CheckboxListTile>(
        find.byType(CheckboxListTile),
      );
      expect(checkbox.value, isTrue);

      await tester.tap(find.text('Weiter'));
      await settle(tester);
      await tester.tap(find.text('Los geht’s'));
      await settle(tester);

      final (settings, doctors) = (await tester.runAsync(
        () async => (
          await SettingsRepository(db).get(),
          await DoctorRepository(db).watchAll().first,
        ),
      ))!;
      expect(settings.onboardingCompleted, isTrue);
      expect(settings.cycleTracking, isTrue);
      expect(settings.cycleSetupDone, isTrue, reason: 'übersprungen');
      expect(settings.menopauseTracking, isFalse);
      expect(doctors.map((d) => d.name), ['Meine Gynäkologin/mein Gynäkologe']);
      // Startseite zeigt die Zyklus-Karte.
      expect(find.byKey(const ValueKey('cycle-home-card')), findsOneWidget);
      expect(find.textContaining('Noch keine Periode erfasst'), findsOneWidget);

      // Erneut übernehmen legt keine zweite Praxis an.
      await tester.runAsync(
        () =>
            CycleRepository(db)
                .apply(const CycleSetup(cycle: true, createGynecologist: true)),
      );
      final again = await tester.runAsync(
        () => DoctorRepository(db).watchAll().first,
      );
      expect(again, hasLength(1));
      await unmount(tester);
    });

    testWidgets('"not for me" and unticked doctor change nothing', (
      tester,
    ) async {
      tallScreen(tester);
      await toCycleStep(tester);
      await tester.tap(find.byKey(const ValueKey('onboarding-menopause')));
      await settle(tester);
      await tester.tap(find.byType(CheckboxListTile));
      await settle(tester);
      await tester.tap(find.text('Überspringen'));
      await settle(tester);
      final (settings, doctors) = (await tester.runAsync(
        () async => (
          await SettingsRepository(db).get(),
          await DoctorRepository(db).watchAll().first,
        ),
      ))!;
      expect(settings.menopauseTracking, isTrue);
      expect(doctors, isEmpty);
      await unmount(tester);
    });

    testWidgets('period start answered in onboarding starts the estimate', (
      tester,
    ) async {
      tallScreen(tester);
      await toCycleStep(tester);
      await tester.tap(find.byKey(const ValueKey('onboarding-cycle')));
      await settle(tester);
      await tester.tap(find.byKey(const ValueKey('cycle-start-weeks-1')));
      await tester.pump();
      await tester.ensureVisible(find.byKey(const ValueKey('cycle-start-save')));
      await tester.tap(find.byKey(const ValueKey('cycle-start-save')));
      await settle(tester);
      await tester.tap(find.text('Weiter'));
      await settle(tester);
      await tester.tap(find.text('Los geht’s'));
      await settle(tester);

      final today = cycleDay(DateTime.now());
      final (settings, days) = (await tester.runAsync(
        () async => (
          await SettingsRepository(db).get(),
          await CycleRepository(db).allDays(),
        ),
      ))!;
      expect(settings.cycleSetupDone, isTrue);
      expect(settings.typicalCycleLength, 28);
      expect(days.map((r) => r.day), [
        for (var i = 0; i < 5; i++) dayKey(plusDays(today, -7 + i)),
      ]);
      // Startseite: Schätzung sofort (28 − 7 = 21 Tage).
      expect(
        find.textContaining('nächste Periode in ~21 Tagen'),
        findsOneWidget,
      );
      await unmount(tester);
    });

    testWidgets('"not for me" clears the choice', (tester) async {
      tallScreen(tester);
      await toCycleStep(tester);
      await tester.tap(find.byKey(const ValueKey('onboarding-cycle')));
      await settle(tester);
      await tester.tap(find.byKey(const ValueKey('cycle-start-later')));
      await settle(tester);
      await tester.tap(find.byKey(const ValueKey('onboarding-none')));
      await settle(tester);
      expect(find.byType(CheckboxListTile), findsNothing);
      await tester.tap(find.text('Überspringen'));
      await settle(tester);
      final settings = await tester.runAsync(
        () => SettingsRepository(db).get(),
      );
      expect(settings!.cycleTracking, isFalse);
      expect(find.byKey(const ValueKey('cycle-home-card')), findsNothing);
      await unmount(tester);
    });
  });

  testWidgets('cycle page: log flow + pain → calendar and insights update', (
    tester,
  ) async {
    tallScreen(tester);
    final today = cycleDay(DateTime.now());
    await tester.runAsync(() async {
      final repo = CycleRepository(db);
      await repo.setCycleTracking(true);
      // Zwei frühere Perioden (28 Tage Abstand) für die Auswertung.
      for (final start in [plusDays(today, -56), plusDays(today, -28)]) {
        for (var i = 0; i < 4; i++) {
          await repo.saveDay(
            plusDays(start, i),
            CycleDaysCompanion(
              flow: const Value(CycleFlow.medium),
              pain: Value(i == 0 ? 7 : null),
            ),
          );
        }
      }
    });
    await tester.pumpWidget(host(const CyclePage()));
    await settle(tester);
    expect(find.text('Heute erfassen'), findsOneWidget);
    expect(find.textContaining('Zyklustag 29'), findsOneWidget);
    // Bestandsnutzerin mit Perioden: kein Zyklus-Start.
    expect(find.byKey(const ValueKey('cycle-start-prompt')), findsNothing);
    expect(find.byKey(const ValueKey('cycle-start-add')), findsNothing);

    await tester.tap(find.byKey(const ValueKey('flow-medium')));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('cycle-pain')));
    await settle(tester);

    final row = await tester.runAsync(() => CycleRepository(db).getDay(today));
    expect(row!.flow, CycleFlow.medium);
    expect(row.pain, 5);
    expect(find.textContaining('Periode, Tag 1'), findsOneWidget);
    expect(find.textContaining('5/10 mittel'), findsOneWidget);

    await tester.tap(find.text('Kalender'));
    await settle(tester);
    final cell = find.byKey(ValueKey('cycle-cal-${dayKey(today)}'));
    expect(cell, findsOneWidget);
    expect(
      tester.getSemantics(cell).label,
      allOf(contains('heute'), contains('Mittel'), contains('Schmerz 5/10')),
    );

    await tester.tap(find.text('Auswertung'));
    await settle(tester);
    expect(find.text('Zykluslängen'), findsOneWidget);
    expect(find.textContaining('Median 28'), findsOneWidget);
    expect(find.text('Schmerz nach Zyklustag'), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('day page saves symptoms and shows the pregnancy hint', (
    tester,
  ) async {
    tallScreen(tester);
    await tester.runAsync(
      () => CycleRepository(db).apply(const CycleSetup(pregnancy: true)),
    );
    await tester.pumpWidget(host(const CyclePage()));
    await settle(tester);
    expect(find.textContaining('trag die letzte Periode'), findsWidgets);

    await tester.tap(find.byKey(const ValueKey('cycle-more')));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('flow-spotting')));
    await settle(tester);
    expect(
      find.textContaining('Blutungen in der Schwangerschaft'),
      findsOneWidget,
    );
    final nausea = find.widgetWithText(FilterChip, 'Übelkeit');
    await tester.scrollUntilVisible(
      nausea,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
    await tester.tap(nausea);
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('cycle-day-save')));
    await settle(tester);

    final row = await tester.runAsync(
      () => CycleRepository(db).getDay(DateTime.now()),
    );
    expect(row!.flow, CycleFlow.spotting);
    expect(row.symptoms, 'nausea');
    // Zurück auf „Heute“: dringlicher Hinweis sichtbar.
    expect(find.text('Bitte zeitnah ärztlich abklären lassen'), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('settings: existing users can enable tracking and add a doctor', (
    tester,
  ) async {
    tallScreen(tester);
    await tester.pumpWidget(
      host(
        Scaffold(
          body: SingleChildScrollView(
            child: StreamBuilder<AppSetting>(
              stream: SettingsRepository(db).watch(),
              builder: (context, snapshot) => snapshot.data == null
                  ? const SizedBox.shrink()
                  : CycleSettingsSection(settings: snapshot.data!),
            ),
          ),
        ),
      ),
    );
    await settle(tester);
    expect(find.text('Gynäkologie als Ärztin/Arzt anlegen'), findsNothing);
    await tester.tap(find.text('Periode/Zyklus tracken'));
    await settle(tester);
    // Zyklus-Start erscheint; „Später“ merkt sich das.
    expect(find.text('Wann hat deine letzte Periode begonnen?'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('cycle-start-later')));
    await settle(tester);
    final settings = (await tester.runAsync(
      () => SettingsRepository(db).get(),
    ))!;
    expect(settings.cycleTracking, isTrue);
    expect(settings.cycleSetupDone, isTrue);
    // Aus und wieder ein: nicht erneut fragen.
    await tester.tap(find.text('Periode/Zyklus tracken'));
    await settle(tester);
    await tester.tap(find.text('Periode/Zyklus tracken'));
    await settle(tester);
    expect(find.text('Wann hat deine letzte Periode begonnen?'), findsNothing);
    expect(find.text('Fruchtbares Fenster anzeigen'), findsOneWidget);

    await tester.tap(find.text('Gynäkologie als Ärztin/Arzt anlegen'));
    await settle(tester);
    expect(
      await tester.runAsync(() => DoctorRepository(db).watchAll().first),
      hasLength(1),
    );
    expect(find.text('Gynäkologie als Ärztin/Arzt anlegen'), findsNothing);
    await unmount(tester);
  });

  group('cycle start on "Heute"', () {
    testWidgets('2 weeks ago, 5 days, 30-day cycle → estimate right away', (
      tester,
    ) async {
      tallScreen(tester);
      final today = cycleDay(DateTime.now());
      await tester.runAsync(() => CycleRepository(db).setCycleTracking(true));
      await tester.pumpWidget(host(const CyclePage()));
      await settle(tester);
      expect(find.byKey(const ValueKey('cycle-start-prompt')), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('cycle-start-open')));
      await settle(tester);
      await tester.tap(find.byKey(const ValueKey('cycle-start-weeks-2')));
      await tester.pump();
      expect(find.text('5 Tage'), findsOneWidget, reason: 'Standarddauer');
      final plus = find.byKey(const ValueKey('cycle-start-length-plus'));
      await tester.ensureVisible(plus);
      await tester.tap(plus);
      await tester.pump();
      await tester.tap(plus);
      await tester.pump();
      expect(find.text('30 Tage'), findsOneWidget);
      await tester.ensureVisible(find.byKey(const ValueKey('cycle-start-save')));
      await tester.tap(find.byKey(const ValueKey('cycle-start-save')));
      await settle(tester);

      final start = plusDays(today, -14);
      final (days, settings) = (await tester.runAsync(
        () async => (
          await CycleRepository(db).allDays(),
          await SettingsRepository(db).get(),
        ),
      ))!;
      expect(days.map((r) => r.day), [
        for (var i = 0; i < 5; i++) dayKey(plusDays(start, i)),
      ]);
      expect(days.map((r) => r.flow).toSet(), {CycleFlow.medium});
      expect((settings.typicalCycleLength, settings.cycleSetupDone), (
        30,
        true,
      ));
      // Nächste Periode ≈ Beginn + 30 = heute + 16.
      expect(find.textContaining('Zyklustag 15'), findsOneWidget);
      expect(
        find.textContaining('nächste Periode in ~16 Tagen'),
        findsOneWidget,
      );
      expect(find.textContaining('anhand deiner Angaben'), findsOneWidget);
      expect(find.textContaining('keine Verhütungsmethode'), findsOneWidget);
      expect(find.byKey(const ValueKey('cycle-start-prompt')), findsNothing);

      await tester.tap(find.text('Kalender'));
      await settle(tester);
      final date = DateFormat('dd.MM.yyyy');
      expect(
        find.textContaining(date.format(plusDays(start, 27))),
        findsWidgets,
      );
      expect(
        find.textContaining(date.format(plusDays(start, 33))),
        findsWidgets,
      );
      await unmount(tester);
    });

    testWidgets('existing logged days are not overwritten', (tester) async {
      tallScreen(tester);
      final today = cycleDay(DateTime.now());
      await tester.runAsync(() async {
        final repo = CycleRepository(db);
        await repo.setCycleTracking(true);
        // Nur Schmierblutung → zählt nicht als Periode.
        await repo.saveDay(
          plusDays(today, -13),
          const CycleDaysCompanion(
            flow: Value(CycleFlow.spotting),
            pain: Value(3),
          ),
        );
      });
      await tester.pumpWidget(host(const CyclePage()));
      await settle(tester);
      await tester.tap(find.byKey(const ValueKey('cycle-start-open')));
      await settle(tester);
      await tester.tap(find.byKey(const ValueKey('cycle-start-weeks-2')));
      await tester.pump();
      await tester.ensureVisible(find.byKey(const ValueKey('cycle-start-save')));
      await tester.tap(find.byKey(const ValueKey('cycle-start-save')));
      await settle(tester);
      final kept = await tester.runAsync(
        () => CycleRepository(db).getDay(plusDays(today, -13)),
      );
      expect((kept!.flow, kept.pain), (CycleFlow.spotting, 3));
      expect(
        await tester.runAsync(() => CycleRepository(db).allDays()),
        hasLength(5),
      );
      await unmount(tester);
    });

    testWidgets('"Später" hides the prompt but keeps a way back', (
      tester,
    ) async {
      tallScreen(tester);
      await tester.runAsync(() => CycleRepository(db).setCycleTracking(true));
      await tester.pumpWidget(host(const CyclePage()));
      await settle(tester);
      await tester.tap(find.byKey(const ValueKey('cycle-start-prompt-later')));
      await settle(tester);
      expect(find.byKey(const ValueKey('cycle-start-prompt')), findsNothing);
      expect(find.byKey(const ValueKey('cycle-start-add')), findsOneWidget);
      final (settings, days) = (await tester.runAsync(
        () async => (
          await SettingsRepository(db).get(),
          await CycleRepository(db).allDays(),
        ),
      ))!;
      expect(settings.cycleSetupDone, isTrue);
      expect(days, isEmpty);

      // Später nachtragen; „Später“ im Sheet speichert nichts.
      await tester.tap(find.byKey(const ValueKey('cycle-start-add')));
      await settle(tester);
      await tester.tap(find.byKey(const ValueKey('cycle-start-later')));
      await settle(tester);
      expect(
        await tester.runAsync(() => CycleRepository(db).allDays()),
        isEmpty,
      );
      await unmount(tester);
    });

    testWidgets('settings: no setup when a period is already logged', (
      tester,
    ) async {
      tallScreen(tester);
      await tester.runAsync(
        () => CycleRepository(db).saveDay(
          DateTime.now(),
          const CycleDaysCompanion(flow: Value(CycleFlow.medium)),
        ),
      );
      await tester.pumpWidget(
        host(
          Scaffold(
            body: SingleChildScrollView(
              child: StreamBuilder<AppSetting>(
                stream: SettingsRepository(db).watch(),
                builder: (context, snapshot) => snapshot.data == null
                    ? const SizedBox.shrink()
                    : CycleSettingsSection(settings: snapshot.data!),
              ),
            ),
          ),
        ),
      );
      await settle(tester);
      await tester.tap(find.text('Periode/Zyklus tracken'));
      await settle(tester);
      expect(find.text('Wann hat deine letzte Periode begonnen?'), findsNothing);
      await unmount(tester);
    });
  });

  testWidgets('summary: cycle section defaults on for the gynecologist only', (
    tester,
  ) async {
    tallScreen(tester);
    final (gynAppointment, otherAppointment) = (await tester.runAsync(() async {
      final repo = CycleRepository(db);
      await repo.setCycleTracking(true);
      final gyn = await repo.ensureGynecologist();
      final other = await DoctorRepository(db)
          .create(name: 'Dr. Haus', specialty: 'Innere Medizin');
      final appointments = AppointmentRepository(db);
      return (
        await appointments.create(
          doctorId: gyn,
          scheduledAt: DateTime(2030, 1, 10, 9),
        ),
        await appointments.create(
          doctorId: other,
          scheduledAt: DateTime(2030, 1, 11, 9),
        ),
      );
    }))!;
    bool cycleSwitch() => tester
        .widget<SwitchListTile>(find.byKey(const ValueKey('summary-cycle')))
        .value;

    await tester.pumpWidget(
      host(VisitSummaryPage(appointmentId: gynAppointment)),
    );
    await settle(tester);
    await tester.ensureVisible(find.byKey(const ValueKey('summary-cycle')));
    expect(cycleSwitch(), isTrue);
    await unmount(tester);

    await tester.pumpWidget(
      host(VisitSummaryPage(appointmentId: otherAppointment)),
    );
    await settle(tester);
    await tester.ensureVisible(find.byKey(const ValueKey('summary-cycle')));
    expect(cycleSwitch(), isFalse);
    await unmount(tester);
  });
}
