import 'dart:async';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../../data/app_database.dart';
import '../../data/repositories/settings_repository.dart';
import 'notification_plan.dart';

/// Hält eine Benachrichtigungs-Gruppe synchron mit der Datenbank: bei jeder
/// Änderung an [tables] wird neu geplant (ganze Gruppe ersetzen).
class PlanSync {
  PlanSync({
    required this.db,
    required this.scheduler,
    required this.group,
    required this.tables,
    required this.plan,
    this.debounce = const Duration(milliseconds: 300),
  });

  final AppDatabase db;
  final NotificationScheduler scheduler;
  final NotificationGroup group;
  final Set<ResultSetImplementation<dynamic, dynamic>> tables;
  final Future<List<PlannedNotification>> Function() plan;
  final Duration debounce;

  StreamSubscription<void>? _subscription;
  Timer? _timer;
  Future<void>? _running;

  Future<void> sync() async {
    // Nie zwei Planungen parallel (cancel/schedule würden sich mischen).
    while (_running != null) {
      await _running;
    }
    final run = () async {
      final settings = await SettingsRepository(db).get();
      final preferences = NotificationPreferences.parse(
        settings.notificationTopics,
      );
      await scheduler.replace(group, preferences.apply(await plan()));
    }();
    _running = run;
    try {
      await run;
    } finally {
      _running = null;
    }
  }

  void start() {
    // App-Settings: Themen-Einstellungen (an/aus, Stufe, diskret).
    _subscription ??= db.watchTables({...tables, db.appSettings}).listen((_) {
          _timer?.cancel();
          _timer = Timer(debounce, () {
            sync().catchError((Object e) {
              debugPrint('Planung ${group.name} fehlgeschlagen: $e');
            });
          });
        });
  }

  Future<void> dispose() async {
    _timer?.cancel();
    await _subscription?.cancel();
  }
}
