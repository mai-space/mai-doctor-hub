import 'dart:io';

import 'package:drift/drift.dart' show OrderingTerm, Value;
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
  test('migrates v1 → current and keeps data', () async {
    final raw = openV1();
    final db = AppDatabase(NativeDatabase.opened(raw));

    final settings = await db.select(db.appSettings).getSingle();
    expect(settings.morningHour, 7);
    expect(settings.calendarSyncEnabled, isFalse);
    expect(settings.calendarIncludeTitle, isFalse);
    expect(settings.appLockEnabled, isFalse);
    expect(settings.onboardingCompleted, isTrue, reason: 'Bestandsnutzer');
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
    expect(version.read<int>('user_version'), db.schemaVersion);

    // v3: Morgen-/Abend-Einstellung wurde zu Erinnerungs-Einträgen.
    final reminders = await (db.select(db.reminders)
          ..orderBy([(t) => OrderingTerm.asc(t.slot)]))
        .get();
    expect(reminders.map((r) => (r.hour, r.minute, r.enabled)), [
      (7, 0, true),
      (20, 0, true),
    ]);
    await db.close();
  });

  test('migrates v11 → v12: symptom descriptions start empty', () async {
    // Echtes v11-Schema (Stand des MCP-Fixtures vor v12).
    final raw = sqlite3.openInMemory();
    final sql = File('test/migrations/v11.sql').readAsStringSync();
    for (final statement in sql.split('---')) {
      final body = statement
          .split('\n')
          .where((l) => !l.startsWith('--'))
          .join('\n')
          .trim();
      if (body.isNotEmpty) raw.execute(body);
    }
    raw
      ..execute('INSERT INTO app_settings (id) VALUES (1)')
      ..execute(
        "INSERT INTO symptoms (id, label, body_region, check_in_cadence, "
        "created_at, updated_at) VALUES ('s1', 'Kopfschmerz', 'Stirn', 0, 0, 0)",
      )
      ..execute(
        'INSERT INTO symptom_observations (id, symptom_id, recorded_at, kind, '
        "value_number) VALUES ('o1', 's1', 1700000000, 0, 6)",
      )
      ..execute('PRAGMA user_version = 11');
    final db = AppDatabase(NativeDatabase.opened(raw));

    final symptom = await db.select(db.symptoms).getSingle();
    expect(symptom.bodyRegion, 'Stirn');
    expect(symptom.sensation, isNull);
    expect(symptom.quality, isNull);
    expect(symptom.side, isNull);
    final observation = await db.select(db.symptomObservations).getSingle();
    expect(observation.valueNumber, 6);
    expect(observation.sensation, isNull);
    expect(observation.pattern, isNull);

    // Neue Spalten sind beschreibbar.
    await (db.update(db.symptomObservations)..where((t) => t.id.equals('o1')))
        .write(const SymptomObservationsCompanion(quality: Value('brennend')));
    expect(
      (await db.select(db.symptomObservations).getSingle()).quality,
      'brennend',
    );
    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.read<int>('user_version'), db.schemaVersion);
    await db.close();
  });

  test('migrates v13 → v14: cycle tables, modes off, no new onboarding', () async {
    // Echtes v13-Schema (Stand des MCP-Fixtures vor v14).
    final raw = sqlite3.openInMemory();
    final sql = File('test/migrations/v13.sql').readAsStringSync();
    for (final statement in sql.split('---')) {
      final body = statement
          .split('\n')
          .where((l) => !l.startsWith('--'))
          .join('\n')
          .trim();
      if (body.isNotEmpty) raw.execute(body);
    }
    raw
      ..execute(
        'INSERT INTO app_settings (id, onboarding_completed, '
        "notification_topics) VALUES (1, 1, '{\"medication\":{}}')",
      )
      ..execute(
        "INSERT INTO doctors (id, name, specialty, created_at, updated_at) "
        "VALUES ('d1', 'Dr. Alt', 'Gynäkologie', 0, 0)",
      )
      ..execute('PRAGMA user_version = 13');
    final db = AppDatabase(NativeDatabase.opened(raw));

    final settings = await db.select(db.appSettings).getSingle();
    expect(settings.onboardingCompleted, isTrue, reason: 'Bestandsnutzerin');
    expect(settings.cycleTracking, isFalse);
    expect(settings.menopauseTracking, isFalse);
    expect(settings.pregnancyTracking, isFalse);
    expect(settings.showFertileWindow, isFalse);
    expect(settings.notificationTopics, '{"medication":{}}');
    expect(await db.select(db.cycleDays).get(), isEmpty);

    // Neue Tabellen sind beschreibbar.
    await db
        .into(db.cycleDays)
        .insert(
          CycleDaysCompanion.insert(
            day: '2026-10-07',
            updatedAt: DateTime(2026, 10, 7),
            flow: const Value(CycleFlow.light),
          ),
        );
    await db
        .into(db.mrsAssessments)
        .insert(
          MrsAssessmentsCompanion.insert(
            id: 'm1',
            recordedAt: DateTime(2026, 10, 7),
            scores: '0,1,2,3,4,0,1,2,3,4,0',
          ),
        );
    await db
        .into(db.pregnancies)
        .insert(
          PregnanciesCompanion.insert(
            id: 'p1',
            createdAt: DateTime(2026, 10, 7),
            lmp: const Value('2026-09-01'),
          ),
        );
    expect((await db.select(db.cycleDays).getSingle()).flow, CycleFlow.light);
    expect(await db.select(db.mrsAssessments).get(), hasLength(1));
    expect((await db.select(db.pregnancies).getSingle()).lmp, '2026-09-01');
    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.read<int>('user_version'), db.schemaVersion);
    await db.close();
  });

  test('fresh database has settings row and two default reminders', () async {
    final db = AppDatabase(NativeDatabase.memory());
    final settings = await db.select(db.appSettings).getSingle();
    expect(settings.eveningHour, 20);
    final reminders = await db.select(db.reminders).get();
    expect(reminders.map((r) => r.hour), unorderedEquals([8, 20]));
    await db.close();
  });
}
