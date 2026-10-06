import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../../data/app_database.dart';
import '../../data/repositories/appointment_repository.dart';
import '../../l10n/l10n.dart';
import '../device_time.dart';
import 'calendar_gateway.dart';

/// Ergebnis eines Abgleichs (für UI und Tests).
class CalendarSyncReport {
  const CalendarSyncReport({
    this.created = 0,
    this.updated = 0,
    this.deleted = 0,
    this.unchanged = 0,
    this.failed = 0,
  });

  final int created;
  final int updated;
  final int deleted;
  final int unchanged;
  final int failed;

  @override
  String toString() =>
      'neu $created, geändert $updated, entfernt $deleted, '
      'unverändert $unchanged, Fehler $failed';
}

/// Überträgt Termine **einseitig** in einen Kalender.
///
/// Die App ist Quelle der Wahrheit: Es werden nur Events angefasst, deren ID
/// in `calendar_links` steht. Fremde Events werden nie gelesen. Änderungen im
/// Kalender werden beim nächsten Abgleich überschrieben; extern gelöschte
/// Events legt der Gateway neu an.
class CalendarSyncService {
  CalendarSyncService(
    this._db,
    this._gateway, {
    Future<String> Function()? timeZone,
  }) : _timeZone = timeZone ?? DeviceTime.timeZone;

  final AppDatabase _db;
  final CalendarGateway _gateway;

  /// Gerätezone; Teil des Hashes → nach einem Zonenwechsel werden alle
  /// Events mit der neuen Zone aktualisiert.
  final Future<String> Function() _timeZone;

  static const defaultDuration = Duration(minutes: 30);
  /// In der App-Sprache; Teil des Hashes → ein Sprachwechsel aktualisiert
  /// beim nächsten Abgleich alle exportierten Events.
  static String get managedBy => AppLocale.strings.svcCalendarManagedBy;

  /// Datensparsamer Event-Inhalt: nie Diagnosen, Symptome, Notizen, Berichte.
  static CalendarEventData eventFor(
    AppointmentSummary summary, {
    required bool includeTitle,
    String? timeZone,
  }) {
    final a = summary.appointment;
    final doctor = summary.doctor;
    final who = summary.doctorName;
    final title = includeTitle && a.title?.isNotEmpty == true
        ? '${a.title} · $who'
        : AppLocale.strings.svcCalendarEventTitle(who);
    final location = [
      doctor?.practiceName,
      doctor?.address,
    ].whereType<String>().where((s) => s.isNotEmpty).join(', ');
    return CalendarEventData(
      title: title,
      start: a.scheduledAt,
      end: a.scheduledAt.add(
        a.durationMin == null
            ? defaultDuration
            : Duration(minutes: a.durationMin!),
      ),
      location: location.isEmpty ? null : location,
      description: managedBy,
      timeZone: timeZone,
    );
  }

  static String hashOf(String calendarId, CalendarEventData event) => sha256
      .convert(utf8.encode(jsonEncode({'c': calendarId, ...event.toJson()})))
      .toString();

  Future<void>? _inFlight;

  /// Läuft nie parallel (manueller Abgleich + Auto-Sync würden sonst
  /// dasselbe Event doppelt anlegen).
  Future<CalendarSyncReport> syncAll() async {
    while (_inFlight != null) {
      await _inFlight;
    }
    final run = _syncAll();
    _inFlight = run.then<void>((_) {}, onError: (_) {});
    try {
      return await run;
    } finally {
      _inFlight = null;
    }
  }

  Future<CalendarSyncReport> _syncAll() async {
    final settings = await _db.select(_db.appSettings).getSingle();
    final calendarId = settings.calendarId;
    if (!settings.calendarSyncEnabled || calendarId == null) {
      return const CalendarSyncReport();
    }
    if (!await _gateway.hasPermission()) {
      throw CalendarException(AppLocale.strings.svcCalendarNoPermission);
    }

    // Abgesagte Termine gehören nicht (mehr) in den Kalender.
    final appointments =
        await (_db.selectActive(_db.appointments)..where(
              (t) => t.status.equalsValue(AppointmentStatus.cancelled).not(),
            ))
            .get();
    final summaries = await AppointmentRepository(
      _db,
    ).summariesFor(appointments);
    final links = {
      for (final l in await _db.select(_db.calendarLinks).get())
        l.appointmentId: l,
    };
    final timeZone = await _timeZone();

    var created = 0, updated = 0, deleted = 0, unchanged = 0, failed = 0;

    for (final summary in summaries) {
      final id = summary.appointment.id;
      final link = links.remove(id);
      final event = eventFor(
        summary,
        includeTitle: settings.calendarIncludeTitle,
        timeZone: timeZone,
      );
      final hash = hashOf(calendarId, event);
      if (link != null &&
          link.externalEventId != null &&
          link.payloadHash == hash &&
          link.lastError == null) {
        unchanged++;
        continue;
      }
      try {
        String? eventId = link?.externalEventId;
        if (link != null && link.calendarId != calendarId && eventId != null) {
          // Kalender gewechselt: im alten löschen, im neuen anlegen.
          await _safeDelete(eventId);
          eventId = null;
        }
        final newId = await _gateway.upsertEvent(
          calendarId,
          event,
          eventId: eventId,
        );
        await _db
            .into(_db.calendarLinks)
            .insertOnConflictUpdate(
              CalendarLinksCompanion.insert(
                appointmentId: id,
                calendarId: calendarId,
                externalEventId: Value(newId),
                payloadHash: Value(hash),
                syncedAt: Value(DateTime.now()),
                lastError: const Value(null),
              ),
            );
        eventId == null ? created++ : updated++;
      } catch (e) {
        failed++;
        await _db
            .into(_db.calendarLinks)
            .insertOnConflictUpdate(
              CalendarLinksCompanion.insert(
                appointmentId: id,
                calendarId: link?.calendarId ?? calendarId,
                externalEventId: Value(link?.externalEventId),
                payloadHash: Value(link?.payloadHash),
                syncedAt: Value(link?.syncedAt),
                lastError: Value('$e'),
              ),
            );
      }
    }

    // Übrig: Termin gelöscht oder abgesagt → Event entfernen.
    for (final link in links.values) {
      try {
        if (link.externalEventId != null) {
          await _gateway.deleteEvent(link.externalEventId!);
        }
        await _deleteLink(link.appointmentId);
        deleted++;
      } catch (e) {
        failed++;
        await (_db.update(_db.calendarLinks)
              ..where((t) => t.appointmentId.equals(link.appointmentId)))
            .write(CalendarLinksCompanion(lastError: Value('$e')));
      }
    }

    if (created + updated + deleted > 0) {
      try {
        await _gateway.requestSync(calendarId);
      } catch (e) {
        debugPrint('Konto-Sync nicht angestoßen: $e');
      }
    }

    return CalendarSyncReport(
      created: created,
      updated: updated,
      deleted: deleted,
      unchanged: unchanged,
      failed: failed,
    );
  }

  /// Entfernt alle exportierten Events und Verknüpfungen.
  Future<int> removeAll() async {
    var removed = 0;
    for (final link in await _db.select(_db.calendarLinks).get()) {
      if (link.externalEventId != null) {
        await _safeDelete(link.externalEventId!);
        removed++;
      }
      await _deleteLink(link.appointmentId);
    }
    return removed;
  }

  Future<void> _safeDelete(String eventId) async {
    try {
      await _gateway.deleteEvent(eventId);
    } catch (e) {
      debugPrint('Event $eventId nicht gelöscht: $e');
    }
  }

  Future<void> _deleteLink(String appointmentId) => (_db.delete(
    _db.calendarLinks,
  )..where((t) => t.appointmentId.equals(appointmentId))).go();
}

/// Startet den Abgleich automatisch, wenn sich Termine/Ärzte ändern.
class CalendarAutoSync {
  CalendarAutoSync(
    this._db,
    this._service, {
    this.debounce = const Duration(seconds: 2),
  });

  final AppDatabase _db;
  final CalendarSyncService _service;
  final Duration debounce;

  StreamSubscription<void>? _subscription;

  /// Abgleich anstoßen, z. B. wenn die App in den Vordergrund kommt
  /// (Zeitzone/Uhrzeit können sich geändert haben). Dank Hash billig.
  void trigger() => _schedule();
  Timer? _timer;
  bool _running = false;
  bool _again = false;

  void start() {
    _subscription ??= _db
        .watchTables({_db.appointments, _db.doctors, _db.appSettings})
        .listen((_) => _schedule());
  }

  void _schedule() {
    _timer?.cancel();
    _timer = Timer(debounce, _run);
  }

  Future<void> _run() async {
    if (_running) {
      _again = true;
      return;
    }
    _running = true;
    try {
      final report = await _service.syncAll();
      debugPrint('Kalender-Abgleich: $report');
    } catch (e) {
      debugPrint('Kalender-Abgleich fehlgeschlagen: $e');
    } finally {
      _running = false;
      if (_again) {
        _again = false;
        _schedule();
      }
    }
  }

  Future<void> dispose() async {
    _timer?.cancel();
    await _subscription?.cancel();
  }
}
