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
  };
}

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
      ('Konzentrationsstörung', 'Poor concentration'),
    ],
  ),
  DescriptorGroup(
    'mind',
    ('Psyche', 'Mind'),
    [
      ('Unruhe', 'Restlessness'),
      ('Angst', 'Anxiety'),
      ('Anspannung', 'Tension'),
      ('Niedergeschlagenheit', 'Low mood'),
      ('Reizbarkeit', 'Irritability'),
      ('Grübeln', 'Rumination'),
    ],
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
