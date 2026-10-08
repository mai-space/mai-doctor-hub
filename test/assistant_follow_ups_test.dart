import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mai_doctor_hub/l10n/generated/app_localizations.dart';
import 'package:mai_doctor_hub/services/assistant/follow_ups.dart';

void main() {
  final de = lookupAppLocalizations(const Locale('de'));
  final en = lookupAppLocalizations(const Locale('en'));

  group('splitFollowUps', () {
    test('Standardzeile wird abgetrennt', () {
      final parts = splitFollowUps(
        '**Mögliche Zusammenhänge**\n- Schlaf\n\n'
        'FOLGEFRAGEN: Was könnte zusammenhängen? | Was soll ich beobachten? '
        '| Wann sollte ich zum Arzt?',
      );
      expect(parts.text, '**Mögliche Zusammenhänge**\n- Schlaf');
      expect(parts.followUps, [
        'Was könnte zusammenhängen?',
        'Was soll ich beobachten?',
        'Wann sollte ich zum Arzt?',
      ]);
    });

    test('Varianten: fett, Aufzählung, Überschrift, Englisch, inline', () {
      expect(
        splitFollowUps('Text\n**Folgefragen:**\n- „Erste Frage?“\n- Zweite Frage?')
            .followUps,
        ['Erste Frage?', 'Zweite Frage?'],
      );
      final heading = splitFollowUps(
        'Answer\n\n---\n### Follow-up questions\n1. First one?\n2) Second one?',
      );
      expect(heading.text, 'Answer');
      expect(heading.followUps, ['First one?', 'Second one?']);
      expect(
        splitFollowUps('Answer. FOLLOW-UPS: A thing? | Another?').followUps,
        ['A thing?', 'Another?'],
      );
      expect(
        splitFollowUps('Antwort. FOLGEFRAGEN: Eins? | Zwei?').text,
        'Antwort.',
      );
    });

    test('Doppelte, Platzhalter und zu lange fallen weg; höchstens drei', () {
      final parts = splitFollowUps(
        'X\nFOLGEFRAGEN: Frage 1 | … | Eins? | eins? | ${'lang ' * 30}? '
        '| Zwei? | Drei? | Vier?',
      );
      expect(parts.followUps, ['Eins?', 'Zwei?', 'Drei?']);
    });

    test('ohne Markierung bleibt der Text unverändert', () {
      final parts = splitFollowUps('Dein Termin ist am 20.10.\n- Folge dem Plan');
      expect(parts.text, 'Dein Termin ist am 20.10.\n- Folge dem Plan');
      expect(parts.followUps, isEmpty);
    });

    test('beim Streamen wird eine begonnene Markierung ausgeblendet', () {
      expect(splitFollowUps('Text\nFOLGEF', streaming: true).text, 'Text');
      expect(splitFollowUps('Text\n**Folge', streaming: true).text, 'Text');
      expect(splitFollowUps('Text\nFOLLOW-U', streaming: true).text, 'Text');
      expect(splitFollowUps('Text. FOLGEFR', streaming: true).text, 'Text.');
      expect(
        splitFollowUps('Text\nFOLGEFRAGEN: Eins', streaming: true).text,
        'Text',
      );
      // Normaler Text bleibt sichtbar.
      expect(splitFollowUps('Text\nFieber', streaming: true).text, 'Text\nFieber');
      // Fertige Antwort: nichts wird geraten.
      expect(splitFollowUps('Text\nFOLGEF').text, 'Text\nFOLGEF');
    });
  });

  group('followUpsFor', () {
    bool both(List<FollowUp> list) =>
        list.any((f) => f.kind == FollowUpKind.understand) &&
        list.any((f) => f.kind == FollowUpKind.act);

    test('ohne Vorschläge: allgemeine feste Fragen in beide Richtungen', () {
      final list = followUpsFor(const [], question: 'Wie geht es mir?', l10n: de);
      expect(list.map((f) => f.text), [
        'Was könnte zusammenhängen?',
        'Was soll ich beobachten?',
        'Was frage ich die Ärztin?',
      ]);
      expect(both(list), isTrue);
    });

    test('symptombezogen, wenn ein Symptom genannt wird', () {
      final list = followUpsFor(
        const [],
        question: 'Warum habe ich Kopfschmerzen?',
        l10n: de,
        symptom: 'Kopfschmerzen',
      );
      expect(list.map((f) => f.text), [
        'Verlauf von Kopfschmerzen',
        'Was könnte bei Kopfschmerzen zusammenhängen?',
        'Fragen an die Ärztin zu Kopfschmerzen',
      ]);
      expect(both(list), isTrue);
    });

    test('fehlende Richtung wird ergänzt', () {
      final understand = followUpsFor(
        const ['Woher kommt das?', 'Seit wann ist das so?'],
        question: 'Q',
        l10n: de,
      );
      expect(understand, hasLength(3));
      expect(understand.last.text, 'Was soll ich beobachten?');
      expect(both(understand), isTrue);

      final act = followUpsFor(
        const [
          'What should I track?',
          'What do I ask my doctor?',
          'When should I seek care?',
        ],
        question: 'Q',
        l10n: en,
      );
      expect(act, hasLength(3));
      expect(act.last.text, 'What could be related?');
      expect(both(act), isTrue);
    });

    test('die gerade gestellte Frage wird nicht wieder vorgeschlagen', () {
      final list = followUpsFor(
        const [],
        question: 'Was könnte zusammenhängen?',
        l10n: de,
      );
      expect(list.map((f) => f.text), isNot(contains('Was könnte zusammenhängen?')));
      expect(both(list), isTrue);
    });
  });

  test('matchSymptom erkennt Bezeichnung und Wortanfang', () {
    const labels = ['Übelkeit', 'Kopfschmerzen'];
    expect(matchSymptom(labels, 'Woher kommt meine Übelkeit?'), 'Übelkeit');
    expect(matchSymptom(labels, 'Kopfschmerz seit gestern'), 'Kopfschmerzen');
    expect(matchSymptom(labels, 'Wann ist mein Termin?'), isNull);
  });

  test('conversationHistory bleibt im Budget, neueste Runde zuerst behalten', () {
    final turns = [
      (question: 'Alte Frage', answer: 'a' * 2000),
      (question: 'Neue Frage', answer: 'b' * 2000),
    ];
    final both = conversationHistory(turns, 900, de);
    expect(both.length, lessThanOrEqualTo(900));
    expect(both, contains('Nutzer: Alte Frage'));
    expect(both, contains('Nutzer: Neue Frage'));
    final small = conversationHistory(turns, 300, de);
    expect(small.length, lessThanOrEqualTo(300));
    expect(small, isNot(contains('Alte Frage')));
    expect(small, contains('Neue Frage'));
    expect(conversationHistory(turns, 150, de), isEmpty);
  });

  test('Systemanweisung nennt beide Richtungen und das Folgefragen-Format', () {
    expect(de.svcContextSystemPrompt, contains('Stelle keine Diagnosen'));
    expect(de.svcContextSystemPrompt, contains('Mögliche Zusammenhänge'));
    expect(de.svcContextSystemPrompt, contains('Was du tun kannst'));
    expect(de.svcContextSystemPrompt, contains('112'));
    expect(de.svcContextSystemPrompt, contains('FOLGEFRAGEN:'));
    expect(en.svcContextSystemPrompt, contains('Possible connections'));
    expect(en.svcContextSystemPrompt, contains('What you can do'));
    expect(en.svcContextSystemPrompt, contains('FOLLOW-UPS:'));
  });
}
