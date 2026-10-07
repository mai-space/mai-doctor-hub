import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/symptom_descriptors.dart';
import 'package:mai_doctor_hub/data/symptom_title.dart';
import 'package:mai_doctor_hub/l10n/l10n.dart';

void main() {
  final de = lookupAppLocalizations(const Locale('de'));
  final en = lookupAppLocalizations(const Locale('en'));

  String deTitle({
    String? sensation,
    List<String> qualities = const [],
    String? location,
    BodySide? side,
  }) => composeSymptomTitle(
    TitleBlocks(
      sensation: sensation,
      qualities: qualities,
      location: location,
      side: side,
    ),
    de,
  );

  String enTitle({
    String? sensation,
    List<String> qualities = const [],
    String? location,
    BodySide? side,
  }) => composeSymptomTitle(
    TitleBlocks(
      sensation: sensation,
      qualities: qualities,
      location: location,
      side: side,
    ),
    en,
  );

  group('German title with inflection', () {
    test('the example from the feedback', () {
      expect(
        deTitle(
          sensation: 'Schmerz',
          qualities: ['brennend'],
          location: 'Hinterkopf',
          side: BodySide.left,
        ),
        'Brennender Schmerz am Hinterkopf (links)',
      );
    });

    test('adjective follows the gender of the sensation', () {
      expect(
        deTitle(sensation: 'Schmerz', qualities: ['stechend']),
        'Stechender Schmerz',
      );
      expect(
        deTitle(sensation: 'Übelkeit', qualities: ['stark']),
        'Starke Übelkeit',
      );
      expect(
        deTitle(sensation: 'Übelkeit', qualities: ['brennend']),
        'Brennende Übelkeit',
      );
      expect(
        deTitle(sensation: 'Brennen', qualities: ['stechend']),
        'Stechendes Brennen',
      );
      expect(
        deTitle(sensation: 'Blähungen', qualities: ['krampfartig']),
        'Krampfartige Blähungen',
      );
      expect(
        deTitle(sensation: 'Juckreiz', qualities: ['juckend', 'trocken']),
        'Juckender, trockener Juckreiz',
      );
      expect(
        deTitle(sensation: 'Schwindel', qualities: ['drehend']),
        'Drehender Schwindel',
      );
      expect(
        deTitle(sensation: 'Kribbeln', qualities: ['taub']),
        'Taubes Kribbeln',
      );
    });

    test('special stems: -e, -el, hoch, participles, adverb phrases', () {
      expect(declineGerman('müde', NounGender.masculine), 'müder');
      expect(declineGerman('müde', NounGender.neuter), 'müdes');
      expect(declineGerman('dunkel', NounGender.masculine), 'dunkler');
      expect(declineGerman('hoch', NounGender.neuter), 'hohes');
      expect(declineGerman('geschwollen', NounGender.feminine), 'geschwollene');
      expect(declineGerman('gerötet', NounGender.plural), 'gerötete');
      expect(
        declineGerman('innerlich unruhig', NounGender.masculine),
        'innerlich unruhiger',
      );
      expect(declineGerman('wie Nadelstiche', NounGender.masculine), isNull);
      expect(declineGerman('Xyz', NounGender.masculine), isNull);
      expect(declineGerman('blau-grün', NounGender.masculine), isNull);
    });

    test('phrases and unknown words stay behind the noun', () {
      expect(
        deTitle(sensation: 'Schmerz', qualities: ['wie Nadelstiche']),
        'Schmerz wie Nadelstiche',
      );
      expect(
        deTitle(sensation: 'Schmerz', qualities: ['pochend', 'blau-grün']),
        'Pochender Schmerz (blau-grün)',
      );
      // Unbekannte Empfindung: nicht raten.
      expect(
        deTitle(sensation: 'Pain', qualities: ['burning']),
        'Pain (burning)',
      );
    });

    test('compound and custom nouns get the gender of their last part', () {
      expect(germanGender('Rückenschmerz'), NounGender.masculine);
      expect(germanGender('Kopfschmerzen'), NounGender.plural);
      expect(germanGender('Augenbrennen'), NounGender.neuter);
      expect(germanGender('Hitzewallungen'), NounGender.plural);
      expect(germanGender('Lähmung'), NounGender.feminine);
      expect(germanGender('Xyz'), isNull);
      expect(
        deTitle(sensation: 'Kopfschmerzen', qualities: ['pochend']),
        'Pochende Kopfschmerzen',
      );
    });

    test('multi-word sensations keep their adjective lower case', () {
      expect(
        deTitle(sensation: 'Innere Unruhe', qualities: ['stark']),
        'Starke innere Unruhe',
      );
      expect(
        deTitle(sensation: 'Verstopfte Nase', qualities: ['trocken']),
        'Trockene verstopfte Nase',
      );
      expect(deTitle(sensation: 'Sozialer Rückzug'), 'Sozialer Rückzug');
    });

    test('locations with preposition, fallback with a dot', () {
      expect(
        deTitle(sensation: 'Schmerz', location: 'Stirn'),
        'Schmerz an der Stirn',
      );
      expect(
        deTitle(sensation: 'Schmerz', location: 'Nacken'),
        'Schmerz im Nacken',
      );
      expect(
        deTitle(sensation: 'Schmerz', location: 'Zähne'),
        'Schmerz an den Zähnen',
      );
      expect(
        deTitle(
          sensation: 'Schmerz',
          location: 'Rechter Unterbauch',
          side: BodySide.right,
        ),
        'Schmerz im rechten Unterbauch (rechts)',
      );
      expect(
        deTitle(sensation: 'Schmerz', location: 'Mittelfinger'),
        'Schmerz · Mittelfinger',
      );
      expect(deTitle(location: 'hinterkopf'), 'Hinterkopf');
      expect(
        deTitle(sensation: 'Schmerz', side: BodySide.both),
        'Schmerz (beidseits)',
      );
      expect(
        deTitle(qualities: ['dumpf'], location: 'Stirn'),
        'Dumpf an der Stirn',
      );
      expect(deTitle(), '');
      expect(deTitle(sensation: '  ', qualities: [' ']), '');
    });
  });

  group('English title', () {
    test('adjectives first, location after a comma', () {
      expect(
        enTitle(
          sensation: 'Pain',
          qualities: ['burning'],
          location: 'Back of head',
          side: BodySide.left,
        ),
        'Burning pain, back of head (left)',
      );
      expect(
        enTitle(sensation: 'Pain', qualities: ['burning', 'throbbing']),
        'Burning, throbbing pain',
      );
      expect(
        enTitle(sensation: 'Tingling', qualities: ['like pins and needles']),
        'Tingling like pins and needles',
      );
      expect(
        enTitle(sensation: 'Nausea', location: 'Upper abdomen'),
        'Nausea, upper abdomen',
      );
      expect(enTitle(location: 'Knee', side: BodySide.right), 'Knee (right)');
      expect(enTitle(sensation: 'Pain', location: 'HWS'), 'Pain, HWS');
    });
  });

  group('catalog', () {
    test('every German sensation has a gender', () {
      for (final g in sensationGroups) {
        for (final (term, _) in g.terms) {
          expect(sensationGenders, contains(term), reason: term);
        }
      }
    });

    test('every German location has a phrase with preposition', () {
      for (final g in locationGroups) {
        for (final (term, _) in g.terms) {
          expect(locationPhrases, contains(term), reason: term);
          expect(
            locationPhrases[term],
            matches(RegExp(r'^(am|an|im|in|um|hinter) ')),
            reason: term,
          );
        }
      }
    });

    test('psych groups exist in both languages', () {
      final keys = sensationGroups.map((g) => g.key).toSet();
      expect(keys.containsAll(SymptomDescriptors.psychGroupKeys), isTrue);
      expect(SymptomDescriptors.sensationGroupOf('Traurigkeit'), 'mind');
      expect(
        SymptomDescriptors.sensationGroupOf('Racing thoughts'),
        'thinking',
      );
      expect(
        SymptomDescriptors.sensationGroupOf(selfHarmThoughts.$1),
        'selfHarm',
      );
    });
  });
}
