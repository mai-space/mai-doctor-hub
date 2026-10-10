import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../l10n/l10n.dart';
import '../../services/cycle/cycle_analytics.dart';
import '../../services/cycle/cycle_dates.dart';
import '../../services/cycle/mrs.dart';
import '../../services/cycle/pregnancy_math.dart';
import '../app_database.dart';
import '../cycle_catalog.dart';
import 'doctor_repository.dart';

const _uuid = Uuid();

/// Welche Bereiche aktiv sein sollen (Onboarding, Einstellungen).
class CycleSetup {
  const CycleSetup({
    this.cycle = false,
    this.menopause = false,
    this.pregnancy = false,
    this.createGynecologist = false,
    this.start,
    this.startAsked = false,
  });

  final bool cycle;
  final bool menopause;
  final bool pregnancy;
  final bool createGynecologist;

  /// Angaben aus dem Zyklus-Start (nur mit [cycle]); `null` = übersprungen.
  final CycleStartAnswers? start;

  /// Zyklus-Start wurde gezeigt (beantwortet oder übersprungen).
  final bool startAsked;

  bool get any => cycle || menopause || pregnancy;
}

/// v17: Angaben aus dem Zyklus-Start, damit die Schätzung sofort beginnt.
class CycleStartAnswers {
  const CycleStartAnswers({
    this.lastStart,
    this.periodDays = defaultPeriodDays,
    this.typicalCycleLength,
  });

  static const defaultPeriodDays = 5;
  static const minPeriodDays = 1;
  static const maxPeriodDays = 10;
  static const defaultCycleLength = 28;
  static const minCycleLength = 21;
  static const maxCycleLength = 45;

  /// Beginn der letzten Periode; `null` = nicht angegeben.
  final DateTime? lastStart;

  /// Dauer der Periode in Tagen (1–10).
  final int periodDays;

  /// Übliche Zykluslänge (21–45); `null` = weiß nicht/unregelmäßig.
  final int? typicalCycleLength;
}

/// Alles, was Seite, Startkarte, PDF, Assistent und Erinnerungen brauchen.
class CycleOverview {
  const CycleOverview({
    required this.today,
    required this.cycleTracking,
    required this.menopauseTracking,
    required this.pregnancyTracking,
    required this.showFertileWindow,
    required this.rows,
    required this.analysis,
    required this.mrs,
    this.pregnancy,
    this.pregnancyStatus,
    this.typicalCycleLength,
    this.cycleSetupDone = true,
    this.calendarFirstWeekday,
  });

  final DateTime today;
  final bool cycleTracking;
  final bool menopauseTracking;
  final bool pregnancyTracking;
  final bool showFertileWindow;

  /// Tagebuch, ältester Tag zuerst.
  final List<CycleDay> rows;
  final CycleAnalysis analysis;

  /// MRS-Bögen, ältester zuerst.
  final List<MrsAssessment> mrs;

  /// Aktive Schwangerschaft (nur bei eingeschaltetem Bereich).
  final Pregnancy? pregnancy;
  final PregnancyStatus? pregnancyStatus;

  /// v17: übliche Zykluslänge laut Zyklus-Start.
  final int? typicalCycleLength;

  /// v17: Zyklus-Start beantwortet oder übersprungen.
  final bool cycleSetupDone;

  /// v18: Wochenbeginn im Kalender (`null` = automatisch nach Region).
  final int? calendarFirstWeekday;

  /// Zyklus-Start anbieten: Periode wird getrackt, aber noch keine erfasst.
  bool get needsCycleStart =>
      cycleTracking && !pregnant && analysis.periods.isEmpty;

  bool get enabled => cycleTracking || menopauseTracking || pregnancyTracking;
  bool get pregnant => pregnancy != null;

  CycleDay? rowFor(DateTime day) {
    final key = dayKey(day);
    for (final r in rows.reversed) {
      if (r.day == key) return r;
    }
    return null;
  }

  MrsAssessment? get latestMrs => mrs.isEmpty ? null : mrs.last;

  /// MRS fällig: Wechseljahre aktiv und nie bzw. vor > 28 Tagen ausgefüllt.
  bool get mrsDue {
    if (!menopauseTracking) return false;
    final last = latestMrs;
    return last == null || dayDiff(last.recordedAt, today) > 28;
  }
}

class CycleRepository {
  CycleRepository(this._db);

  final AppDatabase _db;

  Set<ResultSetImplementation<dynamic, dynamic>> get tables => {
    _db.cycleDays,
    _db.mrsAssessments,
    _db.pregnancies,
    _db.appSettings,
  };

  // ---------------------------------------------------------------- Tage

  Future<List<CycleDay>> allDays() => (_db.select(
    _db.cycleDays,
  )..orderBy([(t) => OrderingTerm.asc(t.day)])).get();

  Future<CycleDay?> getDay(DateTime day) => (_db.select(
    _db.cycleDays,
  )..where((t) => t.day.equals(dayKey(day)))).getSingleOrNull();

  Stream<CycleDay?> watchDay(DateTime day) => (_db.select(
    _db.cycleDays,
  )..where((t) => t.day.equals(dayKey(day)))).watchSingleOrNull();

  /// Speichert die gesetzten Felder von [values] für [day]; nicht gesetzte
  /// Felder (`Value.absent`) bleiben, wie sie sind.
  Future<void> saveDay(DateTime day, CycleDaysCompanion values) {
    final row = values.copyWith(
      day: Value(dayKey(day)),
      updatedAt: Value(DateTime.now()),
    );
    return _db.into(_db.cycleDays).insertOnConflictUpdate(row);
  }

  /// Zyklus-Start speichern: Periodentage (mittlere Blutung, höchstens bis
  /// heute) und übliche Zykluslänge. Bereits erfasste Blutung bleibt
  /// unverändert; Tage ohne Blutungsangabe bekommen nur die Blutung dazu.
  Future<void> saveCycleStart(CycleStartAnswers answers, {DateTime? now}) =>
      _db.transaction(() async {
        final today = cycleDay(now ?? DateTime.now());
        final start = answers.lastStart;
        if (start != null) {
          final days = answers.periodDays.clamp(
            CycleStartAnswers.minPeriodDays,
            CycleStartAnswers.maxPeriodDays,
          );
          for (var i = 0; i < days; i++) {
            final day = plusDays(cycleDay(start), i);
            if (day.isAfter(today)) break;
            final existing = await getDay(day);
            if (existing?.flow != null) continue;
            await saveDay(
              day,
              const CycleDaysCompanion(flow: Value(CycleFlow.medium)),
            );
          }
        }
        await _settings(
          AppSettingsCompanion(
            typicalCycleLength: Value(answers.typicalCycleLength),
            cycleSetupDone: const Value(true),
          ),
        );
      });

  /// Zyklus-Start überspringen („Später“): nicht erneut von selbst fragen.
  Future<void> skipCycleStart() =>
      _settings(const AppSettingsCompanion(cycleSetupDone: Value(true)));

  Future<void> deleteDay(DateTime day) =>
      (_db.delete(_db.cycleDays)..where((t) => t.day.equals(dayKey(day)))).go();

  // ---------------------------------------------------------------- MRS

  Future<List<MrsAssessment>> allMrs() => (_db.select(
    _db.mrsAssessments,
  )..orderBy([(t) => OrderingTerm.asc(t.recordedAt)])).get();

  Future<String> addMrs(MrsResult result, {DateTime? at, String? note}) async {
    final id = _uuid.v4();
    await _db
        .into(_db.mrsAssessments)
        .insert(
          MrsAssessmentsCompanion.insert(
            id: id,
            recordedAt: at ?? DateTime.now(),
            scores: result.encode(),
            note: Value(note?.trim().isEmpty == true ? null : note?.trim()),
          ),
        );
    return id;
  }

  Future<void> deleteMrs(String id) =>
      (_db.delete(_db.mrsAssessments)..where((t) => t.id.equals(id))).go();

  // ------------------------------------------------------- Schwangerschaft

  Future<Pregnancy?> activePregnancy() =>
      (_db.select(_db.pregnancies)
            ..where((t) => t.endedAt.isNull())
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)])
            ..limit(1))
          .getSingleOrNull();

  Future<List<Pregnancy>> allPregnancies() => (_db.select(
    _db.pregnancies,
  )..orderBy([(t) => OrderingTerm.asc(t.createdAt)])).get();

  /// Legt eine aktive Schwangerschaft an (oder gibt die bestehende zurück).
  Future<String> startPregnancy({DateTime? lmp, DateTime? dueDate}) async {
    final existing = await activePregnancy();
    if (existing != null) {
      if (lmp != null || dueDate != null) {
        await updatePregnancy(existing.id, lmp: lmp, dueDate: dueDate);
      }
      return existing.id;
    }
    final id = _uuid.v4();
    await _db
        .into(_db.pregnancies)
        .insert(
          PregnanciesCompanion.insert(
            id: id,
            lmp: Value(lmp == null ? null : dayKey(lmp)),
            dueDate: Value(dueDate == null ? null : dayKey(dueDate)),
            createdAt: DateTime.now(),
          ),
        );
    return id;
  }

  Future<void> updatePregnancy(String id, {DateTime? lmp, DateTime? dueDate}) =>
      (_db.update(_db.pregnancies)..where((t) => t.id.equals(id))).write(
        PregnanciesCompanion(
          lmp: Value(lmp == null ? null : dayKey(lmp)),
          dueDate: Value(dueDate == null ? null : dayKey(dueDate)),
        ),
      );

  /// Beendet die Schwangerschaft (Geburt, Verlust o. Ä. — [outcome] optional)
  /// und blendet den Bereich aus. Daten bleiben erhalten.
  Future<void> endPregnancy(
    String id, {
    String? outcome,
    String? note,
    DateTime? at,
  }) => _db.transaction(() async {
    await (_db.update(_db.pregnancies)..where((t) => t.id.equals(id))).write(
      PregnanciesCompanion(
        endedAt: Value(at ?? DateTime.now()),
        outcome: Value(outcome),
        note: Value(note?.trim().isEmpty == true ? null : note?.trim()),
      ),
    );
    await _settings(
      const AppSettingsCompanion(pregnancyTracking: Value(false)),
    );
  });

  // ------------------------------------------------------------ Bereiche

  Future<void> _settings(AppSettingsCompanion values) =>
      (_db.update(_db.appSettings)..where((t) => t.id.equals(1))).write(values);

  Future<void> setShowFertileWindow(bool value) =>
      _settings(AppSettingsCompanion(showFertileWindow: Value(value)));

  Future<void> setCycleTracking(bool value) =>
      _settings(AppSettingsCompanion(cycleTracking: Value(value)));

  Future<void> setMenopauseTracking(bool value) =>
      _settings(AppSettingsCompanion(menopauseTracking: Value(value)));

  /// Schwangerschaft ein: legt bei Bedarf eine aktive an. Aus: blendet nur
  /// aus (beenden geht bewusst über [endPregnancy]).
  Future<void> setPregnancyTracking(bool value) => _db.transaction(() async {
    await _settings(AppSettingsCompanion(pregnancyTracking: Value(value)));
    if (value) await startPregnancy();
  });

  /// Übernimmt die Auswahl aus Onboarding/Einstellungen. Gibt die ID der
  /// Gynäkologie zurück, wenn sie angelegt oder gefunden wurde.
  Future<String?> apply(CycleSetup setup) => _db.transaction(() async {
    await _settings(
      AppSettingsCompanion(
        cycleTracking: Value(setup.cycle),
        menopauseTracking: Value(setup.menopause),
        pregnancyTracking: Value(setup.pregnancy),
      ),
    );
    if (setup.pregnancy) await startPregnancy();
    if (setup.cycle && setup.startAsked) {
      final start = setup.start;
      start == null ? await skipCycleStart() : await saveCycleStart(start);
    }
    if (setup.createGynecologist && setup.any) return ensureGynecologist();
    return null;
  });

  /// Erste aktive gynäkologische Praxis, sonst `null`.
  Future<Doctor?> gynecologist() async {
    final doctors = await (_db.selectActive(
      _db.doctors,
    )..orderBy([(t) => OrderingTerm.asc(t.createdAt)])).get();
    for (final d in doctors) {
      if (isGynecologySpecialty(d.specialty)) return d;
    }
    return null;
  }

  /// Legt „Meine Gynäkologin/mein Gynäkologe“ an — nur, wenn es noch keine
  /// gynäkologische Praxis gibt.
  Future<String> ensureGynecologist() async {
    final existing = await gynecologist();
    if (existing != null) return existing.id;
    return DoctorRepository(_db).create(
      name: AppLocale.strings.cycleGynecologistPlaceholder,
      specialty: gynecologySpecialty(),
    );
  }

  /// Löscht alle Zyklus-, MRS- und Schwangerschaftsdaten und schaltet die
  /// Bereiche aus. Die Gynäkologie bleibt (gehört zur Akte).
  Future<void> deleteAll() => _db.transaction(() async {
    await _db.delete(_db.cycleDays).go();
    await _db.delete(_db.mrsAssessments).go();
    await _db.delete(_db.pregnancies).go();
    await _settings(
      const AppSettingsCompanion(
        cycleTracking: Value(false),
        menopauseTracking: Value(false),
        pregnancyTracking: Value(false),
        showFertileWindow: Value(false),
        typicalCycleLength: Value(null),
        cycleSetupDone: Value(false),
      ),
    );
  });

  // ------------------------------------------------------------ Übersicht

  Future<CycleOverview> overview({DateTime? now}) async {
    final today = cycleDay(now ?? DateTime.now());
    final settings = await (_db.select(
      _db.appSettings,
    )..where((t) => t.id.equals(1))).getSingle();
    final rows = await allDays();
    final pregnancy = settings.pregnancyTracking
        ? await activePregnancy()
        : null;
    final status = pregnancy == null
        ? null
        : PregnancyStatus.from(
            lmp: parseDayKey(pregnancy.lmp),
            dueDate: parseDayKey(pregnancy.dueDate),
            today: today,
          );
    return CycleOverview(
      today: today,
      cycleTracking: settings.cycleTracking,
      menopauseTracking: settings.menopauseTracking,
      pregnancyTracking: settings.pregnancyTracking,
      showFertileWindow: settings.showFertileWindow,
      rows: rows,
      analysis: CycleAnalysis(
        rows.map(CycleLog.fromRow),
        today: today,
        pregnant: pregnancy != null,
        menopause: settings.menopauseTracking,
        pregnancySince: status?.start ?? pregnancy?.createdAt,
        typicalCycleLength: settings.typicalCycleLength,
      ),
      mrs: await allMrs(),
      pregnancy: pregnancy,
      pregnancyStatus: status,
      typicalCycleLength: settings.typicalCycleLength,
      cycleSetupDone: settings.cycleSetupDone,
      calendarFirstWeekday: settings.calendarFirstWeekday,
    );
  }

  /// Neu laden bei jeder Änderung an Tagebuch, MRS, Schwangerschaft oder
  /// Einstellungen.
  Stream<CycleOverview> watchOverview() =>
      _db.watchWith(tables, () => overview());
}
