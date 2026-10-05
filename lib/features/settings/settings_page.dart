import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _morningReminder = true;
  bool _eveningReminder = true;
  TimeOfDay _morning = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _evening = const TimeOfDay(hour: 20, minute: 0);

  Future<void> _pickTime({required bool morning}) async {
    final initial = morning ? _morning : _evening;
    final picked = await showTimePicker(context: context, initialTime: initial);
    if (picked == null) return;
    setState(() {
      if (morning) {
        _morning = picked;
      } else {
        _evening = picked;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: ListView(
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
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.45),
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
            subtitle: Text(_morning.format(context)),
            value: _morningReminder,
            onChanged: (value) => setState(() => _morningReminder = value),
            secondary: IconButton(
              icon: const Icon(Icons.schedule),
              onPressed: () => _pickTime(morning: true),
            ),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Abends'),
            subtitle: Text(_evening.format(context)),
            value: _eveningReminder,
            onChanged: (value) => setState(() => _eveningReminder = value),
            secondary: IconButton(
              icon: const Icon(Icons.schedule),
              onPressed: () => _pickTime(morning: false),
            ),
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
            style: theme.textTheme.bodySmall?.copyWith(color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
