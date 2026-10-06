import '../../data/app_database.dart';
import '../../data/repositories/vaccination_repository.dart';
import '../../l10n/l10n.dart';
import 'notification_plan.dart';
import 'plan_sync.dart';

abstract final class VaccinationPayload {
  static const prefix = 'vaccination:';

  static String encode(String id) => '$prefix$id';

  static String? decode(String? payload) =>
      payload != null && payload.startsWith(prefix)
      ? payload.substring(prefix.length)
      : null;
}

/// Erinnert an fällige Auffrischungen: eine Woche vorher und am Tag selbst,
/// jeweils morgens.
abstract final class VaccinationReminderPlanner {
  static const hour = 9;
  static const leadDays = 7;
  static const maxNotifications = 60;

  static List<PlannedNotification> plan(
    List<Vaccination> due, {
    required DateTime now,
  }) {
    final l10n = AppLocale.strings;
    final candidates = <(DateTime, Vaccination, bool)>[];
    for (final v in due) {
      final d = v.nextDueAt;
      if (d == null) continue;
      final onDay = DateTime(d.year, d.month, d.day, hour);
      final ahead = DateTime(d.year, d.month, d.day - leadDays, hour);
      if (ahead.isAfter(now)) candidates.add((ahead, v, true));
      if (onDay.isAfter(now)) candidates.add((onDay, v, false));
    }
    candidates.sort((a, b) => a.$1.compareTo(b.$1));
    return [
      for (final (i, (at, v, early)) in candidates.take(maxNotifications).indexed)
        PlannedNotification.once(
          id: NotificationGroup.vaccinations.base + i,
          title: early
              ? l10n.svcReminderVaccinationSoon(v.vaccine)
              : l10n.svcReminderVaccinationToday(v.vaccine),
          body: l10n.svcReminderVaccinationBody,
          payload: VaccinationPayload.encode(v.id),
          topic: NotificationTopic.vaccination,
          at: at,
        ),
    ];
  }
}

class VaccinationReminderService extends PlanSync {
  VaccinationReminderService(
    AppDatabase db,
    NotificationScheduler scheduler, {
    DateTime Function()? clock,
  }) : super(
         db: db,
         scheduler: scheduler,
         group: NotificationGroup.vaccinations,
         tables: {db.vaccinations},
         plan: () async {
           final now = (clock ?? DateTime.now)();
           return VaccinationReminderPlanner.plan(
             // Jüngste Impfung je Impfstoff; weit voraus, die Anzahl ist
             // ohnehin begrenzt.
             await VaccinationRepository(
               db,
             ).due(within: const Duration(days: 3650), now: now),
             now: now,
           );
         },
       );
}
