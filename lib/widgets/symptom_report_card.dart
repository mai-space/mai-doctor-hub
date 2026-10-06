import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../data/app_database.dart';
import '../data/symptom_description.dart';
import '../l10n/l10n.dart';
import 'observation_chart.dart';

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
    final points = scalePoints(observations);
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
                  points.isEmpty
                      ? l10n.settingsSymptomReportCount(observations.length)
                      : l10n.settingsSymptomReportCountStats(
                          observations.length,
                          _avg(points),
                          points.last.value.toStringAsFixed(0),
                        ),
                  style: theme.textTheme.bodySmall,
                ),
                if (points.length > 1) ...[
                  const SizedBox(height: 8),
                  ObservationChart(points: points, height: 90),
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

  static String _avg(List<ChartPoint> points) =>
      (points.map((p) => p.value).reduce((a, b) => a + b) / points.length)
          .toStringAsFixed(1);
}

/// Lesbarer Wert eines Check-ins (auch außerhalb von Widgets genutzt),
/// mit strukturierter Beschreibung davor, falls vorhanden:
/// „Schmerz (brennend) · Hinterkopf (links) · Stärke 7/10“.
String observationLabel(SymptomObservation o) {
  final description = SymptomDescription.fromObservation(o);
  final value = _observationValue(o);
  if (description.isEmpty) return value;
  return '${description.describe(AppLocale.strings, withIntensity: false)}'
      ' · $value';
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
};
