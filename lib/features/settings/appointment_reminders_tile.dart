import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/settings_repository.dart';
import '../../services/notifications/appointment_reminders.dart';
import 'reminders_section.dart';

/// Einstellungen → Termin-Erinnerungen (an/aus + Vorlaufzeiten).
class AppointmentRemindersTile extends StatelessWidget {
  const AppointmentRemindersTile({super.key, required this.settings});

  final AppSetting settings;

  Future<void> _save(
    BuildContext context, {
    bool? enabled,
    List<int>? leads,
  }) => SettingsRepository(DatabaseScope.of(context)).updateAppointmentReminders(
    enabled: enabled ?? settings.appointmentRemindersEnabled,
    leadMinutes: leads ?? parseLeadMinutes(settings.appointmentReminderLeads),
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final leads = parseLeadMinutes(settings.appointmentReminderLeads);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          secondary: const Icon(Icons.event_note_outlined),
          title: const Text('Termin-Erinnerungen'),
          subtitle: Text(
            settings.calendarSyncEnabled && settings.appointmentRemindersEnabled
                ? 'Tipp: Termine gehen auch in deinen Kalender — ggf. doppelt '
                      'erinnert. Eines von beiden abschalten.'
                : 'Benachrichtigung vor Arztterminen. Wer lieber den '
                      'Google Kalender nutzt, schaltet das aus.',
          ),
          value: settings.appointmentRemindersEnabled,
          onChanged: (v) async {
            await _save(context, enabled: v);
            if (v && context.mounted) {
              await ensureNotificationPermission(context);
            }
          },
        ),
        if (settings.appointmentRemindersEnabled) ...[
          Text('Erinnern vorher', style: theme.textTheme.bodySmall),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            children: [
              for (final MapEntry(key: minutes, value: label)
                  in appointmentLeadOptions.entries)
                FilterChip(
                  label: Text(label),
                  selected: leads.contains(minutes),
                  onSelected: (selected) {
                    final next = {...leads};
                    selected ? next.add(minutes) : next.remove(minutes);
                    if (next.isEmpty) return; // mindestens eine Vorlaufzeit
                    _save(context, leads: next.toList());
                  },
                ),
            ],
          ),
        ],
      ],
    );
  }
}
