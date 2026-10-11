import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/settings_repository.dart';
import '../../l10n/l10n.dart';
import '../../services/device_platform.dart';
import '../../services/home_widgets/widget_snapshot.dart';

/// v19: Einstellungen → Startbildschirm-Widgets: diskret, mit Details oder
/// automatisch (diskret, solange die App-Sperre an ist). Gilt auch für die
/// Uhr-Apps (Wear OS, Apple Watch); unter iOS gibt es nur die Uhr.
class HomeWidgetsSection extends StatelessWidget {
  const HomeWidgetsSection({super.key, required this.settings});

  final AppSetting settings;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final repo = SettingsRepository(DatabaseScope.of(context));
    final mode = settings.widgetDiscreet;
    final hint = switch (mode) {
      null when widgetsDiscreet(settings) => l10n.widgetsAutoDiscreet,
      null => l10n.widgetsAutoDetailed,
      true => l10n.widgetsDiscreetText,
      false => l10n.widgetsDetailedText,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          DevicePlatform.isIOS ? l10n.widgetsWatchTitle : l10n.widgetsTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          DevicePlatform.isIOS ? l10n.widgetsWatchIntro : l10n.widgetsIntro,
          style: theme.textTheme.bodySmall,
        ),
        if (DevicePlatform.isAndroid) ...[
          const SizedBox(height: 4),
          Text(l10n.widgetsWatchHint, style: theme.textTheme.bodySmall),
        ],
        const SizedBox(height: 12),
        // Enum statt bool?: SegmentedButton braucht eindeutige Werte.
        SegmentedButton<_Mode>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment(
              value: _Mode.auto,
              icon: const Icon(Icons.lock_clock_outlined),
              label: Text(l10n.widgetsModeAuto),
            ),
            ButtonSegment(
              value: _Mode.discreet,
              icon: const Icon(Icons.visibility_off_outlined),
              label: Text(l10n.widgetsModeDiscreet),
            ),
            ButtonSegment(
              value: _Mode.detailed,
              icon: const Icon(Icons.visibility_outlined),
              label: Text(l10n.widgetsModeDetailed),
            ),
          ],
          selected: {_Mode.of(mode)},
          onSelectionChanged: (v) => repo.setWidgetDiscreet(v.first.value),
        ),
        const SizedBox(height: 8),
        Text(hint, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

enum _Mode {
  auto(null),
  discreet(true),
  detailed(false);

  const _Mode(this.value);

  final bool? value;

  static _Mode of(bool? value) =>
      values.firstWhere((m) => m.value == value);
}
