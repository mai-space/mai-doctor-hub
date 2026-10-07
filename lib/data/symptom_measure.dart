/// v15: Adaptive Skalen — jedes Symptom wird so gemessen, wie es passt:
/// Kopfschmerz als Stärke 0–10, Fieber als Temperatur, Durchfall als Anzahl,
/// Atemnot als Stärke plus SpO₂, Stimmung bipolar −5 … +5.
///
/// Gespeichert wird immer in kanonischer Einheit (°C, mg/dL, kg, Minuten,
/// Schläge/min, mmHg, %); Umrechnung nur in der Anzeige ([UnitPreferences]).
library;

import 'package:intl/intl.dart';

import '../l10n/l10n.dart';
import 'app_database.dart';
import 'measure_units.dart';
import 'symptom_description.dart';
import 'symptom_descriptors.dart';

enum SymptomMeasure {
  /// Stärke 0–10 (NRS) — Standard, auch für alle alten Check-ins.
  intensity,

  /// Körpertemperatur in °C.
  temperature,

  /// Anzahl seit dem letzten Check-in (Episoden, Anfälle, Stuhlgänge …).
  count,

  /// Dauer in Minuten.
  duration,

  /// Puls in Schlägen pro Minute.
  pulse,

  /// Blutdruck systolisch/diastolisch in mmHg.
  bloodPressure,

  /// Sauerstoffsättigung in %.
  spo2,

  /// Blutzucker in mg/dL.
  glucose,

  /// Körpergewicht in kg.
  weight,

  /// Stimmung bipolar −5 (schwer depressiv) … 0 … +5 (manisch).
  mood;

  /// Speicherform (Spalte `measure`).
  String get code => name;

  static SymptomMeasure? fromCode(String? code) =>
      values.where((m) => m.name == code).firstOrNull;

  /// Wird als Skala 0–10 gespeichert (`ObservationKind.scale_1_10`).
  bool get isScale => this == intensity;

  /// Gültiger Bereich in kanonischer Einheit.
  (double, double) get range => switch (this) {
    intensity => (0, 10),
    temperature => (34, 43),
    count => (0, 200),
    duration => (0, 1440),
    pulse => (20, 250),
    bloodPressure => (50, 260),
    spo2 => (50, 100),
    glucose => (20, 600),
    weight => (1, 400),
    mood => (-5, 5),
  };

  /// Startwert im Check-in, wenn es noch keinen früheren Wert gibt.
  double get initialValue => switch (this) {
    intensity => 5,
    temperature => 37,
    count => 1,
    duration => 30,
    pulse => 70,
    bloodPressure => 120,
    spo2 => 97,
    glucose => 100,
    weight => 70,
    mood => 0,
  };

  /// Kanonische Einheit (für Speicherung und MCP).
  String get canonicalUnit => switch (this) {
    intensity => '/10',
    temperature => '°C',
    count => '×',
    duration => 'min',
    pulse => '/min',
    bloodPressure => 'mmHg',
    spo2 => '%',
    glucose => 'mg/dL',
    weight => 'kg',
    mood => '−5…+5',
  };

  /// Zweite Größe neben dieser sinnvoll? (Blutdruck: zwei Werte genügen.)
  bool get canHaveSecondary => this != bloodPressure;

  /// Als zweite Größe sinnvoll? (Blutdruck und Stimmung nur als erste.)
  bool get canBeSecondary => switch (this) {
    bloodPressure || mood || weight => false,
    _ => true,
  };
}

/// Messgrößen eines Symptoms: erste (Standard Stärke) und optionale zweite.
typedef MeasurePair = ({SymptomMeasure primary, SymptomMeasure? secondary});

MeasurePair symptomMeasures(Symptom s) {
  final primary =
      SymptomMeasure.fromCode(s.measure) ?? SymptomMeasure.intensity;
  final secondary = SymptomMeasure.fromCode(s.measure2);
  return (primary: primary, secondary: secondary == primary ? null : secondary);
}

/// Messgröße des Hauptwerts eines Check-ins; `null` = kein Messwert (Farbe,
/// Notiz …). Alte Check-ins (vor v15) sind Skalenwerte = Stärke.
SymptomMeasure? observationMeasure(SymptomObservation o) => switch (o.kind) {
  ObservationKind.scale_1_10 => SymptomMeasure.intensity,
  ObservationKind.measurement => SymptomMeasure.fromCode(o.measure),
  _ => null,
};

// --- Verlauf über Messgrößen-Wechsel -----------------------------------------

/// v16: Werte einer Messgröße im Verlauf eines Symptoms. Jeder Check-in
/// speichert seine eigene Messgröße; wechselt das Symptom die Messgröße,
/// bleiben die alten Werte als eigener Abschnitt sichtbar.
class MeasureSection {
  const MeasureSection({
    required this.measure,
    required this.current,
    this.count = 0,
    this.from,
    this.to,
  });

  final SymptomMeasure measure;

  /// Aktuelle Messgröße des Symptoms (erste oder zweite).
  final bool current;

  /// Check-ins mit einem Wert dieser Größe; [from]/[to] = erster/letzter.
  final int count;
  final DateTime? from;
  final DateTime? to;
}

/// Messgrößen mit Werten in [observations] (Haupt- und Zusatzwerte), mit
/// Anzahl und Zeitraum. Alte Check-ins ohne Messgröße zählen als Stärke.
Map<SymptomMeasure, ({int count, DateTime from, DateTime to})> recordedMeasures(
  Iterable<SymptomObservation> observations,
) {
  final result = <SymptomMeasure, ({int count, DateTime from, DateTime to})>{};
  void add(SymptomMeasure m, DateTime at) {
    final r = result[m];
    result[m] = r == null
        ? (count: 1, from: at, to: at)
        : (
            count: r.count + 1,
            from: at.isBefore(r.from) ? at : r.from,
            to: at.isAfter(r.to) ? at : r.to,
          );
  }

  for (final o in observations) {
    final primary = observationMeasure(o);
    if (primary != null && o.valueNumber != null) add(primary, o.recordedAt);
    final secondary = SymptomMeasure.fromCode(o.measure2);
    if (secondary != null && secondary != primary && o.secondaryValue != null) {
      add(secondary, o.recordedAt);
    }
  }
  return result;
}

/// Abschnitte für Verlauf, PDF und Assistent: aktuelle Messgröße(n) zuerst
/// (auch ohne Werte), dann früher erfasste, zuletzt benutzte zuerst.
List<MeasureSection> measureSections(
  MeasurePair current,
  Iterable<SymptomObservation> observations,
) {
  final recorded = recordedMeasures(observations);
  MeasureSection section(SymptomMeasure m, bool isCurrent) {
    final r = recorded[m];
    return MeasureSection(
      measure: m,
      current: isCurrent,
      count: r?.count ?? 0,
      from: r?.from,
      to: r?.to,
    );
  }

  final now = [current.primary, ?current.secondary];
  final earlier = [
    for (final m in recorded.keys)
      if (!now.contains(m)) section(m, false),
  ]..sort((a, b) => b.to!.compareTo(a.to!));
  return [for (final m in now) section(m, true), ...earlier];
}

/// Check-ins je Messgröße, die nach einem Wechsel auf [next] nicht mehr zur
/// Messgröße des Symptoms passen (leer = kein Hinweis nötig).
Map<SymptomMeasure, int> measuresLeftBehind(
  Iterable<SymptomObservation> observations,
  MeasurePair next,
) => {
  for (final e in recordedMeasures(observations).entries)
    if (e.key != next.primary && e.key != next.secondary) e.key: e.value.count,
};

/// Umrechnung eines gespeicherten (kanonischen) Werts in eine andere
/// Messgröße.
typedef MeasureConverter = double Function(double canonical);

/// Umrechnungen zwischen Messgrößen — **nur** wo physikalisch identisch.
/// Einheiten (°C/°F, mg/dL/mmol/L, kg/lb) sind reine Anzeige, gespeichert
/// wird kanonisch; deshalb gibt es derzeit keine Einträge. Eine Stärke
/// 0–10 lässt sich z. B. nicht in Anzahl oder Temperatur übersetzen.
/// Neue Paare hier ergänzen, z. B. `(von, nach): (v) => v`.
final Map<(SymptomMeasure, SymptomMeasure), MeasureConverter>
measureConverters = {};

/// Umrechnung [from] → [to]; gleiche Größe = unverändert, sonst nur aus
/// [measureConverters] (Blutdruck hat zwei Werte, nie umrechenbar).
MeasureConverter? measureConverter(SymptomMeasure from, SymptomMeasure to) {
  if (from == to) return (v) => v;
  if (from == SymptomMeasure.bloodPressure ||
      to == SymptomMeasure.bloodPressure) {
    return null;
  }
  return measureConverters[(from, to)];
}

// --- Vorschlag aus Titel/Bausteinen ----------------------------------------

/// Wortanfänge (klein) → Messgröße(n). Reihenfolge = Vorrang. Wortanfänge
/// statt „enthält“, damit „Blasenentleerung“ nicht als „Leere“ zählt;
/// Komposita wie „Fieberschub“ oder „Hustenanfälle“ greifen trotzdem.
/// `$` am Ende = ganzes Wort („Puls“, aber nicht „pulsierend“).
const _suggestions = <(List<String>, SymptomMeasure, SymptomMeasure?)>[
  (
    [
      'blutdruck',
      'bluthochdruck',
      'hypertonie',
      'hypotonie',
      'blood pressure',
      'hypertension',
      'hypotension',
    ],
    SymptomMeasure.bloodPressure,
    null,
  ),
  (
    ['fieber', 'temperatur', 'fever', 'temperature', 'pyrexi'],
    SymptomMeasure.temperature,
    null,
  ),
  (
    [
      'blutzucker',
      'zucker',
      'unterzucker',
      'überzucker',
      'hypoglyk',
      'hyperglyk',
      'glukose',
      'glucose',
      'blood sugar',
      'hypoglyc',
      'hyperglyc',
    ],
    SymptomMeasure.glucose,
    null,
  ),
  (
    ['sauerstoff', 'spo2', 'sättigung', 'oxygen', 'saturation'],
    SymptomMeasure.spo2,
    null,
  ),
  (
    ['gewicht', 'körpergewicht', 'weight', 'body weight'],
    SymptomMeasure.weight,
    null,
  ),
  (
    ['panikattack', 'panik', 'panic'],
    SymptomMeasure.count,
    SymptomMeasure.duration,
  ),
  (
    [
      'durchfall',
      'diarrh',
      'diarrhoe',
      'erbrechen',
      'erbroch',
      'vomit',
      'hustenanf',
      'hustenattack',
      'coughing fit',
      'krampfanfall',
      r'anfall$',
      r'anfälle$',
      'epilep',
      'seizure',
      r'fits$',
    ],
    SymptomMeasure.count,
    null,
  ),
  (
    [
      'herzrasen',
      r'puls$',
      'herzfrequenz',
      'ruhepuls',
      'tachykard',
      'racing heart',
      r'pulse$',
      'heart rate',
      'tachycard',
    ],
    SymptomMeasure.pulse,
    null,
  ),
  (
    [
      'atemnot',
      'kurzatmig',
      'luftnot',
      'dyspnoe',
      'shortness of breath',
      'breathless',
      'dyspnea',
      'dyspnoea',
    ],
    SymptomMeasure.intensity,
    SymptomMeasure.spo2,
  ),
  (
    ['migräne', 'schwindel', 'migraine', 'dizz', 'vertigo'],
    SymptomMeasure.intensity,
    SymptomMeasure.duration,
  ),
  (
    ['herzklopfen', 'palpitation'],
    SymptomMeasure.intensity,
    SymptomMeasure.pulse,
  ),
  (
    [
      'traurig',
      'niedergeschlagen',
      'depress',
      'leere',
      'hoffnungslos',
      'gereiztheit',
      'hochgefühl',
      'manie',
      'manisch',
      'euphor',
      'stimmung',
      'schwermut',
      'sadness',
      'low mood',
      'emptiness',
      'hopeless',
      'irritability',
      'elevated mood',
      'mania',
      'manic',
      'mood',
    ],
    SymptomMeasure.mood,
    null,
  ),
];

/// Schlägt die Messgröße(n) aus Titel und Empfindung vor; sonst Stärke 0–10.
MeasurePair suggestMeasures(String title, {String? sensation}) {
  final text = '${title.toLowerCase()} ${sensation?.toLowerCase() ?? ''}';
  final words = text
      .split(RegExp(r'[^\p{L}\p{N}]+', unicode: true))
      .where((w) => w.isNotEmpty)
      .toList();
  bool matches(String key) {
    if (key.endsWith(r'$')) {
      return words.contains(key.substring(0, key.length - 1));
    }
    if (key.contains(' ')) {
      return RegExp(
        '(^|[^\\p{L}])${RegExp.escape(key)}',
        unicode: true,
      ).hasMatch(text);
    }
    return words.any((w) => w.startsWith(key));
  }

  // Gedanken an Selbstverletzung: Stärke 0–10 (Hilfsangebot ab > 0).
  if (isSelfHarmText(text)) {
    return (primary: SymptomMeasure.intensity, secondary: null);
  }
  for (final (keys, primary, secondary) in _suggestions) {
    if (keys.any(matches)) return (primary: primary, secondary: secondary);
  }
  return (primary: SymptomMeasure.intensity, secondary: null);
}

/// Text meint Gedanken an Selbstverletzung oder Suizid (Baustein bzw.
/// typische Bezeichnungen).
bool isSelfHarmText(String? text) {
  final t = text?.toLowerCase() ?? '';
  if (t.isEmpty) return false;
  return t.contains(selfHarmThoughts.$1.toLowerCase()) ||
      t.contains(selfHarmThoughts.$2.toLowerCase()) ||
      RegExp(r'suizid|selbstmord|selbstverletz|lebensmüd|suicid|self[- ]?harm')
          .hasMatch(t);
}

/// Gehört das Symptom zur Psyche? (Stimmung als Messgröße, Baustein aus
/// einer Psyche-Gruppe oder Gedanken an Selbstverletzung.)
bool isPsychSymptom(Symptom s) {
  final measures = symptomMeasures(s);
  if (measures.primary == SymptomMeasure.mood ||
      measures.secondary == SymptomMeasure.mood) {
    return true;
  }
  final group = SymptomDescriptors.sensationGroupOf(s.sensation);
  if (group != null && SymptomDescriptors.psychGroupKeys.contains(group)) {
    return true;
  }
  return isSelfHarmText(s.label) || isSelfHarmText(s.sensation);
}

// --- Referenzbereiche --------------------------------------------------------

/// Körpertemperatur (Erwachsene). Quelle: gesundheitsinformation.de (IQWiG),
/// „Fieber“ — erhöhte Temperatur 37,5–38,0 °C, Fieber ab 38,0 °C, hohes
/// Fieber ab 39,0 °C; ebenso RKI-Ratgeber/AWMF-Patienteninformationen.
/// In °F: 99,5 / 100,4 / 102,2.
enum TemperatureBand { normal, elevated, fever, highFever }

const feverThresholdC = 38.0;

TemperatureBand temperatureBand(double celsius) {
  // Auf 0,1 °C runden, wie angezeigt — 37,99 zählt als 38,0.
  final c = (celsius * 10).round() / 10;
  if (c >= 39.0) return TemperatureBand.highFever;
  if (c >= feverThresholdC) return TemperatureBand.fever;
  if (c >= 37.5) return TemperatureBand.elevated;
  return TemperatureBand.normal;
}

/// Blutdruck nach ESC/ESH 2018 (Williams B et al., Eur Heart J
/// 2018;39:3021–3104, Tab. 3): optimal < 120/80, normal 120–129/80–84,
/// hoch-normal 130–139/85–89, Hypertonie Grad 1 140–159/90–99, Grad 2
/// 160–179/100–109, Grad 3 ≥ 180/110. Es zählt der höhere der beiden Werte.
enum BloodPressureBand { optimal, normal, highNormal, grade1, grade2, grade3 }

BloodPressureBand bloodPressureBand(num systolic, num? diastolic) {
  BloodPressureBand bySys(num s) => s >= 180
      ? BloodPressureBand.grade3
      : s >= 160
      ? BloodPressureBand.grade2
      : s >= 140
      ? BloodPressureBand.grade1
      : s >= 130
      ? BloodPressureBand.highNormal
      : s >= 120
      ? BloodPressureBand.normal
      : BloodPressureBand.optimal;
  BloodPressureBand byDia(num d) => d >= 110
      ? BloodPressureBand.grade3
      : d >= 100
      ? BloodPressureBand.grade2
      : d >= 90
      ? BloodPressureBand.grade1
      : d >= 85
      ? BloodPressureBand.highNormal
      : d >= 80
      ? BloodPressureBand.normal
      : BloodPressureBand.optimal;
  final a = bySys(systolic);
  if (diastolic == null) return a;
  final b = byDia(diastolic);
  return a.index >= b.index ? a : b;
}

/// Sauerstoffsättigung (Pulsoxymeter, Erwachsene ohne bekannte
/// Lungenerkrankung). Zielbereich 94–98 % (BTS-Leitlinie Sauerstofftherapie
/// 2017, O'Driscoll et al., Thorax 2017;72:i1); unter 92 % ärztlich
/// abklären, unter 90 % zeitnah (Hypoxämie).
enum Spo2Band { normal, low, check, urgent }

Spo2Band spo2Band(num percent) {
  if (percent < 90) return Spo2Band.urgent;
  if (percent < 92) return Spo2Band.check;
  if (percent < 95) return Spo2Band.low;
  return Spo2Band.normal;
}

/// Blutzucker (CGM-Konsens, Battelino T et al., Diabetes Care
/// 2019;42:1593; ADA Standards of Care): < 54 mg/dL sehr niedrig, 54–69
/// niedrig, 70–180 Zielbereich, 181–250 hoch, > 250 sehr hoch.
enum GlucoseBand { veryLow, low, inRange, high, veryHigh }

GlucoseBand glucoseBand(num mgdl) {
  if (mgdl < 54) return GlucoseBand.veryLow;
  if (mgdl < 70) return GlucoseBand.low;
  if (mgdl <= 180) return GlucoseBand.inRange;
  if (mgdl <= 250) return GlucoseBand.high;
  return GlucoseBand.veryHigh;
}

/// Ruhepuls Erwachsener 60–100/min (American Heart Association).
enum PulseBand { low, normal, high }

PulseBand pulseBand(num bpm) {
  if (bpm < 60) return PulseBand.low;
  if (bpm > 100) return PulseBand.high;
  return PulseBand.normal;
}

// --- Schweregrad für Heatmap -------------------------------------------------

/// Schweregrad 0–10 eines Messwerts, damit die Heatmap für alle Größen
/// dieselben fünf Farbstufen ([IntensityBand]) nutzen kann:
///
/// * Stärke: der Wert selbst.
/// * Temperatur: < 37,5 °C → 0, erhöht → 3, Fieber → 5, hohes Fieber → 8,
///   ≥ 40,0 °C → 10.
/// * Blutdruck (ESC/ESH): optimal/normal → 0, hoch-normal → 3, Grad 1 → 5,
///   Grad 2 → 8, Grad 3 → 10.
/// * SpO₂: ≥ 95 % → 0, 92–94 → 3, 90–91 → 5, 85–89 → 8, < 85 → 10.
/// * Blutzucker: Zielbereich → 0, niedrig/hoch → 5, sehr niedrig → 10,
///   sehr hoch → 8.
/// * Puls: 60–100 → 0, 50–59 bzw. 101–120 → 3, 121–150 bzw. 40–49 → 5,
///   sonst → 8.
/// * Stimmung: |Wert| × 2 (±5 → 10) — Richtung zeigt das Stimmungsdiagramm.
/// * Anzahl/Dauer: relativ zum höchsten Tageswert ([maxValue]) × 10.
/// * Gewicht: kein Schweregrad → 1 (nur „erfasst“).
double measureSeverity(
  SymptomMeasure measure,
  double value, {
  double? value2,
  double? maxValue,
}) {
  switch (measure) {
    case SymptomMeasure.intensity:
      return value.clamp(0, 10).toDouble();
    case SymptomMeasure.temperature:
      if (value >= 40) return 10;
      return switch (temperatureBand(value)) {
        TemperatureBand.normal => 0,
        TemperatureBand.elevated => 3,
        TemperatureBand.fever => 5,
        TemperatureBand.highFever => 8,
      };
    case SymptomMeasure.bloodPressure:
      return switch (bloodPressureBand(value, value2)) {
        BloodPressureBand.optimal || BloodPressureBand.normal => 0,
        BloodPressureBand.highNormal => 3,
        BloodPressureBand.grade1 => 5,
        BloodPressureBand.grade2 => 8,
        BloodPressureBand.grade3 => 10,
      };
    case SymptomMeasure.spo2:
      if (value < 85) return 10;
      return switch (spo2Band(value)) {
        Spo2Band.normal => 0,
        Spo2Band.low => 3,
        Spo2Band.check => 5,
        Spo2Band.urgent => 8,
      };
    case SymptomMeasure.glucose:
      return switch (glucoseBand(value)) {
        GlucoseBand.inRange => 0,
        GlucoseBand.low || GlucoseBand.high => 5,
        GlucoseBand.veryHigh => 8,
        GlucoseBand.veryLow => 10,
      };
    case SymptomMeasure.pulse:
      if (value >= 60 && value <= 100) return 0;
      if ((value >= 50 && value < 60) || (value > 100 && value <= 120)) {
        return 3;
      }
      if ((value >= 40 && value < 50) || (value > 120 && value <= 150)) {
        return 5;
      }
      return 8;
    case SymptomMeasure.mood:
      return (value.abs() * 2).clamp(0, 10).toDouble();
    case SymptomMeasure.count || SymptomMeasure.duration:
      final max = maxValue ?? value;
      if (max <= 0) return 0;
      return (value / max * 10).clamp(0, 10).toDouble();
    case SymptomMeasure.weight:
      return 1;
  }
}

// --- Anzeige -----------------------------------------------------------------

/// Zahl in der App-Sprache (Komma im Deutschen), [digits] Nachkommastellen.
String formatNumber(
  num value, {
  int digits = 0,
  String? locale,
  bool grouping = true,
}) {
  final format =
      NumberFormat.decimalPattern(locale ?? AppLocale.current.languageCode)
        ..minimumFractionDigits = digits
        ..maximumFractionDigits = digits;
  if (!grouping) format.turnOffGrouping();
  return format.format(value);
}

/// Wert in Anzeigeeinheit (ohne Einheit), z. B. Temperatur in °F.
double displayValue(
  SymptomMeasure measure,
  double canonical, [
  UnitPreferences? units,
]) {
  final u = units ?? AppUnits.current;
  return switch (measure) {
    SymptomMeasure.temperature => u.temperatureToDisplay(canonical),
    SymptomMeasure.glucose => u.glucoseToDisplay(canonical),
    SymptomMeasure.weight => u.weightToDisplay(canonical),
    _ => canonical,
  };
}

/// Eingabe in Anzeigeeinheit → kanonisch.
double canonicalValue(
  SymptomMeasure measure,
  double display, [
  UnitPreferences? units,
]) {
  final u = units ?? AppUnits.current;
  return switch (measure) {
    SymptomMeasure.temperature => u.temperatureFromDisplay(display),
    SymptomMeasure.glucose => u.glucoseFromDisplay(display),
    SymptomMeasure.weight => u.weightFromDisplay(display),
    _ => display,
  };
}

/// Nachkommastellen in der Anzeige.
int displayDigits(SymptomMeasure measure, [UnitPreferences? units]) {
  final u = units ?? AppUnits.current;
  return switch (measure) {
    SymptomMeasure.temperature || SymptomMeasure.weight => 1,
    SymptomMeasure.glucose => u.glucose == GlucoseUnit.mmol ? 1 : 0,
    _ => 0,
  };
}

/// Schrittweite der Eingabe in Anzeigeeinheit.
double displayStep(SymptomMeasure measure, [UnitPreferences? units]) =>
    switch (displayDigits(measure, units)) {
      0 => 1,
      _ => 0.1,
    };

/// Einheit in der Anzeige.
String displayUnit(
  SymptomMeasure measure,
  AppLocalizations l10n, [
  UnitPreferences? units,
]) {
  final u = units ?? AppUnits.current;
  return switch (measure) {
    SymptomMeasure.intensity => '/10',
    SymptomMeasure.temperature => u.temperature.symbol,
    SymptomMeasure.count => '×',
    SymptomMeasure.duration => 'min',
    SymptomMeasure.pulse => l10n.measureUnitPulse,
    SymptomMeasure.bloodPressure => 'mmHg',
    SymptomMeasure.spo2 => '%',
    SymptomMeasure.glucose => u.glucose.symbol,
    SymptomMeasure.weight => u.weight.symbol,
    SymptomMeasure.mood => '',
  };
}

/// Dauer lesbar: „45 min“, „1 h 30 min“, „2 h“.
String formatDuration(num minutes) {
  final total = minutes.round();
  if (total < 60) return '$total min';
  final h = total ~/ 60;
  final m = total % 60;
  return m == 0 ? '$h h' : '$h h $m min';
}

/// Stimmung mit Vorzeichen: „+2“, „0“, „−3“ (typografisches Minus).
String formatMood(num value) {
  final v = value.round();
  if (v > 0) return '+$v';
  if (v < 0) return '−${-v}';
  return '0';
}

/// Wert mit Einheit, z. B. „38,4 °C“, „3×“, „1 h 30 min“, „128/84 mmHg“,
/// „+2“, „7/10“.
String formatMeasureValue(
  SymptomMeasure measure,
  double value, {
  double? value2,
  AppLocalizations? l10n,
  UnitPreferences? units,
}) {
  final strings = l10n ?? AppLocale.strings;
  final locale = strings.localeName;
  final u = units ?? AppUnits.current;
  String number(double v) => formatNumber(
    displayValue(measure, v, u),
    digits: displayDigits(measure, u),
    locale: locale,
  );
  return switch (measure) {
    SymptomMeasure.intensity => '${value.round().clamp(0, 10)}/10',
    SymptomMeasure.count => '${value.round()}×',
    SymptomMeasure.duration => formatDuration(value),
    SymptomMeasure.mood => formatMood(value),
    SymptomMeasure.bloodPressure =>
      '${value.round()}/${value2?.round() ?? '–'} mmHg',
    SymptomMeasure.spo2 => '${number(value)} %',
    _ => '${number(value)} ${displayUnit(measure, strings, u)}',
  };
}

/// Name der Messgröße.
String measureLabel(SymptomMeasure measure, AppLocalizations l10n) =>
    switch (measure) {
      SymptomMeasure.intensity => l10n.measureIntensity,
      SymptomMeasure.temperature => l10n.measureTemperature,
      SymptomMeasure.count => l10n.measureCount,
      SymptomMeasure.duration => l10n.measureDuration,
      SymptomMeasure.pulse => l10n.measurePulse,
      SymptomMeasure.bloodPressure => l10n.measureBloodPressure,
      SymptomMeasure.spo2 => l10n.measureSpo2,
      SymptomMeasure.glucose => l10n.measureGlucose,
      SymptomMeasure.weight => l10n.measureWeight,
      SymptomMeasure.mood => l10n.measureMood,
    };

/// Einordnung des Werts („Fieber“, „Hypertonie Grad 1“ …), `null` wenn es
/// keine gibt (Anzahl, Dauer, Gewicht).
String? measureBandLabel(
  SymptomMeasure measure,
  double value,
  AppLocalizations l10n, {
  double? value2,
}) => switch (measure) {
  SymptomMeasure.intensity => intensityBandLabel(intensityBand(value), l10n),
  SymptomMeasure.temperature => switch (temperatureBand(value)) {
    TemperatureBand.normal => l10n.measureTempNormal,
    TemperatureBand.elevated => l10n.measureTempElevated,
    TemperatureBand.fever => l10n.measureTempFever,
    TemperatureBand.highFever => l10n.measureTempHighFever,
  },
  SymptomMeasure.bloodPressure => switch (bloodPressureBand(value, value2)) {
    BloodPressureBand.optimal => l10n.measureBpOptimal,
    BloodPressureBand.normal => l10n.measureBpNormal,
    BloodPressureBand.highNormal => l10n.measureBpHighNormal,
    BloodPressureBand.grade1 => l10n.measureBpGrade1,
    BloodPressureBand.grade2 => l10n.measureBpGrade2,
    BloodPressureBand.grade3 => l10n.measureBpGrade3,
  },
  SymptomMeasure.spo2 => switch (spo2Band(value)) {
    Spo2Band.normal => l10n.measureSpo2Normal,
    Spo2Band.low => l10n.measureSpo2Low,
    Spo2Band.check => l10n.measureSpo2Check,
    Spo2Band.urgent => l10n.measureSpo2Urgent,
  },
  SymptomMeasure.glucose => switch (glucoseBand(value)) {
    GlucoseBand.veryLow => l10n.measureGlucoseVeryLow,
    GlucoseBand.low => l10n.measureGlucoseLow,
    GlucoseBand.inRange => l10n.measureGlucoseInRange,
    GlucoseBand.high => l10n.measureGlucoseHigh,
    GlucoseBand.veryHigh => l10n.measureGlucoseVeryHigh,
  },
  SymptomMeasure.pulse => switch (pulseBand(value)) {
    PulseBand.low => l10n.measurePulseLow,
    PulseBand.normal => l10n.measurePulseNormal,
    PulseBand.high => l10n.measurePulseHigh,
  },
  SymptomMeasure.mood => moodLabel(value, l10n),
  _ => null,
};

/// Stimmung −5 … +5 als Wort. Anker nach dem Prinzip des NIMH Life Chart
/// Method (Leverich & Post 1998; Denicoff et al. 1997): Richtung
/// (depressiv/gehoben) und Ausmaß der Beeinträchtigung im Alltag (leicht =
/// ohne, mittel = mit deutlicher Mühe, schwer = kaum funktionsfähig).
String moodLabel(num value, AppLocalizations l10n) =>
    switch (value.round().clamp(-5, 5)) {
      -5 => l10n.moodM5,
      -4 => l10n.moodM4,
      -3 => l10n.moodM3,
      -2 => l10n.moodM2,
      -1 => l10n.moodM1,
      0 => l10n.mood0,
      1 => l10n.moodP1,
      2 => l10n.moodP2,
      3 => l10n.moodP3,
      4 => l10n.moodP4,
      _ => l10n.moodP5,
    };

/// Beschreibung der Alltagsfunktion je Stimmungswert.
String moodAnchor(num value, AppLocalizations l10n) =>
    switch (value.round().abs().clamp(0, 5)) {
      0 => l10n.moodAnchor0,
      1 => l10n.moodAnchorMild,
      2 || 3 => l10n.moodAnchorModerate,
      _ => l10n.moodAnchorSevere,
    };

/// „Temperatur 38,4 °C (Fieber)“ bzw. „Stimmung +2 (gehoben)“.
String measureValueText(
  SymptomMeasure measure,
  double value, {
  double? value2,
  AppLocalizations? l10n,
  UnitPreferences? units,
}) {
  final strings = l10n ?? AppLocale.strings;
  if (measure == SymptomMeasure.intensity) {
    return strings.settingsObservationScale(
      value.round().clamp(0, 10).toString(),
    );
  }
  final formatted = formatMeasureValue(
    measure,
    value,
    value2: value2,
    l10n: strings,
    units: units,
  );
  final band = measureBandLabel(measure, value, strings, value2: value2);
  final name = switch (measure) {
    SymptomMeasure.mood => strings.measureMoodShort,
    _ => measureLabel(measure, strings),
  };
  return band == null ? '$name $formatted' : '$name $formatted ($band)';
}
