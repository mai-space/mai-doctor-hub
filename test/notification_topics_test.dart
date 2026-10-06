import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/database_provider.dart';
import 'package:mai_doctor_hub/data/repositories/appointment_repository.dart';
import 'package:mai_doctor_hub/data/repositories/settings_repository.dart';
import 'package:mai_doctor_hub/features/settings/notification_topics_page.dart';
import 'package:mai_doctor_hub/l10n/l10n.dart';
import 'package:mai_doctor_hub/services/notifications/appointment_reminders.dart';
import 'package:mai_doctor_hub/services/notifications/notification_plan.dart';
import 'package:mai_doctor_hub/services/notifications/reminder_service.dart';
import 'package:mai_doctor_hub/services/notifications/vaccination_reminders.dart';

import 'reminders_test.dart' show FakeScheduler;

PlannedNotification _plan(NotificationTopic topic, {int id = 1}) =>
    PlannedNotification.once(
      id: id,
      title: 'Methotrexat 15 mg',
      body: 'Dr. Weiß',
      payload: 'x',
      topic: topic,
      at: DateTime(2030),
    );

Vaccination _vaccination(DateTime? due) => Vaccination(
  id: 'v1',
  vaccine: 'Tetanus',
  administeredAt: DateTime(2020),
  nextDueAt: due,
  createdAt: DateTime(2020),
  updatedAt: DateTime(2020),
);

void main() {
  setUpAll(() => initializeDateFormatting('de'));

  group('preferences', () {
    test('defaults per topic; unknown or broken JSON falls back', () {
      for (final raw in ['', 'kaputt', '[]', '{"medication": 3}']) {
        final p = NotificationPreferences.parse(raw);
        expect(
          p.of(NotificationTopic.medication),
          const TopicPreference(level: NotificationLevel.important),
        );
        expect(
          p.of(NotificationTopic.checkIn).level,
          NotificationLevel.normal,
        );
      }
    });

    test('round trip through JSON', () {
      final p = const NotificationPreferences()
          .withTopic(
            NotificationTopic.checkIn,
            const TopicPreference(
              enabled: false,
              level: NotificationLevel.silent,
            ),
          )
          .withTopic(
            NotificationTopic.medication,
            const TopicPreference(
              level: NotificationLevel.normal,
              discreet: true,
            ),
          );
      final back = NotificationPreferences.parse(p.encode());
      expect(back.of(NotificationTopic.checkIn), p.of(NotificationTopic.checkIn));
      expect(
        back.of(NotificationTopic.medication),
        p.of(NotificationTopic.medication),
      );
    });

    test('apply drops disabled topics, sets level, hides details', () {
      final p = const NotificationPreferences()
          .withTopic(
            NotificationTopic.checkIn,
            const TopicPreference(enabled: false, level: NotificationLevel.normal),
          )
          .withTopic(
            NotificationTopic.medication,
            const TopicPreference(
              level: NotificationLevel.silent,
              discreet: true,
            ),
          );
      final out = p.apply([
        _plan(NotificationTopic.checkIn),
        _plan(NotificationTopic.medication, id: 2),
        _plan(NotificationTopic.appointmentSoon, id: 3),
      ]);
      expect(out.map((n) => n.id), [2, 3]);

      final medication = out.first;
      expect(medication.effectiveLevel, NotificationLevel.silent);
      expect(medication.discreet, isTrue);
      expect(medication.title, isNot(contains('Methotrexat')));
      expect(medication.body, isNot(contains('Weiß')));
      expect(medication.payload, 'x'); // Tippen öffnet trotzdem die Einnahme

      final appointment = out.last;
      expect(appointment.discreet, isFalse);
      expect(appointment.effectiveLevel, NotificationLevel.important);
      expect(appointment.title, 'Methotrexat 15 mg');
    });

    test('one channel id per topic and level', () {
      final ids = {
        for (final t in NotificationTopic.values)
          for (final l in NotificationLevel.values) t.channelId(l),
      };
      expect(ids, hasLength(
        NotificationTopic.values.length * NotificationLevel.values.length,
      ));
      expect(
        ids.intersection(NotificationTopic.legacyChannelIds.toSet()),
        isEmpty,
      );
    });
  });

  test('appointments: short leads are "soon", a day or more is "ahead"', () {
    final now = DateTime(2026, 10, 1, 8);
    final appointment = Appointment(
      id: 'a1',
      doctorId: 'd1',
      scheduledAt: DateTime(2026, 10, 10, 9),
      status: AppointmentStatus.planned,
      createdAt: now,
      updatedAt: now,
    );
    final plans = AppointmentReminderPlanner.plan(
      [AppointmentSummary(appointment: appointment, doctorName: 'Dr. Weiß')],
      leadMinutes: [1440, 60],
      now: now,
    );
    expect(plans.map((p) => p.topic), [
      NotificationTopic.appointmentAhead,
      NotificationTopic.appointmentSoon,
    ]);
  });

  group('vaccinations', () {
    final now = DateTime(2026, 10, 1, 12);

    test('a week ahead and on the day, mornings', () {
      final plans = VaccinationReminderPlanner.plan([
        _vaccination(DateTime(2026, 10, 20)),
      ], now: now);
      expect(plans.map((p) => p.at), [
        DateTime(2026, 10, 13, 9),
        DateTime(2026, 10, 20, 9),
      ]);
      expect(plans.first.title, contains('Tetanus'));
      expect(plans.every((p) => p.topic == NotificationTopic.vaccination), isTrue);
      expect(
        plans.every((p) => NotificationGroup.vaccinations.contains(p.id)),
        isTrue,
      );
      expect(VaccinationPayload.decode(plans.first.payload), 'v1');
    });

    test('only what is still ahead; nothing without a due date', () {
      expect(
        VaccinationReminderPlanner.plan([
          _vaccination(DateTime(2026, 10, 4)),
        ], now: now).map((p) => p.at),
        [DateTime(2026, 10, 4, 9)],
      );
      expect(
        VaccinationReminderPlanner.plan([
          _vaccination(DateTime(2026, 9, 1)),
          _vaccination(null),
        ], now: now),
        isEmpty,
      );
    });
  });

  test('switching a topic off re-plans without it', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final scheduler = FakeScheduler();
    final service = ReminderService(db, scheduler);
    await service.sync();
    expect(scheduler.groups[NotificationGroup.reminders], hasLength(2));

    await SettingsRepository(db).setNotificationPreferences(
      const NotificationPreferences().withTopic(
        NotificationTopic.checkIn,
        const TopicPreference(enabled: false, level: NotificationLevel.normal),
      ),
    );
    await service.sync();
    expect(scheduler.groups[NotificationGroup.reminders], isEmpty);
  });

  testWidgets('settings page stores level, discreet and on/off', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    await tester.pumpWidget(
      DatabaseScope(
        database: db,
        child: const MaterialApp(
          locale: Locale('de'),
          supportedLocales: AppLocale.supported,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: NotificationTopicsPage(),
        ),
      ),
    );
    Future<NotificationPreferences> stored() async => NotificationPreferences.parse(
      (await tester.runAsync(() => SettingsRepository(db).get()))!
          .notificationTopics,
    );
    Future<void> settle() async {
      for (var i = 0; i < 5; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 10)),
        );
        await tester.pump();
      }
    }

    await settle();
    final medication = find.byKey(const ValueKey('topic-medication'));
    expect(medication, findsOneWidget);

    await tester.tap(
      find.descendant(of: medication, matching: find.text('Leise')),
    );
    await settle();
    await tester.tap(
      find.descendant(of: medication, matching: find.text('Diskret')),
    );
    await settle();
    var p = (await stored()).of(NotificationTopic.medication);
    expect(p.level, NotificationLevel.silent);
    expect(p.discreet, isTrue);

    await tester.tap(
      find.descendant(of: medication, matching: find.byType(Switch)).first,
    );
    await settle();
    p = (await stored()).of(NotificationTopic.medication);
    expect(p.enabled, isFalse);
    // Ausgeschaltet: keine weiteren Optionen mehr.
    expect(
      find.descendant(of: medication, matching: find.text('Leise')),
      findsNothing,
    );

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(db.close);
  });
}
