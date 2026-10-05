import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';

const _uuid = Uuid();

class RecordsRepository {
  RecordsRepository(this._db);

  final AppDatabase _db;

  Future<List<QueryRow>> search(String query) => _db.searchFts(query);

  Future<String> createDiagnosis({
    required String title,
    String? notes,
    DiagnosisStatus status = DiagnosisStatus.active,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    await _db
        .into(_db.diagnoses)
        .insert(
          DiagnosesCompanion.insert(
            id: id,
            title: title,
            notes: Value(notes),
            status: status,
            createdAt: now,
            updatedAt: now,
          ),
        );
    await _db.upsertFts(
      entityType: 'diagnosis',
      entityId: id,
      title: title,
      body: notes ?? '',
    );
    return id;
  }

  Future<String> createMedication({
    required String name,
    String? dosage,
    String? scheduleText,
    String? diagnosisId,
    String? notes,
  }) async {
    final id = _uuid.v4();
    await _db
        .into(_db.medications)
        .insert(
          MedicationsCompanion.insert(
            id: id,
            name: name,
            dosage: Value(dosage),
            scheduleText: Value(scheduleText),
            diagnosisId: Value(diagnosisId),
            notes: Value(notes),
            createdAt: DateTime.now(),
          ),
        );
    await _db.upsertFts(
      entityType: 'medication',
      entityId: id,
      title: name,
      body: [dosage, scheduleText, notes].whereType<String>().join(' '),
    );
    return id;
  }

  Future<String> createNote({
    required String body,
    String? relatedAppointmentId,
    String? relatedDiagnosisId,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    await _db
        .into(_db.notes)
        .insert(
          NotesCompanion.insert(
            id: id,
            body: body,
            relatedAppointmentId: Value(relatedAppointmentId),
            relatedDiagnosisId: Value(relatedDiagnosisId),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await _db.upsertFts(
      entityType: 'note',
      entityId: id,
      title: body.length > 40 ? '${body.substring(0, 40)}…' : body,
      body: body,
    );
    return id;
  }

  Future<String> createReport({
    required String title,
    required String mimeType,
    required String localPath,
    required ReportSource source,
    String? appointmentId,
    String? extractedText,
    int? pageCount,
  }) async {
    final id = _uuid.v4();
    await _db
        .into(_db.reports)
        .insert(
          ReportsCompanion.insert(
            id: id,
            appointmentId: Value(appointmentId),
            title: title,
            mimeType: mimeType,
            localPath: localPath,
            extractedText: Value(extractedText),
            pageCount: Value(pageCount),
            source: source,
            createdAt: DateTime.now(),
          ),
        );
    await _db.upsertFts(
      entityType: 'report',
      entityId: id,
      title: title,
      body: extractedText ?? '',
    );
    return id;
  }
}
