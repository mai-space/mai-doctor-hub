import 'package:flutter/material.dart';

import '../../data/database_provider.dart';
import '../../data/repositories/settings_repository.dart';
import '../../services/app_lock.dart';

/// Einstellungen → App-Sperre.
class SecuritySection extends StatelessWidget {
  const SecuritySection({super.key});

  Future<void> _toggle(BuildContext context, bool value) async {
    final lock = AppLockScope.of(context);
    final settings = SettingsRepository(DatabaseScope.of(context));
    final messenger = ScaffoldMessenger.of(context);
    if (value) {
      if (!await lock.authenticator.isAvailable()) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text(
              'Keine Displaysperre eingerichtet — bitte zuerst in den '
              'Geräteeinstellungen PIN oder Biometrie aktivieren.',
            ),
          ),
        );
        return;
      }
      if (!await lock.enableWithConfirmation()) return;
    } else {
      lock.setEnabled(false);
    }
    await settings.setAppLock(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lock = AppLockScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Sicherheit',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          secondary: const Icon(Icons.fingerprint),
          title: const Text('App-Sperre'),
          subtitle: const Text(
            'Beim Öffnen und nach 1 Minute im Hintergrund mit Biometrie oder '
            'Geräte-PIN entsperren. Inhalte erscheinen nicht in Screenshots '
            'oder der App-Übersicht.',
          ),
          value: lock.enabled,
          onChanged: lock.authenticating ? null : (v) => _toggle(context, v),
        ),
      ],
    );
  }
}
