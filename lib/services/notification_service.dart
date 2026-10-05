import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'device_time.dart';
import 'notifications/notification_plan.dart';

/// Benachrichtigungs-Berechtigung — austauschbar für Tests.
abstract interface class NotificationPermissions {
  Future<bool> has();
  Future<bool> request();

  /// Standard: das Plugin; Tests setzen eine Attrappe.
  static NotificationPermissions current = NotificationService.instance;
}

/// Lokale Benachrichtigungen (kein Server, kein FCM).
///
/// Plant inexakt (`inexactAllowWhileIdle`) — dafür braucht es keine
/// „Exakte Wecker“-Berechtigung; wenige Minuten Versatz sind unkritisch.
class NotificationService
    implements NotificationScheduler, NotificationPermissions {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  void Function(String? payload)? onNotificationTap;

  String? _timeZone;

  /// Zeitzone, nach der gerade geplant wird.
  String? get timeZone => _timeZone;

  Future<void> initialize() async {
    if (_initialized || kIsWeb) return;

    tz.initializeTimeZones();
    await _applyTimeZone(await DeviceTime.timeZone());

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const settings = InitializationSettings(android: android, iOS: darwin);

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) {
        onNotificationTap?.call(response.payload);
      },
    );
    _initialized = true;
  }

  /// Payload, falls die App per Benachrichtigung gestartet wurde.
  Future<String?> launchPayload() async {
    if (kIsWeb) return null;
    final details = await _plugin.getNotificationAppLaunchDetails();
    return details?.didNotificationLaunchApp == true
        ? details!.notificationResponse?.payload
        : null;
  }

  /// Fragt die Benachrichtigungs-Berechtigung an (Android 13+, iOS).
  Future<bool> requestPermission() async {
    if (kIsWeb) return false;
    await initialize();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    return await ios?.requestPermissions(alert: true, badge: true, sound: true) ??
        false;
  }

  @override
  Future<bool> has() => hasPermission();

  @override
  Future<bool> request() => requestPermission();

  Future<bool> hasPermission() async {
    if (kIsWeb) return false;
    await initialize();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    return await android?.areNotificationsEnabled() ?? true;
  }

  /// Setzt die tz-Datenbank auf die Gerätezone. Erinnerungen sind „08:00
  /// Ortszeit“ — nach Reise/Zonenwechsel müssen sie neu geplant werden.
  Future<void> _applyTimeZone(String zone) async {
    try {
      tz.setLocalLocation(tz.getLocation(zone));
      _timeZone = zone;
    } catch (_) {
      tz.setLocalLocation(tz.getLocation(DeviceTime.fallbackTimeZone));
      _timeZone = DeviceTime.fallbackTimeZone;
    }
  }

  /// `true`, wenn sich die Gerätezone geändert hat (dann neu planen).
  Future<bool> refreshTimeZone() async {
    if (kIsWeb || !_initialized) return false;
    final zone = await DeviceTime.timeZone();
    if (zone == _timeZone) return false;
    await _applyTimeZone(zone);
    return true;
  }

  @override
  Future<void> replace(
    NotificationGroup group,
    List<PlannedNotification> plans,
  ) async {
    if (kIsWeb) return;
    await initialize();
    final pending = await _plugin.pendingNotificationRequests();
    for (final request in pending) {
      if (group.contains(request.id)) await _plugin.cancel(id: request.id);
    }
    for (final plan in plans) {
      assert(group.contains(plan.id), '$plan liegt nicht in $group');
      await _schedule(plan);
    }
  }

  Future<void> _schedule(PlannedNotification plan) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        plan.channel.id,
        plan.channel.label,
        channelDescription: plan.channel.description,
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
      ),
      iOS: const DarwinNotificationDetails(),
    );

    final tz.TZDateTime when;
    final DateTimeComponents? match;
    if (plan.isRepeating) {
      when = nextInstance(
        tz.TZDateTime.now(tz.local),
        plan.hour!,
        plan.minute!,
        weekday: plan.weekday,
      );
      match = plan.weekday == null
          ? DateTimeComponents.time
          : DateTimeComponents.dayOfWeekAndTime;
    } else {
      when = tz.TZDateTime.from(plan.at!, tz.local);
      if (when.isBefore(tz.TZDateTime.now(tz.local))) return;
      match = null;
    }

    await _plugin.zonedSchedule(
      id: plan.id,
      title: plan.title,
      body: plan.body,
      scheduledDate: when,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: match,
      payload: plan.payload,
    );
  }

  /// Nächster Zeitpunkt [hour]:[minute] (optional am [weekday]) ab [now].
  @visibleForTesting
  static tz.TZDateTime nextInstance(
    tz.TZDateTime now,
    int hour,
    int minute, {
    int? weekday,
  }) {
    var scheduled = tz.TZDateTime(
      now.location,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );
    while (scheduled.isBefore(now) ||
        (weekday != null && scheduled.weekday != weekday)) {
      scheduled = tz.TZDateTime(
        now.location,
        scheduled.year,
        scheduled.month,
        scheduled.day + 1,
        hour,
        minute,
      );
    }
    return scheduled;
  }
}
