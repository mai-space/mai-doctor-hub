import 'package:drift/drift.dart';
import 'package:intl/intl.dart';

import '../../data/app_database.dart';
import '../../data/repositories/appointment_repository.dart';
import '../../data/repositories/cycle_repository.dart';
import '../../data/repositories/medication_repository.dart';
import '../../data/repositories/records_repository.dart';
import '../../data/symptom_description.dart';
import '../../data/symptom_measure.dart';
import '../../l10n/l10n.dart';
import '../../widgets/symptom_report_card.dart' show observationLabel;
import '../cycle/cycle_report.dart';
import '../visit_summary.dart';
import 'assistant_engine.dart';
import 'semantic_index.dart';

/// Systemanweisung: nur aus der Akte antworten, keine Diagnosen stellen —
/// in der App-Sprache (antwortet dann auch in dieser Sprache).
String get assistantSystemPrompt => AppLocale.strings.svcContextSystemPrompt;

/// Stellt den Akte-Auszug für eine Frage zusammen — begrenzt, damit er ins
/// Kontextfenster des Modells passt.
class AssistantContextBuilder {
  AssistantContextBuilder(this._db, {this.maxChars = 7000, this._semantic});

  final AppDatabase _db;

  /// Ohne Embedding-Modell nur Stichwortsuche.
  final SemanticIndex? _semantic;

  /// ≈ 2 000 Tokens; Rest des 4k-Fensters bleibt für Frage und Antwort.
  final int maxChars;

  /// Datumsformate in der App-Sprache (bei jedem Aufruf neu, damit ein
  /// Sprachwechsel greift).
  static DateFormat get _day =>
      DateFormat(AppLocale.strings.svcContextDayPattern);
  static DateFormat get _dayTime =>
      DateFormat(AppLocale.strings.svcContextDayTimePattern);

  static AppLocalizations get _l10n => AppLocale.strings;

  static const _stopWords = {
    'aber',
    'alle',
    'also',
    'auch',
    'bitte',
    'dass',
    'dein',
    'deine',
    'dem',
    'den',
    'der',
    'des',
    'die',
    'dies',
    'diese',
    'doch',
    'eine',
    'einem',
    'einen',
    'einer',
    'eines',
    'habe',
    'haben',
    'hatte',
    'heute',
    'ich',
    'ihre',
    'immer',
    'kann',
    'mein',
    'meine',
    'meinem',
    'meinen',
    'meiner',
    'mich',
    'mir',
    'nach',
    'nicht',
    'noch',
    'oder',
    'schon',
    'sein',
    'sind',
    'soll',
    'über',
    'und',
    'viel',
    'von',
    'wann',
    'warum',
    'was',
    'welche',
    'welcher',
    'welches',
    'wenn',
    'wer',
    'wie',
    'wieder',
    'wird',
    'wo',
    'zum',
    'zur',
    'gibt',
    'gab',
    'letzte',
    'letzten',
    'nächste',
    'nächsten',
    'ist',
    'bin',
    'war',
    'beim',
    'mit',
    'für',
    'auf',
    'aus',
    'bei',
    'hat',
    'ein',
    'das',
    'man',
    'muss',
    'darf',
    'wurde',
    'werden',
  };

  /// Englische Füllwörter — gelten zusätzlich, egal in welcher Sprache.
  static const _englishStopWords = {
    'about',
    'after',
    'again',
    'all',
    'also',
    'and',
    'any',
    'are',
    'been',
    'before',
    'being',
    'but',
    'can',
    'could',
    'did',
    'does',
    'doing',
    'for',
    'from',
    'get',
    'got',
    'had',
    'has',
    'have',
    'how',
    'into',
    'its',
    'just',
    'last',
    'latest',
    'many',
    'more',
    'most',
    'much',
    'next',
    'not',
    'now',
    'one',
    'only',
    'other',
    'our',
    'please',
    'should',
    'some',
    'still',
    'tell',
    'than',
    'that',
    'the',
    'their',
    'them',
    'then',
    'there',
    'these',
    'they',
    'this',
    'those',
    'was',
    'were',
    'what',
    'when',
    'where',
    'which',
    'while',
    'who',
    'whom',
    'why',
    'will',
    'with',
    'would',
    'you',
    'your',
    'yours',
    'currently',
    'right',
    'show',
    'know',
    'take',
    'taking',
    'recent',
    'recently',
  };

  /// Suchbegriffe einer Frage in Alltagssprache.
  static List<String> keywords(String question) => {
    for (final word in question.toLowerCase().split(
      RegExp(r'[^\p{L}\p{N}]+', unicode: true),
    ))
      if (word.length >= 3 &&
          !_stopWords.contains(word) &&
          !_englishStopWords.contains(word))
        word,
  }.toList();

  /// [expansion]: zusätzliche Suchbegriffe (Synonyme, Fachbegriffe), siehe
  /// [expandQuery]. [previous]: vorige Frage im Gespräch — ihre Begriffe
  /// suchen mit (Anschlussfragen wie „Was könnte zusammenhängen?“).
  Future<String> build(
    String question, {
    DateTime? now,
    List<String> expansion = const [],
    String? previous,
  }) async {
    final current = now ?? DateTime.now();
    final l10n = _l10n;
    final summary = await VisitSummaryBuilder(_db)
        .build(const VisitSummaryOptions(), now: current);
    final sections = <String>[
      l10n.svcContextToday(_dayTime.format(current)),
      _section(l10n.svcContextActiveDiagnoses, [
        for (final d in summary.diagnoses)
          [
            d.title,
            if (d.startedAt != null) l10n.svcSince(_day.format(d.startedAt!)),
          ].join(', '),
      ]),
      _section(l10n.svcCurrentMedications, [
        for (final m in summary.medications) _medication(m),
      ]),
      _section(l10n.svcContextOpenSymptoms, [
        for (final t in summary.symptoms) _symptom(t),
      ]),
      ...await _appointments(current),
      _section(l10n.entityVaccinations, [
        for (final v in summary.vaccinations)
          [
            l10n.svcContextVaccineOn(v.vaccine, _day.format(v.administeredAt)),
            if (v.doseNumber != null) l10n.svcContextDoseNumber(v.doseNumber!),
            if (v.nextDueAt != null)
              l10n.svcContextNextDue(_day.format(v.nextDueAt!)),
          ].join(', '),
      ]),
      await _cycle(current),
    ];

    final base = sections.where((s) => s.isNotEmpty).join('\n\n');
    final hits = await relevantHits(
      question,
      expansion: expansion,
      previous: previous,
    );
    if (hits.isEmpty) return _clip(base, maxChars);

    // Treffer bekommen, was sie brauchen — mindestens aber die Hälfte des
    // Budgets; der Überblick wird notfalls gekürzt.
    final hitBudget = (maxChars - base.length).clamp(maxChars ~/ 2, maxChars);
    final found = StringBuffer('\n\n${l10n.svcContextMatchingEntries}');
    for (final hit in hits) {
      final entry =
          '\n- [${_typeLabel(hit.entityType)}] ${hit.title}: ${hit.text}';
      if (found.length + entry.length > hitBudget) {
        if (hitBudget - found.length >= 200) {
          found.write(_clip(entry, hitBudget - found.length));
        }
        break;
      }
      found.write(entry);
    }
    return _clip(base, maxChars - found.length) + found.toString();
  }

  /// Beste Stichworttreffer und beste Bedeutungstreffer im Wechsel, beide
  /// auf Abschnittsebene.
  Future<List<RecordHit>> relevantHits(
    String question, {
    List<String> expansion = const [],
    String? previous,
  }) async {
    final terms = {
      ...keywords(question),
      ...expansion,
      if (previous != null) ...keywords(previous),
    }.toList();
    final rows = await RecordsRepository(_db).searchAny(terms, limit: 20);
    final keyword = keywordChunks([
      for (final row in rows)
        (
          type: row.read<String>('entity_type'),
          id: row.read<String>('entity_id'),
          title: row.read<String>('title'),
          body: row.read<String>('body'),
        ),
    ], terms);
    final semantic = _semantic == null
        ? const <RecordHit>[]
        : await _semantic.search(
            previous == null ? question : '$previous\n$question',
            limit: 10,
            exclude: await RecordsRepository(_db).archivedKeys(),
          );
    return mergeHits(keyword, semantic);
  }

  /// Kompakte Zyklus-Zusammenfassung, nur wenn ein Bereich aktiv ist.
  Future<String> _cycle(DateTime now) async {
    final overview = await CycleRepository(_db).overview(now: now);
    if (!overview.enabled) return '';
    return _section(
      _l10n.cycleSettingsTitle,
      CycleReport.from(overview).contextLines(_l10n),
    );
  }

  Future<List<String>> _appointments(DateTime now) async {
    final repo = AppointmentRepository(_db);
    final upcoming = await repo.summariesFor(
      await (_db.selectActive(_db.appointments)
            ..where((t) => t.scheduledAt.isBiggerOrEqualValue(now))
            ..where((t) => t.status.equalsValue(AppointmentStatus.planned))
            ..orderBy([(t) => OrderingTerm.asc(t.scheduledAt)])
            ..limit(5))
          .get(),
    );
    final past = await repo.summariesFor(
      await (_db.selectActive(_db.appointments)
            ..where((t) => t.scheduledAt.isSmallerThanValue(now))
            ..orderBy([(t) => OrderingTerm.desc(t.scheduledAt)])
            ..limit(5))
          .get(),
    );
    return [
      _section(_l10n.svcContextUpcomingAppointments, [
        for (final a in upcoming) _appointment(a),
      ]),
      _section(_l10n.svcContextPastAppointments, [
        for (final a in past) _appointment(a),
      ]),
    ];
  }

  static String _appointment(AppointmentSummary s) {
    final a = s.appointment;
    return [
      _dayTime.format(a.scheduledAt),
      s.doctorName,
      if (s.doctor?.specialty != null) s.doctor!.specialty!,
      if (a.title?.isNotEmpty == true) a.title!,
      if (a.status == AppointmentStatus.cancelled) _l10n.svcContextCancelled,
      if (s.diagnosisTitles.isNotEmpty)
        _l10n.svcContextDiagnosesList(s.diagnosisTitles.join(', ')),
    ].join(' · ');
  }

  static String _medication(MedicationDetails m) {
    final med = m.medication;
    final times = [
      for (final s in m.schedules)
        [
          '${s.hour.toString().padLeft(2, '0')}:'
              '${s.minute.toString().padLeft(2, '0')}',
          ?m.doseFor(s),
        ].join(' '),
    ];
    return [
      med.name,
      if (med.dosage?.isNotEmpty == true) med.dosage!,
      if (times.isNotEmpty) _l10n.svcContextIntake(times.join(', ')),
      if (times.isEmpty && med.scheduleText?.isNotEmpty == true)
        med.scheduleText!,
      if (med.instructions?.isNotEmpty == true) med.instructions!,
      if (m.diagnosis != null) _l10n.svcContextFor(m.diagnosis!.title),
      if (med.endedAt != null) _l10n.svcContextUntil(_day.format(med.endedAt!)),
    ].join(', ');
  }

  static String _symptom(SymptomTrend t) {
    final s = t.symptom;
    final description = SymptomDescription.fromSymptom(s);
    final latest = t.observations.isEmpty
        ? null
        : t.observations.reduce(
            (a, b) => a.recordedAt.isAfter(b.recordedAt) ? a : b,
          );
    // v15: letzter Tagebuch-Eintrag, kurz (nur lokal im Assistenten).
    final journal = t.observations
        .where((o) => o.journal?.trim().isNotEmpty == true)
        .lastOrNull;
    final stats = t.stats;
    return [
      s.label,
      if (!description.isEmpty) description.describe(_l10n),
      _l10n.svcCheckInCount(t.observations.length),
      if (t.measure == SymptomMeasure.intensity && t.average != null)
        'Ø ${t.average!.toStringAsFixed(1)}/10',
      if (t.measure != SymptomMeasure.intensity && stats != null)
        '${measureLabel(t.measure, _l10n)}: '
            '${stats.describe(t.measure, _l10n)}',
      // v16: Werte früherer Messgrößen (vor einem Wechsel).
      for (final section in t.earlierSections)
        t.earlierLine(section, _l10n, _day),
      if (latest != null)
        _l10n.svcContextLatest(
          _day.format(latest.recordedAt),
          observationLabel(latest),
        ),
      if (journal != null)
        _l10n.journalContext(
          _day.format(journal.recordedAt),
          _clip(journal.journal!.trim().replaceAll('\n', ' '), 160),
        ),
    ].join(', ');
  }

  static String _section(String title, List<String> lines) =>
      lines.isEmpty ? '' : '$title:\n${lines.map((l) => '- $l').join('\n')}';

  static String _clip(String text, int max) =>
      text.length <= max ? text : '${text.substring(0, max - 1)}…';

  static String _typeLabel(String type) => switch (type) {
    'doctor' => _l10n.entityDoctor,
    'diagnosis' => _l10n.entityDiagnosis,
    'symptom' => _l10n.entitySymptom,
    'appointment' => _l10n.entityAppointment,
    'report' => _l10n.entityReport,
    'medication' => _l10n.entityMedication,
    'note' => _l10n.entityNote,
    'pharmacy' => _l10n.entityPharmacy,
    'vaccination' => _l10n.entityVaccination,
    // v16: Tagebuch-Eintrag eines Check-ins (Titel „Symptom · Datum“).
    'journal' => _l10n.searchJournalEntry,
    _ => type,
  };
}

/// Prompt = Akte-Auszug + ggf. bisheriges Gespräch ([history], siehe
/// `conversationHistory`) + Frage + kurze Erinnerung an das Antwortformat
/// (kleine Modelle halten sich eher an das, was zuletzt steht).
String assistantPrompt(String context, String question, {String history = ''}) =>
    '${AppLocale.strings.svcContextRecordHeading}:\n$context\n\n'
    '${history.isEmpty ? '' : '${AppLocale.strings.assistantHistoryHeading}:\n$history\n\n'}'
    '${AppLocale.strings.svcContextQuestionHeading}:\n${question.trim()}\n\n'
    '${AppLocale.strings.assistantPromptReminder}';

/// Lässt das Sprachmodell Suchbegriffe ergänzen (Synonyme, Fach- und
/// Laienbegriffe, Abkürzungen), damit die Stichwortsuche auch Einträge
/// findet, in denen die Wörter der Frage nicht vorkommen. Schlägt das fehl
/// oder dauert es zu lange, wird ohne Ergänzung gesucht.
Future<List<String>> expandQuery(
  AssistantEngine engine,
  String question, {
  Duration timeout = const Duration(seconds: 20),
}) async {
  final l10n = AppLocale.strings;
  try {
    final reply = await engine
        .complete(
          system: l10n.svcQueryExpansionSystem,
          prompt: l10n.svcQueryExpansionPrompt(question.trim()),
        )
        .timeout(timeout);
    return parseExpansion(reply, exclude: AssistantContextBuilder.keywords(question));
  } catch (_) {
    return const [];
  }
}

/// Begriffe aus der Modellantwort: durch Komma/Zeile getrennt, ohne
/// Aufzählungszeichen, Doppelte und schon vorhandene Wörter; höchstens 10.
List<String> parseExpansion(String reply, {List<String> exclude = const []}) {
  final known = {for (final w in exclude) w.toLowerCase()};
  final terms = <String>[];
  for (final raw in reply.split(RegExp(r'[,;\n]'))) {
    final term = raw
        .replaceAll(RegExp(r'^[\s\-•*\d.)]+'), '')
        .replaceAll(RegExp(r'["„“”«»*]'), '')
        .trim()
        .toLowerCase();
    if (term.length < 2 || term.length > 40) continue;
    if (term.split(' ').length > 3) continue;
    if (known.add(term)) terms.add(term);
    if (terms.length == 10) break;
  }
  return terms;
}
