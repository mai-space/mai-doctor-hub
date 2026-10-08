import '../../data/app_database.dart';
import '../../l10n/l10n.dart';
import 'record_context.dart';

/// Richtung einer Folgefrage: verstehen (Zusammenhänge, Verlauf) oder
/// handeln (beobachten, Ärztin fragen, wann zum Arzt).
enum FollowUpKind { understand, act }

class FollowUp {
  const FollowUp(this.text, this.kind);

  final String text;
  final FollowUpKind kind;
}

/// Höchstzahl der Vorschläge unter einer Antwort.
const maxFollowUps = 3;

/// Längere Vorschläge passen nicht in einen Chip und werden verworfen.
const _maxFollowUpLength = 90;

const _markerWords =
    r'folgefragen|weiterführende fragen|follow[- ]?ups?(?: questions?)?';

/// Markierung am Zeilenanfang, ggf. mit Aufzählungs-/Fett-/Überschrift-
/// zeichen — mit Doppelpunkt oder als eigene Zeile (Überschrift).
final _lineMarker = RegExp(
  '(?:^|\\n)[ \\t>#*_•-]*(?:$_markerWords)[ \\t*_]*(?::|(?=\\n|\$))[ \\t*_]*',
  caseSensitive: false,
);

/// Markierung mitten in der Zeile — nur in Großbuchstaben mit Doppelpunkt.
final _inlineMarker = RegExp(r'(?:FOLGEFRAGEN|FOLLOW-?UPS)[ \t*_]*:[ \t*_]*');

/// Anfänge der Markierung, um sie beim Streamen schon vorab auszublenden.
const _markerPrefixes = [
  'folgefragen',
  'weiterführende fragen',
  'follow-ups',
  'follow ups',
  'followups',
  'follow-up questions',
  'follow up questions',
];

/// Platzhalter aus der Anweisung, die das Modell gern wörtlich übernimmt.
final _placeholder = RegExp(
  r'^(?:frage|question)\s*\d*$|^[.…\s]*$',
  caseSensitive: false,
);

/// Trennt die Antwort des Modells in sichtbaren Text und vorgeschlagene
/// Folgefragen (`FOLGEFRAGEN: a | b | c`). Mit [streaming] wird auch eine
/// gerade erst begonnene Markierung am Ende ausgeblendet.
({String text, List<String> followUps}) splitFollowUps(
  String raw, {
  bool streaming = false,
}) {
  final matches = [
    _lineMarker.firstMatch(raw),
    _inlineMarker.firstMatch(raw),
  ].whereType<RegExpMatch>().toList()
    ..sort((a, b) => a.start.compareTo(b.start));
  if (matches.isNotEmpty) {
    final marker = matches.first;
    return (
      text: _tidy(raw.substring(0, marker.start)),
      followUps: parseFollowUps(raw.substring(marker.end)),
    );
  }
  var text = raw;
  if (streaming) {
    final lineStart = text.lastIndexOf('\n') + 1;
    final bare = text
        .substring(lineStart)
        .replaceAll(RegExp(r'^[ \t>#*_•-]*'), '')
        .trimRight()
        .toLowerCase();
    final inline = RegExp(r'[ \t]([A-Z][A-Z-]+)$').firstMatch(text);
    if (bare.isNotEmpty && _markerPrefixes.any((m) => m.startsWith(bare))) {
      text = text.substring(0, lineStart);
    } else if (inline != null &&
        ['FOLGEFRAGEN', 'FOLLOW-UPS'].any(
          (m) => m.startsWith(inline.group(1)!),
        )) {
      text = text.substring(0, inline.start);
    }
  }
  return (text: _tidy(text), followUps: const []);
}

/// Ohne abschließende Leerzeilen und Trennlinie vor den Folgefragen.
String _tidy(String text) =>
    text.trimRight().replaceFirst(RegExp(r'\n\s*[-*_]{3,}$'), '').trimRight();

/// Einzelne Fragen: durch „|“ oder Zeilen getrennt, ohne Aufzählungs-
/// zeichen, Anführungszeichen und Doppelte; höchstens [maxFollowUps].
List<String> parseFollowUps(String tail) {
  final seen = <String>{};
  final questions = <String>[];
  for (final raw in tail.split(RegExp(r'[|\n]'))) {
    final q = raw
        .replaceAll(RegExp(r'^[\s\-•*>\d.)]+'), '')
        .replaceAll(RegExp(r'["„“”«»*_`]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (q.length < 4 || q.length > _maxFollowUpLength) continue;
    if (_placeholder.hasMatch(q)) continue;
    if (!RegExp(r'\p{L}', unicode: true).hasMatch(q)) continue;
    if (seen.add(q.toLowerCase())) questions.add(q);
    if (questions.length == maxFollowUps) break;
  }
  return questions;
}

final _actPattern = RegExp(
  r'beobacht|notier|festhalt|frag|ärzt|arzt|praxis|\btun\b|unternehm|'
  r'soll ich|sollte ich|hilft|helfen|vorbeug|112|notfall|'
  r'observe|track|\blog\b|note|keep an eye|\bask\b|doctor|should i|can i do|'
  r'help|prevent|seek|emergency',
  caseSensitive: false,
);

/// Ordnet eine Frage grob einer Richtung zu.
FollowUpKind classifyFollowUp(String question) =>
    _actPattern.hasMatch(question) ? FollowUpKind.act : FollowUpKind.understand;

/// Feste Vorschläge, wenn das Modell keine brauchbaren liefert —
/// symptombezogen, wenn die Frage ein erfasstes Symptom nennt.
List<FollowUp> fallbackFollowUps(AppLocalizations l10n, {String? symptom}) =>
    symptom == null
    ? [
        FollowUp(l10n.assistantFollowUpRelated, FollowUpKind.understand),
        FollowUp(l10n.assistantFollowUpObserve, FollowUpKind.act),
        FollowUp(l10n.assistantFollowUpAskDoctor, FollowUpKind.act),
      ]
    : [
        FollowUp(
          l10n.assistantFollowUpSymptomCourse(symptom),
          FollowUpKind.understand,
        ),
        FollowUp(
          l10n.assistantFollowUpSymptomRelated(symptom),
          FollowUpKind.understand,
        ),
        FollowUp(l10n.assistantFollowUpSymptomDoctor(symptom), FollowUpKind.act),
      ];

/// Vorschläge unter einer Antwort: die des Modells, sonst feste; in jedem
/// Fall mindestens einer zum Verstehen und einer zum Handeln.
List<FollowUp> followUpsFor(
  List<String> suggested, {
  required String question,
  required AppLocalizations l10n,
  String? symptom,
}) {
  final asked = question.trim().toLowerCase();
  bool fresh(String q, List<FollowUp> list) =>
      q.toLowerCase() != asked &&
      !list.any((f) => f.text.toLowerCase() == q.toLowerCase());
  final result = <FollowUp>[];
  for (final q in suggested) {
    if (fresh(q, result)) result.add(FollowUp(q, classifyFollowUp(q)));
  }
  final pool = [
    ...fallbackFollowUps(l10n, symptom: symptom),
    FollowUp(l10n.assistantFollowUpDevelopment, FollowUpKind.understand),
    FollowUp(l10n.assistantFollowUpWhenDoctor, FollowUpKind.act),
  ];
  if (result.isEmpty) {
    for (final f in pool) {
      if (result.length < maxFollowUps && fresh(f.text, result)) result.add(f);
    }
  }
  for (final kind in FollowUpKind.values) {
    if (result.any((f) => f.kind == kind)) continue;
    final extra = pool
        .where((f) => f.kind == kind && fresh(f.text, result))
        .firstOrNull;
    if (extra == null) continue;
    if (result.length >= maxFollowUps) {
      result[maxFollowUps - 1] = extra;
    } else {
      result.add(extra);
    }
  }
  return result.take(maxFollowUps).toList();
}

/// Erstes erfasstes (nicht archiviertes) Symptom, das die Frage nennt.
Future<String?> mentionedSymptom(AppDatabase db, String question) async {
  final labels = [
    for (final s in await db.selectActive(db.symptoms).get()) s.label,
  ];
  return matchSymptom(labels, question);
}

/// Längste Bezeichnung zuerst; trifft auch Wortanfänge
/// („Kopfschmerz“ ↔ „Kopfschmerzen“).
String? matchSymptom(List<String> labels, String question) {
  final lower = question.toLowerCase();
  final sorted = [
    for (final l in labels)
      if (l.trim().isNotEmpty) l.trim(),
  ]..sort((a, b) => b.length.compareTo(a.length));
  for (final label in sorted) {
    if (lower.contains(label.toLowerCase())) return label;
  }
  final words = AssistantContextBuilder.keywords(question);
  for (final label in sorted) {
    for (final part in AssistantContextBuilder.keywords(label)) {
      for (final word in words) {
        final short = part.length < word.length ? part : word;
        if (short.length >= 5 &&
            (word.startsWith(part) || part.startsWith(word))) {
          return label;
        }
      }
    }
  }
  return null;
}

/// Die letzten (höchstens zwei) Fragen und gekürzten Antworten für den
/// Prompt — höchstens [maxChars] Zeichen; ältere fallen zuerst weg.
String conversationHistory(
  List<({String question, String answer})> turns,
  int maxChars,
  AppLocalizations l10n,
) {
  String flat(String s, int max) {
    final t = s.replaceAll(RegExp(r'\s+'), ' ').trim();
    return t.length <= max ? t : '${t.substring(0, max - 1)}…';
  }

  final recent = turns.length > 2 ? turns.sublist(turns.length - 2) : turns;
  for (var start = 0; start < recent.length; start++) {
    final kept = recent.sublist(start);
    // Gleichmäßig verteilt, die Frage bekommt höchstens 200 Zeichen.
    final perTurn = maxChars ~/ kept.length - 30;
    if (perTurn < 180) continue;
    final text = [
      for (final t in kept)
        if (flat(t.question, 200) case final q)
          l10n.assistantHistoryTurn(
            q,
            flat(t.answer, (perTurn - q.length).clamp(40, perTurn)),
          ),
    ].join('\n');
    if (text.length <= maxChars) return text;
  }
  return '';
}
