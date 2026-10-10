/// Auswertung des Zyklus-Tagebuchs — reine Funktionen, ohne Datenbank.
///
/// Begriffe und Schwellen (nur für neutrale Hinweise „lohnt sich, mit deiner
/// Gynäkologin/deinem Gynäkologen zu besprechen“, keine Diagnosen):
/// * Periode: aufeinanderfolgende Tage mit Blutung ≥ leicht; ein Tag Lücke
///   ist erlaubt. Schmierblutung allein beginnt keine Periode.
/// * Zykluslänge: Beginn bis Beginn der nächsten Periode.
/// * FIGO 2018 (Munro MG et al., Int J Gynaecol Obstet 2018;143:393–408):
///   normale Zykluslänge 24–38 Tage, Schwankung kürzester↔längster Zyklus
///   bis 7–9 Tage (altersabhängig); Patientinnen-Informationen (z. B. NHS,
///   frauenaerzte-im-netz.de) nennen 21–35 Tage. Hinweis hier: wiederholt
///   < 21 oder > 35 Tage, Schwankung ≥ 10 Tage (> 9), Periode > 7 Tage.
/// * PBAC > 100 je Zyklus (Higham 1990) → verstärkte Regelblutung möglich.
/// * Schmerz ≥ 7/10 an ≥ 2 Tagen eines Zyklus oder Schmerzmittel hilft nicht.
/// * Blutung zwischen den Perioden, Blutung nach ≥ 12 Monaten ohne Periode
///   (Wechseljahre) und jede Blutung in der Schwangerschaft → ärztlich
///   abklären lassen.
/// * Prognose: Median der letzten bis zu 6 Zyklen, Spanne ± halbe Schwankung;
///   Eisprung ≈ nächster Beginn − 14 Tage (grobe Schätzung, keine Verhütung).
///   Solange weniger als 2 abgeschlossene Zyklen vorliegen, zählt die
///   angegebene übliche Zykluslänge (Zyklus-Start) mit, ohne Angabe 28 Tage
///   (in der Oberfläche als Standardwert gekennzeichnet).
library;

import 'dart:math' as math;

import '../../data/app_database.dart';
import 'cycle_dates.dart';
import 'pbac.dart';

/// Ein Tag aus dem Tagebuch, reduziert auf das, was die Auswertung braucht.
class CycleLog {
  const CycleLog({
    required this.day,
    this.flow,
    this.pain,
    this.symptoms = const [],
    this.painkiller,
    this.painkillerHelped,
    this.pbac = 0,
    this.hotFlashes,
    this.nightSweats,
    this.fetalMovement,
    this.weightKg,
    this.bpSystolic,
    this.bpDiastolic,
    this.hasNote = false,
  });

  factory CycleLog.fromRow(CycleDay row) => CycleLog(
    day: parseDayKey(row.day)!,
    flow: row.flow,
    pain: row.pain,
    symptoms: splitKeys(row.symptoms),
    painkiller: row.painkiller,
    painkillerHelped: row.painkillerHelped,
    pbac: PbacCounts.parse(row.pbacJson).score,
    hotFlashes: row.hotFlashes,
    nightSweats: row.nightSweats,
    fetalMovement: row.fetalMovement,
    weightKg: row.weightKg,
    bpSystolic: row.bpSystolic,
    bpDiastolic: row.bpDiastolic,
    hasNote: row.note?.trim().isNotEmpty == true,
  );

  /// Lokaler Tag (Mitternacht).
  final DateTime day;
  final CycleFlow? flow;
  final int? pain;
  final List<String> symptoms;
  final bool? painkiller;
  final bool? painkillerHelped;
  final int pbac;
  final int? hotFlashes;
  final int? nightSweats;
  final FetalMovement? fetalMovement;
  final double? weightKg;
  final int? bpSystolic;
  final int? bpDiastolic;
  final bool hasNote;

  /// Blutung ≥ leicht (zählt zur Periode).
  bool get isPeriodFlow => flow != null && flow!.index >= CycleFlow.light.index;

  /// Jede Blutung inkl. Schmierblutung.
  bool get isBleeding =>
      flow != null && flow!.index >= CycleFlow.spotting.index;
}

/// Kommagetrennte Liste → Einträge (ohne leere/doppelte).
List<String> splitKeys(String? raw) {
  if (raw == null) return const [];
  final seen = <String>{};
  return [
    for (final part in raw.split(','))
      if (part.trim().isNotEmpty && seen.add(part.trim())) part.trim(),
  ];
}

String? joinKeys(Iterable<String> keys) {
  final list = keys.where((k) => k.trim().isNotEmpty).toList();
  return list.isEmpty ? null : list.join(',');
}

class Period {
  const Period(this.start, this.end);

  final DateTime start;
  final DateTime end;

  int get length => dayDiff(start, end) + 1;

  bool contains(DateTime day) => !day.isBefore(start) && !day.isAfter(end);

  @override
  bool operator ==(Object other) =>
      other is Period && other.start == start && other.end == end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'Period(${dayKey(start)}–${dayKey(end)})';
}

/// Zyklus ab Beginn einer Periode; [nextStart] fehlt beim laufenden Zyklus.
class Cycle {
  const Cycle({
    required this.period,
    this.nextStart,
    this.pbac = 0,
    this.strongPainDays = 0,
    this.painkillerNotHelping = false,
    this.pain = const {},
  });

  final Period period;
  final DateTime? nextStart;

  /// PBAC-Summe aller Tage des Zyklus.
  final int pbac;

  /// Tage mit Schmerz ≥ 7.
  final int strongPainDays;
  final bool painkillerNotHelping;

  /// Schmerz je Zyklustag (1 = erster Periodentag).
  final Map<int, int> pain;

  DateTime get start => period.start;
  bool get isComplete => nextStart != null;

  /// Länge in Tagen; `null` beim laufenden Zyklus.
  int? get length => nextStart == null ? null : dayDiff(start, nextStart!);
}

class CycleStats {
  const CycleStats({
    required this.count,
    required this.average,
    required this.median,
    required this.min,
    required this.max,
    required this.averagePeriodLength,
  });

  /// Anzahl ausgewerteter (abgeschlossener) Zyklen.
  final int count;
  final double average;
  final int median;
  final int min;
  final int max;
  final double averagePeriodLength;

  /// Kürzester bis längster Zyklus.
  int get variability => max - min;
}

/// Worauf die Prognose beruht.
enum CyclePredictionBasis {
  /// Mindestens zwei erfasste Zyklen.
  history,

  /// Angegebene übliche Zykluslänge (ggf. gemittelt mit einem Zyklus).
  typical,

  /// Weder Zyklen noch Angabe: Standardwert 28 Tage.
  defaultLength,
}

class CyclePrediction {
  const CyclePrediction({
    required this.start,
    required this.earliest,
    required this.latest,
    this.basis = CyclePredictionBasis.history,
  });

  final CyclePredictionBasis basis;

  /// Aus Angaben bzw. Standardwert geschätzt (noch zu wenige Zyklen).
  bool get isEstimated => basis != CyclePredictionBasis.history;

  /// Wahrscheinlichster Beginn der nächsten Periode.
  final DateTime start;
  final DateTime earliest;
  final DateTime latest;

  /// Eisprung grob geschätzt (Beginn − 14 Tage).
  DateTime get ovulation => plusDays(start, -14);

  /// Grob geschätztes fruchtbares Fenster: 5 Tage vor bis 1 Tag nach dem
  /// geschätzten Eisprung.
  DateTime get fertileFrom => plusDays(ovulation, -5);
  DateTime get fertileTo => plusDays(ovulation, 1);

  bool isFertile(DateTime day) =>
      !day.isBefore(fertileFrom) && !day.isAfter(fertileTo);

  /// Liegt [day] im erwarteten Periodenfenster (± Schwankung)?
  bool isExpected(DateTime day, {int periodLength = 5}) {
    final end = plusDays(start, periodLength - 1);
    return !day.isBefore(start) && !day.isAfter(end);
  }
}

enum CyclePhase { menstruation, follicular, ovulation, luteal }

enum CycleHintKind {
  shortCycles,
  longCycles,
  irregular,
  longPeriod,
  heavyBleeding,
  strongPain,
  painkillerNotHelping,
  intermenstrualBleeding,
  postmenopausalBleeding,
  pregnancyBleeding,
  reducedFetalMovement,
}

class CycleHint {
  const CycleHint(this.kind, [this.value]);

  final CycleHintKind kind;

  /// Wert zur Begründung (z. B. Tage, PBAC-Punkte).
  final int? value;

  /// Diese Hinweise bitte zeitnah abklären (nicht erst zur Vorsorge).
  bool get urgent => switch (kind) {
    CycleHintKind.postmenopausalBleeding ||
    CycleHintKind.pregnancyBleeding ||
    CycleHintKind.reducedFetalMovement => true,
    _ => false,
  };

  @override
  bool operator ==(Object other) =>
      other is CycleHint && other.kind == kind && other.value == value;

  @override
  int get hashCode => Object.hash(kind, value);

  @override
  String toString() => 'CycleHint(${kind.name}, $value)';
}

/// Grenzwerte (siehe Bibliotheks-Kommentar).
abstract final class CycleThresholds {
  static const shortCycle = 21;
  static const longCycle = 35;
  static const maxVariability = 9;
  static const longPeriod = 7;
  static const strongPain = 7;
  static const strongPainDays = 2;

  /// Längere „Zyklen“ sind meist vergessene Einträge → nicht in die Statistik.
  static const implausibleCycle = 90;
  static const statsWindow = 6;
  static const defaultCycleLength = 28;
  static const lutealDays = 14;
}

/// Gesamtauswertung für einen Stichtag.
class CycleAnalysis {
  factory CycleAnalysis(
    Iterable<CycleLog> logs, {
    required DateTime today,
    bool pregnant = false,
    bool menopause = false,
    DateTime? pregnancySince,
    int? typicalCycleLength,
  }) {
    final sorted = logs.toList()..sort((a, b) => a.day.compareTo(b.day));
    return CycleAnalysis._(
      sorted,
      cycleDay(today),
      pregnant,
      menopause,
      pregnancySince == null ? null : cycleDay(pregnancySince),
      typicalCycleLength,
    );
  }

  CycleAnalysis._(
    this.logs,
    this.today,
    this.pregnant,
    this.menopause,
    this.pregnancySince,
    this.typicalCycleLength,
  ) {
    periods = detectPeriods(logs);
    cycles = _buildCycles();
    stats = _stats();
    prediction = pregnant ? null : _predict();
    hints = _hints();
  }

  final List<CycleLog> logs;
  final DateTime today;
  final bool pregnant;
  final bool menopause;
  final DateTime? pregnancySince;

  /// Übliche Zykluslänge laut Angabe (v17), `null` = unbekannt.
  final int? typicalCycleLength;

  late final List<Period> periods;

  /// Alle Zyklen, ältester zuerst; der letzte ist ggf. der laufende.
  late final List<Cycle> cycles;
  late final CycleStats? stats;
  late final CyclePrediction? prediction;
  late final List<CycleHint> hints;

  late final Map<DateTime, CycleLog> byDay = {for (final l in logs) l.day: l};

  /// Abgeschlossene, plausible Zyklen (für Statistik und Diagramme).
  List<Cycle> get completedCycles => [
    for (final c in cycles)
      if (c.isComplete && c.length! <= CycleThresholds.implausibleCycle) c,
  ];

  Cycle? get currentCycle =>
      cycles.isNotEmpty && !cycles.last.isComplete ? cycles.last : null;

  /// Zyklustag (1 = erster Periodentag) für [day]; `null` vor der ersten
  /// erfassten Periode.
  int? cycleDayOf(DateTime day) {
    final c = _cycleFor(cycleDay(day));
    return c == null ? null : dayDiff(c.start, cycleDay(day)) + 1;
  }

  /// Läuft gerade eine Periode (letzter Periodentag heute oder gestern)?
  bool get inPeriod {
    if (periods.isEmpty) return false;
    final last = periods.last;
    return !today.isBefore(last.start) && dayDiff(last.end, today) <= 1;
  }

  /// Phase für [day] — abgeschlossene Zyklen mit tatsächlicher Länge, der
  /// laufende mit dem Median (bzw. 28 Tagen).
  CyclePhase? phaseOf(DateTime day) {
    final d = cycleDay(day);
    final c = _cycleFor(d);
    if (c == null) return null;
    final n = dayDiff(c.start, d) + 1;
    final length =
        c.length ??
        stats?.median ??
        typicalCycleLength ??
        CycleThresholds.defaultCycleLength;
    final periodLength = c.period.length;
    if (n <= periodLength) return CyclePhase.menstruation;
    final ovulation = math.max(
      length - CycleThresholds.lutealDays,
      periodLength + 1,
    );
    if (n >= ovulation - 2 && n <= ovulation + 1) return CyclePhase.ovulation;
    if (n < ovulation - 2) return CyclePhase.follicular;
    return CyclePhase.luteal;
  }

  Cycle? _cycleFor(DateTime day) {
    for (final c in cycles.reversed) {
      if (day.isBefore(c.start)) continue;
      if (c.nextStart == null || day.isBefore(c.nextStart!)) return c;
      return null;
    }
    return null;
  }

  /// Anteil der erfassten Tage je Phase, an denen ein Symptom notiert wurde
  /// (0–1), für die [top] häufigsten Symptome.
  List<(String, Map<CyclePhase, double>)> symptomsByPhase({int top = 5}) {
    final daysPerPhase = <CyclePhase, int>{};
    final hits = <String, Map<CyclePhase, int>>{};
    final totals = <String, int>{};
    for (final log in logs) {
      final phase = phaseOf(log.day);
      if (phase == null) continue;
      daysPerPhase[phase] = (daysPerPhase[phase] ?? 0) + 1;
      for (final s in log.symptoms) {
        totals[s] = (totals[s] ?? 0) + 1;
        final m = hits.putIfAbsent(s, () => {});
        m[phase] = (m[phase] ?? 0) + 1;
      }
    }
    final ranked = totals.keys.toList()
      ..sort((a, b) {
        final byCount = totals[b]!.compareTo(totals[a]!);
        return byCount != 0 ? byCount : a.compareTo(b);
      });
    return [
      for (final s in ranked.take(top))
        (
          s,
          {
            for (final phase in CyclePhase.values)
              phase: (daysPerPhase[phase] ?? 0) == 0
                  ? 0.0
                  : (hits[s]![phase] ?? 0) / daysPerPhase[phase]!,
          },
        ),
    ];
  }

  /// Häufigste Symptome insgesamt (Schlüssel, Anzahl Tage).
  List<(String, int)> topSymptoms({int top = 5, DateTime? since}) {
    final counts = <String, int>{};
    for (final log in logs) {
      if (since != null && log.day.isBefore(since)) continue;
      for (final s in log.symptoms) {
        counts[s] = (counts[s] ?? 0) + 1;
      }
    }
    final list = counts.entries.toList()
      ..sort((a, b) {
        final byCount = b.value.compareTo(a.value);
        return byCount != 0 ? byCount : a.key.compareTo(b.key);
      });
    return [for (final e in list.take(top)) (e.key, e.value)];
  }

  List<Cycle> _buildCycles() {
    final result = <Cycle>[];
    for (var i = 0; i < periods.length; i++) {
      final period = periods[i];
      final next = i + 1 < periods.length ? periods[i + 1].start : null;
      var pbac = 0;
      var strong = 0;
      var notHelping = false;
      final pain = <int, int>{};
      for (final log in logs) {
        if (log.day.isBefore(period.start)) continue;
        if (next != null && !log.day.isBefore(next)) break;
        pbac += log.pbac;
        final p = log.pain;
        if (p != null) {
          pain[dayDiff(period.start, log.day) + 1] = p;
          if (p >= CycleThresholds.strongPain) strong++;
        }
        if (log.painkiller == true && log.painkillerHelped == false) {
          notHelping = true;
        }
      }
      result.add(
        Cycle(
          period: period,
          nextStart: next,
          pbac: pbac,
          strongPainDays: strong,
          painkillerNotHelping: notHelping,
          pain: pain,
        ),
      );
    }
    return result;
  }

  CycleStats? _stats() {
    final recent = completedCycles.reversed
        .take(CycleThresholds.statsWindow)
        .toList();
    if (recent.isEmpty) return null;
    final lengths = [for (final c in recent) c.length!]..sort();
    final mid = lengths.length ~/ 2;
    final median = lengths.length.isOdd
        ? lengths[mid]
        : ((lengths[mid - 1] + lengths[mid]) / 2).round();
    final periodLengths = [for (final c in recent) c.period.length];
    return CycleStats(
      count: lengths.length,
      average: lengths.reduce((a, b) => a + b) / lengths.length,
      median: median,
      min: lengths.first,
      max: lengths.last,
      averagePeriodLength:
          periodLengths.reduce((a, b) => a + b) / periodLengths.length,
    );
  }

  CyclePrediction? _predict() {
    final s = stats;
    if (periods.isEmpty) return null;
    final last = periods.last.start;
    if (s == null || s.count < 2) {
      // Zu wenige Zyklen: Angabe (mit einem Zyklus gemittelt) bzw. 28 Tage.
      final typical = typicalCycleLength;
      if (s != null && typical == null) return _range(last, s.median, 3);
      if (typical == null) {
        return _range(
          last,
          CycleThresholds.defaultCycleLength,
          5,
          CyclePredictionBasis.defaultLength,
        );
      }
      final length = s == null ? typical : ((s.median + typical) / 2).round();
      return _range(last, length, 3, CyclePredictionBasis.typical);
    }
    final start = plusDays(last, s.median);
    // Spanne: halbe Schwankung, mindestens 1, höchstens 7 Tage; bei nur einem
    // Zyklus ± 3 Tage.
    final half = s.count < 2 ? 3 : ((s.variability + 1) ~/ 2).clamp(1, 7);
    return CyclePrediction(
      start: start,
      earliest: plusDays(start, -half),
      latest: plusDays(start, half),
    );
  }

  CyclePrediction _range(
    DateTime last,
    int length,
    int half, [
    CyclePredictionBasis basis = CyclePredictionBasis.history,
  ]) {
    final start = plusDays(last, length);
    return CyclePrediction(
      start: start,
      earliest: plusDays(start, -half),
      latest: plusDays(start, half),
      basis: basis,
    );
  }

  /// Periode später als die geschätzte Spanne (Tage nach [latest]). Nicht
  /// beim bloßen Standardwert (28 Tage) — der sagt über „zu spät“ nichts.
  int? get daysLate {
    final p = prediction;
    if (p == null || inPeriod) return null;
    if (p.basis == CyclePredictionBasis.defaultLength) return null;
    final late = dayDiff(p.latest, today);
    return late > 0 ? late : null;
  }

  List<CycleHint> _hints() {
    final result = <CycleHint>[];
    final recent = completedCycles.reversed
        .take(CycleThresholds.statsWindow)
        .toList();
    if (!pregnant && recent.length >= 2) {
      final short = recent
          .where((c) => c.length! < CycleThresholds.shortCycle)
          .length;
      final long = recent
          .where((c) => c.length! > CycleThresholds.longCycle)
          .length;
      // „Regelmäßig“: mindestens zwei und mindestens die Hälfte.
      if (short >= 2 && short * 2 >= recent.length) {
        result.add(CycleHint(CycleHintKind.shortCycles, stats!.median));
      }
      if (long >= 2 && long * 2 >= recent.length) {
        result.add(CycleHint(CycleHintKind.longCycles, stats!.median));
      }
    }
    final s = stats;
    if (!pregnant &&
        s != null &&
        s.count >= 3 &&
        s.variability > CycleThresholds.maxVariability) {
      result.add(CycleHint(CycleHintKind.irregular, s.variability));
    }

    // Letzte drei Zyklen inkl. laufendem.
    final lastThree = cycles.reversed.take(3).toList();
    final longest = lastThree.isEmpty
        ? 0
        : lastThree.map((c) => c.period.length).reduce(math.max);
    if (longest > CycleThresholds.longPeriod) {
      result.add(CycleHint(CycleHintKind.longPeriod, longest));
    }
    final maxPbac = lastThree.isEmpty
        ? 0
        : lastThree.map((c) => c.pbac).reduce(math.max);
    if (maxPbac > pbacHeavyThreshold) {
      result.add(CycleHint(CycleHintKind.heavyBleeding, maxPbac));
    }
    final painDays = lastThree.isEmpty
        ? 0
        : lastThree.map((c) => c.strongPainDays).reduce(math.max);
    if (painDays >= CycleThresholds.strongPainDays) {
      result.add(CycleHint(CycleHintKind.strongPain, painDays));
    }
    if (lastThree.any((c) => c.painkillerNotHelping)) {
      result.add(const CycleHint(CycleHintKind.painkillerNotHelping));
    }

    final window = plusDays(today, -90);
    if (!pregnant) {
      // Schmierblutung außerhalb der Perioden (± 2 Tage).
      final between = logs.where(
        (l) =>
            !l.day.isBefore(window) &&
            l.isBleeding &&
            !l.isPeriodFlow &&
            !periods.any(
              (p) =>
                  !l.day.isBefore(plusDays(p.start, -2)) &&
                  !l.day.isAfter(plusDays(p.end, 2)),
            ),
      );
      if (between.length >= 2) {
        result.add(
          CycleHint(CycleHintKind.intermenstrualBleeding, between.length),
        );
      }
    }

    if (menopause && !pregnant) {
      // Blutung nach ≥ 12 Monaten ohne jede Blutung.
      final bleeding = [
        for (final l in logs)
          if (l.isBleeding) l.day,
      ];
      for (var i = 1; i < bleeding.length; i++) {
        if (bleeding[i].isBefore(window)) continue;
        if (dayDiff(bleeding[i - 1], bleeding[i]) >= 365) {
          result.add(const CycleHint(CycleHintKind.postmenopausalBleeding));
          break;
        }
      }
    }

    if (pregnant) {
      final since = pregnancySince;
      final recentWeek = plusDays(today, -7);
      if (logs.any(
        (l) =>
            l.isBleeding &&
            !l.day.isBefore(recentWeek) &&
            (since == null || !l.day.isBefore(since)),
      )) {
        result.add(const CycleHint(CycleHintKind.pregnancyBleeding));
      }
      final recentDays = plusDays(today, -3);
      if (logs.any(
        (l) =>
            l.fetalMovement == FetalMovement.less &&
            !l.day.isBefore(recentDays),
      )) {
        result.add(const CycleHint(CycleHintKind.reducedFetalMovement));
      }
    }
    // Dringliches zuerst (Reihenfolge sonst beibehalten).
    return [
      ...result.where((h) => h.urgent),
      ...result.where((h) => !h.urgent),
    ];
  }
}

/// Perioden aus den Tagen: Blutung ≥ leicht, höchstens ein Tag Lücke.
List<Period> detectPeriods(Iterable<CycleLog> logs) {
  final days = [
    for (final l in logs)
      if (l.isPeriodFlow) l.day,
  ]..sort();
  final result = <Period>[];
  DateTime? start;
  DateTime? end;
  for (final day in days) {
    if (start != null && dayDiff(end!, day) <= 2) {
      end = day;
      continue;
    }
    if (start != null) result.add(Period(start, end!));
    start = day;
    end = day;
  }
  if (start != null) result.add(Period(start, end!));
  return result;
}
