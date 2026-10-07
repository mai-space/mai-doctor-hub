import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../data/app_database.dart';
import '../data/cycle_catalog.dart';
import '../data/symptom_description.dart';
import '../l10n/l10n.dart';
import '../services/cycle/cycle_analytics.dart';
import '../services/cycle/cycle_dates.dart';
import '../services/cycle/cycle_text.dart';
import '../services/cycle/pbac.dart';
import '../theme/app_theme.dart';
import 'observation_chart.dart' show ChartPoint;
import 'symptom_heatmap.dart' show heatmapColor;

/// Farbe der Blutungsstärke: ein ruhiger Rotton (AppColors.danger), hell →
/// kräftig. Schmierblutung nur angedeutet.
Color flowColor(CycleFlow flow, ColorScheme scheme) {
  final t = switch (flow) {
    CycleFlow.none => 0.0,
    CycleFlow.spotting => 0.18,
    CycleFlow.light => 0.35,
    CycleFlow.medium => 0.55,
    CycleFlow.heavy => 0.75,
    CycleFlow.veryHeavy => 0.95,
  };
  return Color.lerp(scheme.surface, AppColors.danger, t)!;
}

/// Phasen-Farben (gleiche Reihenfolge in Legende und Balken).
Color phaseColor(CyclePhase phase, ColorScheme scheme) => switch (phase) {
  CyclePhase.menstruation => AppColors.danger,
  CyclePhase.follicular => scheme.primary,
  CyclePhase.ovulation => AppColors.accent,
  CyclePhase.luteal => scheme.tertiary,
};

// ---------------------------------------------------------------- Kalender

/// Monatskalender: Blutung farbig, erwartete Periode gestrichelt umrandet,
/// heute fett umrandet. Tippen öffnet den Tag.
class CycleMonthCalendar extends StatelessWidget {
  const CycleMonthCalendar({
    super.key,
    required this.month,
    required this.analysis,
    required this.today,
    required this.onDayTap,
    this.showFertileWindow = false,
  });

  /// Beliebiger Tag im Monat.
  final DateTime month;
  final CycleAnalysis analysis;
  final DateTime today;
  final ValueChanged<DateTime> onDayTap;
  final bool showFertileWindow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = context.l10n;
    final first = DateTime(month.year, month.month);
    final firstIndex = MaterialLocalizations.of(context).firstDayOfWeekIndex;
    final firstWeekday = firstIndex == 0 ? DateTime.sunday : firstIndex;
    final offset = (first.weekday - firstWeekday) % 7;
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final cells = ((offset + daysInMonth) / 7).ceil() * 7;
    final prediction = analysis.prediction;
    final periodLength = analysis.stats?.averagePeriodLength.round() ?? 5;
    final cellFormat = DateFormat(l10n.cycleDayPattern);
    final weekdayFormat = DateFormat.E();

    Widget cell(int index) {
      final dayNumber = index - offset + 1;
      if (dayNumber < 1 || dayNumber > daysInMonth) return const SizedBox();
      final day = DateTime(month.year, month.month, dayNumber);
      final log = analysis.byDay[day];
      final flow = log?.flow;
      final predicted =
          prediction != null &&
          day.isAfter(today) &&
          prediction.isExpected(day, periodLength: periodLength);
      final fertile =
          showFertileWindow &&
          prediction != null &&
          !day.isBefore(today) &&
          prediction.isFertile(day);
      final isToday = day == today;
      final hasData = log != null;
      final parts = <String>[
        cellFormat.format(day),
        if (isToday) l10n.cycleToday,
        if (flow != null && flow != CycleFlow.none) flowLabel(flow, l10n),
        if (log?.pain != null) l10n.cyclePainValue(log!.pain!),
        if (predicted) l10n.cycleLegendPredicted,
        if (fertile) l10n.cycleLegendFertile,
      ];
      final filled = flow != null && flow != CycleFlow.none;
      final fill = filled
          ? flowColor(flow, scheme)
          : fertile
          ? AppColors.accent.withValues(alpha: 0.14)
          : Colors.transparent;
      final onFill = filled && flow.index >= CycleFlow.medium.index
          ? Colors.white
          : scheme.onSurface;
      return Semantics(
        label: parts.join(', '),
        button: true,
        excludeSemantics: true,
        child: InkWell(
          key: ValueKey('cycle-cal-${dayKey(day)}'),
          borderRadius: BorderRadius.circular(10),
          onTap: day.isAfter(today) ? null : () => onDayTap(day),
          child: CustomPaint(
            painter: predicted
                ? _DashedBorderPainter(color: AppColors.danger)
                : null,
            child: Container(
              margin: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: fill,
                borderRadius: BorderRadius.circular(8),
                border: isToday
                    ? Border.all(color: scheme.primary, width: 2)
                    : null,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    '$dayNumber',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: day.isAfter(today) && !filled
                          ? scheme.onSurfaceVariant
                          : onFill,
                      fontWeight: isToday ? FontWeight.w700 : null,
                    ),
                  ),
                  if (hasData && !filled)
                    Positioned(
                      bottom: 4,
                      child: Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: scheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  if (log?.flow == CycleFlow.spotting)
                    Positioned(
                      bottom: 4,
                      child: Icon(
                        Icons.water_drop,
                        size: 8,
                        color: AppColors.danger,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final small = theme.textTheme.labelSmall!.copyWith(
      color: scheme.onSurfaceVariant,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            for (var i = 0; i < 7; i++)
              Expanded(
                child: ExcludeSemantics(
                  child: Text(
                    weekdayFormat.format(plusDays(first, i - offset)),
                    textAlign: TextAlign.center,
                    style: small,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        for (var row = 0; row < cells ~/ 7; row++)
          SizedBox(
            height: 44,
            child: Row(
              children: [
                for (var col = 0; col < 7; col++)
                  Expanded(child: cell(row * 7 + col)),
              ],
            ),
          ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: [
            _Legend(
              color: flowColor(CycleFlow.medium, scheme),
              label: l10n.cycleLegendPeriod,
            ),
            _Legend(
              border: true,
              color: AppColors.danger,
              label: l10n.cycleLegendPredicted,
            ),
            if (showFertileWindow)
              _Legend(
                color: AppColors.accent.withValues(alpha: 0.3),
                label: l10n.cycleLegendFertile,
              ),
            _Legend(
              dot: true,
              color: scheme.primary,
              label: l10n.cycleLegendLogged,
            ),
          ],
        ),
      ],
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({
    required this.color,
    required this.label,
    this.border = false,
    this.dot = false,
  });

  final Color color;
  final String label;
  final bool border;
  final bool dot;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (dot)
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          )
        else if (border)
          CustomPaint(
            painter: _DashedBorderPainter(color: color),
            child: const SizedBox(width: 12, height: 12),
          )
        else
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(8),
    ).deflate(1.5);
    final path = Path()..addRRect(rect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        canvas.drawPath(metric.extractPath(distance, distance + 4), paint);
        distance += 7;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter old) => old.color != color;
}

// ------------------------------------------------------------ Balken

/// Ein Balken: [value] als Gesamthöhe, optional [inner] als dunklerer Anteil.
class BarDatum {
  const BarDatum({required this.label, required this.value, this.inner});

  final String label;
  final double value;
  final double? inner;
}

/// Balkendiagramm im Stil von [ObservationChart] (ohne Abhängigkeiten):
/// optionales Normband, Referenzlinie (gestrichelt) und Mittelwertlinie.
class CycleBarChart extends StatelessWidget {
  const CycleBarChart({
    super.key,
    required this.bars,
    required this.semanticsLabel,
    this.band,
    this.referenceLine,
    this.averageLine,
    this.color,
    this.innerColor,
    this.height = 170,
    this.minMax = 10,
  });

  final List<BarDatum> bars;
  final String semanticsLabel;

  /// Normbereich (z. B. 21–35 Tage), dezent hinterlegt.
  final (double, double)? band;
  final double? referenceLine;
  final double? averageLine;
  final Color? color;
  final Color? innerColor;
  final double height;

  /// Mindest-Skalenende.
  final double minMax;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = theme.textTheme.labelSmall!.copyWith(
      color: scheme.onSurfaceVariant,
    );
    return Semantics(
      label: semanticsLabel,
      child: ExcludeSemantics(
        child: SizedBox(
          height: height,
          child: CustomPaint(
            size: Size.infinite,
            painter: _BarPainter(
              bars: bars,
              band: band,
              referenceLine: referenceLine,
              averageLine: averageLine,
              color: color ?? scheme.primary,
              innerColor:
                  innerColor ??
                  Color.lerp(color ?? scheme.primary, Colors.black, 0.35)!,
              grid: scheme.outlineVariant,
              bandColor: scheme.primaryContainer.withValues(alpha: 0.45),
              refColor: AppColors.danger,
              label: text,
              minMax: minMax,
            ),
          ),
        ),
      ),
    );
  }
}

class _BarPainter extends CustomPainter {
  _BarPainter({
    required this.bars,
    required this.band,
    required this.referenceLine,
    required this.averageLine,
    required this.color,
    required this.innerColor,
    required this.grid,
    required this.bandColor,
    required this.refColor,
    required this.label,
    required this.minMax,
  });

  final List<BarDatum> bars;
  final (double, double)? band;
  final double? referenceLine;
  final double? averageLine;
  final Color color;
  final Color innerColor;
  final Color grid;
  final Color bandColor;
  final Color refColor;
  final TextStyle label;
  final double minMax;

  static const _left = 26.0;
  static const _bottom = 18.0;

  TextPainter _text(String s, [TextStyle? style]) => TextPainter(
    text: TextSpan(text: s, style: style ?? label),
    textDirection: TextDirection.ltr,
  )..layout();

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTRB(
      _left,
      12,
      size.width - 4,
      size.height - _bottom,
    );
    var top = [
      minMax,
      for (final b in bars) b.value,
      ?referenceLine,
      ?band?.$2,
    ].reduce(math.max);
    top = (top * 1.12).ceilToDouble();
    double y(double v) => chart.bottom - chart.height * (v / top);

    if (band case (final lo, final hi)?) {
      canvas.drawRect(
        Rect.fromLTRB(chart.left, y(hi), chart.right, y(lo)),
        Paint()..color = bandColor,
      );
    }
    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (final v in [0.0, (top / 2).roundToDouble(), top]) {
      final yy = y(v);
      canvas.drawLine(
        Offset(chart.left, yy),
        Offset(chart.right, yy),
        gridPaint,
      );
      final tp = _text(v.toStringAsFixed(0));
      tp.paint(canvas, Offset(0, yy - tp.height / 2));
    }

    if (bars.isNotEmpty) {
      final slot = chart.width / bars.length;
      final width = math.min(28.0, slot * 0.62);
      final labelEvery = math.max(1, (bars.length / 8).ceil());
      for (var i = 0; i < bars.length; i++) {
        final b = bars[i];
        final cx = chart.left + slot * (i + 0.5);
        final rect = RRect.fromRectAndCorners(
          Rect.fromLTRB(
            cx - width / 2,
            y(b.value),
            cx + width / 2,
            chart.bottom,
          ),
          topLeft: const Radius.circular(4),
          topRight: const Radius.circular(4),
        );
        canvas.drawRRect(rect, Paint()..color = color.withValues(alpha: 0.75));
        if (b.inner != null && b.inner! > 0) {
          canvas.drawRect(
            Rect.fromLTRB(
              cx - width / 2,
              y(math.min(b.inner!, b.value)),
              cx + width / 2,
              chart.bottom,
            ),
            Paint()..color = innerColor,
          );
        }
        final value = _text(b.value.toStringAsFixed(0));
        if (slot >= value.width + 2) {
          value.paint(
            canvas,
            Offset(cx - value.width / 2, y(b.value) - value.height - 1),
          );
        }
        if (i % labelEvery == 0) {
          final tp = _text(b.label);
          tp.paint(canvas, Offset(cx - tp.width / 2, chart.bottom + 3));
        }
      }
    }

    void dashed(double v, Color c) {
      final yy = y(v);
      final paint = Paint()
        ..color = c
        ..strokeWidth = 1.5;
      for (var x = chart.left; x < chart.right; x += 8) {
        canvas.drawLine(
          Offset(x, yy),
          Offset(math.min(x + 4, chart.right), yy),
          paint,
        );
      }
    }

    if (referenceLine != null) dashed(referenceLine!, refColor);
    if (averageLine != null) dashed(averageLine!, innerColor);
  }

  @override
  bool shouldRepaint(_BarPainter old) =>
      old.bars != bars ||
      old.band != band ||
      old.referenceLine != referenceLine ||
      old.averageLine != averageLine ||
      old.color != color;
}

/// Zykluslängen (letzte 12) mit Ø-Linie und Normband 21–35; der dunkle
/// Anteil ist die Periodenlänge.
class CycleLengthChart extends StatelessWidget {
  const CycleLengthChart({super.key, required this.cycles, this.average});

  final List<Cycle> cycles;
  final double? average;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final format = DateFormat(l10n.cycleShortDatePattern);
    final recent = cycles.reversed.take(12).toList().reversed.toList();
    return CycleBarChart(
      semanticsLabel: l10n.cycleChartLengthSemantics(
        recent.length,
        recent.map((c) => '${c.length}').join(', '),
      ),
      band: (
        CycleThresholds.shortCycle.toDouble(),
        CycleThresholds.longCycle.toDouble(),
      ),
      averageLine: average,
      minMax: 40,
      color: Theme.of(context).colorScheme.primary,
      innerColor: AppColors.danger,
      bars: [
        for (final c in recent)
          BarDatum(
            label: format.format(c.start),
            value: c.length!.toDouble(),
            inner: c.period.length.toDouble(),
          ),
      ],
    );
  }
}

/// PBAC je Zyklus mit 100-Punkte-Linie.
class PbacChart extends StatelessWidget {
  const PbacChart({super.key, required this.cycles});

  final List<Cycle> cycles;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final format = DateFormat(l10n.cycleShortDatePattern);
    final withPbac = [
      for (final c in cycles)
        if (c.pbac > 0) c,
    ].reversed.take(12).toList().reversed.toList();
    return CycleBarChart(
      semanticsLabel: l10n.cycleChartPbacSemantics(
        withPbac.map((c) => '${c.pbac}').join(', '),
      ),
      referenceLine: pbacHeavyThreshold.toDouble(),
      minMax: 120,
      color: AppColors.danger,
      bars: [
        for (final c in withPbac)
          BarDatum(label: format.format(c.start), value: c.pbac.toDouble()),
      ],
    );
  }
}

// --------------------------------------------------------- Schmerz-Raster

/// Zeilen = Zyklen (neuester unten), Spalten = Zyklustag 1…N, Farbe =
/// Schmerz 0–10 (gleiche Stufen wie die Symptom-Heatmap). Zeigt Muster wie
/// „Schmerz vor/zu Beginn der Periode“.
class PainHeatStrip extends StatelessWidget {
  const PainHeatStrip({super.key, required this.cycles, this.maxDays = 35});

  final List<Cycle> cycles;
  final int maxDays;

  static const _cell = 9.0;
  static const _gap = 2.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = context.l10n;
    final small = theme.textTheme.labelSmall!.copyWith(
      color: scheme.onSurfaceVariant,
    );
    final rows = cycles.reversed.take(6).toList().reversed.toList();
    final format = DateFormat(l10n.cycleShortDatePattern);
    final days = math.min(
      maxDays,
      rows.fold<int>(
        1,
        (m, c) => math.max(m, c.length ?? (c.pain.keys.fold(1, math.max))),
      ),
    );
    final painfulDays = <int>{
      for (final c in rows)
        for (final e in c.pain.entries)
          if (e.value >= CycleThresholds.strongPain) e.key,
    }.toList()..sort();
    return Semantics(
      label: l10n.cycleChartPainSemantics(
        rows.length,
        painfulDays.isEmpty ? '–' : painfulDays.join(', '),
      ),
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final c in rows)
                    Padding(
                      padding: const EdgeInsets.only(bottom: _gap),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 44,
                            child: Text(format.format(c.start), style: small),
                          ),
                          for (var d = 1; d <= days; d++)
                            Container(
                              width: _cell,
                              height: _cell + 3,
                              margin: const EdgeInsets.only(right: _gap),
                              decoration: BoxDecoration(
                                color: c.pain[d] == null
                                    ? (c.length != null && d > c.length!)
                                          ? Colors.transparent
                                          : scheme.surfaceContainerHighest
                                    : heatmapColor(
                                        intensityBand(c.pain[d]!),
                                        scheme,
                                      ),
                                borderRadius: BorderRadius.circular(2),
                                border: d <= c.period.length
                                    ? Border(
                                        bottom: BorderSide(
                                          color: AppColors.danger,
                                          width: 2,
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                        ],
                      ),
                    ),
                  Row(
                    children: [
                      const SizedBox(width: 44),
                      for (var d = 1; d <= days; d++)
                        SizedBox(
                          width: _cell + _gap,
                          child: d == 1 || d % 7 == 0
                              ? Text(
                                  '$d',
                                  style: small,
                                  softWrap: false,
                                  overflow: TextOverflow.visible,
                                )
                              : null,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(l10n.cyclePainStripLegend, style: small),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------------ Symptome nach Phase

/// Je Symptom vier Balken: Anteil der erfassten Tage je Zyklusphase.
class PhaseSymptomChart extends StatelessWidget {
  const PhaseSymptomChart({super.key, required this.data});

  final List<(String, Map<CyclePhase, double>)> data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = context.l10n;
    final small = theme.textTheme.labelSmall!.copyWith(
      color: scheme.onSurfaceVariant,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (symptom, byPhase) in data)
          Semantics(
            label: [
              CycleCatalog.symptomLabel(symptom),
              for (final p in CyclePhase.values)
                '${phaseLabel(p, l10n)} ${(byPhase[p]! * 100).round()} %',
            ].join(', '),
            excludeSemantics: true,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    CycleCatalog.symptomLabel(symptom),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  for (final p in CyclePhase.values)
                    Row(
                      children: [
                        SizedBox(
                          width: 92,
                          child: Text(phaseLabel(p, l10n), style: small),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: byPhase[p]!,
                              minHeight: 7,
                              color: phaseColor(p, scheme),
                              backgroundColor: scheme.surfaceContainerHighest,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          child: Text(
                            '${(byPhase[p]! * 100).round()} %',
                            textAlign: TextAlign.end,
                            style: small,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

// ------------------------------------------------------------ Linien

class LineSeries {
  const LineSeries(this.label, this.color, this.points);

  final String label;
  final Color color;
  final List<ChartPoint> points;
}

/// Mehrere Linien über die Zeit (Gewicht, Blutdruck, MRS-Verlauf).
class CycleLineChart extends StatelessWidget {
  const CycleLineChart({
    super.key,
    required this.series,
    required this.semanticsLabel,
    this.minY,
    this.maxY,
    this.height = 170,
  });

  final List<LineSeries> series;
  final String semanticsLabel;
  final double? minY;
  final double? maxY;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = context.l10n;
    final text = theme.textTheme.labelSmall!.copyWith(
      color: scheme.onSurfaceVariant,
    );
    final all = [for (final s in series) ...s.points];
    if (all.isEmpty) {
      return SizedBox(
        height: height / 2,
        child: Center(child: Text(l10n.settingsChartEmpty, style: text)),
      );
    }
    final format = DateFormat(l10n.cycleShortDatePattern);
    final first = all.map((p) => p.at).reduce((a, b) => a.isBefore(b) ? a : b);
    final last = all.map((p) => p.at).reduce((a, b) => a.isAfter(b) ? a : b);
    return Semantics(
      label: semanticsLabel,
      child: ExcludeSemantics(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: height,
              child: CustomPaint(
                painter: _LinePainter(
                  series: series,
                  minY: minY,
                  maxY: maxY,
                  grid: scheme.outlineVariant,
                  label: text,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(format.format(first), style: text),
                if (last != first) Text(format.format(last), style: text),
              ],
            ),
            if (series.length > 1)
              Wrap(
                spacing: 12,
                children: [
                  for (final s in series)
                    _Legend(color: s.color, label: s.label),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _LinePainter extends CustomPainter {
  _LinePainter({
    required this.series,
    required this.minY,
    required this.maxY,
    required this.grid,
    required this.label,
  });

  final List<LineSeries> series;
  final double? minY;
  final double? maxY;
  final Color grid;
  final TextStyle label;

  static const _left = 30.0;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTRB(_left, 6, size.width - 6, size.height - 6);
    final points = [for (final s in series) ...s.points];
    var lo = minY ?? points.map((p) => p.value).reduce(math.min);
    var hi = maxY ?? points.map((p) => p.value).reduce(math.max);
    if (minY == null || maxY == null) {
      final pad = math.max(1.0, (hi - lo) * 0.1);
      if (minY == null) lo = (lo - pad).floorToDouble();
      if (maxY == null) hi = (hi + pad).ceilToDouble();
    }
    if (hi <= lo) hi = lo + 1;
    double y(double v) => chart.bottom - chart.height * (v - lo) / (hi - lo);
    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (final v in [lo, (lo + hi) / 2, hi]) {
      final yy = y(v);
      canvas.drawLine(
        Offset(chart.left, yy),
        Offset(chart.right, yy),
        gridPaint,
      );
      final tp = TextPainter(
        text: TextSpan(text: v.toStringAsFixed(0), style: label),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, yy - tp.height / 2));
    }
    final start = points
        .map((p) => p.at.millisecondsSinceEpoch)
        .reduce(math.min)
        .toDouble();
    final end = points
        .map((p) => p.at.millisecondsSinceEpoch)
        .reduce(math.max)
        .toDouble();
    final span = end - start;
    Offset at(ChartPoint p) => Offset(
      chart.left +
          chart.width *
              (span == 0 ? 0.5 : (p.at.millisecondsSinceEpoch - start) / span),
      y(p.value),
    );
    for (final s in series) {
      final sorted = [...s.points]..sort((a, b) => a.at.compareTo(b.at));
      final path = Path();
      for (var i = 0; i < sorted.length; i++) {
        final o = at(sorted[i]);
        i == 0 ? path.moveTo(o.dx, o.dy) : path.lineTo(o.dx, o.dy);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = s.color
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke
          ..strokeJoin = StrokeJoin.round,
      );
      final dot = Paint()..color = s.color;
      for (final p in sorted) {
        canvas.drawCircle(at(p), 3, dot);
      }
    }
  }

  @override
  bool shouldRepaint(_LinePainter old) =>
      old.series != series || old.minY != minY || old.maxY != maxY;
}
