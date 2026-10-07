import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../data/app_database.dart';
import '../data/symptom_description.dart';
import '../data/symptom_measure.dart';
import '../l10n/l10n.dart';
import 'measure_chart.dart';

/// Symptom mit den im Zeitraum gemeldeten Check-ins (Diagramm + Werte).
class SymptomReportCard extends StatelessWidget {
  const SymptomReportCard({
    super.key,
    required this.symptom,
    required this.observations,
    required this.from,
    required this.to,
    this.onTap,
  });

  final Symptom symptom;
  final List<SymptomObservation> observations;
  final DateTime from;
  final DateTime to;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final day = DateFormat(l10n.settingsChartDayPattern);
    final dayTime = DateFormat(l10n.settingsChartDayTimePattern);
    // v15: je Messgröße des Symptoms (Stärke, Temperatur, Anzahl …).
    final measure = symptomMeasures(symptom).primary;
    final stats = MeasureStats.of(observations, measure);
    final chart = MeasureChartData.from(observations, measure);
    final latest = observations.reversed.take(5).toList();
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      symptom.label,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    '${day.format(from)} – ${day.format(to)}',
                    style: theme.textTheme.labelSmall,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              if (observations.isEmpty)
                Text(
                  l10n.settingsSymptomReportNoCheckIns,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
              else ...[
                Text(
                  stats == null
                      ? l10n.settingsSymptomReportCount(observations.length)
                      : measure == SymptomMeasure.intensity
                      ? l10n.settingsSymptomReportCountStats(
                          observations.length,
                          _avg(stats.average),
                          stats.last.toStringAsFixed(0),
                        )
                      : l10n.measureStatsCount(
                          observations.length,
                          stats.describe(measure, l10n),
                        ),
                  style: theme.textTheme.bodySmall,
                ),
                if ((stats?.count ?? 0) > 1) ...[
                  const SizedBox(height: 8),
                  MeasureChart(data: chart, height: 90),
                ],
                const SizedBox(height: 4),
                for (final o in latest)
                  Text(
                    '${dayTime.format(o.recordedAt)} · ${observationLabel(o)}',
                    style: theme.textTheme.bodySmall,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static String _avg(double average) => average.toStringAsFixed(1);
}

/// Lesbarer Wert eines Check-ins (auch außerhalb von Widgets genutzt),
/// mit strukturierter Beschreibung davor, falls vorhanden:
/// „Schmerz (brennend) · Hinterkopf (links) · Stärke 7/10“. v15: Messwerte
/// mit Einheit („Temperatur 38,4 °C (Fieber)“), Zusatzwert und
/// Stimmungs-Extras; das Tagebuch nur mit [withJournal].
String observationLabel(SymptomObservation o, {bool withJournal = false}) {
  final description = SymptomDescription.fromObservation(o);
  final value = [
    _observationValue(o),
    ...observationExtras(o),
    if (withJournal && o.journal?.trim().isNotEmpty == true)
      '„${o.journal!.trim()}“',
  ].join(' · ');
  if (description.isEmpty) return value;
  return '${description.describe(AppLocale.strings, withIntensity: false)}'
      ' · $value';
}

/// Zusatzwert und Stimmungs-Extras eines Check-ins als Texte.
List<String> observationExtras(SymptomObservation o) {
  final l10n = AppLocale.strings;
  final secondary = SymptomMeasure.fromCode(o.measure2);
  return [
    if (secondary != null && o.secondaryValue != null)
      measureValueText(secondary, o.secondaryValue!, l10n: l10n),
    if (o.energy != null) l10n.moodEnergyValue('${o.energy}'),
    if (o.sleepHours != null)
      l10n.moodSleepValue(
        formatNumber(
          o.sleepHours!,
          digits: o.sleepHours! == o.sleepHours!.roundToDouble() ? 0 : 1,
          locale: l10n.localeName,
        ),
      ),
    if (o.anxiety != null) l10n.moodAnxietyValue('${o.anxiety}'),
  ];
}

String _observationValue(SymptomObservation o) => switch (o.kind) {
  ObservationKind.scale_1_10 => AppLocale.strings.settingsObservationScale(
    o.valueNumber?.toStringAsFixed(0) ?? '–',
  ),
  ObservationKind.quantity =>
    '${o.valueNumber?.toString() ?? '–'} ${o.unit ?? ''}'.trim(),
  ObservationKind.color => AppLocale.strings.settingsObservationColor(
    o.valueColor ?? o.valueText ?? '',
  ),
  ObservationKind.note => o.valueText ?? o.note ?? AppLocale.strings.entityNote,
  ObservationKind.measurement => switch ((
    SymptomMeasure.fromCode(o.measure),
    o.valueNumber,
  )) {
    (final m?, final v?) => measureValueText(m, v, value2: o.valueNumber2),
    _ => '${o.valueNumber?.toString() ?? '–'} ${o.unit ?? ''}'.trim(),
  },
};
