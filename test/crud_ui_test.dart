import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/repositories/appointment_repository.dart';
import 'package:mai_doctor_hub/data/repositories/doctor_repository.dart';
import 'package:mai_doctor_hub/data/repositories/records_repository.dart';
import 'package:mai_doctor_hub/data/repositories/symptom_repository.dart';
import 'package:mai_doctor_hub/features/records/detail_pages.dart';
import 'package:mai_doctor_hub/main.dart';

import 'helpers/test_env.dart';

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
      await tester.pump(const Duration(milliseconds: 50));
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

  Future<void> openAkte(WidgetTester tester) async {
    await tester.tap(find.text('Meine Akte'));
    await settle(tester);
  }

  testWidgets('archive undo snackbar dismisses itself', (tester) async {
    await tester.runAsync(
      () => RecordsRepository(db).createDiagnosis(title: 'Asthma'),
    );
    await pumpApp(tester);
    await openAkte(tester);
    await tester.tap(find.text('Asthma'));
    await settle(tester);
    await tester.tap(find.byTooltip('Löschen (ins Archiv)'));
    await settle(tester);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Diagnose im Archiv'), findsOneWidget);

    await tester.pump(const Duration(seconds: 7));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Diagnose im Archiv'), findsNothing);
    await disposeApp(tester);
  });

  testWidgets('Akte: open diagnosis hub, edit title, archive, undo', (tester) async {
    late String diagnosisId;
    await tester.runAsync(() async {
      final records = RecordsRepository(db);
      diagnosisId = await records.createDiagnosis(title: 'Migräne');
      await records.createMedication(
        name: 'Triptan',
        diagnosisId: diagnosisId,
      );
    });
    await pumpApp(tester);
    await openAkte(tester);

    await tester.tap(find.text('Migräne'));
    await settle(tester);
    Finder inHub(Finder f) =>
        find.descendant(of: find.byType(DiagnosisDetailPage), matching: f);
    expect(inHub(find.text('Triptan')), findsOneWidget);
    expect(inHub(find.text('aktiv')), findsOneWidget);

    await tester.tap(find.byTooltip('Bearbeiten'));
    await settle(tester);
    await tester.enterText(
      find.widgetWithText(TextField, 'Migräne'),
      'Migräne mit Aura',
    );
    await tester.tap(find.text('Speichern'));
    await settle(tester);
    expect(inHub(find.text('Migräne mit Aura')), findsOneWidget);

    await tester.tap(find.byTooltip('Löschen (ins Archiv)'));
    await settle(tester);
    await tester.pump(const Duration(seconds: 1)); // Route-Animation

    expect(find.byType(DiagnosisDetailPage), findsNothing);
    expect(find.text('Diagnose im Archiv'), findsOneWidget);
    // Aus der Akte verschwunden, aber nicht gelöscht.
    expect(find.text('Migräne mit Aura'), findsNothing);
    var row = await tester.runAsync(
      () => RecordsRepository(db).getDiagnosis(diagnosisId),
    );
    expect(row!.archivedAt, isNotNull);

    await tester.tap(find.text('Rückgängig'));
    await settle(tester);
    row = await tester.runAsync(
      () => RecordsRepository(db).getDiagnosis(diagnosisId),
    );
    expect(row!.archivedAt, isNull);
    expect(find.text('Migräne mit Aura'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('Termin: absagen zeigt Status, entfernt „Bericht fehlt“', (
    tester,
  ) async {
    await tester.runAsync(() async {
      final doctorId = await DoctorRepository(db).create(name: 'Dr. Ost');
      await AppointmentRepository(db).create(
        doctorId: doctorId,
        scheduledAt: DateTime.now().subtract(const Duration(days: 1)),
        title: 'Röntgen',
      );
    });
    await pumpApp(tester);
    // Vergangene Termine liegen oberhalb des „Jetzt“-Ankers.
    await tester.drag(find.byType(CustomScrollView), const Offset(0, 400));
    await settle(tester);
    expect(find.text('Bericht fehlt'), findsOneWidget);

    await tester.tap(find.text('Röntgen'));
    await settle(tester);
    await tester.tap(find.byIcon(Icons.more_vert));
    await settle(tester);
    await tester.tap(find.text('Absagen'));
    await settle(tester);
    expect(find.text('Abgesagt'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await settle(tester);
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('Bericht fehlt'), findsNothing);
    expect(find.text('Abgesagt'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('Symptom: Verlauf und als geheilt markieren', (tester) async {
    late String symptomId;
    await tester.runAsync(() async {
      final symptoms = SymptomRepository(db);
      symptomId = await symptoms.create(label: 'Kopfschmerz');
      for (final v in [7.0, 5.0, 2.0]) {
        await symptoms.addObservation(
          symptomId: symptomId,
          kind: ObservationKind.scale_1_10,
          valueNumber: v,
        );
      }
    });
    await pumpApp(tester);
    await openAkte(tester);
    await tester.tap(find.text('Kopfschmerz'));
    await settle(tester);

    expect(find.bySemanticsLabel(RegExp('zuletzt 2 von 10')), findsOneWidget);
    // Check-ins stehen unter Belegen und Kalender.
    // Senkrechte Liste der Detailseite (nicht die verdeckte Akte dahinter).
    final scrollable = find
        .byWidgetPredicate(
          (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
        )
        .hitTestable()
        .first;
    await tester.scrollUntilVisible(
      find.text('Stärke 2/10'),
      300,
      scrollable: scrollable,
    );
    expect(find.text('Stärke 2/10'), findsOneWidget);
    // Zurück nach oben (sonst liegt der Knopf ggf. unter der App-Leiste).
    await tester.drag(scrollable, const Offset(0, 5000));
    await settle(tester);

    await tester.tap(find.text('Als geheilt markieren'));
    await settle(tester);
    expect(find.text('Wieder aktiv'), findsOneWidget);
    final symptom = await tester.runAsync(
      () => SymptomRepository(db).getById(symptomId),
    );
    expect(symptom!.healedAt, isNotNull);
    await disposeApp(tester);
  });

  testWidgets('Akte-Suche filtert nach Typ', (tester) async {
    await tester.runAsync(() async {
      final records = RecordsRepository(db);
      await records.createNote(body: 'Allergie Pollen');
      await records.createDiagnosis(title: 'Allergie');
    });
    await pumpApp(tester);
    await openAkte(tester);

    await tester.enterText(find.byType(SearchBar), 'Allerg');
    await tester.pump(const Duration(milliseconds: 300));
    await settle(tester);
    expect(find.textContaining('Notiz'), findsWidgets);

    await tester.tap(find.widgetWithText(FilterChip, 'Diagnosen'));
    await settle(tester);
    expect(find.textContaining('Notiz ·'), findsNothing);
    expect(find.text('Allergie'), findsOneWidget);
    await disposeApp(tester);
  });

  testWidgets('Bericht: fehlende Datei, umbenennen', (tester) async {
    await tester.runAsync(
      () => RecordsRepository(db).createReport(
        title: 'scan.pdf',
        mimeType: 'application/pdf',
        localPath: '/does/not/exist.pdf',
        source: ReportSource.pdf,
      ),
    );
    await pumpApp(tester);
    await openAkte(tester);
    await tester.tap(find.text('scan.pdf'));
    await settle(tester);
    expect(find.text('Datei nicht verfügbar'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.more_vert));
    await settle(tester);
    await tester.tap(find.text('Umbenennen'));
    await settle(tester);
    await tester.enterText(find.byType(TextField).last, 'MRT Knie');
    await tester.tap(find.text('Speichern'));
    await settle(tester);
    expect(find.text('MRT Knie'), findsWidgets);
    await disposeApp(tester);
  });
}
