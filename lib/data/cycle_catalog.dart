/// Begriffe des Zyklus-Tagebuchs: Symptome, Schmerzorte, Ausfluss.
///
/// Gespeichert werden stabile Schlüssel (sprachunabhängig); angezeigt wird
/// der Begriff in der App-Sprache. Unbekannte Schlüssel sind eigene
/// Freitext-Einträge und werden unverändert angezeigt.
library;

import '../l10n/l10n.dart';
import 'symptom_descriptors.dart' show Term;

/// Begriff mit Schlüssel.
class CycleTerm {
  const CycleTerm(this.key, this.label);

  final String key;
  final Term label;

  String get localized =>
      AppLocale.current.languageCode == 'de' ? label.$1 : label.$2;
}

/// Gruppe (z. B. „Körper“, „Stimmung“).
class CycleTermGroup {
  const CycleTermGroup(this.key, this.title, this.terms);

  final String key;
  final Term title;
  final List<CycleTerm> terms;

  String get localizedTitle =>
      AppLocale.current.languageCode == 'de' ? title.$1 : title.$2;
}

abstract final class CycleCatalog {
  static const physical = CycleTermGroup(
    'physical',
    ('Körper', 'Body'),
    [
      CycleTerm('cramps', ('Krämpfe', 'Cramps')),
      CycleTerm('headache', ('Kopfschmerz/Migräne', 'Headache/migraine')),
      CycleTerm('breast_tenderness', ('Brustspannen', 'Breast tenderness')),
      CycleTerm('bloating', ('Blähungen', 'Bloating')),
      CycleTerm('nausea', ('Übelkeit', 'Nausea')),
      CycleTerm('diarrhea', ('Durchfall', 'Diarrhea')),
      CycleTerm('constipation', ('Verstopfung', 'Constipation')),
      CycleTerm('back_pain', ('Rückenschmerzen', 'Back pain')),
      CycleTerm('fatigue', ('Müdigkeit', 'Tiredness')),
      CycleTerm('acne', ('Akne/Hautunreinheiten', 'Acne/breakouts')),
      CycleTerm('water_retention', ('Wassereinlagerungen', 'Water retention')),
      CycleTerm('cravings', ('Heißhunger', 'Cravings')),
      CycleTerm('sleep_problems', ('Schlafprobleme', 'Trouble sleeping')),
      CycleTerm('dizziness', ('Schwindel', 'Dizziness')),
    ],
  );

  static const mood = CycleTermGroup(
    'mood',
    ('Stimmung', 'Mood'),
    [
      CycleTerm('mood_swings', ('Stimmungsschwankungen', 'Mood swings')),
      CycleTerm('irritability', ('Reizbarkeit', 'Irritability')),
      CycleTerm('low_mood', ('Niedergeschlagenheit', 'Low mood')),
      CycleTerm('anxiety', ('Ängstlichkeit', 'Anxiety')),
      CycleTerm('poor_concentration', (
        'Konzentrationsprobleme',
        'Trouble concentrating',
      )),
    ],
  );

  static const menopause = CycleTermGroup(
    'menopause',
    ('Wechseljahre', 'Menopause'),
    [
      CycleTerm('joint_pain', ('Gelenk-/Muskelschmerzen', 'Joint/muscle pain')),
      CycleTerm('vaginal_dryness', ('Scheidentrockenheit', 'Vaginal dryness')),
      CycleTerm('palpitations', ('Herzklopfen', 'Palpitations')),
      CycleTerm('bladder', ('Blasenbeschwerden', 'Bladder problems')),
    ],
  );

  static const pregnancy = CycleTermGroup(
    'pregnancy',
    ('Schwangerschaft', 'Pregnancy'),
    [
      CycleTerm('vomiting', ('Erbrechen', 'Vomiting')),
      CycleTerm('contractions', ('Wehen/Ziehen', 'Contractions/tightening')),
      CycleTerm('heartburn', ('Sodbrennen', 'Heartburn')),
      CycleTerm('pelvic_pressure', ('Druck im Becken', 'Pelvic pressure')),
    ],
  );

  static const painLocations = [
    CycleTerm('lower_abdomen', ('Unterbauch', 'Lower abdomen')),
    CycleTerm('lower_back', ('Unterer Rücken', 'Lower back')),
    CycleTerm('legs', ('Beine', 'Legs')),
    CycleTerm('breasts', ('Brust', 'Breasts')),
    CycleTerm('head', ('Kopf', 'Head')),
    CycleTerm('toilet', (
      'Beim Wasserlassen/Stuhlgang',
      'When urinating/passing stool',
    )),
    CycleTerm('intercourse', (
      'Beim Geschlechtsverkehr (Dyspareunie)',
      'During sex (dyspareunia)',
    )),
  ];

  static const discharge = [
    CycleTerm('none', ('Keiner', 'None')),
    CycleTerm('sticky', ('Klebrig', 'Sticky')),
    CycleTerm('creamy', ('Cremig', 'Creamy')),
    CycleTerm('eggwhite', ('Spinnbar/eiweißartig', 'Stretchy/egg white')),
    CycleTerm('watery', ('Wässrig', 'Watery')),
    CycleTerm('unusual', (
      'Ungewöhnlich (Farbe/Geruch)',
      'Unusual (colour/smell)',
    )),
  ];

  /// Symptom-Gruppen für die aktiven Bereiche.
  static List<CycleTermGroup> symptomGroups({
    bool menopause = false,
    bool pregnancy = false,
  }) => [
    physical,
    mood,
    if (menopause) CycleCatalog.menopause,
    if (pregnancy) CycleCatalog.pregnancy,
  ];

  static final Map<String, CycleTerm> _all = {
    for (final g in [physical, mood, menopause, pregnancy])
      for (final t in g.terms) t.key: t,
  };

  static final Map<String, CycleTerm> _locations = {
    for (final t in painLocations) t.key: t,
  };

  static final Map<String, CycleTerm> _discharge = {
    for (final t in discharge) t.key: t,
  };

  /// Symptom-Schlüssel → Begriff in der App-Sprache (Freitext unverändert).
  static String symptomLabel(String key) => _all[key]?.localized ?? key;

  static String painLocationLabel(String key) =>
      _locations[key]?.localized ?? key;

  static String dischargeLabel(String key) => _discharge[key]?.localized ?? key;

  /// Ist [key] ein Katalog-Symptom (sonst eigener Begriff)?
  static bool isKnownSymptom(String key) => _all.containsKey(key);

  /// Vorschläge für eigene Einträge („andere“).
  static const otherSuggestions = <Term>[
    ('Hitzegefühl', 'Feeling hot'),
    ('Frösteln', 'Chills'),
    ('Libido verändert', 'Changed libido'),
    ('Haarausfall', 'Hair loss'),
    ('Gereizte Blase', 'Irritable bladder'),
    ('Zahnfleischbluten', 'Bleeding gums'),
    ('Nasenbluten', 'Nosebleed'),
    ('Wadenkrämpfe', 'Leg cramps'),
    ('Sehstörung', 'Visual disturbance'),
    ('Juckreiz im Intimbereich', 'Intimate itching'),
  ];

  static List<String> get localizedOtherSuggestions => [
    for (final t in otherSuggestions)
      AppLocale.current.languageCode == 'de' ? t.$1 : t.$2,
  ];
}

/// Fachrichtung, unter der die Gynäkologie angelegt wird (Katalogbegriff,
/// damit Icon und Vorschläge passen).
String gynecologySpecialty() => AppLocale.current.languageCode == 'de'
    ? 'Frauenheilkunde und Geburtshilfe (Gynäkologie)'
    : 'Obstetrics and Gynecology (OB/GYN)';

/// Erkennt gynäkologische Fachrichtungen in beiden Sprachen, auch frei
/// eingetippte („Gynäkologin“, „Frauenärztin“, „OB/GYN“).
bool isGynecologySpecialty(String? specialty) {
  final s = specialty?.toLowerCase() ?? '';
  return s.contains('gyn') ||
      s.contains('frauenheil') ||
      s.contains('frauenarzt') ||
      s.contains('frauenärzt') ||
      s.contains('obstetric');
}
