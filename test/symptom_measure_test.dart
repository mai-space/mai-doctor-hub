import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/measure_units.dart';
import 'package:mai_doctor_hub/data/symptom_measure.dart';
import 'package:mai_doctor_hub/l10n/l10n.dart';
import 'package:mai_doctor_hub/widgets/measure_chart.dart';
import 'package:mai_doctor_hub/widgets/symptom_heatmap.dart';
import 'package:mai_doctor_hub/widgets/symptom_report_card.dart';

SymptomObservation _m(
  DateTime at,
  SymptomMeasure measure,
  double value, {
  double? value2,
  String? journal,
  SymptomMeasure? measure2,
  double? secondary,
}) => SymptomObservation(
  id: '${at.microsecondsSinceEpoch}-$value',
  symptomId: 's',
  recordedAt: at,
  kind: measure.isScale
      ? ObservationKind.scale_1_10
      : ObservationKind.measurement,
  valueNumber: value,
  valueNumber2: value2,
  measure: measure.code,
  journal: journal,
  measure2: measure2?.code,
  secondaryValue: secondary,
);

void main() {
  final de = lookupAppLocalizations(const Locale('de'));
  final en = lookupAppLocalizations(const Locale('en'));
  const celsius = UnitPreferences();
  const us = UnitPreferences(
    temperature: TemperatureUnit.fahrenheit,
    glucose: GlucoseUnit.mgdl,
    weight: WeightUnit.lb,
  );
  const mmol = UnitPreferences(glucose: GlucoseUnit.mmol);

  tearDown(() {
    AppLocale.update(AppLocale.german);
    AppUnits.reset();
  });

  group('measure suggestion', () {
    MeasurePair s(String title, {String? sensation}) =>
        suggestMeasures(title, sensation: sensation);

    test('from the title', () {
      expect(s('Fieber').primary, SymptomMeasure.temperature);
      expect(s('Fieberschub nachts').primary, SymptomMeasure.temperature);
      expect(s('Fever').primary, SymptomMeasure.temperature);
      expect(s('Erhöhte Temperatur').primary, SymptomMeasure.temperature);
      expect(s('Herzrasen').primary, SymptomMeasure.pulse);
      expect(s('Puls').primary, SymptomMeasure.pulse);
      expect(s('Hoher Blutdruck').primary, SymptomMeasure.bloodPressure);
      expect(s('Durchfall').primary, SymptomMeasure.count);
      expect(s('Erbrechen').primary, SymptomMeasure.count);
      expect(s('Hustenanfälle').primary, SymptomMeasure.count);
      expect(s('Krampfanfall').primary, SymptomMeasure.count);
      expect(s('Seizures').primary, SymptomMeasure.count);
      expect(s('Panikattacken'), (
        primary: SymptomMeasure.count,
        secondary: SymptomMeasure.duration,
      ));
      expect(s('Migräne'), (
        primary: SymptomMeasure.intensity,
        secondary: SymptomMeasure.duration,
      ));
      expect(s('Schwindel').secondary, SymptomMeasure.duration);
      expect(s('Atemnot'), (
        primary: SymptomMeasure.intensity,
        secondary: SymptomMeasure.spo2,
      ));
      expect(s('Shortness of breath').secondary, SymptomMeasure.spo2);
      expect(s('Blutzucker').primary, SymptomMeasure.glucose);
      expect(s('Unterzuckerung').primary, SymptomMeasure.glucose);
      expect(s('Gewichtsverlust').primary, SymptomMeasure.weight);
      expect(s('Traurigkeit').primary, SymptomMeasure.mood);
      expect(s('Low mood').primary, SymptomMeasure.mood);
      expect(s('Manische Phase').primary, SymptomMeasure.mood);
    });

    test('falls back to intensity and avoids false friends', () {
      expect(s('Kopfschmerz').primary, SymptomMeasure.intensity);
      expect(s('').primary, SymptomMeasure.intensity);
      // „pulsierend“ ist kein Puls, „Blasenentleerung“ keine Leere,
      // „gereizte Haut“ keine Stimmung.
      expect(s('Pulsierender Schmerz').primary, SymptomMeasure.intensity);
      expect(s('Blasenentleerung gestört').primary, SymptomMeasure.intensity);
      expect(s('Gereizte Haut').primary, SymptomMeasure.intensity);
      // Gedanken an Selbstverletzung: Stärke (Hilfsangebot ab > 0).
      expect(
        s('Gedanken an Selbstverletzung oder Suizid').primary,
        SymptomMeasure.intensity,
      );
    });

    test('from the sensation block', () {
      expect(
        s('Am Abend', sensation: 'Niedergeschlagenheit').primary,
        SymptomMeasure.mood,
      );
      expect(s('', sensation: 'Durchfall').primary, SymptomMeasure.count);
    });
  });

  group('units', () {
    test('defaults by region', () {
      expect(UnitPreferences.forRegion('US'), us);
      expect(UnitPreferences.forRegion('DE'), celsius);
      expect(UnitPreferences.forRegion('GB').glucose, GlucoseUnit.mmol);
      expect(UnitPreferences.forRegion('GB').weight, WeightUnit.kg);
      expect(UnitPreferences.forRegion(null), celsius);
      // Gerät in den Tests: de_DE.
      expect(AppUnits.current, celsius);
    });

    test('conversions round-trip', () {
      for (final c in [35.0, 36.6, 38.4, 41.2]) {
        expect(fahrenheitToCelsius(celsiusToFahrenheit(c)), closeTo(c, 1e-9));
      }
      expect(celsiusToFahrenheit(38), closeTo(100.4, 1e-9));
      expect(celsiusToFahrenheit(37.5), closeTo(99.5, 1e-9));
      expect(celsiusToFahrenheit(39), closeTo(102.2, 1e-9));
      expect(mgdlToMmol(180), closeTo(9.99, 0.01));
      expect(mmolToMgdl(mgdlToMmol(123)), closeTo(123, 1e-9));
      expect(kgToLb(70), closeTo(154.32, 0.01));
      expect(lbToKg(kgToLb(68.5)), closeTo(68.5, 1e-9));
      for (final m in SymptomMeasure.values) {
        for (final u in [celsius, us, mmol]) {
          expect(
            canonicalValue(m, displayValue(m, 42.5, u), u),
            closeTo(42.5, 1e-9),
            reason: '$m $u',
          );
        }
      }
    });

    test('settings: stored code wins over region default', () {
      final row = AppSetting(
        id: 1,
        morningReminderEnabled: true,
        eveningReminderEnabled: true,
        morningHour: 8,
        morningMinute: 0,
        eveningHour: 20,
        eveningMinute: 0,
        calendarSyncEnabled: false,
        calendarIncludeTitle: false,
        appLockEnabled: false,
        onboardingCompleted: true,
        appointmentRemindersEnabled: true,
        appointmentReminderLeads: '',
        notificationTopics: '',
        cycleTracking: false,
        menopauseTracking: false,
        pregnancyTracking: false,
        showFertileWindow: false,
        temperatureUnit: 'fahrenheit',
        psychQuestionnaires: false,
      );
      final p = UnitPreferences.fromSettings(row, region: 'GB');
      expect(p.temperature, TemperatureUnit.fahrenheit);
      expect(p.glucose, GlucoseUnit.mmol);
      expect(p.weight, WeightUnit.kg);
    });
  });

  group('formatting', () {
    test('German uses a decimal comma, English a point', () {
      expect(
        formatMeasureValue(
          SymptomMeasure.temperature,
          38.4,
          l10n: de,
          units: celsius,
        ),
        '38,4 °C',
      );
      expect(
        formatMeasureValue(
          SymptomMeasure.temperature,
          38.4,
          l10n: en,
          units: us,
        ),
        '101.1 °F',
      );
      expect(
        formatMeasureValue(
          SymptomMeasure.temperature,
          38.4,
          l10n: de,
          units: us,
        ),
        '101,1 °F',
      );
      expect(
        formatMeasureValue(SymptomMeasure.glucose, 99, l10n: de, units: mmol),
        '5,5 mmol/L',
      );
      expect(
        formatMeasureValue(SymptomMeasure.glucose, 99, l10n: en),
        '99 mg/dL',
      );
      expect(
        formatMeasureValue(SymptomMeasure.weight, 68.5, l10n: en, units: us),
        '151.0 lb',
      );
      expect(
        formatMeasureValue(
          SymptomMeasure.bloodPressure,
          128,
          value2: 84,
          l10n: de,
        ),
        '128/84 mmHg',
      );
      expect(formatMeasureValue(SymptomMeasure.count, 3, l10n: de), '3×');
      expect(
        formatMeasureValue(SymptomMeasure.duration, 90, l10n: de),
        '1 h 30 min',
      );
      expect(
        formatMeasureValue(SymptomMeasure.duration, 45, l10n: de),
        '45 min',
      );
      expect(formatMeasureValue(SymptomMeasure.duration, 120, l10n: de), '2 h');
      expect(formatMeasureValue(SymptomMeasure.pulse, 72, l10n: de), '72 /min');
      expect(formatMeasureValue(SymptomMeasure.pulse, 72, l10n: en), '72 bpm');
      expect(formatMeasureValue(SymptomMeasure.spo2, 94, l10n: de), '94 %');
      expect(formatMeasureValue(SymptomMeasure.mood, 2, l10n: de), '+2');
      expect(formatMeasureValue(SymptomMeasure.mood, -3, l10n: de), '−3');
      expect(formatMeasureValue(SymptomMeasure.mood, 0, l10n: de), '0');
      expect(formatMeasureValue(SymptomMeasure.intensity, 7, l10n: de), '7/10');
    });

    test('value text with band', () {
      expect(
        measureValueText(
          SymptomMeasure.temperature,
          38.4,
          l10n: de,
          units: celsius,
        ),
        'Temperatur 38,4 °C (Fieber)',
      );
      expect(
        measureValueText(SymptomMeasure.mood, -2, l10n: de),
        'Stimmung −2 (gedrückt)',
      );
      expect(
        measureValueText(SymptomMeasure.intensity, 7, l10n: de),
        'Stärke 7/10',
      );
      expect(measureValueText(SymptomMeasure.count, 4, l10n: en), 'Count 4×');
    });

    test('observation label with secondary value and mood extras', () {
      final o = SymptomObservation(
        id: 'o',
        symptomId: 's',
        recordedAt: DateTime(2026, 10, 1),
        kind: ObservationKind.measurement,
        measure: 'mood',
        valueNumber: 2,
        energy: 7,
        sleepHours: 5.5,
        anxiety: 3,
        journal: 'privat',
      );
      expect(
        observationLabel(o),
        'Stimmung +2 (gehoben) · Energie 7/10 · Schlaf 5,5 h · Angst 3/10',
      );
      expect(observationLabel(o, withJournal: true), endsWith('„privat“'));
      final dyspnea = _m(
        DateTime(2026, 10, 1),
        SymptomMeasure.intensity,
        6,
        measure2: SymptomMeasure.spo2,
        secondary: 91,
      );
      expect(
        observationLabel(dyspnea),
        'Stärke 6/10 · Sauerstoffsättigung (SpO₂) 91 % (ärztlich abklären)',
      );
    });
  });

  group('reference bands', () {
    test('fever (gesundheitsinformation.de / RKI)', () {
      expect(temperatureBand(36.8), TemperatureBand.normal);
      expect(temperatureBand(37.44), TemperatureBand.normal);
      // Gerundet wie angezeigt: 37,46 → 37,5.
      expect(temperatureBand(37.46), TemperatureBand.elevated);
      expect(temperatureBand(37.5), TemperatureBand.elevated);
      expect(temperatureBand(37.99), TemperatureBand.fever);
      expect(temperatureBand(38.0), TemperatureBand.fever);
      expect(temperatureBand(38.9), TemperatureBand.fever);
      expect(temperatureBand(39.0), TemperatureBand.highFever);
      // 100,4 °F = 38,0 °C.
      expect(
        temperatureBand(fahrenheitToCelsius(100.4)),
        TemperatureBand.fever,
      );
    });

    test('blood pressure (ESC/ESH 2018): higher category wins', () {
      expect(bloodPressureBand(115, 75), BloodPressureBand.optimal);
      expect(bloodPressureBand(125, 75), BloodPressureBand.normal);
      expect(bloodPressureBand(118, 82), BloodPressureBand.normal);
      expect(bloodPressureBand(135, 80), BloodPressureBand.highNormal);
      expect(bloodPressureBand(120, 87), BloodPressureBand.highNormal);
      expect(bloodPressureBand(140, 90), BloodPressureBand.grade1);
      expect(bloodPressureBand(130, 95), BloodPressureBand.grade1);
      expect(bloodPressureBand(165, 85), BloodPressureBand.grade2);
      expect(bloodPressureBand(150, 112), BloodPressureBand.grade3);
      expect(bloodPressureBand(185, null), BloodPressureBand.grade3);
    });

    test('SpO2: hints below 92 % and 90 %', () {
      expect(spo2Band(98), Spo2Band.normal);
      expect(spo2Band(95), Spo2Band.normal);
      expect(spo2Band(94), Spo2Band.low);
      expect(spo2Band(92), Spo2Band.low);
      expect(spo2Band(91), Spo2Band.check);
      expect(spo2Band(90), Spo2Band.check);
      expect(spo2Band(89), Spo2Band.urgent);
    });

    test('glucose and pulse', () {
      expect(glucoseBand(50), GlucoseBand.veryLow);
      expect(glucoseBand(65), GlucoseBand.low);
      expect(glucoseBand(70), GlucoseBand.inRange);
      expect(glucoseBand(180), GlucoseBand.inRange);
      expect(glucoseBand(200), GlucoseBand.high);
      expect(glucoseBand(300), GlucoseBand.veryHigh);
      expect(pulseBand(55), PulseBand.low);
      expect(pulseBand(80), PulseBand.normal);
      expect(pulseBand(110), PulseBand.high);
    });

    test('severity mapping for the heatmap', () {
      expect(measureSeverity(SymptomMeasure.temperature, 36.9), 0);
      expect(measureSeverity(SymptomMeasure.temperature, 37.6), 3);
      expect(measureSeverity(SymptomMeasure.temperature, 38.4), 5);
      expect(measureSeverity(SymptomMeasure.temperature, 39.2), 8);
      expect(measureSeverity(SymptomMeasure.temperature, 40.1), 10);
      expect(measureSeverity(SymptomMeasure.bloodPressure, 145, value2: 85), 5);
      expect(measureSeverity(SymptomMeasure.spo2, 84), 10);
      expect(measureSeverity(SymptomMeasure.mood, -4), 8);
      expect(measureSeverity(SymptomMeasure.mood, 5), 10);
      expect(measureSeverity(SymptomMeasure.count, 2, maxValue: 4), 5);
      expect(measureSeverity(SymptomMeasure.count, 0, maxValue: 0), 0);
      expect(measureSeverity(SymptomMeasure.weight, 70), 1);
    });
  });

  group('charts and heatmap data', () {
    test('mood chart is diverging around 0 with journal markers', () {
      final data = MeasureChartData.from([
        _m(DateTime(2026, 10, 3), SymptomMeasure.mood, 2, journal: 'gut'),
        _m(DateTime(2026, 10, 1), SymptomMeasure.mood, -3),
        _m(DateTime(2026, 10, 2), SymptomMeasure.mood, 0),
        _m(DateTime(2026, 10, 2), SymptomMeasure.intensity, 7),
      ], SymptomMeasure.mood);
      expect(data.style, MeasureChartStyle.diverging);
      expect((data.min, data.max), (-5.0, 5.0));
      expect(data.series.single.map((p) => p.value), [-3, 0, 2]);
      expect(data.markers.single.journal, 'gut');
      expect(data.withoutMarkers().markers, isEmpty);
    });

    test('temperature chart in display units with fever line', () {
      final obs = [
        _m(DateTime(2026, 10, 1, 8), SymptomMeasure.temperature, 37.2),
        _m(DateTime(2026, 10, 1, 20), SymptomMeasure.temperature, 38.4),
      ];
      final c = MeasureChartData.from(
        obs,
        SymptomMeasure.temperature,
        units: celsius,
        l10n: de,
      );
      expect(c.style, MeasureChartStyle.line);
      expect(c.series.single.map((p) => p.value), [37.2, 38.4]);
      expect(c.references.single.value, 38.0);
      expect(c.references.single.label, 'Fieber ab 38,0 °C');
      expect(c.min, lessThan(36));
      final f = MeasureChartData.from(
        obs,
        SymptomMeasure.temperature,
        units: us,
        l10n: en,
      );
      expect(f.series.single.last.value, closeTo(101.12, 0.01));
      expect(f.references.single.value, closeTo(100.4, 1e-9));
    });

    test('counts become bars per day, BP two lines', () {
      final counts = MeasureChartData.from([
        _m(DateTime(2026, 10, 1, 8), SymptomMeasure.count, 2),
        _m(DateTime(2026, 10, 1, 18), SymptomMeasure.count, 3),
        _m(DateTime(2026, 10, 2, 9), SymptomMeasure.count, 1),
      ], SymptomMeasure.count);
      expect(counts.style, MeasureChartStyle.dailyBars);
      expect(counts.series.single.map((p) => p.value), [5, 1]);
      expect(counts.max, 5);
      final bp = MeasureChartData.from([
        _m(
          DateTime(2026, 10, 1),
          SymptomMeasure.bloodPressure,
          142,
          value2: 91,
        ),
        _m(
          DateTime(2026, 10, 2),
          SymptomMeasure.bloodPressure,
          128,
          value2: 82,
        ),
      ], SymptomMeasure.bloodPressure);
      expect(bp.series, hasLength(2));
      expect(bp.series[1].map((p) => p.value), [91, 82]);
      expect(bp.references.map((r) => r.value), [140, 90]);
    });

    test('secondary values feed their own chart and stats', () {
      final obs = [
        _m(
          DateTime(2026, 10, 1),
          SymptomMeasure.intensity,
          6,
          measure2: SymptomMeasure.spo2,
          secondary: 93,
        ),
        _m(
          DateTime(2026, 10, 2),
          SymptomMeasure.intensity,
          4,
          measure2: SymptomMeasure.spo2,
          secondary: 96,
        ),
      ];
      final spo2 = MeasureChartData.from(obs, SymptomMeasure.spo2);
      expect(spo2.series.single.map((p) => p.value), [93, 96]);
      final stats = MeasureStats.of(obs, SymptomMeasure.spo2)!;
      expect((stats.min, stats.max, stats.last), (93.0, 96.0, 96.0));
      expect(MeasureStats.of(obs, SymptomMeasure.glucose), isNull);
    });

    test('stats text per measure', () {
      final stats = MeasureStats.of([
        _m(DateTime(2026, 10, 1), SymptomMeasure.temperature, 37.6),
        _m(DateTime(2026, 10, 2), SymptomMeasure.temperature, 39.0),
      ], SymptomMeasure.temperature)!;
      expect(
        stats.describe(SymptomMeasure.temperature, de, units: celsius),
        'Ø 38,3 °C · min 37,6 °C · max 39,0 °C · zuletzt 39,0 °C',
      );
      final bp = MeasureStats.of([
        _m(
          DateTime(2026, 10, 1),
          SymptomMeasure.bloodPressure,
          140,
          value2: 90,
        ),
        _m(
          DateTime(2026, 10, 2),
          SymptomMeasure.bloodPressure,
          120,
          value2: 80,
        ),
      ], SymptomMeasure.bloodPressure)!;
      expect(
        bp.describe(SymptomMeasure.bloodPressure, de),
        'Ø 130/85 mmHg · min 120 mmHg · max 140 mmHg · zuletzt 120/80 mmHg',
      );
    });

    test('heatmap: daily worst value per measure', () {
      final days = dailySeverity([
        _m(DateTime(2026, 10, 1, 8), SymptomMeasure.temperature, 37.2),
        _m(DateTime(2026, 10, 1, 20), SymptomMeasure.temperature, 39.1),
        _m(DateTime(2026, 10, 2, 9), SymptomMeasure.temperature, 37.7),
      ], SymptomMeasure.temperature);
      expect(days[DateTime(2026, 10, 1)]!.value, 39.1);
      expect(days[DateTime(2026, 10, 1)]!.severity, 8);
      expect(days[DateTime(2026, 10, 2)]!.severity, 3);

      final spo2 = dailySeverity([
        _m(DateTime(2026, 10, 1, 8), SymptomMeasure.spo2, 96),
        _m(DateTime(2026, 10, 1, 9), SymptomMeasure.spo2, 97),
      ], SymptomMeasure.spo2);
      expect(spo2[DateTime(2026, 10, 1)]!.value, 96);

      final counts = dailySeverity([
        _m(DateTime(2026, 10, 1, 8), SymptomMeasure.count, 2),
        _m(DateTime(2026, 10, 1, 9), SymptomMeasure.count, 2),
        _m(DateTime(2026, 10, 2, 9), SymptomMeasure.count, 1),
      ], SymptomMeasure.count);
      expect(counts[DateTime(2026, 10, 1)]!.value, 4);
      expect(counts[DateTime(2026, 10, 1)]!.severity, 10);
      expect(counts[DateTime(2026, 10, 2)]!.severity, 2.5);

      // Stärke wie bisher: Höchstwert des Tages.
      final scale = dailySeverity([
        _m(DateTime(2026, 10, 1, 8), SymptomMeasure.intensity, 3),
        _m(DateTime(2026, 10, 1, 9), SymptomMeasure.intensity, 8),
      ], SymptomMeasure.intensity);
      expect(scale[DateTime(2026, 10, 1)]!.severity, 8);
    });
  });
}
