import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';

const _uuid = Uuid();

class DoctorRepository {
  DoctorRepository(this._db);

  final AppDatabase _db;

  Stream<List<Doctor>> watchAll() {
    return (_db.select(_db.doctors)
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .watch();
  }

  Future<Doctor?> getById(String id) {
    return (_db.select(_db.doctors)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<String> create({
    required String name,
    String? specialty,
    String? practiceName,
    String? phone,
    String? address,
    String? notes,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    await _db
        .into(_db.doctors)
        .insert(
          DoctorsCompanion.insert(
            id: id,
            name: name,
            specialty: Value(specialty),
            practiceName: Value(practiceName),
            phone: Value(phone),
            address: Value(address),
            notes: Value(notes),
            createdAt: now,
            updatedAt: now,
          ),
        );
    await _db.upsertFts(
      entityType: 'doctor',
      entityId: id,
      title: name,
      body: [specialty, practiceName, notes].whereType<String>().join(' '),
    );
    return id;
  }

  Future<void> update({
    required String id,
    required String name,
    String? specialty,
    String? practiceName,
    String? phone,
    String? address,
    String? notes,
  }) async {
    await (_db.update(_db.doctors)..where((t) => t.id.equals(id))).write(
      DoctorsCompanion(
        name: Value(name),
        specialty: Value(specialty),
        practiceName: Value(practiceName),
        phone: Value(phone),
        address: Value(address),
        notes: Value(notes),
        updatedAt: Value(DateTime.now()),
      ),
    );
    await _db.upsertFts(
      entityType: 'doctor',
      entityId: id,
      title: name,
      body: [specialty, practiceName, notes].whereType<String>().join(' '),
    );
  }

  Future<int> appointmentCount(String id) async {
    final count = _db.appointments.id.count();
    final row =
        await (_db.selectOnly(_db.appointments)
              ..addColumns([count])
              ..where(_db.appointments.doctorId.equals(id)))
            .getSingle();
    return row.read(count) ?? 0;
  }

  /// Löscht den Arzt nur, wenn keine Termine mehr auf ihn verweisen.
  /// Gibt `false` zurück, wenn noch Termine existieren.
  Future<bool> delete(String id) async {
    if (await appointmentCount(id) > 0) return false;
    await (_db.delete(
      _db.doctorSymptoms,
    )..where((t) => t.doctorId.equals(id))).go();
    await (_db.delete(_db.doctors)..where((t) => t.id.equals(id))).go();
    await _db.deleteFts('doctor', id);
    return true;
  }
}
