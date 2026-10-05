import 'package:flutter/widgets.dart';

/// Reagiert, wenn die App in den Vordergrund kommt: Zeitzone oder Uhrzeit
/// können sich inzwischen geändert haben (Reise, Sommerzeit, manuell
/// gestellte Uhr). Android liefert dafür keine Events an Flutter; der
/// Wiedereintritt ist der verlässliche Zeitpunkt zum Nachprüfen.
class TimeChangeObserver with WidgetsBindingObserver {
  TimeChangeObserver(this.onResume);

  final Future<void> Function() onResume;

  void attach() => WidgetsBinding.instance.addObserver(this);

  void detach() => WidgetsBinding.instance.removeObserver(this);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      onResume().catchError((Object e) {
        debugPrint('Zeit-Abgleich fehlgeschlagen: $e');
      });
    }
  }
}
