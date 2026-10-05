import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/repositories/appointment_repository.dart';
import 'package:mai_doctor_hub/data/repositories/doctor_repository.dart';
import 'package:mai_doctor_hub/data/repositories/records_repository.dart';
import 'package:mai_doctor_hub/main.dart';

import 'helpers/test_env.dart';

void main() {
  late AppDatabase database;

  setUpAll(() async {
    await initializeDateFormatting('de');
  });

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  Future<void> pumpApp(WidgetTester tester) async {
    useFakePermissions();
    await tester.runAsync(() => markOnboarded(database));
    await tester.pumpWidget(MaiDoctorHubApp(database: database));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  Future<void> disposeApp(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 100));
  }

  testWidgets('Sticky footer shows four destinations', (tester) async {
    await pumpApp(tester);

    expect(find.text('Home'), findsWidgets);
    expect(find.text('Kalender'), findsOneWidget);
    expect(find.text('Meine Akte'), findsOneWidget);
    expect(find.text('Einstellungen'), findsOneWidget);
    expect(find.text('Termin hinzufügen'), findsOneWidget);

    await disposeApp(tester);
  });

  testWidgets('Kalender tab exposes view mode toggle', (tester) async {
    await pumpApp(tester);

    await tester.tap(find.text('Kalender'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Tag'), findsOneWidget);
    expect(find.text('Woche'), findsOneWidget);
    expect(find.text('Monat'), findsWidgets);
    expect(find.text('Jahr'), findsOneWidget);

    await disposeApp(tester);
  });

  testWidgets('Home shows appointment after create', (tester) async {
    final doctorId = await DoctorRepository(database).create(name: 'Dr. Test');
    await AppointmentRepository(database).create(
      doctorId: doctorId,
      scheduledAt: DateTime.now().add(const Duration(days: 1)),
      title: 'Kontrolle',
    );

    await pumpApp(tester);
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Kontrolle'), findsOneWidget);
    expect(find.text('Noch keine Termine'), findsNothing);

    await disposeApp(tester);
  });

  test('FTS finds diagnosis and report text', () async {
    final records = RecordsRepository(database);
    await records.createDiagnosis(title: 'Migräne', notes: 'mit Aura');
    await records.createReport(
      title: 'MRT Bericht',
      mimeType: 'application/pdf',
      localPath: '/tmp/mrt.pdf',
      source: ReportSource.pdf,
      extractedText: 'Befund unauffällig Blutbild',
    );

    final hits = await records.search('Blutbild');
    expect(hits, isNotEmpty);
    expect(hits.first.read<String>('entity_type'), 'report');

    final diagnosisHits = await records.search('Migräne');
    expect(diagnosisHits, isNotEmpty);
  });
}
