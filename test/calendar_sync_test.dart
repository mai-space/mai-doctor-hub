import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/repositories/appointment_repository.dart';
import 'package:mai_doctor_hub/data/repositories/doctor_repository.dart';
import 'package:mai_doctor_hub/data/repositories/records_repository.dart';
import 'package:mai_doctor_hub/data/repositories/settings_repository.dart';
import 'package:mai_doctor_hub/services/calendar/calendar_gateway.dart';
import 'package:mai_doctor_hub/services/calendar/calendar_sync_service.dart';
import 'package:mai_doctor_hub/services/calendar/ics.dart';

import 'helpers/fake_calendar.dart';

void main() {
  late AppDatabase db;
  late FakeCalendar calendar;
  late CalendarSyncService sync;
  late AppointmentRepository appointments;
  late String doctorId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    calendar = FakeCalendar();
    sync = CalendarSyncService(db, calendar);
    appointments = AppointmentRepository(db);
    doctorId = await DoctorRepository(db).create(
      name: 'Dr. Süd',
      practiceName: 'Praxis am Markt',
      address: 'Marktplatz 1, Freiburg',
    );
  });
  tearDown(() => db.close());

  Future<void> enable({String calendarId = 'g1', bool title = false}) =>
      SettingsRepository(db).updateCalendarExport(
        enabled: true,
        calendarId: calendarId,
        includeTitle: title,
      );

  test('does nothing while disabled', () async {
    await appointments.create(doctorId: doctorId, scheduledAt: DateTime(2030));
    final report = await sync.syncAll();
    expect(report.created, 0);
    expect(calendar.writes, 0);
  });

  test('exports minimal data: no title, diagnoses or notes', () async {
    final diagnosisId = await RecordsRepository(
      db,
    ).createDiagnosis(title: 'Depression');
    await appointments.create(
      doctorId: doctorId,
      scheduledAt: DateTime(2030, 5, 4, 9, 30),
      durationMin: 45,
      title: 'Psychotherapie',
      notes: 'Sehr privat',
      diagnosisIds: [diagnosisId],
    );
    await enable();

    final report = await sync.syncAll();
    expect(report.created, 1);
    final event = calendar.all('g1').single;
    expect(event.title, 'Arzttermin · Dr. Süd');
    expect(event.start, DateTime(2030, 5, 4, 9, 30));
    expect(event.end, DateTime(2030, 5, 4, 10, 15));
    expect(event.location, 'Praxis am Markt, Marktplatz 1, Freiburg');
    final everything = '${event.title} ${event.description} ${event.location}';
    expect(everything, isNot(contains('Psycho')));
    expect(everything, isNot(contains('Depression')));
    expect(everything, isNot(contains('privat')));
  });

  test('title is opt-in', () async {
    await appointments.create(
      doctorId: doctorId,
      scheduledAt: DateTime(2030),
      title: 'Kontrolle',
    );
    await enable(title: true);
    await sync.syncAll();
    expect(calendar.all('g1').single.title, 'Kontrolle · Dr. Süd');
  });

  test('idempotent; updates, cancels and deletes propagate', () async {
    final id = await appointments.create(
      doctorId: doctorId,
      scheduledAt: DateTime(2030, 1, 1, 8),
    );
    final other = await appointments.create(
      doctorId: doctorId,
      scheduledAt: DateTime(2030, 2, 1, 8),
    );
    await enable();
    await sync.syncAll();
    expect(calendar.all('g1'), hasLength(2));

    final again = await sync.syncAll();
    expect(again.unchanged, 2);
    expect(calendar.writes, 2, reason: 'keine unnötigen Schreibzugriffe');

    final summary = (await appointments.summaryFor(id))!;
    await appointments.update(
      id: id,
      doctorId: doctorId,
      scheduledAt: DateTime(2030, 1, 3, 10),
      diagnosisIds: const [],
      symptomIds: const [],
    );
    expect(summary.appointment.scheduledAt, isNot(DateTime(2030, 1, 3, 10)));
    final moved = await sync.syncAll();
    expect(moved.updated, 1);
    expect(
      calendar.all('g1').map((e) => e.start),
      contains(DateTime(2030, 1, 3, 10)),
    );
    expect(calendar.all('g1'), hasLength(2), reason: 'kein Duplikat');

    await appointments.updateStatus(other, AppointmentStatus.cancelled);
    await appointments.delete(id);
    final removed = await sync.syncAll();
    expect(removed.deleted, 2);
    expect(calendar.all('g1'), isEmpty);
    expect(await db.select(db.calendarLinks).get(), isEmpty);
  });

  test('never touches foreign events; recreates externally deleted', () async {
    calendar.events['g1'] = {'foreign': calendar.foreign['x'] = CalendarEventData(
      title: 'Geburtstag',
      start: DateTime(2030),
      end: DateTime(2030),
    )};
    final id = await appointments.create(
      doctorId: doctorId,
      scheduledAt: DateTime(2030, 6, 1),
    );
    await enable();
    await sync.syncAll();
    final link = await (db.select(
      db.calendarLinks,
    )..where((t) => t.appointmentId.equals(id))).getSingle();

    // Nutzer löscht das Event im Google Kalender; Termin wird geändert.
    await calendar.deleteEvent(link.externalEventId!);
    await appointments.update(
      id: id,
      doctorId: doctorId,
      scheduledAt: DateTime(2030, 6, 2),
      diagnosisIds: const [],
      symptomIds: const [],
    );
    await sync.syncAll();

    expect(calendar.events['g1']!.containsKey('foreign'), isTrue);
    expect(calendar.all('g1'), hasLength(2));

    await sync.removeAll();
    expect(calendar.all('g1').single.title, 'Geburtstag');
  });

  test('parallel syncs never create an event twice', () async {
    await enable();
    await appointments.create(doctorId: doctorId, scheduledAt: DateTime(2030));
    await appointments.create(doctorId: doctorId, scheduledAt: DateTime(2031));
    final reports = await Future.wait([sync.syncAll(), sync.syncAll()]);
    expect(calendar.all('g1'), hasLength(2));
    expect(reports.map((r) => r.created).reduce((a, b) => a + b), 2);
  });

  test('asks the account to sync only when something changed', () async {
    await enable();
    await appointments.create(doctorId: doctorId, scheduledAt: DateTime(2030));
    await sync.syncAll();
    expect(calendar.syncRequests, ['g1']);
    await sync.syncAll();
    expect(calendar.syncRequests, ['g1']);
  });

  test('switching calendars moves events', () async {
    await appointments.create(doctorId: doctorId, scheduledAt: DateTime(2030));
    await enable(calendarId: 'g1');
    await sync.syncAll();
    await enable(calendarId: 'g2');
    await sync.syncAll();
    expect(calendar.all('g1'), isEmpty);
    expect(calendar.all('g2'), hasLength(1));
  });

  test('errors are recorded per appointment and retried', () async {
    await appointments.create(
      doctorId: doctorId,
      scheduledAt: DateTime(2030),
      title: 'Kaputt',
    );
    await enable(title: true);
    calendar.failOnTitle = {'Kaputt'};
    final failed = await sync.syncAll();
    expect(failed.failed, 1);
    final link = await db.select(db.calendarLinks).getSingle();
    expect(link.lastError, contains('boom'));

    calendar.failOnTitle = {};
    final retried = await sync.syncAll();
    expect(retried.created, 1);
    expect((await db.select(db.calendarLinks).getSingle()).lastError, isNull);
  });

  test('missing permission throws instead of silently skipping', () async {
    await enable();
    calendar.permission = false;
    expect(sync.syncAll, throwsA(isA<CalendarException>()));
  });

  test('auto sync reacts to appointment changes', () async {
    await enable();
    final auto = CalendarAutoSync(
      db,
      sync,
      debounce: const Duration(milliseconds: 10),
    )..start();
    addTearDown(auto.dispose);
    await appointments.create(doctorId: doctorId, scheduledAt: DateTime(2030));
    await Future<void>.delayed(const Duration(milliseconds: 200));
    expect(calendar.all('g1'), hasLength(1));
  });

  test('events carry the device time zone; a zone change re-syncs', () async {
    var zone = 'Europe/Berlin';
    final zoned = CalendarSyncService(db, calendar, timeZone: () async => zone);
    // Termin über die Zeitumstellung (25.10.2026, 03:00 → 02:00).
    final start = DateTime(2026, 10, 25, 1, 30);
    await appointments.create(
      doctorId: doctorId,
      scheduledAt: start,
      durationMin: 120,
    );
    await enable();

    await zoned.syncAll();
    final event = calendar.all('g1').single;
    expect(event.timeZone, 'Europe/Berlin');
    // Absolute Zeitpunkte: genau 2 h, unabhängig von der Umstellung.
    expect(event.start.millisecondsSinceEpoch, start.millisecondsSinceEpoch);
    expect(event.end.difference(event.start), const Duration(hours: 2));

    expect((await zoned.syncAll()).unchanged, 1);

    zone = 'America/New_York'; // Reise / Zone in den Einstellungen geändert
    final report = await zoned.syncAll();
    expect(report.updated, 1);
    final moved = calendar.all('g1').single;
    expect(moved.timeZone, 'America/New_York');
    expect(moved.start, event.start, reason: 'gleicher Zeitpunkt, nur Anzeige');
    expect(calendar.all('g1'), hasLength(1), reason: 'kein Duplikat');
  });

  test('ICS export escapes and folds', () {
    final ics = Ics.event(
      uid: 'abc',
      now: DateTime.utc(2026, 10, 5, 12),
      event: CalendarEventData(
        title: 'Arzttermin · Dr. Süd; Kontrolle, Blut',
        start: DateTime.utc(2030, 5, 4, 7, 30),
        end: DateTime.utc(2030, 5, 4, 8),
        location: 'Marktplatz 1\nFreiburg',
        description: 'Verwaltet von Mai Doctor Hub ' * 4,
      ),
    );
    expect(ics, startsWith('BEGIN:VCALENDAR\r\n'));
    expect(ics, contains('DTSTART:20300504T073000Z'));
    expect(ics, contains(r'SUMMARY:Arzttermin · Dr. Süd\; Kontrolle\, Blut'));
    expect(ics, contains(r'LOCATION:Marktplatz 1\nFreiburg'));
    for (final line in ics.split('\r\n')) {
      expect(line.length, lessThanOrEqualTo(75));
    }
    expect(ics.trimRight(), endsWith('END:VCALENDAR'));
  });

  test('settings defaults keep export off', () async {
    final settings = await db.select(db.appSettings).getSingle();
    expect(settings.calendarSyncEnabled, isFalse);
    expect(settings.calendarIncludeTitle, isFalse);
    await db
        .update(db.appSettings)
        .write(const AppSettingsCompanion(calendarId: Value('x')));
    expect(await sync.syncAll(), isA<CalendarSyncReport>());
    expect(calendar.writes, 0);
  });
}
