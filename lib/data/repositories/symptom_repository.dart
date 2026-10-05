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
}
