import 'package:drift/drift.dart';
import 'package:intl/intl.dart';

import '../../data/app_database.dart';
import '../../data/repositories/appointment_repository.dart';
import '../../data/repositories/medication_repository.dart';
import '../../data/repositories/records_repository.dart';
import '../../widgets/symptom_report_card.dart' show observationLabel;
import '../visit_summary.dart';

/// Systemanweisung: nur aus der Akte antworten, keine Diagnosen stellen.
const assistantSystemPrompt = '''
Du bist der Assistent der App „Mai Doctor Hub“. Du beantwortest Fragen zur
persönlichen Gesundheitsakte des Nutzers auf Deutsch, kurz und klar.
Regeln:
- Nutze nur die Informationen aus dem Abschnitt AKTE. Steht etwas nicht darin,
  sag ehrlich, dass es in der Akte nicht vermerkt ist.
- Übernimm Daten, Uhrzeiten, Dosierungen und Werte exakt.
- Stelle keine Diagnosen und gib keine Therapie- oder Dosierungsempfehlungen;
  verweise bei medizinischen Fragen an Arzt, Ärztin oder Apotheke.
- Bei Warnzeichen für einen Notfall: rate, sofort 112 anzurufen.''';

/// Stellt den Akte-Auszug für eine Frage zusammen — begrenzt, damit er ins
/// Kontextfenster des Modells passt.
class AssistantContextBuilder {
  AssistantContextBuilder(this._db, {this.maxChars = 7000});

  final AppDatabase _db;

  /// ≈ 2 000 Tokens; Rest des 4k-Fensters bleibt für Frage und Antwort.
  final int maxChars;

  static final _day = DateFormat('dd.MM.yyyy', 'de');
  static final _dayTime = DateFormat('dd.MM.yyyy HH:mm', 'de');

  static const _stopWords = {
    'aber', 'alle', 'also', 'auch', 'bitte', 'dass', 'dein', 'deine', 'dem',
    'den', 'der', 'des', 'die', 'dies', 'diese', 'doch', 'eine', 'einem',
    'einen', 'einer', 'eines', 'habe', 'haben', 'hatte', 'heute', 'ich',
    'ihre', 'immer', 'kann', 'mein', 'meine', 'meinem', 'meinen', 'meiner',
    'mich', 'mir', 'nach', 'nicht', 'noch', 'oder', 'schon', 'sein', 'sind',
    'soll', 'über', 'und', 'viel', 'von', 'wann', 'warum', 'was', 'welche',
    'welcher', 'welches', 'wenn', 'wer', 'wie', 'wieder', 'wird', 'wo',
    'zum', 'zur', 'gibt', 'gab', 'letzte', 'letzten', 'nächste', 'nächsten',
    'ist', 'bin', 'war', 'beim', 'mit', 'für', 'auf', 'aus', 'bei', 'hat',
    'ein', 'das', 'man', 'muss', 'darf', 'wurde', 'werden',
  };

  /// Suchbegriffe einer Frage in Alltagssprache.
  static List<String> keywords(String question) => {
    for (final word in question.toLowerCase().split(RegExp(r'[^\p{L}\p{N}]+', unicode: true)))
      if (word.length >= 3 && !_stopWords.contains(word)) word,
  }.toList();

  Future<String> build(String question, {DateTime? now}) async {
    final current = now ?? DateTime.now();
    final summary = await VisitSummaryBuilder(
      _db,
    ).build(const VisitSummaryOptions(), now: current);
    final sections = <String>[
      'Heute: ${_dayTime.format(current)}',
      _section('Aktive Diagnosen', [
        for (final d in summary.diagnoses)
          [
            d.title,
            if (d.startedAt != null) 'seit ${_day.format(d.startedAt!)}',
          ].join(', '),
      ]),
      _section('Aktuelle Medikamente', [
        for (final m in summary.medications) _medication(m),
      ]),
      _section('Offene Symptome (letzte 30 Tage)', [
        for (final t in summary.symptoms) _symptom(t),
      ]),
      ...await _appointments(current),
      _section('Impfungen', [
        for (final v in summary.vaccinations)
          [
            '${v.vaccine} am ${_day.format(v.administeredAt)}',
            if (v.doseNumber != null) '${v.doseNumber}. Dosis',
            if (v.nextDueAt != null) 'nächste fällig ${_day.format(v.nextDueAt!)}',
          ].join(', '),
      ]),
    ];

    final base = sections.where((s) => s.isNotEmpty).join('\n\n');
    final buffer = StringBuffer(_clip(base, maxChars));
    final matches = await RecordsRepository(
      _db,
    ).searchAny(keywords(question));
    if (matches.isNotEmpty && buffer.length < maxChars - 200) {
      buffer.write('\n\nPassende Einträge zur Frage:');
      for (final row in matches) {
        final remaining = maxChars - buffer.length;
        if (remaining < 200) break;
        final entry =
            '\n- [${_typeLabel(row.read<String>('entity_type'))}] '
            '${row.read<String>('title')}: '
            '${_excerpt(row.read<String>('body'), keywords(question))}';
        buffer.write(_clip(entry, remaining));
      }
    }
    return buffer.toString();
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
      _section('Nächste Termine', [for (final a in upcoming) _appointment(a)]),
      _section('Letzte Termine', [for (final a in past) _appointment(a)]),
    ];
  }

  static String _appointment(AppointmentSummary s) {
    final a = s.appointment;
    return [
      _dayTime.format(a.scheduledAt),
      s.doctorName,
      if (s.doctor?.specialty != null) s.doctor!.specialty!,
      if (a.title?.isNotEmpty == true) a.title!,
      if (a.status == AppointmentStatus.cancelled) 'abgesagt',
      if (s.diagnosisTitles.isNotEmpty) 'Diagnosen: ${s.diagnosisTitles.join(', ')}',
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
      if (times.isNotEmpty) 'Einnahme ${times.join(', ')}',
      if (times.isEmpty && med.scheduleText?.isNotEmpty == true)
        med.scheduleText!,
      if (med.instructions?.isNotEmpty == true) med.instructions!,
      if (m.diagnosis != null) 'gegen ${m.diagnosis!.title}',
      if (med.endedAt != null) 'bis ${_day.format(med.endedAt!)}',
    ].join(', ');
  }

  static String _symptom(SymptomTrend t) {
    final s = t.symptom;
    final latest = t.observations.isEmpty
        ? null
        : t.observations.reduce((a, b) => a.recordedAt.isAfter(b.recordedAt) ? a : b);
    return [
      s.label,
      if (s.bodyRegion?.isNotEmpty == true) s.bodyRegion!,
      '${t.observations.length} Check-ins',
      if (t.average != null) 'Ø ${t.average!.toStringAsFixed(1)}/10',
      if (latest != null)
        'zuletzt ${_day.format(latest.recordedAt)}: ${observationLabel(latest)}',
    ].join(', ');
  }

  static String _section(String title, List<String> lines) =>
      lines.isEmpty ? '' : '$title:\n${lines.map((l) => '- $l').join('\n')}';

  static String _clip(String text, int max) =>
      text.length <= max ? text : '${text.substring(0, max - 1)}…';

  /// Ausschnitt rund um den ersten Treffer (Berichte können lang sein).
  static String _excerpt(String body, List<String> terms, {int size = 600}) {
    final text = body.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (text.length <= size) return text;
    final lower = text.toLowerCase();
    var hit = -1;
    for (final term in terms) {
      final i = lower.indexOf(term);
      if (i >= 0 && (hit < 0 || i < hit)) hit = i;
    }
    final start = hit < 0 ? 0 : (hit - size ~/ 3).clamp(0, text.length - size);
    return '${start > 0 ? '…' : ''}${text.substring(start, start + size)}…';
  }

  static String _typeLabel(String type) => switch (type) {
    'doctor' => 'Arzt',
    'diagnosis' => 'Diagnose',
    'symptom' => 'Symptom',
    'appointment' => 'Termin',
    'report' => 'Bericht',
    'medication' => 'Medikament',
    'note' => 'Notiz',
    'pharmacy' => 'Apotheke',
    'vaccination' => 'Impfung',
    _ => type,
  };
}

/// Prompt = Akte-Auszug + Frage.
String assistantPrompt(String context, String question) =>
    'AKTE:\n$context\n\nFRAGE:\n${question.trim()}';
