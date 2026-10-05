import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';

const _uuid = Uuid();

class SymptomRepository {
  SymptomRepository(this._db);

  final AppDatabase _db;

  Stream<List<Symptom>> watchOpen() {
    return (_db.select(_db.symptoms)
          ..where((t) => t.healedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.label)]))
        .watch();
  }

  Stream<List<Symptom>> watchAll() {
    return (_db.select(_db.symptoms)
          ..orderBy([(t) => OrderingTerm.asc(t.label)]))
        .watch();
  }

  Future<String> create({
    required String label,
    String? diagnosisId,
    String? bodyRegion,
    CheckInCadence cadence = CheckInCadence.daily,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    await _db
        .into(_db.symptoms)
        .insert(
          SymptomsCompanion.insert(
            id: id,
            label: label,
            diagnosisId: Value(diagnosisId),
            bodyRegion: Value(bodyRegion),
            checkInCadence: cadence,
            createdAt: now,
            updatedAt: now,
          ),
        );
    await _db.upsertFts(
      entityType: 'symptom',
      entityId: id,
      title: label,
      body: bodyRegion ?? '',
    );
    return id;
  }

  Future<void> markHealed(String id) async {
    final now = DateTime.now();
    await (_db.update(_db.symptoms)..where((t) => t.id.equals(id))).write(
      SymptomsCompanion(healedAt: Value(now), updatedAt: Value(now)),
    );
  }

  Future<void> reopen(String id) async {
    await (_db.update(_db.symptoms)..where((t) => t.id.equals(id))).write(
      SymptomsCompanion(
        healedAt: const Value(null),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<Symptom?> getById(String id) => (_db.select(
    _db.symptoms,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> update({
    required String id,
    required String label,
    String? bodyRegion,
    String? diagnosisId,
    CheckInCadence? cadence,
  }) async {
    await (_db.update(_db.symptoms)..where((t) => t.id.equals(id))).write(
      SymptomsCompanion(
        label: Value(label),
        bodyRegion: Value(bodyRegion),
        diagnosisId: Value(diagnosisId),
        checkInCadence: cadence == null
            ? const Value.absent()
            : Value(cadence),
        updatedAt: Value(DateTime.now()),
      ),
    );
    await _db.upsertFts(
      entityType: 'symptom',
      entityId: id,
      title: label,
      body: bodyRegion ?? '',
    );
  }

  /// Löscht Symptom inkl. aller Check-in-Werte und Terminverknüpfungen.
  Future<void> delete(String id) async {
    await _db.transaction(() async {
      await (_db.delete(
        _db.doctorSymptoms,
      )..where((t) => t.symptomId.equals(id))).go();
      await (_db.delete(
        _db.reminderSymptoms,
      )..where((t) => t.symptomId.equals(id))).go();
      await (_db.delete(
        _db.symptomObservations,
      )..where((t) => t.symptomId.equals(id))).go();
      await (_db.delete(
        _db.appointmentSymptoms,
      )..where((t) => t.symptomId.equals(id))).go();
      await (_db.delete(_db.symptoms)..where((t) => t.id.equals(id))).go();
      await _db.deleteFts('symptom', id);
    });
  }

  /// Check-in-Verlauf eines Symptoms, älteste zuerst.
  Stream<List<SymptomObservation>> watchObservations(String symptomId) {
    return (_db.select(_db.symptomObservations)
          ..where((t) => t.symptomId.equals(symptomId))
          ..orderBy([(t) => OrderingTerm.asc(t.recordedAt)]))
        .watch();
  }

  Future<void> deleteObservation(String id) async {
    await (_db.delete(
      _db.symptomObservations,
    )..where((t) => t.id.equals(id))).go();
  }

  Future<String> addObservation({
    required String symptomId,
    required ObservationKind kind,
    double? valueNumber,
    String? valueText,
    String? valueColor,
    String? unit,
    String? note,
    DateTime? recordedAt,
  }) async {
    final id = _uuid.v4();
    await _db
        .into(_db.symptomObservations)
        .insert(
          SymptomObservationsCompanion.insert(
            id: id,
            symptomId: symptomId,
            recordedAt: recordedAt ?? DateTime.now(),
            kind: kind,
            valueNumber: Value(valueNumber),
            valueText: Value(valueText),
            valueColor: Value(valueColor),
            unit: Value(unit),
            note: Value(note),
          ),
        );
    return id;
  }

  // --- Ärzte (n:m) ---------------------------------------------------------

  Future<List<Doctor>> doctorsFor(String symptomId) async {
    final rows = await (_db.select(_db.doctorSymptoms).join([
      innerJoin(
        _db.doctors,
        _db.doctors.id.equalsExp(_db.doctorSymptoms.doctorId),
      ),
    ])..where(_db.doctorSymptoms.symptomId.equals(symptomId))).get();
    return [for (final r in rows) r.readTable(_db.doctors)];
  }

  Future<void> setDoctors(String symptomId, List<String> doctorIds) =>
      _db.transaction(() async {
        await (_db.delete(
          _db.doctorSymptoms,
        )..where((t) => t.symptomId.equals(symptomId))).go();
        for (final doctorId in doctorIds.toSet()) {
          await _db
              .into(_db.doctorSymptoms)
              .insert(
                DoctorSymptomsCompanion.insert(
                  doctorId: doctorId,
                  symptomId: symptomId,
                ),
              );
        }
      });

  Future<void> linkDoctor(String doctorId, String symptomId) => _db
      .into(_db.doctorSymptoms)
      .insert(
        DoctorSymptomsCompanion.insert(doctorId: doctorId, symptomId: symptomId),
        mode: InsertMode.insertOrIgnore,
      );

  Future<void> unlinkDoctor(String doctorId, String symptomId) =>
      (_db.delete(_db.doctorSymptoms)..where(
            (t) => t.doctorId.equals(doctorId) & t.symptomId.equals(symptomId),
          ))
          .go();

  /// Symptome eines Arztes: direkt zugeordnet **oder** über seine Termine.
  /// Bool = direkt zugeordnet.
  Future<List<(Symptom, bool)>> symptomsForDoctor(String doctorId) async {
    final direct = await (_db.select(_db.doctorSymptoms).join([
      innerJoin(
        _db.symptoms,
        _db.symptoms.id.equalsExp(_db.doctorSymptoms.symptomId),
      ),
    ])..where(_db.doctorSymptoms.doctorId.equals(doctorId))).get();
    final viaAppointments = await (_db.select(_db.appointmentSymptoms).join([
      innerJoin(
        _db.appointments,
        _db.appointments.id.equalsExp(_db.appointmentSymptoms.appointmentId),
      ),
      innerJoin(
        _db.symptoms,
        _db.symptoms.id.equalsExp(_db.appointmentSymptoms.symptomId),
      ),
    ])..where(_db.appointments.doctorId.equals(doctorId))).get();
    final result = <String, (Symptom, bool)>{};
    for (final r in viaAppointments) {
      final s = r.readTable(_db.symptoms);
      result[s.id] = (s, false);
    }
    for (final r in direct) {
      final s = r.readTable(_db.symptoms);
      result[s.id] = (s, true);
    }
    return result.values.toList()
      ..sort((a, b) => a.$1.label.toLowerCase().compareTo(b.$1.label.toLowerCase()));
  }

  /// Gemeldete Check-ins im Zeitraum [from, to), älteste zuerst.
  Future<List<SymptomObservation>> observationsBetween(
    String symptomId,
    DateTime from,
    DateTime to,
  ) =>
      (_db.select(_db.symptomObservations)
            ..where((t) => t.symptomId.equals(symptomId))
            ..where((t) => t.recordedAt.isBiggerOrEqualValue(from))
            ..where((t) => t.recordedAt.isSmallerThanValue(to))
            ..orderBy([(t) => OrderingTerm.asc(t.recordedAt)]))
          .get();
}
