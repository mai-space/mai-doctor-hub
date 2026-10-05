import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/database_provider.dart';
import 'package:mai_doctor_hub/data/repositories/reminder_repository.dart';
import 'package:mai_doctor_hub/data/repositories/symptom_repository.dart';
import 'package:mai_doctor_hub/features/settings/reminders_section.dart';
import 'package:mai_doctor_hub/services/notification_service.dart';
import 'package:mai_doctor_hub/services/notifications/notification_plan.dart';
import 'package:mai_doctor_hub/services/notifications/reminder_service.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'helpers/test_env.dart';

class FakeScheduler implements NotificationScheduler {
  final groups = <NotificationGroup, List<PlannedNotification>>{};
  int calls = 0;

  @override
  Future<void> replace(
    NotificationGroup group,
    List<PlannedNotification> plans,
  ) async {
    calls++;
    groups[group] = plans;
  }
}

void main() {
  late AppDatabase db;
  late ReminderRepository repo;

  setUpAll(() async {
    tzdata.initializeTimeZones();
    await initializeDateFormatting('de');
  });
  setUp(() {
    useFakePermissions();
    db = AppDatabase(NativeDatabase.memory());
    repo = ReminderRepository(db);
  });
  tearDown(() => db.close());

  test('defaults: two daily check-ins in the reminder range', () async {
    final plans = ReminderPlanner.plan(await repo.all());
    expect(plans, hasLength(2));
    expect(plans.every((p) => p.weekday == null), isTrue);
    expect(
      plans.every((p) => NotificationGroup.reminders.contains(p.id)),
      isTrue,
    );
    expect(plans.map((p) => p.payload).toSet(), {'check_in'});
  });

  test('weekday reminders, symptom scope, disabled skipped', () async {
    final symptomId = await SymptomRepository(db).create(label: 'Migräne');
    final id = await repo.create(
      title: 'Kopf-Check',
      hour: 13,
      minute: 15,
      weekdays: 1 | 4, // Mo + Mi
      symptomIds: [symptomId],
    );
    await repo.setEnabled('reminder-evening', false);

    final plans = ReminderPlanner.plan(await repo.all());
    final mine = plans.where((p) => p.title == 'Kopf-Check').toList();
    expect(mine.map((p) => p.weekday), [1, 3]);
    expect(mine.first.body, 'Check-in: Migräne');
    expect(CheckInPayload.decode(mine.first.payload), [symptomId]);
    expect(plans.where((p) => p.title == 'Abend-Check-in'), isEmpty);
    expect(mine.map((p) => p.id).toSet(), hasLength(2), reason: 'eindeutig');

    // IDs aller Erinnerungen kollidieren nie.
    final ids = plans.map((p) => p.id).toList();
    expect(ids.toSet(), hasLength(ids.length));

    await repo.delete(id);
    expect(
      ReminderPlanner.plan(await repo.all()).where((p) => p.title == 'Kopf-Check'),
      isEmpty,
    );
  });

  test('many reminders get distinct slots', () async {
    for (var i = 0; i < 10; i++) {
      await repo.create(title: 'R$i', hour: i, minute: 0);
    }
    final slots = (await repo.all()).map((r) => r.reminder.slot).toList();
    expect(slots.toSet(), hasLength(12));
  });

  test('service re-plans automatically when reminders change', () async {
    final scheduler = FakeScheduler();
    final service = ReminderService(db, scheduler)..start();
    addTearDown(service.dispose);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(scheduler.groups[NotificationGroup.reminders], hasLength(2));

    await repo.create(title: 'Mittag', hour: 12, minute: 0);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(scheduler.groups[NotificationGroup.reminders], hasLength(3));
  });

  test('payload round trip', () {
    expect(CheckInPayload.decode('check_in'), isEmpty);
    expect(CheckInPayload.decode(CheckInPayload.encode(['a', 'b'])), ['a', 'b']);
    expect(CheckInPayload.decode('appointment:1'), isNull);
    expect(CheckInPayload.decode(null), isNull);
  });

  test('nextInstance: weekday and DST-safe wall clock', () {
    final berlin = tz.getLocation('Europe/Berlin');
    // Sa 24.10.2026 21:00 → nächster Montag 08:00 (nach Zeitumstellung).
    final now = tz.TZDateTime(berlin, 2026, 10, 24, 21);
    final next = NotificationService.nextInstance(now, 8, 0, weekday: 1);
    expect((next.year, next.month, next.day, next.hour), (2026, 10, 26, 8));
    // Täglich, Uhrzeit heute schon vorbei → morgen, trotz 25-h-Tag.
    final daily = NotificationService.nextInstance(now, 8, 0);
    expect((daily.day, daily.hour), (25, 8));
  });

  testWidgets('settings section lists and adds reminders', (tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    Future<void> settle() async {
      for (var i = 0; i < 5; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 10)),
        );
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    await tester.pumpWidget(
      DatabaseScope(
        database: db,
        child: const MaterialApp(
          home: Scaffold(body: SingleChildScrollView(child: RemindersSection())),
        ),
      ),
    );
    await settle();
    expect(find.textContaining('Morgen-Check-in'), findsOneWidget);
    expect(find.textContaining('Abend-Check-in'), findsOneWidget);

    await tester.tap(find.text('Neu'));
    await settle();
    await tester.enterText(find.widgetWithText(TextField, 'Titel'), 'Blutdruck');
    await tester.tap(find.widgetWithText(FilterChip, 'Sa'));
    await tester.tap(find.widgetWithText(FilterChip, 'So'));
    await tester.tap(find.text('Speichern'));
    await settle();

    expect(find.textContaining('Blutdruck'), findsOneWidget);
    expect(find.textContaining('werktags'), findsOneWidget);
    final all = await tester.runAsync(() => loadReminders(db));
    expect(all!.singleWhere((r) => r.title == 'Blutdruck').weekdays, 31);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 100));
  });
}
