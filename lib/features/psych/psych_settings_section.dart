import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/psych_repository.dart';
import '../../l10n/l10n.dart';
import '../settings/reminders_section.dart' show ensureNotificationPermission;
import 'psych_page.dart';

/// v15: Einstellungen → Psyche: monatliche Fragebögen (wie der MRS-Bogen bei
/// den Wechseljahren) und Zugang zur Seite „Psyche“.
class PsychSettingsSection extends StatelessWidget {
  const PsychSettingsSection({super.key, required this.settings});

  final AppSetting settings;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final repo = PsychRepository(DatabaseScope.of(context));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.psychTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(l10n.psychSettingsSubtitle, style: theme.textTheme.bodySmall),
        SwitchListTile(
          key: const ValueKey('psych-questionnaires'),
          contentPadding: EdgeInsets.zero,
          secondary: const Icon(Icons.event_repeat),
          title: Text(l10n.psychQuestionnairesToggle),
          subtitle: Text(l10n.psychQuestionnairesSubtitle),
          value: settings.psychQuestionnaires,
          onChanged: (v) async {
            await repo.setQuestionnaires(v);
            if (v && context.mounted) {
              await ensureNotificationPermission(context);
            }
          },
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.self_improvement),
          title: Text(l10n.psychOpen),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute<void>(builder: (_) => const PsychPage())),
        ),
      ],
    );
  }
}
