import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../data/app_database.dart';

/// Punkt im Verlauf (Skalenwert 1–10).
class ChartPoint {
  const ChartPoint(this.at, this.value);

  final DateTime at;
  final double value;
}

/// Skalenwerte eines Symptoms, älteste zuerst.
List<ChartPoint> scalePoints(List<SymptomObservation> observations) => [
  for (final o in observations)
    if (o.kind == ObservationKind.scale_1_10 && o.valueNumber != null)
      ChartPoint(o.recordedAt, o.valueNumber!.clamp(0, 10).toDouble()),
]..sort((a, b) => a.at.compareTo(b.at));

/// Liniendiagramm 0–10 über die Zeit, ohne externe Abhängigkeit.
class ObservationChart extends StatelessWidget {
  const ObservationChart({super.key, required this.points, this.height = 180});

  final List<ChartPoint> points;
  final double height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme.labelSmall!;
    if (points.isEmpty) {
      return SizedBox(
        height: height / 2,
        child: Center(
          child: Text(
            'Noch keine Skalenwerte — per Check-in erfassen.',
            style: TextStyle(color: scheme.onSurfaceVariant),
          ),
        ),
      );
    }
    final first = points.first.at;
    final last = points.last.at;
    final format = DateFormat('d.M.', 'de');
    return Semantics(
      label:
          'Verlauf von ${format.format(first)} bis ${format.format(last)}, '
          'zuletzt ${points.last.value.toStringAsFixed(0)} von 10',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: height,
            child: CustomPaint(
              painter: _ChartPainter(
                points: points,
                line: scheme.primary,
                grid: scheme.outlineVariant,
                label: text.copyWith(color: scheme.onSurfaceVariant),
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
        ],
      ),
    );
  }
}

class _ChartPainter extends CustomPainter {
  _ChartPainter({
    required this.points,
    required this.line,
    required this.grid,
    required this.label,
  });

  final List<ChartPoint> points;
  final Color line;
  final Color grid;
  final TextStyle label;

  static const _leftInset = 22.0;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTRB(_leftInset, 6, size.width - 6, size.height - 6);
    final gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    for (final v in [0, 5, 10]) {
      final y = chart.bottom - chart.height * v / 10;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
      final tp = TextPainter(
        text: TextSpan(text: '$v', style: label),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }

    final start = points.first.at.millisecondsSinceEpoch.toDouble();
    final span = (points.last.at.millisecondsSinceEpoch - start).toDouble();
    Offset toOffset(ChartPoint p) {
      final t = span == 0
          ? 0.5
          : (p.at.millisecondsSinceEpoch - start) / span;
      return Offset(
        chart.left + chart.width * t,
        chart.bottom - chart.height * p.value / 10,
      );
    }

    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final o = toOffset(points[i]);
      i == 0 ? path.moveTo(o.dx, o.dy) : path.lineTo(o.dx, o.dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = line
        ..strokeWidth = 2.5
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round,
    );
    final dot = Paint()..color = line;
    for (final p in points) {
      canvas.drawCircle(toOffset(p), 3.5, dot);
    }
  }

  @override
  bool shouldRepaint(_ChartPainter old) =>
      old.points != points || old.line != line || old.grid != grid;
}
