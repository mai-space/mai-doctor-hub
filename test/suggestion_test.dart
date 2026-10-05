import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/database_provider.dart';
import 'package:mai_doctor_hub/data/repositories/doctor_repository.dart';
import 'package:mai_doctor_hub/data/repositories/records_repository.dart';
import 'package:mai_doctor_hub/data/repositories/suggestion_repository.dart';
import 'package:mai_doctor_hub/data/suggestion_catalog.dart';
import 'package:mai_doctor_hub/data/repositories/symptom_repository.dart';
import 'package:mai_doctor_hub/features/records/entity_forms.dart';

void main() {
  late AppDatabase database;

  setUp(() => database = AppDatabase(NativeDatabase.memory()));
  tearDown(() => database.close());

  test('ranks own values by frequency, dedupes case, then defaults', () async {
    final symptoms = SymptomRepository(database);
    await symptoms.create(label: 'Schmerz', bodyRegion: 'linkes Knie');
    await symptoms.create(label: 'Schwellung', bodyRegion: 'Linkes Knie ');
    await symptoms.create(label: 'Jucken', bodyRegion: 'Unterarm');
    await symptoms.create(label: 'Druck', bodyRegion: '  ');

    final values = await SuggestionRepository(database)
        .valuesFor(SuggestionField.bodyRegion);

    expect(values.take(2).map((v) => v.toLowerCase()), [
      'linkes knie',
      'unterarm',
    ]);
    expect(values.where((v) => v.toLowerCase() == 'linkes knie'), hasLength(1));
    expect(values, contains('Kopf'));
    expect(values.where((v) => v.trim().isEmpty), isEmpty);
  });

  test('remembers medication fields without defaults', () async {
    await RecordsRepository(database).createMedication(
      name: 'Ibuprofen',
      dosage: '400 mg',
      scheduleText: '1-0-1',
    );
    final repo = SuggestionRepository(database);
    expect(await repo.valuesFor(SuggestionField.medicationName), ['Ibuprofen']);
    expect(await repo.valuesFor(SuggestionField.dosage), ['400 mg']);
    expect(await repo.valuesFor(SuggestionField.medicationSchedule), ['1-0-1']);
  });

  test('filter: prefix before word start before substring', () {
    final values = ['linkes Knie', 'Knie', 'Kniekehle', 'Hand'];
    expect(SuggestionRepository.filter(values, 'kni'), [
      'Knie',
      'Kniekehle',
      'linkes Knie',
    ]);
    expect(SuggestionRepository.filter(values, 'and'), ['Hand']);
    expect(SuggestionRepository.filter(values, 'Knie'), [
      'Kniekehle',
      'linkes Knie',
    ]);
    expect(SuggestionRepository.filter(values, ''), values);
  });

  test('German catalogs: own values first, then catalog', () async {
    await DoctorRepository(database).create(name: 'Dr. A', specialty: 'Kinderarzt');
    final repo = SuggestionRepository(database);

    final specialties = await repo.valuesFor(SuggestionField.specialty);
    expect(specialties.first, 'Kinderarzt');
    expect(specialties, containsAll(specialtyCatalog));

    final symptoms = await repo.valuesFor(SuggestionField.symptomLabel);
    expect(symptoms, containsAll(['Kopfschmerzen', 'Übelkeit', 'Husten']));
    expect(
      await repo.valuesFor(SuggestionField.bodyRegion),
      contains('Lendenwirbelsäule'),
    );
  });

  test('catalog matching: abbreviations, word starts, umlauts', () {
    expect(
      SuggestionRepository.filter(specialtyCatalog, 'hno').first,
      'Hals-Nasen-Ohrenheilkunde (HNO)',
    );
    expect(
      SuggestionRepository.filter(specialtyCatalog, 'Gyn'),
      contains('Frauenheilkunde und Geburtshilfe (Gynäkologie)'),
    );
    expect(
      SuggestionRepository.filter(specialtyCatalog, 'hausarzt'),
      contains('Allgemeinmedizin (Hausarzt)'),
    );
    for (final typed in ['ubelkeit', 'uebelkeit', 'ÜBEL']) {
      expect(
        SuggestionRepository.filter(symptomCatalog, typed),
        contains('Übelkeit'),
        reason: typed,
      );
    }
    expect(
      SuggestionRepository.filter(symptomCatalog, 'kopf').first,
      'Kopfschmerzen',
    );
    expect(SuggestionRepository.filter(symptomCatalog, 'schmerz'), hasLength(8));
  });

  test('own spelling variants with umlauts are merged', () async {
    final symptoms = SymptomRepository(database);
    await symptoms.create(label: 'Uebelkeit');
    await symptoms.create(label: 'Übelkeit');
    final values = await SuggestionRepository(
      database,
    ).valuesFor(SuggestionField.symptomLabel);
    expect(
      values.where((v) => SuggestionRepository.normalize(v) == 'ubelkeit'),
      hasLength(1),
    );
  });

  testWidgets('symptom dialog suggests previously entered body region', (
    tester,
  ) async {
    await tester.runAsync(
      () =>
          SymptomRepository(database)
              .create(label: 'Schmerz', bodyRegion: 'Lendenwirbelsäule'),
    );

    await tester.pumpWidget(
      DatabaseScope(
        database: database,
        child: MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: TextButton(
                onPressed: () => showCreateSymptomDialog(context),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final region = find.widgetWithText(TextField, 'Körperregion');
    await tester.runAsync(() async {
      await tester.tap(region);
      await tester.enterText(region, 'lend');
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pumpAndSettle();

    final option = find.text('Lendenwirbelsäule');
    expect(option, findsOneWidget);
    await tester.tap(option);
    await tester.pumpAndSettle();

    final field = tester.widget<TextField>(region);
    expect(field.controller!.text, 'Lendenwirbelsäule');

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 100));
  });
}
