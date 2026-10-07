import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/database_provider.dart';
import 'package:mai_doctor_hub/data/repositories/records_repository.dart';
import 'package:mai_doctor_hub/data/repositories/suggestion_repository.dart';
import 'package:mai_doctor_hub/data/repositories/symptom_repository.dart';
import 'package:mai_doctor_hub/data/symptom_description.dart';
import 'package:mai_doctor_hub/data/symptom_descriptors.dart';
import 'package:mai_doctor_hub/features/check_in/check_in_sheet.dart';
import 'package:mai_doctor_hub/l10n/l10n.dart';
import 'package:mai_doctor_hub/theme/app_theme.dart';
import 'package:mai_doctor_hub/widgets/symptom_heatmap.dart';
import 'package:mai_doctor_hub/widgets/symptom_report_card.dart';

SymptomObservation _obs(
  DateTime at,
  double? value, {
  ObservationKind kind = ObservationKind.scale_1_10,
}) => SymptomObservation(
  id: '${at.microsecondsSinceEpoch}-$value',
  symptomId: 's',
  recordedAt: at,
  kind: kind,
  valueNumber: value,
);

void main() {
  tearDown(() => AppLocale.update(AppLocale.german));

  group('repository', () {
    late AppDatabase db;
    late SymptomRepository repo;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      repo = SymptomRepository(db);
    });
    tearDown(() => db.close());

    test('symptom defaults and observation details round-trip', () async {
      final id = await repo.create(
        label: 'Kopfschmerz',
        bodyRegion: 'Hinterkopf',
        sensation: 'Schmerz',
        quality: 'brennend, pochend',
        side: BodySide.left,
      );
      var symptom = (await repo.getById(id))!;
      expect(symptom.sensation, 'Schmerz');
      expect(symptom.quality, 'brennend, pochend');
      expect(BodySide.fromCode(symptom.side), BodySide.left);

      await repo.addObservation(
        symptomId: id,
        kind: ObservationKind.scale_1_10,
        valueNumber: 7,
        sensation: 'Schmerz',
        quality: 'stechend',
        location: 'Schläfe',
        side: BodySide.both,
        pattern: 'anfallsartig, nachts',
      );
      final o = (await repo.latestObservation(id))!;
      expect(o.valueNumber, 7);
      expect(
        (o.sensation, o.quality, o.location, o.side, o.pattern),
        ('Schmerz', 'stechend', 'Schläfe', 'both', 'anfallsartig, nachts'),
      );

      // Beschreibung ist über die Akte-Suche auffindbar.
      final hits = await RecordsRepository(db).search('pochend');
      expect(hits.map((h) => h.read<String>('entity_id')), contains(id));

      await repo.update(
        id: id,
        label: 'Kopfschmerz',
        bodyRegion: 'Hinterkopf',
        sensation: 'Druckgefühl',
      );
      symptom = (await repo.getById(id))!;
      expect(symptom.sensation, 'Druckgefühl');
      expect(symptom.quality, isNull);
      expect(symptom.side, isNull);
    });

    test('used descriptors: newest first, split and deduplicated', () async {
      final id = await repo.create(label: 'Juckreiz', quality: 'juckend');
      await repo.addObservation(
        symptomId: id,
        kind: ObservationKind.scale_1_10,
        valueNumber: 3,
        quality: 'brennend, Juckend',
        recordedAt: DateTime.now().add(const Duration(minutes: 1)),
      );
      expect(await repo.usedDescriptors(DescriptorField.quality), [
        'brennend',
        'Juckend',
      ]);
      expect(await repo.usedDescriptors(DescriptorField.pattern), isEmpty);
    });
  });

  group('description', () {
    test('sentence preview keeps grammar simple and robust', () {
      final l10n = AppLocale.strings;
      const full = SymptomDescription(
        sensation: 'Schmerz',
        qualities: ['brennend', 'pochend'],
        location: 'Hinterkopf',
        side: BodySide.left,
        patterns: ['anfallsartig'],
        intensity: 7,
      );
      expect(
        full.describe(l10n),
        'Schmerz (brennend, pochend) · Hinterkopf (links) · anfallsartig · '
        '7/10 stark',
      );
      expect(
        full.describe(l10n, withIntensity: false),
        'Schmerz (brennend, pochend) · Hinterkopf (links) · anfallsartig',
      );
      expect(
        const SymptomDescription(
          qualities: ['dumpf'],
          side: BodySide.both,
        ).describe(l10n),
        'dumpf · beidseits',
      );
      expect(
        const SymptomDescription(intensity: 0).describe(l10n),
        '0/10 keine',
      );
      expect(const SymptomDescription().isEmpty, isTrue);

      AppLocale.update(AppLocale.english);
      expect(
        full.describe(AppLocale.strings),
        'Schmerz (brennend, pochend) · Hinterkopf (left) · anfallsartig · '
        '7/10 severe',
      );
    });

    test('intensity anchors cover 0–10', () {
      final l10n = AppLocale.strings;
      expect(
        [for (var v = 0; v <= 10; v++) intensityBand(v)],
        [
          IntensityBand.none,
          ...List.filled(3, IntensityBand.mild),
          ...List.filled(3, IntensityBand.moderate),
          ...List.filled(3, IntensityBand.severe),
          IntensityBand.unbearable,
        ],
      );
      final anchors = {for (var v = 0; v <= 10; v++) intensityAnchor(v, l10n)};
      expect(anchors, hasLength(11));
      expect(intensityText(6.6, l10n), '7/10 stark');
    });

    test('list fields split and join', () {
      expect(SymptomDescription.splitList(' a, b ,,A, c'), ['a', 'b', 'c']);
      expect(SymptomDescription.splitList(null), isEmpty);
      expect(SymptomDescription.joinList(const []), isNull);
      expect(SymptomDescription.joinList(const ['a', 'b']), 'a, b');
    });

    test('observation label prefixes the description', () {
      final plain = _obs(DateTime(2026, 10, 1), 4);
      expect(observationLabel(plain), 'Stärke 4/10');
      final described = SymptomObservation(
        id: 'o',
        symptomId: 's',
        recordedAt: DateTime(2026, 10, 1),
        kind: ObservationKind.scale_1_10,
        valueNumber: 7,
        sensation: 'Schmerz',
        quality: 'brennend',
        location: 'Hinterkopf',
        side: 'left',
      );
      expect(
        observationLabel(described),
        'Schmerz (brennend) · Hinterkopf (links) · Stärke 7/10',
      );
    });
  });

  group('catalog', () {
    test('terms are unique per list in both languages', () {
      for (final groups in [
        sensationGroups,
        qualityGroups,
        locationGroups,
        patternGroups,
      ]) {
        for (final lang in [0, 1]) {
          final terms = [
            for (final g in groups)
              for (final t in g.terms) lang == 0 ? t.$1 : t.$2,
          ];
          final normalized = terms.map(SuggestionRepository.normalize).toSet();
          expect(normalized, hasLength(terms.length), reason: '$terms');
        }
      }
    });

    test('qualities matching the sensation come first', () {
      expect(SymptomDescriptors.qualitiesFor('Juckreiz').first.key, 'skin');
      expect(SymptomDescriptors.qualitiesFor('kribbeln').first.key, 'nerve');
      expect(SymptomDescriptors.qualitiesFor('Schmerz').first.key, 'pain');
      expect(
        SymptomDescriptors.qualitiesFor('Eigenes').map((g) => g.key),
        qualityGroups.map((g) => g.key),
      );
      AppLocale.update(AppLocale.english);
      expect(SymptomDescriptors.qualitiesFor('Itch').first.title, 'Skin');
      expect(
        SymptomDescriptors.flat(SymptomDescriptors.locations),
        contains('Back of head'),
      );
    });
  });

  group('heatmap', () {
    test('max intensity per local calendar day', () {
      final days = dailyMaxIntensity([
        _obs(DateTime(2026, 10, 5, 0, 5), 3),
        _obs(DateTime(2026, 10, 5, 23, 55), 8),
        _obs(DateTime(2026, 10, 5, 12), 6),
        _obs(DateTime(2026, 10, 6, 1), 0),
        _obs(DateTime(2026, 10, 6, 9), 12), // wird auf 10 begrenzt
        _obs(DateTime(2026, 10, 7), 5, kind: ObservationKind.note),
        _obs(DateTime(2026, 10, 8), null),
      ]);
      expect(days, {DateTime(2026, 10, 5): 8.0, DateTime(2026, 10, 6): 10.0});
    });

    test('UTC timestamps are bucketed by local day', () {
      final utc = DateTime.utc(2026, 10, 5, 12);
      final days = dailyMaxIntensity([_obs(utc, 4)]);
      final local = utc.toLocal();
      expect(days.keys.single, DateTime(local.year, local.month, local.day));
    });

    test('calendar days survive daylight saving changes', () {
      // Zeitumstellung in Europa: 29.3. und 25.10.2026.
      expect(addDays(DateTime(2026, 3, 28), 1), DateTime(2026, 3, 29));
      expect(addDays(DateTime(2026, 3, 28), 2), DateTime(2026, 3, 30));
      expect(addDays(DateTime(2026, 10, 24), 2), DateTime(2026, 10, 26));
      expect(daysBetween(DateTime(2026, 3, 1), DateTime(2026, 4, 1)), 31);
    });

    test('grid starts on the first weekday and covers today', () {
      final today = DateTime(2026, 10, 6, 15); // Dienstag
      final grid = HeatmapGrid(today: today, minWeeks: 4);
      expect(grid.start.weekday, DateTime.monday);
      expect(grid.weeks, 4);
      expect(grid.dayAt(grid.weeks - 1, 1), DateTime(2026, 10, 6));

      final longer = HeatmapGrid(
        today: today,
        earliest: DateTime(2026, 1, 1, 8),
        firstWeekday: DateTime.sunday,
      );
      expect(longer.start.weekday, DateTime.sunday);
      expect(longer.start.isAfter(DateTime(2026, 1, 1)), isFalse);
      expect(daysBetween(longer.start, DateTime(2026, 1, 1)), lessThan(7));
    });

    testWidgets('cells have semantic labels and show the day on tap', (
      tester,
    ) async {
      final today = DateTime(2026, 10, 6);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(),
          home: Scaffold(
            body: SymptomHeatmap(
              today: today,
              observations: [
                _obs(DateTime(2026, 10, 5, 8), 3),
                _obs(DateTime(2026, 10, 5, 20), 7),
              ],
            ),
          ),
        ),
      );
      final cell = find.bySemanticsLabel('5. Okt. 2026: 7/10');
      expect(cell, findsOneWidget);
      expect(
        find.bySemanticsLabel('4. Okt. 2026: kein Check-in'),
        findsOneWidget,
      );
      expect(find.text('7–9 stark'), findsOneWidget);

      await tester.tap(cell);
      await tester.pump();
      expect(find.text('Montag, 5. Oktober 2026'), findsOneWidget);
      expect(find.text('08:00 · Stärke 3/10'), findsOneWidget);
      expect(find.text('20:00 · Stärke 7/10'), findsOneWidget);
    });
  });

  testWidgets('check-in: pick a quality from the list and save', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    late String id;
    await tester.runAsync(() async {
      id = await SymptomRepository(db).create(
        label: 'Kopfschmerz',
        bodyRegion: 'Hinterkopf',
        sensation: 'Schmerz',
        side: BodySide.left,
      );
    });

    Future<void> settle() async {
      for (var i = 0; i < 5; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 10)),
        );
        await tester.pump(const Duration(milliseconds: 100));
      }
      await tester.pump(const Duration(milliseconds: 400));
    }

    await tester.pumpWidget(
      DatabaseScope(
        database: db,
        child: MaterialApp(
          theme: AppTheme.light(),
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => showCheckInSheet(context),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await settle();

    // v15: Beschreibung steckt hinter „Details ändern“ (Messwert zuerst).
    expect(find.byTooltip('Charakter'), findsNothing);
    await tester.tap(find.text('Details ändern'));
    await settle();

    // Vorbelegt aus dem Symptom.
    expect(
      find.text('Schmerz · Hinterkopf (links) · 5/10 mittel'),
      findsOneWidget,
    );

    await tester.tap(find.byTooltip('Charakter'));
    await settle();
    expect(find.text('Schmerzcharakter'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilterChip, 'brennend'));
    await tester.pump();
    await tester.tap(find.widgetWithText(FilterChip, 'pochend'));
    await tester.pump();
    await tester.tap(find.text('Übernehmen'));
    await settle();

    expect(
      find.text(
        'Schmerz (brennend, pochend) · Hinterkopf (links) · 5/10 mittel',
      ),
      findsOneWidget,
    );

    // Stärke ganz nach rechts → 10.
    await tester.drag(find.byType(Slider), const Offset(600, 0));
    await tester.pump();
    expect(find.textContaining('10/10 unerträglich'), findsWidgets);

    await tester.tap(find.text('Speichern'));
    await settle();

    final o = await tester.runAsync(
      () => SymptomRepository(db).latestObservation(id),
    );
    expect(o!.valueNumber, 10);
    expect(o.sensation, 'Schmerz');
    expect(o.quality, 'brennend, pochend');
    expect(o.location, 'Hinterkopf');
    expect(o.side, 'left');
    expect(o.pattern, isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 100));
  });
}
