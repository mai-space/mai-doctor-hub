import 'dart:io';
import 'dart:typed_data';

import 'package:mai_backup_format/mai_backup_format.dart';
import 'package:mai_mcp/mai_mcp.dart' show supportedSchemaVersion;
import 'package:sqlite3/sqlite3.dart';

int s(DateTime dt) => dt.millisecondsSinceEpoch ~/ 1000;

/// Legt eine Akte mit dem aktuellen App-Schema an (siehe schema_contract_test
/// in der App) und füllt sie mit Beispieldaten.
String buildFixtureDb(Directory dir, {int userVersion = supportedSchemaVersion}) {
  final path = '${dir.path}/akte.sqlite';
  final db = sqlite3.open(path);
  final schema = File('test/fixtures/schema.sql').readAsStringSync();
  for (final statement in schema.split('---')) {
    final sql = statement
        .split('\n')
        .where((l) => !l.startsWith('--'))
        .join('\n')
        .trim();
    if (sql.isNotEmpty) db.execute(sql);
  }
  final now = DateTime.now();
  final past = now.subtract(const Duration(days: 20));
  final future = now.add(const Duration(days: 10));
  db
    ..execute('INSERT INTO app_settings (id) VALUES (1)')
    ..execute(
      "INSERT INTO doctors (id, name, specialty, practice_name, address, "
      "created_at, updated_at) VALUES ('doc1', 'Dr. Weiß', 'HNO', "
      "'Praxis am See', 'Seestr. 1', 0, 0)",
    )
    ..execute(
      "INSERT INTO diagnoses (id, title, notes, status, created_at, updated_at) "
      "VALUES ('dia1', 'Sinusitis', 'chronisch', 0, 0, 0)",
    )
    ..execute(
      "INSERT INTO symptoms (id, label, diagnosis_id, body_region, "
      "check_in_cadence, created_at, updated_at) VALUES "
      "('sym1', 'Kopfschmerz', 'dia1', 'Stirn', 0, 0, 0)",
    )
    ..execute(
      'INSERT INTO appointments (id, doctor_id, scheduled_at, duration_min, '
      'title, notes, status, created_at, updated_at) VALUES '
      "('apt1', 'doc1', ${s(past)}, 30, 'Kontrolle', 'Nüchtern', 1, 0, 0), "
      "('apt2', 'doc1', ${s(future)}, NULL, 'Nachsorge', NULL, 0, 0, 0)",
    )
    ..execute(
      "INSERT INTO appointment_diagnoses VALUES ('apt1', 'dia1')",
    )
    ..execute("INSERT INTO appointment_symptoms VALUES ('apt1', 'sym1')")
    ..execute(
      'INSERT INTO reports (id, appointment_id, title, mime_type, local_path, '
      'extracted_text, page_count, source, created_at) VALUES '
      "('rep1', 'apt1', 'CT Nasennebenhöhlen', 'application/pdf', '/x', "
      "'Befund: Schleimhautschwellung beidseits. ${'Lorem ' * 50}', 2, 0, "
      '${s(past)})',
    )
    ..execute(
      'INSERT INTO medications (id, name, dosage, diagnosis_id, ended_at, '
      'created_at, form, dose_amount, dose_unit, prescriber_id) VALUES '
      "('med1', 'Nasenspray', '2x täglich', 'dia1', NULL, 0, 4, 1, "
      "'Sprühstoß', 'doc1'),"
      " ('med2', 'Antibiotikum', '1-0-1', NULL, ${s(past)}, 0, NULL, NULL, "
      'NULL, NULL)',
    )
    ..execute(
      'INSERT INTO notes (id, body, related_diagnosis_id, created_at, '
      "updated_at) VALUES ('not1', 'Frage: OP sinnvoll?', 'dia1', 0, 0)",
    );
  db.execute(
    'INSERT INTO vaccinations (id, vaccine, administered_at, next_due_at, '
    "batch, created_at, updated_at) VALUES ('vac1', 'Tetanus', "
    "${s(DateTime(2014))}, ${s(DateTime(2024))}, 'X1', 0, 0)",
  );
  for (final (i, v) in [7, 5, 3].indexed) {
    db.execute(
      'INSERT INTO symptom_observations (id, symptom_id, recorded_at, kind, '
      "value_number) VALUES ('obs$i', 'sym1', "
      '${s(past.add(Duration(days: i)))}, 0, $v)',
    );
  }
  // v12: strukturierte Beschreibung am Symptom und am letzten Check-in.
  db
    ..execute(
      "UPDATE symptoms SET sensation = 'Schmerz', quality = 'drückend', "
      "side = 'both' WHERE id = 'sym1'",
    )
    ..execute(
      "UPDATE symptom_observations SET sensation = 'Schmerz', "
      "quality = 'pochend, stechend', location = 'Schläfe', side = 'left', "
      "pattern = 'anfallsartig' WHERE id = 'obs2'",
    );
  for (final (type, id, title, body) in [
    ('doctor', 'doc1', 'Dr. Weiß', 'HNO Praxis am See'),
    ('diagnosis', 'dia1', 'Sinusitis', 'chronisch'),
    ('appointment', 'apt1', 'Kontrolle', 'Nüchtern'),
    ('report', 'rep1', 'CT Nasennebenhöhlen', 'Schleimhautschwellung beidseits'),
    ('note', 'not1', 'Frage: OP sinnvoll?', 'Frage: OP sinnvoll?'),
  ]) {
    db.execute('INSERT INTO records_fts VALUES (?, ?, ?, ?)', [
      type,
      id,
      title,
      body,
    ]);
  }
  db
    ..userVersion = userVersion
    ..close();
  return path;
}

Future<Uint8List> buildFixtureBackup(String dbPath, String passphrase) =>
    BackupCrypto.encrypt(
      BackupArchive.build(
        database: File(dbPath).readAsBytesSync(),
        manifest: {
          'format': 1,
          'schemaVersion': 2,
          'createdAt': DateTime.utc(2026, 10, 5).toIso8601String(),
          'reports': <String, String>{},
        },
      ),
      passphrase,
      iterations: 1000,
    );
