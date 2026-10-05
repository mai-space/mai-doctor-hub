import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';

const _uuid = Uuid();

enum RecordSort { date, name, updated }

class RecordListItem {
  const RecordListItem({
    required this.entityType,
    required this.entityId,
    required this.title,
    required this.subtitle,
    required this.sortDate,
    this.icon,
  });

  final String entityType;
  final String entityId;
  final String title;
  final String subtitle;
  final DateTime sortDate;
  final String? icon;
}

class RecordsRepository {
  RecordsRepository(this._db);

  final AppDatabase _db;

  Future<List<QueryRow>> search(String query) {
    final tokens = query
        .trim()
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .map((t) {
          final cleaned = t.replaceAll('"', ' ');
          return cleaned.endsWith('*') ? cleaned : '$cleaned*';
        })
        .join(' ');
    return _db.searchFts(tokens);
  }

  Stream<List<Diagnose>> watchDiagnoses() {
    return (_db.select(_db.diagnoses)
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch();
  }

  Stream<List<Medication>> watchMedications() {
    return (_db.select(_db.medications)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Stream<List<Note>> watchNotes() {
    return (_db.select(_db.notes)
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch();
  }

  Stream<List<Report>> watchReports() {
    return (_db.select(_db.reports)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<List<Report>> reportsForAppointment(String appointmentId) {
    return (_db.select(_db.reports)
          ..where((t) => t.appointmentId.equals(appointmentId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Future<List<RecordListItem>> listAll({
    required RecordSort sort,
    String? entityType,
  }) async {
    final items = <RecordListItem>[];

    if (entityType == null || entityType == 'doctor') {
      final doctors = await _db.select(_db.doctors).get();
      for (final d in doctors) {
        items.add(
          RecordListItem(
            entityType: 'doctor',
            entityId: d.id,
            title: d.name,
            subtitle: [
              'Arzt',
              if (d.specialty != null) d.specialty!,
            ].join(' · '),
            sortDate: d.updatedAt,
          ),
        );
      }
    }
    if (entityType == null || entityType == 'diagnosis') {
      final diagnoses = await _db.select(_db.diagnoses).get();
      for (final d in diagnoses) {
        items.add(
          RecordListItem(
            entityType: 'diagnosis',
            entityId: d.id,
            title: d.title,
            subtitle: 'Diagnose · ${d.status.name}',
            sortDate: d.updatedAt,
          ),
        );
      }
    }
    if (entityType == null || entityType == 'symptom') {
      final symptoms = await _db.select(_db.symptoms).get();
      for (final s in symptoms) {
        items.add(
          RecordListItem(
            entityType: 'symptom',
            entityId: s.id,
            title: s.label,
            subtitle: s.healedAt == null
                ? 'Symptom · aktiv'
                : 'Symptom · geheilt',
            sortDate: s.updatedAt,
          ),
        );
      }
    }
    if (entityType == null || entityType == 'appointment') {
      final appointments = await _db.select(_db.appointments).get();
      for (final a in appointments) {
        items.add(
          RecordListItem(
            entityType: 'appointment',
            entityId: a.id,
            title: a.title ?? 'Termin',
            subtitle: 'Termin · ${_formatDate(a.scheduledAt)}',
            sortDate: a.scheduledAt,
          ),
        );
      }
    }
    if (entityType == null || entityType == 'report') {
      final reports = await _db.select(_db.reports).get();
      for (final r in reports) {
        items.add(
          RecordListItem(
            entityType: 'report',
            entityId: r.id,
            title: r.title,
            subtitle: 'Bericht · ${_formatDate(r.createdAt)}',
            sortDate: r.createdAt,
          ),
        );
      }
    }
    if (entityType == null || entityType == 'medication') {
      final meds = await _db.select(_db.medications).get();
      for (final m in meds) {
        items.add(
          RecordListItem(
            entityType: 'medication',
            entityId: m.id,
            title: m.name,
            subtitle: [
              'Medikament',
              if (m.dosage != null) m.dosage!,
            ].join(' · '),
            sortDate: m.createdAt,
          ),
        );
      }
    }
    if (entityType == null || entityType == 'note') {
      final notes = await _db.select(_db.notes).get();
      for (final n in notes) {
        final preview = n.body.length > 48
            ? '${n.body.substring(0, 48)}…'
            : n.body;
        items.add(
          RecordListItem(
            entityType: 'note',
            entityId: n.id,
            title: preview,
            subtitle: 'Notiz · ${_formatDate(n.updatedAt)}',
            sortDate: n.updatedAt,
          ),
        );
      }
    }

    items.sort((a, b) {
      switch (sort) {
        case RecordSort.name:
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        case RecordSort.updated:
        case RecordSort.date:
          return b.sortDate.compareTo(a.sortDate);
      }
    });
    return items;
  }

  String _formatDate(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    return '$d.$m.${dt.year}';
  }

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
