import 'package:drift/drift.dart';

import '../../data/app_database.dart';
import '../../data/repositories/cycle_repository.dart';
import '../../l10n/l10n.dart';
import '../cycle/cycle_dates.dart';
import '../cycle/cycle_text.dart' show milestoneTitle;
import '../cycle/mrs.dart';
import '../cycle/pregnancy_math.dart';
import 'notification_plan.dart';
import 'plan_sync.dart';

/// Payload `cycle:<ziel>` — öffnet die Zyklus-Seite bzw. den MRS-Bogen.
abstract final class CyclePayload {
  static const prefix = 'cycle:';
  static const today = 'today';
  static const mrs = 'mrs';

  static String encode(String target) => '$prefix$target';

  static String? decode(String? payload) =>
      payload != null && payload.startsWith(prefix)
      ? payload.substring(prefix.length)
      : null;
}

/// Erinnerungen des Themas „Zyklus“:
/// * Periode in etwa 2 Tagen bzw. heute erwartet (geschätzt, 9 Uhr),
/// * MRS-Fragebogen 30 Tage nach dem letzten (10 Uhr),
/// * Schwangerschaft: Beginn der Ultraschall-Fenster und die nächsten
///   Vorsorge-Wochen — nur, wenn in dem Zeitraum noch kein Termin geplant ist.
abstract final class CycleReminderPlanner {
  static const hour = 9;
  static const mrsHour = 10;
  static const leadDays = 2;
  static const mrsInterval = 30;

  static List<PlannedNotification> plan(
    CycleOverview overview, {
    required DateTime now,
    List<DateTime> plannedAppointments = const [],
  }) {
    final l10n = AppLocale.strings;
    final candidates = <(DateTime, String, String, String)>[];
    void add(DateTime at, String title, String body, String target) {
      if (at.isAfter(now)) candidates.add((at, title, body, target));
    }

    DateTime at(DateTime day, int h) =>
        DateTime(day.year, day.month, day.day, h);

    final prediction = overview.analysis.prediction;
    if (overview.cycleTracking && !overview.pregnant && prediction != null) {
      add(
        at(plusDays(prediction.start, -leadDays), hour),
        l10n.cycleReminderSoonTitle,
        l10n.cycleReminderBody,
        CyclePayload.today,
      );
      if (!overview.analysis.inPeriod) {
        add(
          at(prediction.start, hour),
          l10n.cycleReminderTodayTitle,
          l10n.cycleReminderBody,
          CyclePayload.today,
        );
      }
    }

    if (overview.menopauseTracking) {
      final last = overview.latestMrs;
      if (last != null) {
        var due = at(plusDays(cycleDay(last.recordedAt), mrsInterval), mrsHour);
        if (!due.isAfter(now)) due = at(plusDays(cycleDay(now), 1), mrsHour);
        add(
          due,
          l10n.cycleReminderMrsTitle,
          l10n.cycleReminderMrsBody(MrsResult.parse(last.scores).total),
          CyclePayload.mrs,
        );
      }
    }

    final status = overview.pregnancyStatus;
    if (overview.pregnant && status != null) {
      bool covered(DateTime from, DateTime to) => plannedAppointments.any(
        (a) => !cycleDay(a).isBefore(from) && !cycleDay(a).isAfter(to),
      );
      var checkups = 0;
      for (final m in pregnancyTimeline(status, upcomingOnly: true)) {
        if (covered(m.from, m.to)) continue;
        if (m.kind == MilestoneKind.checkup) {
          // Nur die nächsten zwei Vorsorge-Wochen.
          if (checkups++ >= 2) continue;
        }
        add(
          at(m.from, hour),
          milestoneTitle(m, l10n),
          l10n.cycleReminderMilestoneBody,
          CyclePayload.today,
        );
      }
    }

    candidates.sort((a, b) => a.$1.compareTo(b.$1));
    return [
      for (final (i, (fireAt, title, body, target))
          in candidates.take(50).indexed)
        PlannedNotification.once(
          id: NotificationGroup.cycle.base + i,
          title: title,
          body: body,
          payload: CyclePayload.encode(target),
          topic: NotificationTopic.cycle,
          at: fireAt,
        ),
    ];
  }
}

class CycleReminderService extends PlanSync {
  CycleReminderService(
    AppDatabase db,
    NotificationScheduler scheduler, {
    DateTime Function()? clock,
  }) : super(
         db: db,
         scheduler: scheduler,
         group: NotificationGroup.cycle,
         tables: {
           db.cycleDays,
           db.mrsAssessments,
           db.pregnancies,
           db.appointments,
         },
         plan: () async {
           final now = (clock ?? DateTime.now)();
           final overview = await CycleRepository(db).overview(now: now);
           if (!overview.enabled) return const [];
           final appointments =
               await (db.selectActive(db.appointments)
                     ..where((t) => t.scheduledAt.isBiggerOrEqualValue(now))
                     ..where(
                       (t) => t.status.equalsValue(AppointmentStatus.planned),
                     ))
                   .get();
           return CycleReminderPlanner.plan(
             overview,
             now: now,
             plannedAppointments: [for (final a in appointments) a.scheduledAt],
           );
         },
       );
}
