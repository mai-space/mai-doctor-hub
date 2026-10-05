import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/settings_repository.dart';
import '../../services/notification_service.dart';
import '../../theme/app_theme.dart';
import '../check_in/check_in_sheet.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final db = DatabaseScope.of(context);
    final repo = SettingsRepository(db);
    final theme = Theme.of(context);

    return SafeArea(
      child: StreamBuilder<AppSetting>(
        stream: repo.watch(),
        builder: (context, snapshot) {
          final settings = snapshot.data;
          if (settings == null) {
            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              children: const [
                Text('Einstellungen', style: TextStyle(fontSize: 24)),
                SizedBox(height: 16),
                Text('Einstellungen werden geladen…'),
              ],
            );
          }

          final morning = TimeOfDay(
            hour: settings.morningHour,
            minute: settings.morningMinute,
          );
          final evening = TimeOfDay(
            hour: settings.eveningHour,
            minute: settings.eveningMinute,
          );

          Future<void> persist({
            bool? morningEnabled,
            bool? eveningEnabled,
            TimeOfDay? morningTime,
            TimeOfDay? eveningTime,
          }) async {
            final next = AppSetting(
              id: 1,
              morningReminderEnabled:
                  morningEnabled ?? settings.morningReminderEnabled,
              eveningReminderEnabled:
                  eveningEnabled ?? settings.eveningReminderEnabled,
              morningHour: morningTime?.hour ?? settings.morningHour,
              morningMinute: morningTime?.minute ?? settings.morningMinute,
              eveningHour: eveningTime?.hour ?? settings.eveningHour,
              eveningMinute: eveningTime?.minute ?? settings.eveningMinute,
            );
            await repo.updateReminders(
              morningEnabled: next.morningReminderEnabled,
              eveningEnabled: next.eveningReminderEnabled,
              morningHour: next.morningHour,
              morningMinute: next.morningMinute,
              eveningHour: next.eveningHour,
              eveningMinute: next.eveningMinute,
            );
            await NotificationService.instance.syncFromSettings(next);
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              Text(
                'Einstellungen',
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
                child: const ListTile(
                  leading: Icon(Icons.lock_outline),
                  title: Text('Alles lokal auf diesem Gerät'),
                  subtitle: Text(
                    'Keine Accounts, kein Sync, keine Patientendaten auf Servern.',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Erinnerungen',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Morgens'),
                subtitle: Text(morning.format(context)),
                value: settings.morningReminderEnabled,
                onChanged: (value) => persist(morningEnabled: value),
                secondary: IconButton(
                  icon: const Icon(Icons.schedule),
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: morning,
                    );
                    if (picked != null) await persist(morningTime: picked);
                  },
                ),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Abends'),
                subtitle: Text(evening.format(context)),
                value: settings.eveningReminderEnabled,
                onChanged: (value) => persist(eveningEnabled: value),
                secondary: IconButton(
                  icon: const Icon(Icons.schedule),
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: evening,
                    );
                    if (picked != null) await persist(eveningTime: picked);
                  },
                ),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => showCheckInSheet(context),
                icon: const Icon(Icons.favorite_outline),
                label: const Text('Check-in jetzt öffnen'),
              ),
              const SizedBox(height: 24),
              Text(
                'App',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Sprache'),
                subtitle: Text('Deutsch'),
              ),
              const ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Version'),
                subtitle: Text('1.0.0+1 (Iteration 1)'),
              ),
              Text(
                'Erweiterungen (PIN, Export, Themes) folgen später.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.muted,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
