import 'package:drift/drift.dart';

import '../../data/app_database.dart';
import '../../data/repositories/cycle_repository.dart';
import '../../data/repositories/vaccination_repository.dart';
import '../../l10n/l10n.dart';
import '../../services/cycle/cycle_dates.dart' show dayKey;
import 'calendar_layout.dart';

/// Herkunft eines Kalendereintrags.
enum CalendarEventKind {
  appointment,
  vaccination,
  period,
  periodExpected,
  fertile,
}

/// Ein Eintrag im Kalender: Termin (mit Uhrzeit) oder ganztägig (fällige
/// Impfung, Periode, Vorhersage).
class CalendarEvent {
  const CalendarEvent({
    required this.id,
    required this.kind,
    required this.title,
    required this.start,
    required this.end,
    this.subtitle,
    this.allDay = false,
    this.status,
  });

  /// Termin- bzw. Impfungs-ID; bei Zyklus-Einträgen der erste Tag.
  final String id;
  final CalendarEventKind kind;
  final String title;

  /// Arzt/Ärztin bei Terminen.
  final String? subtitle;

  /// Beginn; bei ganztägigen Einträgen der erste Tag (Mitternacht).
  final DateTime start;

  /// Ende (exklusiv); bei ganztägigen Einträgen der Tag nach dem letzten.
  final DateTime end;
  final bool allDay;
  final AppointmentStatus? status;

  /// Standarddauer, wenn ein Termin keine Dauer hat.
  static const defaultDuration = Duration(minutes: 30);

  /// Erster und letzter Tag (inklusive), den der Eintrag belegt. Termine
  /// erscheinen in Monat und Liste nur an ihrem Starttag.
  DateTime get firstDay => dateOnly(start);
  DateTime get lastDay => allDay ? addDays(dateOnly(end), -1) : firstDay;

  bool coversDay(DateTime day) {
    final d = dateOnly(day);
    return !d.isBefore(firstDay) && !d.isAfter(lastDay);
  }

  /// Dauer in Minuten (mindestens 1).
  int get durationMinutes {
    final m = end.difference(start).inMinutes;
    return m < 1 ? 1 : m;
  }
}

/// Reihenfolge innerhalb eines Tages: ganztägige (längere zuerst), dann nach
/// Uhrzeit.
int compareCalendarEvents(CalendarEvent a, CalendarEvent b) {
  if (a.allDay != b.allDay) return a.allDay ? -1 : 1;
  final byStart = a.start.compareTo(b.start);
  if (byStart != 0) return byStart;
  return b.end.compareTo(a.end);
}

/// Lädt alle Einträge, die den Zeitraum [start, end) berühren, und lädt bei
/// jeder Änderung an Terminen, Ärzten, Impfungen oder Zyklusdaten neu.
Stream<List<CalendarEvent>> watchCalendarEvents(
  AppDatabase db,
  DateTime start,
  DateTime end,
) {
  return db.watchWith({
    db.appointments,
    db.doctors,
    db.vaccinations,
    ...CycleRepository(db).tables,
  }, () => loadCalendarEvents(db, start, end));
}

Future<List<CalendarEvent>> loadCalendarEvents(
  AppDatabase db,
  DateTime start,
  DateTime end, {
  DateTime? now,
}) async {
  final t = AppLocale.strings;
  final events = <CalendarEvent>[];

  // Termine (mit Uhrzeit, Standarddauer 30 min).
  final appointments =
      await (db.selectActive(db.appointments)
            ..where((a) => a.scheduledAt.isBiggerOrEqualValue(start))
            ..where((a) => a.scheduledAt.isSmallerThanValue(end))
            ..orderBy([(a) => OrderingTerm.asc(a.scheduledAt)]))
          .get();
  final doctorIds = appointments.map((a) => a.doctorId).toSet();
  final doctors = doctorIds.isEmpty
      ? const <String, String>{}
      : {
          for (final d in await (db.select(
            db.doctors,
          )..where((d) => d.id.isIn(doctorIds))).get())
            d.id: d.name,
        };
  for (final a in appointments) {
    final doctor = doctors[a.doctorId];
    final title = a.title?.trim();
    events.add(
      CalendarEvent(
        id: a.id,
        kind: CalendarEventKind.appointment,
        title: title == null || title.isEmpty
            ? (doctor ?? t.entityAppointment)
            : title,
        subtitle: title == null || title.isEmpty ? null : doctor,
        start: a.scheduledAt,
        end: a.scheduledAt.add(
          a.durationMin != null && a.durationMin! > 0
              ? Duration(minutes: a.durationMin!)
              : CalendarEvent.defaultDuration,
        ),
        status: a.status,
      ),
    );
  }

  // Fällige Auffrischungen (jüngste Impfung je Impfstoff) als ganztägig.
  final due = await VaccinationRepository(db)
      .due(within: Duration.zero, now: end);
  for (final v in due) {
    final day = dateOnly(v.nextDueAt!);
    if (day.isBefore(dateOnly(start)) || !day.isBefore(end)) continue;
    events.add(
      CalendarEvent(
        id: v.id,
        kind: CalendarEventKind.vaccination,
        title: t.calendarVaccinationDue(v.vaccine),
        start: day,
        end: addDays(day, 1),
        allDay: true,
      ),
    );
  }

  // Zyklus (nur wenn eingeschaltet): erfasste Perioden, erwartete Periode
  // und — falls gewünscht — das grob geschätzte fruchtbare Fenster.
  final settings = await (db.select(
    db.appSettings,
  )..where((s) => s.id.equals(1))).getSingleOrNull();
  if (settings?.cycleTracking ?? false) {
    final overview = await CycleRepository(db).overview(now: now);
    final a = overview.analysis;
    final today = overview.today;
    void addRange(
      CalendarEventKind kind,
      String title,
      DateTime from,
      DateTime to,
    ) {
      if (to.isBefore(from)) return;
      final exclusive = addDays(to, 1);
      if (!exclusive.isAfter(start) || !from.isBefore(end)) return;
      events.add(
        CalendarEvent(
          id: dayKey(from),
          kind: kind,
          title: title,
          start: from,
          end: exclusive,
          allDay: true,
        ),
      );
    }

    for (final p in a.periods) {
      addRange(CalendarEventKind.period, t.calendarPeriod, p.start, p.end);
    }
    final prediction = a.prediction;
    if (prediction != null) {
      final length = a.stats?.averagePeriodLength.round() ?? 5;
      final tomorrow = addDays(today, 1);
      DateTime later(DateTime d) => d.isBefore(tomorrow) ? tomorrow : d;
      addRange(
        CalendarEventKind.periodExpected,
        t.calendarPeriodExpected,
        later(prediction.start),
        addDays(prediction.start, length - 1),
      );
      if (overview.showFertileWindow) {
        addRange(
          CalendarEventKind.fertile,
          t.calendarFertileWindow,
          prediction.fertileFrom.isBefore(today)
              ? today
              : prediction.fertileFrom,
          prediction.fertileTo,
        );
      }
    }
  }

  events.sort(compareCalendarEvents);
  return events;
}
