import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/connection/database_key.dart';
import 'package:mai_doctor_hub/data/database_provider.dart';
import 'package:mai_doctor_hub/data/repositories/container_paths.dart';
import 'package:mai_doctor_hub/features/settings/notification_topics_page.dart';
import 'package:mai_doctor_hub/l10n/l10n.dart';
import 'package:mai_doctor_hub/services/app_lock.dart';
import 'package:mai_doctor_hub/services/assistant/assistant_engine.dart';
import 'package:mai_doctor_hub/services/calendar/calendar_gateway.dart';
import 'package:mai_doctor_hub/services/device_platform.dart';
import 'package:mai_doctor_hub/services/device_time.dart';
import 'package:mai_doctor_hub/services/notification_service.dart';
import 'package:mai_doctor_hub/services/notifications/notification_plan.dart';
import 'package:mai_doctor_hub/services/ocr/document_scanner.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

/// Plattform-Weichen für die iOS-App (Android bleibt unverändert).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  /// Zeichnet Aufrufe auf [channel] auf; [reply] liefert die Antwort.
  List<MethodCall> mockChannel(
    String channel,
    Object? Function(MethodCall call) reply,
  ) {
    final calls = <MethodCall>[];
    messenger.setMockMethodCallHandler(MethodChannel(channel), (call) async {
      calls.add(call);
      return reply(call);
    });
    addTearDown(
      () => messenger.setMockMethodCallHandler(MethodChannel(channel), null),
    );
    return calls;
  }

  void onPlatform(TargetPlatform platform) {
    debugDefaultTargetPlatformOverride = platform;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
  }

  group('DevicePlatform', () {
    test('iOS und Android sind mobil, macOS nicht', () {
      onPlatform(TargetPlatform.iOS);
      expect(DevicePlatform.isIOS, isTrue);
      expect(DevicePlatform.isAndroid, isFalse);
      expect(DevicePlatform.isMobile, isTrue);

      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      expect(DevicePlatform.isAndroid, isTrue);
      expect(DevicePlatform.isMobile, isTrue);

      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      expect(DevicePlatform.isMobile, isFalse);
    });

    test('Scanner und Kalender gibt es auf iOS, nicht auf dem Desktop', () {
      onPlatform(TargetPlatform.iOS);
      expect(MlKitDocumentScanner().isSupported, isTrue);
      expect(AndroidCalendarGateway().isSupported, isTrue);

      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      expect(MlKitDocumentScanner().isSupported, isFalse);
      expect(AndroidCalendarGateway().isSupported, isFalse);
    });
  });

  group('Datenbankschlüssel', () {
    test('iOS fragt den Schlüsselbund-Kanal', () async {
      final key = 'ab' * 32;
      final calls = mockChannel('mai/db_key', (_) => key);
      const store = PlatformDatabaseKeyStore(operatingSystem: 'ios');
      expect(await store.getOrCreate(), key);
      await store.reset();
      expect(calls.map((c) => c.method), ['getOrCreate', 'reset']);
    });

    test('KEY_LOST wird Verlust, alles andere vorübergehend', () async {
      var code = 'KEY_LOST';
      mockChannel(
        'mai/db_key',
        (_) => throw PlatformException(code: code, message: 'x'),
      );
      const store = PlatformDatabaseKeyStore(operatingSystem: 'ios');
      await expectLater(store.getOrCreate(), throwsA(isA<DatabaseKeyLost>()));
      code = 'KEY_UNAVAILABLE';
      await expectLater(
        store.getOrCreate(),
        throwsA(isA<DatabaseKeyUnavailable>()),
      );
    });

    test('Desktop bleibt unverschlüsselt, ohne Kanal', () async {
      final calls = mockChannel('mai/db_key', (_) => 'nie');
      const store = PlatformDatabaseKeyStore(operatingSystem: 'macos');
      expect(await store.getOrCreate(), isNull);
      await store.reset();
      expect(calls, isEmpty);
    });
  });

  group('mai/device und mai/secure_window', () {
    test('Zeitzone kommt auf iOS vom Gerät', () async {
      onPlatform(TargetPlatform.iOS);
      mockChannel('mai/device', (call) => 'Europe/Vienna');
      expect(await DeviceTime.timeZone(), 'Europe/Vienna');
    });

    test('Zeitzone auf dem Desktop: Standard', () async {
      onPlatform(TargetPlatform.macOS);
      final calls = mockChannel('mai/device', (call) => 'Europe/Vienna');
      expect(await DeviceTime.timeZone(), DeviceTime.fallbackTimeZone);
      expect(calls, isEmpty);
    });

    test('App-Umschalter wird auf iOS verdeckt', () async {
      onPlatform(TargetPlatform.iOS);
      final calls = mockChannel('mai/secure_window', (_) => null);
      await SecureWindow.setSecure(true);
      expect(calls.single.method, 'setSecure');
      expect(calls.single.arguments, isTrue);
    });
  });

  group('Assistent auf iOS', () {
    const gib = 1024 * 1024 * 1024;

    test('braucht 64 Bit und genug Arbeitsspeicher', () {
      final strings = AppLocale.strings;
      expect(
        iosAssistantSupport({'arm64': false, 'totalRam': 8 * gib}),
        isA<AssistantUnsupported>().having(
          (s) => s.reason,
          'reason',
          strings.svcAssistantNeedsArm64,
        ),
      );
      expect(
        iosAssistantSupport({'arm64': true, 'totalRam': 4 * gib}),
        isA<AssistantUnsupported>().having(
          (s) => s.reason,
          'reason',
          strings.svcAssistantNeedsMoreMemory,
        ),
      );
      expect(
        iosAssistantSupport({'arm64': true, 'totalRam': (5.6 * gib).round()}),
        isA<AssistantSupported>().having((s) => s.lowMemory, 'low', isTrue),
      );
      expect(
        iosAssistantSupport({'arm64': true, 'totalRam': (7.5 * gib).round()}),
        isA<AssistantSupported>().having((s) => s.lowMemory, 'low', isFalse),
      );
    });

    test('support() nutzt auf iOS die Geräteangaben', () async {
      onPlatform(TargetPlatform.iOS);
      mockChannel(
        'mai/device',
        (_) => {'platform': 'ios', 'arm64': true, 'totalRam': 8 * gib},
      );
      final support = await GemmaAssistantEngine().support();
      expect(support, isA<AssistantSupported>());
    });

    test('Desktop: nur in der App für Android und iOS', () async {
      onPlatform(TargetPlatform.macOS);
      final support = await GemmaAssistantEngine().support();
      expect(
        support,
        isA<AssistantUnsupported>().having(
          (s) => s.reason,
          'reason',
          AppLocale.strings.svcAssistantMobileOnly,
        ),
      );
    });
  });

  group('Benachrichtigungs-Budget (iOS: max. 64 ausstehend)', () {
    setUpAll(tzdata.initializeTimeZones);

    PlannedNotification once(int id, DateTime at) => PlannedNotification.once(
      id: id,
      title: 't',
      body: 'b',
      payload: '',
      topic: NotificationTopic.appointmentSoon,
      at: at,
    );

    test('nimmt die nächsten, wiederkehrende zählen einmal', () {
      final berlin = tz.getLocation('Europe/Berlin');
      final now = tz.TZDateTime(berlin, 2026, 3, 2, 12);
      final plans = [
        // Täglich 08:00 → morgen früh.
        PlannedNotification.repeating(
          id: 300001,
          title: 'Tablette',
          body: '',
          payload: '',
          topic: NotificationTopic.medication,
          hour: 8,
          minute: 0,
        ),
        for (var i = 0; i < 70; i++)
          once(
            200000 + i,
            DateTime.utc(2026, 3, 2, 12).add(Duration(hours: i + 1)),
          ),
        // Vergangen: fällt weg.
        once(200999, DateTime.utc(2026, 3, 1)),
      ];
      final allowed = NotificationService.withinBudget(plans, now);
      expect(allowed, hasLength(NotificationService.iosPendingLimit));
      expect(allowed, contains(300001));
      expect(allowed, contains(200000));
      expect(allowed, isNot(contains(200999)));
      // Die spätesten fallen heraus.
      expect(allowed, isNot(contains(200069)));
    });

    test('unter dem Limit bleibt alles', () {
      final berlin = tz.getLocation('Europe/Berlin');
      final now = tz.TZDateTime(berlin, 2026, 3, 2, 12);
      final plans = [
        for (var i = 0; i < 5; i++)
          once(400000 + i, DateTime.utc(2026, 4, i + 1)),
      ];
      expect(NotificationService.withinBudget(plans, now), {
        for (final p in plans) p.id,
      });
    });
  });

  group('iOS-Container-Pfade', () {
    const oldDocs =
        '/var/mobile/Containers/Data/Application/'
        '1B2C3D4E-0000-4000-8000-ABCDEF012345/Documents';
    const newDocs =
        '/var/mobile/Containers/Data/Application/'
        '9F8E7D6C-1111-4111-8111-0123456789AB/Documents';

    test('alter Container wird auf den neuen umgebogen', () {
      expect(
        relocatedContainerPath('$oldDocs/reports/a.pdf', newDocs),
        '$newDocs/reports/a.pdf',
      );
      // Schon richtig, leer, Android-Pfad oder „..“: unverändert.
      expect(relocatedContainerPath('$newDocs/reports/a.pdf', newDocs), isNull);
      expect(relocatedContainerPath('', newDocs), isNull);
      expect(
        relocatedContainerPath(
          '/data/user/0/space.mai.mai_doctor_hub/app_flutter/reports/a.pdf',
          newDocs,
        ),
        isNull,
      );
      expect(
        relocatedContainerPath('$oldDocs/../../x/db.key', newDocs),
        isNull,
      );
    });

    test('Berichte und Belege in der Datenbank', () async {
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);
      final now = DateTime(2026, 3, 2);
      await db
          .into(db.reports)
          .insert(
            ReportsCompanion.insert(
              id: 'r1',
              title: 'Befund',
              mimeType: 'application/pdf',
              localPath: '$oldDocs/reports/r1.pdf',
              source: ReportSource.pdf,
              createdAt: now,
            ),
          );
      await db
          .into(db.reports)
          .insert(
            ReportsCompanion.insert(
              id: 'r2',
              title: 'Web',
              mimeType: 'application/pdf',
              localPath: 'web-memory://r2',
              source: ReportSource.pdf,
              createdAt: now,
            ),
          );

      expect(await relocateContainerPaths(db, documentsDir: newDocs), 1);
      final paths = {
        for (final r in await db.select(db.reports).get()) r.id: r.localPath,
      };
      expect(paths, {'r1': '$newDocs/reports/r1.pdf', 'r2': 'web-memory://r2'});
      // Zweiter Lauf: nichts mehr zu tun.
      expect(await relocateContainerPaths(db, documentsDir: newDocs), 0);
    });
  });

  testWidgets('Benachrichtigungen: iOS-Hinweis statt Android-Kanälen', (
    tester,
  ) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    tester.view.physicalSize = const Size(1080, 6000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
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
    for (var i = 0; i < 5; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 10)),
      );
      await tester.pump();
    }
    final strings = AppLocale.strings;
    expect(
      find.text(strings.settingsNotificationSystemHintIos),
      findsOneWidget,
    );
    expect(find.text(strings.settingsNotificationSystemHint), findsNothing);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
    await tester.runAsync(db.close);
    debugDefaultTargetPlatformOverride = null;
  });
}
