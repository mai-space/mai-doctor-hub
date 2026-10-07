import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/database_provider.dart';
import 'package:mai_doctor_hub/data/measure_units.dart';
import 'package:mai_doctor_hub/data/repositories/settings_repository.dart';
import 'package:mai_doctor_hub/data/repositories/symptom_repository.dart';
import 'package:mai_doctor_hub/data/symptom_descriptors.dart';
import 'package:mai_doctor_hub/data/symptom_measure.dart';
import 'package:mai_doctor_hub/features/check_in/check_in_sheet.dart';
import 'package:mai_doctor_hub/features/records/detail_pages.dart';
import 'package:mai_doctor_hub/features/records/entity_forms.dart';
import 'package:mai_doctor_hub/features/settings/units_section.dart';
import 'package:mai_doctor_hub/services/assistant/record_context.dart';
import 'package:mai_doctor_hub/services/visit_summary.dart';
import 'package:mai_doctor_hub/theme/app_theme.dart';

void main() {
  late AppDatabase db;

  setUpAll(() => initializeDateFormatting('de'));
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() async {
    AppUnits.reset();
    await db.close();
  });

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 6; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 10)),
      );
      await tester.pump(const Duration(milliseconds: 100));
    }
    await tester.pump(const Duration(milliseconds: 400));
  }

  void bigScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
  }

  Widget host(Widget child) => DatabaseScope(
    database: db,
    child: MaterialApp(theme: AppTheme.light(), home: child),
  );

  Widget launcher(void Function(BuildContext) open) => host(
    Builder(
      builder: (context) => Scaffold(
        body: TextButton(
          onPressed: () => open(context),
          child: const Text('open'),
        ),
      ),
    ),
  );

  /// Senkrechte Liste der Detailseite bis [finder] scrollen.
  Future<void> scrollTo(WidgetTester tester, Finder finder) =>
      tester.scrollUntilVisible(
        finder,
        300,
        scrollable: find
            .byWidgetPredicate(
              (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
            )
            .first,
      );

  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('Fieber: temperature suggested, 38,4 °C stored canonically, '
      'shown in °F after switching units', (tester) async {
    bigScreen(tester);
    await tester.pumpWidget(launcher((c) => showSymptomForm(c)));
    await tester.tap(find.text('open'));
    await settle(tester);

    final name = find.widgetWithText(TextField, 'Bezeichnung');
    await tester.runAsync(() async {
      await tester.enterText(name, 'Fieber');
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pumpAndSettle();
    // Vorschlag „Wie messen?“ aus dem Namen.
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('symptom-measure')),
        matching: find.text('Temperatur'),
      ),
      findsOneWidget,
    );
    // Vorschläge der Autovervollständigung schließen, dann speichern.
    await tester.tap(find.text('Wie messen?'));
    await settle(tester);
    expect(
      tester
          .widget<ChoiceChip>(find.byKey(const ValueKey('measure-temperature')))
          .selected,
      isTrue,
    );
    await tester.tap(find.text('Übernehmen'));
    await settle(tester);
    await tester.tap(find.text('Speichern'));
    await settle(tester);

    final symptom = (await tester.runAsync(
      () => db.select(db.symptoms).getSingle(),
    ))!;
    expect(symptom.label, 'Fieber');
    expect(symptom.measure, 'temperature');

    // Check-in: Temperatur eintippen (deutsches Komma).
    await tester.pumpWidget(launcher((c) => showCheckInSheet(c)));
    await tester.tap(find.text('open'));
    await settle(tester);
    final field = find.byKey(const ValueKey('measure-field-temperature'));
    expect(field, findsOneWidget);
    await tester.enterText(field, '38,4');
    await tester.pump();
    expect(find.text('Fieber'), findsWidgets);
    await tester.tap(find.text('Speichern'));
    await settle(tester);

    final o = (await tester.runAsync(
      () => SymptomRepository(db).latestObservation(symptom.id),
    ))!;
    expect(o.kind, ObservationKind.measurement);
    expect(o.measure, 'temperature');
    expect(o.valueNumber, closeTo(38.4, 1e-9));
    expect(o.unit, '°C');

    // Einstellungen → Einheiten → °F.
    await tester.pumpWidget(
      host(
        Scaffold(
          body: StreamBuilder<AppSetting>(
            stream: SettingsRepository(db).watch(),
            builder: (context, snapshot) => snapshot.data == null
                ? const SizedBox.shrink()
                : UnitsSection(settings: snapshot.data!),
          ),
        ),
      ),
    );
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('unit-fahrenheit')));
    await settle(tester);
    expect(AppUnits.current.temperature, TemperatureUnit.fahrenheit);
    final settings = (await tester.runAsync(
      () => SettingsRepository(db).get(),
    ))!;
    expect(settings.temperatureUnit, 'fahrenheit');
    // Gespeichert bleibt °C.
    expect(
      (await tester.runAsync(
        () => SymptomRepository(db).latestObservation(symptom.id),
      ))!.valueNumber,
      closeTo(38.4, 1e-9),
    );

    await tester.pumpWidget(host(SymptomDetailPage(symptomId: symptom.id)));
    await settle(tester);
    await scrollTo(tester, find.textContaining('101,1 °F'));
    expect(find.textContaining('101,1 °F'), findsWidgets);
    expect(find.textContaining('38,4 °C'), findsNothing);
    await unmount(tester);
  });

  testWidgets('mood check-in with extras and journal', (tester) async {
    bigScreen(tester);
    final id = (await tester.runAsync(
      () => SymptomRepository(db).create(
        label: 'Niedergeschlagenheit',
        sensation: 'Niedergeschlagenheit',
        measures: (primary: SymptomMeasure.mood, secondary: null),
      ),
    ))!;
    await tester.pumpWidget(launcher((c) => showCheckInSheet(c)));
    await tester.tap(find.text('open'));
    await settle(tester);

    expect(
      find.text('0 ausgeglichen — Weder gedrückt noch aufgedreht'),
      findsOneWidget,
    );
    // Nach links: gedrückt.
    await tester.drag(
      find.byKey(const ValueKey('mood-slider')),
      const Offset(-120, 0),
    );
    await tester.pump();
    expect(find.textContaining('gedrückt'), findsWidgets);

    // Extras: Schlaf + 0,5 h ab 7 h.
    await tester.tap(find.text('Energie, Schlaf, Angst'));
    await tester.pump();
    await tester.tap(find.byTooltip('Mehr').last);
    await tester.pump();
    expect(find.text('7,5 h'), findsOneWidget);

    // Tagebuch ist bei psychischen Symptomen schon offen.
    await tester.tap(find.text('Was hat heute geholfen?'));
    await tester.pump();
    final journal = find.byKey(ValueKey('journal-$id'));
    expect(
      tester.widget<TextField>(journal).controller!.text,
      'Was hat heute geholfen? ',
    );
    await tester.enterText(journal, 'Was hat heute geholfen? Spaziergang');
    await tester.pump();
    expect(find.byKey(const ValueKey('support-card')), findsNothing);
    await tester.tap(find.text('Speichern'));
    await settle(tester);

    final o = (await tester.runAsync(
      () => SymptomRepository(db).latestObservation(id),
    ))!;
    expect(o.kind, ObservationKind.measurement);
    expect(o.measure, 'mood');
    expect(o.valueNumber, lessThan(0));
    expect(o.sleepHours, 7.5);
    expect(o.journal, 'Was hat heute geholfen? Spaziergang');
    expect(o.note, isNull, reason: 'Tagebuch getrennt von der Notiz');

    // Detailseite: Tagebuch-Liste, Eintrag lesen.
    await tester.pumpWidget(host(SymptomDetailPage(symptomId: id)));
    await settle(tester);
    expect(find.text('Psyche: Fragebögen & Verlauf'), findsOneWidget);
    await scrollTo(tester, find.text('Was hat heute geholfen? Spaziergang'));
    expect(find.text('Tagebuch'), findsOneWidget);
    await tester.ensureVisible(
      find.text('Was hat heute geholfen? Spaziergang'),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Was hat heute geholfen? Spaziergang'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.tap(find.text('Schließen'));
    await tester.pumpAndSettle();
    await unmount(tester);

    // Arzt-PDF: Tagebuch nur auf Wunsch; Assistent bekommt es kurz.
    final builder = VisitSummaryBuilder(db);
    final without = (await tester.runAsync(
      () => builder.build(const VisitSummaryOptions()),
    ))!;
    expect(without.includeJournal, isFalse);
    final withJournal = (await tester.runAsync(
      () => builder.build(const VisitSummaryOptions(includeJournal: true)),
    ))!;
    expect(withJournal.includeJournal, isTrue);
    for (final data in [without, withJournal]) {
      final pdf = (await tester.runAsync(() => VisitSummaryPdf.render(data)))!;
      expect(pdf, isNotEmpty);
    }
    final context = (await tester.runAsync(
      () => AssistantContextBuilder(db).build('Wie war meine Stimmung?'),
    ))!;
    expect(context, contains('Tagebuch'));
    expect(context, contains('Spaziergang'));
  });

  testWidgets('self-harm thoughts > 0: calm support card with phone numbers', (
    tester,
  ) async {
    bigScreen(tester);
    await tester.runAsync(
      () => SymptomRepository(db).create(
        label: selfHarmThoughts.$1,
        sensation: selfHarmThoughts.$1,
        measures: (primary: SymptomMeasure.intensity, secondary: null),
      ),
    );
    await tester.pumpWidget(launcher((c) => showCheckInSheet(c)));
    await tester.tap(find.text('open'));
    await settle(tester);
    // Vorbelegt mit Stärke 5 → Hilfsangebot direkt sichtbar.
    expect(find.byKey(const ValueKey('support-card')), findsOneWidget);
    expect(
      find.text('TelefonSeelsorge (24/7): 0800 111 0 111'),
      findsOneWidget,
    );
    expect(find.text('Bei akuter Gefahr: Notruf 112'), findsOneWidget);

    // Auf 0 → Karte verschwindet.
    await tester.drag(find.byType(Slider), const Offset(-800, 0));
    await tester.pump();
    expect(find.byKey(const ValueKey('support-card')), findsNothing);
    await tester.drag(find.byType(Slider), const Offset(100, 0));
    await tester.pump();
    await tester.tap(find.text('Speichern'));
    await settle(tester);
    // Nach dem Speichern noch einmal als Dialog.
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byKey(const ValueKey('support-card')), findsOneWidget);
    await tester.tap(find.text('Schließen'));
    await tester.pumpAndSettle();
    await unmount(tester);
  });

  testWidgets('building blocks compose the name; manual edits are kept', (
    tester,
  ) async {
    bigScreen(tester);
    await tester.pumpWidget(launcher((c) => showSymptomForm(c)));
    await tester.tap(find.text('open'));
    await settle(tester);

    Future<void> tapAsync(Finder f) async {
      await tester.runAsync(() async {
        await tester.tap(f);
        await Future<void>.delayed(const Duration(milliseconds: 50));
      });
      await settle(tester);
    }

    await tapAsync(find.byTooltip('Charakter'));
    await tester.tap(find.widgetWithText(FilterChip, 'brennend'));
    await tester.pump();
    await tapAsync(find.text('Übernehmen'));
    await tapAsync(find.byTooltip('Empfindung'));
    await tapAsync(find.widgetWithText(ChoiceChip, 'Schmerz'));
    await tapAsync(find.byTooltip('Ort'));
    await tapAsync(find.widgetWithText(ChoiceChip, 'Hinterkopf'));
    await tapAsync(find.byTooltip('Seite'));
    await tapAsync(find.text('links'));

    final name = find.widgetWithText(TextField, 'Bezeichnung');
    String text() => tester.widget<TextField>(name).controller!.text;
    expect(text(), 'Brennender Schmerz am Hinterkopf (links)');
    expect(find.text('Aus Bausteinen neu erzeugen'), findsNothing);

    // Eigener Name wird nicht überschrieben.
    await tester.runAsync(() async {
      await tester.enterText(name, 'Mein Kopf');
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await settle(tester);
    await tapAsync(find.byTooltip('Seite'));
    await tapAsync(find.text('rechts'));
    expect(text(), 'Mein Kopf');
    await tapAsync(find.text('Aus Bausteinen neu erzeugen'));
    expect(text(), 'Brennender Schmerz am Hinterkopf (rechts)');

    await tapAsync(find.text('Speichern'));
    final s = (await tester.runAsync(
      () => db.select(db.symptoms).getSingle(),
    ))!;
    expect(s.label, 'Brennender Schmerz am Hinterkopf (rechts)');
    expect(
      (s.sensation, s.quality, s.bodyRegion, s.side, s.measure),
      ('Schmerz', 'brennend', 'Hinterkopf', 'right', 'intensity'),
    );
    await unmount(tester);
  });
}
