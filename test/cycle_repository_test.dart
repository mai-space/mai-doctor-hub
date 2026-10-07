import 'dart:io';

import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/connection/connection_io.dart';
import 'package:mai_doctor_hub/data/repositories/appointment_repository.dart';
import 'package:mai_doctor_hub/data/repositories/cycle_repository.dart';
import 'package:mai_doctor_hub/data/repositories/doctor_repository.dart';
import 'package:mai_doctor_hub/data/repositories/settings_repository.dart';
import 'package:mai_doctor_hub/l10n/l10n.dart';
import 'package:mai_doctor_hub/services/assistant/record_context.dart';
import 'package:mai_doctor_hub/services/backup_service_io.dart';
import 'package:mai_doctor_hub/services/cycle/cycle_dates.dart';
import 'package:mai_doctor_hub/services/cycle/mrs.dart';
import 'package:mai_doctor_hub/services/cycle/pbac.dart';
import 'package:mai_doctor_hub/services/notifications/cycle_reminders.dart';
import 'package:mai_doctor_hub/services/notifications/notification_plan.dart';
import 'package:mai_doctor_hub/services/visit_summary.dart';

import 'reminders_test.dart' show FakeScheduler;

DateTime d(int y, int m, int day) => DateTime(y, m, day);

/// Perioden à 5 Tage mit den Zykluslängen [lengths] ab [first].
Future<void> logCycles(
  CycleRepository repo,
  DateTime first,
  List<int> lengths, {
  int? pain,
}) async {
  var start = first;
  for (final l in [...lengths, 0]) {
    for (var i = 0; i < 5; i++) {
      await repo.saveDay(
        plusDays(start, i),
        CycleDaysCompanion(
          flow: const Value(CycleFlow.medium),
          pain: Value(i == 0 ? pain : null),
          symptoms: Value(i == 0 ? 'cramps,headache' : null),
        ),
      );
    }
    start = plusDays(start, l);
  }
}

void main() {
  late AppDatabase db;
  late CycleRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = CycleRepository(db);
  });
  tearDown(() => db.close());

  group('repository', () {
    test('day upsert keeps fields that were not sent', () async {
      final day = DateTime(2026, 3, 29, 22, 30); // Uhrzeit egal
      await repo.saveDay(
        day,
        const CycleDaysCompanion(flow: Value(CycleFlow.heavy)),
      );
      await repo.saveDay(day, const CycleDaysCompanion(pain: Value(6)));
      await repo.saveDay(
        d(2026, 3, 29),
        CycleDaysCompanion(
          pbacJson: Value(PbacCounts.empty.withValue('padsFull', 2).encode()),
          painLocations: const Value('lower_abdomen,lower_back'),
          note: const Value('Wärmflasche hilft'),
        ),
      );
      final row = (await repo.getDay(d(2026, 3, 29)))!;
      expect(row.day, '2026-03-29');
      expect(row.flow, CycleFlow.heavy);
      expect(row.pain, 6);
      expect(PbacCounts.parse(row.pbacJson).score, 40);
      expect(row.painLocations, 'lower_abdomen,lower_back');
      expect(row.note, 'Wärmflasche hilft');
      expect(await repo.allDays(), hasLength(1));

      await repo.deleteDay(day);
      expect(await repo.getDay(day), isNull);
    });

    test(
      'setup creates the gynecology doctor once and enables modes',
      () async {
        final id = await repo.apply(
          const CycleSetup(cycle: true, createGynecologist: true),
        );
        final again = await repo.apply(
          const CycleSetup(
            cycle: true,
            menopause: true,
            createGynecologist: true,
          ),
        );
        expect(again, id);
        final doctors = await DoctorRepository(db).watchAll().first;
        expect(doctors, hasLength(1));
        expect(doctors.single.name, 'Meine Gynäkologin/mein Gynäkologe');
        expect(
          doctors.single.specialty,
          'Frauenheilkunde und Geburtshilfe (Gynäkologie)',
        );
        final s = await SettingsRepository(db).get();
        expect(s.cycleTracking, isTrue);
        expect(s.menopauseTracking, isTrue);
        expect(s.pregnancyTracking, isFalse);
      },
    );

    test('an existing gynecologist (any spelling) is reused', () async {
      final mine = await DoctorRepository(db)
          .create(name: 'Dr. Weber', specialty: 'Gynäkologin');
      expect(await repo.ensureGynecologist(), mine);
      expect(await DoctorRepository(db).watchAll().first, hasLength(1));
    });

    test('no doctor without a choice or when unticked', () async {
      expect(
        await repo.apply(const CycleSetup(createGynecologist: true)),
        isNull,
      );
      await repo.apply(const CycleSetup(cycle: true));
      expect(await DoctorRepository(db).watchAll().first, isEmpty);
    });

    test(
      'pregnancy: start, dates, end (neutral), pauses predictions',
      () async {
        await logCycles(repo, d(2026, 1, 1), [28, 28]);
        await repo.apply(const CycleSetup(cycle: true, pregnancy: true));
        var o = await repo.overview(now: d(2026, 3, 20));
        expect(o.pregnant, isTrue);
        expect(o.pregnancyStatus, isNull, reason: 'noch keine Daten');
        expect(o.analysis.prediction, isNull);

        await repo.startPregnancy(lmp: d(2026, 2, 26));
        o = await repo.overview(now: d(2026, 3, 20));
        expect(o.pregnancy!.lmp, '2026-02-26');
        expect(o.pregnancyStatus!.age.label, '3+1');
        expect(
          await repo.allPregnancies(),
          hasLength(1),
          reason: 'kein Duplikat',
        );

        await repo.endPregnancy(o.pregnancy!.id, outcome: 'loss', note: ' ');
        final ended = (await repo.allPregnancies()).single;
        expect(ended.endedAt, isNotNull);
        expect(ended.outcome, 'loss');
        expect(ended.note, isNull);
        o = await repo.overview(now: d(2026, 3, 20));
        expect(o.pregnancyTracking, isFalse);
        expect(o.pregnant, isFalse);
        expect(o.cycleTracking, isTrue, reason: 'Zyklus bleibt wie gewählt');
      },
    );

    test('MRS round trip and monthly due flag', () async {
      await repo.setMenopauseTracking(true);
      expect((await repo.overview()).mrsDue, isTrue);
      await repo.addMrs(
        MrsResult([2, 1, 3, 1, 1, 0, 2, 1, 0, 2, 2]),
        at: d(2026, 9, 1),
      );
      final o = await repo.overview(now: d(2026, 9, 20));
      expect(MrsResult.parse(o.latestMrs!.scores).total, 15);
      expect(o.mrsDue, isFalse);
      expect((await repo.overview(now: d(2026, 10, 5))).mrsDue, isTrue);
    });

    test('delete all wipes cycle data and turns modes off', () async {
      await repo.apply(
        const CycleSetup(
          cycle: true,
          pregnancy: true,
          createGynecologist: true,
        ),
      );
      await logCycles(repo, d(2026, 1, 1), [28]);
      await repo.addMrs(MrsResult(const []));
      await repo.deleteAll();
      expect(await repo.allDays(), isEmpty);
      expect(await repo.allMrs(), isEmpty);
      expect(await repo.allPregnancies(), isEmpty);
      expect((await repo.overview()).enabled, isFalse);
      expect(await DoctorRepository(db).watchAll().first, hasLength(1));
    });
  });

  group('notifications', () {
    test('period expected: 2 days ahead and on the day, discreet by default', () async {
      await repo.setCycleTracking(true);
      await logCycles(repo, d(2026, 8, 1), [28, 28]);
      // Letzter Beginn 26.9., Median 28 → erwartet 24.10.
      final now = DateTime(2026, 10, 10, 12);
      final o = await repo.overview(now: now);
      final plans = CycleReminderPlanner.plan(o, now: now);
      expect(plans.map((p) => p.at), [
        DateTime(2026, 10, 22, 9),
        DateTime(2026, 10, 24, 9),
      ]);
      expect(plans.first.title, contains('Periode'));
      expect(plans.first.topic, NotificationTopic.cycle);
      expect(
        plans.every((p) => NotificationGroup.cycle.contains(p.id)),
        isTrue,
      );
      expect(CyclePayload.decode(plans.first.payload), CyclePayload.today);

      // Standard: diskret — kein Wort über die Periode auf dem Sperrbildschirm.
      final applied = const NotificationPreferences().apply(plans);
      expect(applied.first.discreet, isTrue);
      expect(applied.first.title, 'Erinnerung');
      expect(applied.first.title, isNot(contains('Periode')));
      expect(applied.first.body, isNot(contains('Periode')));
      // Andere Themen bleiben ausführlich.
      expect(
        const NotificationPreferences()
            .of(NotificationTopic.medication)
            .discreet,
        isFalse,
      );
      // Bewusst ausgeschaltet → ausführlich; alte JSON ohne Feld → Standard.
      final open = NotificationPreferences.parse(
        '{"cycle":{"enabled":true,"level":"normal","discreet":false}}',
      );
      expect(open.apply(plans).first.title, contains('Periode'));
      expect(
        NotificationPreferences.parse(
          '{"cycle":{"enabled":true,"level":"silent"}}',
        ).of(NotificationTopic.cycle).discreet,
        isTrue,
      );
    });

    test(
      'nothing when tracking is off or pregnant; MRS after 30 days',
      () async {
        await logCycles(repo, d(2026, 8, 1), [28, 28]);
        final now = DateTime(2026, 10, 10, 12);
        expect(
          CycleReminderPlanner.plan(await repo.overview(now: now), now: now),
          isEmpty,
        );
        await repo.apply(const CycleSetup(cycle: true, pregnancy: true));
        expect(
          CycleReminderPlanner.plan(await repo.overview(now: now), now: now),
          isEmpty,
        );
        await repo.apply(const CycleSetup(menopause: true));
        await repo.addMrs(
          MrsResult(const [1, 1]),
          at: DateTime(2026, 9, 20, 18),
        );
        final plans = CycleReminderPlanner.plan(
          await repo.overview(now: now),
          now: now,
        );
        expect(plans.single.at, DateTime(2026, 10, 20, 10));
        expect(CyclePayload.decode(plans.single.payload), CyclePayload.mrs);
      },
    );

    test(
      'pregnancy check-ups: skipped when an appointment is planned',
      () async {
        await repo.apply(const CycleSetup(pregnancy: true));
        await repo.startPregnancy(lmp: d(2026, 5, 1));
        final now = DateTime(2026, 8, 1, 12); // SSW 13+1
        final o = await repo.overview(now: now);
        final plans = CycleReminderPlanner.plan(o, now: now);
        final titles = plans.map((p) => p.title).toList();
        expect(titles.first, 'Vorsorge (SSW 16)');
        expect(titles, contains('Basis-Ultraschall (SSW 19–22)'));
        expect(titles.where((t) => t.startsWith('Vorsorge')), hasLength(2));

        final covered = CycleReminderPlanner.plan(
          o,
          now: now,
          plannedAppointments: [DateTime(2026, 9, 20, 9)], // in SSW 20
        );
        expect(
          covered.map((p) => p.title),
          isNot(contains('Basis-Ultraschall (SSW 19–22)')),
        );
      },
    );

    test('service plans into its own group', () async {
      await repo.setCycleTracking(true);
      await logCycles(repo, d(2026, 8, 1), [28, 28]);
      final scheduler = FakeScheduler();
      final service = CycleReminderService(
        db,
        scheduler,
        clock: () => DateTime(2026, 10, 10, 12),
      );
      await service.sync();
      expect(scheduler.groups[NotificationGroup.cycle], hasLength(2));
      expect(scheduler.groups[NotificationGroup.cycle]!.first.discreet, isTrue);
    });
  });

  group('doctor PDF and assistant', () {
    Future<String> appointmentWith(String doctorId) =>
        AppointmentRepository(db)
            .create(doctorId: doctorId, scheduledAt: DateTime(2026, 10, 20, 9));

    test('cycle section only when asked for and a mode is enabled', () async {
      final gyn = await repo.ensureGynecologist();
      final appointment = await appointmentWith(gyn);
      await logCycles(repo, d(2026, 7, 1), [28, 30, 29], pain: 8);
      final now = DateTime(2026, 10, 7, 12);

      // Bereich aus → kein Abschnitt, auch wenn angefragt.
      var data = await VisitSummaryBuilder(db).build(
        VisitSummaryOptions(appointmentId: appointment, includeCycle: true),
        now: now,
      );
      expect(data.cycle, isNull);

      await repo.setCycleTracking(true);
      data = await VisitSummaryBuilder(db)
          .build(VisitSummaryOptions(appointmentId: appointment), now: now);
      expect(data.cycle, isNull, reason: 'Standard: aus');

      data = await VisitSummaryBuilder(db).build(
        VisitSummaryOptions(appointmentId: appointment, includeCycle: true),
        now: now,
      );
      final cycle = data.cycle!;
      expect(cycle.cycles.map((c) => c.length), [28, 30, 29, null]);
      expect(cycle.stats!.median, 29);
      expect(cycle.topSymptoms.first.$2, 4);
      final lines = cycle.summaryLines(AppLocale.strings);
      expect(lines.join('\n'), contains('Median 29 (28–30), 3 Zyklen'));
      expect(lines.join('\n'), contains('Krämpfe (4)'));
      final bytes = await VisitSummaryPdf.render(data);
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    });

    test('pregnancy and MRS in the report', () async {
      await repo.apply(const CycleSetup(pregnancy: true, menopause: true));
      await repo.startPregnancy(dueDate: d(2027, 1, 10));
      await repo.saveDay(
        d(2026, 10, 1),
        const CycleDaysCompanion(
          weightKg: Value(68.5),
          bpSystolic: Value(118),
          bpDiastolic: Value(76),
        ),
      );
      await repo.addMrs(MrsResult(const [4, 4, 4]), at: d(2026, 9, 1));
      final data = await VisitSummaryBuilder(db).build(
        const VisitSummaryOptions(includeCycle: true),
        now: DateTime(2026, 10, 7, 12),
      );
      final text = data.cycle!.summaryLines(AppLocale.strings).join('\n');
      expect(text, contains('SSW 26+3'));
      expect(text, contains('Errechneter Termin 10.01.2027'));
      expect(text, contains('68,5 kg'));
      expect(text, contains('118/76 mmHg'));
      expect(text, contains('MRS 12 (mittel)'));
    });

    test(
      'assistant context gets a compact cycle summary when enabled',
      () async {
        await logCycles(repo, d(2026, 7, 1), [28, 30]);
        final now = DateTime(2026, 10, 7, 12);
        var context = await AssistantContextBuilder(db)
            .build('Zyklus?', now: now);
        expect(context, isNot(contains('Zyklus & Frauengesundheit')));
        await repo.setCycleTracking(true);
        context = await AssistantContextBuilder(db).build('Zyklus?', now: now);
        expect(context, contains('Zyklus & Frauengesundheit:'));
        expect(context, contains('Letzte Periodenbeginne: 01.07.2026'));
      },
    );
  });

  test('backup restores cycle tables on another device', () async {
    final root = await Directory.systemTemp.createTemp('cycle_backup');
    addTearDown(() => root.delete(recursive: true));
    Future<(AppDatabase, BackupService)> device(String name, String key) async {
      final docs = await Directory('${root.path}/$name/docs')
          .create(recursive: true);
      final tmp = await Directory('${root.path}/$name/tmp')
          .create(recursive: true);
      final deviceDb = AppDatabase(
        NativeDatabase(
          File('${root.path}/$name/db.sqlite'),
          setup: (raw) => applyKey(raw, key * 32),
        ),
      );
      addTearDown(deviceDb.close);
      return (
        deviceDb,
        BackupService(
          deviceDb,
          baseDir: () async => docs,
          tempDir: () async => tmp,
          iterations: 1000,
        ),
      );
    }

    final (dbA, backupA) = await device('a', 'a1');
    final repoA = CycleRepository(dbA);
    await repoA.apply(const CycleSetup(cycle: true, pregnancy: true));
    await repoA.startPregnancy(lmp: d(2026, 5, 1));
    await logCycles(repoA, d(2026, 1, 1), [28]);
    await repoA.addMrs(MrsResult(const [1, 2, 3]));
    final sealed = await backupA.createBackupFile('korrekt-pferd-batterie');

    final (dbB, backupB) = await device('b', 'b2');
    await backupB.restoreFile(sealed.path, 'korrekt-pferd-batterie');
    final repoB = CycleRepository(dbB);
    expect(await repoB.allDays(), hasLength(10));
    expect((await repoB.allMrs()).single.scores, startsWith('1,2,3'));
    final o = await repoB.overview(now: d(2026, 6, 1));
    expect(o.cycleTracking, isTrue);
    expect(o.pregnancy!.lmp, '2026-05-01');
  });
}
