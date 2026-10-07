/// v15: Fragebögen zur Psyche — PHQ-9 (Depression) und GAD-7 (Angst).
///
/// Quellen:
/// * PHQ-9: Kroenke K, Spitzer RL, Williams JBW. The PHQ-9: validity of a
///   brief depression severity measure. J Gen Intern Med 2001;16:606–613.
///   Schweregrade 0–4 minimal, 5–9 leicht, 10–14 mittelgradig, 15–19
///   ausgeprägt (mittelschwer), 20–27 schwer.
/// * GAD-7: Spitzer RL, Kroenke K, Williams JBW, Löwe B. A brief measure for
///   assessing generalized anxiety disorder. Arch Intern Med
///   2006;166:1092–1097. Schweregrade 0–4 minimal, 5–9 leicht, 10–14
///   mittelgradig, 15–21 schwer.
/// * Deutsche Fassung (PHQ-D): Löwe B, Spitzer RL, Zipfel S, Herzog W.
///   Gesundheitsfragebogen für Patienten (PHQ-D), 2. Aufl., Pfizer 2002;
///   GAD-7: Löwe B et al., Med Care 2008;46:266–274.
///
/// Lizenz: PHQ und GAD-7 wurden von Spitzer, Williams, Kroenke und Kollegen
/// mit einem Ausbildungsstipendium von Pfizer entwickelt; Abdruck,
/// Übersetzung, Anzeige und Verbreitung sind ohne Genehmigung erlaubt
/// (www.phqscreeners.com). Ergebnisse sind keine Diagnose.
library;

import '../../l10n/l10n.dart';

enum PsychInstrument {
  phq9('phq9', 9, 27),
  gad7('gad7', 7, 21);

  const PsychInstrument(this.code, this.itemCount, this.maxScore);

  final String code;
  final int itemCount;
  final int maxScore;

  static PsychInstrument? fromCode(String? code) =>
      values.where((i) => i.code == code).firstOrNull;
}

/// Antworten je Item: 0 überhaupt nicht … 3 beinahe jeden Tag.
const psychMaxItem = 3;

/// Index des PHQ-9-Items 9 (Gedanken an Tod/Selbstverletzung).
const phq9SelfHarmItem = 8;

enum PsychSeverity { minimal, mild, moderate, moderatelySevere, severe }

class PsychResult {
  PsychResult(this.instrument, List<int> scores)
    : scores = List.unmodifiable([
        for (var i = 0; i < instrument.itemCount; i++)
          i < scores.length ? scores[i].clamp(0, psychMaxItem) : 0,
      ]);

  /// Unvollständige/ungültige Werte zählen als 0.
  factory PsychResult.parse(PsychInstrument instrument, String raw) =>
      PsychResult(instrument, [
        for (final part in raw.split(',')) int.tryParse(part.trim()) ?? 0,
      ]);

  final PsychInstrument instrument;
  final List<int> scores;

  int get total => scores.fold(0, (a, b) => a + b);

  PsychSeverity get severity => psychSeverity(instrument, total);

  /// PHQ-9 Item 9 > 0: Hilfsangebot zeigen (siehe `psych_safety.dart`).
  bool get selfHarmFlag =>
      instrument == PsychInstrument.phq9 && scores[phq9SelfHarmItem] > 0;

  String encode() => scores.join(',');
}

PsychSeverity psychSeverity(PsychInstrument instrument, int total) {
  if (total <= 4) return PsychSeverity.minimal;
  if (total <= 9) return PsychSeverity.mild;
  if (total <= 14) return PsychSeverity.moderate;
  return switch (instrument) {
    PsychInstrument.phq9 =>
      total <= 19 ? PsychSeverity.moderatelySevere : PsychSeverity.severe,
    // GAD-7 kennt keine Stufe „ausgeprägt“: 15–21 = schwer.
    PsychInstrument.gad7 => PsychSeverity.severe,
  };
}

String psychSeverityLabel(PsychSeverity s, AppLocalizations l10n) =>
    switch (s) {
      PsychSeverity.minimal => l10n.psychSeverityMinimal,
      PsychSeverity.mild => l10n.psychSeverityMild,
      PsychSeverity.moderate => l10n.psychSeverityModerate,
      PsychSeverity.moderatelySevere => l10n.psychSeverityModeratelySevere,
      PsychSeverity.severe => l10n.psychSeveritySevere,
    };

String psychInstrumentLabel(PsychInstrument i, AppLocalizations l10n) =>
    switch (i) {
      PsychInstrument.phq9 => l10n.psychPhq9Title,
      PsychInstrument.gad7 => l10n.psychGad7Title,
    };

/// Offizielle Item-Formulierungen (PHQ-D bzw. englisches Original).
List<String> psychItems(PsychInstrument i, AppLocalizations l10n) =>
    switch (i) {
      PsychInstrument.phq9 => [
        l10n.psychPhq1,
        l10n.psychPhq2,
        l10n.psychPhq3,
        l10n.psychPhq4,
        l10n.psychPhq5,
        l10n.psychPhq6,
        l10n.psychPhq7,
        l10n.psychPhq8,
        l10n.psychPhq9,
      ],
      PsychInstrument.gad7 => [
        l10n.psychGad1,
        l10n.psychGad2,
        l10n.psychGad3,
        l10n.psychGad4,
        l10n.psychGad5,
        l10n.psychGad6,
        l10n.psychGad7,
      ],
    };

/// Antwortstufen 0–3.
List<String> psychAnswerLabels(AppLocalizations l10n) => [
  l10n.psychAnswer0,
  l10n.psychAnswer1,
  l10n.psychAnswer2,
  l10n.psychAnswer3,
];

/// „PHQ-9: 12 von 27 — mittelgradig“.
String psychSummary(PsychResult r, AppLocalizations l10n) =>
    l10n.psychResultSummary(
      psychInstrumentLabel(r.instrument, l10n),
      r.total,
      r.instrument.maxScore,
      psychSeverityLabel(r.severity, l10n),
    );
