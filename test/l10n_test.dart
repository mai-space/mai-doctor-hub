import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/repositories/doctor_repository.dart';
import 'package:mai_doctor_hub/data/repositories/appointment_repository.dart';
import 'package:mai_doctor_hub/l10n/l10n.dart';
import 'package:mai_doctor_hub/main.dart';

import 'helpers/test_env.dart';

void main() {
  test('system language picks German or English, otherwise English', () {
    expect(AppLocale.resolve(const [Locale('de', 'AT')]), AppLocale.german);
    expect(AppLocale.resolve(const [Locale('en', 'US')]), AppLocale.english);
    expect(AppLocale.resolve(const [Locale('fr'), Locale('de')]), AppLocale.german);
    expect(AppLocale.resolve(const [Locale('fr')]), AppLocale.english);
    expect(AppLocale.resolve(const []), AppLocale.english);
  });

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 6; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 10)),
      );
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  testWidgets('English device: onboarding in English', (tester) async {
    _EnglishDevice.use(tester);
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    useFakePermissions();
    await tester.pumpWidget(MaiDoctorHubApp(database: db));
    await settle(tester);
    expect(find.text('Your records stay with you'), findsOneWidget);
    expect(find.textContaining('Deine Akte'), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 100));
  });

  testWidgets('English device: app runs in English end to end', (
    tester,
  ) async {
    _EnglishDevice.use(tester);
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    useFakePermissions();

    await tester.runAsync(() async {
      await markOnboarded(db);
      final doctor = await DoctorRepository(
        db,
      ).create(name: 'Dr. Smith', specialty: 'Cardiology');
      await AppointmentRepository(
        db,
      ).create(doctorId: doctor, scheduledAt: DateTime(2030, 3, 14, 15, 30));
    });
    await tester.pumpWidget(MaiDoctorHubApp(database: db));
    await settle(tester);

    expect(find.text('Add'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('My records'), findsWidgets);
    // Datum im englischen Format, nicht „Do 14. März“.
    expect(find.textContaining('Mar 14'), findsWidgets);
    expect(find.textContaining('März'), findsNothing);

    await tester.tap(find.text('Settings'));
    await settle(tester);
    expect(find.textContaining('Einstellungen'), findsNothing);

    await tester.tap(find.text('My records').last);
    await settle(tester);
    expect(find.text('Dr. Smith'), findsOneWidget);
    expect(find.text('No entries yet'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 100));
  });
}

class _EnglishDevice {
  static void use(WidgetTester tester) {
    final dispatcher = tester.binding.platformDispatcher;
    dispatcher.localesTestValue = const [Locale('en', 'US')];
    dispatcher.localeTestValue = const Locale('en', 'US');
    AppLocale.update(AppLocale.english);
    addTearDown(() {
      dispatcher.localesTestValue = const [Locale('de', 'DE')];
      dispatcher.localeTestValue = const Locale('de', 'DE');
      AppLocale.update(AppLocale.german);
    });
  }
}
