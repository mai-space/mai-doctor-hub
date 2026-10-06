import '../../data/app_database.dart';
import '../../data/repositories/medication_repository.dart';
import '../../data/repositories/reminder_repository.dart' show Weekdays;
import '../../l10n/l10n.dart';
import 'notification_plan.dart';
import 'plan_sync.dart';

abstract final class MedicationPayload {
  static const prefix = 'medication:';

  static String encode(String medicationId, DateTime scheduledFor) =>
      '$prefix$medicationId@${scheduledFor.millisecondsSinceEpoch}';

  /// (Medikament-ID, geplanter Zeitpunkt) oder `null`.
  static (String, DateTime)? decode(String? payload) {
    if (payload == null || !payload.startsWith(prefix)) return null;
    final rest = payload.substring(prefix.length);
    final at = rest.lastIndexOf('@');
    if (at < 0) return null;
    final millis = int.tryParse(rest.substring(at + 1));
    if (millis == null) return null;
    return (
      rest.substring(0, at),
      DateTime.fromMillisecondsSinceEpoch(millis),
    );
  }
}

/// Einnahme-Erinnerungen.
///
/// Unbefristete Einnahmen: wiederkehrend (täglich/wochentags), überdauern
/// auch lange App-Pausen. Befristete (Enddatum) oder erst später beginnende:
/// einzelne Termine bis zum Ende (max. [horizonDays] voraus) — so endet die
/// Erinnerung pünktlich mit der Einnahme.
abstract final class MedicationReminderPlanner {
  static const horizonDays = 14;
  static const maxOnce = 300;
  static const _onceOffset = 60000;

  static List<PlannedNotification> plan(
    List<MedicationDetails> medications, {
    required DateTime now,
  }) {
    final plans = <PlannedNotification>[];
    final once = <PlannedNotification>[];
    final today = DateTime(now.year, now.month, now.day);
    final l10n = AppLocale.strings;

    for (final details in medications) {
      final m = details.medication;
      if (!m.remindersEnabled || details.schedules.isEmpty) continue;
      if (m.endedAt != null && m.endedAt!.isBefore(today)) continue;
      final title = l10n.svcReminderMedicationTitle(m.name);
      final repeating =
          m.endedAt == null &&
          (m.startedAt == null || !m.startedAt!.isAfter(now));

      for (final s in details.schedules) {
        final body = [
          details.doseFor(s) ?? l10n.svcReminderTakeNow,
          if (m.instructions?.isNotEmpty == true) m.instructions!,
        ].join(' · ');
        if (repeating) {
          final base = NotificationGroup.medications.base + s.slot * 8;
          final daily = s.weekdays & Weekdays.all == Weekdays.all;
          for (final day in daily ? [null] : Weekdays.days(s.weekdays)) {
            plans.add(
              PlannedNotification.repeating(
                id: base + (day ?? 0),
                title: title,
                body: body,
                // Zeitpunkt wird beim Öffnen auf „heute“ bezogen.
                payload: MedicationPayload.encode(
                  m.id,
                  DateTime(0, 1, 1, s.hour, s.minute),
                ),
                topic: NotificationTopic.medication,
                hour: s.hour,
                minute: s.minute,
                weekday: day,
              ),
            );
          }
          continue;
        }
        for (var i = 0; i <= horizonDays; i++) {
          final day = DateTime(today.year, today.month, today.day + i);
          if (!details.isActiveOn(day)) continue;
          if (!Weekdays.contains(s.weekdays, day.weekday)) continue;
          final at = DateTime(day.year, day.month, day.day, s.hour, s.minute);
          if (!at.isAfter(now)) continue;
          once.add(
            PlannedNotification.once(
              id: 0, // wird unten vergeben
              title: title,
              body: body,
              payload: MedicationPayload.encode(m.id, at),
              topic: NotificationTopic.medication,
              at: at,
            ),
          );
        }
      }
    }

    once.sort((a, b) => a.at!.compareTo(b.at!));
    for (final (i, p) in once.take(maxOnce).indexed) {
      plans.add(
        PlannedNotification.once(
          id: NotificationGroup.medications.base + _onceOffset + i,
          title: p.title,
          body: p.body,
          payload: p.payload,
          topic: p.topic,
          at: p.at!,
        ),
      );
    }
    return plans;
  }
}

class MedicationReminderService extends PlanSync {
  MedicationReminderService(
    AppDatabase db,
    NotificationScheduler scheduler, {
    DateTime Function()? clock,
  }) : super(
         db: db,
         scheduler: scheduler,
         group: NotificationGroup.medications,
         tables: {db.medications, db.medicationSchedules},
         plan: () async => MedicationReminderPlanner.plan(
           await MedicationRepository(db).all(),
           now: (clock ?? DateTime.now)(),
         ),
       );
}
