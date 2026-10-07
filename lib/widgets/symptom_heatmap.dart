import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../data/app_database.dart';
import '../data/measure_units.dart';
import '../data/symptom_description.dart';
import '../data/symptom_measure.dart';
import '../l10n/l10n.dart';
import 'symptom_report_card.dart' show observationLabel;

/// Lokales Kalenderdatum (Mitternacht, ohne Uhrzeit).
DateTime localDay(DateTime at) {
  final local = at.toLocal();
  return DateTime(local.year, local.month, local.day);
}

/// [day] plus [days] Kalendertage — über DateTime(y, m, d + n) statt
/// `Duration`, damit Sommer-/Winterzeit keinen Tag verschluckt.
DateTime addDays(DateTime day, int days) =>
    DateTime(day.year, day.month, day.day + days);

/// Kalendertage zwischen zwei lokalen Tagen (zeitzonenunabhängig über UTC).
int daysBetween(DateTime from, DateTime to) => DateTime.utc(
  to.year,
  to.month,
  to.day,
).difference(DateTime.utc(from.year, from.month, from.day)).inDays;

/// Höchste Stärke (0–10) je lokalem Kalendertag.
Map<DateTime, double> dailyMaxIntensity(
  Iterable<SymptomObservation> observations,
) {
  final result = <DateTime, double>{};
  for (final o in observations) {
    final value = o.valueNumber;
    if (o.kind != ObservationKind.scale_1_10 || value == null) continue;
    final day = localDay(o.recordedAt);
    final clamped = value.clamp(0, 10).toDouble();
    final current = result[day];
    if (current == null || clamped > current) result[day] = clamped;
  }
  return result;
}

/// v15: Tageswert einer Messgröße mit Schweregrad 0–10 (siehe
/// [measureSeverity]). Anzahl/Dauer: Summe des Tages, Schweregrad relativ
/// zum höchsten Tageswert; sonst der auffälligste Wert des Tages (SpO₂: der
/// niedrigste, Stimmung: der weiteste von 0).
typedef DayMeasure = ({double severity, double value, double? value2});

Map<DateTime, DayMeasure> dailySeverity(
  Iterable<SymptomObservation> observations,
  SymptomMeasure measure,
) {
  final values = <DateTime, List<(double, double?)>>{};
  for (final o in observations) {
    final double? value;
    double? value2;
    if (observationMeasure(o) == measure) {
      value = o.valueNumber;
      value2 = o.valueNumber2;
    } else if (SymptomMeasure.fromCode(o.measure2) == measure) {
      value = o.secondaryValue;
    } else {
      continue;
    }
    if (value == null) continue;
    (values[localDay(o.recordedAt)] ??= []).add((value, value2));
  }
  if (measure == SymptomMeasure.count || measure == SymptomMeasure.duration) {
    final sums = {
      for (final e in values.entries)
        e.key: e.value.fold<double>(0, (sum, v) => sum + v.$1),
    };
    final max = sums.values.fold<double>(0, (m, v) => v > m ? v : m);
    return {
      for (final e in sums.entries)
        e.key: (
          severity: measureSeverity(measure, e.value, maxValue: max),
          value: e.value,
          value2: null,
        ),
    };
  }
  final result = <DateTime, DayMeasure>{};
  for (final e in values.entries) {
    DayMeasure? worst;
    for (final (v, v2) in e.value) {
      final severity = measure == SymptomMeasure.intensity
          ? v.clamp(0, 10).toDouble()
          : measureSeverity(measure, v, value2: v2);
      // Gleichstand: auffälligerer Rohwert (SpO₂ niedriger, sonst weiter weg).
      final better =
          worst == null ||
          severity > worst.severity ||
          (severity == worst.severity &&
              (measure == SymptomMeasure.spo2
                  ? v < worst.value
                  : v.abs() > worst.value.abs()));
      if (better) worst = (severity: severity, value: v, value2: v2);
    }
    result[e.key] = worst!;
  }
  return result;
}

/// v16: Tageswert mit der Messgröße, aus der er stammt.
typedef MixedDayMeasure = ({SymptomMeasure measure, DayMeasure day});

/// Wie [dailySeverity] für [current], aber Tage mit Check-ins einer früheren
/// Messgröße (vor einem Wechsel) werden nach deren eigenem Schweregrad
/// eingefärbt. Mischt ein Tag Messgrößen, zählt der höchste Schweregrad.
Map<DateTime, MixedDayMeasure> dailySeverityMixed(
  List<SymptomObservation> observations,
  SymptomMeasure current,
) {
  final result = <DateTime, MixedDayMeasure>{
    for (final e in dailySeverity(observations, current).entries)
      e.key: (measure: current, day: e.value),
  };
  final earlier = {
    for (final o in observations)
      if (observationMeasure(o) case final m? when m != current) m,
  };
  for (final m in earlier) {
    final own = observations.where((o) => observationMeasure(o) == m);
    for (final e in dailySeverity(own, m).entries) {
      final existing = result[e.key];
      if (existing == null || e.value.severity > existing.day.severity) {
        result[e.key] = (measure: m, day: e.value);
      }
    }
  }
  return result;
}

/// Raster des Kalenders: Spalten = Wochen, Zeilen = Wochentage.
class HeatmapGrid {
  HeatmapGrid._(this.start, this.weeks);

  /// Mindestens [minWeeks] Wochen bis einschließlich [today]; früher, wenn
  /// [earliest] weiter zurückliegt. Wochen beginnen an [firstWeekday]
  /// (DateTime.monday … DateTime.sunday).
  factory HeatmapGrid({
    required DateTime today,
    DateTime? earliest,
    int minWeeks = 17,
    int firstWeekday = DateTime.monday,
  }) {
    final end = localDay(today);
    var from = addDays(end, -(minWeeks - 1) * 7);
    if (earliest != null) {
      final first = localDay(earliest);
      if (first.isBefore(from)) from = first;
    }
    final offset = (from.weekday - firstWeekday) % 7;
    final start = addDays(from, -offset);
    final weeks = daysBetween(start, end) ~/ 7 + 1;
    return HeatmapGrid._(start, weeks);
  }

  final DateTime start;
  final int weeks;

  DateTime dayAt(int week, int row) => addDays(start, week * 7 + row);
}

/// Farbe je Stärke-Stufe: ein Farbton (Primärfarbe), hell → dunkel.
Color heatmapColor(IntensityBand band, ColorScheme scheme) {
  final t = switch (band) {
    IntensityBand.none => 0.14,
    IntensityBand.mild => 0.34,
    IntensityBand.moderate => 0.56,
    IntensityBand.severe => 0.8,
    IntensityBand.unbearable => 1.0,
  };
  final end = Color.lerp(scheme.primary, Colors.black, 0.3)!;
  return Color.lerp(scheme.surface, end, t)!;
}

/// Kalender-Heatmap eines Symptoms (GitHub-Stil): Wochen als Spalten, Tage
/// als Zellen, Farbe = höchste Stärke des Tages. Neueste Woche rechts, nach
/// links scrollbar. Tippen zeigt die Check-ins des Tages darunter.
class SymptomHeatmap extends StatefulWidget {
  const SymptomHeatmap({
    super.key,
    required this.observations,
    this.today,
    this.measure = SymptomMeasure.intensity,
  });

  final List<SymptomObservation> observations;

  /// v15: Messgröße; Farbe = Schweregrad (siehe [dailySeverity]).
  final SymptomMeasure measure;

  /// Für Tests; sonst heute.
  final DateTime? today;

  @override
  State<SymptomHeatmap> createState() => _SymptomHeatmapState();
}

class _SymptomHeatmapState extends State<SymptomHeatmap> {
  static const _cell = 16.0;
  static const _gap = 3.0;
  static const _labelHeight = 16.0;

  DateTime? _selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = context.l10n;
    final small = theme.textTheme.labelSmall!.copyWith(
      color: scheme.onSurfaceVariant,
    );
    final today = localDay(widget.today ?? DateTime.now());
    final measure = widget.measure;
    final intensity = measure == SymptomMeasure.intensity;
    // v16: Tage früherer Messgrößen nach deren eigenem Schweregrad.
    final mixed = dailySeverityMixed(widget.observations, measure);
    final byDay = {
      for (final e in mixed.entries)
        if (e.value.measure == measure) e.key: e.value.day,
    };
    final hasEarlier = mixed.values.any((d) => d.measure != measure);
    final maxByDay = {
      for (final e in mixed.entries) e.key: e.value.day.severity,
    };
    final earliest = widget.observations.isEmpty
        ? null
        : widget.observations
              .map((o) => o.recordedAt)
              .reduce((a, b) => a.isBefore(b) ? a : b);
    // MaterialLocalizations: 0 = Sonntag; DateTime: 7 = Sonntag.
    final firstIndex = MaterialLocalizations.of(context).firstDayOfWeekIndex;
    final grid = HeatmapGrid(
      today: today,
      earliest: earliest,
      firstWeekday: firstIndex == 0 ? DateTime.sunday : firstIndex,
    );
    final cellFormat = DateFormat(l10n.symptomHeatmapCellPattern);
    final monthFormat = DateFormat(l10n.symptomHeatmapMonthPattern);
    final weekdayFormat = DateFormat.E();

    Widget cell(DateTime day) {
      if (day.isAfter(today)) {
        return const SizedBox(width: _cell, height: _cell);
      }
      final value = maxByDay[day];
      final selected = day == _selected;
      final dayValue = mixed[day];
      final label = value == null
          ? l10n.symptomHeatmapCellEmpty(cellFormat.format(day))
          : intensity && dayValue!.measure == measure
          ? l10n.symptomHeatmapCell(
              cellFormat.format(day),
              value.round().toString(),
            )
          : l10n.heatmapCellMeasure(
              cellFormat.format(day),
              formatMeasureValue(
                dayValue!.measure,
                dayValue.day.value,
                value2: dayValue.day.value2,
                l10n: l10n,
              ),
            );
      return Semantics(
        label: label,
        button: true,
        selected: selected,
        excludeSemantics: true,
        child: GestureDetector(
          onTap: () => setState(() => _selected = selected ? null : day),
          child: Container(
            width: _cell,
            height: _cell,
            decoration: BoxDecoration(
              color: value == null
                  ? Colors.transparent
                  : heatmapColor(intensityBand(value), scheme),
              borderRadius: BorderRadius.circular(3),
              border: selected
                  ? Border.all(color: scheme.onSurface, width: 2)
                  : value == null
                  ? Border.all(color: scheme.outlineVariant)
                  : null,
            ),
          ),
        ),
      );
    }

    Widget week(int index) {
      final first = grid.dayAt(index, 0);
      // Monatsname über der Woche, in der der Monat beginnt (bzw. ganz links).
      final monthStart = [
        for (var row = 0; row < 7; row++) grid.dayAt(index, row),
      ].where((d) => d.day == 1 && !d.isAfter(today)).firstOrNull;
      final month = monthStart ?? (index == 0 ? first : null);
      return Padding(
        padding: const EdgeInsets.only(right: _gap),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: _cell,
              height: _labelHeight,
              child: month == null
                  ? null
                  : Text(
                      monthFormat.format(month),
                      style: small,
                      softWrap: false,
                      overflow: TextOverflow.visible,
                    ),
            ),
            for (var row = 0; row < 7; row++) ...[
              cell(grid.dayAt(index, row)),
              if (row < 6) const SizedBox(height: _gap),
            ],
          ],
        ),
      );
    }

    final selected = _selected;
    final selectedObservations = selected == null
        ? const <SymptomObservation>[]
        : (widget.observations
              .where((o) => localDay(o.recordedAt) == selected)
              .toList()
            ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          label: intensity
              ? l10n.symptomHeatmapSemantics(maxByDay.length)
              : l10n.heatmapSemanticsMeasure(
                  measureLabel(measure, l10n),
                  maxByDay.length,
                ),
          child: SizedBox(
            height: _labelHeight + 7 * _cell + 6 * _gap,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Wochentage (jede zweite Zeile, wie bei GitHub).
                Padding(
                  padding: const EdgeInsets.only(top: _labelHeight, right: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (var row = 0; row < 7; row++)
                        SizedBox(
                          height: _cell + (row < 6 ? _gap : 0),
                          child: row.isOdd
                              ? null
                              : ExcludeSemantics(
                                  child: Text(
                                    weekdayFormat.format(grid.dayAt(0, row)),
                                    style: small,
                                  ),
                                ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    itemCount: grid.weeks,
                    itemBuilder: (context, i) => week(grid.weeks - 1 - i),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 4,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _LegendItem(
              decoration: BoxDecoration(
                border: Border.all(color: scheme.outlineVariant),
                borderRadius: BorderRadius.circular(3),
              ),
              label: l10n.symptomHeatmapLegendEmpty,
              style: small,
            ),
            for (final (band, range) in const [
              (IntensityBand.none, '0'),
              (IntensityBand.mild, '1–3'),
              (IntensityBand.moderate, '4–6'),
              (IntensityBand.severe, '7–9'),
              (IntensityBand.unbearable, '10'),
            ])
              _LegendItem(
                decoration: BoxDecoration(
                  color: heatmapColor(band, scheme),
                  borderRadius: BorderRadius.circular(3),
                ),
                label: intensity
                    ? '$range ${intensityBandLabel(band, l10n)}'
                    : severityLabel(band, l10n),
                style: small,
              ),
          ],
        ),
        if (!intensity) ...[
          const SizedBox(height: 4),
          Text(heatmapMappingText(measure, byDay, l10n), style: small),
        ],
        if (hasEarlier) ...[
          const SizedBox(height: 4),
          Text(l10n.heatmapMixedNote, style: small),
        ],
        const SizedBox(height: 4),
        if (selected == null)
          Text(l10n.symptomHeatmapHint, style: small)
        else ...[
          const SizedBox(height: 4),
          Text(
            DateFormat(l10n.symptomHeatmapDayPattern).format(selected),
            style: theme.textTheme.titleSmall,
          ),
          if (selectedObservations.isEmpty)
            Text(l10n.symptomHeatmapNoDay, style: small)
          else
            for (final o in selectedObservations)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  '${DateFormat.Hm().format(o.recordedAt.toLocal())} · '
                  '${observationLabel(o)}',
                  style: theme.textTheme.bodySmall,
                ),
              ),
        ],
      ],
    );
  }
}

/// Legende für Messgrößen außer Stärke (Schweregrad statt 0–10).
String severityLabel(IntensityBand band, AppLocalizations l10n) =>
    switch (band) {
      IntensityBand.none => l10n.severityNone,
      IntensityBand.mild => l10n.severityMild,
      IntensityBand.moderate => l10n.severityModerate,
      IntensityBand.severe => l10n.severitySevere,
      IntensityBand.unbearable => l10n.severityMax,
    };

/// Erklärt, wie Werte der Messgröße auf Farben abgebildet werden.
String heatmapMappingText(
  SymptomMeasure measure,
  Map<DateTime, DayMeasure> byDay,
  AppLocalizations l10n,
) {
  String value(double v) => formatMeasureValue(measure, v, l10n: l10n);
  return switch (measure) {
    SymptomMeasure.temperature => l10n.heatmapMapTemperature(
      value(37.5),
      value(38),
      value(39),
      value(40),
    ),
    SymptomMeasure.count || SymptomMeasure.duration => l10n.heatmapMapRelative(
      value(byDay.values.fold<double>(0, (m, d) => d.value > m ? d.value : m)),
    ),
    SymptomMeasure.bloodPressure => l10n.heatmapMapBloodPressure,
    SymptomMeasure.spo2 => l10n.heatmapMapSpo2,
    SymptomMeasure.glucose => l10n.heatmapMapGlucose(
      formatNumber(
        AppUnits.current.glucoseToDisplay(70),
        digits: displayDigits(measure),
        locale: l10n.localeName,
      ),
      value(180),
    ),
    SymptomMeasure.pulse => l10n.heatmapMapPulse,
    SymptomMeasure.mood => l10n.heatmapMapMood,
    SymptomMeasure.weight => l10n.heatmapMapWeight,
    SymptomMeasure.intensity => '',
  };
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.decoration,
    required this.label,
    required this.style,
  });

  final BoxDecoration decoration;
  final String label;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: decoration),
        const SizedBox(width: 4),
        Text(label, style: style),
      ],
    );
  }
}
