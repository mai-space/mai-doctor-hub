import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';

const _uuid = Uuid();

String diagnosisStatusLabel(DiagnosisStatus status) => switch (status) {
  DiagnosisStatus.active => 'aktiv',
  DiagnosisStatus.resolved => 'abgeschlossen',
};

enum RecordSort { date, name, updated }

class RecordListItem {
  const RecordListItem({
    required this.entityType,
    required this.entityId,
    required this.title,
    required this.subtitle,
    required this.sortDate,
    DateTime? updatedAt,
    this.icon,
  }) : updatedAt = updatedAt ?? sortDate;

  final String entityType;
  final String entityId;
  final String title;
  final String subtitle;
  final DateTime sortDate;
  final DateTime updatedAt;
  final String? icon;
}

class RecordsRepository {
  RecordsRepository(this._db);

  final AppDatabase _db;

  Future<List<QueryRow>> search(String query, {String? entityType}) async {
    final tokens = query
        .trim()
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .map((t) {
          final cleaned = t.replaceAll('"', ' ');
          return cleaned.endsWith('*') ? cleaned : '$cleaned*';
        })
        .join(' ');
    return _withoutArchived(
      await _db.searchFts(tokens, entityType: entityType, limit: 200),
    );
  }

  /// Treffer für *irgendeinen* der Begriffe (für Fragen in Alltagssprache),
  /// nach Relevanz sortiert.
  Future<List<QueryRow>> searchAny(Iterable<String> terms, {int limit = 8}) async {
    final query = [
      for (final term in terms)
        if (term.isNotEmpty) '"${term.replaceAll('"', '')}"*',
    ].join(' OR ');
    if (query.isEmpty) return const [];
    final rows = await _withoutArchived(
      await _db.searchFts(query, limit: 200),
    );
    return rows.take(limit).toList();
  }

  Future<List<QueryRow>> _withoutArchived(List<QueryRow> rows) async {
    // Archivierte Einträge bleiben im Index (für die Wiederherstellung),
    // werden aber nicht gefunden.
    final archived = <String>{};
    for (final type in rows.map((r) => r.read<String>('entity_type')).toSet()) {
      final table = AppDatabase.entityTables[type];
      if (table == null) continue;
      final ids = await _db
          .customSelect('SELECT id FROM $table WHERE archived_at IS NOT NULL')
          .get();
      archived.addAll(ids.map((r) => '$type:${r.read<String>('id')}'));
    }
    return rows
        .where(
          (r) => !archived.contains(
            '${r.read<String>('entity_type')}:${r.read<String>('entity_id')}',
          ),
        )
        .take(50)
        .toList();
  }

  /// Wie [listAll], aber reaktiv auf alle Akten-Tabellen.
  Stream<List<RecordListItem>> watchAll({
    required RecordSort sort,
    String? entityType,
  }) {
    return _db
        .watchTables({
          _db.doctors,
          _db.diagnoses,
          _db.symptoms,
          _db.appointments,
          _db.reports,
          _db.medications,
          _db.notes,
          _db.pharmacies,
          _db.vaccinations,
        })
        .asyncMap((_) => listAll(sort: sort, entityType: entityType));
  }

  Stream<List<Diagnose>> watchDiagnoses() {
    return (_db.selectActive(_db.diagnoses)
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch();
  }

  Stream<List<Medication>> watchMedications() {
    return (_db.selectActive(_db.medications)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Stream<List<Note>> watchNotes() {
    return (_db.selectActive(_db.notes)
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .watch();
  }

  Stream<List<Report>> watchReports() {
    return (_db.selectActive(_db.reports)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<List<Report>> reportsForAppointment(String appointmentId) {
    return (_db.selectActive(_db.reports)
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
      final doctors = await _db.selectActive(_db.doctors).get();
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
            sortDate: d.createdAt,
            updatedAt: d.updatedAt,
          ),
        );
      }
    }
    if (entityType == null || entityType == 'diagnosis') {
      final diagnoses = await _db.selectActive(_db.diagnoses).get();
      for (final d in diagnoses) {
        items.add(
          RecordListItem(
            entityType: 'diagnosis',
            entityId: d.id,
            title: d.title,
            subtitle: 'Diagnose · ${diagnosisStatusLabel(d.status)}',
            sortDate: d.startedAt ?? d.createdAt,
            updatedAt: d.updatedAt,
          ),
        );
      }
    }
    if (entityType == null || entityType == 'symptom') {
      final symptoms = await _db.selectActive(_db.symptoms).get();
      for (final s in symptoms) {
        items.add(
          RecordListItem(
            entityType: 'symptom',
            entityId: s.id,
            title: s.label,
            subtitle: s.healedAt == null
                ? 'Symptom · aktiv'
                : 'Symptom · geheilt',
            sortDate: s.createdAt,
            updatedAt: s.updatedAt,
          ),
        );
      }
    }
    if (entityType == null || entityType == 'appointment') {
      final appointments = await _db.selectActive(_db.appointments).get();
      for (final a in appointments) {
        items.add(
          RecordListItem(
            entityType: 'appointment',
            entityId: a.id,
            title: a.title ?? 'Termin',
            subtitle: 'Termin · ${_formatDate(a.scheduledAt)}',
            sortDate: a.scheduledAt,
            updatedAt: a.updatedAt,
          ),
        );
      }
    }
    if (entityType == null || entityType == 'report') {
      final reports = await _db.selectActive(_db.reports).get();
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
      final meds = await _db.selectActive(_db.medications).get();
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
            sortDate: m.startedAt ?? m.createdAt,
            updatedAt: m.createdAt,
          ),
        );
      }
    }
    if (entityType == null || entityType == 'pharmacy') {
      final pharmacies = await _db.selectActive(_db.pharmacies).get();
      for (final p in pharmacies) {
        items.add(
          RecordListItem(
            entityType: 'pharmacy',
            entityId: p.id,
            title: p.name,
            subtitle: ['Apotheke', ?p.address].join(' · '),
            sortDate: p.createdAt,
            updatedAt: p.updatedAt,
          ),
        );
      }
    }
    if (entityType == null || entityType == 'vaccination') {
      final vaccinations = await _db.selectActive(_db.vaccinations).get();
      for (final v in vaccinations) {
        items.add(
          RecordListItem(
            entityType: 'vaccination',
            entityId: v.id,
            title: v.vaccine,
            subtitle: [
              'Impfung',
              _formatDate(v.administeredAt),
              if (v.doseNumber != null) '${v.doseNumber}. Dosis',
            ].join(' · '),
            sortDate: v.administeredAt,
            updatedAt: v.updatedAt,
          ),
        );
      }
    }
    if (entityType == null || entityType == 'note') {
      final notes = await _db.selectActive(_db.notes).get();
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
            sortDate: n.createdAt,
            updatedAt: n.updatedAt,
          ),
        );
      }
    }

    items.sort((a, b) {
      switch (sort) {
        case RecordSort.name:
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        case RecordSort.updated:
          return b.updatedAt.compareTo(a.updatedAt);
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

  // --- Diagnosen ---------------------------------------------------------

  Future<Diagnose?> getDiagnosis(String id) => (_db.select(
    _db.diagnoses,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> updateDiagnosis({
    required String id,
    required String title,
    String? notes,
    required DiagnosisStatus status,
    DateTime? startedAt,
    DateTime? endedAt,
  }) async {
    await (_db.update(_db.diagnoses)..where((t) => t.id.equals(id))).write(
      DiagnosesCompanion(
        title: Value(title),
        notes: Value(notes),
        status: Value(status),
        startedAt: Value(startedAt),
        endedAt: Value(endedAt),
        updatedAt: Value(DateTime.now()),
      ),
    );
    await _db.upsertFts(
      entityType: 'diagnosis',
      entityId: id,
      title: title,
      body: notes ?? '',
    );
  }

  /// Löscht die Diagnose; verknüpfte Symptome/Medikamente/Notizen bleiben.
  Future<void> deleteDiagnosis(String id) async {
    await _db.transaction(() async {
      await (_db.delete(
        _db.appointmentDiagnoses,
      )..where((t) => t.diagnosisId.equals(id))).go();
      await (_db.update(_db.symptoms)..where((t) => t.diagnosisId.equals(id)))
          .write(const SymptomsCompanion(diagnosisId: Value(null)));
      await (_db.update(_db.medications)
            ..where((t) => t.diagnosisId.equals(id)))
          .write(const MedicationsCompanion(diagnosisId: Value(null)));
      await (_db.update(_db.notes)
            ..where((t) => t.relatedDiagnosisId.equals(id)))
          .write(const NotesCompanion(relatedDiagnosisId: Value(null)));
      await (_db.delete(_db.diagnoses)..where((t) => t.id.equals(id))).go();
      await _db.deleteFts('diagnosis', id);
    });
  }

  // --- Medikamente -------------------------------------------------------

  Future<Medication?> getMedication(String id) => (_db.select(
    _db.medications,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> updateMedication({
    required String id,
    required String name,
    String? dosage,
    String? scheduleText,
    String? diagnosisId,
    DateTime? startedAt,
    DateTime? endedAt,
    String? notes,
  }) async {
    await (_db.update(_db.medications)..where((t) => t.id.equals(id))).write(
      MedicationsCompanion(
        name: Value(name),
        dosage: Value(dosage),
        scheduleText: Value(scheduleText),
        diagnosisId: Value(diagnosisId),
        startedAt: Value(startedAt),
        endedAt: Value(endedAt),
        notes: Value(notes),
      ),
    );
    await _db.upsertFts(
      entityType: 'medication',
      entityId: id,
      title: name,
      body: [dosage, scheduleText, notes].whereType<String>().join(' '),
    );
  }

  Future<void> deleteMedication(String id) => _db.transaction(() async {
    await (_db.delete(
      _db.medicationSchedules,
    )..where((t) => t.medicationId.equals(id))).go();
    await (_db.delete(
      _db.medicationIntakes,
    )..where((t) => t.medicationId.equals(id))).go();
    await (_db.delete(_db.medications)..where((t) => t.id.equals(id))).go();
    await _db.deleteFts('medication', id);
  });

  // --- Notizen -----------------------------------------------------------

  Future<Note?> getNote(String id) => (_db.select(
    _db.notes,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<void> updateNote({
    required String id,
    required String body,
    String? relatedAppointmentId,
    String? relatedDiagnosisId,
  }) async {
    await (_db.update(_db.notes)..where((t) => t.id.equals(id))).write(
      NotesCompanion(
        body: Value(body),
        relatedAppointmentId: Value(relatedAppointmentId),
        relatedDiagnosisId: Value(relatedDiagnosisId),
        updatedAt: Value(DateTime.now()),
      ),
    );
    await _db.upsertFts(
      entityType: 'note',
      entityId: id,
      title: body.length > 40 ? '${body.substring(0, 40)}…' : body,
      body: body,
    );
  }

  Future<void> deleteNote(String id) async {
    await (_db.delete(_db.notes)..where((t) => t.id.equals(id))).go();
    await _db.deleteFts('note', id);
  }

  // --- Berichte ----------------------------------------------------------

  Future<Report?> getReport(String id) => (_db.select(
    _db.reports,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<List<Report>> allReports() => _db.select(_db.reports).get();

  Future<void> updateReport({
    required String id,
    required String title,
    String? appointmentId,
  }) async {
    await (_db.update(_db.reports)..where((t) => t.id.equals(id))).write(
      ReportsCompanion(title: Value(title), appointmentId: Value(appointmentId)),
    );
    final report = await getReport(id);
    await _db.upsertFts(
      entityType: 'report',
      entityId: id,
      title: title,
      body: report?.extractedText ?? '',
    );
  }

  /// Speichert (neu) extrahierten Text und aktualisiert den Suchindex.
  Future<void> setReportText(String id, String? text, int? pageCount) async {
    await (_db.update(_db.reports)..where((t) => t.id.equals(id))).write(
      ReportsCompanion(extractedText: Value(text), pageCount: Value(pageCount)),
    );
    final report = await getReport(id);
    if (report == null) return;
    await _db.upsertFts(
      entityType: 'report',
      entityId: id,
      title: report.title,
      body: text ?? '',
    );
  }

  Future<void> deleteReport(String id) async {
    final report = await getReport(id);
    if (report == null) return;
    await deleteReportRow(id);
    await deleteReportFile(report);
  }

  /// Nur DB-Zeile + Index (für Transaktionen); Datei separat löschen.
  Future<void> deleteReportRow(String id) async {
    await (_db.delete(_db.reports)..where((t) => t.id.equals(id))).go();
    await _db.deleteFts('report', id);
  }

  Future<void> deleteReportFile(Report report) async {
    if (kIsWeb || report.localPath.startsWith('web-memory://')) return;
    try {
      final file = File(report.localPath);
      if (await file.exists()) await file.delete();
    } catch (_) {
      // Datei bereits weg oder nicht zugreifbar — DB ist maßgeblich.
    }
  }
}
