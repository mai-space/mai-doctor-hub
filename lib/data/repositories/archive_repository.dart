import 'package:drift/drift.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../l10n/l10n.dart';
import '../app_database.dart';
import 'appointment_repository.dart';
import 'doctor_repository.dart';
import 'medication_repository.dart';
import 'records_repository.dart';
import 'symptom_repository.dart';
import 'vaccination_repository.dart';

/// Archivieren nicht möglich (z. B. Arzt mit aktiven Terminen).
class ArchiveBlocked implements Exception {
  const ArchiveBlocked(this.message);

  final String message;

  @override
  String toString() => 'ArchiveBlocked: $message';
}

class ArchivedItem {
  const ArchivedItem({
    required this.entityType,
    required this.id,
    required this.title,
    required this.archivedAt,
  });

  final String entityType;
  final String id;
  final String title;
  final DateTime archivedAt;
}

/// Papierkorb: Einträge werden archiviert (Soft Delete), lassen sich
/// wiederherstellen oder endgültig löschen.
class ArchiveRepository {
  ArchiveRepository(this._db);

  final AppDatabase _db;

  String _table(String type) {
    final table = AppDatabase.entityTables[type];
    if (table == null) throw ArgumentError('Unbekannter Typ $type');
    return table;
  }

  /// Archiviert den Eintrag. Ein Termin nimmt seine Berichte mit (gleicher
  /// Zeitstempel → gemeinsame Wiederherstellung).
  Future<DateTime> archive(String type, String id) async {
    if (type == 'doctor') {
      final active =
          await (_db.selectActive(_db.appointments)
                ..where((t) => t.doctorId.equals(id)))
              .get();
      if (active.isNotEmpty) {
        throw ArchiveBlocked(AppLocale.strings.homeArchiveBlockedDoctor);
      }
    }
    // Sekundengenau, wie drift Zeitstempel speichert.
    final now = DateTime.now();
    final stamp = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
      now.second,
    );
    final seconds = stamp.millisecondsSinceEpoch ~/ 1000;
    await _db.transaction(() async {
      await _db.customUpdate(
        'UPDATE ${_table(type)} SET archived_at = ? WHERE id = ?',
        variables: [Variable.withInt(seconds), Variable.withString(id)],
        updates: {_tableInfo(type)},
      );
      if (type == 'appointment') {
        await _db.customUpdate(
          'UPDATE reports SET archived_at = ? '
          'WHERE appointment_id = ? AND archived_at IS NULL',
          variables: [Variable.withInt(seconds), Variable.withString(id)],
          updates: {_db.reports},
        );
      }
    });
    return stamp;
  }

  Future<void> restore(String type, String id) async {
    final row = await _db
        .customSelect(
          'SELECT archived_at FROM ${_table(type)} WHERE id = ?',
          variables: [Variable.withString(id)],
        )
        .getSingleOrNull();
    final stamp = row?.read<int?>('archived_at');
    await _db.transaction(() async {
      await _db.customUpdate(
        'UPDATE ${_table(type)} SET archived_at = NULL WHERE id = ?',
        variables: [Variable.withString(id)],
        updates: {_tableInfo(type)},
      );
      if (type == 'appointment' && stamp != null) {
        await _db.customUpdate(
          'UPDATE reports SET archived_at = NULL '
          'WHERE appointment_id = ? AND archived_at = ?',
          variables: [Variable.withString(id), Variable.withInt(stamp)],
          updates: {_db.reports},
        );
      }
    });
  }

  /// Endgültig löschen (mit allen bisherigen Kaskaden).
  Future<void> purge(String type, String id) async {
    final records = RecordsRepository(_db);
    switch (type) {
      case 'doctor':
        if (!await DoctorRepository(_db).delete(id)) {
          throw ArchiveBlocked(
            AppLocale.strings.homeArchivePurgeBlockedDoctor,
          );
        }
      case 'diagnosis':
        await records.deleteDiagnosis(id);
      case 'symptom':
        await SymptomRepository(_db).delete(id);
      case 'appointment':
        await AppointmentRepository(_db).delete(id);
      case 'report':
        await records.deleteReport(id);
      case 'medication':
        await records.deleteMedication(id);
      case 'note':
        await records.deleteNote(id);
      case 'pharmacy':
        await PharmacyRepository(_db).delete(id);
      case 'vaccination':
        await VaccinationRepository(_db).delete(id);
      default:
        throw ArgumentError('Unbekannter Typ $type');
    }
  }

  /// Leert das Archiv; Ärzte zuletzt (Termine verweisen auf sie).
  /// Gibt die Zahl gelöschter Einträge zurück.
  Future<int> purgeAll() async {
    var count = 0;
    final items = await archived();
    items.sort(
      (a, b) => (a.entityType == 'doctor' ? 1 : 0).compareTo(
        b.entityType == 'doctor' ? 1 : 0,
      ),
    );
    for (final item in items) {
      try {
        await purge(item.entityType, item.id);
        count++;
      } on ArchiveBlocked {
        // Arzt mit aktiven Terminen bleibt im Archiv.
      }
    }
    return count;
  }

  Stream<List<ArchivedItem>> watchArchived() =>
      _db.watchWith(_db.archivableTables.toSet(), archived);

  Future<List<ArchivedItem>> archived() async {
    Future<List<ArchivedItem>> load(
      String type,
      String sql,
      String Function(QueryRow r) title,
    ) async => [
      for (final r in await _db.customSelect(sql).get())
        ArchivedItem(
          entityType: type,
          id: r.read<String>('id'),
          title: title(r),
          archivedAt: DateTime.fromMillisecondsSinceEpoch(
            r.read<int>('archived_at') * 1000,
          ),
        ),
    ];
    String w(String table, String columns) =>
        'SELECT id, archived_at, $columns FROM $table '
        'WHERE archived_at IS NOT NULL';
    DateTime d(QueryRow r, String c) =>
        DateTime.fromMillisecondsSinceEpoch(r.read<int>(c) * 1000);
    final strings = AppLocale.strings;
    final date = DateFormat(strings.homeArchiveDatePattern);

    final items = [
      ...await load('doctor', w('doctors', 'name'), (r) => r.read('name')),
      ...await load(
        'diagnosis',
        w('diagnoses', 'title'),
        (r) => r.read('title'),
      ),
      ...await load('symptom', w('symptoms', 'label'), (r) => r.read('label')),
      ...await load(
        'appointment',
        w('appointments', 'title, scheduled_at'),
        (r) =>
            '${r.read<String?>('title') ?? strings.entityAppointment} · '
            '${date.format(d(r, 'scheduled_at'))}',
      ),
      ...await load('report', w('reports', 'title'), (r) => r.read('title')),
      ...await load(
        'medication',
        w('medications', 'name'),
        (r) => r.read('name'),
      ),
      ...await load('note', w('notes', 'body'), (r) {
        final body = r.read<String>('body');
        return body.length > 50 ? '${body.substring(0, 50)}…' : body;
      }),
      ...await load(
        'pharmacy',
        w('pharmacies', 'name'),
        (r) => r.read('name'),
      ),
      ...await load(
        'vaccination',
        w('vaccinations', 'vaccine, administered_at'),
        (r) =>
            '${r.read<String>('vaccine')} · '
            '${date.format(d(r, 'administered_at'))}',
      ),
    ];
    items.sort((a, b) => b.archivedAt.compareTo(a.archivedAt));
    return items;
  }

  TableInfo<Table, dynamic> _tableInfo(String type) => _db.archivableTables
      .firstWhere((t) => t.actualTableName == _table(type));
}
