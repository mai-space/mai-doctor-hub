import 'dart:convert';

import '../../l10n/l10n.dart';

/// Bereiche für Benachrichtigungs-IDs — jede Quelle ersetzt nur ihren eigenen.
enum NotificationGroup {
  reminders(100000),
  appointments(200000),
  medications(300000),
  vaccinations(400000),
  cycle(500000);

  const NotificationGroup(this.base);

  final int base;
  int get end => base + 100000;
  bool contains(int id) => id >= base && id < end;
}

/// Wie auffällig eine Benachrichtigung ist (Android: Wichtigkeit des Kanals).
enum NotificationLevel {
  /// Ton und Banner oben auf dem Bildschirm.
  important,

  /// Ton, nur in der Benachrichtigungsleiste.
  normal,

  /// Kein Ton, nur in der Benachrichtigungsleiste.
  silent,
}

/// Themen — jedes mit eigenem Android-Kanal, eigener Wichtigkeit und eigenem
/// Diskret-Modus, damit Wichtiges (Einnahme) nicht im Rauschen untergeht.
enum NotificationTopic {
  medication('medication', NotificationLevel.important),
  appointmentSoon('appointment_soon', NotificationLevel.important),
  appointmentAhead('appointment_ahead', NotificationLevel.normal),
  vaccination('vaccination', NotificationLevel.normal),
  checkIn('check_in', NotificationLevel.normal),

  /// v14: Zyklus, Wechseljahre (MRS), Schwangerschaft — standardmäßig
  /// diskret, damit auf dem Sperrbildschirm nichts über die Periode steht.
  cycle('cycle', NotificationLevel.normal, defaultDiscreet: true);

  const NotificationTopic(
    this.id,
    this.defaultLevel, {
    this.defaultDiscreet = false,
  });

  final String id;
  final NotificationLevel defaultLevel;
  final bool defaultDiscreet;

  /// Android legt die Wichtigkeit beim Anlegen eines Kanals fest und lässt
  /// sie danach nur Nutzer ändern — deshalb ein Kanal je Stufe.
  String channelId(NotificationLevel level) => '${id}_${level.name}';

  /// Kanal-IDs vor den Themen (v1.0); werden beim Start entfernt.
  static const legacyChannelIds = ['check_in', 'appointment', 'medication'];

  /// Name in den Android-Einstellungen (App-Sprache).
  String get label {
    final l10n = AppLocale.strings;
    return switch (this) {
      medication => l10n.svcTopicMedication,
      appointmentSoon => l10n.svcTopicAppointmentSoon,
      appointmentAhead => l10n.svcTopicAppointmentAhead,
      vaccination => l10n.svcTopicVaccination,
      checkIn => l10n.svcChannelCheckIn,
      cycle => l10n.cycleTopic,
    };
  }

  String get description {
    final l10n = AppLocale.strings;
    return switch (this) {
      medication => l10n.svcChannelMedicationDescription,
      appointmentSoon => l10n.svcTopicAppointmentSoonDescription,
      appointmentAhead => l10n.svcTopicAppointmentAheadDescription,
      vaccination => l10n.svcTopicVaccinationDescription,
      checkIn => l10n.svcChannelCheckInDescription,
      cycle => l10n.cycleTopicDescription,
    };
  }

  /// Text im Diskret-Modus: ohne Medikament, Arzt, Impfung oder Symptom.
  (String title, String body) get discreet {
    final l10n = AppLocale.strings;
    return switch (this) {
      medication => (l10n.svcDiscreetMedicationTitle, l10n.svcDiscreetBody),
      appointmentSoon ||
      appointmentAhead => (l10n.svcDiscreetAppointmentTitle, l10n.svcDiscreetBody),
      vaccination => (l10n.svcDiscreetVaccinationTitle, l10n.svcDiscreetBody),
      checkIn => (l10n.svcDiscreetCheckInTitle, l10n.svcDiscreetBody),
      cycle => (l10n.cycleDiscreetTitle, l10n.svcDiscreetBody),
    };
  }
}

/// Einstellung eines Themas.
class TopicPreference {
  const TopicPreference({
    this.enabled = true,
    required this.level,
    this.discreet = false,
  });

  final bool enabled;
  final NotificationLevel level;

  /// Titel/Text ohne Gesundheitsdaten (z. B. für den Sperrbildschirm).
  final bool discreet;

  TopicPreference copyWith({
    bool? enabled,
    NotificationLevel? level,
    bool? discreet,
  }) => TopicPreference(
    enabled: enabled ?? this.enabled,
    level: level ?? this.level,
    discreet: discreet ?? this.discreet,
  );

  @override
  bool operator ==(Object other) =>
      other is TopicPreference &&
      other.enabled == enabled &&
      other.level == level &&
      other.discreet == discreet;

  @override
  int get hashCode => Object.hash(enabled, level, discreet);
}

/// Einstellungen aller Themen; gespeichert als JSON in den App-Settings.
class NotificationPreferences {
  const NotificationPreferences([this._topics = const {}]);

  final Map<NotificationTopic, TopicPreference> _topics;

  TopicPreference of(NotificationTopic topic) =>
      _topics[topic] ??
      TopicPreference(
        level: topic.defaultLevel,
        discreet: topic.defaultDiscreet,
      );

  NotificationPreferences withTopic(
    NotificationTopic topic,
    TopicPreference preference,
  ) => NotificationPreferences({..._topics, topic: preference});

  /// Unbekannte Themen/Werte werden ignoriert (Standard greift).
  static NotificationPreferences parse(String raw) {
    if (raw.trim().isEmpty) return const NotificationPreferences();
    try {
      final json = jsonDecode(raw);
      if (json is! Map<String, Object?>) return const NotificationPreferences();
      final topics = <NotificationTopic, TopicPreference>{};
      for (final topic in NotificationTopic.values) {
        final entry = json[topic.id];
        if (entry is! Map<String, Object?>) continue;
        final level = NotificationLevel.values
            .where((l) => l.name == entry['level'])
            .firstOrNull;
        topics[topic] = TopicPreference(
          enabled: entry['enabled'] != false,
          level: level ?? topic.defaultLevel,
          discreet: switch (entry['discreet']) {
            final bool value => value,
            _ => topic.defaultDiscreet,
          },
        );
      }
      return NotificationPreferences(topics);
    } on FormatException {
      return const NotificationPreferences();
    }
  }

  String encode() => jsonEncode({
    for (final MapEntry(key: topic, value: p) in _topics.entries)
      topic.id: {
        'enabled': p.enabled,
        'level': p.level.name,
        'discreet': p.discreet,
      },
  });

  /// Nur eingeschaltete Themen; Stufe gesetzt, Text ggf. diskret.
  List<PlannedNotification> apply(List<PlannedNotification> plans) => [
    for (final plan in plans)
      if (of(plan.topic) case final p when p.enabled)
        plan.withPreference(p),
  ];
}

/// Eine geplante Benachrichtigung — reine Daten, ohne Plugin.
///
/// Entweder wiederkehrend ([hour]/[minute], optional [weekday] 1=Mo…7=So;
/// ohne Wochentag täglich) oder einmalig zum Zeitpunkt [at].
class PlannedNotification {
  const PlannedNotification.repeating({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
    required this.topic,
    this.level,
    this.discreet = false,
    required int this.hour,
    required int this.minute,
    this.weekday,
  }) : at = null;

  const PlannedNotification.once({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
    required this.topic,
    this.level,
    this.discreet = false,
    required DateTime this.at,
  }) : hour = null,
       minute = null,
       weekday = null;

  final int id;
  final String title;
  final String body;
  final String payload;
  final NotificationTopic topic;

  /// Gesetzt von [NotificationPreferences.apply]; sonst Standard des Themas.
  final NotificationLevel? level;

  NotificationLevel get effectiveLevel => level ?? topic.defaultLevel;

  /// Text ohne Gesundheitsdaten — darf auf dem Sperrbildschirm erscheinen.
  final bool discreet;
  final int? hour;
  final int? minute;
  final int? weekday;
  final DateTime? at;

  bool get isRepeating => at == null;

  PlannedNotification withPreference(TopicPreference preference) {
    final (title, body) = preference.discreet
        ? topic.discreet
        : (this.title, this.body);
    return isRepeating
        ? PlannedNotification.repeating(
            id: id,
            title: title,
            body: body,
            payload: payload,
            topic: topic,
            level: preference.level,
            discreet: preference.discreet,
            hour: hour!,
            minute: minute!,
            weekday: weekday,
          )
        : PlannedNotification.once(
            id: id,
            title: title,
            body: body,
            payload: payload,
            topic: topic,
            level: preference.level,
            discreet: preference.discreet,
            at: at!,
          );
  }

  @override
  String toString() => isRepeating
      ? 'Plan#$id ${weekday ?? 'täglich'} $hour:$minute "$title"'
      : 'Plan#$id $at "$title"';
}

/// Plant/entfernt Benachrichtigungen — austauschbar für Tests.
abstract interface class NotificationScheduler {
  /// Ersetzt alle Benachrichtigungen der [group] durch [plans].
  Future<void> replace(NotificationGroup group, List<PlannedNotification> plans);
}
