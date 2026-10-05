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
}
