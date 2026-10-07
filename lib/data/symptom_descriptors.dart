/// Vorschläge für die strukturierte Symptom-Beschreibung:
/// Qualität + Empfindung + Ort + Stärke, z. B. brennender Schmerz am
/// Hinterkopf links, 7/10.
///
/// Alle Begriffe sind Vorschläge — Freitext ist immer erlaubt. Gruppen dienen
/// der Liste „zum Reflektieren“ im Auswahl-Sheet. Jeder Begriff steht als Paar
/// (Deutsch, Englisch); die UI greift über [SymptomDescriptors] auf die
/// aktuelle App-Sprache zu (wie bei [SuggestionCatalog]).
library;

import '../l10n/l10n.dart';

/// Begriff in beiden Sprachen.
typedef Term = (String de, String en);

/// Gruppe von Begriffen mit stabilem [key] (sprachunabhängig).
class DescriptorGroup {
  const DescriptorGroup(this.key, this.title, this.terms);

  final String key;
  final Term title;
  final List<Term> terms;
}

/// Gruppe in der App-Sprache.
class LocalizedGroup {
  const LocalizedGroup(this.key, this.title, this.items);

  final String key;
  final String title;
  final List<String> items;
}

abstract final class SymptomDescriptors {
  static bool get _german => AppLocale.current.languageCode == 'de';

  static List<LocalizedGroup> _localize(List<DescriptorGroup> groups) => [
    for (final g in groups)
      LocalizedGroup(g.key, _german ? g.title.$1 : g.title.$2, [
        for (final t in g.terms) _german ? t.$1 : t.$2,
      ]),
  ];

  /// Art der Empfindung (Schmerz, Juckreiz, Übelkeit …).
  static List<LocalizedGroup> get sensations => _localize(sensationGroups);

  /// Qualität/Charakter (stechend, brennend …).
  static List<LocalizedGroup> get qualities => _localize(qualityGroups);

  /// Körperstellen, nach Region gruppiert.
  static List<LocalizedGroup> get locations => _localize(locationGroups);

  /// Verlauf, Auslöser und Tageszeit.
  static List<LocalizedGroup> get patterns => _localize(patternGroups);

  /// Alle Begriffe der [groups] als flache Liste (für die Suche).
  static List<String> flat(List<LocalizedGroup> groups) => [
    for (final g in groups) ...g.items,
  ];

  /// Qualitäts-Gruppen, die zur Empfindung passen, zuerst — so stehen bei
  /// „Juckreiz“ die Haut-Begriffe oben, bei „Kribbeln“ die Nerven-Begriffe.
  static List<LocalizedGroup> qualitiesFor(String? sensation) {
    final groups = qualities;
    final preferred = _qualityHints[_sensationGroupOf(sensation)] ?? const [];
    if (preferred.isEmpty) return groups;
    int rank(LocalizedGroup g) {
      final i = preferred.indexOf(g.key);
      return i < 0 ? preferred.length : i;
    }

    // Stabil sortieren: Index als Tiebreaker.
    final indexed = groups.indexed.toList()
      ..sort((a, b) {
        final byRank = rank(a.$2).compareTo(rank(b.$2));
        return byRank != 0 ? byRank : a.$1.compareTo(b.$1);
      });
    return [for (final (_, g) in indexed) g];
  }

  static String? _sensationGroupOf(String? sensation) {
    final value = sensation?.trim().toLowerCase();
    if (value == null || value.isEmpty) return null;
    for (final g in sensationGroups) {
      for (final (de, en) in g.terms) {
        if (de.toLowerCase() == value || en.toLowerCase() == value) {
          return g.key;
        }
      }
    }
    return null;
  }

  /// Empfindungs-Gruppe → bevorzugte Qualitäts-Gruppen.
  static const _qualityHints = <String, List<String>>{
    'pain': ['pain', 'spread', 'tension'],
    'nerve': ['nerve', 'spread', 'temperature'],
    'skin': ['skin', 'temperature', 'spread'],
    'digest': ['feeling', 'pain'],
    'head': ['feeling', 'pain'],
    'breath': ['tension', 'feeling'],
    'general': ['feeling', 'temperature'],
    'mind': ['feeling', 'tension'],
    'drive': ['feeling', 'tension'],
    'anxiety': ['feeling', 'tension'],
    'thinking': ['feeling'],
    'perception': ['feeling'],
    'mindOther': ['feeling'],
    'selfHarm': ['feeling'],
  };

  /// v15: Gruppen-Schlüssel der Empfindung (z. B. `pain`, `mind`), auch für
  /// englische Begriffe; `null` bei eigenen Begriffen.
  static String? sensationGroupOf(String? sensation) =>
      _sensationGroupOf(sensation);

  /// v15: Gruppen der Psyche (für Messgröße, Erinnerungen, Fragebögen).
  static const psychGroupKeys = {
    'mind',
    'drive',
    'anxiety',
    'thinking',
    'perception',
    'mindOther',
    'selfHarm',
  };
}

/// v15: Baustein für Gedanken an Selbstverletzung oder Suizid — bei Stärke
/// > 0 zeigt der Check-in Hilfsangebote (siehe `psych_safety.dart`).
const Term selfHarmThoughts = (
  'Gedanken an Selbstverletzung oder Suizid',
  'Thoughts of self-harm or suicide',
);

const sensationGroups = <DescriptorGroup>[
  DescriptorGroup(
    'pain',
    ('Schmerz & Druck', 'Pain & pressure'),
    [
      ('Schmerz', 'Pain'),
      ('Druckgefühl', 'Pressure'),
      ('Krampf', 'Cramp'),
      ('Spannungsgefühl', 'Tightness'),
      ('Steifheit', 'Stiffness'),
      ('Muskelkater', 'Muscle soreness'),
      ('Wundgefühl', 'Soreness'),
    ],
  ),
  DescriptorGroup(
    'nerve',
    ('Nerven & Gefühl', 'Nerves & sensation'),
    [
      ('Taubheit', 'Numbness'),
      ('Kribbeln', 'Tingling'),
      ('Brennen', 'Burning'),
      ('Missempfindung', 'Abnormal sensation'),
      ('Schwäche', 'Weakness'),
      ('Zittern', 'Tremor'),
      ('Zucken', 'Twitching'),
    ],
  ),
  DescriptorGroup(
    'skin',
    ('Haut', 'Skin'),
    [
      ('Juckreiz', 'Itch'),
      ('Ausschlag', 'Rash'),
      ('Rötung', 'Redness'),
      ('Schwellung', 'Swelling'),
      ('Trockenheit', 'Dryness'),
      ('Bläschen', 'Blisters'),
      ('Schuppung', 'Scaling'),
      ('Quaddeln', 'Hives'),
    ],
  ),
  DescriptorGroup(
    'digest',
    ('Bauch & Verdauung', 'Stomach & digestion'),
    [
      ('Übelkeit', 'Nausea'),
      ('Erbrechen', 'Vomiting'),
      ('Völlegefühl', 'Bloating'),
      ('Blähungen', 'Flatulence'),
      ('Sodbrennen', 'Heartburn'),
      ('Aufstoßen', 'Belching'),
      ('Durchfall', 'Diarrhea'),
      ('Verstopfung', 'Constipation'),
      ('Appetitlosigkeit', 'Loss of appetite'),
    ],
  ),
  DescriptorGroup(
    'head',
    ('Kopf, Kreislauf & Sinne', 'Head, circulation & senses'),
    [
      ('Schwindel', 'Dizziness'),
      ('Benommenheit', 'Light-headedness'),
      ('Ohrgeräusch', 'Ringing in the ears'),
      ('Sehstörung', 'Visual disturbance'),
      ('Lichtempfindlichkeit', 'Sensitivity to light'),
      ('Geräuschempfindlichkeit', 'Sensitivity to noise'),
      ('Herzklopfen', 'Palpitations'),
      ('Herzrasen', 'Racing heart'),
      ('Ohnmachtsgefühl', 'Feeling faint'),
    ],
  ),
  DescriptorGroup(
    'breath',
    ('Atmung', 'Breathing'),
    [
      ('Atemnot', 'Shortness of breath'),
      ('Husten', 'Cough'),
      ('Engegefühl', 'Chest tightness'),
      ('Halskratzen', 'Scratchy throat'),
      ('Verstopfte Nase', 'Blocked nose'),
      ('Heiserkeit', 'Hoarseness'),
    ],
  ),
  DescriptorGroup(
    'general',
    ('Allgemein', 'General'),
    [
      ('Müdigkeit', 'Tiredness'),
      ('Erschöpfung', 'Exhaustion'),
      ('Hitzegefühl', 'Feeling hot'),
      ('Kältegefühl', 'Feeling cold'),
      ('Schüttelfrost', 'Chills'),
      ('Schwitzen', 'Sweating'),
      ('Schlafstörung', 'Trouble sleeping'),
    ],
  ),
  // v15: Psyche — Stimmung, Antrieb, Angst, Denken, Wahrnehmung, Sonstiges
  // und belastende Gedanken (eigene Gruppe, damit sie nicht untergehen).
  DescriptorGroup(
    'mind',
    ('Stimmung', 'Mood'),
    [
      ('Traurigkeit', 'Sadness'),
      ('Niedergeschlagenheit', 'Low mood'),
      ('Leere', 'Emptiness'),
      ('Hoffnungslosigkeit', 'Hopelessness'),
      ('Gereiztheit', 'Irritability'),
      ('Hochgefühl', 'Elevated mood'),
      ('Manie', 'Mania'),
      ('Euphorie', 'Euphoria'),
    ],
  ),
  DescriptorGroup(
    'drive',
    ('Antrieb', 'Drive'),
    [
      ('Antriebslosigkeit', 'Lack of drive'),
      ('Innere Unruhe', 'Inner restlessness'),
      ('Getriebenheit', 'Feeling driven'),
      ('Vermindertes Schlafbedürfnis', 'Reduced need for sleep'),
    ],
  ),
  DescriptorGroup(
    'anxiety',
    ('Angst', 'Anxiety'),
    [
      ('Angst', 'Anxiety'),
      ('Panikattacke', 'Panic attack'),
      ('Sorgen/Grübeln', 'Worry/rumination'),
      ('Anspannung', 'Tension'),
    ],
  ),
  DescriptorGroup(
    'thinking',
    ('Denken', 'Thinking'),
    [
      ('Gedankenrasen', 'Racing thoughts'),
      ('Konzentrationsprobleme', 'Trouble concentrating'),
      ('Entscheidungsschwierigkeiten', 'Trouble making decisions'),
    ],
  ),
  DescriptorGroup(
    'perception',
    ('Wahrnehmung', 'Perception'),
    [('Dissoziation', 'Dissociation'), ('Derealisation', 'Derealisation')],
  ),
  DescriptorGroup(
    'mindOther',
    ('Sonstiges (Psyche)', 'Other (mind)'),
    [
      ('Sozialer Rückzug', 'Social withdrawal'),
      ('Appetitveränderung', 'Change in appetite'),
      ('Selbstwertprobleme', 'Low self-esteem'),
    ],
  ),
  DescriptorGroup(
    'selfHarm',
    ('Belastende Gedanken', 'Distressing thoughts'),
    [selfHarmThoughts],
  ),
];

const qualityGroups = <DescriptorGroup>[
  DescriptorGroup(
    'pain',
    ('Schmerzcharakter', 'Pain character'),
    [
      ('stechend', 'stabbing'),
      ('brennend', 'burning'),
      ('pochend', 'throbbing'),
      ('pulsierend', 'pulsating'),
      ('klopfend', 'pounding'),
      ('hämmernd', 'hammering'),
      ('drückend', 'pressing'),
      ('ziehend', 'pulling'),
      ('dumpf', 'dull'),
      ('scharf', 'sharp'),
      ('krampfartig', 'cramping'),
      ('kolikartig', 'colicky'),
      ('schneidend', 'cutting'),
      ('bohrend', 'boring'),
      ('reißend', 'tearing'),
      ('nagend', 'gnawing'),
      ('quetschend', 'squeezing'),
      ('einschnürend', 'constricting'),
    ],
  ),
  DescriptorGroup(
    'nerve',
    ('Nervenartig', 'Nerve-like'),
    [
      ('elektrisierend', 'electric'),
      ('einschießend', 'shooting'),
      ('kribbelnd', 'tingling'),
      ('taub', 'numb'),
      ('pelzig', 'furry'),
      ('wie Ameisenlaufen', 'like ants crawling'),
      ('wie Nadelstiche', 'like pins and needles'),
      ('berührungsempfindlich', 'tender to touch'),
    ],
  ),
  DescriptorGroup(
    'spread',
    ('Ausbreitung', 'Spread'),
    [
      ('ausstrahlend', 'radiating'),
      ('wandernd', 'migrating'),
      ('punktuell', 'pinpoint'),
      ('flächig', 'widespread'),
      ('oberflächlich', 'superficial'),
      ('tief', 'deep'),
    ],
  ),
  DescriptorGroup(
    'skin',
    ('Haut', 'Skin'),
    [
      ('juckend', 'itchy'),
      ('spannend', 'taut'),
      ('nässend', 'weeping'),
      ('schuppend', 'flaky'),
      ('trocken', 'dry'),
      ('gerötet', 'reddened'),
      ('geschwollen', 'swollen'),
      ('wund', 'raw'),
    ],
  ),
  DescriptorGroup(
    'tension',
    ('Spannung & Bewegung', 'Tension & movement'),
    [
      ('steif', 'stiff'),
      ('verspannt', 'tense'),
      ('blockiert', 'locked'),
      ('schwer', 'heavy'),
      ('instabil', 'unstable'),
      ('kraftlos', 'weak'),
      ('zitternd', 'shaky'),
      ('eng', 'tight'),
    ],
  ),
  DescriptorGroup(
    'temperature',
    ('Temperatur', 'Temperature'),
    [('heiß', 'hot'), ('warm', 'warm'), ('kalt', 'cold'), ('eiskalt', 'icy')],
  ),
  DescriptorGroup(
    'feeling',
    ('Empfinden', 'Feeling'),
    [
      ('drehend', 'spinning'),
      ('schwankend', 'swaying'),
      ('benommen', 'foggy'),
      ('flau', 'queasy'),
      ('wie Watte', 'cotton-wool'),
      ('leer', 'empty'),
      ('erdrückend', 'overwhelming'),
      ('innerlich unruhig', 'jittery'),
    ],
  ),
];

const patternGroups = <DescriptorGroup>[
  DescriptorGroup(
    'course',
    ('Verlauf', 'Course'),
    [
      ('dauerhaft', 'constant'),
      ('anfallsartig', 'in attacks'),
      ('wellenförmig', 'in waves'),
      ('zunehmend', 'getting worse'),
      ('abnehmend', 'easing'),
      ('wechselnd', 'fluctuating'),
      ('plötzlich einsetzend', 'sudden onset'),
      ('schleichend', 'gradual onset'),
    ],
  ),
  DescriptorGroup(
    'trigger',
    ('Auslöser', 'Trigger'),
    [
      ('bei Belastung', 'on exertion'),
      ('in Ruhe', 'at rest'),
      ('bei Bewegung', 'on movement'),
      ('beim Liegen', 'when lying down'),
      ('beim Sitzen', 'when sitting'),
      ('beim Gehen', 'when walking'),
      ('nach dem Essen', 'after eating'),
      ('bei Stress', 'with stress'),
      ('bei Kälte', 'in the cold'),
      ('bei Wärme', 'in the heat'),
      ('bei Berührung', 'on touch'),
      ('beim Husten/Niesen', 'when coughing/sneezing'),
      ('beim Atmen', 'when breathing'),
    ],
  ),
  DescriptorGroup(
    'time',
    ('Tageszeit', 'Time of day'),
    [
      ('morgens', 'in the morning'),
      ('nach dem Aufstehen', 'after getting up'),
      ('tagsüber', 'during the day'),
      ('abends', 'in the evening'),
      ('nachts', 'at night'),
    ],
  ),
];

const locationGroups = <DescriptorGroup>[
  DescriptorGroup(
    'head',
    ('Kopf', 'Head'),
    [
      ('Ganzer Kopf', 'Whole head'),
      ('Stirn', 'Forehead'),
      ('Schläfe', 'Temple'),
      ('Scheitel', 'Top of head'),
      ('Hinterkopf', 'Back of head'),
      ('Hinter den Augen', 'Behind the eyes'),
      ('Kopfhaut', 'Scalp'),
    ],
  ),
  DescriptorGroup(
    'face',
    ('Gesicht & Sinne', 'Face & senses'),
    [
      ('Gesicht', 'Face'),
      ('Auge', 'Eye'),
      ('Augenlid', 'Eyelid'),
      ('Ohr', 'Ear'),
      ('Nase', 'Nose'),
      ('Nasennebenhöhlen', 'Sinuses'),
      ('Wange', 'Cheek'),
      ('Mund', 'Mouth'),
      ('Lippen', 'Lips'),
      ('Zunge', 'Tongue'),
      ('Zähne', 'Teeth'),
      ('Zahnfleisch', 'Gums'),
      ('Kiefer', 'Jaw'),
      ('Kiefergelenk', 'Jaw joint'),
    ],
  ),
  DescriptorGroup(
    'neck',
    ('Hals & Nacken', 'Throat & neck'),
    [
      ('Hals', 'Throat'),
      ('Rachen', 'Pharynx'),
      ('Kehlkopf', 'Larynx'),
      ('Nacken', 'Neck'),
      ('Halswirbelsäule', 'Cervical spine'),
    ],
  ),
  DescriptorGroup(
    'trunk',
    ('Brust & Rücken', 'Chest & back'),
    [
      ('Brust', 'Chest'),
      ('Brustbein', 'Breastbone'),
      ('Rippen', 'Ribs'),
      ('Herzgegend', 'Heart area'),
      ('Oberer Rücken', 'Upper back'),
      ('Schulterblatt', 'Shoulder blade'),
      ('Brustwirbelsäule', 'Thoracic spine'),
      ('Unterer Rücken', 'Lower back'),
      ('Lendenwirbelsäule', 'Lumbar spine'),
      ('Kreuzbein', 'Sacrum'),
      ('Steißbein', 'Tailbone'),
      ('Flanke', 'Flank'),
    ],
  ),
  DescriptorGroup(
    'abdomen',
    ('Bauch & Becken', 'Abdomen & pelvis'),
    [
      ('Bauch', 'Abdomen'),
      ('Oberbauch', 'Upper abdomen'),
      ('Unterbauch', 'Lower abdomen'),
      ('Rechter Oberbauch', 'Upper right abdomen'),
      ('Linker Oberbauch', 'Upper left abdomen'),
      ('Rechter Unterbauch', 'Lower right abdomen'),
      ('Linker Unterbauch', 'Lower left abdomen'),
      ('Um den Nabel', 'Around the navel'),
      ('Leiste', 'Groin'),
      ('Becken', 'Pelvis'),
      ('Genitalbereich', 'Genital area'),
      ('After', 'Anus'),
    ],
  ),
  DescriptorGroup(
    'organs',
    ('Innere Organe (vermutet)', 'Internal organs (suspected)'),
    [
      ('Herz', 'Heart'),
      ('Lunge', 'Lungs'),
      ('Speiseröhre', 'Esophagus'),
      ('Magen', 'Stomach'),
      ('Darm', 'Bowel'),
      ('Leber/Galle', 'Liver/gallbladder'),
      ('Niere', 'Kidney'),
      ('Blase', 'Bladder'),
      ('Gebärmutter', 'Uterus'),
    ],
  ),
  DescriptorGroup(
    'arms',
    ('Arme & Hände', 'Arms & hands'),
    [
      ('Schulter', 'Shoulder'),
      ('Oberarm', 'Upper arm'),
      ('Ellenbogen', 'Elbow'),
      ('Unterarm', 'Forearm'),
      ('Handgelenk', 'Wrist'),
      ('Hand', 'Hand'),
      ('Handfläche', 'Palm'),
      ('Handrücken', 'Back of hand'),
      ('Finger', 'Fingers'),
      ('Daumen', 'Thumb'),
    ],
  ),
  DescriptorGroup(
    'legs',
    ('Beine & Füße', 'Legs & feet'),
    [
      ('Hüfte', 'Hip'),
      ('Gesäß', 'Buttocks'),
      ('Oberschenkel', 'Thigh'),
      ('Knie', 'Knee'),
      ('Kniekehle', 'Back of knee'),
      ('Unterschenkel', 'Lower leg'),
      ('Schienbein', 'Shin'),
      ('Wade', 'Calf'),
      ('Sprunggelenk', 'Ankle'),
      ('Achillessehne', 'Achilles tendon'),
      ('Fuß', 'Foot'),
      ('Ferse', 'Heel'),
      ('Fußsohle', 'Sole of foot'),
      ('Fußrücken', 'Top of foot'),
      ('Zehen', 'Toes'),
    ],
  ),
  DescriptorGroup(
    'body',
    ('Haut & ganzer Körper', 'Skin & whole body'),
    [
      ('Haut', 'Skin'),
      ('Gelenke', 'Joints'),
      ('Muskeln', 'Muscles'),
      ('Ganzer Körper', 'Whole body'),
      ('Wechselnde Stellen', 'Changing places'),
    ],
  ),
];

/// v15: Grammatisches Geschlecht deutscher Nomen für den Titel aus
/// Bausteinen („brennender Schmerz“, „brennende Übelkeit“, „stechendes
/// Brennen“). [plural] = Mehrzahl („brennende Blähungen“).
enum NounGender { masculine, feminine, neuter, plural }

/// Geschlecht jeder Empfindung des Katalogs (Schlüssel: deutscher Begriff).
/// Ein Test stellt sicher, dass kein Begriff fehlt.
const sensationGenders = <String, NounGender>{
  'Schmerz': NounGender.masculine,
  'Druckgefühl': NounGender.neuter,
  'Krampf': NounGender.masculine,
  'Spannungsgefühl': NounGender.neuter,
  'Steifheit': NounGender.feminine,
  'Muskelkater': NounGender.masculine,
  'Wundgefühl': NounGender.neuter,
  'Taubheit': NounGender.feminine,
  'Kribbeln': NounGender.neuter,
  'Brennen': NounGender.neuter,
  'Missempfindung': NounGender.feminine,
  'Schwäche': NounGender.feminine,
  'Zittern': NounGender.neuter,
  'Zucken': NounGender.neuter,
  'Juckreiz': NounGender.masculine,
  'Ausschlag': NounGender.masculine,
  'Rötung': NounGender.feminine,
  'Schwellung': NounGender.feminine,
  'Trockenheit': NounGender.feminine,
  'Bläschen': NounGender.plural,
  'Schuppung': NounGender.feminine,
  'Quaddeln': NounGender.plural,
  'Übelkeit': NounGender.feminine,
  'Erbrechen': NounGender.neuter,
  'Völlegefühl': NounGender.neuter,
  'Blähungen': NounGender.plural,
  'Sodbrennen': NounGender.neuter,
  'Aufstoßen': NounGender.neuter,
  'Durchfall': NounGender.masculine,
  'Verstopfung': NounGender.feminine,
  'Appetitlosigkeit': NounGender.feminine,
  'Schwindel': NounGender.masculine,
  'Benommenheit': NounGender.feminine,
  'Ohrgeräusch': NounGender.neuter,
  'Sehstörung': NounGender.feminine,
  'Lichtempfindlichkeit': NounGender.feminine,
  'Geräuschempfindlichkeit': NounGender.feminine,
  'Herzklopfen': NounGender.neuter,
  'Herzrasen': NounGender.neuter,
  'Ohnmachtsgefühl': NounGender.neuter,
  'Atemnot': NounGender.feminine,
  'Husten': NounGender.masculine,
  'Engegefühl': NounGender.neuter,
  'Halskratzen': NounGender.neuter,
  'Verstopfte Nase': NounGender.feminine,
  'Heiserkeit': NounGender.feminine,
  'Müdigkeit': NounGender.feminine,
  'Erschöpfung': NounGender.feminine,
  'Hitzegefühl': NounGender.neuter,
  'Kältegefühl': NounGender.neuter,
  'Schüttelfrost': NounGender.masculine,
  'Schwitzen': NounGender.neuter,
  'Schlafstörung': NounGender.feminine,
  'Traurigkeit': NounGender.feminine,
  'Niedergeschlagenheit': NounGender.feminine,
  'Leere': NounGender.feminine,
  'Hoffnungslosigkeit': NounGender.feminine,
  'Gereiztheit': NounGender.feminine,
  'Hochgefühl': NounGender.neuter,
  'Manie': NounGender.feminine,
  'Euphorie': NounGender.feminine,
  'Antriebslosigkeit': NounGender.feminine,
  'Innere Unruhe': NounGender.feminine,
  'Getriebenheit': NounGender.feminine,
  'Vermindertes Schlafbedürfnis': NounGender.neuter,
  'Angst': NounGender.feminine,
  'Panikattacke': NounGender.feminine,
  'Sorgen/Grübeln': NounGender.plural,
  'Anspannung': NounGender.feminine,
  'Gedankenrasen': NounGender.neuter,
  'Konzentrationsprobleme': NounGender.plural,
  'Entscheidungsschwierigkeiten': NounGender.plural,
  'Dissoziation': NounGender.feminine,
  'Derealisation': NounGender.feminine,
  'Sozialer Rückzug': NounGender.masculine,
  'Appetitveränderung': NounGender.feminine,
  'Selbstwertprobleme': NounGender.plural,
  'Gedanken an Selbstverletzung oder Suizid': NounGender.plural,
};

/// Ort mit Präposition und Artikel für den deutschen Titel
/// („Schmerz am Hinterkopf“). Schlüssel: deutscher Begriff des Katalogs; ein
/// Test stellt sicher, dass kein Ort fehlt. Eigene Orte: „Schmerz · Ort“.
const locationPhrases = <String, String>{
  'Ganzer Kopf': 'am ganzen Kopf',
  'Stirn': 'an der Stirn',
  'Schläfe': 'an der Schläfe',
  'Scheitel': 'am Scheitel',
  'Hinterkopf': 'am Hinterkopf',
  'Hinter den Augen': 'hinter den Augen',
  'Kopfhaut': 'an der Kopfhaut',
  'Gesicht': 'im Gesicht',
  'Auge': 'am Auge',
  'Augenlid': 'am Augenlid',
  'Ohr': 'am Ohr',
  'Nase': 'an der Nase',
  'Nasennebenhöhlen': 'in den Nasennebenhöhlen',
  'Wange': 'an der Wange',
  'Mund': 'im Mund',
  'Lippen': 'an den Lippen',
  'Zunge': 'an der Zunge',
  'Zähne': 'an den Zähnen',
  'Zahnfleisch': 'am Zahnfleisch',
  'Kiefer': 'am Kiefer',
  'Kiefergelenk': 'am Kiefergelenk',
  'Hals': 'am Hals',
  'Rachen': 'im Rachen',
  'Kehlkopf': 'am Kehlkopf',
  'Nacken': 'im Nacken',
  'Halswirbelsäule': 'an der Halswirbelsäule',
  'Brust': 'in der Brust',
  'Brustbein': 'am Brustbein',
  'Rippen': 'an den Rippen',
  'Herzgegend': 'in der Herzgegend',
  'Oberer Rücken': 'im oberen Rücken',
  'Schulterblatt': 'am Schulterblatt',
  'Brustwirbelsäule': 'an der Brustwirbelsäule',
  'Unterer Rücken': 'im unteren Rücken',
  'Lendenwirbelsäule': 'an der Lendenwirbelsäule',
  'Kreuzbein': 'am Kreuzbein',
  'Steißbein': 'am Steißbein',
  'Flanke': 'an der Flanke',
  'Bauch': 'im Bauch',
  'Oberbauch': 'im Oberbauch',
  'Unterbauch': 'im Unterbauch',
  'Rechter Oberbauch': 'im rechten Oberbauch',
  'Linker Oberbauch': 'im linken Oberbauch',
  'Rechter Unterbauch': 'im rechten Unterbauch',
  'Linker Unterbauch': 'im linken Unterbauch',
  'Um den Nabel': 'um den Nabel',
  'Leiste': 'in der Leiste',
  'Becken': 'im Becken',
  'Genitalbereich': 'im Genitalbereich',
  'After': 'am After',
  'Herz': 'am Herzen',
  'Lunge': 'in der Lunge',
  'Speiseröhre': 'in der Speiseröhre',
  'Magen': 'im Magen',
  'Darm': 'im Darm',
  'Leber/Galle': 'an Leber/Galle',
  'Niere': 'an der Niere',
  'Blase': 'an der Blase',
  'Gebärmutter': 'an der Gebärmutter',
  'Schulter': 'an der Schulter',
  'Oberarm': 'am Oberarm',
  'Ellenbogen': 'am Ellenbogen',
  'Unterarm': 'am Unterarm',
  'Handgelenk': 'am Handgelenk',
  'Hand': 'an der Hand',
  'Handfläche': 'an der Handfläche',
  'Handrücken': 'am Handrücken',
  'Finger': 'an den Fingern',
  'Daumen': 'am Daumen',
  'Hüfte': 'an der Hüfte',
  'Gesäß': 'am Gesäß',
  'Oberschenkel': 'am Oberschenkel',
  'Knie': 'am Knie',
  'Kniekehle': 'in der Kniekehle',
  'Unterschenkel': 'am Unterschenkel',
  'Schienbein': 'am Schienbein',
  'Wade': 'an der Wade',
  'Sprunggelenk': 'am Sprunggelenk',
  'Achillessehne': 'an der Achillessehne',
  'Fuß': 'am Fuß',
  'Ferse': 'an der Ferse',
  'Fußsohle': 'an der Fußsohle',
  'Fußrücken': 'am Fußrücken',
  'Zehen': 'an den Zehen',
  'Haut': 'an der Haut',
  'Gelenke': 'in den Gelenken',
  'Muskeln': 'in den Muskeln',
  'Ganzer Körper': 'am ganzen Körper',
  'Wechselnde Stellen': 'an wechselnden Stellen',
};
