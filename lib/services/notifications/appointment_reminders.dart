import 'package:intl/intl.dart';

import 'package:drift/drift.dart';

import '../../data/app_database.dart';
import '../../data/repositories/appointment_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../l10n/l10n.dart';
import 'notification_plan.dart';
import 'plan_sync.dart';

/// Wählbare Vorlaufzeiten (Minuten) mit Beschriftung in der App-Sprache.
Map<int, String> get appointmentLeadOptions {
  final l10n = AppLocale.strings;
  return {
    15: l10n.svcReminderLead15Min,
    60: l10n.svcReminderLead1Hour,
    120: l10n.svcReminderLead2Hours,
    1440: l10n.svcReminderLead1Day,
    2880: l10n.svcReminderLead2Days,
    10080: l10n.svcReminderLead1Week,
  };
}

abstract final class AppointmentPayload {
  static const prefix = 'appointment:';

  static String encode(String id) => '$prefix$id';

  static String? decode(String? payload) =>
      payload != null && payload.startsWith(prefix)
      ? payload.substring(prefix.length)
      : null;
}

/// Plant Erinnerungen vor geplanten Terminen.
abstract final class AppointmentReminderPlanner {
  /// Android erlaubt ~500 Wecker pro App — wir bleiben weit darunter.
  static const maxNotifications = 60;

  static List<PlannedNotification> plan(
    List<AppointmentSummary> upcoming, {
    required List<int> leadMinutes,
    required DateTime now,
  }) {
    final candidates = <(DateTime, AppointmentSummary, int)>[];
    for (final s in upcoming) {
      final a = s.appointment;
      if (a.status != AppointmentStatus.planned) continue;
      for (final lead in leadMinutes) {
        final at = a.scheduledAt.subtract(Duration(minutes: lead));
        if (at.isAfter(now)) candidates.add((at, s, lead));
      }
    }
    candidates.sort((x, y) => x.$1.compareTo(y.$1));

    final plans = <PlannedNotification>[];
    for (final (i, (at, s, lead)) in candidates.take(maxNotifications).indexed) {
      final a = s.appointment;
      plans.add(
        PlannedNotification.once(
          id: NotificationGroup.appointments.base + i,
          title: '${_when(a.scheduledAt, lead)} · ${s.doctorName}',
          body: [
            if (a.title?.isNotEmpty == true) a.title!,
            if (s.doctor?.practiceName?.isNotEmpty == true)
              s.doctor!.practiceName!,
            if (s.doctor?.address?.isNotEmpty == true) s.doctor!.address!,
          ].join(' · ').ifEmpty(AppLocale.strings.svcReminderAppointmentFallback),
          payload: AppointmentPayload.encode(a.id),
          channel: NotificationChannel.appointment,
          at: at,
        ),
      );
    }
    return plans;
  }

  /// „Morgen 09:00“, „In 1 Stunde (14:30)“, „Mi., 12.11. 09:00“.
  static String _when(DateTime start, int lead) {
    final l10n = AppLocale.strings;
    final time = DateFormat(l10n.svcReminderTimePattern).format(start);
    if (lead < 60) return l10n.svcReminderInMinutes(lead, time);
    if (lead < 1440) return l10n.svcReminderInHours(lead ~/ 60, time);
    if (lead == 1440) return l10n.svcReminderTomorrow(time);
    return '${DateFormat(l10n.svcReminderDayPattern).format(start)} $time';
  }
}

extension on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}

/// Hält Termin-Erinnerungen synchron (Termine, Ärzte, Einstellung).
class AppointmentReminderService extends PlanSync {
  AppointmentReminderService(
    AppDatabase db,
    NotificationScheduler scheduler, {
    DateTime Function()? clock,
  }) : super(
         db: db,
         scheduler: scheduler,
         group: NotificationGroup.appointments,
         tables: {db.appointments, db.doctors, db.appSettings},
         plan: () async {
           final settings = await SettingsRepository(db).get();
           if (!settings.appointmentRemindersEnabled) return const [];
           final now = (clock ?? DateTime.now)();
           final rows =
               await (db.selectActive(db.appointments)
                     ..where((t) => t.scheduledAt.isBiggerOrEqualValue(now))
                     ..where(
                       (t) => t.status.equalsValue(AppointmentStatus.planned),
                     ))
                   .get();
           return AppointmentReminderPlanner.plan(
             await AppointmentRepository(db).summariesFor(rows),
             leadMinutes: parseLeadMinutes(settings.appointmentReminderLeads),
             now: now,
           );
         },
       );
}
