import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';
import 'suggestion_repository.dart';
import 'symptom_media_repository.dart';

const _uuid = Uuid();

/// v12: Felder der strukturierten Symptom-Beschreibung (für Vorschläge).
enum DescriptorField { sensation, quality, location, pattern }

class SymptomRepository {
  SymptomRepository(this._db);

  final AppDatabase _db;

  Stream<List<Symptom>> watchOpen() {
    return (_db.selectActive(_db.symptoms)
          ..where((t) => t.healedAt.isNull())
          ..orderBy([(t) => OrderingTerm.asc(t.label)]))
        .watch();
  }

  Stream<List<Symptom>> watchAll() {
    return (_db.selectActive(_db.symptoms)
          ..orderBy([(t) => OrderingTerm.asc(t.label)]))
        .watch();
  }

  Future<String> create({
    required String label,
    String? diagnosisId,
    String? bodyRegion,
    CheckInCadence cadence = CheckInCadence.daily,
    String? sensation,
    String? quality,
    BodySide? side,
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
            sensation: Value(sensation),
            quality: Value(quality),
            side: Value(side?.name),
          ),
        );
    await _db.upsertFts(
      entityType: 'symptom',
      entityId: id,
      title: label,
      body: _ftsBody(bodyRegion, sensation, quality),
    );
    return id;
  }

  /// Suchtext: Ort plus Standard-Beschreibung (Empfindung, Qualität).
  static String _ftsBody(
    String? bodyRegion,
    String? sensation,
    String? quality,
  ) => [?bodyRegion, ?sensation, ?quality].join(' ');

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
    String? sensation,
    String? quality,
    BodySide? side,
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
        sensation: Value(sensation),
        quality: Value(quality),
        side: Value(side?.name),
      ),
    );
    await _db.upsertFts(
      entityType: 'symptom',
      entityId: id,
      title: label,
      body: _ftsBody(bodyRegion, sensation, quality),
    );
  }

  /// Löscht Symptom inkl. aller Check-in-Werte und Terminverknüpfungen.
  Future<void> delete(String id) async {
    // Belege: Dateien erst nach erfolgreichem Löschen der Zeilen entfernen.
    final media = await SymptomMediaRepository(_db).forSymptom(id);
    await _db.transaction(() async {
      await (_db.delete(
        _db.symptomMedia,
      )..where((t) => t.symptomId.equals(id))).go();
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
    for (final item in media) {
      await deleteMediaFile(item.localPath);
    }
  }

  /// Check-in-Verlauf eines Symptoms, älteste zuerst.
  Stream<List<SymptomObservation>> watchObservations(String symptomId) {
    return (_db.select(_db.symptomObservations)
          ..where((t) => t.symptomId.equals(symptomId))
          ..orderBy([(t) => OrderingTerm.asc(t.recordedAt)]))
        .watch();
  }

  /// Früher verwendete Werte eines Beschreibungs-Felds (Check-ins und
  /// Symptom-Vorgaben), neueste zuerst; Mehrfachwerte einzeln, ohne Doppelte.
  Future<List<String>> usedDescriptors(
    DescriptorField field, {
    int limit = 12,
  }) async {
    final (observationColumn, symptomColumn) = switch (field) {
      DescriptorField.sensation => ('sensation', 'sensation'),
      DescriptorField.quality => ('quality', 'quality'),
      DescriptorField.location => ('location', 'body_region'),
      DescriptorField.pattern => ('pattern', null),
    };
    final symptomPart = symptomColumn == null
        ? ''
        : 'UNION ALL SELECT $symptomColumn, updated_at FROM symptoms '
              'WHERE archived_at IS NULL';
    final rows = await _db.customSelect('''
      SELECT v FROM (
        SELECT $observationColumn AS v, recorded_at AS t
        FROM symptom_observations
        $symptomPart
      )
      WHERE v IS NOT NULL AND TRIM(v) <> ''
      ORDER BY t DESC
      LIMIT 300
      ''', readsFrom: {}).get();
    final seen = <String>{};
    final result = <String>[];
    for (final row in rows) {
      for (final part in row.read<String>('v').split(',')) {
        final value = part.trim();
        if (value.isEmpty) continue;
        if (!seen.add(SuggestionRepository.normalize(value))) continue;
        result.add(value);
        if (result.length >= limit) return result;
      }
    }
    return result;
  }

  /// Letzter Check-in eines Symptoms (Vorbelegung des nächsten).
  Future<SymptomObservation?> latestObservation(String symptomId) =>
      (_db.select(_db.symptomObservations)
            ..where((t) => t.symptomId.equals(symptomId))
            ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)])
            ..limit(1))
          .getSingleOrNull();

  Future<void> deleteObservation(String id) async {
    // Belege bleiben beim Symptom, nur die Zuordnung zum Check-in fällt weg.
    await (_db.update(_db.symptomMedia)
          ..where((t) => t.observationId.equals(id)))
        .write(const SymptomMediaCompanion(observationId: Value(null)));
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
    String? sensation,
    String? quality,
    String? location,
    BodySide? side,
    String? pattern,
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
            sensation: Value(sensation),
            quality: Value(quality),
            location: Value(location),
            side: Value(side?.name),
            pattern: Value(pattern),
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
    ])
          ..where(_db.doctorSymptoms.symptomId.equals(symptomId))
          ..where(_db.doctors.archivedAt.isNull()))
        .get();
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
    ])
          ..where(_db.doctorSymptoms.doctorId.equals(doctorId))
          ..where(_db.symptoms.archivedAt.isNull()))
        .get();
    final viaAppointments = await (_db.select(_db.appointmentSymptoms).join([
      innerJoin(
        _db.appointments,
        _db.appointments.id.equalsExp(_db.appointmentSymptoms.appointmentId),
      ),
      innerJoin(
        _db.symptoms,
        _db.symptoms.id.equalsExp(_db.appointmentSymptoms.symptomId),
      ),
    ])
          ..where(_db.appointments.doctorId.equals(doctorId))
          ..where(_db.appointments.archivedAt.isNull())
          ..where(_db.symptoms.archivedAt.isNull()))
        .get();
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
