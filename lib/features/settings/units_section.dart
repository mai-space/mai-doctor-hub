import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/measure_units.dart';
import '../../data/repositories/settings_repository.dart';
import '../../l10n/l10n.dart';

/// v15: Einstellungen → Einheiten (Temperatur, Blutzucker, Gewicht).
/// Leere Einstellung = Standard nach Region des Geräts.
class UnitsSection extends StatelessWidget {
  const UnitsSection({super.key, required this.settings});

  final AppSetting settings;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final repo = SettingsRepository(DatabaseScope.of(context));
    final units = UnitPreferences.fromSettings(settings);

    Widget row<T extends Enum>(
      String label,
      List<(T, String)> options,
      T selected,
      UnitPreferences Function(T) apply,
    ) => Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          Expanded(child: Text(label, style: theme.textTheme.bodyLarge)),
          SegmentedButton<T>(
            showSelectedIcon: false,
            segments: [
              for (final (value, text) in options)
                ButtonSegment(
                  value: value,
                  label: Text(text, key: ValueKey('unit-${value.name}')),
                ),
            ],
            selected: {selected},
            onSelectionChanged: (v) => repo.setUnits(apply(v.first)),
          ),
        ],
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.unitsTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(l10n.unitsIntro, style: theme.textTheme.bodySmall),
        row(
          l10n.unitsTemperature,
          [for (final u in TemperatureUnit.values) (u, u.symbol)],
          units.temperature,
          (v) => units.copyWith(temperature: v),
        ),
        row(
          l10n.unitsGlucose,
          [for (final u in GlucoseUnit.values) (u, u.symbol)],
          units.glucose,
          (v) => units.copyWith(glucose: v),
        ),
        row(
          l10n.unitsWeight,
          [for (final u in WeightUnit.values) (u, u.symbol)],
          units.weight,
          (v) => units.copyWith(weight: v),
        ),
      ],
    );
  }
}
