import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/repositories/psych_repository.dart';
import 'package:mai_doctor_hub/data/symptom_descriptors.dart';
import 'package:mai_doctor_hub/data/symptom_measure.dart';
import 'package:mai_doctor_hub/l10n/l10n.dart';
import 'package:mai_doctor_hub/services/notifications/notification_plan.dart';
import 'package:mai_doctor_hub/services/notifications/psych_reminders.dart';
import 'package:mai_doctor_hub/services/notifications/reminder_service.dart';
import 'package:mai_doctor_hub/data/repositories/reminder_repository.dart'
    show ReminderWithSymptoms;
import 'package:mai_doctor_hub/services/psych/psych_questionnaires.dart';
import 'package:mai_doctor_hub/services/psych/psych_safety.dart';

Symptom _symptom(String label, {String? sensation, String? measure}) => Symptom(
  id: label,
  label: label,
  checkInCadence: CheckInCadence.daily,
  reminderTimesJson: '[]',
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
  sensation: sensation,
  measure: measure,
);

void main() {
  group('PHQ-9 (Kroenke 2001)', () {
    PsychSeverity band(int total) => psychSeverity(PsychInstrument.phq9, total);

    test('bands 0–4, 5–9, 10–14, 15–19, 20–27', () {
      expect(band(0), PsychSeverity.minimal);
      expect(band(4), PsychSeverity.minimal);
      expect(band(5), PsychSeverity.mild);
      expect(band(9), PsychSeverity.mild);
      expect(band(10), PsychSeverity.moderate);
      expect(band(14), PsychSeverity.moderate);
      expect(band(15), PsychSeverity.moderatelySevere);
      expect(band(19), PsychSeverity.moderatelySevere);
      expect(band(20), PsychSeverity.severe);
      expect(band(27), PsychSeverity.severe);
    });

    test('scoring, clamping, parsing and item 9', () {
      final r = PsychResult(PsychInstrument.phq9, [3, 3, 2, 2, 1, 1, 0, 0, 0]);
      expect(r.total, 12);
      expect(r.severity, PsychSeverity.moderate);
      expect(r.selfHarmFlag, isFalse);
      expect(r.encode(), '3,3,2,2,1,1,0,0,0');
      final clamped = PsychResult(PsychInstrument.phq9, [9, -1]);
      expect(clamped.scores, [3, 0, 0, 0, 0, 0, 0, 0, 0]);
      final parsed = PsychResult.parse(PsychInstrument.phq9, '1,x,3');
      expect(parsed.total, 4);
      expect(parsed.scores, hasLength(9));
      final item9 = PsychResult(PsychInstrument.phq9, [
        0, 0, 0, 0, 0, 0, 0, 0, 1, //
      ]);
      expect(item9.selfHarmFlag, isTrue);
      expect(
        PsychResult(PsychInstrument.phq9, List.filled(9, 3)).total,
        PsychInstrument.phq9.maxScore,
      );
    });

    test('official wording is complete in both languages', () {
      for (final lang in [AppLocale.german, AppLocale.english]) {
        final l10n = lookupAppLocalizations(lang);
        expect(psychItems(PsychInstrument.phq9, l10n), hasLength(9));
        expect(psychItems(PsychInstrument.gad7, l10n), hasLength(7));
        expect(psychAnswerLabels(l10n), hasLength(4));
      }
      final de = lookupAppLocalizations(AppLocale.german);
      expect(
        psychItems(PsychInstrument.phq9, de)[8],
        'Gedanken, dass Sie lieber tot wären oder sich Leid zufügen möchten',
      );
      expect(
        psychSummary(
          PsychResult(PsychInstrument.phq9, [3, 3, 2, 2, 1, 1, 0, 0, 0]),
          de,
        ),
        'PHQ-9 (Depression): 12 von 27 – mittelgradig',
      );
    });
  });

  group('GAD-7 (Spitzer 2006)', () {
    test('bands 0–4, 5–9, 10–14, 15–21', () {
      PsychSeverity band(int total) =>
          psychSeverity(PsychInstrument.gad7, total);
      expect(band(4), PsychSeverity.minimal);
      expect(band(5), PsychSeverity.mild);
      expect(band(10), PsychSeverity.moderate);
      expect(band(14), PsychSeverity.moderate);
      expect(band(15), PsychSeverity.severe);
      expect(band(21), PsychSeverity.severe);
      final r = PsychResult(PsychInstrument.gad7, List.filled(7, 3));
      expect(r.total, 21);
      expect(r.selfHarmFlag, isFalse);
    });
  });

  group('safety trigger', () {
    final thoughts = _symptom(
      'Gedanken an Selbstverletzung oder Suizid',
      sensation: selfHarmThoughts.$1,
    );
    final headache = _symptom('Kopfschmerz');

    test('self-harm thoughts with intensity > 0', () {
      expect(checkInNeedsSupport(symptom: thoughts, value: 0), isFalse);
      expect(checkInNeedsSupport(symptom: thoughts, value: 1), isTrue);
      expect(
        checkInNeedsSupport(symptom: _symptom('Suizidgedanken'), value: 3),
        isTrue,
      );
      expect(
        checkInNeedsSupport(
          symptom: _symptom('Thoughts of self-harm or suicide'),
          value: 2,
        ),
        isTrue,
      );
      // Andere Symptome: Stärke allein löst nichts aus.
      expect(checkInNeedsSupport(symptom: headache, value: 10), isFalse);
    });

    test('journal: clear phrases only, German and English', () {
      for (final text in [
        'Ich will nicht mehr leben.',
        'Habe heute an Suizid gedacht',
        'lebensmüde seit Tagen',
        'ich möchte mich umbringen',
        'I want to die',
        'Thinking about self-harm again',
        'feel like I would be better off dead',
      ]) {
        expect(journalNeedsSupport(text), isTrue, reason: text);
        expect(
          checkInNeedsSupport(symptom: headache, value: 2, journal: text),
          isTrue,
          reason: text,
        );
      }
      for (final text in [
        null,
        '',
        'Heute war ein guter Tag, Spaziergang hat geholfen.',
        'Ich bin todmüde',
        'Die Pflanze ist gestorben',
        'Dead tired after work',
        'Ritzenputz im Bad',
      ]) {
        expect(journalNeedsSupport(text), isFalse, reason: '$text');
      }
    });

    test('support contacts by region', () {
      final de = supportContactsFor('DE');
      expect(de.lines.map((l) => l.number), [
        '0800 111 0 111',
        '0800 111 0 222',
      ]);
      expect(de.emergency!.number, '112');
      expect(de.lines.first.uri.toString(), 'tel:08001110111');
      expect(supportContactsFor('US').lines.single.number, '988');
      expect(supportContactsFor('GB').lines.single.number, '116 123');
      expect(supportContactsFor(null, language: 'de').emergency!.number, '112');
      expect(supportContactsFor('FR').isGeneric, isTrue);
      expect(supportContactsFor(null, language: 'en').isGeneric, isTrue);
    });
  });

  group('psych symptoms', () {
    test('recognised by mood measure, psych block or self-harm wording', () {
      expect(isPsychSymptom(_symptom('Kopfschmerz')), isFalse);
      expect(isPsychSymptom(_symptom('Tief', measure: 'mood')), isTrue);
      expect(
        isPsychSymptom(_symptom('Abends', sensation: 'Gedankenrasen')),
        isTrue,
      );
      expect(isPsychSymptom(_symptom('Suizidgedanken')), isTrue);
    });

    test('reminders for psych symptoms use the discreet mood topic', () {
      Reminder reminder() => Reminder(
        id: 'r',
        slot: 3,
        title: 'Abends',
        hour: 20,
        minute: 0,
        weekdays: 127,
        enabled: true,
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );
      final psych = ReminderPlanner.plan([
        ReminderWithSymptoms(reminder(), [
          _symptom('Traurigkeit', measure: 'mood'),
        ]),
      ]).single;
      expect(psych.topic, NotificationTopic.mood);
      final mixed = ReminderPlanner.plan([
        ReminderWithSymptoms(reminder(), [
          _symptom('Traurigkeit', measure: 'mood'),
          _symptom('Kopfschmerz'),
        ]),
      ]).single;
      expect(mixed.topic, NotificationTopic.checkIn);

      // Standard diskret: keine Symptomnamen auf dem Sperrbildschirm.
      final applied = const NotificationPreferences().apply([psych]).single;
      expect(applied.discreet, isTrue);
      expect(applied.body, isNot(contains('Traurigkeit')));
    });

    test('monthly questionnaire reminder', () {
      final now = DateTime(2026, 10, 7, 12);
      expect(
        PsychReminderPlanner.plan(
          enabled: false,
          lastAssessment: null,
          now: now,
        ),
        isEmpty,
      );
      final first = PsychReminderPlanner.plan(
        enabled: true,
        lastAssessment: null,
        now: now,
      ).single;
      expect(first.at, DateTime(2026, 10, 8, 10));
      expect(first.topic, NotificationTopic.mood);
      expect(PsychPayload.decode(first.payload), PsychPayload.questionnaire);
      final next = PsychReminderPlanner.plan(
        enabled: true,
        lastAssessment: DateTime(2026, 10, 1, 9),
        now: now,
      ).single;
      expect(next.at, DateTime(2026, 10, 31, 10));
    });
  });

  test('repository stores results, oldest first', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final repo = PsychRepository(db);
    await repo.add(
      PsychResult(PsychInstrument.gad7, [1, 1, 1, 1, 1, 1, 1]),
      at: DateTime(2026, 10, 2),
    );
    await repo.add(
      PsychResult(PsychInstrument.phq9, [2, 2, 2, 2, 2, 0, 0, 0, 0]),
      at: DateTime(2026, 9, 2),
    );
    final all = await repo.all();
    expect(all.map((e) => e.result.instrument), [
      PsychInstrument.phq9,
      PsychInstrument.gad7,
    ]);
    expect(all.first.result.total, 10);
    await repo.setQuestionnaires(true);
    expect(
      (await db.select(db.appSettings).getSingle()).psychQuestionnaires,
      isTrue,
    );
    await repo.delete(all.first.row.id);
    expect(await repo.all(), hasLength(1));
  });
}
