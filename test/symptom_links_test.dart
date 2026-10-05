import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/database_provider.dart';
import 'package:mai_doctor_hub/data/repositories/appointment_repository.dart';
import 'package:mai_doctor_hub/data/repositories/doctor_repository.dart';
import 'package:mai_doctor_hub/data/repositories/symptom_repository.dart';
import 'package:mai_doctor_hub/features/home/appointment_detail_page.dart';
import 'package:mai_doctor_hub/features/records/detail_pages.dart';

void main() {
  late AppDatabase db;
  late SymptomRepository symptoms;
  late AppointmentRepository appointments;
  late String doctorId;
  late String otherDoctorId;

  setUpAll(() => initializeDateFormatting('de'));
  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    symptoms = SymptomRepository(db);
    appointments = AppointmentRepository(db);
    doctorId = await DoctorRepository(db).create(name: 'Dr. Haut');
    otherDoctorId = await DoctorRepository(db).create(name: 'Dr. Knie');
  });
  tearDown(() => db.close());

  Future<void> observe(String symptomId, DateTime at, double value) =>
      symptoms.addObservation(
        symptomId: symptomId,
        kind: ObservationKind.scale_1_10,
        valueNumber: value,
        recordedAt: at,
      );

  test('doctor ↔ symptom n:m, union with appointment links', () async {
    final itch = await symptoms.create(label: 'Juckreiz');
    final rash = await symptoms.create(label: 'Ausschlag');
    final knee = await symptoms.create(label: 'Knieschmerz');

    await symptoms.setDoctors(itch, [doctorId, otherDoctorId]);
    await appointments.create(
      doctorId: doctorId,
      scheduledAt: DateTime(2030),
      symptomIds: [rash],
    );
    await symptoms.linkDoctor(otherDoctorId, knee);

    final forDoctor = await symptoms.symptomsForDoctor(doctorId);
    expect(forDoctor.map((e) => (e.$1.label, e.$2)), [
      ('Ausschlag', false),
      ('Juckreiz', true),
    ]);
    expect((await symptoms.doctorsFor(itch)).map((d) => d.name), unorderedEquals([
      'Dr. Haut',
      'Dr. Knie',
    ]));

    await symptoms.unlinkDoctor(otherDoctorId, itch);
    expect((await symptoms.doctorsFor(itch)).map((d) => d.name), ['Dr. Haut']);

    await symptoms.delete(itch);
    expect(await db.select(db.doctorSymptoms).get(), hasLength(1));
  });

  test('report window: since previous appointment at same doctor', () async {
    await appointments.create(doctorId: doctorId, scheduledAt: DateTime(2030, 1, 10));
    final cancelled = await appointments.create(
      doctorId: doctorId,
      scheduledAt: DateTime(2030, 2, 1),
    );
    await appointments.updateStatus(cancelled, AppointmentStatus.cancelled);
    await appointments.create(
      doctorId: otherDoctorId,
      scheduledAt: DateTime(2030, 2, 5),
    );
    final id = await appointments.create(
      doctorId: doctorId,
      scheduledAt: DateTime(2030, 2, 20),
    );
    final a = (await appointments.getById(id))!;

    final (from, to) = await appointments.reportWindow(
      a,
      now: DateTime(2030, 6),
    );
    expect(from, DateTime(2030, 1, 10), reason: 'abgesagt/anderer Arzt zählen nicht');
    expect(to.isAfter(DateTime(2030, 2, 20)), isTrue);

    // Kein Vortermin → 30 Tage; zukünftiger Termin → bis jetzt.
    final first = await appointments.create(
      doctorId: otherDoctorId,
      scheduledAt: DateTime(2030, 1, 1),
    );
    final (f2, _) = await appointments.reportWindow(
      (await appointments.getById(first))!,
      now: DateTime(2030, 6),
    );
    expect(f2, DateTime(2029, 12, 2));
    final (_, t3) = await appointments.reportWindow(a, now: DateTime(2030, 2, 15));
    expect(t3.difference(DateTime(2030, 2, 15)).inSeconds, 1);
  });

  testWidgets('appointment shows check-ins reported since last visit', (
    tester,
  ) async {
    late String appointmentId;
    await tester.runAsync(() async {
      final itch = await symptoms.create(label: 'Juckreiz');
      await appointments.create(
        doctorId: doctorId,
        scheduledAt: DateTime(2025, 1, 10),
      );
      appointmentId = await appointments.create(
        doctorId: doctorId,
        scheduledAt: DateTime(2025, 2, 20),
        symptomIds: [itch],
      );
      await observe(itch, DateTime(2025, 1, 5), 9); // vor dem Zeitraum
      await observe(itch, DateTime(2025, 1, 20, 8), 6);
      await observe(itch, DateTime(2025, 2, 10, 8), 3);
    });

    Future<void> settle() async {
      for (var i = 0; i < 6; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 10)),
        );
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    tester.view.physicalSize = const Size(1080, 3200);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      DatabaseScope(
        database: db,
        child: MaterialApp(
          home: AppointmentDetailPage(appointmentId: appointmentId),
        ),
      ),
    );
    await settle();

    expect(find.text('Symptome & gemeldete Check-ins'), findsOneWidget);
    expect(find.text('10.1. – 20.2.'), findsOneWidget);
    expect(find.textContaining('2 Check-in(s) · Ø 4.5 · zuletzt 3/10'), findsOneWidget);
    expect(find.text('10.2. 08:00 · Stärke 3/10'), findsOneWidget);
    expect(find.textContaining('Stärke 9/10'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 100));
  });

  testWidgets('doctor page lists symptoms and assigns new ones', (tester) async {
    await tester.runAsync(() async {
      final a = await symptoms.create(label: 'Akne');
      await symptoms.create(label: 'Schuppen');
      await symptoms.linkDoctor(doctorId, a);
    });
    Future<void> settle() async {
      for (var i = 0; i < 6; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 10)),
        );
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      DatabaseScope(
        database: db,
        child: MaterialApp(home: DoctorDetailPage(doctorId: doctorId)),
      ),
    );
    await settle();
    expect(find.text('Akne'), findsOneWidget);
    expect(find.text('aktiv · zugeordnet'), findsOneWidget);

    await tester.tap(find.text('Zuordnen'));
    await settle();
    await tester.tap(find.widgetWithText(FilterChip, 'Schuppen'));
    await tester.tap(find.text('Speichern'));
    await settle();
    expect(find.text('Schuppen'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 100));
  });
}
