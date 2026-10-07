import 'package:flutter/material.dart';

import '../../data/repositories/cycle_repository.dart';
import '../../l10n/l10n.dart';
import 'cycle_widgets.dart';

/// Onboarding-Schritt „Zyklus & Frauengesundheit“: Mehrfachauswahl, alles
/// optional. Die Gynäkologie wird standardmäßig mit angelegt, sobald etwas
/// gewählt ist (abwählbar).
class CycleOnboardingStep extends StatelessWidget {
  const CycleOnboardingStep({
    super.key,
    required this.setup,
    required this.onChanged,
  });

  final CycleSetup setup;
  final ValueChanged<CycleSetup> onChanged;

  CycleSetup _with({bool? cycle, bool? menopause, bool? pregnancy}) {
    final next = CycleSetup(
      cycle: cycle ?? setup.cycle,
      menopause: menopause ?? setup.menopause,
      pregnancy: pregnancy ?? setup.pregnancy,
      createGynecologist: setup.createGynecologist,
    );
    // Erste Auswahl: Gynäkologie vorschlagen.
    return CycleSetup(
      cycle: next.cycle,
      menopause: next.menopause,
      pregnancy: next.pregnancy,
      createGynecologist: setup.any ? setup.createGynecologist : next.any,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    Widget tile({
      required Key key,
      required IconData icon,
      required String title,
      required String subtitle,
      required bool selected,
      required VoidCallback onTap,
    }) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: selected
            ? theme.colorScheme.primaryContainer
            : theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.outlineVariant,
          ),
        ),
        child: InkWell(
          key: key,
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Semantics(
            selected: selected,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(icon, color: theme.colorScheme.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(subtitle, style: theme.textTheme.bodySmall),
                      ],
                    ),
                  ),
                  Icon(
                    selected ? Icons.check_circle : Icons.circle_outlined,
                    color: selected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Icon(
            Icons.water_drop_outlined,
            size: 64,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.cycleOnboardingTitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.cycleOnboardingText,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          tile(
            key: const ValueKey('onboarding-cycle'),
            icon: Icons.water_drop_outlined,
            title: l10n.cycleModeCycle,
            subtitle: l10n.cycleModeCycleSubtitle,
            selected: setup.cycle,
            onTap: () => onChanged(_with(cycle: !setup.cycle)),
          ),
          tile(
            key: const ValueKey('onboarding-menopause'),
            icon: Icons.spa_outlined,
            title: l10n.cycleModeMenopause,
            subtitle: l10n.cycleModeMenopauseSubtitle,
            selected: setup.menopause,
            onTap: () => onChanged(_with(menopause: !setup.menopause)),
          ),
          tile(
            key: const ValueKey('onboarding-pregnancy'),
            icon: Icons.pregnant_woman,
            title: l10n.cycleModePregnancy,
            subtitle: l10n.cycleModePregnancySubtitle,
            selected: setup.pregnancy,
            onTap: () => onChanged(_with(pregnancy: !setup.pregnancy)),
          ),
          tile(
            key: const ValueKey('onboarding-none'),
            icon: Icons.do_not_disturb_on_outlined,
            title: l10n.cycleModeNone,
            subtitle: l10n.cycleModeNoneSubtitle,
            selected: !setup.any,
            onTap: () => onChanged(const CycleSetup()),
          ),
          if (setup.any)
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(l10n.cycleCreateGynecologist),
              subtitle: Text(l10n.cycleCreateGynecologistSubtitle),
              value: setup.createGynecologist,
              onChanged: (v) => onChanged(
                CycleSetup(
                  cycle: setup.cycle,
                  menopause: setup.menopause,
                  pregnancy: setup.pregnancy,
                  createGynecologist: v ?? false,
                ),
              ),
            ),
          const SizedBox(height: 8),
          const CyclePrivacyNote(),
        ],
      ),
    );
  }
}
