import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../data/app_database.dart';
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

  static final _day = DateFormat('d.M.', 'de');
  static final _dayTime = DateFormat('d.M. HH:mm', 'de');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                    '${_day.format(from)} – ${_day.format(to)}',
                    style: theme.textTheme.labelSmall,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              if (observations.isEmpty)
                Text(
                  'Keine Check-ins in diesem Zeitraum.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                )
              else ...[
                Text(
                  '${observations.length} Check-in(s)'
                  '${points.isEmpty ? '' : ' · Ø ${_avg(points)} · zuletzt ${points.last.value.toStringAsFixed(0)}/10'}',
                  style: theme.textTheme.bodySmall,
                ),
                if (points.length > 1) ...[
                  const SizedBox(height: 8),
                  ObservationChart(points: points, height: 90),
                ],
                const SizedBox(height: 4),
                for (final o in latest)
                  Text(
                    '${_dayTime.format(o.recordedAt)} · ${observationLabel(o)}',
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

/// Lesbarer Wert eines Check-ins.
String observationLabel(SymptomObservation o) => switch (o.kind) {
  ObservationKind.scale_1_10 =>
    'Stärke ${o.valueNumber?.toStringAsFixed(0) ?? '–'}/10',
  ObservationKind.quantity =>
    '${o.valueNumber?.toString() ?? '–'} ${o.unit ?? ''}'.trim(),
  ObservationKind.color => 'Farbe ${o.valueColor ?? o.valueText ?? ''}',
  ObservationKind.note => o.valueText ?? o.note ?? 'Notiz',
};
