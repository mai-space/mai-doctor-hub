import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/repositories/settings_repository.dart';
import 'package:mai_doctor_hub/main.dart';
import 'package:mai_doctor_hub/services/app_lock.dart';

class FakeAuthenticator implements LockAuthenticator {
  bool available = true;
  bool succeed = true;
  int calls = 0;

  @override
  Future<bool> isAvailable() async => available;

  @override
  Future<bool> authenticate(String reason) async {
    calls++;
    return succeed;
  }
}

void main() {
  setUpAll(() => initializeDateFormatting('de'));

  group('AppLockController', () {
    late FakeAuthenticator auth;
    late DateTime now;
    late AppLockController lock;

    setUp(() {
      auth = FakeAuthenticator();
      now = DateTime(2026, 10, 5, 12);
      lock = AppLockController(
        authenticator: auth,
        enabled: true,
        clock: () => now,
      );
    });

    test('starts locked when enabled; unlock needs success', () async {
      expect(lock.locked, isTrue);
      auth.succeed = false;
      expect(await lock.unlock(), isFalse);
      expect(lock.locked, isTrue);
      auth.succeed = true;
      expect(await lock.unlock(), isTrue);
      expect(lock.locked, isFalse);
    });

    test('relocks only after the grace period in background', () async {
      await lock.unlock();
      lock.didChangeAppLifecycleState(AppLifecycleState.paused);
      now = now.add(const Duration(seconds: 30));
      lock.didChangeAppLifecycleState(AppLifecycleState.resumed);
      expect(lock.locked, isFalse);

      lock.didChangeAppLifecycleState(AppLifecycleState.hidden);
      lock.didChangeAppLifecycleState(AppLifecycleState.paused);
      now = now.add(const Duration(minutes: 2));
      lock.didChangeAppLifecycleState(AppLifecycleState.resumed);
      expect(lock.locked, isTrue);
    });

    test('disabling unlocks; enabling requires available + auth', () async {
      lock.setEnabled(false);
      expect(lock.locked, isFalse);

      auth.available = false;
      expect(await lock.enableWithConfirmation(), isFalse);
      expect(lock.enabled, isFalse);

      auth.available = true;
      auth.succeed = false;
      expect(await lock.enableWithConfirmation(), isFalse);
      expect(lock.enabled, isFalse);

      auth.succeed = true;
      expect(await lock.enableWithConfirmation(), isTrue);
      expect(lock.enabled, isTrue);
      expect(lock.locked, isFalse, reason: 'gerade bestätigt');
    });
  });

  group('Widgets', () {
    late AppDatabase db;
    late FakeAuthenticator auth;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      auth = FakeAuthenticator();
    });
    tearDown(() => db.close());

    Future<void> settle(WidgetTester tester) async {
      for (var i = 0; i < 5; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 10)),
        );
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    testWidgets('locked app hides content until unlocked', (tester) async {
      auth.succeed = false;
      final lock = AppLockController(authenticator: auth, enabled: true);
      addTearDown(lock.dispose);
      await tester.pumpWidget(MaiDoctorHubApp(database: db, appLock: lock));
      await settle(tester);

      expect(auth.calls, 1, reason: 'fragt beim Start automatisch');
      expect(find.text('Mai Doctor Hub ist gesperrt'), findsOneWidget);
      expect(find.text('Termin hinzufügen'), findsNothing);

      auth.succeed = true;
      await tester.tap(find.text('Entsperren'));
      await settle(tester);
      expect(find.text('Mai Doctor Hub ist gesperrt'), findsNothing);
      expect(find.text('Termin hinzufügen'), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 100));
    });

    testWidgets('settings toggle persists app lock', (tester) async {
      tester.view.physicalSize = const Size(1080, 4000);
      tester.view.devicePixelRatio = 2.5;
      addTearDown(tester.view.reset);
      final lock = AppLockController(authenticator: auth);
      addTearDown(lock.dispose);
      await tester.pumpWidget(MaiDoctorHubApp(database: db, appLock: lock));
      await settle(tester);
      await tester.tap(find.text('Einstellungen'));
      await settle(tester);

      await tester.tap(find.text('App-Sperre'));
      await settle(tester);
      expect(lock.enabled, isTrue);
      final settings = await tester.runAsync(
        () => SettingsRepository(db).get(),
      );
      expect(settings!.appLockEnabled, isTrue);

      await tester.tap(find.text('App-Sperre'));
      await settle(tester);
      expect(lock.enabled, isFalse);

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(milliseconds: 100));
    });
  });
}
