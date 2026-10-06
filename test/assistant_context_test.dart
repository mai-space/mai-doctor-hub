import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/repositories/appointment_repository.dart';
import 'package:mai_doctor_hub/data/repositories/archive_repository.dart';
import 'package:mai_doctor_hub/data/repositories/doctor_repository.dart';
import 'package:mai_doctor_hub/data/repositories/records_repository.dart';
import 'package:mai_doctor_hub/services/assistant/record_context.dart';

void main() {
  late AppDatabase db;
  late RecordsRepository records;
  final now = DateTime(2026, 10, 6, 9);

  setUpAll(() => initializeDateFormatting('de'));
  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    records = RecordsRepository(db);
  });
  tearDown(() => db.close());

  test('keywords drop stop words and punctuation', () {
    expect(
      AssistantContextBuilder.keywords('Wann ist mein nächster Termin beim Kardiologen?'),
      ['nächster', 'termin', 'kardiologen'],
    );
  });

  test('context has overview and the report matching the question', () async {
    final diagnosis = await records.createDiagnosis(title: 'Hypothyreose');
    await records.createMedication(
      name: 'L-Thyroxin',
      dosage: '50 µg',
      scheduleText: 'morgens nüchtern',
      diagnosisId: diagnosis,
    );
    final doctor = await DoctorRepository(
      db,
    ).create(name: 'Dr. Weiß', specialty: 'Endokrinologie');
    await AppointmentRepository(db).create(
      doctorId: doctor,
      scheduledAt: DateTime(2026, 10, 20, 8, 30),
      title: 'Kontrolle',
    );
    await records.createReport(
      title: 'Laborbefund',
      mimeType: 'application/pdf',
      localPath: '/tmp/x.pdf',
      source: ReportSource.pdf,
      extractedText: '${'Einleitung ' * 200} TSH 3,1 mU/l im Normbereich.',
    );

    final context = await AssistantContextBuilder(
      db,
    ).build('Wie war mein TSH-Wert?', now: now);

    expect(context, contains('Heute: 06.10.2026 09:00'));
    expect(context, contains('- Hypothyreose'));
    expect(
      context,
      contains('L-Thyroxin, 50 µg, morgens nüchtern, gegen Hypothyreose'),
    );
    expect(
      context,
      contains('20.10.2026 08:30 · Dr. Weiß · Endokrinologie · Kontrolle'),
    );
    expect(context, contains('[Bericht] Laborbefund:'));
    expect(context, contains('TSH 3,1 mU/l'));
  });

  test('archived entries stay out; context respects the limit', () async {
    final id = await records.createDiagnosis(title: 'Alte Diagnose');
    await ArchiveRepository(db).archive('diagnosis', id);
    for (var i = 0; i < 40; i++) {
      await records.createNote(body: 'Notiz $i über Kopfschmerz ${'x' * 300}');
    }
    final context = await AssistantContextBuilder(
      db,
      maxChars: 3000,
    ).build('Kopfschmerz', now: now);
    expect(context, isNot(contains('Alte Diagnose')));
    expect(context, contains('[Notiz]'));
    expect(context.length, lessThanOrEqualTo(3000));
  });
}
