import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../services/psych/psych_questionnaires.dart';
import '../app_database.dart';

const _uuid = Uuid();

/// Gespeicherter Fragebogen mit Ergebnis.
class PsychEntry {
  const PsychEntry(this.row, this.result);

  final PsychAssessment row;
  final PsychResult result;

  DateTime get recordedAt => row.recordedAt;
}

/// v15: Fragebögen zur Psyche (PHQ-9, GAD-7) und ihre Einstellung.
class PsychRepository {
  PsychRepository(this._db);

  final AppDatabase _db;

  Future<String> add(PsychResult result, {DateTime? at, String? note}) async {
    final id = _uuid.v4();
    await _db
        .into(_db.psychAssessments)
        .insert(
          PsychAssessmentsCompanion.insert(
            id: id,
            recordedAt: at ?? DateTime.now(),
            instrument: result.instrument.code,
            scores: result.encode(),
            note: Value(note?.trim().isEmpty == true ? null : note?.trim()),
          ),
        );
    return id;
  }

  Future<void> delete(String id) =>
      (_db.delete(_db.psychAssessments)..where((t) => t.id.equals(id))).go();

  /// Alle Bögen, ältester zuerst; unbekannte Instrumente werden übergangen.
  Future<List<PsychEntry>> all() async {
    final rows = await (_db.select(
      _db.psychAssessments,
    )..orderBy([(t) => OrderingTerm.asc(t.recordedAt)])).get();
    return [
      for (final r in rows)
        if (PsychInstrument.fromCode(r.instrument) case final i?)
          PsychEntry(r, PsychResult.parse(i, r.scores)),
    ];
  }

  Stream<List<PsychEntry>> watchAll() =>
      _db.watchWith({_db.psychAssessments}, all);

  Future<void> setQuestionnaires(bool enabled) =>
      (_db.update(_db.appSettings)..where((t) => t.id.equals(1))).write(
        AppSettingsCompanion(psychQuestionnaires: Value(enabled)),
      );
}
