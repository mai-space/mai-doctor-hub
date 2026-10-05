import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// Status einer Diagnose.
enum DiagnosisStatus { active, resolved }

/// Check-in-Rhythmus für Symptome.
enum CheckInCadence { daily, hourly, weekly, custom }

/// Art einer Symptom-Beobachtung.
enum ObservationKind { scale_1_10, color, quantity, note }

/// Status eines Termins.
enum AppointmentStatus { planned, done, cancelled }

/// Herkunft eines Berichts.
enum ReportSource { pdf, scan, image }

class Doctors extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get specialty => text().nullable()();
  TextColumn get practiceName => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Diagnoses extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get status => intEnum<DiagnosisStatus>()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Symptoms extends Table {
  TextColumn get id => text()();
  TextColumn get label => text()();
  TextColumn get diagnosisId => text().nullable().references(Diagnoses, #id)();
  TextColumn get bodyRegion => text().nullable()();
  DateTimeColumn get healedAt => dateTime().nullable()();
  IntColumn get checkInCadence => intEnum<CheckInCadence>()();
  TextColumn get reminderTimesJson => text().withDefault(const Constant('[]'))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class SymptomObservations extends Table {
  TextColumn get id => text()();
  TextColumn get symptomId => text().references(Symptoms, #id)();
  DateTimeColumn get recordedAt => dateTime()();
  IntColumn get kind => intEnum<ObservationKind>()();
  RealColumn get valueNumber => real().nullable()();
  TextColumn get valueText => text().nullable()();
  TextColumn get valueColor => text().nullable()();
  TextColumn get unit => text().nullable()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Appointments extends Table {
  TextColumn get id => text()();
  TextColumn get doctorId => text().references(Doctors, #id)();
  DateTimeColumn get scheduledAt => dateTime()();
  IntColumn get durationMin => integer().nullable()();
  TextColumn get title => text().nullable()();
  TextColumn get notes => text().nullable()();
  IntColumn get status => intEnum<AppointmentStatus>()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class AppointmentDiagnoses extends Table {
  TextColumn get appointmentId =>
      text().references(Appointments, #id)();
  TextColumn get diagnosisId => text().references(Diagnoses, #id)();

  @override
  Set<Column<Object>> get primaryKey => {appointmentId, diagnosisId};
}

class AppointmentSymptoms extends Table {
  TextColumn get appointmentId =>
      text().references(Appointments, #id)();
  TextColumn get symptomId => text().references(Symptoms, #id)();

  @override
  Set<Column<Object>> get primaryKey => {appointmentId, symptomId};
}

class Reports extends Table {
  TextColumn get id => text()();
  TextColumn get appointmentId =>
      text().nullable().references(Appointments, #id)();
  TextColumn get title => text()();
  TextColumn get mimeType => text()();
  TextColumn get localPath => text()();
  TextColumn get extractedText => text().nullable()();
  IntColumn get pageCount => integer().nullable()();
  IntColumn get source => intEnum<ReportSource>()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Medications extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get dosage => text().nullable()();
  TextColumn get scheduleText => text().nullable()();
  TextColumn get diagnosisId => text().nullable().references(Diagnoses, #id)();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Notes extends Table {
  TextColumn get id => text()();
  TextColumn get body => text()();
  TextColumn get relatedAppointmentId =>
      text().nullable().references(Appointments, #id)();
  TextColumn get relatedDiagnosisId =>
      text().nullable().references(Diagnoses, #id)();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Lokale Einstellungen (Erinnerungszeiten).
class AppSettings extends Table {
  IntColumn get id => integer().withDefault(const Constant(1))();
  BoolColumn get morningReminderEnabled =>
      boolean().withDefault(const Constant(true))();
  BoolColumn get eveningReminderEnabled =>
      boolean().withDefault(const Constant(true))();
  IntColumn get morningHour => integer().withDefault(const Constant(8))();
  IntColumn get morningMinute => integer().withDefault(const Constant(0))();
  IntColumn get eveningHour => integer().withDefault(const Constant(20))();
  IntColumn get eveningMinute => integer().withDefault(const Constant(0))();

  // v2: Kalender-Export (einseitig nach Google/Gerätekalender).
  BoolColumn get calendarSyncEnabled =>
      boolean().withDefault(const Constant(false))();
  TextColumn get calendarId => text().nullable()();
  BoolColumn get calendarIncludeTitle =>
      boolean().withDefault(const Constant(false))();

  // v2: App-Sperre (Biometrie/Geräte-PIN).
  BoolColumn get appLockEnabled =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// v2: Verknüpfung Termin → exportiertes Kalender-Event.
class CalendarLinks extends Table {
  TextColumn get appointmentId => text()();
  TextColumn get calendarId => text()();
  TextColumn get externalEventId => text().nullable()();
  TextColumn get payloadHash => text().nullable()();
  DateTimeColumn get syncedAt => dateTime().nullable()();
  TextColumn get lastError => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {appointmentId};
}

@DriftDatabase(
  tables: [
    Doctors,
    Diagnoses,
    Symptoms,
    SymptomObservations,
    Appointments,
    AppointmentDiagnoses,
    AppointmentSymptoms,
    Reports,
    Medications,
    Notes,
    AppSettings,
    CalendarLinks,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'mai_doctor_hub'));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
      await customStatement('''
        CREATE VIRTUAL TABLE IF NOT EXISTS records_fts USING fts5(
          entity_type,
          entity_id,
          title,
          body,
          tokenize = 'unicode61'
        );
      ''');
      await into(appSettings).insert(AppSettingsCompanion.insert());
    },
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.addColumn(appSettings, appSettings.calendarSyncEnabled);
        await migrator.addColumn(appSettings, appSettings.calendarId);
        await migrator.addColumn(
          appSettings,
          appSettings.calendarIncludeTitle,
        );
        await migrator.addColumn(appSettings, appSettings.appLockEnabled);
        await migrator.createTable(calendarLinks);
      }
    },
    beforeOpen: (details) async {
      // Settings-Zeile garantieren (z. B. nach Restore eines Fremd-Backups).
      await customStatement('INSERT OR IGNORE INTO app_settings (id) VALUES (1)');
    },
  );

  /// Lädt [load] neu, sobald sich eine der [tables] ändert.
  Stream<T> watchWith<T>(
    Set<ResultSetImplementation<dynamic, dynamic>> tables,
    Future<T> Function() load,
  ) {
    return customSelect(
      'SELECT 1',
      readsFrom: tables,
    ).watch().asyncMap((_) => load());
  }

  Future<void> upsertFts({
    required String entityType,
    required String entityId,
    required String title,
    required String body,
  }) async {
    await customStatement(
      'DELETE FROM records_fts WHERE entity_type = ? AND entity_id = ?',
      [entityType, entityId],
    );
    await customStatement(
      'INSERT INTO records_fts(entity_type, entity_id, title, body) VALUES (?, ?, ?, ?)',
      [entityType, entityId, title, body],
    );
  }

  Future<List<QueryRow>> searchFts(
    String query, {
    String? entityType,
    int limit = 50,
  }) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];
    return customSelect(
      '''
      SELECT entity_type, entity_id, title, body, bm25(records_fts) AS rank
      FROM records_fts
      WHERE records_fts MATCH ?
        AND (? IS NULL OR entity_type = ?)
      ORDER BY rank
      LIMIT ?
      ''',
      variables: [
        Variable.withString(trimmed),
        Variable(entityType),
        Variable(entityType),
        Variable.withInt(limit),
      ],
      readsFrom: {},
    ).get();
  }

  Future<void> deleteFts(String entityType, String entityId) {
    return customStatement(
      'DELETE FROM records_fts WHERE entity_type = ? AND entity_id = ?',
      [entityType, entityId],
    );
  }
}
