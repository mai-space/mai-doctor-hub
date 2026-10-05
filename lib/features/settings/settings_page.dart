import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/settings_repository.dart';
import 'appointment_reminders_tile.dart';
import 'backup_section.dart';
import 'calendar_section.dart';
import 'reminders_section.dart';
import 'security_section.dart';

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
                    'Keine Accounts, keine Patientendaten auf Servern.',
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const RemindersSection(),
              const SizedBox(height: 8),
              AppointmentRemindersTile(settings: settings),
              const SizedBox(height: 24),
              CalendarSection(settings: settings),
              const SizedBox(height: 24),
              const SecuritySection(),
              const SizedBox(height: 24),
              const BackupSection(),
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
                subtitle: Text('1.0.0+1'),
              ),
            ],
          );
        },
      ),
    );
  }
}
