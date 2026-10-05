import 'package:drift/drift.dart';

import '../app_database.dart';

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
}
