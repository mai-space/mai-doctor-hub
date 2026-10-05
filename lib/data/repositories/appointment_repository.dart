import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';

const _uuid = Uuid();

class AppointmentRepository {
  AppointmentRepository(this._db);

  final AppDatabase _db;

  Stream<List<Appointment>> watchUpcoming({DateTime? from}) {
    final start = from ?? DateTime.now();
    return (_db.select(_db.appointments)
          ..where((t) => t.scheduledAt.isBiggerOrEqualValue(start))
          ..where((t) => t.status.equalsValue(AppointmentStatus.planned))
          ..orderBy([(t) => OrderingTerm.asc(t.scheduledAt)]))
        .watch();
  }

  Stream<List<Appointment>> watchPast({DateTime? until}) {
    final end = until ?? DateTime.now();
    return (_db.select(_db.appointments)
          ..where((t) => t.scheduledAt.isSmallerThanValue(end))
          ..orderBy([(t) => OrderingTerm.desc(t.scheduledAt)]))
        .watch();
  }

  Future<List<Appointment>> forDay(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    return (_db.select(_db.appointments)
          ..where((t) => t.scheduledAt.isBiggerOrEqualValue(start))
          ..where((t) => t.scheduledAt.isSmallerThanValue(end))
          ..orderBy([(t) => OrderingTerm.asc(t.scheduledAt)]))
        .get();
  }

  Future<String> create({
    required String doctorId,
    required DateTime scheduledAt,
    String? title,
    String? notes,
    int? durationMin,
    List<String> diagnosisIds = const [],
    List<String> symptomIds = const [],
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    await _db.transaction(() async {
      await _db
          .into(_db.appointments)
          .insert(
            AppointmentsCompanion.insert(
              id: id,
              doctorId: doctorId,
              scheduledAt: scheduledAt,
              durationMin: Value(durationMin),
              title: Value(title),
              notes: Value(notes),
              status: AppointmentStatus.planned,
              createdAt: now,
              updatedAt: now,
            ),
          );
      for (final diagnosisId in diagnosisIds) {
        await _db
            .into(_db.appointmentDiagnoses)
            .insert(
              AppointmentDiagnosesCompanion.insert(
                appointmentId: id,
                diagnosisId: diagnosisId,
              ),
            );
      }
      for (final symptomId in symptomIds) {
        await _db
            .into(_db.appointmentSymptoms)
            .insert(
              AppointmentSymptomsCompanion.insert(
                appointmentId: id,
                symptomId: symptomId,
              ),
            );
      }
      await _db.upsertFts(
        entityType: 'appointment',
        entityId: id,
        title: title ?? 'Termin',
        body: notes ?? '',
      );
    });
    return id;
  }
}
