import 'package:flutter/material.dart';

import '../services/app_lock.dart';

/// Legt den Sperrbildschirm über die gesamte App, solange gesperrt.
class AppLockGate extends StatefulWidget {
  const AppLockGate({super.key, required this.child});

  final Widget child;

  @override
  State<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends State<AppLockGate> {
  bool _prompted = false;

  @override
  Widget build(BuildContext context) {
    final lock = AppLockScope.of(context);
    if (!lock.locked) {
      _prompted = false;
      return widget.child;
    }
    // Einmal automatisch fragen; danach per Knopf.
    if (!_prompted) {
      _prompted = true;
      WidgetsBinding.instance.addPostFrameCallback((_) => lock.unlock());
    }
    // Inhalt bleibt im Baum (Zustand/Navigation), ist aber nicht sichtbar.
    return Stack(
      children: [
        Offstage(child: ExcludeSemantics(child: widget.child)),
        const Positioned.fill(child: _LockScreen()),
      ],
    );
  }
}

class _LockScreen extends StatelessWidget {
  const _LockScreen();

  @override
  Widget build(BuildContext context) {
    final lock = AppLockScope.of(context);
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      child: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.lock_outline,
                  size: 56,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'Mai Doctor Hub ist gesperrt',
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Mit Fingerabdruck, Gesicht oder Geräte-PIN entsperren.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: lock.authenticating ? null : lock.unlock,
                  icon: const Icon(Icons.fingerprint),
                  label: const Text('Entsperren'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
