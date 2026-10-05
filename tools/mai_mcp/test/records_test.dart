import 'dart:io';

import 'package:mai_mcp/mai_mcp.dart';
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
    expect(records.symptomTimeline('Bauch'), isNull);
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
