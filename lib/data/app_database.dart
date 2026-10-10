import 'package:drift/drift.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../l10n/l10n.dart';
import 'connection/connection.dart';

part 'app_database.g.dart';

/// Status einer Diagnose.
enum DiagnosisStatus { active, resolved }

/// Check-in-Rhythmus für Symptome.
enum CheckInCadence { daily, hourly, weekly, custom }

/// Art einer Symptom-Beobachtung.
///
/// v15: [measurement] = Messwert in kanonischer Einheit, welche Messgröße
/// steht in `SymptomObservations.measure` (siehe `SymptomMeasure`). Neue
/// Werte nur hinten anhängen — gespeichert wird der Index.
enum ObservationKind { scale_1_10, color, quantity, note, measurement }

/// v12: Körperseite einer Symptom-Beschreibung (in der DB als [name]).
enum BodySide {
  left,
  right,
  both,
  center;

  /// `null` bei unbekanntem oder leerem Code.
  static BodySide? fromCode(String? code) {
    for (final side in values) {
      if (side.name == code) return side;
    }
    return null;
  }
}

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

  // v12: Standard-Beschreibung für Check-ins (Ort = [bodyRegion]).
  /// Empfindungsart, z. B. „Schmerz“, „Juckreiz“ (Freitext).
  TextColumn get sensation => text().nullable()();

  /// Qualität(en), kommagetrennt, z. B. „brennend, pochend“ (Freitext).
  TextColumn get quality => text().nullable()();

  /// Seite als Code: `left`, `right`, `both`, `center` (siehe [BodySide]).
  TextColumn get side => text().nullable()();

  // v15: Messgröße für Check-ins (Code aus `SymptomMeasure`); leer = Stärke
  // 0–10. [measure2] ist eine optionale zweite Größe (z. B. SpO₂ bei Atemnot).
  TextColumn get measure => text().nullable()();
  TextColumn get measure2 => text().nullable()();

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

  // v12: strukturierte Beschreibung zum Zeitpunkt des Check-ins
  // (vorbelegt aus dem Symptom, im Check-in änderbar).
  TextColumn get sensation => text().nullable()();
  TextColumn get quality => text().nullable()();
  TextColumn get location => text().nullable()();
  TextColumn get side => text().nullable()();

  /// Verlauf/Muster, z. B. „anfallsartig“, „nachts“ (kommagetrennt).
  TextColumn get pattern => text().nullable()();

  // v15: adaptive Messung. Werte immer in kanonischer Einheit (°C, mg/dL,
  // kg, Minuten, /min, mmHg, %); Umrechnung nur in der Anzeige.
  /// Messgröße von [valueNumber]; leer = aus [kind] (Skala = Stärke 0–10).
  TextColumn get measure => text().nullable()();

  /// Zweiter Wert derselben Größe (Blutdruck: diastolisch).
  RealColumn get valueNumber2 => real().nullable()();

  /// Optionale zweite Messgröße des Check-ins und ihr Wert.
  TextColumn get measure2 => text().nullable()();
  RealColumn get secondaryValue => real().nullable()();

  /// Stimmungs-Extras: Energie 0–10, Schlaf in Stunden, Angst/Anspannung 0–10.
  IntColumn get energy => integer().nullable()();
  RealColumn get sleepHours => real().nullable()();
  IntColumn get anxiety => integer().nullable()();

  /// Kurzer Tagebuch-Eintrag. Bewusst getrennt von [note]: [note] steht im
  /// Arzt-PDF, das Tagebuch nur auf ausdrücklichen Wunsch.
  TextColumn get journal => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// v13: Art eines Symptom-Belegs.
enum MediaKind { photo, video, audio }

/// v13: Foto/Video/Sprachnotiz als Beleg zu einem Symptom (verschlüsselte
/// Datei unter `<appDocs>/media`, siehe FileVault).
@DataClassName('SymptomMediaItem')
class SymptomMedia extends Table {
  TextColumn get id => text()();
  TextColumn get symptomId => text().references(Symptoms, #id)();

  /// Optional: Beleg gehört zu diesem Check-in.
  TextColumn get observationId =>
      text().nullable().references(SymptomObservations, #id)();
  IntColumn get kind => intEnum<MediaKind>()();
  TextColumn get mimeType => text()();
  TextColumn get localPath => text()();
  IntColumn get durationMs => integer().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get recordedAt => dateTime()();

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

  // v14: Zyklus & Frauengesundheit (alles optional, standardmäßig aus).
  BoolColumn get cycleTracking =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get menopauseTracking =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get pregnancyTracking =>
      boolean().withDefault(const Constant(false))();

  /// Grob geschätztes fruchtbares Fenster im Kalender zeigen.
  BoolColumn get showFertileWindow =>
      boolean().withDefault(const Constant(false))();

  // v15: Einheiten (Code, leer = nach Region des Geräts, siehe
  // `UnitPreferences`) und monatliche Psyche-Fragebögen (PHQ-9/GAD-7).
  TextColumn get temperatureUnit => text().nullable()();
  TextColumn get glucoseUnit => text().nullable()();
  TextColumn get weightUnit => text().nullable()();
  BoolColumn get psychQuestionnaires =>
      boolean().withDefault(const Constant(false))();

  // v17: Zyklus-Start (letzte Periode beim Einschalten erfragen).
  /// Übliche Zykluslänge laut Angabe (21–45); `null` = unbekannt/unregelmäßig.
  IntColumn get typicalCycleLength => integer().nullable()();

  /// Zyklus-Start erledigt oder übersprungen (nicht erneut nachfragen).
  BoolColumn get cycleSetupDone =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// v14: Stärke der Blutung an einem Tag.
enum CycleFlow { none, spotting, light, medium, heavy, veryHeavy }

/// v14: Kindsbewegungen (Schwangerschaft).
enum FetalMovement { notYet, normal, less }

/// v14: Zyklus-Tagebuch — eine Zeile je Kalendertag. [day] ist der lokale
/// Tag als `yyyy-MM-dd` (zeitzonenunabhängig, siehe `cycle_dates.dart`).
/// Listen (Symptome, Schmerzorte) kommagetrennt als stabile Schlüssel;
/// eigene Begriffe stehen als Freitext dazwischen.
class CycleDays extends Table {
  TextColumn get day => text()();
  IntColumn get flow => intEnum<CycleFlow>().nullable()();

  /// PBAC-Zählungen als JSON (siehe `PbacCounts`).
  TextColumn get pbacJson => text().nullable()();

  /// Schmerz 0–10 (gleiche Anker wie bei Symptomen).
  IntColumn get pain => integer().nullable()();
  TextColumn get painLocations => text().nullable()();
  TextColumn get symptoms => text().nullable()();
  TextColumn get discharge => text().nullable()();
  BoolColumn get painkiller => boolean().nullable()();
  TextColumn get painkillerName => text().nullable()();

  /// Hat das Schmerzmittel geholfen? `null` = keine Angabe.
  BoolColumn get painkillerHelped => boolean().nullable()();

  // Wechseljahre.
  IntColumn get hotFlashes => integer().nullable()();

  /// Stärke der Hitzewallungen 1–3 (leicht/mittel/stark).
  IntColumn get hotFlashIntensity => integer().nullable()();

  /// Nachtschweiß 0–3.
  IntColumn get nightSweats => integer().nullable()();

  // Schwangerschaft.
  IntColumn get fetalMovement => intEnum<FetalMovement>().nullable()();
  RealColumn get weightKg => real().nullable()();
  IntColumn get bpSystolic => integer().nullable()();
  IntColumn get bpDiastolic => integer().nullable()();

  TextColumn get note => text().nullable()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {day};
}

/// v14: Menopause Rating Scale (11 Items, je 0–4, kommagetrennt).
class MrsAssessments extends Table {
  TextColumn get id => text()();
  DateTimeColumn get recordedAt => dateTime()();
  TextColumn get scores => text()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// v15: Fragebogen zur Psyche ([instrument] `phq9` oder `gad7`), Antworten
/// je Item 0–3 kommagetrennt (siehe `psych_questionnaires.dart`).
class PsychAssessments extends Table {
  TextColumn get id => text()();
  DateTimeColumn get recordedAt => dateTime()();
  TextColumn get instrument => text()();
  TextColumn get scores => text()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// v14: Schwangerschaft. Aktiv = [endedAt] leer. Termine als lokaler Tag
/// (`yyyy-MM-dd`); [dueDate] überschreibt die Berechnung aus [lmp].
class Pregnancies extends Table {
  TextColumn get id => text()();

  /// Erster Tag der letzten Periode.
  TextColumn get lmp => text().nullable()();

  /// Errechneter Termin (z. B. aus dem Ultraschall), sonst aus [lmp].
  TextColumn get dueDate => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();

  /// `birth`, `loss` oder `other` — nur, wenn angegeben.
  TextColumn get outcome => text().nullable()();
  TextColumn get note => text().nullable()();

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
    SymptomMedia,
    CycleDays,
    MrsAssessments,
    Pregnancies,
    PsychAssessments,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? openAppDatabase());

  @override
  int get schemaVersion => 17;

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
      if (from < 12) {
        await migrator.addColumn(symptoms, symptoms.sensation);
        await migrator.addColumn(symptoms, symptoms.quality);
        await migrator.addColumn(symptoms, symptoms.side);
        for (final column in [
          symptomObservations.sensation,
          symptomObservations.quality,
          symptomObservations.location,
          symptomObservations.side,
          symptomObservations.pattern,
        ]) {
          await migrator.addColumn(symptomObservations, column);
        }
      }
      if (from < 13) {
        await migrator.createTable(symptomMedia);
      }
      if (from < 14) {
        for (final column in [
          appSettings.cycleTracking,
          appSettings.menopauseTracking,
          appSettings.pregnancyTracking,
          appSettings.showFertileWindow,
        ]) {
          await migrator.addColumn(appSettings, column);
        }
        await migrator.createTable(cycleDays);
        await migrator.createTable(mrsAssessments);
        await migrator.createTable(pregnancies);
      }
      if (from < 15) {
        await migrator.addColumn(symptoms, symptoms.measure);
        await migrator.addColumn(symptoms, symptoms.measure2);
        for (final column in [
          symptomObservations.measure,
          symptomObservations.valueNumber2,
          symptomObservations.measure2,
          symptomObservations.secondaryValue,
          symptomObservations.energy,
          symptomObservations.sleepHours,
          symptomObservations.anxiety,
          symptomObservations.journal,
        ]) {
          await migrator.addColumn(symptomObservations, column);
        }
        for (final column in [
          appSettings.temperatureUnit,
          appSettings.glucoseUnit,
          appSettings.weightUnit,
          appSettings.psychQuestionnaires,
        ]) {
          await migrator.addColumn(appSettings, column);
        }
        await migrator.createTable(psychAssessments);
      }
      if (from < 16) {
        // Tagebuch-Einträge in den Suchindex (bisher nicht durchsuchbar).
        await reindexJournals();
      }
      if (from < 17) {
        await migrator.addColumn(appSettings, appSettings.typicalCycleLength);
        await migrator.addColumn(appSettings, appSettings.cycleSetupDone);
        // Bestandsnutzerinnen mit erfasster Periode (Blutung ≥ leicht)
        // brauchen den Zyklus-Start nicht mehr. Greift auch beim Einspielen
        // älterer Sicherungen (die werden ebenfalls migriert).
        if (from >= 14) {
          await customStatement(
            'UPDATE app_settings SET cycle_setup_done = 1 WHERE EXISTS '
            '(SELECT 1 FROM cycle_days WHERE flow >= ${CycleFlow.light.index})',
          );
        }
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

  /// v16: Suchindex-Titel eines Tagebuch-Eintrags: „Symptom · Datum“.
  static String journalFtsTitle(String label, DateTime recordedAt) =>
      '$label · '
      '${DateFormat(AppLocale.strings.recordsDatePattern).format(recordedAt)}';

  /// v16: Tagebuch-Einträge (`journal`, entity_id = Check-in) neu in den
  /// Suchindex schreiben — alle, die eines Symptoms oder ein Check-in. Leere
  /// Einträge fliegen raus. Archiviert wird über das Symptom (siehe
  /// `RecordsRepository.archivedKeys`).
  Future<void> reindexJournals({
    String? symptomId,
    String? observationId,
  }) async {
    final rows = await customSelect(
      '''
      SELECT o.id, o.journal, o.recorded_at, s.label
      FROM symptom_observations o JOIN symptoms s ON s.id = o.symptom_id
      WHERE (?1 IS NULL OR o.symptom_id = ?1)
        AND (?2 IS NULL OR o.id = ?2)
      ''',
      variables: [Variable(symptomId), Variable(observationId)],
      readsFrom: {},
    ).get();
    for (final r in rows) {
      final id = r.read<String>('id');
      final text = r.read<String?>('journal')?.trim() ?? '';
      if (text.isEmpty) {
        await deleteFts('journal', id);
        continue;
      }
      await upsertFts(
        entityType: 'journal',
        entityId: id,
        title: journalFtsTitle(
          r.read<String>('label'),
          DateTime.fromMillisecondsSinceEpoch(
            r.read<int>('recorded_at') * 1000,
          ),
        ),
        body: text,
      );
    }
  }

  Future<void> deleteFts(String entityType, String entityId) {
    return customStatement(
      'DELETE FROM records_fts WHERE entity_type = ? AND entity_id = ?',
      [entityType, entityId],
    );
  }
}
