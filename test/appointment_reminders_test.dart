import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/database_provider.dart';
import 'package:mai_doctor_hub/data/repositories/appointment_repository.dart';
import 'package:mai_doctor_hub/data/repositories/doctor_repository.dart';
import 'package:mai_doctor_hub/data/repositories/settings_repository.dart';
import 'package:mai_doctor_hub/features/settings/appointment_reminders_tile.dart';
import 'package:mai_doctor_hub/services/notifications/appointment_reminders.dart';
import 'package:mai_doctor_hub/services/notifications/notification_plan.dart';

import 'helpers/test_env.dart';
import 'reminders_test.dart' show FakeScheduler;

void main() {
  late AppDatabase db;
  late AppointmentRepository appointments;
  late String doctorId;
  final now = DateTime(2030, 3, 10, 12);

  setUpAll(() => initializeDateFormatting('de'));
  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    appointments = AppointmentRepository(db);
    doctorId = await DoctorRepository(db).create(
      name: 'Dr. Nord',
      practiceName: 'Praxis Nord',
    );
  });
  tearDown(() => db.close());

  Future<List<PlannedNotification>> plan() async {
    final scheduler = FakeScheduler();
    await AppointmentReminderService(db, scheduler, clock: () => now).sync();
    return scheduler.groups[NotificationGroup.appointments]!;
  }

  test('default leads: 1 day and 1 hour before, with readable titles', () async {
    final id = await appointments.create(
      doctorId: doctorId,
      scheduledAt: DateTime(2030, 3, 12, 9, 30),
      title: 'Kontrolle',
    );
    final plans = await plan();
    expect(plans.map((p) => p.at), [
      DateTime(2030, 3, 11, 9, 30),
      DateTime(2030, 3, 12, 8, 30),
    ]);
    expect(plans.first.title, 'Morgen 09:30 · Dr. Nord');
    expect(plans.last.title, 'In 1 Stunde (09:30) · Dr. Nord');
    expect(plans.first.body, 'Kontrolle · Praxis Nord');
    expect(AppointmentPayload.decode(plans.first.payload), id);
    expect(
      plans.every((p) => NotificationGroup.appointments.contains(p.id)),
      isTrue,
    );
  });

  test('skips past lead times, cancelled and past appointments', () async {
    // In 30 Min.: 1-Tag- und 1-Std.-Erinnerung liegen schon in der Vergangenheit.
    await appointments.create(
      doctorId: doctorId,
      scheduledAt: now.add(const Duration(minutes: 30)),
    );
    final cancelled = await appointments.create(
      doctorId: doctorId,
      scheduledAt: now.add(const Duration(days: 3)),
    );
    await appointments.updateStatus(cancelled, AppointmentStatus.cancelled);
    await appointments.create(
      doctorId: doctorId,
      scheduledAt: now.subtract(const Duration(days: 1)),
    );
    expect(await plan(), isEmpty);
  });

  test('toggle off and custom leads', () async {
    await appointments.create(
      doctorId: doctorId,
      scheduledAt: DateTime(2030, 3, 20, 10),
    );
    final settings = SettingsRepository(db);
    await settings.updateAppointmentReminders(
      enabled: true,
      leadMinutes: [10080, 15],
    );
    final plans = await plan();
    expect(plans.map((p) => p.at), [
      DateTime(2030, 3, 13, 10),
      DateTime(2030, 3, 20, 9, 45),
    ]);
    expect(plans.first.title, startsWith('Mi., 20.3. 10:00'));

    await settings.updateAppointmentReminders(
      enabled: false,
      leadMinutes: [60],
    );
    expect(await plan(), isEmpty);
  });

  test('caps the number of scheduled notifications', () async {
    for (var i = 0; i < 50; i++) {
      await appointments.create(
        doctorId: doctorId,
        scheduledAt: now.add(Duration(days: i + 2)),
      );
    }
    final plans = await plan();
    expect(plans, hasLength(AppointmentReminderPlanner.maxNotifications));
    expect(plans.first.at!.isBefore(plans.last.at!), isTrue, reason: 'nächste zuerst');
  });

  test('parseLeadMinutes ignores junk', () {
    expect(parseLeadMinutes('60, x,1440,,-5,60'), [1440, 60]);
  });

  testWidgets('settings tile toggles and edits leads', (tester) async {
    useFakePermissions();
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
        child: MaterialApp(
          home: Scaffold(
            body: StreamBuilder<AppSetting>(
              stream: SettingsRepository(db).watch(),
              builder: (context, s) => s.hasData
                  ? AppointmentRemindersTile(settings: s.data!)
                  : const SizedBox(),
            ),
          ),
        ),
      ),
    );
    await settle();
    await tester.tap(find.widgetWithText(FilterChip, '2 Std.'));
    await settle();
    var s = await tester.runAsync(() => SettingsRepository(db).get());
    expect(parseLeadMinutes(s!.appointmentReminderLeads), [1440, 120, 60]);

    await tester.tap(find.text('Termin-Erinnerungen'));
    await settle();
    s = await tester.runAsync(() => SettingsRepository(db).get());
    expect(s!.appointmentRemindersEnabled, isFalse);
    expect(find.text('Erinnern vorher'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 100));
  });
}
