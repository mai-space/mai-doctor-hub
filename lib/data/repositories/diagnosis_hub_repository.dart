import 'package:drift/drift.dart';

import '../app_database.dart';
import 'appointment_repository.dart';

/// Alles, was an einer Diagnose hängt — die „Akte zur Diagnose“.
class DiagnosisHub {
  const DiagnosisHub({
    required this.diagnosis,
    required this.appointments,
    required this.symptoms,
    required this.medications,
    required this.notes,
    required this.reports,
  });

  final Diagnose diagnosis;
  final List<AppointmentSummary> appointments;
  final List<Symptom> symptoms;
  final List<Medication> medications;
  final List<Note> notes;

  /// Berichte der verknüpften Termine.
  final List<Report> reports;
}

class DiagnosisHubRepository {
  DiagnosisHubRepository(this._db);

  final AppDatabase _db;

  Stream<DiagnosisHub?> watch(String diagnosisId) {
    return _db.watchWith({
      _db.diagnoses,
      _db.appointments,
      _db.appointmentDiagnoses,
      _db.symptoms,
      _db.medications,
      _db.notes,
      _db.reports,
      _db.doctors,
    }, () => load(diagnosisId));
  }

  Future<DiagnosisHub?> load(String diagnosisId) async {
    final diagnosis = await (_db.select(
      _db.diagnoses,
    )..where((t) => t.id.equals(diagnosisId))).getSingleOrNull();
    if (diagnosis == null) return null;

    final appointmentRows =
        await (_db.select(_db.appointments).join([
                innerJoin(
                  _db.appointmentDiagnoses,
                  _db.appointmentDiagnoses.appointmentId.equalsExp(
                    _db.appointments.id,
                  ),
                ),
              ])
              ..where(_db.appointmentDiagnoses.diagnosisId.equals(diagnosisId))
              ..where(_db.appointments.archivedAt.isNull())
              ..orderBy([OrderingTerm.desc(_db.appointments.scheduledAt)]))
            .get();
    final appointments = [
      for (final row in appointmentRows) row.readTable(_db.appointments),
    ];
    final appointmentIds = appointments.map((a) => a.id).toList();

    return DiagnosisHub(
      diagnosis: diagnosis,
      appointments: await AppointmentRepository(
        _db,
      ).summariesFor(appointments),
      symptoms:
          await (_db.selectActive(_db.symptoms)
                ..where((t) => t.diagnosisId.equals(diagnosisId))
                ..orderBy([(t) => OrderingTerm.asc(t.label)]))
              .get(),
      medications:
          await (_db.selectActive(_db.medications)
                ..where((t) => t.diagnosisId.equals(diagnosisId))
                ..orderBy([(t) => OrderingTerm.asc(t.name)]))
              .get(),
      notes:
          await (_db.selectActive(_db.notes)
                ..where((t) => t.relatedDiagnosisId.equals(diagnosisId))
                ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
              .get(),
      reports: appointmentIds.isEmpty
          ? const []
          : await (_db.selectActive(_db.reports)
                  ..where((t) => t.appointmentId.isIn(appointmentIds))
                  ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
                .get(),
    );
  }
}
