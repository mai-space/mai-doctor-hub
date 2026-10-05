import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/app_database.dart';
import '../../data/repositories/reminder_repository.dart';
import 'notification_plan.dart';

/// Payload für Check-in-Benachrichtigungen; optional mit Symptom-IDs.
abstract final class CheckInPayload {
  static const prefix = 'check_in';

  static String encode(List<String> symptomIds) =>
      symptomIds.isEmpty ? prefix : '$prefix:${symptomIds.join(',')}';

  /// `null`, wenn es kein Check-in-Payload ist; sonst die Symptom-IDs
  /// (leer = alle offenen Symptome).
  static List<String>? decode(String? payload) {
    if (payload == null || !payload.startsWith(prefix)) return null;
    final rest = payload.substring(prefix.length);
    if (rest.isEmpty) return const [];
    return rest.substring(1).split(',').where((s) => s.isNotEmpty).toList();
  }
}

/// Übersetzt Erinnerungs-Einträge in Benachrichtigungen.
abstract final class ReminderPlanner {
  static List<PlannedNotification> plan(List<ReminderWithSymptoms> reminders) {
    final plans = <PlannedNotification>[];
    for (final item in reminders) {
      final r = item.reminder;
      if (!r.enabled) continue;
      final labels = item.symptoms.map((s) => s.label).toList();
      final body =
          r.body?.isNotEmpty == true
              ? r.body!
              : labels.isEmpty
              ? 'Symptome kurz protokollieren.'
              : 'Check-in: ${labels.join(', ')}';
      final payload = CheckInPayload.encode([
        for (final s in item.symptoms) s.id,
      ]);
      // slot * 8: Platz für „täglich“ (0) und sieben Wochentage (1–7).
      final base = NotificationGroup.reminders.base + r.slot * 8;
      if (r.weekdays & Weekdays.all == Weekdays.all) {
        plans.add(
          PlannedNotification.repeating(
            id: base,
            title: r.title,
            body: body,
            payload: payload,
            channel: NotificationChannel.checkIn,
            hour: r.hour,
            minute: r.minute,
          ),
        );
        continue;
      }
      for (final day in Weekdays.days(r.weekdays)) {
        plans.add(
          PlannedNotification.repeating(
            id: base + day,
            title: r.title,
            body: body,
            payload: payload,
            channel: NotificationChannel.checkIn,
            hour: r.hour,
            minute: r.minute,
            weekday: day,
          ),
        );
      }
    }
    return plans;
  }
}

/// Hält die geplanten Check-in-Benachrichtigungen synchron mit der DB.
class ReminderService {
  ReminderService(this._db, this._scheduler);

  final AppDatabase _db;
  final NotificationScheduler _scheduler;
  StreamSubscription<void>? _subscription;

  Future<void> sync() async {
    final reminders = await ReminderRepository(_db).all();
    await _scheduler.replace(
      NotificationGroup.reminders,
      ReminderPlanner.plan(reminders),
    );
  }

  /// Plant bei jeder Änderung an Erinnerungen/Symptomen neu.
  void start() {
    _subscription ??= _db
        .customSelect(
          'SELECT 1',
          readsFrom: {_db.reminders, _db.reminderSymptoms, _db.symptoms},
        )
        .watch()
        .listen((_) {
          sync().catchError((Object e) {
            debugPrint('Erinnerungen planen fehlgeschlagen: $e');
          });
        });
  }

  Future<void> dispose() async => _subscription?.cancel();
}
