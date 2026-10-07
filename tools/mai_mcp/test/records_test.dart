import 'dart:io';

import 'package:mai_mcp/mai_mcp.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:test/test.dart';

import 'fixture.dart';

void main() {
  late Directory dir;
  late MaiSnapshot snapshot;
  late MaiRecords records;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('mai_records');
    snapshot = MaiSnapshot.openSqlite(buildFixtureDb(dir));
    records = MaiRecords(snapshot.db);
  });
  tearDown(() async {
    await snapshot.close();
    dir.deleteSync(recursive: true);
  });

  test('search finds report text with snippet and type filter', () {
    final hits = records.searchRecords('Schleimhaut');
    expect(hits.single['type'], 'report');
    expect(hits.single['snippet'], contains('[Schleimhautschwellung]'));
    expect(records.searchRecords('Sinus', types: ['note']), isEmpty);
    expect(records.searchRecords('  '), isEmpty);
    expect(records.searchRecords('"; DROP TABLE'), isEmpty);
  });

  test('appointments filter by status, doctor and range', () {
    expect(records.listAppointments(), hasLength(2));
    final done = records.listAppointments(status: 'erledigt').single;
    expect(done['title'], 'Kontrolle');
    expect(done['diagnoses'], 'Sinusitis');
    expect(done['report_count'], 1);
    expect(records.listAppointments(doctor: 'hno'), hasLength(2));
    expect(records.listAppointments(doctor: 'Kardio'), isEmpty);
    expect(
      records.listAppointments(from: DateTime.now()).single['title'],
      'Nachsorge',
    );
  });

  test('appointment details include links and reports', () {
    final a = records.getAppointment('apt1')!;
    expect((a['doctor'] as Map)['practice'], 'Praxis am See');
    expect(a['symptoms'], [
      {'id': 'sym1', 'label': 'Kopfschmerz'},
    ]);
    expect((a['reports'] as List).single['has_text'], isTrue);
    expect(records.getAppointment('nope'), isNull);
  });

  test('report text is truncated to max_chars', () {
    final r = records.getReportText('rep1', maxChars: 200)!;
    expect(r['text'] as String, startsWith('Befund: Schleimhaut'));
    expect(r['text'] as String, contains('[gekürzt,'));
    expect(
      (records.getReportText('rep1')!['text'] as String),
      isNot(contains('gekürzt')),
    );
  });

  test('symptom timeline by label with stats', () {
    final t = records.symptomTimeline('kopf')!;
    expect(t['id'], 'sym1');
    expect(t['stats'], {
      'count': 3,
      'min': 3.0,
      'max': 7.0,
      'avg': 5.0,
      'last': 3.0,
    });
    expect(t['observations'], hasLength(3));
    expect(t['default_description'], {
      'sensation': 'Schmerz',
      'quality': 'drückend',
      'location': 'Stirn',
      'side': 'both',
    });
    final observations = t['observations'] as List;
    expect((observations.first as Map)['description'], isNull);
    expect((observations.last as Map)['description'], {
      'sensation': 'Schmerz',
      'quality': 'pochend, stechend',
      'location': 'Schläfe',
      'side': 'left',
      'pattern': 'anfallsartig',
    });
    expect(records.symptomTimeline('Bauch'), isNull);
  });

  test('v15 timeline: measure, unit, display; journal stays private', () async {
    // Eigene Akte: der Snapshot zeigt Tabellen als (Archiv-)Views.
    final own = Directory.systemTemp.createTempSync('mai_v15');
    addTearDown(() => own.deleteSync(recursive: true));
    final path = buildFixtureDb(own);
    final db = sqlite3.open(path);
    final at = DateTime.now().subtract(const Duration(days: 2));
    int sec(DateTime d) => d.millisecondsSinceEpoch ~/ 1000;
    db
      ..execute(
        'INSERT INTO symptoms (id, label, check_in_cadence, created_at, '
        "updated_at, measure, measure2) VALUES ('sym2', 'Fieber', 0, 0, 0, "
        "'temperature', 'pulse')",
      )
      ..execute(
        'INSERT INTO symptom_observations (id, symptom_id, recorded_at, kind, '
        'value_number, unit, measure, measure2, secondary_value, journal) '
        "VALUES ('f1', 'sym2', ${sec(at)}, 4, 38.4, '°C', 'temperature', "
        "'pulse', 96, 'Sehr privat'), "
        "('f2', 'sym2', ${sec(at.add(const Duration(hours: 6)))}, 4, 37.6, "
        "'°C', 'temperature', NULL, NULL, NULL)",
      )
      // v16: Tagebuch steht im Suchindex der App, nicht in der MCP-Suche.
      ..execute(
        "INSERT INTO records_fts VALUES ('journal', 'f1', 'Fieber · x', "
        "'Sehr privat')",
      );
    db.close();
    var opened = MaiSnapshot.openSqlite(path);
    var t = MaiRecords(opened.db).symptomTimeline('Fieber')!;
    expect(t['measure'], 'temperature');
    expect(t['unit'], '°C');
    expect(t['measure2'], 'pulse');
    expect((t['stats'] as Map)['max'], 38.4);
    final first = (t['observations'] as List).first as Map;
    expect(first['kind'], 'messung');
    expect(first['display'], '38.4 °C');
    expect((first['secondary'] as Map)['display'], '96/min');
    expect(first.toString(), isNot(contains('Sehr privat')));
    expect(first.containsKey('journal'), isFalse);
    expect(MaiRecords(opened.db).searchRecords('privat'), isEmpty);
    expect(
      MaiRecords(opened.db).searchRecords('privat', types: ['journal']),
      isEmpty,
    );

    // Einheiten der App-Einstellungen gelten auch hier.
    await opened.close();
    sqlite3.open(path)
      ..execute("UPDATE app_settings SET temperature_unit = 'fahrenheit'")
      ..close();
    opened = MaiSnapshot.openSqlite(path);
    addTearDown(opened.close);
    t = MaiRecords(opened.db).symptomTimeline('Fieber')!;
    expect(((t['observations'] as List).first as Map)['display'], '101.1 °F');
    expect(
      MaiRecords.formatMeasure('bloodPressure', 128, value2: 84),
      '128/84 mmHg',
    );
    expect(MaiRecords.formatMeasure('mood', -2), '-2');
    expect(MaiRecords.formatMeasure('mood', 3), '+3');
  });

  test('medications: active only by default filter', () {
    expect(records.listMedications(), hasLength(2));
    final active = records.listMedications(activeOnly: true);
    expect(active.single['name'], 'Nasenspray');
    expect(active.single['diagnosis'], 'Sinusitis');
    expect(active.single['form'], 'Spray');
    expect(active.single['dose'], '1.0 Sprühstoß');
    expect(active.single['prescriber'], 'Dr. Weiß');
  });

  test('diagnosis hub by title keeps own notes and linked notes', () {
    final d = records.getDiagnosis('sinus')!;
    expect(d['notes'], 'chronisch');
    expect(d['notes_linked'], ['Frage: OP sinnvoll?']);
    expect((d['appointments'] as List).single['status'], 'erledigt');
    expect(d['medications'], [
      {'name': 'Nasenspray', 'dosage': '2x täglich'},
    ]);
  });

  test('archived entries are invisible', () async {
    await snapshot.close();
    final path = '${dir.path}/akte.sqlite';
    final raw = sqlite3.open(path)
      ..execute("UPDATE notes SET archived_at = 1 WHERE id = 'not1'")
      ..execute("UPDATE appointments SET archived_at = 1 WHERE id = 'apt2'")
      ..close();
    expect(raw, isNotNull);
    snapshot = MaiSnapshot.openSqlite(path);
    records = MaiRecords(snapshot.db);
    expect(records.searchRecords('OP sinnvoll'), isEmpty);
    expect(records.listAppointments().map((a) => a['id']), ['apt1']);
    expect(records.getDiagnosis('dia1')!['notes_linked'], isEmpty);
    expect((records.summary()['next_appointments'] as List), isEmpty);
  });

  test('vaccinations with due flag', () {
    final v = records.listVaccinations().single;
    expect(v['vaccine'], 'Tetanus');
    expect(v['batch'], 'X1');
    expect(v['due'], isTrue);
  });

  test('summary lists active items and next appointments', () {
    final summary = records.summary();
    expect(summary['active_diagnoses'], [
      {'id': 'dia1', 'title': 'Sinusitis'},
    ]);
    expect(summary['current_medications'], ['Nasenspray 2x täglich']);
    expect((summary['next_appointments'] as List).single['title'], 'Nachsorge');
    expect((summary['counts'] as Map)['reports'], 1);
  });
}
