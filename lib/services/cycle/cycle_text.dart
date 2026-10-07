/// Texte rund um den Zyklus — für Oberfläche, PDF, Assistent und
/// Benachrichtigungen (immer mit den übergebenen [AppLocalizations]).
library;

import 'package:intl/intl.dart';

import '../../data/app_database.dart';
import '../../data/repositories/cycle_repository.dart';
import '../../l10n/l10n.dart';
import 'cycle_analytics.dart';
import 'cycle_dates.dart';
import 'mrs.dart';
import 'pregnancy_math.dart';

String flowLabel(CycleFlow flow, AppLocalizations l10n) => switch (flow) {
  CycleFlow.none => l10n.cycleFlowNone,
  CycleFlow.spotting => l10n.cycleFlowSpotting,
  CycleFlow.light => l10n.cycleFlowLight,
  CycleFlow.medium => l10n.cycleFlowMedium,
  CycleFlow.heavy => l10n.cycleFlowHeavy,
  CycleFlow.veryHeavy => l10n.cycleFlowVeryHeavy,
};

String phaseLabel(CyclePhase phase, AppLocalizations l10n) => switch (phase) {
  CyclePhase.menstruation => l10n.cyclePhaseMenstruation,
  CyclePhase.follicular => l10n.cyclePhaseFollicular,
  CyclePhase.ovulation => l10n.cyclePhaseOvulation,
  CyclePhase.luteal => l10n.cyclePhaseLuteal,
};

String mrsSeverityLabel(MrsSeverity s, AppLocalizations l10n) => switch (s) {
  MrsSeverity.none => l10n.cycleMrsSeverityNone,
  MrsSeverity.mild => l10n.cycleMrsSeverityMild,
  MrsSeverity.moderate => l10n.cycleMrsSeverityModerate,
  MrsSeverity.severe => l10n.cycleMrsSeveritySevere,
};

String mrsSubscaleLabel(MrsSubscale s, AppLocalizations l10n) => switch (s) {
  MrsSubscale.somatic => l10n.cycleMrsSomatic,
  MrsSubscale.psychological => l10n.cycleMrsPsychological,
  MrsSubscale.urogenital => l10n.cycleMrsUrogenital,
};

/// MRS-Item-Texte (Reihenfolge wie im Original-Fragebogen).
List<String> mrsItemLabels(AppLocalizations l10n) => [
  l10n.cycleMrsItem1,
  l10n.cycleMrsItem2,
  l10n.cycleMrsItem3,
  l10n.cycleMrsItem4,
  l10n.cycleMrsItem5,
  l10n.cycleMrsItem6,
  l10n.cycleMrsItem7,
  l10n.cycleMrsItem8,
  l10n.cycleMrsItem9,
  l10n.cycleMrsItem10,
  l10n.cycleMrsItem11,
];

/// „12 (mittel) · körperlich 5 · psychisch 4 · urogenital 3“.
String mrsSummary(MrsResult r, AppLocalizations l10n) => [
  l10n.cycleMrsTotal(r.total, mrsSeverityLabel(r.severity, l10n)),
  for (final s in MrsSubscale.values)
    '${mrsSubscaleLabel(s, l10n)} ${r.subscale(s)}',
].join(' · ');

/// „Vorsorge (SSW 20)“ bzw. „Basis-Ultraschall (SSW 19–22)“.
String milestoneTitle(PregnancyMilestone m, AppLocalizations l10n) =>
    switch (m.kind) {
      MilestoneKind.checkup => l10n.cycleMilestoneCheckup(m.weeksLabel),
      MilestoneKind.ultrasound => l10n.cycleMilestoneUltrasound(m.weeksLabel),
    };

/// Begründeter, neutraler Hinweis.
String hintText(CycleHint hint, AppLocalizations l10n) {
  final v = hint.value ?? 0;
  return switch (hint.kind) {
    CycleHintKind.shortCycles => l10n.cycleHintShortCycles(v),
    CycleHintKind.longCycles => l10n.cycleHintLongCycles(v),
    CycleHintKind.irregular => l10n.cycleHintIrregular(v),
    CycleHintKind.longPeriod => l10n.cycleHintLongPeriod(v),
    CycleHintKind.heavyBleeding => l10n.cycleHintHeavyBleeding(v),
    CycleHintKind.strongPain => l10n.cycleHintStrongPain(v),
    CycleHintKind.painkillerNotHelping => l10n.cycleHintPainkiller,
    CycleHintKind.intermenstrualBleeding => l10n.cycleHintIntermenstrual(v),
    CycleHintKind.postmenopausalBleeding => l10n.cycleHintPostmenopausal,
    CycleHintKind.pregnancyBleeding => l10n.cycleHintPregnancyBleeding,
    CycleHintKind.reducedFetalMovement => l10n.cycleHintFetalMovement,
  };
}

/// Statuszeilen für Startkarte und Seitenkopf, z. B. „Zyklustag 12 ·
/// nächste Periode in ~16 Tagen (geschätzt)“ oder „SSW 14+3 · 2. Trimester“.
List<String> cycleStatusLines(CycleOverview o, AppLocalizations l10n) {
  final lines = <String>[];
  final date = DateFormat(l10n.cycleDatePattern);
  if (o.pregnancyTracking) {
    final s = o.pregnancyStatus;
    if (s == null) {
      lines.add(l10n.cyclePregnancyNoDates);
    } else {
      lines.add(
        [
          l10n.cyclePregnancyWeek(s.age.label),
          l10n.cyclePregnancyTrimester(s.age.trimester),
          if (s.daysToDue >= 0)
            l10n.cyclePregnancyDaysToDue(s.daysToDue)
          else
            l10n.cyclePregnancyDue(date.format(s.dueDate)),
        ].join(' · '),
      );
    }
  }
  if (o.cycleTracking && !o.pregnant) {
    final a = o.analysis;
    final day = a.cycleDayOf(o.today);
    final p = a.prediction;
    if (day == null) {
      lines.add(l10n.cycleStatusNoData);
    } else {
      final parts = <String>[
        a.inPeriod
            ? l10n.cycleStatusPeriodDay(
                dayDiff(a.periods.last.start, o.today) + 1,
              )
            : l10n.cycleStatusCycleDay(day),
      ];
      final late = a.daysLate;
      if (late != null) {
        parts.add(l10n.cycleStatusLate);
      } else if (p != null && !a.inPeriod) {
        final until = dayDiff(o.today, p.start);
        parts.add(
          until > 0
              ? l10n.cycleStatusNextIn(until)
              : l10n.cycleStatusExpectedNow,
        );
      }
      lines.add(parts.join(' · '));
    }
  }
  if (o.menopauseTracking) {
    final m = o.latestMrs;
    final todayRow = o.rowFor(o.today);
    lines.add(
      [
        if (m == null)
          l10n.cycleMrsNotYet
        else
          l10n.cycleMrsLatest(
            MrsResult.parse(m.scores).total,
            mrsSeverityLabel(MrsResult.parse(m.scores).severity, l10n),
            date.format(m.recordedAt),
          ),
        if (todayRow?.hotFlashes != null)
          l10n.cycleHotFlashesToday(todayRow!.hotFlashes!),
      ].join(' · '),
    );
  }
  return lines;
}
