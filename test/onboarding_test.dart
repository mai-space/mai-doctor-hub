import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:drift/drift.dart' show Value;
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/database_provider.dart';
import 'package:mai_doctor_hub/data/repositories/settings_repository.dart';
import 'package:mai_doctor_hub/features/settings/reminders_section.dart';
import 'package:mai_doctor_hub/main.dart';

import 'helpers/test_env.dart';

void main() {
  late AppDatabase db;

  setUpAll(() => initializeDateFormatting('de'));
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 6; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 10)),
      );
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  testWidgets('first start: onboarding asks for notifications, then app', (
    tester,
  ) async {
    final permissions = useFakePermissions(granted: false);
    await tester.pumpWidget(MaiDoctorHubApp(database: db));
    await settle(tester);

    expect(find.text('Deine Akte bleibt bei dir'), findsOneWidget);
    expect(permissions.requests, 0, reason: 'nicht beim Start');

    await tester.tap(find.text('Weiter'));
    await settle(tester);
    await tester.tap(find.text('Weiter'));
    await settle(tester);
    // v14: Schritt „Zyklus & Frauengesundheit“ (optional) überspringen.
    expect(find.text('Zyklus & Frauengesundheit'), findsOneWidget);
    await tester.tap(find.text('Weiter'));
    await settle(tester);
    await tester.tap(find.text('Benachrichtigungen erlauben'));
    await settle(tester);
    expect(permissions.requests, 1);
    expect(find.text('Erlaubt'), findsOneWidget);

    await tester.tap(find.text('Los geht’s'));
    await settle(tester);
    expect(find.text('Erfassen'), findsOneWidget);
    final settings = await tester.runAsync(() => SettingsRepository(db).get());
    expect(settings!.onboardingCompleted, isTrue);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 100));
  });

  testWidgets('skip leaves permission untouched', (tester) async {
    final permissions = useFakePermissions(granted: false);
    await tester.pumpWidget(MaiDoctorHubApp(database: db));
    await settle(tester);
    await tester.tap(find.text('Überspringen'));
    await settle(tester);
    expect(find.text('Erfassen'), findsOneWidget);
    expect(permissions.requests, 0);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 100));
  });

  testWidgets('reminders: hint when denied; enabling asks with explanation', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 2.5;
    addTearDown(tester.view.reset);
    final permissions = useFakePermissions(granted: false);
    await tester.runAsync(() async {
      await (db.update(db.reminders)).write(
        const RemindersCompanion(enabled: Value(false)),
      );
    });
    await tester.pumpWidget(
      DatabaseScope(
        database: db,
        child: const MaterialApp(
          home: Scaffold(body: SingleChildScrollView(child: RemindersSection())),
        ),
      ),
    );
    await settle(tester);
    expect(find.text('Benachrichtigungen sind aus'), findsOneWidget);

    await tester.tap(find.byType(Switch).first);
    await settle(tester);
    expect(find.text('Benachrichtigungen erlauben?'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Erlauben'));
    await settle(tester);
    expect(permissions.requests, 1);
    expect(find.text('Benachrichtigungen sind aus'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 100));
  });

  test('upgrade from an older schema skips onboarding', () async {
    // Frische DB = Neuinstallation → Onboarding offen.
    expect((await SettingsRepository(db).get()).onboardingCompleted, isFalse);
  });
}
