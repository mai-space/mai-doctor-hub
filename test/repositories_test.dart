import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/repositories/appointment_repository.dart';
import 'package:mai_doctor_hub/data/repositories/doctor_repository.dart';
import 'package:mai_doctor_hub/data/repositories/records_repository.dart';
import 'package:mai_doctor_hub/data/repositories/symptom_repository.dart';

void main() {
  late AppDatabase db;
  late AppointmentRepository appointments;
  late RecordsRepository records;
  late DoctorRepository doctors;
  late SymptomRepository symptoms;
  late String doctorId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    appointments = AppointmentRepository(db);
    records = RecordsRepository(db);
    doctors = DoctorRepository(db);
    symptoms = SymptomRepository(db);
    doctorId = await doctors.create(name: 'Dr. Weiß', specialty: 'HNO');
  });

  tearDown(() => db.close());

  group('AppointmentRepository', () {
    test('summaries batch-load doctor, links and report count', () async {
      final diagnosisId = await records.createDiagnosis(title: 'Sinusitis');
      final symptomId = await symptoms.create(label: 'Druck');
      final id = await appointments.create(
        doctorId: doctorId,
        scheduledAt: DateTime.now().subtract(const Duration(days: 1)),
        diagnosisIds: [diagnosisId],
        symptomIds: [symptomId],
      );
      await records.createReport(
        title: 'Brief',
        mimeType: 'application/pdf',
        localPath: '/nope.pdf',
        source: ReportSource.pdf,
        appointmentId: id,
      );

      final summary = (await appointments.summaryFor(id))!;
      expect(summary.doctorName, 'Dr. Weiß');
      expect(summary.diagnosisTitles, ['Sinusitis']);
      expect(summary.symptomIds, [symptomId]);
      expect(summary.reportCount, 1);
      expect(summary.isMissingReport, isFalse);
    });

    test('cancelled or future appointments never miss a report', () async {
      final past = await appointments.create(
        doctorId: doctorId,
        scheduledAt: DateTime.now().subtract(const Duration(days: 2)),
      );
      final future = await appointments.create(
        doctorId: doctorId,
        scheduledAt: DateTime.now().add(const Duration(days: 2)),
      );
      expect((await appointments.summaryFor(past))!.isMissingReport, isTrue);
      expect(
        (await appointments.summaryFor(future))!.isMissingReport,
        isFalse,
      );

      await appointments.updateStatus(past, AppointmentStatus.cancelled);
      expect((await appointments.summaryFor(past))!.isMissingReport, isFalse);
    });

    test('past summaries stream re-emits when a report is attached', () async {
      final id = await appointments.create(
        doctorId: doctorId,
        scheduledAt: DateTime.now().subtract(const Duration(hours: 3)),
      );
      final emissions = appointments.watchPastSummaries().map(
        (list) => list.single.hasReport,
      );
      final expectation = expectLater(emissions, emitsInOrder([false, true]));
      await Future<void>.delayed(const Duration(milliseconds: 20));
      await records.createReport(
        title: 'Befund',
        mimeType: 'application/pdf',
        localPath: '/x.pdf',
        source: ReportSource.pdf,
        appointmentId: id,
      );
      await expectation;
    });

    test('update replaces fields and links', () async {
      final d1 = await records.createDiagnosis(title: 'A');
      final d2 = await records.createDiagnosis(title: 'B');
      final id = await appointments.create(
        doctorId: doctorId,
        scheduledAt: DateTime(2030, 1, 1, 9),
        title: 'Alt',
        diagnosisIds: [d1],
      );
      await appointments.update(
        id: id,
        doctorId: doctorId,
        scheduledAt: DateTime(2030, 1, 2, 10),
        title: 'Neu',
        notes: 'Nüchtern kommen',
        diagnosisIds: [d2],
        symptomIds: const [],
      );
      final summary = (await appointments.summaryFor(id))!;
      expect(summary.appointment.title, 'Neu');
      expect(summary.appointment.scheduledAt, DateTime(2030, 1, 2, 10));
      expect(summary.diagnosisIds, [d2]);
      final hits = await records.search('Nüchtern');
      expect(hits.single.read<String>('entity_id'), id);
    });

    test('delete cascades reports (incl. file) and unlinks notes', () async {
      final dir = await Directory.systemTemp.createTemp('cascade');
      addTearDown(() => dir.delete(recursive: true));
      final file = File('${dir.path}/r.pdf')..writeAsStringSync('%PDF');

      final id = await appointments.create(
        doctorId: doctorId,
        scheduledAt: DateTime.now(),
        title: 'Weg',
      );
      final reportId = await records.createReport(
        title: 'Anhang',
        mimeType: 'application/pdf',
        localPath: file.path,
        source: ReportSource.pdf,
        appointmentId: id,
        extractedText: 'Laborwerte',
      );
      final noteId = await records.createNote(
        body: 'Fragen',
        relatedAppointmentId: id,
      );

      await appointments.delete(id);

      expect(await appointments.getById(id), isNull);
      expect(await records.getReport(reportId), isNull);
      expect(file.existsSync(), isFalse);
      expect((await records.getNote(noteId))!.relatedAppointmentId, isNull);
      expect(await records.search('Laborwerte'), isEmpty);
      expect(await records.search('Weg'), isEmpty);
    });
  });

  group('RecordsRepository', () {
    test('search filters entity type before limit', () async {
      for (var i = 0; i < 60; i++) {
        await records.createNote(body: 'Kopfweh Eintrag $i');
      }
      await records.createDiagnosis(title: 'Kopfweh chronisch');
      final hits = await records.search('Kopfweh', entityType: 'diagnosis');
      expect(hits, hasLength(1));
    });

    test('diagnosis update/delete keeps linked records', () async {
      final id = await records.createDiagnosis(title: 'Asthma');
      final medId = await records.createMedication(
        name: 'Spray',
        diagnosisId: id,
      );
      await records.updateDiagnosis(
        id: id,
        title: 'Asthma bronchiale',
        status: DiagnosisStatus.resolved,
      );
      final items = await records.listAll(
        sort: RecordSort.name,
        entityType: 'diagnosis',
      );
      expect(items.single.subtitle, 'Diagnose · abgeschlossen');

      await records.deleteDiagnosis(id);
      expect(await records.getDiagnosis(id), isNull);
      expect((await records.getMedication(medId))!.diagnosisId, isNull);
    });

    test('medication, note and report updates reindex search', () async {
      final medId = await records.createMedication(name: 'Ibu');
      await records.updateMedication(id: medId, name: 'Ibuprofen 600');
      expect(await records.search('Ibuprofen'), isNotEmpty);
      await records.deleteMedication(medId);
      expect(await records.search('Ibuprofen'), isEmpty);

      final noteId = await records.createNote(body: 'alt');
      await records.updateNote(id: noteId, body: 'Allergie Pollen');
      expect(await records.search('Pollen'), isNotEmpty);
      await records.deleteNote(noteId);
      expect(await records.getNote(noteId), isNull);

      final reportId = await records.createReport(
        title: 'scan.pdf',
        mimeType: 'application/pdf',
        localPath: '/x',
        source: ReportSource.pdf,
      );
      await records.setReportText(reportId, 'Ferritin niedrig', 2);
      await records.updateReport(id: reportId, title: 'Blutbild März');
      expect(await records.search('Ferritin'), isNotEmpty);
      expect(await records.search('März'), isNotEmpty);
      expect((await records.getReport(reportId))!.pageCount, 2);
    });

    test('watchAll emits after changes', () async {
      final stream = records
          .watchAll(sort: RecordSort.name, entityType: 'note')
          .map((items) => items.length);
      final expectation = expectLater(stream, emitsInOrder([0, 1]));
      await Future<void>.delayed(const Duration(milliseconds: 20));
      await records.createNote(body: 'neu');
      await expectation;
    });
  });

  group('Doctor & Symptom', () {
    test('doctor with appointments cannot be deleted', () async {
      await appointments.create(doctorId: doctorId, scheduledAt: DateTime(2030));
      expect(await doctors.delete(doctorId), isFalse);
      final other = await doctors.create(name: 'Dr. Frei');
      await doctors.update(id: other, name: 'Dr. Frei', phone: '0761 123');
      expect((await doctors.getById(other))!.phone, '0761 123');
      expect(await doctors.delete(other), isTrue);
    });

    test('symptom delete removes observations and links', () async {
      final id = await symptoms.create(label: 'Husten');
      await symptoms.addObservation(
        symptomId: id,
        kind: ObservationKind.scale_1_10,
        valueNumber: 4,
      );
      await appointments.create(
        doctorId: doctorId,
        scheduledAt: DateTime(2030),
        symptomIds: [id],
      );
      await symptoms.update(id: id, label: 'Reizhusten', bodyRegion: 'Brust');
      expect((await symptoms.getById(id))!.label, 'Reizhusten');
      await symptoms.markHealed(id);
      expect((await symptoms.getById(id))!.healedAt, isNotNull);
      await symptoms.reopen(id);
      expect((await symptoms.getById(id))!.healedAt, isNull);

      await symptoms.delete(id);
      expect(await db.select(db.symptomObservations).get(), isEmpty);
      expect(await db.select(db.appointmentSymptoms).get(), isEmpty);
    });
  });
}
