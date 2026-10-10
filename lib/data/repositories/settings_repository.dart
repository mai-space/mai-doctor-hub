import 'package:drift/drift.dart';

import '../../services/notifications/notification_plan.dart';
import '../app_database.dart';
import '../measure_units.dart';

class SettingsRepository {
  SettingsRepository(this._db);

  final AppDatabase _db;

  Stream<AppSetting> watch() {
    return (_db.select(_db.appSettings)..where((t) => t.id.equals(1)))
        .watchSingle();
  }

  Future<AppSetting> get() {
    return (_db.select(_db.appSettings)..where((t) => t.id.equals(1)))
        .getSingle();
  }

  Future<void> setAppLock(bool enabled) {
    return (_db.update(_db.appSettings)..where((t) => t.id.equals(1))).write(
      AppSettingsCompanion(appLockEnabled: Value(enabled)),
    );
  }

  Future<void> updateCalendarExport({
    required bool enabled,
    String? calendarId,
    required bool includeTitle,
  }) {
    return (_db.update(_db.appSettings)..where((t) => t.id.equals(1))).write(
      AppSettingsCompanion(
        calendarSyncEnabled: Value(enabled),
        calendarId: Value(calendarId),
        calendarIncludeTitle: Value(includeTitle),
      ),
    );
  }

  /// v18: Wochenbeginn im Kalender (`DateTime.weekday`); `null` = Region.
  Future<void> setCalendarFirstWeekday(int? weekday) {
    return (_db.update(_db.appSettings)..where((t) => t.id.equals(1))).write(
      AppSettingsCompanion(calendarFirstWeekday: Value(weekday)),
    );
  }

  Future<void> completeOnboarding() {
    return (_db.update(_db.appSettings)..where((t) => t.id.equals(1))).write(
      const AppSettingsCompanion(onboardingCompleted: Value(true)),
    );
  }

  Future<void> setNotificationPreferences(NotificationPreferences preferences) {
    return (_db.update(_db.appSettings)..where((t) => t.id.equals(1))).write(
      AppSettingsCompanion(notificationTopics: Value(preferences.encode())),
    );
  }

  /// v15: Einheiten speichern und sofort überall anwenden ([AppUnits]).
  Future<void> setUnits(UnitPreferences units) async {
    await (_db.update(_db.appSettings)..where((t) => t.id.equals(1))).write(
      AppSettingsCompanion(
        temperatureUnit: Value(units.temperature.name),
        glucoseUnit: Value(units.glucose.name),
        weightUnit: Value(units.weight.name),
      ),
    );
    AppUnits.update(units);
  }

  Future<void> updateAppointmentReminders({
    required bool enabled,
    required List<int> leadMinutes,
  }) {
    final leads = leadMinutes.toSet().toList()..sort((a, b) => b - a);
    return (_db.update(_db.appSettings)..where((t) => t.id.equals(1))).write(
      AppSettingsCompanion(
        appointmentRemindersEnabled: Value(enabled),
        appointmentReminderLeads: Value(leads.join(',')),
      ),
    );
  }
}

/// Vorlaufzeiten aus der Einstellung (Minuten, absteigend).
List<int> parseLeadMinutes(String raw) =>
    raw
        .split(',')
        .map((s) => int.tryParse(s.trim()))
        .whereType<int>()
        .where((m) => m > 0)
        .toSet()
        .toList()
      ..sort((a, b) => b - a);
