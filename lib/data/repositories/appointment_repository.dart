import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';
import 'records_repository.dart';

const _uuid = Uuid();

/// Termin inkl. Arztname für Listen/Timeline.
class AppointmentSummary {
  const AppointmentSummary({
    required this.appointment,
    required this.doctorName,
    this.doctor,
    this.symptomLabels = const [],
    this.diagnosisTitles = const [],
    this.symptomIds = const [],
    this.diagnosisIds = const [],
    this.reportCount = 0,
  });

  final Appointment appointment;
  final Doctor? doctor;
  final String doctorName;
  final List<String> symptomLabels;
  final List<String> diagnosisTitles;
  final List<String> symptomIds;
  final List<String> diagnosisIds;
  final int reportCount;

  bool get hasReport => reportCount > 0;

  /// „Bericht fehlt“ nur für vergangene, nicht abgesagte Termine.
  bool get isMissingReport =>
      !hasReport &&
      appointment.status != AppointmentStatus.cancelled &&
      appointment.scheduledAt.isBefore(DateTime.now());
}

String appointmentStatusLabel(AppointmentStatus status) => switch (status) {
  AppointmentStatus.planned => 'Geplant',
  AppointmentStatus.done => 'Erledigt',
  AppointmentStatus.cancelled => 'Abgesagt',
};

class AppointmentRepository {
  AppointmentRepository(this._db);

  final AppDatabase _db;

  Set<ResultSetImplementation<dynamic, dynamic>> get _summaryTables => {
    _db.appointments,
    _db.doctors,
    _db.diagnoses,
    _db.symptoms,
    _db.appointmentDiagnoses,
    _db.appointmentSymptoms,
    _db.reports,
  };

  /// Feuert bei jeder Änderung an Terminen und allem, was eine
  /// [AppointmentSummary] beeinflusst (Arzt, Diagnosen, Berichte …).
  Stream<void> _summaryChanges() => _db
      .customSelect('SELECT 1', readsFrom: _summaryTables)
      .watch()
      .map((_) {});

  /// Kommende, geplante Termine — `now` wird bei jeder Änderung neu bestimmt.
  Stream<List<AppointmentSummary>> watchUpcomingSummaries() {
    return _summaryChanges().asyncMap((_) async {
      final now = DateTime.now();
      final rows =
          await (_db.select(_db.appointments)
                ..where((t) => t.scheduledAt.isBiggerOrEqualValue(now))
                ..where((t) => t.status.equalsValue(AppointmentStatus.planned))
                ..orderBy([(t) => OrderingTerm.asc(t.scheduledAt)]))
              .get();
      return summariesFor(rows);
    });
  }

  /// Vergangene Termine (alle Status), neueste zuerst.
  Stream<List<AppointmentSummary>> watchPastSummaries() {
    return _summaryChanges().asyncMap((_) async {
      final now = DateTime.now();
      final rows =
          await (_db.select(_db.appointments)
                ..where((t) => t.scheduledAt.isSmallerThanValue(now))
                ..orderBy([(t) => OrderingTerm.desc(t.scheduledAt)]))
              .get();
      return summariesFor(rows);
    });
  }

  Stream<AppointmentSummary?> watchSummary(String id) {
    return _summaryChanges().asyncMap((_) => summaryFor(id));
  }

  Stream<List<Appointment>> watchUpcoming({DateTime? from}) {
    final start = from ?? DateTime.now();
    return (_db.select(_db.appointments)
          ..where((t) => t.scheduledAt.isBiggerOrEqualValue(start))
          ..where((t) => t.status.equalsValue(AppointmentStatus.planned))
          ..orderBy([(t) => OrderingTerm.asc(t.scheduledAt)]))
        .watch();
  }

  Stream<List<Appointment>> watchPast({DateTime? until}) {
    final end = until ?? DateTime.now();
    return (_db.select(_db.appointments)
          ..where((t) => t.scheduledAt.isSmallerThanValue(end))
          ..orderBy([(t) => OrderingTerm.desc(t.scheduledAt)]))
        .watch();
  }

  Stream<List<Appointment>> watchAll() {
    return (_db.select(_db.appointments)
          ..orderBy([(t) => OrderingTerm.desc(t.scheduledAt)]))
        .watch();
  }

  Stream<List<Appointment>> watchInRange(DateTime start, DateTime end) {
    return (_db.select(_db.appointments)
          ..where((t) => t.scheduledAt.isBiggerOrEqualValue(start))
          ..where((t) => t.scheduledAt.isSmallerThanValue(end))
          ..orderBy([(t) => OrderingTerm.asc(t.scheduledAt)]))
        .watch();
  }

  Future<List<Appointment>> forDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return (_db.select(_db.appointments)
          ..where((t) => t.scheduledAt.isBiggerOrEqualValue(start))
          ..where((t) => t.scheduledAt.isSmallerThanValue(end))
          ..orderBy([(t) => OrderingTerm.asc(t.scheduledAt)]))
        .get();
  }

  Future<Appointment?> getById(String id) {
    return (_db.select(
      _db.appointments,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<AppointmentSummary?> summaryFor(String id) async {
    final appointment = await getById(id);
    if (appointment == null) return null;
    return (await summariesFor([appointment])).single;
  }

  /// Lädt Zusatzdaten für alle Termine mit einer festen Anzahl Queries
  /// (statt pro Termin).
  Future<List<AppointmentSummary>> summariesFor(
    List<Appointment> appointments,
  ) async {
    if (appointments.isEmpty) return const [];
    final ids = appointments.map((a) => a.id).toList();
    final doctorIds = appointments.map((a) => a.doctorId).toSet();

    final doctors = {
      for (final d in await (_db.select(
        _db.doctors,
      )..where((t) => t.id.isIn(doctorIds))).get())
        d.id: d,
    };

    final diagnosisRows =
        await (_db.select(_db.appointmentDiagnoses).join([
                innerJoin(
                  _db.diagnoses,
                  _db.diagnoses.id.equalsExp(
                    _db.appointmentDiagnoses.diagnosisId,
                  ),
                ),
              ])
              ..where(_db.appointmentDiagnoses.appointmentId.isIn(ids))
              ..orderBy([OrderingTerm.asc(_db.diagnoses.title)]))
            .get();
    final diagnoses = <String, List<Diagnose>>{};
    for (final row in diagnosisRows) {
      final link = row.readTable(_db.appointmentDiagnoses);
      diagnoses
          .putIfAbsent(link.appointmentId, () => [])
          .add(row.readTable(_db.diagnoses));
    }

    final symptomRows =
        await (_db.select(_db.appointmentSymptoms).join([
                innerJoin(
                  _db.symptoms,
                  _db.symptoms.id.equalsExp(_db.appointmentSymptoms.symptomId),
                ),
              ])
              ..where(_db.appointmentSymptoms.appointmentId.isIn(ids))
              ..orderBy([OrderingTerm.asc(_db.symptoms.label)]))
            .get();
    final symptoms = <String, List<Symptom>>{};
    for (final row in symptomRows) {
      final link = row.readTable(_db.appointmentSymptoms);
      symptoms
          .putIfAbsent(link.appointmentId, () => [])
          .add(row.readTable(_db.symptoms));
    }

    final count = _db.reports.id.count();
    final reportRows =
        await (_db.selectOnly(_db.reports)
              ..addColumns([_db.reports.appointmentId, count])
              ..where(_db.reports.appointmentId.isIn(ids))
              ..groupBy([_db.reports.appointmentId]))
            .get();
    final reportCounts = {
      for (final row in reportRows)
        row.read(_db.reports.appointmentId)!: row.read(count) ?? 0,
    };

    return [
      for (final a in appointments)
        AppointmentSummary(
          appointment: a,
          doctor: doctors[a.doctorId],
          doctorName: doctors[a.doctorId]?.name ?? 'Unbekannter Arzt',
          diagnosisTitles: [for (final d in diagnoses[a.id] ?? []) d.title],
          diagnosisIds: [for (final d in diagnoses[a.id] ?? []) d.id],
          symptomLabels: [for (final s in symptoms[a.id] ?? []) s.label],
          symptomIds: [for (final s in symptoms[a.id] ?? []) s.id],
          reportCount: reportCounts[a.id] ?? 0,
        ),
    ];
  }

  Future<String> create({
    required String doctorId,
    required DateTime scheduledAt,
    String? title,
    String? notes,
    int? durationMin,
    List<String> diagnosisIds = const [],
    List<String> symptomIds = const [],
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    await _db.transaction(() async {
      await _db
          .into(_db.appointments)
          .insert(
            AppointmentsCompanion.insert(
              id: id,
              doctorId: doctorId,
              scheduledAt: scheduledAt,
              durationMin: Value(durationMin),
              title: Value(title),
              notes: Value(notes),
              status: AppointmentStatus.planned,
              createdAt: now,
              updatedAt: now,
            ),
          );
      await _replaceLinks(id, diagnosisIds, symptomIds);
      await _indexFts(id, title, notes);
    });
    return id;
  }

  Future<void> update({
    required String id,
    required String doctorId,
    required DateTime scheduledAt,
    String? title,
    String? notes,
    int? durationMin,
    required List<String> diagnosisIds,
    required List<String> symptomIds,
  }) async {
    await _db.transaction(() async {
      await (_db.update(
        _db.appointments,
      )..where((t) => t.id.equals(id))).write(
        AppointmentsCompanion(
          doctorId: Value(doctorId),
          scheduledAt: Value(scheduledAt),
          title: Value(title),
          notes: Value(notes),
          durationMin: Value(durationMin),
          updatedAt: Value(DateTime.now()),
        ),
      );
      await _replaceLinks(id, diagnosisIds, symptomIds);
      await _indexFts(id, title, notes);
    });
  }

  Future<void> _replaceLinks(
    String id,
    List<String> diagnosisIds,
    List<String> symptomIds,
  ) async {
    await (_db.delete(
      _db.appointmentDiagnoses,
    )..where((t) => t.appointmentId.equals(id))).go();
    await (_db.delete(
      _db.appointmentSymptoms,
    )..where((t) => t.appointmentId.equals(id))).go();
    for (final diagnosisId in diagnosisIds.toSet()) {
      await _db
          .into(_db.appointmentDiagnoses)
          .insert(
            AppointmentDiagnosesCompanion.insert(
              appointmentId: id,
              diagnosisId: diagnosisId,
            ),
          );
    }
    for (final symptomId in symptomIds.toSet()) {
      await _db
          .into(_db.appointmentSymptoms)
          .insert(
            AppointmentSymptomsCompanion.insert(
              appointmentId: id,
              symptomId: symptomId,
            ),
          );
    }
  }

  Future<void> _indexFts(String id, String? title, String? notes) {
    return _db.upsertFts(
      entityType: 'appointment',
      entityId: id,
      title: title?.isNotEmpty == true ? title! : 'Termin',
      body: notes ?? '',
    );
  }

  Future<void> updateStatus(String id, AppointmentStatus status) async {
    await (_db.update(_db.appointments)..where((t) => t.id.equals(id))).write(
      AppointmentsCompanion(
        status: Value(status),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Löscht den Termin samt Verknüpfungen und Berichten (inkl. Dateien).
  /// Notizen bleiben erhalten, verlieren aber den Terminbezug.
  Future<void> delete(String id) async {
    final records = RecordsRepository(_db);
    final reports = await records.reportsForAppointment(id);
    await _db.transaction(() async {
      await (_db.delete(
        _db.appointmentDiagnoses,
      )..where((t) => t.appointmentId.equals(id))).go();
      await (_db.delete(
        _db.appointmentSymptoms,
      )..where((t) => t.appointmentId.equals(id))).go();
      await (_db.update(_db.notes)
            ..where((t) => t.relatedAppointmentId.equals(id)))
          .write(const NotesCompanion(relatedAppointmentId: Value(null)));
      for (final report in reports) {
        await records.deleteReportRow(report.id);
      }
      await (_db.delete(
        _db.appointments,
      )..where((t) => t.id.equals(id))).go();
      await _db.deleteFts('appointment', id);
    });
    for (final report in reports) {
      await records.deleteReportFile(report);
    }
  }
}
