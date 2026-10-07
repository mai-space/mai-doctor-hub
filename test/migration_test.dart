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

  test('migrates v14 → v15: measures, journal, units, psych table', () async {
    // Echtes v14-Schema (Stand des MCP-Fixtures vor v15).
    final raw = sqlite3.openInMemory();
    final sql = File('test/migrations/v14.sql').readAsStringSync();
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
        'INSERT INTO app_settings (id, onboarding_completed, cycle_tracking) '
        'VALUES (1, 1, 1)',
      )
      ..execute(
        'INSERT INTO symptoms (id, label, body_region, check_in_cadence, '
        "created_at, updated_at, sensation) VALUES ('s1', 'Kopfschmerz', "
        "'Stirn', 0, 0, 0, 'Schmerz')",
      )
      ..execute(
        'INSERT INTO symptom_observations (id, symptom_id, recorded_at, kind, '
        "value_number, note) VALUES ('o1', 's1', 1700000000, 0, 6, 'alt')",
      )
      ..execute('PRAGMA user_version = 14');
    final db = AppDatabase(NativeDatabase.opened(raw));

    final settings = await db.select(db.appSettings).getSingle();
    expect(settings.cycleTracking, isTrue);
    expect(settings.temperatureUnit, isNull, reason: 'Standard nach Region');
    expect(settings.glucoseUnit, isNull);
    expect(settings.weightUnit, isNull);
    expect(settings.psychQuestionnaires, isFalse);

    // Alte Symptome und Check-ins bleiben Stärke 0–10.
    final symptom = await db.select(db.symptoms).getSingle();
    expect(symptom.measure, isNull);
    expect(symptom.measure2, isNull);
    final old = await db.select(db.symptomObservations).getSingle();
    expect(old.kind, ObservationKind.scale_1_10);
    expect(old.valueNumber, 6);
    expect(old.note, 'alt');
    expect(old.measure, isNull);
    expect(old.journal, isNull);

    // Neue Spalten und Tabelle sind beschreibbar.
    await db
        .into(db.symptomObservations)
        .insert(
          SymptomObservationsCompanion.insert(
            id: 'o2',
            symptomId: 's1',
            recordedAt: DateTime(2026, 10, 7),
            kind: ObservationKind.measurement,
            valueNumber: const Value(38.4),
            measure: const Value('temperature'),
            measure2: const Value('pulse'),
            secondaryValue: const Value(96),
            valueNumber2: const Value(null),
            energy: const Value(4),
            sleepHours: const Value(6.5),
            anxiety: const Value(2),
            journal: const Value('Tagebuch'),
          ),
        );
    final o2 = await (db.select(
      db.symptomObservations,
    )..where((t) => t.id.equals('o2'))).getSingle();
    expect(o2.kind, ObservationKind.measurement);
    expect((o2.measure, o2.secondaryValue, o2.journal), (
      'temperature',
      96.0,
      'Tagebuch',
    ));
    await (db.update(db.symptoms)..where((t) => t.id.equals('s1'))).write(
      const SymptomsCompanion(measure: Value('temperature')),
    );
    await db
        .into(db.psychAssessments)
        .insert(
          PsychAssessmentsCompanion.insert(
            id: 'p1',
            recordedAt: DateTime(2026, 10, 7),
            instrument: 'phq9',
            scores: '0,1,2,3,0,1,2,3,0',
          ),
        );
    expect(await db.select(db.psychAssessments).get(), hasLength(1));
    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.read<int>('user_version'), db.schemaVersion);
    expect(db.schemaVersion, 16);
    await db.close();
  });

  test('migrates v15 → v16: journal entries backfilled into search', () async {
    // Echtes v15-Schema (Stand des MCP-Fixtures vor v16).
    final raw = sqlite3.openInMemory();
    final sql = File('test/migrations/v15.sql').readAsStringSync();
    for (final statement in sql.split('---')) {
      final body = statement
          .split('\n')
          .where((l) => !l.startsWith('--'))
          .join('\n')
          .trim();
      if (body.isNotEmpty) raw.execute(body);
    }
    final at = DateTime(2026, 9, 14, 21).millisecondsSinceEpoch ~/ 1000;
    raw
      ..execute(
        'INSERT INTO app_settings (id, onboarding_completed) VALUES (1, 1)',
      )
      ..execute(
        'INSERT INTO symptoms (id, label, check_in_cadence, created_at, '
        "updated_at, archived_at) VALUES ('s1', 'Stimmung', 0, 0, 0, NULL), "
        "('s2', 'Alt', 0, 0, 0, 5)",
      )
      ..execute(
        'INSERT INTO symptom_observations (id, symptom_id, recorded_at, kind, '
        'value_number, measure, journal) VALUES '
        "('o1', 's1', $at, 4, -2, 'mood', 'Spaziergang am Fluss'), "
        "('o2', 's1', $at, 4, 1, 'mood', '   '), "
        "('o3', 's1', $at, 4, 0, 'mood', NULL), "
        "('o4', 's2', $at, 0, 5, NULL, 'Fluss archiviert')",
      )
      ..execute(
        "INSERT INTO records_fts VALUES ('symptom', 's1', 'Stimmung', '')",
      )
      ..execute('PRAGMA user_version = 15');
    final db = AppDatabase(NativeDatabase.opened(raw));

    final rows = await db
        .customSelect(
          "SELECT entity_id, title, body FROM records_fts "
          "WHERE entity_type = 'journal' ORDER BY entity_id",
        )
        .get();
    expect([for (final r in rows) r.read<String>('entity_id')], ['o1', 'o4']);
    expect(rows.first.read<String>('body'), 'Spaziergang am Fluss');
    expect(rows.first.read<String>('title'), startsWith('Stimmung · '));
    // Gefunden wird nur der Eintrag des nicht archivierten Symptoms.
    final hits = await RecordsRepository(db).search('Fluss');
    expect([for (final h in hits) h.read<String>('entity_id')], ['o1']);
    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.read<int>('user_version'), 16);
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
