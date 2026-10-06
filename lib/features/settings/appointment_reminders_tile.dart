import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/settings_repository.dart';
import '../../l10n/l10n.dart';
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
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          secondary: const Icon(Icons.event_note_outlined),
          title: Text(l10n.settingsAppointmentRemindersTitle),
          subtitle: Text(
            settings.calendarSyncEnabled && settings.appointmentRemindersEnabled
                ? l10n.settingsAppointmentRemindersCalendarTip
                : l10n.settingsAppointmentRemindersSubtitle,
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
          Text(
            l10n.settingsAppointmentRemindersLeadLabel,
            style: theme.textTheme.bodySmall,
          ),
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
