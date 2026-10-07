import 'package:flutter_test/flutter_test.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/services/cycle/cycle_analytics.dart';
import 'package:mai_doctor_hub/services/cycle/cycle_dates.dart';
import 'package:mai_doctor_hub/services/cycle/mrs.dart';
import 'package:mai_doctor_hub/services/cycle/pbac.dart';
import 'package:mai_doctor_hub/services/cycle/pregnancy_math.dart';

DateTime d(int y, int m, int day) => DateTime(y, m, day);

/// Periode über [length] Tage ab [start] mit mittlerer Blutung.
List<CycleLog> period(DateTime start, {int length = 5, int pain = 0}) => [
  for (var i = 0; i < length; i++)
    CycleLog(
      day: plusDays(start, i),
      flow: i == 0 ? CycleFlow.heavy : CycleFlow.medium,
      pain: pain > 0 && i < 2 ? pain : null,
    ),
];

/// Perioden mit den Zykluslängen [lengths] ab [first].
List<CycleLog> cyclesOf(DateTime first, List<int> lengths, {int length = 5}) {
  final logs = <CycleLog>[];
  var start = first;
  for (final l in lengths) {
    logs.addAll(period(start, length: length));
    start = plusDays(start, l);
  }
  logs.addAll(period(start, length: length));
  return logs;
}

void main() {
  group('days', () {
    test('day keys round trip and reject invalid dates', () {
      expect(dayKey(DateTime(2026, 3, 29, 23, 59)), '2026-03-29');
      expect(parseDayKey('2026-03-29'), d(2026, 3, 29));
      expect(parseDayKey('2026-02-31'), isNull);
      expect(parseDayKey('29.03.2026'), isNull);
      expect(parseDayKey(null), isNull);
    });

    test('day differences ignore DST (EU switch end of March/October)', () {
      expect(dayDiff(d(2026, 3, 28), d(2026, 3, 30)), 2);
      expect(dayDiff(d(2026, 10, 24), d(2026, 10, 26)), 2);
      expect(plusDays(d(2026, 3, 28), 2), d(2026, 3, 30));
      expect(dayDiff(d(2026, 1, 1), d(2025, 12, 31)), -1);
    });
  });

  group('period detection', () {
    test('one empty day inside a period is bridged, two are not', () {
      final periods = detectPeriods([
        CycleLog(day: d(2026, 1, 1), flow: CycleFlow.medium),
        CycleLog(day: d(2026, 1, 2), flow: CycleFlow.heavy),
        // 3. Januar fehlt (vergessen) → gleiche Periode.
        CycleLog(day: d(2026, 1, 4), flow: CycleFlow.light),
        // 5./6. leer → neue Periode am 7.
        CycleLog(day: d(2026, 1, 7), flow: CycleFlow.light),
      ]);
      expect(periods, [
        Period(d(2026, 1, 1), d(2026, 1, 4)),
        Period(d(2026, 1, 7), d(2026, 1, 7)),
      ]);
      expect(periods.first.length, 4);
    });

    test('spotting alone never starts a period; "none" is ignored', () {
      final periods = detectPeriods([
        CycleLog(day: d(2026, 1, 10), flow: CycleFlow.spotting),
        CycleLog(day: d(2026, 1, 11), flow: CycleFlow.spotting),
        CycleLog(day: d(2026, 1, 12), flow: CycleFlow.none),
        CycleLog(day: d(2026, 1, 20), flow: CycleFlow.spotting),
        CycleLog(day: d(2026, 1, 21), flow: CycleFlow.light),
        CycleLog(day: d(2026, 1, 22), flow: CycleFlow.medium),
      ]);
      expect(periods, [Period(d(2026, 1, 21), d(2026, 1, 22))]);
    });

    test('unsorted input is fine', () {
      final periods = detectPeriods([
        CycleLog(day: d(2026, 2, 2), flow: CycleFlow.medium),
        CycleLog(day: d(2026, 2, 1), flow: CycleFlow.medium),
      ]);
      expect(periods.single, Period(d(2026, 2, 1), d(2026, 2, 2)));
    });
  });

  group('cycles, stats and prediction', () {
    final logs = cyclesOf(d(2026, 1, 1), [28, 28, 29, 28, 29, 30]);
    final lastStart = plusDays(d(2026, 1, 1), 28 + 28 + 29 + 28 + 29 + 30);
    final today = plusDays(lastStart, 10);
    final a = CycleAnalysis(logs, today: today);

    test('cycle length is start to next start; last cycle is running', () {
      expect(a.cycles, hasLength(7));
      expect(a.cycles.map((c) => c.length), [28, 28, 29, 28, 29, 30, null]);
      expect(a.currentCycle!.start, lastStart);
      expect(a.cycles.first.period.length, 5);
    });

    test('average, median and spread over the last 6 cycles', () {
      final s = a.stats!;
      expect(s.count, 6);
      expect(s.average, closeTo(28.67, 0.01));
      expect(s.median, 29); // (28 + 29) / 2 = 28,5 → 29
      expect(s.min, 28);
      expect(s.max, 30);
      expect(s.variability, 2);
      expect(s.averagePeriodLength, 5);
    });

    test('prediction: last start + median, range ± half the spread', () {
      final p = a.prediction!;
      expect(p.start, plusDays(lastStart, 29));
      expect(p.earliest, plusDays(lastStart, 28));
      expect(p.latest, plusDays(lastStart, 30));
      expect(p.ovulation, plusDays(lastStart, 15));
      expect(p.fertileFrom, plusDays(lastStart, 10));
      expect(p.fertileTo, plusDays(lastStart, 16));
      expect(a.cycleDayOf(today), 11);
      expect(a.inPeriod, isFalse);
      expect(a.daysLate, isNull);
    });

    test('only the last 6 cycles count', () {
      final b = CycleAnalysis(
        cyclesOf(d(2025, 1, 1), [40, 40, 28, 28, 28, 28, 28, 28]),
        today: d(2026, 1, 1),
      );
      expect(b.stats!.max, 28);
      expect(b.stats!.count, 6);
    });

    test('late: today after the latest expected day', () {
      final late = CycleAnalysis(logs, today: plusDays(lastStart, 35));
      expect(late.daysLate, 5);
    });

    test('no prediction with a single period or during pregnancy', () {
      expect(
        CycleAnalysis(period(d(2026, 1, 1)), today: d(2026, 1, 10)).prediction,
        isNull,
      );
      expect(
        CycleAnalysis(logs, today: today, pregnant: true).prediction,
        isNull,
      );
    });

    test('one cycle → ± 3 days', () {
      final one = CycleAnalysis(
        cyclesOf(d(2026, 1, 1), [30]),
        today: d(2026, 2, 5),
      );
      final p = one.prediction!;
      expect(p.start, d(2026, 3, 2));
      expect(dayDiff(p.earliest, p.latest), 6);
    });

    test('implausibly long gaps (forgotten entries) stay out of stats', () {
      final gap = CycleAnalysis(
        cyclesOf(d(2025, 1, 1), [28, 120, 28]),
        today: d(2025, 7, 1),
      );
      expect(gap.completedCycles.map((c) => c.length), [28, 28]);
    });
  });

  group('phases', () {
    final a = CycleAnalysis(
      cyclesOf(d(2026, 1, 1), [28]),
      today: d(2026, 2, 3),
    );

    test('28-day cycle with 5-day period', () {
      CyclePhase? phase(int cycleDay) =>
          a.phaseOf(plusDays(d(2026, 1, 1), cycleDay - 1));
      expect(phase(1), CyclePhase.menstruation);
      expect(phase(5), CyclePhase.menstruation);
      expect(phase(6), CyclePhase.follicular);
      expect(phase(11), CyclePhase.follicular);
      expect(phase(12), CyclePhase.ovulation);
      expect(phase(15), CyclePhase.ovulation);
      expect(phase(16), CyclePhase.luteal);
      expect(phase(28), CyclePhase.luteal);
      // Nächster Zyklus beginnt wieder mit der Periode.
      expect(phase(29), CyclePhase.menstruation);
      expect(a.phaseOf(d(2025, 12, 31)), isNull);
    });

    test('symptom frequency per phase', () {
      final logs = [
        for (final l in cyclesOf(d(2026, 1, 1), [28]))
          l.day == d(2026, 1, 2)
              ? CycleLog(day: l.day, flow: l.flow, symptoms: const ['cramps'])
              : l,
        CycleLog(day: d(2026, 1, 20), symptoms: const ['bloating', 'cramps']),
        CycleLog(day: d(2026, 1, 21), symptoms: const ['bloating']),
      ];
      final b = CycleAnalysis(logs, today: d(2026, 2, 3));
      final result = {for (final (s, m) in b.symptomsByPhase()) s: m};
      expect(result.keys, containsAll(['cramps', 'bloating']));
      // Lutealphase: 2 erfasste Tage, beide mit Blähungen.
      expect(result['bloating']![CyclePhase.luteal], 1.0);
      expect(result['bloating']![CyclePhase.menstruation], 0.0);
      expect(result['cramps']![CyclePhase.luteal], 0.5);
      // Periode: 10 erfasste Tage (zwei Perioden à 5), einmal Krämpfe.
      expect(result['cramps']![CyclePhase.menstruation], 0.1);
      expect(b.topSymptoms(), [('bloating', 2), ('cramps', 2)]);
    });
  });

  group('hints', () {
    Set<CycleHintKind> kinds(CycleAnalysis a) => {
      for (final h in a.hints) h.kind,
    };

    test('regular cycles → no hints', () {
      final a = CycleAnalysis(
        cyclesOf(d(2026, 1, 1), [28, 29, 28]),
        today: d(2026, 4, 1),
      );
      expect(a.hints, isEmpty);
    });

    test('short and long cycles', () {
      expect(
        kinds(
          CycleAnalysis(
            cyclesOf(d(2026, 1, 1), [19, 20, 19]),
            today: d(2026, 3, 15),
          ),
        ),
        contains(CycleHintKind.shortCycles),
      );
      final long = CycleAnalysis(
        cyclesOf(d(2025, 1, 1), [40, 38, 41]),
        today: d(2025, 6, 1),
      );
      expect(long.hints.first, const CycleHint(CycleHintKind.longCycles, 40));
      // Einzelner Ausreißer reicht nicht.
      expect(
        kinds(
          CycleAnalysis(
            cyclesOf(d(2025, 1, 1), [28, 40, 28, 29]),
            today: d(2025, 6, 1),
          ),
        ),
        isNot(contains(CycleHintKind.longCycles)),
      );
    });

    test('irregular: spread ≥ 10 days over ≥ 3 cycles', () {
      final a = CycleAnalysis(
        cyclesOf(d(2025, 1, 1), [24, 34, 28]),
        today: d(2025, 5, 1),
      );
      expect(a.hints, contains(const CycleHint(CycleHintKind.irregular, 10)));
      final b = CycleAnalysis(
        cyclesOf(d(2025, 1, 1), [24, 33, 28]),
        today: d(2025, 5, 1),
      );
      expect(kinds(b), isNot(contains(CycleHintKind.irregular)));
    });

    test('long period, heavy bleeding (PBAC > 100), strong pain', () {
      final logs = [
        ...period(d(2026, 1, 1), length: 9),
        for (var i = 0; i < 3; i++)
          CycleLog(
            day: d(2026, 1, 29 + i),
            flow: CycleFlow.heavy,
            pbac: 40, // 3 × 40 = 120
            pain: i < 2 ? 8 : 3,
            painkiller: true,
            painkillerHelped: i == 0 ? false : null,
          ),
      ];
      final a = CycleAnalysis(logs, today: d(2026, 2, 5));
      expect(
        a.hints,
        containsAll([
          const CycleHint(CycleHintKind.longPeriod, 9),
          const CycleHint(CycleHintKind.heavyBleeding, 120),
          const CycleHint(CycleHintKind.strongPain, 2),
          const CycleHint(CycleHintKind.painkillerNotHelping),
        ]),
      );
      expect(a.cycles.last.pbac, 120);
      expect(a.cycles.last.pain, {1: 8, 2: 8, 3: 3});
    });

    test('PBAC of exactly 100 is not flagged', () {
      final a = CycleAnalysis([
        CycleLog(day: d(2026, 1, 1), flow: CycleFlow.heavy, pbac: 60),
        CycleLog(day: d(2026, 1, 2), flow: CycleFlow.heavy, pbac: 40),
      ], today: d(2026, 1, 5));
      expect(a.hints, isEmpty);
    });

    test('spotting between periods (2+ days, last 90 days)', () {
      final logs = [
        ...cyclesOf(d(2026, 1, 1), [28]),
        CycleLog(day: d(2026, 1, 14), flow: CycleFlow.spotting),
        CycleLog(day: d(2026, 1, 16), flow: CycleFlow.spotting),
        // Direkt vor der Periode zählt nicht.
        CycleLog(day: d(2026, 1, 28), flow: CycleFlow.spotting),
      ];
      final a = CycleAnalysis(logs, today: d(2026, 2, 10));
      expect(
        a.hints,
        contains(const CycleHint(CycleHintKind.intermenstrualBleeding, 2)),
      );
    });

    test('bleeding after 12 months without a period (menopause)', () {
      final logs = [
        CycleLog(day: d(2025, 1, 5), flow: CycleFlow.light),
        CycleLog(day: d(2026, 2, 1), flow: CycleFlow.spotting),
      ];
      expect(
        kinds(CycleAnalysis(logs, today: d(2026, 2, 3), menopause: true)),
        contains(CycleHintKind.postmenopausalBleeding),
      );
      expect(
        kinds(CycleAnalysis(logs, today: d(2026, 2, 3))),
        isNot(contains(CycleHintKind.postmenopausalBleeding)),
      );
    });

    test('pregnancy: any bleeding and fewer movements are urgent', () {
      final a = CycleAnalysis(
        [
          CycleLog(day: d(2026, 5, 1), flow: CycleFlow.spotting),
          CycleLog(day: d(2026, 5, 2), fetalMovement: FetalMovement.less),
        ],
        today: d(2026, 5, 3),
        pregnant: true,
        pregnancySince: d(2026, 1, 1),
      );
      expect(kinds(a), {
        CycleHintKind.pregnancyBleeding,
        CycleHintKind.reducedFetalMovement,
      });
      expect(a.hints.every((h) => h.urgent), isTrue);
      // Blutung vor der Schwangerschaft zählt nicht.
      final before = CycleAnalysis(
        [CycleLog(day: d(2026, 5, 1), flow: CycleFlow.medium)],
        today: d(2026, 5, 3),
        pregnant: true,
        pregnancySince: d(2026, 5, 2),
      );
      expect(before.hints, isEmpty);
    });

    test('urgent hints come first', () {
      final a = CycleAnalysis(
        [
          ...period(d(2025, 1, 1), length: 9),
          CycleLog(day: d(2026, 3, 1), flow: CycleFlow.light),
        ],
        today: d(2026, 3, 2),
        menopause: true,
      );
      expect(a.hints.first.kind, CycleHintKind.postmenopausalBleeding);
    });
  });

  group('PBAC', () {
    test('Higham scoring', () {
      const counts = PbacCounts(
        padsLight: 1, // 1
        padsMedium: 1, // 5
        padsFull: 2, // 40
        tamponsLight: 2, // 2
        tamponsMedium: 3, // 15
        tamponsFull: 1, // 10
        clotsSmall: 2, // 2
        clotsLarge: 1, // 5
        flooding: 1, // 5
      );
      expect(counts.score, 85);
      expect(PbacCounts.empty.score, 0);
    });

    test('JSON round trip; broken input is empty', () {
      final c = PbacCounts.empty
          .withValue('padsFull', 3)
          .withValue('flooding', 1);
      expect(c.encode(), '{"padsFull":3,"flooding":1}');
      expect(PbacCounts.parse(c.encode()), c);
      expect(PbacCounts.parse(c.encode()).score, 65);
      expect(PbacCounts.empty.encode(), isNull);
      for (final raw in [null, '', 'kaputt', '[]', '{"padsFull":"x"}']) {
        expect(PbacCounts.parse(raw), PbacCounts.empty);
      }
      expect(PbacCounts.empty.withValue('padsLight', -2).padsLight, 0);
    });
  });

  group('MRS', () {
    MrsResult total(int n) => MrsResult([
      for (var i = 0; i < 11; i++) i < n ~/ 4 ? 4 : (i == n ~/ 4 ? n % 4 : 0),
    ]);

    test('severity bands of the total (Heinemann 2004)', () {
      expect(total(0).severity, MrsSeverity.none);
      expect(total(4).severity, MrsSeverity.none);
      expect(total(5).severity, MrsSeverity.mild);
      expect(total(8).severity, MrsSeverity.mild);
      expect(total(9).severity, MrsSeverity.moderate);
      expect(total(16).severity, MrsSeverity.moderate);
      expect(total(17).severity, MrsSeverity.severe);
      expect(total(44).total, 44);
      expect(total(44).severity, MrsSeverity.severe);
    });

    test(
      'subscales: somatic 1,2,3,11 · psychological 4–7 · urogenital 8–10',
      () {
        final r = MrsResult([1, 2, 3, 4, 0, 1, 2, 3, 1, 0, 4]);
        expect(r.subscale(MrsSubscale.somatic), 1 + 2 + 3 + 4);
        expect(r.subscale(MrsSubscale.psychological), 4 + 0 + 1 + 2);
        expect(r.subscale(MrsSubscale.urogenital), 3 + 1 + 0);
        expect(r.total, 21);
        expect(r.subscaleSeverity(MrsSubscale.somatic), MrsSeverity.severe);
        expect(
          r.subscaleSeverity(MrsSubscale.psychological),
          MrsSeverity.severe,
        );
        expect(r.subscaleSeverity(MrsSubscale.urogenital), MrsSeverity.severe);
        final u = MrsResult([0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0]);
        expect(
          u.subscaleSeverity(MrsSubscale.urogenital),
          MrsSeverity.moderate,
        );
        expect(u.severity, MrsSeverity.none);
      },
    );

    test('encode/parse, clamping and missing items', () {
      final r = MrsResult([9, -1, 2]);
      expect(r.scores, [4, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0]);
      expect(MrsResult.parse(r.encode()).scores, r.scores);
      expect(MrsResult.parse('1,x,3').scores.take(3), [1, 0, 3]);
    });
  });

  group('pregnancy', () {
    test('Naegele: LMP + 280 days', () {
      expect(naegeleDueDate(d(2026, 1, 1)), d(2026, 10, 8));
      // Über den Jahreswechsel und einen Schalttag (2028).
      expect(naegeleDueDate(d(2027, 6, 1)), d(2028, 3, 7));
    });

    test('week + days and trimester from LMP', () {
      final s = PregnancyStatus.from(
        lmp: d(2026, 1, 1),
        today: d(2026, 4, 10),
      )!;
      expect(s.age.label, '14+1');
      expect(s.age.trimester, 2);
      expect(s.dueDate, d(2026, 10, 8));
      expect(s.daysToDue, 181);
      expect(const GestationalAge(13 * 7 + 6).trimester, 1);
      expect(const GestationalAge(28 * 7).trimester, 3);
    });

    test('manual due date (ultrasound) overrides LMP', () {
      final s = PregnancyStatus.from(
        lmp: d(2026, 1, 1),
        dueDate: d(2026, 10, 15),
        today: d(2026, 4, 10),
      )!;
      expect(s.start, d(2026, 1, 8));
      expect(s.age.label, '13+1');
      expect(s.age.trimester, 1);
    });

    test('across DST: whole days, no off-by-one', () {
      // Zeitumstellung am 29.3.2026 (EU) liegt dazwischen.
      final s = PregnancyStatus.from(
        lmp: d(2026, 3, 1),
        today: DateTime(2026, 4, 5, 0, 30),
      )!;
      expect(s.age.label, '5+0');
      expect(PregnancyStatus.from(today: d(2026, 1, 1)), isNull);
    });

    test('Mutterschafts-Richtlinien timeline', () {
      final s = PregnancyStatus.from(
        lmp: d(2026, 1, 1),
        today: d(2026, 5, 20),
      )!;
      final all = pregnancyTimeline(s);
      expect(
        all
            .where((m) => m.kind == MilestoneKind.checkup)
            .map((m) => m.fromWeek),
        checkupWeeks,
      );
      final scans = all
          .where((m) => m.kind == MilestoneKind.ultrasound)
          .toList();
      expect(scans.map((m) => m.weeksLabel), ['9–12', '19–22', '29–32']);
      expect(scans[1].from, plusDays(d(2026, 1, 1), 19 * 7));
      expect(scans[1].to, plusDays(d(2026, 1, 1), 22 * 7 + 6));
      // Heute 19+6: Ultraschall 19–22 läuft noch, SSW 16 ist vorbei.
      final upcoming = pregnancyTimeline(s, upcomingOnly: true);
      expect(s.age.label, '19+6');
      expect(upcoming.first.kind, MilestoneKind.ultrasound);
      expect(upcoming.first.fromWeek, 19);
      expect(upcoming.any((m) => m.fromWeek == 16), isFalse);
      // Sortiert nach Datum.
      for (var i = 1; i < all.length; i++) {
        expect(all[i].from.isBefore(all[i - 1].from), isFalse);
      }
    });
  });
}
