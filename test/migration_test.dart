import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/repositories/records_repository.dart';
import 'package:sqlite3/sqlite3.dart';

/// Baut eine echte v1-Datenbank (Schema aus `test/migrations/v1.sql`).
Database openV1() {
  final raw = sqlite3.openInMemory();
  final sql = File('test/migrations/v1.sql').readAsStringSync();
  for (final statement in sql.split('---')) {
    if (statement.trim().isNotEmpty) raw.execute(statement);
  }
  raw.execute('INSERT INTO app_settings (id, morning_hour) VALUES (1, 7)');
  raw.execute(
    "INSERT INTO doctors VALUES ('d1', 'Dr. Alt', NULL, NULL, NULL, NULL, NULL, 0, 0)",
  );
  raw.execute(
    "INSERT INTO appointments VALUES ('a1', 'd1', 1700000000, NULL, 'Kontrolle', NULL, 0, 0, 0)",
  );
  raw.execute(
    "INSERT INTO records_fts VALUES ('appointment', 'a1', 'Kontrolle', '')",
  );
  raw.execute('PRAGMA user_version = 1');
  return raw;
}

void main() {
  test('migrates v1 → v2 and keeps data', () async {
    final raw = openV1();
    final db = AppDatabase(NativeDatabase.opened(raw));

    final settings = await db.select(db.appSettings).getSingle();
    expect(settings.morningHour, 7);
    expect(settings.calendarSyncEnabled, isFalse);
    expect(settings.calendarIncludeTitle, isFalse);
    expect(settings.appLockEnabled, isFalse);
    expect(settings.calendarId, isNull);

    final appointments = await db.select(db.appointments).get();
    expect(appointments.single.title, 'Kontrolle');

    expect(await db.select(db.calendarLinks).get(), isEmpty);
    await db
        .into(db.calendarLinks)
        .insert(
          CalendarLinksCompanion.insert(appointmentId: 'a1', calendarId: 'c'),
        );

    final hits = await RecordsRepository(db).search('Kontr');
    expect(hits, isNotEmpty);

    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.read<int>('user_version'), 2);
    await db.close();
  });

  test('fresh database has settings row', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final settings = await db.select(db.appSettings).getSingle();
    expect(settings.eveningHour, 20);
    await db.close();
  });
}
