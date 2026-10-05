import 'package:flutter/material.dart';

import '../../data/database_provider.dart';
import '../../data/repositories/settings_repository.dart';
import '../../services/notification_service.dart';
import '../../widgets/app_logo.dart';

/// Kurzes Onboarding beim ersten Start. Die Benachrichtigungs-Berechtigung
/// wird erst hier — mit Erklärung — angefragt, nicht beim App-Start.
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _pages = PageController();
  int _index = 0;
  bool? _notificationsGranted;

  static const _count = 3;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  Future<void> _finish() =>
      SettingsRepository(DatabaseScope.of(context)).completeOnboarding();

  void _next() {
    if (_index == _count - 1) {
      _finish();
    } else {
      _pages.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _askNotifications() async {
    final granted = await NotificationPermissions.current.request();
    if (mounted) setState(() => _notificationsGranted = granted);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _finish,
                child: const Text('Überspringen'),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pages,
                onPageChanged: (i) => setState(() => _index = i),
                children: [
                  const _Step(
                    visual: AppLogo(size: 96),
                    title: 'Deine Akte bleibt bei dir',
                    text:
                        'Mai Doctor Hub speichert alles nur auf diesem Gerät. '
                        'Kein Konto, kein Server. Was das Gerät verlässt — '
                        'Sicherung, Kalender, Assistent — entscheidest du.',
                  ),
                  const _Step(
                    visual: _StepIcon(Icons.medical_services_outlined),
                    title: 'Alles an einem Ort',
                    text:
                        'Termine, Ärzte, Diagnosen, Symptome, Medikamente und '
                        'Arztberichte — durchsuchbar und miteinander '
                        'verknüpft. Für den nächsten Arztbesuch hast du alles '
                        'parat.',
                  ),
                  _Step(
                    visual: const _StepIcon(
                      Icons.notifications_active_outlined,
                    ),
                    title: 'Erinnerungen',
                    text:
                        'Damit wir dich an Check-ins, Termine und Medikamente '
                        'erinnern können, braucht die App die Erlaubnis für '
                        'Benachrichtigungen. Sie werden lokal auf dem Gerät '
                        'geplant — ohne Push-Server. Du kannst das später '
                        'jederzeit ändern.',
                    action: switch (_notificationsGranted) {
                      null => FilledButton.icon(
                        onPressed: _askNotifications,
                        icon: const Icon(Icons.notifications_outlined),
                        label: const Text('Benachrichtigungen erlauben'),
                      ),
                      true => const Chip(
                        avatar: Icon(Icons.check),
                        label: Text('Erlaubt'),
                      ),
                      false => Text(
                        'Nicht erlaubt — in den Einstellungen der App '
                        'jederzeit nachholbar.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall,
                      ),
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Row(
                children: [
                  for (var i = 0; i < _count; i++)
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i == _index
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outlineVariant,
                      ),
                    ),
                  const Spacer(),
                  FilledButton(
                    // Theme-Standard ist volle Breite — in einer Row unmöglich.
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(140, 48),
                    ),
                    onPressed: _next,
                    child: Text(_index == _count - 1 ? 'Los geht’s' : 'Weiter'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.visual,
    required this.title,
    required this.text,
    this.action,
  });

  final Widget visual;
  final String title;
  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Column(
        children: [
          visual,
          const SizedBox(height: 24),
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            text,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          if (action != null) ...[const SizedBox(height: 24), action!],
        ],
      ),
    );
  }
}

class _StepIcon extends StatelessWidget {
  const _StepIcon(this.icon);

  final IconData icon;

  @override
  Widget build(BuildContext context) =>
      Icon(icon, size: 72, color: Theme.of(context).colorScheme.primary);
}
