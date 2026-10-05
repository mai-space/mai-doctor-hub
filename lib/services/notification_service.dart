import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../data/app_database.dart';

/// Lokale Morgen-/Abend-Erinnerungen für den Symptom-Check-in.
class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  void Function(String? payload)? onNotificationTap;

  static const _morningId = 1001;
  static const _eveningId = 1002;
  static const checkInPayload = 'check_in';

  Future<void> initialize() async {
    if (_initialized || kIsWeb) return;

    tz.initializeTimeZones();
    try {
      tz.setLocalLocation(tz.getLocation('Europe/Berlin'));
    } catch (_) {
      // Fallback: System-Lokalzeit der tz-Datenbank.
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwin = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: darwin);

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) {
        onNotificationTap?.call(response.payload);
      },
    );

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.requestNotificationsPermission();

    final iosPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    await iosPlugin?.requestPermissions(alert: true, badge: true, sound: true);

    _initialized = true;
  }

  Future<void> syncFromSettings(AppSetting settings) async {
    if (kIsWeb) return;
    await initialize();
    await _plugin.cancel(id: _morningId);
    await _plugin.cancel(id: _eveningId);

    if (settings.morningReminderEnabled) {
      await _scheduleDaily(
        id: _morningId,
        hour: settings.morningHour,
        minute: settings.morningMinute,
        title: 'Morgen-Check-in',
        body: 'Wie geht es dir heute? Symptome kurz protokollieren.',
      );
    }
    if (settings.eveningReminderEnabled) {
      await _scheduleDaily(
        id: _eveningId,
        hour: settings.eveningHour,
        minute: settings.eveningMinute,
        title: 'Abend-Check-in',
        body: 'Abendliche Symptom-Notizen — dauert nur einen Moment.',
      );
    }
  }

  Future<void> _scheduleDaily({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'check_in',
        'Symptom-Check-in',
        channelDescription: 'Lokale Erinnerungen für Symptom-Check-ins',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: _nextInstanceOf(hour, minute),
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: checkInPayload,
    );
  }

  tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
