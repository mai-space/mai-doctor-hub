import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/settings_repository.dart';
import '../../l10n/l10n.dart';
import '../archive/archive_page.dart';
import '../cycle/cycle_settings_section.dart';
import '../psych/psych_settings_section.dart';
import 'appointment_reminders_tile.dart';
import 'backup_section.dart';
import '../../services/notifications/notification_plan.dart';
import 'calendar_section.dart';
import 'notification_topics_page.dart';
import 'reminders_section.dart';
import 'security_section.dart';
import 'units_section.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final db = DatabaseScope.of(context);
    final repo = SettingsRepository(db);
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return SafeArea(
      child: StreamBuilder<AppSetting>(
        stream: repo.watch(),
        builder: (context, snapshot) {
          final settings = snapshot.data;
          if (settings == null) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              children: [
                Text(l10n.settingsTitle, style: const TextStyle(fontSize: 24)),
                const SizedBox(height: 16),
                Text(l10n.settingsLoading),
              ],
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              Text(
                l10n.settingsTitle,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 0,
                color: theme.colorScheme.primaryContainer.withValues(
                  alpha: 0.45,
                ),
                child: ListTile(
                  leading: const Icon(Icons.lock_outline),
                  title: Text(l10n.settingsLocalOnlyTitle),
                  subtitle: Text(l10n.settingsLocalOnlySubtitle),
                ),
              ),
              const SizedBox(height: 24),
              const RemindersSection(),
              const SizedBox(height: 8),
              AppointmentRemindersTile(settings: settings),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.tune),
                title: Text(l10n.settingsNotificationsTitle),
                subtitle: Text(
                  [
                    l10n.settingsNotificationsSubtitle,
                    notificationTopicsSummary(
                      l10n,
                      NotificationPreferences.parse(
                        settings.notificationTopics,
                      ),
                    ),
                  ].where((s) => s.isNotEmpty).join('\n'),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const NotificationTopicsPage(),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              CalendarSection(settings: settings),
              const SizedBox(height: 24),
              const SecuritySection(),
              const SizedBox(height: 24),
              const BackupSection(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.inventory_2_outlined),
                title: Text(l10n.settingsArchiveTitle),
                subtitle: Text(l10n.settingsArchiveSubtitle),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(builder: (_) => const ArchivePage()),
                ),
              ),
              const SizedBox(height: 24),
              CycleSettingsSection(settings: settings),
              const SizedBox(height: 24),
              PsychSettingsSection(settings: settings),
              const SizedBox(height: 24),
              UnitsSection(settings: settings),
              const SizedBox(height: 24),
              Text(
                l10n.settingsAppSection,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.settingsLanguage),
                subtitle: Text(l10n.settingsLanguageValue),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.settingsVersion),
                subtitle: const Text('1.0.0+1'),
              ),
            ],
          );
        },
      ),
    );
  }
}
