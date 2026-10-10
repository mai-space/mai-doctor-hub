import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'device_platform.dart';
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
    if (android == null) {
      final ios = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      if (ios != null) {
        final options = await ios.checkPermissions();
        return options?.isEnabled ?? false;
      }
    }
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
    if (DevicePlatform.isIOS) {
      // Nacheinander: sonst überschneiden sich die Budget-Berechnungen.
      final next = _iosQueue.then((_) => _replaceWithinBudget(group, plans));
      _iosQueue = next.catchError((Object _) {});
      return next;
    }
    final pending = await _plugin.pendingNotificationRequests();
    for (final request in pending) {
      if (group.contains(request.id)) await _plugin.cancel(id: request.id);
    }
    for (final plan in plans) {
      assert(group.contains(plan.id), '$plan liegt nicht in $group');
      await _schedule(plan);
    }
  }

  /// iOS behält nur 64 ausstehende Benachrichtigungen je App und verwirft den
  /// Rest stillschweigend. Etwas Reserve darunter.
  static const iosPendingLimit = 60;

  final Map<NotificationGroup, List<PlannedNotification>> _iosPlans = {};
  Set<int> _iosScheduled = {};
  Future<void> _iosQueue = Future.value();

  /// iOS: plant über alle Gruppen nur die [iosPendingLimit] nächsten
  /// Benachrichtigungen. Der Rest folgt bei einem späteren Abgleich (beim
  /// Öffnen der App planen alle Quellen neu).
  Future<void> _replaceWithinBudget(
    NotificationGroup group,
    List<PlannedNotification> plans,
  ) async {
    _iosPlans[group] = plans;
    final all = [for (final list in _iosPlans.values) ...list];
    final allowed = withinBudget(all, tz.TZDateTime.now(tz.local));
    final pending = await _plugin.pendingNotificationRequests();
    for (final request in pending) {
      final id = request.id;
      // Gruppen, die noch nicht abgeglichen haben, bleiben unangetastet.
      if (!_iosPlans.keys.any((g) => g.contains(id))) continue;
      if (group.contains(id) || !allowed.contains(id)) {
        await _plugin.cancel(id: id);
      }
    }
    for (final plan in all) {
      if (!allowed.contains(plan.id)) continue;
      // Eigene Gruppe neu; andere nur, wenn sie bisher nicht geplant waren.
      if (group.contains(plan.id) || !_iosScheduled.contains(plan.id)) {
        await _schedule(plan);
      }
    }
    _iosScheduled = allowed;
  }

  /// IDs der [limit] nächsten Benachrichtigungen; wiederkehrende zählen bei
  /// iOS als eine einzige ausstehende Anfrage.
  @visibleForTesting
  static Set<int> withinBudget(
    Iterable<PlannedNotification> plans,
    tz.TZDateTime now, {
    int limit = iosPendingLimit,
  }) {
    final upcoming = <(tz.TZDateTime, int)>[];
    for (final plan in plans) {
      if (plan.isRepeating) {
        upcoming.add((
          nextInstance(now, plan.hour!, plan.minute!, weekday: plan.weekday),
          plan.id,
        ));
      } else {
        final at = tz.TZDateTime.from(plan.at!, now.location);
        if (!at.isBefore(now)) upcoming.add((at, plan.id));
      }
    }
    upcoming.sort((a, b) {
      final byTime = a.$1.compareTo(b.$1);
      return byTime != 0 ? byTime : a.$2.compareTo(b.$2);
    });
    return {for (final (_, id) in upcoming.take(limit)) id};
  }

  static Importance _importance(NotificationLevel level) => switch (level) {
    NotificationLevel.important => Importance.high,
    NotificationLevel.normal => Importance.defaultImportance,
    NotificationLevel.silent => Importance.low,
  };

  static Priority _priority(NotificationLevel level) => switch (level) {
    NotificationLevel.important => Priority.high,
    NotificationLevel.normal => Priority.defaultPriority,
    NotificationLevel.silent => Priority.low,
  };

  /// Legt je Thema den Kanal der gewählten Stufe an (Namen in App-Sprache)
  /// und entfernt die übrigen — so zeigt Android genau einen Kanal je Thema.
  Future<void> applyChannels(NotificationPreferences preferences) async {
    if (kIsWeb) return;
    await initialize();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) return;
    for (final id in NotificationTopic.legacyChannelIds) {
      await android.deleteNotificationChannel(channelId: id);
    }
    for (final topic in NotificationTopic.values) {
      final level = preferences.of(topic).level;
      await android.createNotificationChannel(
        AndroidNotificationChannel(
          topic.channelId(level),
          topic.label,
          description: topic.description,
          importance: _importance(level),
          playSound: level != NotificationLevel.silent,
          enableVibration: level != NotificationLevel.silent,
        ),
      );
      for (final other in NotificationLevel.values) {
        if (other == level) continue;
        await android.deleteNotificationChannel(
          channelId: topic.channelId(other),
        );
      }
    }
  }

  Future<void> _schedule(PlannedNotification plan) async {
    final level = plan.effectiveLevel;
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        plan.topic.channelId(level),
        plan.topic.label,
        channelDescription: plan.topic.description,
        importance: _importance(level),
        priority: _priority(level),
        playSound: level != NotificationLevel.silent,
        enableVibration: level != NotificationLevel.silent,
        category: plan.topic == NotificationTopic.medication
            ? AndroidNotificationCategory.reminder
            : AndroidNotificationCategory.event,
        // Mit Gesundheitsdaten (Medikament, Arzt, Symptom) nie auf dem
        // gesperrten Bildschirm — „private“ allein greift nur, wenn Android
        // sensible Inhalte ausblendet. Diskrete Texte dürfen dort stehen.
        visibility: plan.discreet
            ? NotificationVisibility.public
            : NotificationVisibility.secret,
      ),
      iOS: DarwinNotificationDetails(
        interruptionLevel: switch (level) {
          NotificationLevel.important => InterruptionLevel.timeSensitive,
          NotificationLevel.normal => InterruptionLevel.active,
          NotificationLevel.silent => InterruptionLevel.passive,
        },
        presentSound: level != NotificationLevel.silent,
      ),
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
