import 'package:drift/drift.dart' show Variable;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/database_provider.dart';
import 'package:mai_doctor_hub/data/repositories/archive_repository.dart';
import 'package:mai_doctor_hub/data/repositories/records_repository.dart';
import 'package:mai_doctor_hub/data/repositories/symptom_repository.dart';
import 'package:mai_doctor_hub/data/symptom_measure.dart';
import 'package:mai_doctor_hub/features/records/detail_pages.dart';
import 'package:mai_doctor_hub/features/records/entity_forms.dart';
import 'package:mai_doctor_hub/l10n/l10n.dart';
import 'package:mai_doctor_hub/services/assistant/record_context.dart';
import 'package:mai_doctor_hub/services/visit_summary.dart';
import 'package:mai_doctor_hub/theme/app_theme.dart';
import 'package:mai_doctor_hub/widgets/symptom_heatmap.dart';

/// v16: Tagebuch in der Suche, Verlauf über Messgrößen-Wechsel hinweg.
void main() {
  late AppDatabase db;
  late SymptomRepository repo;
  final now = DateTime(2026, 10, 7, 12);

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = SymptomRepository(db);
  });
  tearDown(() => db.close());

  SymptomObservation obs(
    String id,
    DateTime at, {
    ObservationKind kind = ObservationKind.scale_1_10,
    double? value,
    String? measure,
    String? measure2,
    double? secondary,
  }) => SymptomObservation(
    id: id,
    symptomId: 's',
    recordedAt: at,
    kind: kind,
    valueNumber: value,
    measure: measure,
    measure2: measure2,
    secondaryValue: secondary,
  );

  Future<List<String>> journalHits(String query) async => [
    for (final r in await RecordsRepository(db).search(query))
      if (r.read<String>('entity_type') == 'journal')
        r.read<String>('entity_id'),
  ];

  group('journal search index', () {
    test('add, rename, delete observation, archive, delete symptom', () async {
      final id = await repo.create(label: 'Stimmung');
      final o1 = await repo.addMeasurement(
        symptomId: id,
        measure: SymptomMeasure.mood,
        value: -1,
        journal: '  Langer Spaziergang am Fluss  ',
        recordedAt: DateTime(2026, 9, 14, 20),
      );
      final o2 = await repo.addMeasurement(
        symptomId: id,
        measure: SymptomMeasure.mood,
        value: 1,
        journal: '   ',
      );
      expect(await journalHits('Fluss'), [o1]);
      final row = (await RecordsRepository(db).search('Fluss')).single;
      expect(row.read<String>('title'), 'Stimmung · 14. Sept. 2026');
      expect(row.read<String>('body'), 'Langer Spaziergang am Fluss');
      final empty = await db
          .customSelect(
            "SELECT 1 FROM records_fts WHERE entity_type = 'journal' "
            'AND entity_id = ?',
            variables: [Variable.withString(o2)],
          )
          .get();
      expect(empty, isEmpty, reason: 'leeres Tagebuch nicht im Index');

      // Umbenennen → Titel der Treffer folgt.
      await repo.update(id: id, label: 'Laune');
      expect(
        (await RecordsRepository(db).search('Fluss')).single
            .read<String>('title'),
        startsWith('Laune · '),
      );

      // Archiviert: nicht gefunden (auch nicht vom Assistenten), danach wieder.
      final archive = ArchiveRepository(db);
      await archive.archive('symptom', id);
      expect(await journalHits('Fluss'), isEmpty);
      expect(
        await RecordsRepository(db).archivedKeys(),
        contains('journal:$o1'),
      );
      expect(await RecordsRepository(db).searchAny(['spaziergang']), isEmpty);
      await archive.restore('symptom', id);
      expect(await journalHits('Fluss'), [o1]);

      await repo.deleteObservation(o1);
      expect(await journalHits('Fluss'), isEmpty);

      await repo.addObservation(
        symptomId: id,
        kind: ObservationKind.note,
        journal: 'Regen am Fluss',
      );
      expect(await journalHits('Regen'), hasLength(1));
      await repo.delete(id);
      final left = await db
          .customSelect(
            "SELECT 1 FROM records_fts WHERE entity_type = 'journal'",
          )
          .get();
      expect(left, isEmpty);
    });

    test('assistant labels journal hits', () async {
      final id = await repo.create(label: 'Stimmung');
      await repo.addMeasurement(
        symptomId: id,
        measure: SymptomMeasure.mood,
        value: 0,
        journal: 'Gartenarbeit hat geholfen',
      );
      final context = await AssistantContextBuilder(db)
          .build('Was war mit Gartenarbeit?');
      expect(context, contains('[Tagebuch-Eintrag] Stimmung · '));
      expect(context, contains('Gartenarbeit hat geholfen'));
    });
  });

  group('measure history', () {
    test('sections: current first, earlier ones with range', () {
      final history = [
        obs('a', DateTime(2026, 9, 1), value: 6),
        obs('b', DateTime(2026, 9, 3), value: 4),
        obs(
          'c',
          DateTime(2026, 9, 5),
          kind: ObservationKind.measurement,
          value: 3,
          measure: 'count',
        ),
        obs(
          'd',
          DateTime(2026, 9, 10),
          kind: ObservationKind.measurement,
          value: 38.2,
          measure: 'temperature',
          measure2: 'pulse',
          secondary: 96,
        ),
        obs('e', DateTime(2026, 9, 11), kind: ObservationKind.note),
      ];
      final sections = measureSections((
        primary: SymptomMeasure.temperature,
        secondary: null,
      ), history);
      expect(
        [for (final s in sections) (s.measure, s.current, s.count)],
        [
          (SymptomMeasure.temperature, true, 1),
          (SymptomMeasure.pulse, false, 1),
          (SymptomMeasure.count, false, 1),
          (SymptomMeasure.intensity, false, 2),
        ],
      );
      final intensity = sections.last;
      expect(
        (intensity.from, intensity.to),
        (DateTime(2026, 9, 1), DateTime(2026, 9, 3)),
      );
      // Aktuelle Größe ohne Werte bleibt als Abschnitt.
      expect(
        measureSections((
          primary: SymptomMeasure.glucose,
          secondary: SymptomMeasure.intensity,
        ), history).take(2).map((s) => (s.measure, s.current, s.count)),
        [
          (SymptomMeasure.glucose, true, 0),
          (SymptomMeasure.intensity, true, 2),
        ],
      );
      expect(
        measuresLeftBehind(history, (
          primary: SymptomMeasure.temperature,
          secondary: SymptomMeasure.pulse,
        )),
        {SymptomMeasure.intensity: 2, SymptomMeasure.count: 1},
      );
      expect(
        measuresLeftBehind(
          [history.first],
          (primary: SymptomMeasure.intensity, secondary: null),
        ),
        isEmpty,
      );
    });

    test('converter table: identity only, unknown pairs refused', () async {
      expect(
        measureConverter(SymptomMeasure.intensity, SymptomMeasure.intensity)!(
          7,
        ),
        7,
      );
      expect(
        measureConverter(SymptomMeasure.intensity, SymptomMeasure.count),
        isNull,
      );
      expect(
        measureConverters,
        isEmpty,
        reason: 'keine erfundenen Umrechnungen',
      );

      // Mit eingetragener Umrechnung rechnet das Repository um.
      final id = await repo.create(label: 'Test');
      await repo.addMeasurement(
        symptomId: id,
        measure: SymptomMeasure.duration,
        value: 30,
      );
      await repo.addMeasurement(
        symptomId: id,
        measure: SymptomMeasure.intensity,
        value: 4,
      );
      measureConverters[(SymptomMeasure.duration, SymptomMeasure.count)] = (
        v,
      ) => v;
      addTearDown(measureConverters.clear);
      expect(await repo.convertObservations(id, SymptomMeasure.count), 1);
      final all = await repo.watchObservations(id).first;
      expect(
        [for (final o in all) observationMeasure(o)],
        [SymptomMeasure.count, SymptomMeasure.intensity],
      );
    });

    test('heatmap colors each day by its own measure, max when mixed', () {
      final day1 = DateTime(2026, 9, 1, 9);
      final day2 = DateTime(2026, 9, 2, 9);
      final history = [
        obs('a', day1, value: 8),
        obs(
          'b',
          day1.add(const Duration(hours: 2)),
          kind: ObservationKind.measurement,
          value: 37.0,
          measure: 'temperature',
        ),
        obs(
          'c',
          day2,
          kind: ObservationKind.measurement,
          value: 39.2,
          measure: 'temperature',
        ),
        obs('d', day2.add(const Duration(hours: 1)), value: 2),
      ];
      final mixed = dailySeverityMixed(history, SymptomMeasure.temperature);
      final d1 = mixed[DateTime(2026, 9, 1)]!;
      expect((d1.measure, d1.day.severity), (SymptomMeasure.intensity, 8.0));
      final d2 = mixed[DateTime(2026, 9, 2)]!;
      expect((d2.measure, d2.day.severity), (SymptomMeasure.temperature, 8.0));
      // Nur alte Werte: Tag trotzdem eingefärbt.
      expect(
        dailySeverityMixed([history.first], SymptomMeasure.temperature),
        hasLength(1),
      );
    });

    test('doctor PDF and assistant keep earlier measure values', () async {
      final id = await repo.create(label: 'Kopfschmerz');
      for (final (i, v) in [6.0, 4.0].indexed) {
        await repo.addMeasurement(
          symptomId: id,
          measure: SymptomMeasure.intensity,
          value: v,
          recordedAt: now.subtract(Duration(days: 10 - i)),
        );
      }
      await repo.update(
        id: id,
        label: 'Kopfschmerz',
        measures: (primary: SymptomMeasure.temperature, secondary: null),
      );
      await repo.addMeasurement(
        symptomId: id,
        measure: SymptomMeasure.temperature,
        value: 38.4,
        recordedAt: now.subtract(const Duration(days: 1)),
      );
      final data = await VisitSummaryBuilder(db)
          .build(const VisitSummaryOptions(), now: now);
      final trend = data.symptoms.single;
      expect(trend.measure, SymptomMeasure.temperature);
      expect(trend.stats!.last, 38.4);
      final earlier = trend.earlierSections.single;
      expect((earlier.measure, earlier.count), (SymptomMeasure.intensity, 2));
      final line = trend.earlierLine(
        earlier,
        AppLocale.strings,
        DateFormat('d.M.'),
      );
      expect(line, startsWith('Früher erfasst: Stärke 0–10 (27.9. – 28.9.): '));
      expect(line, contains('Ø 5,0/10'));
      expect(await VisitSummaryPdf.render(data), isNotEmpty);

      final context = await AssistantContextBuilder(db)
          .build('Wie geht es mir?', now: now);
      expect(context, contains('Temperatur'));
      expect(context, contains('Früher erfasst: Stärke 0–10'));
    });
  });

  group('UI', () {
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

    Widget launcher(void Function(BuildContext) open) => DatabaseScope(
      database: db,
      child: MaterialApp(
        theme: AppTheme.light(),
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => open(context),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    Future<void> unmount(WidgetTester tester) async {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 100));
    }

    testWidgets('detail page: one chart per recorded measure', (tester) async {
      bigScreen(tester);
      final id = (await tester.runAsync(() async {
        final id = await repo.create(
          label: 'Fieber',
          measures: (primary: SymptomMeasure.temperature, secondary: null),
        );
        await repo.addMeasurement(
          symptomId: id,
          measure: SymptomMeasure.intensity,
          value: 5,
          recordedAt: DateTime(2026, 9, 1),
        );
        await repo.addMeasurement(
          symptomId: id,
          measure: SymptomMeasure.temperature,
          value: 38.5,
          recordedAt: DateTime(2026, 9, 20),
        );
        return id;
      }))!;
      await tester.pumpWidget(
        DatabaseScope(
          database: db,
          child: MaterialApp(
            theme: AppTheme.light(),
            home: SymptomDetailPage(symptomId: id),
          ),
        ),
      );
      await settle(tester);
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('measure-chart-intensity')),
        300,
        scrollable: find
            .byWidgetPredicate(
              (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
            )
            .first,
      );
      expect(
        find.byKey(const ValueKey('measure-chart-temperature')),
        findsOneWidget,
      );
      expect(find.text('Früher erfasst: Stärke 0–10'), findsOneWidget);
      expect(find.textContaining('1 Check-in'), findsWidgets);
      await unmount(tester);
    });

    testWidgets('measure change dialog only when old check-ins differ', (
      tester,
    ) async {
      bigScreen(tester);
      final (withHistory, without) = (await tester.runAsync(() async {
        final a = await repo.create(label: 'Kopfschmerz');
        await repo.addMeasurement(
          symptomId: a,
          measure: SymptomMeasure.intensity,
          value: 5,
        );
        final b = await repo.create(label: 'Neu');
        return (a, b);
      }))!;

      Future<void> pickTemperature(String symptomId) async {
        final symptom = (await tester.runAsync(() => repo.getById(symptomId)))!;
        await tester.pumpWidget(
          launcher((c) => showSymptomForm(c, symptom: symptom)),
        );
        await tester.tap(find.text('open'));
        await settle(tester);
        await tester.tap(find.byKey(const ValueKey('symptom-measure')));
        await settle(tester);
        await tester.tap(find.byKey(const ValueKey('measure-temperature')));
        await tester.pump();
        await tester.tap(find.text('Übernehmen'));
        await settle(tester);
      }

      // Ohne Check-ins: kein Dialog.
      await pickTemperature(without);
      expect(find.byKey(const ValueKey('measure-change-dialog')), findsNothing);
      await tester.tap(find.text('Speichern'));
      await settle(tester);
      expect(
        (await tester.runAsync(() => repo.getById(without)))!.measure,
        'temperature',
      );

      // Mit Stärke-Check-ins: Hinweis, Abbrechen lässt die Messgröße.
      await pickTemperature(withHistory);
      final dialog = find.byKey(const ValueKey('measure-change-dialog'));
      expect(dialog, findsOneWidget);
      expect(
        find.descendant(
          of: dialog,
          matching: find.textContaining('Stärke 0–10: 1'),
        ),
        findsOneWidget,
      );
      // Keine erfundene Umrechnung.
      expect(find.text('Ändern und umrechnen'), findsNothing);
      await tester.tap(
        find.descendant(of: dialog, matching: find.text('Abbrechen')),
      );
      await settle(tester);
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('symptom-measure')),
          matching: find.text('Stärke 0–10'),
        ),
        findsOneWidget,
      );

      // Erneut wählen, „Ändern“ → gespeichert, alte Werte unverändert.
      await tester.tap(find.byKey(const ValueKey('symptom-measure')));
      await settle(tester);
      await tester.tap(find.byKey(const ValueKey('measure-temperature')));
      await tester.pump();
      await tester.tap(find.text('Übernehmen'));
      await settle(tester);
      await tester.tap(
        find.descendant(of: dialog, matching: find.text('Ändern')),
      );
      await settle(tester);
      await tester.tap(find.text('Speichern'));
      await settle(tester);
      final saved = (await tester.runAsync(() => repo.getById(withHistory)))!;
      expect(saved.measure, 'temperature');
      final old = (await tester.runAsync(
        () => repo.latestObservation(withHistory),
      ))!;
      expect((old.kind, old.valueNumber), (ObservationKind.scale_1_10, 5));
      await unmount(tester);
    });

    testWidgets('journal search hit opens symptom with the entry', (
      tester,
    ) async {
      bigScreen(tester);
      final observationId = (await tester.runAsync(() async {
        final id = await repo.create(
          label: 'Stimmung',
          measures: (primary: SymptomMeasure.mood, secondary: null),
        );
        return repo.addMeasurement(
          symptomId: id,
          measure: SymptomMeasure.mood,
          value: 1,
          journal: 'Konzert mit Freunden',
        );
      }))!;
      final hit = (await tester.runAsync(
        () => RecordsRepository(db).search('Konzert'),
      ))!.single;
      expect(hit.read<String>('entity_type'), 'journal');

      await tester.pumpWidget(
        launcher(
          (c) => openRecord(
            c,
            hit.read<String>('entity_type'),
            hit.read<String>('entity_id'),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await settle(tester);
      expect(find.byType(SymptomDetailPage), findsOneWidget);
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text('Konzert mit Freunden'),
        ),
        findsOneWidget,
      );
      await tester.tap(find.text('Schließen'));
      await settle(tester);
      // Eintrag in der Tagebuch-Liste markiert.
      final tile = find.byKey(ValueKey('journal-entry-$observationId'));
      await tester.scrollUntilVisible(
        tile,
        300,
        scrollable: find
            .byWidgetPredicate(
              (w) => w is Scrollable && w.axisDirection == AxisDirection.down,
            )
            .first,
      );
      expect(tester.widget<ListTile>(tile).selected, isTrue);
      await unmount(tester);
    });
  });
}
