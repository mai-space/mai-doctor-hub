/// Zusammenfassung des Zyklus-Tagebuchs für das Arzt-PDF und den
/// Assistenten — kompakt, sachlich, ohne Bewertung.
library;

import 'package:intl/intl.dart';

import '../../data/cycle_catalog.dart';
import '../../data/repositories/cycle_repository.dart';
import '../../data/symptom_measure.dart'
    show SymptomMeasure, formatMeasureValue;
import '../../l10n/l10n.dart';
import 'cycle_analytics.dart';
import 'cycle_dates.dart';
import 'cycle_text.dart';
import 'mrs.dart';

/// Zeile der Zyklus-Tabelle.
class CycleRow {
  const CycleRow({
    required this.start,
    this.length,
    required this.periodLength,
    this.pbac,
    required this.strongPainDays,
  });

  final DateTime start;

  /// `null` beim laufenden Zyklus.
  final int? length;
  final int periodLength;

  /// `null`, wenn in diesem Zyklus nichts gezählt wurde.
  final int? pbac;
  final int strongPainDays;
}

class CycleReport {
  const CycleReport({
    required this.cycleTracking,
    required this.cycles,
    required this.hints,
    required this.topSymptoms,
    required this.painDays,
    this.stats,
    this.pregnancyWeek,
    this.dueDate,
    this.latestWeight,
    this.latestBp,
    this.mrs,
    this.mrsDate,
  });

  /// Wertet die letzten 6 Zyklen und 180 Tage aus.
  factory CycleReport.from(CycleOverview o) {
    final a = o.analysis;
    final since = plusDays(o.today, -180);
    final recent = a.cycles.reversed.take(6).toList().reversed;
    (double, DateTime)? weight;
    (int, int, DateTime)? bp;
    for (final r in o.rows) {
      final day = parseDayKey(r.day)!;
      if (r.weightKg != null) weight = (r.weightKg!, day);
      if (r.bpSystolic != null && r.bpDiastolic != null) {
        bp = (r.bpSystolic!, r.bpDiastolic!, day);
      }
    }
    final mrs = o.latestMrs;
    return CycleReport(
      cycleTracking: o.cycleTracking,
      cycles: [
        for (final c in recent)
          CycleRow(
            start: c.start,
            length: c.length,
            periodLength: c.period.length,
            pbac: c.pbac > 0 ? c.pbac : null,
            strongPainDays: c.strongPainDays,
          ),
      ],
      stats: a.stats,
      hints: a.hints,
      topSymptoms: a.topSymptoms(since: since),
      painDays: o.rows
          .where(
            (r) => (r.pain ?? 0) > 0 && !parseDayKey(r.day)!.isBefore(since),
          )
          .length,
      pregnancyWeek: o.pregnancyStatus?.age.label,
      dueDate: o.pregnancyStatus?.dueDate,
      latestWeight: o.pregnant ? weight : null,
      latestBp: o.pregnant ? bp : null,
      mrs: mrs == null ? null : MrsResult.parse(mrs.scores),
      mrsDate: mrs?.recordedAt,
    );
  }

  final bool cycleTracking;
  final List<CycleRow> cycles;
  final CycleStats? stats;
  final List<CycleHint> hints;

  /// (Symptom-Schlüssel, Anzahl Tage) der letzten 180 Tage.
  final List<(String, int)> topSymptoms;

  /// Tage mit Schmerz > 0 in den letzten 180 Tagen.
  final int painDays;
  final String? pregnancyWeek;
  final DateTime? dueDate;
  final (double, DateTime)? latestWeight;
  final (int, int, DateTime)? latestBp;
  final MrsResult? mrs;
  final DateTime? mrsDate;

  bool get isEmpty =>
      cycles.isEmpty &&
      topSymptoms.isEmpty &&
      pregnancyWeek == null &&
      dueDate == null &&
      mrs == null &&
      latestWeight == null &&
      latestBp == null;

  /// Überblick als Textzeilen (ohne Zyklus-Tabelle).
  List<String> summaryLines(AppLocalizations l10n) {
    final date = DateFormat(l10n.cycleDatePattern);
    final decimal = NumberFormat.decimalPattern(l10n.localeName);
    final s = stats;
    return [
      if (pregnancyWeek != null) l10n.cyclePregnancyWeek(pregnancyWeek!),
      if (dueDate != null) l10n.cyclePregnancyDue(date.format(dueDate!)),
      if (latestWeight case (final kg, final day)?)
        // v15: in der gewählten Einheit (kg/lb).
        l10n.cycleReportWeightValue(
          formatMeasureValue(SymptomMeasure.weight, kg, l10n: l10n),
          date.format(day),
        ),
      if (latestBp case (final sys, final dia, final day)?)
        l10n.cycleReportBp(sys, dia, date.format(day)),
      if (s != null)
        l10n.cycleReportStats(
          decimal.format(double.parse(s.average.toStringAsFixed(1))),
          s.median,
          s.min,
          s.max,
          s.count,
        ),
      if (s != null)
        l10n.cycleReportPeriodLength(
          decimal.format(
            double.parse(s.averagePeriodLength.toStringAsFixed(1)),
          ),
        ),
      if (painDays > 0) l10n.cycleReportPainDays(painDays),
      if (topSymptoms.isNotEmpty)
        l10n.cycleReportTopSymptoms(
          topSymptoms
              .map((e) => '${CycleCatalog.symptomLabel(e.$1)} (${e.$2})')
              .join(', '),
        ),
      if (mrs != null)
        '${l10n.cycleMrsTitle} ${mrsDate == null ? '' : date.format(mrsDate!)}: '
            '${mrsSummary(mrs!, l10n)}',
    ];
  }

  /// Zyklus-Tabelle: Beginn, Länge, Periode, PBAC, Tage Schmerz ≥ 7.
  List<List<String>> cycleTable(AppLocalizations l10n) {
    final date = DateFormat(l10n.cycleDatePattern);
    return [
      for (final c in cycles.reversed)
        [
          date.format(c.start),
          c.length == null ? l10n.cycleReportRunning : '${c.length}',
          '${c.periodLength}',
          c.pbac == null ? '–' : '${c.pbac}',
          '${c.strongPainDays}',
        ],
    ];
  }

  /// Kompakte Zeilen für den Assistenten.
  List<String> contextLines(AppLocalizations l10n) {
    final date = DateFormat(l10n.cycleDatePattern);
    return [
      ...summaryLines(l10n),
      if (cycles.isNotEmpty)
        l10n.cycleReportRecentStarts(
          cycles.map((c) => date.format(c.start)).join(', '),
        ),
      for (final h in hints) hintText(h, l10n),
    ];
  }
}
