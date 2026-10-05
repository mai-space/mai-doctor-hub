import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';

const _uuid = Uuid();

/// Termin inkl. Arztname für Listen/Timeline.
class AppointmentSummary {
  const AppointmentSummary({
    required this.appointment,
    required this.doctorName,
    this.symptomLabels = const [],
    this.diagnosisTitles = const [],
    this.hasReport = false,
  });

  final Appointment appointment;
  final String doctorName;
  final List<String> symptomLabels;
  final List<String> diagnosisTitles;
  final bool hasReport;
}

class AppointmentRepository {
  AppointmentRepository(this._db);

  final AppDatabase _db;

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
    return (_db.select(_db.appointments)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<AppointmentSummary?> summaryFor(String id) async {
    final appointment = await getById(id);
    if (appointment == null) return null;
    return _enrich(appointment);
  }

  Future<List<AppointmentSummary>> summariesFor(
    List<Appointment> appointments,
  ) async {
    final result = <AppointmentSummary>[];
    for (final appointment in appointments) {
      result.add(await _enrich(appointment));
    }
    return result;
  }

  Future<AppointmentSummary> _enrich(Appointment appointment) async {
    final doctor = await (_db.select(
      _db.doctors,
    )..where((t) => t.id.equals(appointment.doctorId))).getSingleOrNull();

    final diagnosisRows =
        await (_db.select(_db.appointmentDiagnoses).join([
              innerJoin(
                _db.diagnoses,
                _db.diagnoses.id.equalsExp(
                  _db.appointmentDiagnoses.diagnosisId,
                ),
              ),
            ])..where(
              _db.appointmentDiagnoses.appointmentId.equals(appointment.id),
            ))
            .get();

    final symptomRows =
        await (_db.select(_db.appointmentSymptoms).join([
              innerJoin(
                _db.symptoms,
                _db.symptoms.id.equalsExp(_db.appointmentSymptoms.symptomId),
              ),
            ])..where(
              _db.appointmentSymptoms.appointmentId.equals(appointment.id),
            ))
            .get();

    final report = await (_db.select(
      _db.reports,
    )..where((t) => t.appointmentId.equals(appointment.id))).get();

    return AppointmentSummary(
      appointment: appointment,
      doctorName: doctor?.name ?? 'Unbekannter Arzt',
      diagnosisTitles: diagnosisRows
          .map((row) => row.readTable(_db.diagnoses).title)
          .toList(),
      symptomLabels: symptomRows
          .map((row) => row.readTable(_db.symptoms).label)
          .toList(),
      hasReport: report.isNotEmpty,
    );
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
      for (final diagnosisId in diagnosisIds) {
        await _db
            .into(_db.appointmentDiagnoses)
            .insert(
              AppointmentDiagnosesCompanion.insert(
                appointmentId: id,
                diagnosisId: diagnosisId,
              ),
            );
      }
      for (final symptomId in symptomIds) {
        await _db
            .into(_db.appointmentSymptoms)
            .insert(
              AppointmentSymptomsCompanion.insert(
                appointmentId: id,
                symptomId: symptomId,
              ),
            );
      }
      await _db.upsertFts(
        entityType: 'appointment',
        entityId: id,
        title: title ?? 'Termin',
        body: notes ?? '',
      );
    });
    return id;
  }

  Future<void> updateStatus(String id, AppointmentStatus status) async {
    await (_db.update(_db.appointments)..where((t) => t.id.equals(id))).write(
      AppointmentsCompanion(
        status: Value(status),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> delete(String id) async {
    await _db.transaction(() async {
      await (_db.delete(
        _db.appointmentDiagnoses,
      )..where((t) => t.appointmentId.equals(id))).go();
      await (_db.delete(
        _db.appointmentSymptoms,
      )..where((t) => t.appointmentId.equals(id))).go();
      await (_db.delete(
        _db.appointments,
      )..where((t) => t.id.equals(id))).go();
      await _db.customStatement(
        'DELETE FROM records_fts WHERE entity_type = ? AND entity_id = ?',
        ['appointment', id],
      );
    });
  }
}
