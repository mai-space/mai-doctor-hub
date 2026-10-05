import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';
import 'reminder_repository.dart' show Weekdays;

const _uuid = Uuid();

String medicationFormLabel(MedicationForm form) => switch (form) {
  MedicationForm.tablet => 'Tablette',
  MedicationForm.capsule => 'Kapsel',
  MedicationForm.drops => 'Tropfen',
  MedicationForm.liquid => 'Saft / Lösung',
  MedicationForm.spray => 'Spray',
  MedicationForm.inhaler => 'Inhalator',
  MedicationForm.ointment => 'Salbe / Creme',
  MedicationForm.injection => 'Spritze',
  MedicationForm.patch => 'Pflaster',
  MedicationForm.suppository => 'Zäpfchen',
  MedicationForm.powder => 'Pulver / Granulat',
  MedicationForm.other => 'Sonstiges',
};

/// Typische Einheit je Darreichungsform (Vorschlag im Formular).
String defaultDoseUnit(MedicationForm form) => switch (form) {
  MedicationForm.tablet => 'Stück',
  MedicationForm.capsule => 'Stück',
  MedicationForm.drops => 'Tropfen',
  MedicationForm.liquid => 'ml',
  MedicationForm.spray => 'Sprühstoß',
  MedicationForm.inhaler => 'Hub',
  MedicationForm.ointment => 'Anwendung',
  MedicationForm.injection => 'Einheit',
  MedicationForm.patch => 'Stück',
  MedicationForm.suppository => 'Stück',
  MedicationForm.powder => 'Beutel',
  MedicationForm.other => 'Stück',
};

const doseUnitCatalog = [
  'Stück',
  'Tropfen',
  'ml',
  'mg',
  'g',
  'Hub',
  'Sprühstoß',
  'Beutel',
  'Messlöffel',
  'IE',
  'Einheit',
  'Anwendung',
];

String formatAmount(double amount) => amount == amount.roundToDouble()
    ? amount.toStringAsFixed(0)
    : amount.toString().replaceAll('.', ',');

/// Neue/bearbeitete Einnahmezeit.
class ScheduleInput {
  const ScheduleInput({
    required this.hour,
    required this.minute,
    this.weekdays = Weekdays.all,
    this.doseAmount,
  });

  final int hour;
  final int minute;
  final int weekdays;
  final double? doseAmount;
}

class MedicationDetails {
  const MedicationDetails({
    required this.medication,
    required this.schedules,
    this.prescriber,
    this.pharmacy,
    this.diagnosis,
  });

  final Medication medication;
  final List<MedicationSchedule> schedules;
  final Doctor? prescriber;
  final Pharmacy? pharmacy;
  final Diagnose? diagnosis;

  /// „1 Tablette“, „20 Tropfen“.
  String? doseFor(MedicationSchedule? schedule) {
    final amount = schedule?.doseAmount ?? medication.doseAmount;
    if (amount == null) return null;
    final unit = medication.doseUnit ?? '';
    return '${formatAmount(amount)} $unit'.trim();
  }

  bool isActiveOn(DateTime day) {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    final m = medication;
    return (m.startedAt == null || m.startedAt!.isBefore(end)) &&
        (m.endedAt == null || !m.endedAt!.isBefore(start));
  }
}

/// Eine Einnahme an einem Tag (für „Heute einnehmen“).
class PlannedDose {
  const PlannedDose({
    required this.details,
    required this.schedule,
    required this.at,
    this.intake,
  });

  final MedicationDetails details;
  final MedicationSchedule schedule;
  final DateTime at;
  final MedicationIntake? intake;

  bool get done => intake != null;
}

class MedicationRepository {
  MedicationRepository(this._db);

  final AppDatabase _db;

  Set<ResultSetImplementation<dynamic, dynamic>> get tables => {
    _db.medications,
    _db.medicationSchedules,
    _db.medicationIntakes,
    _db.doctors,
    _db.pharmacies,
    _db.diagnoses,
  };

  Future<List<MedicationDetails>> all() async {
    final meds =
        await (_db.select(_db.medications)
              ..orderBy([(t) => OrderingTerm.asc(t.name)]))
            .get();
    return _details(meds);
  }

  Future<MedicationDetails?> get(String id) async {
    final med = await (_db.select(
      _db.medications,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (med == null) return null;
    return (await _details([med])).single;
  }

  Stream<MedicationDetails?> watch(String id) =>
      _db.watchWith(tables, () => get(id));

  Future<List<MedicationDetails>> _details(List<Medication> meds) async {
    if (meds.isEmpty) return const [];
    final ids = meds.map((m) => m.id).toList();
    final schedules =
        await (_db.select(_db.medicationSchedules)
              ..where((t) => t.medicationId.isIn(ids))
              ..orderBy([
                (t) => OrderingTerm.asc(t.hour),
                (t) => OrderingTerm.asc(t.minute),
              ]))
            .get();
    final doctors = {
      for (final d in await _db.select(_db.doctors).get()) d.id: d,
    };
    final pharmacies = {
      for (final p in await _db.select(_db.pharmacies).get()) p.id: p,
    };
    final diagnoses = {
      for (final d in await _db.select(_db.diagnoses).get()) d.id: d,
    };
    return [
      for (final m in meds)
        MedicationDetails(
          medication: m,
          schedules: [
            for (final s in schedules)
              if (s.medicationId == m.id) s,
          ],
          prescriber: doctors[m.prescriberId],
          pharmacy: pharmacies[m.pharmacyId],
          diagnosis: diagnoses[m.diagnosisId],
        ),
    ];
  }

  /// Anlegen ([id] == null) oder vollständig aktualisieren.
  Future<String> save({
    String? id,
    required String name,
    String? strength,
    MedicationForm? form,
    double? doseAmount,
    String? doseUnit,
    String? instructions,
    String? prescriberId,
    String? pharmacyId,
    String? diagnosisId,
    DateTime? startedAt,
    DateTime? endedAt,
    String? notes,
    bool remindersEnabled = true,
    List<ScheduleInput> schedules = const [],
  }) async {
    final medId = id ?? _uuid.v4();
    schedules = [...schedules]
      ..sort((a, b) => (a.hour * 60 + a.minute).compareTo(b.hour * 60 + b.minute));
    final scheduleText = schedules.isEmpty
        ? null
        : schedules
              .map(
                (s) =>
                    '${_two(s.hour)}:${_two(s.minute)}'
                    '${s.weekdays & Weekdays.all == Weekdays.all ? '' : ' (${Weekdays.describe(s.weekdays)})'}',
              )
              .join(', ');
    final companion = MedicationsCompanion(
      name: Value(name),
      dosage: Value(strength),
      scheduleText: Value(scheduleText),
      diagnosisId: Value(diagnosisId),
      startedAt: Value(startedAt),
      endedAt: Value(endedAt),
      notes: Value(notes),
      form: Value(form),
      doseAmount: Value(doseAmount),
      doseUnit: Value(doseUnit),
      instructions: Value(instructions),
      prescriberId: Value(prescriberId),
      pharmacyId: Value(pharmacyId),
      remindersEnabled: Value(remindersEnabled),
    );
    await _db.transaction(() async {
      if (id == null) {
        await _db
            .into(_db.medications)
            .insert(
              companion.copyWith(
                id: Value(medId),
                createdAt: Value(DateTime.now()),
              ),
            );
      } else {
        await (_db.update(
          _db.medications,
        )..where((t) => t.id.equals(medId))).write(companion);
      }
      await (_db.delete(
        _db.medicationSchedules,
      )..where((t) => t.medicationId.equals(medId))).go();
      final maxSlot = _db.medicationSchedules.slot.max();
      var slot =
          (await (_db.selectOnly(
                _db.medicationSchedules,
              )..addColumns([maxSlot])).getSingle()).read(maxSlot) ??
          0;
      for (final s in schedules) {
        await _db
            .into(_db.medicationSchedules)
            .insert(
              MedicationSchedulesCompanion.insert(
                id: _uuid.v4(),
                medicationId: medId,
                slot: ++slot,
                hour: s.hour,
                minute: s.minute,
                weekdays: Value(s.weekdays == 0 ? Weekdays.all : s.weekdays),
                doseAmount: Value(s.doseAmount),
              ),
            );
      }
      await _db.upsertFts(
        entityType: 'medication',
        entityId: medId,
        title: name,
        body: [
          strength,
          if (form != null) medicationFormLabel(form),
          instructions,
          scheduleText,
          notes,
        ].whereType<String>().join(' '),
      );
    });
    return medId;
  }

  Future<void> setRemindersEnabled(String id, bool enabled) =>
      (_db.update(_db.medications)..where((t) => t.id.equals(id))).write(
        MedicationsCompanion(remindersEnabled: Value(enabled)),
      );

  // --- Einnahmen ---------------------------------------------------------

  /// Alle geplanten Einnahmen an [day] inkl. bereits erfasster.
  Future<List<PlannedDose>> dosesOn(DateTime day) async {
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    final intakes =
        await (_db.select(_db.medicationIntakes)
              ..where((t) => t.scheduledFor.isBiggerOrEqualValue(start))
              ..where((t) => t.scheduledFor.isSmallerThanValue(end)))
            .get();
    final doses = <PlannedDose>[];
    for (final details in await all()) {
      if (!details.isActiveOn(start)) continue;
      for (final s in details.schedules) {
        if (!Weekdays.contains(s.weekdays, start.weekday)) continue;
        final at = DateTime(start.year, start.month, start.day, s.hour, s.minute);
        doses.add(
          PlannedDose(
            details: details,
            schedule: s,
            at: at,
            intake: intakes
                .where(
                  (i) =>
                      i.medicationId == details.medication.id &&
                      i.scheduledFor == at,
                )
                .firstOrNull,
          ),
        );
      }
    }
    doses.sort((a, b) => a.at.compareTo(b.at));
    return doses;
  }

  Stream<List<PlannedDose>> watchDosesOn(DateTime day) =>
      _db.watchWith(tables, () => dosesOn(day));

  /// Erfasst eine Einnahme; für geplante Zeitpunkte ersetzt sie eine
  /// frühere Erfassung desselben Zeitpunkts.
  Future<String> recordIntake({
    required String medicationId,
    DateTime? scheduledFor,
    IntakeStatus status = IntakeStatus.taken,
    double? doseAmount,
    String? note,
    DateTime? at,
  }) async {
    final id = _uuid.v4();
    await _db.transaction(() async {
      if (scheduledFor != null) {
        await (_db.delete(_db.medicationIntakes)
              ..where((t) => t.medicationId.equals(medicationId))
              ..where((t) => t.scheduledFor.equals(scheduledFor)))
            .go();
      }
      await _db
          .into(_db.medicationIntakes)
          .insert(
            MedicationIntakesCompanion.insert(
              id: id,
              medicationId: medicationId,
              scheduledFor: Value(scheduledFor),
              recordedAt: at ?? DateTime.now(),
              status: status,
              doseAmount: Value(doseAmount),
              note: Value(note),
            ),
          );
    });
    return id;
  }

  Future<void> deleteIntake(String id) =>
      (_db.delete(_db.medicationIntakes)..where((t) => t.id.equals(id))).go();

  Future<List<MedicationIntake>> intakes(String medicationId, {int limit = 50}) =>
      (_db.select(_db.medicationIntakes)
            ..where((t) => t.medicationId.equals(medicationId))
            ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)])
            ..limit(limit))
          .get();

  /// Anteil genommener an geplanten Einnahmen der letzten [days] Tage
  /// (bis gestern; heute läuft noch). `null`, wenn nichts geplant war.
  Future<double?> adherence(String medicationId, {int days = 14, DateTime? now}) async {
    final today = now ?? DateTime.now();
    var planned = 0;
    var taken = 0;
    for (var i = 1; i <= days; i++) {
      final day = DateTime(today.year, today.month, today.day - i);
      for (final dose in await dosesOn(day)) {
        if (dose.details.medication.id != medicationId) continue;
        planned++;
        if (dose.intake?.status == IntakeStatus.taken) taken++;
      }
    }
    return planned == 0 ? null : taken / planned;
  }

  static String _two(int v) => v.toString().padLeft(2, '0');
}

class PharmacyRepository {
  PharmacyRepository(this._db);

  final AppDatabase _db;

  Stream<List<Pharmacy>> watchAll() =>
      (_db.select(_db.pharmacies)..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .watch();

  Future<Pharmacy?> get(String id) => (_db.select(
    _db.pharmacies,
  )..where((t) => t.id.equals(id))).getSingleOrNull();

  Future<String> save({
    String? id,
    required String name,
    String? address,
    String? phone,
    String? notes,
  }) async {
    final pharmacyId = id ?? _uuid.v4();
    final now = DateTime.now();
    final companion = PharmaciesCompanion(
      name: Value(name),
      address: Value(address),
      phone: Value(phone),
      notes: Value(notes),
      updatedAt: Value(now),
    );
    if (id == null) {
      await _db
          .into(_db.pharmacies)
          .insert(
            companion.copyWith(id: Value(pharmacyId), createdAt: Value(now)),
          );
    } else {
      await (_db.update(
        _db.pharmacies,
      )..where((t) => t.id.equals(id))).write(companion);
    }
    await _db.upsertFts(
      entityType: 'pharmacy',
      entityId: pharmacyId,
      title: name,
      body: [address, notes].whereType<String>().join(' '),
    );
    return pharmacyId;
  }

  /// Löscht die Apotheke; Medikamente verlieren nur die Zuordnung.
  Future<void> delete(String id) => _db.transaction(() async {
    await (_db.update(_db.medications)..where((t) => t.pharmacyId.equals(id)))
        .write(const MedicationsCompanion(pharmacyId: Value(null)));
    await (_db.delete(_db.pharmacies)..where((t) => t.id.equals(id))).go();
    await _db.deleteFts('pharmacy', id);
  });

  Future<List<Medication>> medicationsFor(String pharmacyId) =>
      (_db.select(_db.medications)
            ..where((t) => t.pharmacyId.equals(pharmacyId))
            ..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .get();
}
