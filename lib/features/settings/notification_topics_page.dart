import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/settings_repository.dart';
import '../../l10n/l10n.dart';
import '../../services/notifications/notification_plan.dart';

/// Einstellungen → Benachrichtigungen: je Thema an/aus, Wichtigkeit, diskret.
class NotificationTopicsPage extends StatelessWidget {
  const NotificationTopicsPage({super.key});

  static IconData icon(NotificationTopic topic) => switch (topic) {
    NotificationTopic.medication => Icons.medication_outlined,
    NotificationTopic.appointmentSoon => Icons.alarm,
    NotificationTopic.appointmentAhead => Icons.event_note_outlined,
    NotificationTopic.vaccination => Icons.vaccines_outlined,
    NotificationTopic.checkIn => Icons.edit_note,
    NotificationTopic.cycle => Icons.water_drop_outlined,
    NotificationTopic.mood => Icons.self_improvement,
  };

  @override
  Widget build(BuildContext context) {
    final db = DatabaseScope.of(context);
    final repo = SettingsRepository(db);
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsNotificationsTitle)),
      body: StreamBuilder<AppSetting>(
        stream: repo.watch(),
        builder: (context, snapshot) {
          final settings = snapshot.data;
          if (settings == null) return const SizedBox.shrink();
          final preferences = NotificationPreferences.parse(
            settings.notificationTopics,
          );
          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            children: [
              Text(l10n.settingsNotificationsIntro),
              const SizedBox(height: 12),
              for (final topic in NotificationTopic.values)
                _TopicCard(
                  topic: topic,
                  preference: preferences.of(topic),
                  onChanged: (p) => repo.setNotificationPreferences(
                    preferences.withTopic(topic, p),
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                l10n.settingsNotificationSystemHint,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _TopicCard extends StatelessWidget {
  const _TopicCard({
    required this.topic,
    required this.preference,
    required this.onChanged,
  });

  final NotificationTopic topic;
  final TopicPreference preference;
  final ValueChanged<TopicPreference> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final p = preference;
    return Card(
      key: ValueKey('topic-${topic.id}'),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: Icon(NotificationTopicsPage.icon(topic)),
              title: Text(topic.label),
              subtitle: Text(topic.description),
              value: p.enabled,
              onChanged: (v) => onChanged(p.copyWith(enabled: v)),
            ),
            if (p.enabled) ...[
              SegmentedButton<NotificationLevel>(
                showSelectedIcon: false,
                segments: [
                  ButtonSegment(
                    value: NotificationLevel.important,
                    icon: const Icon(Icons.notifications_active_outlined),
                    label: Text(l10n.settingsNotificationLevelImportant),
                  ),
                  ButtonSegment(
                    value: NotificationLevel.normal,
                    icon: const Icon(Icons.notifications_none),
                    label: Text(l10n.settingsNotificationLevelNormal),
                  ),
                  ButtonSegment(
                    value: NotificationLevel.silent,
                    icon: const Icon(Icons.notifications_paused_outlined),
                    label: Text(l10n.settingsNotificationLevelSilent),
                  ),
                ],
                selected: {p.level},
                onSelectionChanged: (s) => onChanged(p.copyWith(level: s.first)),
              ),
              const SizedBox(height: 6),
              Text(
                switch (p.level) {
                  NotificationLevel.important =>
                    l10n.settingsNotificationLevelImportantHint,
                  NotificationLevel.normal =>
                    l10n.settingsNotificationLevelNormalHint,
                  NotificationLevel.silent =>
                    l10n.settingsNotificationLevelSilentHint,
                },
                style: theme.textTheme.bodySmall,
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.settingsNotificationDiscreet),
                subtitle: Text(l10n.settingsNotificationDiscreetSubtitle),
                value: p.discreet,
                onChanged: (v) => onChanged(p.copyWith(discreet: v)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Kurzbeschreibung für die Einstellungsübersicht, z. B. „3 wichtig · 1 aus“.
String notificationTopicsSummary(
  AppLocalizations l10n,
  NotificationPreferences preferences,
) {
  final topics = NotificationTopic.values.map(preferences.of);
  final important = topics
      .where((p) => p.enabled && p.level == NotificationLevel.important)
      .length;
  final off = topics.where((p) => !p.enabled).length;
  return [
    if (important > 0) '$important × ${l10n.settingsNotificationLevelImportant}',
    if (off > 0) '$off × ${l10n.settingsNotificationOff}',
  ].join(' · ');
}
