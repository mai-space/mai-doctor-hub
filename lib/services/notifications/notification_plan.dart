/// Bereiche für Benachrichtigungs-IDs — jede Quelle ersetzt nur ihren eigenen.
enum NotificationGroup {
  reminders(100000),
  appointments(200000),
  medications(300000);

  const NotificationGroup(this.base);

  final int base;
  int get end => base + 100000;
  bool contains(int id) => id >= base && id < end;
}

/// Kanäle (Android: in den System-Einstellungen einzeln abschaltbar).
enum NotificationChannel {
  checkIn('check_in', 'Symptom-Check-in', 'Erinnerungen für Check-ins'),
  appointment('appointment', 'Termine', 'Erinnerungen vor Arztterminen'),
  medication('medication', 'Medikamente', 'Einnahme-Erinnerungen');

  const NotificationChannel(this.id, this.label, this.description);

  final String id;
  final String label;
  final String description;
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
    required this.channel,
    required int this.hour,
    required int this.minute,
    this.weekday,
  }) : at = null;

  const PlannedNotification.once({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
    required this.channel,
    required DateTime this.at,
  }) : hour = null,
       minute = null,
       weekday = null;

  final int id;
  final String title;
  final String body;
  final String payload;
  final NotificationChannel channel;
  final int? hour;
  final int? minute;
  final int? weekday;
  final DateTime? at;

  bool get isRepeating => at == null;

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
