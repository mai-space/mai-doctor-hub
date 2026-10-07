import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../data/app_database.dart';
import '../data/measure_units.dart';
import '../data/symptom_measure.dart';
import '../l10n/l10n.dart';
import 'observation_chart.dart';
import 'symptom_heatmap.dart' show localDay;

/// v15: Darstellung je Messgröße.
enum MeasureChartStyle {
  /// Linie über die Zeit (Stärke, Temperatur, Puls, SpO₂, Zucker, Gewicht;
  /// Blutdruck als zwei Linien).
  line,

  /// Balken je Kalendertag, Summe (Anzahl, Dauer).
  dailyBars,

  /// Balken um die Nulllinie (Stimmung −5 … +5).
  diverging,
}

/// Referenzlinie (Anzeigeeinheit) mit Beschriftung.
typedef ReferenceLine = ({double value, String label});

/// Daten eines Verlaufsdiagramms — reine Daten, damit testbar.
class MeasureChartData {
  const MeasureChartData({
    required this.measure,
    required this.style,
    required this.series,
    required this.min,
    required this.max,
    this.references = const [],
    this.markers = const [],
  });

  /// Werte in Anzeigeeinheit, älteste zuerst. Blutdruck: [systolisch,
  /// diastolisch]; sonst genau eine Reihe.
  factory MeasureChartData.from(
    List<SymptomObservation> observations,
    SymptomMeasure measure, {
    UnitPreferences? units,
    AppLocalizations? l10n,
  }) {
    final u = units ?? AppUnits.current;
    final strings = l10n ?? AppLocale.strings;
    final sorted = [...observations]
      ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));

    // Haupt- und Zusatzwerte derselben Größe.
    final values = <(DateTime, double, double?)>[];
    for (final o in sorted) {
      if (observationMeasure(o) == measure && o.valueNumber != null) {
        values.add((o.recordedAt, o.valueNumber!, o.valueNumber2));
      } else if (SymptomMeasure.fromCode(o.measure2) == measure &&
          o.secondaryValue != null) {
        values.add((o.recordedAt, o.secondaryValue!, null));
      }
    }
    double show(double v) => displayValue(measure, v, u);
    String label(double canonical) =>
        formatMeasureValue(measure, canonical, l10n: strings, units: u);

    final markers = [
      for (final o in sorted)
        if (o.journal?.trim().isNotEmpty == true) o,
    ];

    switch (measure) {
      case SymptomMeasure.intensity:
        return MeasureChartData(
          measure: measure,
          style: MeasureChartStyle.line,
          series: [
            [for (final (at, v, _) in values) ChartPoint(at, v.clamp(0, 10))],
          ],
          min: 0,
          max: 10,
          markers: markers,
        );
      case SymptomMeasure.mood:
        return MeasureChartData(
          measure: measure,
          style: MeasureChartStyle.diverging,
          series: [
            [for (final (at, v, _) in values) ChartPoint(at, v.clamp(-5, 5))],
          ],
          min: -5,
          max: 5,
          markers: markers,
        );
      case SymptomMeasure.count || SymptomMeasure.duration:
        final byDay = <DateTime, double>{};
        for (final (at, v, _) in values) {
          final day = localDay(at);
          byDay[day] = (byDay[day] ?? 0) + v;
        }
        final points = [
          for (final e in byDay.entries) ChartPoint(e.key, e.value),
        ]..sort((a, b) => a.at.compareTo(b.at));
        final top = points.fold<double>(0, (m, p) => math.max(m, p.value));
        return MeasureChartData(
          measure: measure,
          style: MeasureChartStyle.dailyBars,
          series: [points],
          min: 0,
          max: _niceMax(top),
          markers: markers,
        );
      case SymptomMeasure.bloodPressure:
        final sys = [for (final (at, v, _) in values) ChartPoint(at, v)];
        final dia = [
          for (final (at, _, d) in values)
            if (d != null) ChartPoint(at, d),
        ];
        final all = [...sys, ...dia].map((p) => p.value);
        return MeasureChartData(
          measure: measure,
          style: MeasureChartStyle.line,
          series: [sys, dia],
          min: math.min(60, _floorTo(all.fold(200, math.min), 10)),
          max: math.max(160, _ceilTo(all.fold(0, math.max), 10)),
          // ESC/ESH 2018: Hypertonie ab 140/90.
          references: const [
            (value: 140, label: '140'),
            (value: 90, label: '90'),
          ],
          markers: markers,
        );
      case _:
        final points = [
          for (final (at, v, _) in values) ChartPoint(at, show(v)),
        ];
        final refs = <ReferenceLine>[
          if (measure == SymptomMeasure.temperature)
            (
              value: show(feverThresholdC),
              label: strings.measureFeverLine(label(feverThresholdC)),
            ),
          if (measure == SymptomMeasure.spo2) ...[
            (value: 92.0, label: '92 %'),
            (value: 90.0, label: '90 %'),
          ],
          if (measure == SymptomMeasure.glucose) ...[
            (value: show(70), label: label(70)),
            (value: show(180), label: label(180)),
          ],
          if (measure == SymptomMeasure.pulse) ...[
            (value: 60.0, label: '60'),
            (value: 100.0, label: '100'),
          ],
        ];
        final range = [
          ...points.map((p) => p.value),
          ...refs.map((r) => r.value),
        ];
        // Temperatur: mindestens 36–39,5 °C, damit Fieber einzuordnen ist.
        final (floor, ceil) = switch (measure) {
          SymptomMeasure.temperature => (show(36), show(39.5)),
          SymptomMeasure.spo2 => (88.0, 100.0),
          _ => (double.infinity, double.negativeInfinity),
        };
        var lo = range.isEmpty ? 0.0 : range.reduce(math.min);
        var hi = range.isEmpty ? 1.0 : range.reduce(math.max);
        lo = math.min(lo, floor);
        hi = math.max(hi, ceil);
        if (measure == SymptomMeasure.spo2) hi = 100;
        final pad = (hi - lo) * 0.08 + (hi == lo ? 1 : 0);
        return MeasureChartData(
          measure: measure,
          style: MeasureChartStyle.line,
          series: [points],
          min: measure == SymptomMeasure.spo2 ? lo : lo - pad,
          max: measure == SymptomMeasure.spo2 ? hi : hi + pad,
          references: refs,
          markers: markers,
        );
    }
  }

  final SymptomMeasure measure;
  final MeasureChartStyle style;
  final List<List<ChartPoint>> series;
  final double min;
  final double max;
  final List<ReferenceLine> references;

  /// Check-ins mit Tagebuch-Eintrag (Punkte über dem Diagramm).
  final List<SymptomObservation> markers;

  bool get isEmpty => series.every((s) => s.isEmpty);

  /// Gleiche Daten ohne Tagebuch-Marker (z. B. fürs zweite Diagramm).
  MeasureChartData withoutMarkers([bool apply = true]) => !apply
      ? this
      : MeasureChartData(
          measure: measure,
          style: style,
          series: series,
          min: min,
          max: max,
          references: references,
        );

  /// Zeitspanne über alle Reihen und Marker.
  (DateTime, DateTime)? get span {
    final times = [
      for (final s in series) ...s.map((p) => p.at),
      ...markers.map((m) => m.recordedAt),
    ];
    if (times.isEmpty) return null;
    times.sort();
    return (times.first, times.last);
  }

  static double _niceMax(double v) {
    if (v <= 5) return 5;
    if (v <= 10) return 10;
    final step = math.pow(10, (math.log(v) / math.ln10).floor()).toDouble();
    return (v / step).ceil() * step;
  }

  static double _floorTo(double v, double step) => (v / step).floor() * step;
  static double _ceilTo(double v, double step) => (v / step).ceil() * step;
}

/// Kennzahlen einer Messgröße (kanonische Einheit), z. B. für Karte und PDF.
class MeasureStats {
  const MeasureStats({
    required this.count,
    required this.average,
    required this.min,
    required this.max,
    required this.last,
    this.average2,
    this.last2,
  });

  final int count;
  final double average;
  final double min;
  final double max;
  final double last;

  /// Blutdruck: diastolisch.
  final double? average2;
  final double? last2;

  /// `null` ohne Werte. Blutdruck: min/max systolisch.
  static MeasureStats? of(
    List<SymptomObservation> observations,
    SymptomMeasure measure,
  ) {
    final sorted = [...observations]
      ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));
    final values = <(double, double?)>[];
    for (final o in sorted) {
      if (observationMeasure(o) == measure && o.valueNumber != null) {
        values.add((o.valueNumber!, o.valueNumber2));
      } else if (SymptomMeasure.fromCode(o.measure2) == measure &&
          o.secondaryValue != null) {
        values.add((o.secondaryValue!, null));
      }
    }
    if (values.isEmpty) return null;
    final main = [for (final (v, _) in values) v];
    final second = [for (final (_, d) in values) ?d];
    return MeasureStats(
      count: values.length,
      average: main.reduce((a, b) => a + b) / main.length,
      min: main.reduce(math.min),
      max: main.reduce(math.max),
      last: main.last,
      average2: second.isEmpty
          ? null
          : second.reduce((a, b) => a + b) / second.length,
      last2: values.last.$2,
    );
  }

  /// „Ø 38,2 °C · min 37,1 °C · max 39,0 °C · zuletzt 38,4 °C“.
  String describe(
    SymptomMeasure measure,
    AppLocalizations l10n, {
    UnitPreferences? units,
  }) {
    String f(double v, [double? v2]) {
      if (measure == SymptomMeasure.intensity) {
        return '${formatNumber(v, digits: v == v.roundToDouble() ? 0 : 1, locale: l10n.localeName)}/10';
      }
      if (measure == SymptomMeasure.mood) {
        return v == v.roundToDouble()
            ? formatMood(v)
            : '${v > 0
                      ? '+'
                      : v < 0
                      ? '−'
                      : ''}'
                  '${formatNumber(v.abs(), digits: 1, locale: l10n.localeName)}';
      }
      // Blutdruck min/max: nur systolisch.
      if (measure == SymptomMeasure.bloodPressure && v2 == null) {
        return '${v.round()} mmHg';
      }
      return formatMeasureValue(
        measure,
        v,
        value2: v2,
        l10n: l10n,
        units: units,
      );
    }

    final avgDigits = measure == SymptomMeasure.intensity ? 1 : null;
    final avg = avgDigits == null
        ? f(_round(measure, average), average2?.roundToDouble())
        : '${formatNumber(average, digits: 1, locale: l10n.localeName)}/10';
    return l10n.measureStats(avg, f(min), f(max), f(last, last2));
  }

  static double _round(SymptomMeasure m, double v) => switch (m) {
    SymptomMeasure.mood => (v * 10).round() / 10,
    SymptomMeasure.temperature ||
    SymptomMeasure.weight ||
    SymptomMeasure.glucose => v,
    _ => v.roundToDouble(),
  };
}

/// Verlauf einer Messgröße mit Einheit, Referenzlinien (z. B. Fieber ab
/// 38 °C) und Tagebuch-Markern. Tippen auf einen Marker → [onMarkerTap].
class MeasureChart extends StatelessWidget {
  const MeasureChart({
    super.key,
    required this.data,
    this.height = 180,
    this.onMarkerTap,
  });

  final MeasureChartData data;
  final double height;
  final ValueChanged<SymptomObservation>? onMarkerTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme.labelSmall!;
    final l10n = context.l10n;
    final span = data.span;
    if (data.isEmpty || span == null) {
      return SizedBox(
        height: height / 2,
        child: Center(
          child: Text(
            l10n.settingsChartEmpty,
            style: TextStyle(color: scheme.onSurfaceVariant),
          ),
        ),
      );
    }
    final (first, last) = span;
    final format = DateFormat(l10n.settingsChartDayPattern);
    final latest = data.series.first.isEmpty ? null : data.series.first.last;
    final latestText = latest == null
        ? '–'
        : data.measure == SymptomMeasure.mood
        ? formatMood(latest.value)
        : '${formatNumber(latest.value, digits: displayDigits(data.measure), locale: l10n.localeName)}'
                  ' ${displayUnit(data.measure, l10n)}'
              .trim();
    final colors = [
      scheme.primary,
      data.measure == SymptomMeasure.bloodPressure
          ? scheme.tertiary
          : scheme.secondary,
    ];
    final painter = _MeasurePainter(
      data: data,
      start: first,
      end: last,
      colors: colors,
      positive: scheme.tertiary,
      grid: scheme.outlineVariant,
      reference: scheme.error,
      marker: scheme.secondary,
      label: text.copyWith(color: scheme.onSurfaceVariant),
      digits: displayDigits(data.measure),
      localeName: l10n.localeName,
    );
    return Semantics(
      // Stärke wie bisher („Verlauf von … bis …, zuletzt 7 von 10“).
      label: data.measure == SymptomMeasure.intensity
          ? l10n.settingsChartSemantics(
              format.format(first),
              format.format(last),
              (latest?.value ?? 0).toStringAsFixed(0),
            )
          : l10n.measureChartSemantics(
              measureLabel(data.measure, l10n),
              data.series.first.length,
              latestText,
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: height,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapUp: onMarkerTap == null || data.markers.isEmpty
                  ? null
                  : (details) {
                      final box = context.findRenderObject() as RenderBox?;
                      final width = box?.size.width ?? 0;
                      final hit = painter.markerAt(
                        details.localPosition,
                        Size(width, height),
                      );
                      if (hit != null) onMarkerTap!(hit);
                    },
              child: CustomPaint(painter: painter, size: Size.infinite),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(format.format(first), style: text),
              // Einheit der Achse (Temperatur, Puls, SpO₂, Zucker, Gewicht).
              if (data.measure == SymptomMeasure.bloodPressure)
                Text(
                  '${l10n.measureBpSystolic} / ${l10n.measureBpDiastolic} '
                  '(mmHg)',
                  style: text,
                )
              else if (data.style == MeasureChartStyle.dailyBars)
                Text(
                  '${l10n.measureTotalPerDay} '
                  '(${displayUnit(data.measure, l10n)})',
                  style: text,
                )
              else if (data.measure != SymptomMeasure.intensity &&
                  data.measure != SymptomMeasure.mood)
                Text(
                  '${measureLabel(data.measure, l10n)} '
                  '(${displayUnit(data.measure, l10n)})',
                  style: text,
                ),
              if (last != first) Text(format.format(last), style: text),
            ],
          ),
        ],
      ),
    );
  }
}

class _MeasurePainter extends CustomPainter {
  _MeasurePainter({
    required this.data,
    required this.start,
    required this.end,
    required this.colors,
    required this.positive,
    required this.grid,
    required this.reference,
    required this.marker,
    required this.label,
    required this.digits,
    required this.localeName,
  });

  final MeasureChartData data;
  final DateTime start;
  final DateTime end;
  final List<Color> colors;
  final Color positive;
  final Color grid;
  final Color reference;
  final Color marker;
  final TextStyle label;
  final int digits;
  final String localeName;

  static const _leftInset = 34.0;
  static const _markerBand = 14.0;

  Rect _chart(Size size) => Rect.fromLTRB(
    _leftInset,
    6 + (data.markers.isEmpty ? 0 : _markerBand),
    size.width - 8,
    size.height - 6,
  );

  double _x(DateTime at, Rect chart) {
    final span = end.millisecondsSinceEpoch - start.millisecondsSinceEpoch;
    final t = span == 0
        ? 0.5
        : (at.millisecondsSinceEpoch - start.millisecondsSinceEpoch) / span;
    // Balken brauchen links/rechts etwas Luft.
    final inset = data.style == MeasureChartStyle.line ? 0.0 : 10.0;
    return chart.left + inset + (chart.width - 2 * inset) * t;
  }

  double _y(double v, Rect chart) {
    final range = data.max - data.min;
    final t = range == 0 ? 0.5 : (v - data.min) / range;
    return chart.bottom - chart.height * t.clamp(0, 1);
  }

  /// Marker unter [position] (± 16 px), sonst `null`.
  SymptomObservation? markerAt(Offset position, Size size) {
    final chart = _chart(size);
    SymptomObservation? best;
    var bestDistance = 16.0;
    for (final m in data.markers) {
      final d = (position.dx - _x(m.recordedAt, chart)).abs();
      if (d <= bestDistance) {
        best = m;
        bestDistance = d;
      }
    }
    return best;
  }

  void _text(Canvas canvas, String text, Offset at, {bool right = false}) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: label),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(
      canvas,
      Offset(right ? at.dx - tp.width : at.dx, at.dy - tp.height / 2),
    );
  }

  String _num(double v) => formatNumber(
    v,
    digits: data.max - data.min < 5 ? digits : 0,
    locale: localeName,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final chart = _chart(size);
    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;

    // Gitter: Unter-, Mittel- und Obergrenze (Stimmung: −5, 0, +5).
    final gridValues = data.style == MeasureChartStyle.diverging
        ? [-5.0, 0.0, 5.0]
        : [data.min, (data.min + data.max) / 2, data.max];
    for (final v in gridValues) {
      final y = _y(v, chart);
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
      _text(
        canvas,
        data.style == MeasureChartStyle.diverging ? formatMood(v) : _num(v),
        Offset(chart.left - 4, y),
        right: true,
      );
    }

    // Referenzlinien gestrichelt.
    final refPaint = Paint()
      ..color = reference.withValues(alpha: 0.7)
      ..strokeWidth = 1.2;
    for (final r in data.references) {
      if (r.value < data.min || r.value > data.max) continue;
      final y = _y(r.value, chart);
      for (var x = chart.left; x < chart.right; x += 8) {
        canvas.drawLine(
          Offset(x, y),
          Offset(math.min(x + 4, chart.right), y),
          refPaint,
        );
      }
      _text(canvas, r.label, Offset(chart.right, y - 7), right: true);
    }

    switch (data.style) {
      case MeasureChartStyle.line:
        for (final (i, points) in data.series.indexed) {
          if (points.isEmpty) continue;
          final color = colors[i % colors.length];
          final path = Path();
          for (final (j, p) in points.indexed) {
            final o = Offset(_x(p.at, chart), _y(p.value, chart));
            j == 0 ? path.moveTo(o.dx, o.dy) : path.lineTo(o.dx, o.dy);
          }
          canvas.drawPath(
            path,
            Paint()
              ..color = color
              ..strokeWidth = 2.5
              ..style = PaintingStyle.stroke
              ..strokeJoin = StrokeJoin.round,
          );
          final dot = Paint()..color = color;
          for (final p in points) {
            canvas.drawCircle(
              Offset(_x(p.at, chart), _y(p.value, chart)),
              3.5,
              dot,
            );
          }
        }
      case MeasureChartStyle.dailyBars:
        final points = data.series.first;
        final width = math.max(
          3.0,
          math.min(14.0, chart.width / (points.length + 1) * 0.6),
        );
        final bar = Paint()..color = colors.first;
        for (final p in points) {
          final x = _x(p.at, chart);
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTRB(
                x - width / 2,
                _y(p.value, chart),
                x + width / 2,
                _y(0, chart),
              ),
              const Radius.circular(2),
            ),
            bar,
          );
        }
      case MeasureChartStyle.diverging:
        final points = data.series.first;
        final width = math.max(
          3.0,
          math.min(12.0, chart.width / (points.length + 1) * 0.6),
        );
        final zero = _y(0, chart);
        for (final p in points) {
          final x = _x(p.at, chart);
          final y = _y(p.value, chart);
          final paint = Paint()..color = p.value >= 0 ? positive : colors.first;
          if (p.value == 0) {
            canvas.drawCircle(Offset(x, zero), 3, paint);
            continue;
          }
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTRB(
                x - width / 2,
                math.min(y, zero),
                x + width / 2,
                math.max(y, zero),
              ),
              const Radius.circular(2),
            ),
            paint,
          );
        }
    }

    // Tagebuch-Marker über dem Diagramm.
    final markerPaint = Paint()..color = marker;
    for (final m in data.markers) {
      canvas.drawCircle(
        Offset(_x(m.recordedAt, chart), chart.top - _markerBand / 2),
        4,
        markerPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_MeasurePainter old) =>
      old.data != data || old.colors != colors || old.grid != grid;
}
