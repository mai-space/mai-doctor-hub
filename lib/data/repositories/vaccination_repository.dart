import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';

const _uuid = Uuid();

class VaccinationRepository {
  VaccinationRepository(this._db);

  final AppDatabase _db;

  Future<List<Vaccination>> all() =>
      (_db.selectActive(_db.vaccinations)
            ..orderBy([(t) => OrderingTerm.desc(t.administeredAt)]))
          .get();

  Stream<List<Vaccination>> watchAll() =>
      (_db.selectActive(_db.vaccinations)
            ..orderBy([(t) => OrderingTerm.desc(t.administeredAt)]))
          .watch();

  Future<Vaccination?> get(String id) => (_db.select(
    _db.vaccinations,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  /// Fällige bzw. bald fällige Auffrischungen (bis [within] voraus).
  Future<List<Vaccination>> due({
    Duration within = const Duration(days: 60),
    DateTime? now,
  }) async {
    final limit = (now ?? DateTime.now()).add(within);
    final rows = await (_db.selectActive(_db.vaccinations)
          ..where((t) => t.nextDueAt.isNotNull())
          ..where((t) => t.nextDueAt.isSmallerOrEqualValue(limit))
          ..orderBy([(t) => OrderingTerm.asc(t.nextDueAt)]))
        .get();
    // Nur die jeweils jüngste Impfung je Impfstoff zählt.
    final latest = <String, Vaccination>{};
    for (final v in await all()) {
      latest.putIfAbsent(v.vaccine.toLowerCase(), () => v);
    }
    return [
      for (final v in rows)
        if (latest[v.vaccine.toLowerCase()]?.id == v.id) v,
    ];
  }

  Future<String> save({
    String? id,
    required String vaccine,
    String? product,
    required DateTime administeredAt,
    int? doseNumber,
    String? batch,
    String? doctorId,
    DateTime? nextDueAt,
    String? notes,
  }) async {
    final vaccinationId = id ?? _uuid.v4();
    final now = DateTime.now();
    final companion = VaccinationsCompanion(
      vaccine: Value(vaccine),
      product: Value(product),
      administeredAt: Value(administeredAt),
      doseNumber: Value(doseNumber),
      batch: Value(batch),
      doctorId: Value(doctorId),
      nextDueAt: Value(nextDueAt),
      notes: Value(notes),
      updatedAt: Value(now),
    );
    if (id == null) {
      await _db
          .into(_db.vaccinations)
          .insert(
            companion.copyWith(id: Value(vaccinationId), createdAt: Value(now)),
          );
    } else {
      await (_db.update(
        _db.vaccinations,
      )..where((t) => t.id.equals(id))).write(companion);
    }
    await _db.upsertFts(
      entityType: 'vaccination',
      entityId: vaccinationId,
      title: vaccine,
      body: [product, batch, notes].whereType<String>().join(' '),
    );
    return vaccinationId;
  }

  Future<void> delete(String id) async {
    await (_db.delete(_db.vaccinations)..where((t) => t.id.equals(id))).go();
    await _db.deleteFts('vaccination', id);
  }
}
