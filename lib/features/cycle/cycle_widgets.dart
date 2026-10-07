import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../data/symptom_description.dart';
import '../../l10n/l10n.dart';
import '../../services/cycle/cycle_analytics.dart';
import '../../services/cycle/cycle_text.dart';
import '../../theme/app_theme.dart';
import '../../widgets/cycle_charts.dart' show flowColor;

/// Blutungsstärke als Auswahl-Chips (erneut tippen hebt die Auswahl auf).
class FlowSelector extends StatelessWidget {
  const FlowSelector({super.key, required this.value, required this.onChanged});

  final CycleFlow? value;
  final ValueChanged<CycleFlow?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (final flow in CycleFlow.values)
          ChoiceChip(
            key: ValueKey('flow-${flow.name}'),
            avatar: flow == CycleFlow.none
                ? null
                : Icon(
                    Icons.water_drop,
                    size: 16,
                    color: Color.lerp(
                      flowColor(flow, scheme),
                      AppColors.danger,
                      0.3,
                    ),
                  ),
            label: Text(flowLabel(flow, l10n)),
            selected: value == flow,
            onSelected: (selected) => onChanged(selected ? flow : null),
          ),
      ],
    );
  }
}

/// Schmerz 0–10 mit denselben verbalen Ankern wie bei Symptomen.
class PainSlider extends StatelessWidget {
  const PainSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.onChangeEnd,
  });

  /// `null` = nicht erfasst.
  final int? value;
  final ValueChanged<int?> onChanged;
  final ValueChanged<int?>? onChangeEnd;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final v = value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                v == null
                    ? l10n.cyclePainNotLogged
                    : '${intensityText(v, l10n)} — ${intensityAnchor(v, l10n)}',
                style: theme.textTheme.bodyMedium,
              ),
            ),
            if (v != null)
              IconButton(
                tooltip: l10n.cyclePainClear,
                icon: const Icon(Icons.close),
                onPressed: () {
                  onChanged(null);
                  onChangeEnd?.call(null);
                },
              ),
          ],
        ),
        Slider(
          key: const ValueKey('cycle-pain'),
          value: (v ?? 0).toDouble(),
          max: 10,
          divisions: 10,
          label: v == null ? null : '$v',
          semanticFormatterCallback: (x) =>
              '${x.round()}/10, ${intensityAnchor(x, l10n)}',
          onChanged: (x) => onChanged(x.round()),
          onChangeEnd: (x) => onChangeEnd?.call(x.round()),
        ),
      ],
    );
  }
}

/// Neutrale Hinweise „lohnt sich zu besprechen“ (dringliche hervorgehoben).
class CycleHintsCard extends StatelessWidget {
  const CycleHintsCard({super.key, required this.hints});

  final List<CycleHint> hints;

  @override
  Widget build(BuildContext context) {
    if (hints.isEmpty) return const SizedBox.shrink();
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final urgent = hints.any((h) => h.urgent);
    return Card(
      color: urgent
          ? AppColors.danger.withValues(alpha: 0.08)
          : theme.colorScheme.secondaryContainer.withValues(alpha: 0.5),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  urgent ? Icons.info : Icons.chat_bubble_outline,
                  color: urgent ? AppColors.danger : theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    urgent ? l10n.cycleHintsUrgentTitle : l10n.cycleHintsTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (final h in hints)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('•  '),
                    Expanded(child: Text(hintText(h, l10n))),
                  ],
                ),
              ),
            Text(l10n.cycleHintsFooter, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

/// Zähler mit −/+ (z. B. PBAC, Hitzewallungen).
class CountStepper extends StatelessWidget {
  const CountStepper({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.subtitle,
  });

  final String label;
  final String? subtitle;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label),
              if (subtitle != null)
                Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
        IconButton(
          tooltip: l10n.cycleLess,
          onPressed: value > 0 ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.remove_circle_outline),
        ),
        Semantics(
          label: '$label: $value',
          excludeSemantics: true,
          child: SizedBox(
            width: 28,
            child: Text('$value', textAlign: TextAlign.center),
          ),
        ),
        IconButton(
          tooltip: l10n.cycleMore,
          onPressed: () => onChanged(value + 1),
          icon: const Icon(Icons.add_circle_outline),
        ),
      ],
    );
  }
}

/// Hinweis zum Datenschutz (besonders sensible Daten).
class CyclePrivacyNote extends StatelessWidget {
  const CyclePrivacyNote({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.lock_outline, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            context.l10n.cyclePrivacyNote,
            style: theme.textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
