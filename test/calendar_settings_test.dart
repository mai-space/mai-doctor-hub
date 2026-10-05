import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/database_provider.dart';
import 'package:mai_doctor_hub/data/repositories/appointment_repository.dart';
import 'package:mai_doctor_hub/data/repositories/doctor_repository.dart';
import 'package:mai_doctor_hub/data/repositories/settings_repository.dart';
import 'package:mai_doctor_hub/features/settings/calendar_section.dart';

import 'helpers/fake_calendar.dart';

void main() {
  setUpAll(() => initializeDateFormatting('de'));

  testWidgets('enable picks primary Google calendar; sync now exports', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final calendar = FakeCalendar()..permission = false;
    await tester.runAsync(() async {
      final doctorId = await DoctorRepository(db).create(name: 'Dr. West');
      await AppointmentRepository(
        db,
      ).create(doctorId: doctorId, scheduledAt: DateTime(2030, 1, 2, 9));
    });

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
              builder: (context, snapshot) => snapshot.hasData
                  ? SingleChildScrollView(
                      child: CalendarSection(
                        settings: snapshot.data!,
                        gateway: calendar,
                      ),
                    )
                  : const SizedBox(),
            ),
          ),
        ),
      ),
    );
    await settle();

    await tester.tap(find.text('Termine in Kalender übertragen'));
    await settle();
    final settings = await tester.runAsync(() => SettingsRepository(db).get());
    expect(settings!.calendarSyncEnabled, isTrue);
    expect(settings.calendarId, 'g1', reason: 'primärer Google-Kalender');
    expect(find.text('Privat (me@gmail.com)'), findsOneWidget);

    await tester.tap(find.text('Jetzt'));
    await settle();
    expect(calendar.all('g1'), hasLength(1));
    expect(find.text('1 Termin(e) im Kalender'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 100));
  });
}
