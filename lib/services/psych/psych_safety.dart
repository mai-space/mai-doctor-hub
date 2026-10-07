/// v15: Ruhiges Hilfsangebot bei Gedanken an Selbstverletzung oder Suizid.
///
/// Auslöser (bewusst einfach und lokal — nichts verlässt das Gerät):
/// * Check-in des Symptoms „Gedanken an Selbstverletzung oder Suizid“ mit
///   Stärke > 0,
/// * PHQ-9 Item 9 > 0,
/// * Tagebuch-Eintrag mit eindeutigen Formulierungen (konservative Liste,
///   Deutsch und Englisch; lieber einmal zu oft ein freundlicher Hinweis).
library;

import '../../data/app_database.dart';
import '../../data/symptom_measure.dart';

/// Eindeutige Formulierungen (klein, ohne Wortgrenzen-Tricks). Keine
/// einzelnen mehrdeutigen Wörter wie „sterben“ oder „ritzen“.
const _journalPhrases = [
  // Deutsch
  'suizid',
  'selbstmord',
  'mich umbringen',
  'mich töten',
  'mir das leben nehmen',
  'nicht mehr leben',
  'nicht mehr am leben sein',
  'will sterben',
  'möchte sterben',
  'lieber tot',
  'lebensmüde',
  'selbstverletz',
  'mich verletzen',
  'mich ritzen',
  'ritze mich',
  // Englisch
  'suicide',
  'suicidal',
  'kill myself',
  'end my life',
  'take my own life',
  'want to die',
  'better off dead',
  'self-harm',
  'self harm',
  'hurt myself',
  'cut myself',
];

/// Tagebuch-Text enthält eine eindeutige Formulierung.
bool journalNeedsSupport(String? text) {
  final t = text?.toLowerCase().replaceAll(RegExp(r'\s+'), ' ') ?? '';
  if (t.trim().isEmpty) return false;
  return _journalPhrases.any(t.contains);
}

/// Check-in eines Symptoms: Gedanken an Selbstverletzung mit Stärke > 0
/// oder Tagebuch mit eindeutiger Formulierung.
bool checkInNeedsSupport({
  required Symptom symptom,
  SymptomMeasure? measure,
  double? value,
  String? journal,
}) {
  final selfHarm =
      isSelfHarmText(symptom.label) || isSelfHarmText(symptom.sensation);
  if (selfHarm &&
      (measure ?? SymptomMeasure.intensity) == SymptomMeasure.intensity &&
      (value ?? 0) > 0) {
    return true;
  }
  return journalNeedsSupport(journal);
}

/// Gespeicherter Check-in (für die Detailseite).
bool observationNeedsSupport(Symptom symptom, SymptomObservation o) =>
    checkInNeedsSupport(
      symptom: symptom,
      measure: observationMeasure(o),
      value: o.valueNumber,
      journal: o.journal,
    );

/// Telefonnummer mit Anzeige-Text.
class SupportLine {
  const SupportLine(this.name, this.number, {this.hours});

  final String name;

  /// Zum Wählen (ohne Leerzeichen über `tel:`).
  final String number;
  final String? hours;

  Uri get uri => Uri(scheme: 'tel', path: number.replaceAll(' ', ''));
}

/// Anlaufstellen nach Region; `emergency` = Notruf.
class SupportContacts {
  const SupportContacts({this.lines = const [], this.emergency});

  final List<SupportLine> lines;
  final SupportLine? emergency;

  bool get isGeneric => lines.isEmpty && emergency == null;
}

/// Region (ISO 3166, z. B. `DE`) → Anlaufstellen. Unbekannt: allgemein
/// („örtlichen Notruf kontaktieren“), bei deutscher Sprache Deutschland.
SupportContacts supportContactsFor(String? region, {String? language}) {
  final r = region?.toUpperCase() ?? (language == 'de' ? 'DE' : null);
  return switch (r) {
    'DE' => const SupportContacts(
      lines: [
        SupportLine('TelefonSeelsorge', '0800 111 0 111', hours: '24/7'),
        SupportLine('TelefonSeelsorge', '0800 111 0 222', hours: '24/7'),
      ],
      emergency: SupportLine('Notruf', '112'),
    ),
    'AT' => const SupportContacts(
      lines: [SupportLine('TelefonSeelsorge', '142', hours: '24/7')],
      emergency: SupportLine('Notruf', '112'),
    ),
    'CH' => const SupportContacts(
      lines: [SupportLine('Die Dargebotene Hand', '143', hours: '24/7')],
      emergency: SupportLine('Notruf', '144'),
    ),
    'US' => const SupportContacts(
      lines: [
        SupportLine('988 Suicide & Crisis Lifeline', '988', hours: '24/7'),
      ],
      emergency: SupportLine('Emergency', '911'),
    ),
    'CA' => const SupportContacts(
      lines: [
        SupportLine('9-8-8 Suicide Crisis Helpline', '988', hours: '24/7'),
      ],
      emergency: SupportLine('Emergency', '911'),
    ),
    'GB' => const SupportContacts(
      lines: [SupportLine('Samaritans', '116 123', hours: '24/7')],
      emergency: SupportLine('Emergency', '999'),
    ),
    'IE' => const SupportContacts(
      lines: [SupportLine('Samaritans', '116 123', hours: '24/7')],
      emergency: SupportLine('Emergency', '112'),
    ),
    'AU' => const SupportContacts(
      lines: [SupportLine('Lifeline', '13 11 14', hours: '24/7')],
      emergency: SupportLine('Emergency', '000'),
    ),
    _ => const SupportContacts(),
  };
}
