import '../../data/app_database.dart';
import '../../data/repositories/psych_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../l10n/l10n.dart';
import 'notification_plan.dart';
import 'plan_sync.dart';

/// Payload `psych:<ziel>` — öffnet die Seite „Psyche“.
abstract final class PsychPayload {
  static const prefix = 'psych:';
  static const questionnaire = 'questionnaire';

  static String encode(String target) => '$prefix$target';

  static String? decode(String? payload) =>
      payload != null && payload.startsWith(prefix)
      ? payload.substring(prefix.length)
      : null;
}

/// v15: Monatliche Erinnerung an PHQ-9/GAD-7 — 30 Tage nach dem letzten
/// Bogen um 10 Uhr (ohne Bogen: am nächsten Tag), Thema „Stimmung“
/// (standardmäßig diskret).
abstract final class PsychReminderPlanner {
  static const hour = 10;
  static const interval = 30;

  static List<PlannedNotification> plan({
    required bool enabled,
    required DateTime? lastAssessment,
    required DateTime now,
  }) {
    if (!enabled) return const [];
    DateTime at(DateTime day) => DateTime(day.year, day.month, day.day, hour);
    var due = lastAssessment == null
        ? at(DateTime(now.year, now.month, now.day + 1))
        : at(
            DateTime(
              lastAssessment.year,
              lastAssessment.month,
              lastAssessment.day + interval,
            ),
          );
    if (!due.isAfter(now)) due = at(DateTime(now.year, now.month, now.day + 1));
    final l10n = AppLocale.strings;
    return [
      PlannedNotification.once(
        id: NotificationGroup.psych.base,
        title: l10n.psychReminderTitle,
        body: l10n.psychReminderBody,
        payload: PsychPayload.encode(PsychPayload.questionnaire),
        topic: NotificationTopic.mood,
        at: due,
      ),
    ];
  }
}

class PsychReminderService extends PlanSync {
  PsychReminderService(
    AppDatabase db,
    NotificationScheduler scheduler, {
    DateTime Function()? clock,
  }) : super(
         db: db,
         scheduler: scheduler,
         group: NotificationGroup.psych,
         tables: {db.psychAssessments},
         plan: () async {
           final settings = await SettingsRepository(db).get();
           final entries = await PsychRepository(db).all();
           return PsychReminderPlanner.plan(
             enabled: settings.psychQuestionnaires,
             lastAssessment: entries.isEmpty ? null : entries.last.recordedAt,
             now: (clock ?? DateTime.now)(),
           );
         },
       );
}
