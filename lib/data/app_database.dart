import 'package:drift/drift.dart';

import '../l10n/l10n.dart';
import 'connection/connection.dart';

part 'app_database.g.dart';

/// Status einer Diagnose.
enum DiagnosisStatus { active, resolved }

/// Check-in-Rhythmus für Symptome.
enum CheckInCadence { daily, hourly, weekly, custom }

/// Art einer Symptom-Beobachtung.
enum ObservationKind { scale_1_10, color, quantity, note }

/// Status eines Termins.
enum AppointmentStatus { planned, done, cancelled }

/// Darreichungsform eines Medikaments.
enum MedicationForm {
  tablet,
  capsule,
  drops,
  liquid,
  spray,
  inhaler,
  ointment,
  injection,
  patch,
  suppository,
  powder,
  other,
}

/// Einnahme erfasst als genommen oder ausgelassen.
enum IntakeStatus { taken, skipped }

/// Herkunft eines Berichts.
enum ReportSource { pdf, scan, image }

/// v9: Archiv statt endgültigem Löschen (Soft Delete).
mixin Archivable on Table {
  /// Gesetzt = im Archiv; überall ausgeblendet, wiederherstellbar.
  DateTimeColumn get archivedAt => dateTime().nullable()();
}

class Doctors extends Table with Archivable {
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

class Diagnoses extends Table with Archivable {
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

class Symptoms extends Table with Archivable {
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

class Appointments extends Table with Archivable {
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

/// v6: Symptom ist (auch) Thema bei einem Arzt — unabhängig vom Termin.
class DoctorSymptoms extends Table {
  TextColumn get doctorId => text().references(Doctors, #id)();
  TextColumn get symptomId => text().references(Symptoms, #id)();

  @override
  Set<Column<Object>> get primaryKey => {doctorId, symptomId};
}

class Reports extends Table with Archivable {
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

class Medications extends Table with Archivable {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get dosage => text().nullable()();
  TextColumn get scheduleText => text().nullable()();
  TextColumn get diagnosisId => text().nullable().references(Diagnoses, #id)();
  DateTimeColumn get startedAt => dateTime().nullable()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  // v7: vollwertiges Medikament.
  /// Darreichungsform (Tablette, Tropfen …).
  IntColumn get form => intEnum<MedicationForm>().nullable()();

  /// Menge pro Einnahme, z. B. 1 (Stück) oder 20 (Tropfen).
  RealColumn get doseAmount => real().nullable()();
  TextColumn get doseUnit => text().nullable()();

  /// Hinweise wie „nach dem Essen“.
  TextColumn get instructions => text().nullable()();
  TextColumn get prescriberId => text().nullable().references(Doctors, #id)();
  TextColumn get pharmacyId => text().nullable().references(Pharmacies, #id)();
  BoolColumn get remindersEnabled =>
      boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// v8: Impfung.
class Vaccinations extends Table with Archivable {
  TextColumn get id => text()();

  /// Impfstoff bzw. Impfung, z. B. „Tetanus/Diphtherie/Pertussis“.
  TextColumn get vaccine => text()();
  TextColumn get product => text().nullable()();
  DateTimeColumn get administeredAt => dateTime()();
  IntColumn get doseNumber => integer().nullable()();
  TextColumn get batch => text().nullable()();
  TextColumn get doctorId => text().nullable().references(Doctors, #id)();
  DateTimeColumn get nextDueAt => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// v7: Apotheke (Bezug/Abholung von Medikamenten).
class Pharmacies extends Table with Archivable {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get address => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// v7: Einnahmezeit eines Medikaments ([weekdays] wie bei Erinnerungen).
class MedicationSchedules extends Table {
  TextColumn get id => text()();
  TextColumn get medicationId => text().references(Medications, #id)();

  /// Stabile Nummer für Benachrichtigungs-IDs.
  IntColumn get slot => integer().unique()();
  IntColumn get hour => integer()();
  IntColumn get minute => integer()();
  IntColumn get weekdays => integer().withDefault(const Constant(127))();

  /// Abweichende Menge für diese Einnahme (sonst die des Medikaments).
  RealColumn get doseAmount => real().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// v7: Einnahme-Protokoll.
class MedicationIntakes extends Table {
  TextColumn get id => text()();
  TextColumn get medicationId => text().references(Medications, #id)();

  /// Geplanter Einnahmezeitpunkt (null = außerplanmäßig).
  DateTimeColumn get scheduledFor => dateTime().nullable()();
  DateTimeColumn get recordedAt => dateTime()();
  IntColumn get status => intEnum<IntakeStatus>()();
  RealColumn get doseAmount => real().nullable()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Notes extends Table with Archivable {
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

  // v4: Onboarding gesehen (Berechtigungen werden dort erklärt/angefragt).
  BoolColumn get onboardingCompleted =>
      boolean().withDefault(const Constant(false))();

  // v5: Erinnerungen vor Arztterminen (Vorlauf in Minuten, kommagetrennt).
  BoolColumn get appointmentRemindersEnabled =>
      boolean().withDefault(const Constant(true))();
  TextColumn get appointmentReminderLeads =>
      text().withDefault(const Constant('1440,60'))();

  // v11: Benachrichtigungs-Themen (JSON: an/aus, Wichtigkeit, diskret).
  TextColumn get notificationTopics =>
      text().withDefault(const Constant(''))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// v3: Erinnerung (beliebig viele). [weekdays] ist eine Bitmaske
/// Mo=1, Di=2, Mi=4 … So=64; 127 = täglich.
class Reminders extends Table {
  TextColumn get id => text()();

  /// Stabile Nummer für Benachrichtigungs-IDs (einmalig vergeben).
  IntColumn get slot => integer().unique()();
  TextColumn get title => text()();
  TextColumn get body => text().nullable()();
  IntColumn get hour => integer()();
  IntColumn get minute => integer()();
  IntColumn get weekdays => integer().withDefault(const Constant(127))();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// v3: Erinnerung gilt nur für bestimmte Symptome (leer = alle offenen).
class ReminderSymptoms extends Table {
  TextColumn get reminderId => text().references(Reminders, #id)();
  TextColumn get symptomId => text().references(Symptoms, #id)();

  @override
  Set<Column<Object>> get primaryKey => {reminderId, symptomId};
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
    Reminders,
    ReminderSymptoms,
    DoctorSymptoms,
    Pharmacies,
    MedicationSchedules,
    MedicationIntakes,
    Vaccinations,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? openAppDatabase());

  @override
  int get schemaVersion => 11;

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
      await _createRecordVectors();
      await into(appSettings).insert(AppSettingsCompanion.insert());
      await _insertDefaultReminders();
    },
    // Schritte strikt aufsteigend: jeder Block bringt v(n-1) → v(n).
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
      if (from < 3) {
        await migrator.createTable(reminders);
        await migrator.createTable(reminderSymptoms);
        // Bisherige Morgen-/Abend-Einstellung als Erinnerungen übernehmen.
        final row = await customSelect(
          'SELECT morning_reminder_enabled, evening_reminder_enabled, '
          'morning_hour, morning_minute, evening_hour, evening_minute '
          'FROM app_settings WHERE id = 1',
        ).getSingleOrNull();
        await _insertDefaultReminders(
          morning: row == null
              ? null
              : (
                  row.read<bool>('morning_reminder_enabled'),
                  row.read<int>('morning_hour'),
                  row.read<int>('morning_minute'),
                ),
          evening: row == null
              ? null
              : (
                  row.read<bool>('evening_reminder_enabled'),
                  row.read<int>('evening_hour'),
                  row.read<int>('evening_minute'),
                ),
        );
      }
      if (from < 4) {
        await migrator.addColumn(appSettings, appSettings.onboardingCompleted);
      }
      if (from < 5) {
        await migrator.addColumn(
          appSettings,
          appSettings.appointmentRemindersEnabled,
        );
        await migrator.addColumn(
          appSettings,
          appSettings.appointmentReminderLeads,
        );
      }
      if (from < 6) {
        await migrator.createTable(doctorSymptoms);
      }
      if (from < 7) {
        await migrator.createTable(pharmacies);
        await migrator.addColumn(medications, medications.form);
        await migrator.addColumn(medications, medications.doseAmount);
        await migrator.addColumn(medications, medications.doseUnit);
        await migrator.addColumn(medications, medications.instructions);
        await migrator.addColumn(medications, medications.prescriberId);
        await migrator.addColumn(medications, medications.pharmacyId);
        await migrator.addColumn(medications, medications.remindersEnabled);
        await migrator.createTable(medicationSchedules);
        await migrator.createTable(medicationIntakes);
      }
      if (from < 8) {
        await migrator.createTable(vaccinations);
      }
      if (from < 9) {
        // createTable legt das aktuelle Schema an — in diesem Upgrade neu
        // erstellte Tabellen haben archived_at also schon.
        final createdNow = {
          if (from < 7) pharmacies.actualTableName,
          if (from < 8) vaccinations.actualTableName,
        };
        for (final table in archivableTables) {
          if (createdNow.contains(table.actualTableName)) continue;
          await migrator.addColumn(
            table,
            table.columnsByName['archived_at']!,
          );
        }
      }
      if (from < 10) {
        await _createRecordVectors();
      }
      if (from < 11) {
        await migrator.addColumn(appSettings, appSettings.notificationTopics);
      }
    },
    beforeOpen: (details) async {
      // Bestandsnutzer kennen die App schon → kein Onboarding nach Update;
      // die Berechtigung wird bei Bedarf in den Erinnerungen angefragt.
      if (details.hadUpgrade && details.versionBefore! < 4) {
        await customStatement(
          'UPDATE app_settings SET onboarding_completed = 1',
        );
      }
      // Settings-Zeile garantieren (z. B. nach Restore eines Fremd-Backups).
      await customStatement('INSERT OR IGNORE INTO app_settings (id) VALUES (1)');
    },
  );

  /// `select` ohne archivierte Zeilen (nur für [Archivable]-Tabellen).
  SimpleSelectStatement<T, R> selectActive<T extends HasResultSet, R>(
    ResultSetImplementation<T, R> table,
  ) {
    return select(table)
      ..where((t) => (t as Archivable).archivedAt.isNull());
  }

  /// FTS-`entity_type` → Tabelle.
  static const entityTables = {
    'doctor': 'doctors',
    'diagnosis': 'diagnoses',
    'symptom': 'symptoms',
    'appointment': 'appointments',
    'report': 'reports',
    'medication': 'medications',
    'note': 'notes',
    'pharmacy': 'pharmacies',
    'vaccination': 'vaccinations',
  };

  /// Alle Tabellen mit Archiv-Funktion.
  List<TableInfo<Table, dynamic>> get archivableTables => [
    doctors,
    diagnoses,
    symptoms,
    appointments,
    reports,
    medications,
    notes,
    pharmacies,
    vaccinations,
  ];

  /// Standard: zwei Check-in-Erinnerungen (morgens/abends).
  Future<void> _insertDefaultReminders({
    (bool, int, int)? morning,
    (bool, int, int)? evening,
  }) async {
    final now = DateTime.now();
    // Texte in der App-Sprache beim Anlegen; bestehende Zeilen bleiben.
    final strings = AppLocale.strings;
    final defaults = [
      ('reminder-morning', 1, strings.catalogReminderMorningTitle,
          strings.catalogReminderMorningBody,
          morning ?? (true, 8, 0)),
      ('reminder-evening', 2, strings.catalogReminderEveningTitle,
          strings.catalogReminderEveningBody,
          evening ?? (true, 20, 0)),
    ];
    for (final (id, slot, title, body, (enabled, hour, minute)) in defaults) {
      await into(reminders).insert(
        RemindersCompanion.insert(
          id: id,
          slot: slot,
          title: title,
          body: Value(body),
          hour: hour,
          minute: minute,
          enabled: Value(enabled),
          createdAt: now,
          updatedAt: now,
        ),
      );
    }
  }

  /// Feuert sofort und bei jeder Änderung an einer der [tables].
  Stream<void> watchTables(
    Set<ResultSetImplementation<dynamic, dynamic>> tables,
  ) {
    // drift teilt Watch-Streams mit gleichem SQL + Variablen, ohne readsFrom
    // zu vergleichen. Die Tabellennamen gehören deshalb in den Schlüssel.
    final key = [for (final t in tables) t.entityName]..sort();
    return customSelect(
      'SELECT ?',
      variables: [Variable.withString(key.join(','))],
      readsFrom: tables,
    ).watch().map((_) {});
  }

  /// Abschnitte der Akte mit Embedding-Vektor (semantische Suche des
  /// Assistenten). Abgeleitet aus `records_fts`, jederzeit neu aufbaubar.
  Future<void> _createRecordVectors() => customStatement('''
    CREATE TABLE IF NOT EXISTS record_vectors (
      entity_type TEXT NOT NULL,
      entity_id TEXT NOT NULL,
      chunk INTEGER NOT NULL,
      model TEXT NOT NULL,
      source_hash TEXT NOT NULL,
      content TEXT NOT NULL,
      vector BLOB NOT NULL,
      PRIMARY KEY (entity_type, entity_id, chunk)
    )
  ''');

  /// Lädt [load] neu, sobald sich eine der [tables] ändert.
  Stream<T> watchWith<T>(
    Set<ResultSetImplementation<dynamic, dynamic>> tables,
    Future<T> Function() load,
  ) {
    return watchTables(tables).asyncMap((_) => load());
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
