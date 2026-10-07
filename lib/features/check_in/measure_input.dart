import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../data/measure_units.dart';
import '../../data/symptom_description.dart';
import '../../data/symptom_measure.dart';
import '../../l10n/l10n.dart';
import '../../theme/app_theme.dart';

/// v15: Eingabe eines Messwerts passend zur Messgröße — Schieberegler für
/// Stärke und Stimmung, Zahlenfeld mit −/+ für Temperatur, Puls, SpO₂,
/// Zucker und Gewicht, Zähler für Anzahl, Dauer mit Schnellwahl, zwei
/// Felder für den Blutdruck. [value]/[value2] in kanonischer Einheit.
class MeasureInput extends StatelessWidget {
  const MeasureInput({
    super.key,
    required this.measure,
    required this.value,
    required this.onChanged,
    this.value2,
  });

  final SymptomMeasure measure;
  final double value;
  final double? value2;
  final void Function(double value, double? value2) onChanged;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<UnitPreferences>(
      valueListenable: AppUnits.notifier,
      builder: (context, units, _) => switch (measure) {
        SymptomMeasure.intensity => _IntensitySlider(
          value: value,
          onChanged: (v) => onChanged(v, null),
        ),
        SymptomMeasure.mood => _MoodSlider(
          value: value,
          onChanged: (v) => onChanged(v, null),
        ),
        SymptomMeasure.count => _Counter(
          value: value,
          onChanged: (v) => onChanged(v, null),
        ),
        SymptomMeasure.duration => _DurationInput(
          value: value,
          onChanged: (v) => onChanged(v, null),
        ),
        SymptomMeasure.bloodPressure => _BloodPressureInput(
          systolic: value,
          diastolic: value2,
          onChanged: onChanged,
        ),
        _ => _NumberInput(
          key: ValueKey('${measure.code}-${units.hashCode}'),
          measure: measure,
          value: value,
          units: units,
          onChanged: (v) => onChanged(v, null),
        ),
      },
    );
  }
}

class _IntensitySlider extends StatelessWidget {
  const _IntensitySlider({required this.value, required this.onChanged});

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            SizedBox(
              width: 28,
              child: Text(
                '${value.round()}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: Slider(
                value: value.clamp(0, 10).toDouble(),
                min: 0,
                max: 10,
                divisions: 10,
                label: intensityText(value, l10n),
                semanticFormatterCallback: (v) => intensityText(v, l10n),
                onChanged: onChanged,
              ),
            ),
          ],
        ),
        Text(
          '${intensityText(value, l10n)} — ${intensityAnchor(value, l10n)}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

/// Stimmung −5 … +5 (bipolar, Mitte = ausgeglichen).
class _MoodSlider extends StatelessWidget {
  const _MoodSlider({required this.value, required this.onChanged});

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final small = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    String text(double v) => '${formatMood(v)} ${moodLabel(v, l10n)}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            SizedBox(
              width: 36,
              child: Text(
                formatMood(value),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: Slider(
                key: const ValueKey('mood-slider'),
                value: value.clamp(-5, 5).toDouble(),
                min: -5,
                max: 5,
                divisions: 10,
                label: text(value),
                semanticFormatterCallback: text,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.moodScaleLow, style: small),
            Text(l10n.moodScaleHigh, style: small),
          ],
        ),
        const SizedBox(height: 2),
        Text('${text(value)} — ${moodAnchor(value, l10n)}', style: small),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => IconButton.filledTonal(
    tooltip: tooltip,
    icon: Icon(icon),
    onPressed: onPressed,
  );
}

class _Counter extends StatelessWidget {
  const _Counter({required this.value, required this.onChanged});

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final n = value.round();
    return Row(
      children: [
        _StepButton(
          icon: Icons.remove,
          tooltip: l10n.measureDecrease,
          onPressed: n > 0 ? () => onChanged((n - 1).toDouble()) : null,
        ),
        SizedBox(
          width: 64,
          child: Text(
            '$n×',
            key: const ValueKey('count-value'),
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        _StepButton(
          icon: Icons.add,
          tooltip: l10n.measureIncrease,
          onPressed: () => onChanged((n + 1).toDouble()),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(l10n.measureCountHint, style: theme.textTheme.bodySmall),
        ),
      ],
    );
  }
}

class _DurationInput extends StatelessWidget {
  const _DurationInput({required this.value, required this.onChanged});

  final double value;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final minutes = value.round();
    final step = minutes >= 60 ? 15 : 5;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _StepButton(
              icon: Icons.remove,
              tooltip: l10n.measureDecrease,
              onPressed: minutes > 0
                  ? () => onChanged((minutes - step).clamp(0, 1440).toDouble())
                  : null,
            ),
            Expanded(
              child: Text(
                formatDuration(minutes),
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            _StepButton(
              icon: Icons.add,
              tooltip: l10n.measureIncrease,
              onPressed: () =>
                  onChanged((minutes + step).clamp(0, 1440).toDouble()),
            ),
          ],
        ),
        Text(l10n.measureDurationHint, style: theme.textTheme.bodySmall),
        const SizedBox(height: 4),
        Wrap(
          spacing: 6,
          children: [
            for (final m in const [5, 15, 30, 60, 120, 240])
              ChoiceChip(
                label: Text(formatDuration(m)),
                selected: minutes == m,
                onSelected: (_) => onChanged(m.toDouble()),
              ),
          ],
        ),
      ],
    );
  }
}

/// Zahl in Anzeigeeinheit (z. B. °F) mit −/+; Komma oder Punkt erlaubt.
class _NumberInput extends StatefulWidget {
  const _NumberInput({
    super.key,
    required this.measure,
    required this.value,
    required this.units,
    required this.onChanged,
  });

  final SymptomMeasure measure;
  final double value;
  final UnitPreferences units;
  final ValueChanged<double> onChanged;

  @override
  State<_NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends State<_NumberInput> {
  late final _controller = TextEditingController(text: _format(widget.value));

  int get _digits => displayDigits(widget.measure, widget.units);

  String _format(double canonical) => formatNumber(
    displayValue(widget.measure, canonical, widget.units),
    digits: _digits,
    grouping: false,
  );

  @override
  void didUpdateWidget(_NumberInput old) {
    super.didUpdateWidget(old);
    // Von außen geändert (−/+), nicht durch Tippen.
    final typed = _parse(_controller.text);
    if (typed == null ||
        (typed - widget.value).abs() > 0.0001 * (widget.value.abs() + 1)) {
      _controller.text = _format(widget.value);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double? _parse(String text) {
    final display = double.tryParse(text.trim().replaceAll(',', '.'));
    if (display == null) return null;
    return canonicalValue(widget.measure, display, widget.units);
  }

  void _step(int direction) {
    final step = displayStep(widget.measure, widget.units);
    final display = displayValue(widget.measure, widget.value, widget.units);
    // Auf das Raster der Anzeige runden, dann einen Schritt.
    final next = ((display / step).round() + direction) * step;
    final canonical = canonicalValue(widget.measure, next, widget.units);
    final (lo, hi) = widget.measure.range;
    final clamped = canonical.clamp(lo, hi).toDouble();
    _controller.text = _format(clamped);
    widget.onChanged(clamped);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final band = measureBandLabel(widget.measure, widget.value, l10n);
    final severity = measureSeverity(widget.measure, widget.value);
    final spo2 = widget.measure == SymptomMeasure.spo2
        ? spo2Band(widget.value)
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _StepButton(
              icon: Icons.remove,
              tooltip: l10n.measureDecrease,
              onPressed: () => _step(-1),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                key: ValueKey('measure-field-${widget.measure.code}'),
                controller: _controller,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                ],
                decoration: InputDecoration(
                  labelText: measureLabel(widget.measure, l10n),
                  suffixText: displayUnit(widget.measure, l10n, widget.units),
                  isDense: true,
                ),
                onChanged: (text) {
                  final v = _parse(text);
                  final (lo, hi) = widget.measure.range;
                  if (v != null && v >= lo && v <= hi) widget.onChanged(v);
                },
              ),
            ),
            const SizedBox(width: 8),
            _StepButton(
              icon: Icons.add,
              tooltip: l10n.measureIncrease,
              onPressed: () => _step(1),
            ),
          ],
        ),
        if (band != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              band,
              style: theme.textTheme.bodySmall?.copyWith(
                color: severity >= 5 ? AppColors.danger : AppColors.muted,
                fontWeight: severity >= 5 ? FontWeight.w600 : null,
              ),
            ),
          ),
        if (spo2 == Spo2Band.check || spo2 == Spo2Band.urgent)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              spo2 == Spo2Band.urgent
                  ? l10n.measureSpo2HintUrgent
                  : l10n.measureSpo2HintCheck,
              style: theme.textTheme.bodySmall,
            ),
          ),
      ],
    );
  }
}

class _BloodPressureInput extends StatefulWidget {
  const _BloodPressureInput({
    required this.systolic,
    required this.diastolic,
    required this.onChanged,
  });

  final double systolic;
  final double? diastolic;
  final void Function(double systolic, double? diastolic) onChanged;

  @override
  State<_BloodPressureInput> createState() => _BloodPressureInputState();
}

class _BloodPressureInputState extends State<_BloodPressureInput> {
  late final _sys = TextEditingController(
    text: widget.systolic.round().toString(),
  );
  late final _dia = TextEditingController(
    text: widget.diastolic?.round().toString() ?? '',
  );

  @override
  void dispose() {
    _sys.dispose();
    _dia.dispose();
    super.dispose();
  }

  void _changed() {
    final s = double.tryParse(_sys.text.trim());
    final d = double.tryParse(_dia.text.trim());
    if (s == null || s < 50 || s > 260) return;
    widget.onChanged(s, d != null && d >= 30 && d <= 160 ? d : null);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final band = measureBandLabel(
      SymptomMeasure.bloodPressure,
      widget.systolic,
      l10n,
      value2: widget.diastolic,
    );
    final severity = measureSeverity(
      SymptomMeasure.bloodPressure,
      widget.systolic,
      value2: widget.diastolic,
    );
    InputDecoration decoration(String label) =>
        InputDecoration(labelText: label, suffixText: 'mmHg', isDense: true);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                key: const ValueKey('bp-systolic'),
                controller: _sys,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: decoration(l10n.measureBpSystolic),
                onChanged: (_) => _changed(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text('/'),
            ),
            Expanded(
              child: TextField(
                key: const ValueKey('bp-diastolic'),
                controller: _dia,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: decoration(l10n.measureBpDiastolic),
                onChanged: (_) => _changed(),
              ),
            ),
          ],
        ),
        if (band != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              band,
              style: theme.textTheme.bodySmall?.copyWith(
                color: severity >= 5 ? AppColors.danger : AppColors.muted,
              ),
            ),
          ),
      ],
    );
  }
}

/// Optionale Extras zur Stimmung: Energie 0–10, Schlaf (Stunden),
/// Angst/Anspannung 0–10 — leer, bis man sie anfasst.
class MoodExtrasInput extends StatelessWidget {
  const MoodExtrasInput({
    super.key,
    required this.energy,
    required this.sleepHours,
    required this.anxiety,
    required this.onChanged,
  });

  final int? energy;
  final double? sleepHours;
  final int? anxiety;
  final void Function(int? energy, double? sleepHours, int? anxiety) onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    Widget slider(String label, int? value, ValueChanged<int> changed) => Row(
      children: [
        SizedBox(
          width: 120,
          child: Text(
            '$label ${value ?? '–'}',
            style: theme.textTheme.bodyMedium,
          ),
        ),
        Expanded(
          child: Slider(
            value: (value ?? 5).toDouble(),
            min: 0,
            max: 10,
            divisions: 10,
            onChanged: (v) => changed(v.round()),
          ),
        ),
      ],
    );
    final sleep = sleepHours;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        slider(
          l10n.moodEnergy,
          energy,
          (v) => onChanged(v, sleepHours, anxiety),
        ),
        Row(
          children: [
            SizedBox(
              width: 120,
              child: Text(l10n.moodSleep, style: theme.textTheme.bodyMedium),
            ),
            IconButton(
              tooltip: l10n.measureDecrease,
              icon: const Icon(Icons.remove),
              onPressed: () => onChanged(
                energy,
                ((sleep ?? 7) - 0.5).clamp(0, 24).toDouble(),
                anxiety,
              ),
            ),
            Text(
              sleep == null
                  ? '–'
                  : '${formatNumber(sleep, digits: sleep == sleep.roundToDouble() ? 0 : 1)} h',
              style: theme.textTheme.titleMedium,
            ),
            IconButton(
              tooltip: l10n.measureIncrease,
              icon: const Icon(Icons.add),
              onPressed: () => onChanged(
                energy,
                ((sleep ?? 7) + 0.5).clamp(0, 24).toDouble(),
                anxiety,
              ),
            ),
          ],
        ),
        slider(
          l10n.moodAnxiety,
          anxiety,
          (v) => onChanged(energy, sleepHours, v),
        ),
      ],
    );
  }
}
