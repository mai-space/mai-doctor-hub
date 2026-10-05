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
