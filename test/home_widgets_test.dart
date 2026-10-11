import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/database_provider.dart';
import 'package:mai_doctor_hub/data/repositories/appointment_repository.dart';
import 'package:mai_doctor_hub/data/repositories/doctor_repository.dart';
import 'package:mai_doctor_hub/data/repositories/medication_repository.dart';
import 'package:mai_doctor_hub/data/repositories/settings_repository.dart';
import 'package:mai_doctor_hub/data/repositories/symptom_repository.dart';
import 'package:mai_doctor_hub/data/symptom_measure.dart';
import 'package:mai_doctor_hub/features/settings/home_widgets_section.dart';
import 'package:mai_doctor_hub/services/home_widgets/home_widget_sync.dart';
import 'package:mai_doctor_hub/services/home_widgets/widget_actions.dart';
import 'package:mai_doctor_hub/services/home_widgets/widget_snapshot.dart';

/// Attrappe der nativen Seite.
class FakeBridge implements HomeWidgetBridge {
  String? pending;
  final updates = <(String, List<String>)>[];

  @override
  Future<void> update(String snapshot, List<String> ack) async =>
      updates.add((snapshot, ack));

  @override
  Future<String?> pendingActions() async => pending;

  @override
  Future<String?> takeLaunchLink() async => null;

  @override
  set onOpen(void Function(String link)? handler) {}
}

/// Beispielakte mit allem, was die Widgets zeigen (alles erfunden).
Future<({String medId, String symptomId})> seed(
  AppDatabase db,
  DateTime now,
) async {
  final doctorId = await DoctorRepository(db).create(name: 'Dr. Vertraulich');
  await AppointmentRepository(db).create(
    doctorId: doctorId,
    scheduledAt: DateTime(now.year, now.month, now.day + 1, 9, 30),
    title: 'Nachsorge Geheimsache',
  );
  final medId = await MedicationRepository(db).save(
    name: 'Geheimol',
    doseAmount: 1,
    doseUnit: 'Tablette',
    schedules: const [
      ScheduleInput(hour: 8, minute: 0),
      ScheduleInput(hour: 20, minute: 0),
    ],
  );
  final symptomId = await SymptomRepository(db).create(
    label: 'Heimliches Ziehen',
  );
  await SymptomRepository(db).addMeasurement(
    symptomId: symptomId,
    measure: SymptomMeasure.intensity,
    value: 4,
    recordedAt: DateTime(now.year, now.month, now.day, 7),
  );
  return (medId: medId, symptomId: symptomId);
}

const secrets = [
  'Dr. Vertraulich',
  'Nachsorge Geheimsache',
  'Geheimol',
  'Tablette',
  'Heimliches Ziehen',
];

void main() {
  late AppDatabase db;
  final now = DateTime(2030, 3, 11, 12);

  setUpAll(() => initializeDateFormatting('de'));

  group('snapshot', () {
    setUp(() => db = AppDatabase(NativeDatabase.memory()));
    tearDown(() => db.close());

    test('with details: names, doses for a week, check-in', () async {
      final ids = await seed(db, now);
      await SettingsRepository(db).setWidgetDiscreet(false);
      final s = await buildWidgetSnapshot(db, now: now);

      expect(s['v'], widgetSnapshotVersion);
      expect(s['discreet'], isFalse);
      final appointments = s['appointments']! as List;
      expect(appointments.single, containsPair('doctor', 'Dr. Vertraulich'));
      expect(appointments.single, containsPair('title', 'Nachsorge Geheimsache'));
      expect(
        (appointments.single as Map)['at'],
        DateTime(2030, 3, 12, 9, 30).millisecondsSinceEpoch,
      );
      final doses = (s['doses']! as List).cast<Map<String, Object?>>();
      expect(doses, hasLength(2 * widgetDoseDays));
      expect(doses.first, containsPair('med', ids.medId));
      expect(doses.first, containsPair('name', 'Geheimol'));
      expect(doses.first, containsPair('dose', '1 Tablette'));
      expect(doses.first, isNot(contains('status')));
      expect(
        s['dosesUntil'],
        DateTime(2030, 3, 18).millisecondsSinceEpoch,
      );
      final checkIn = s['checkIn']! as Map;
      expect(checkIn['symptom'], ids.symptomId);
      expect(checkIn['label'], 'Heimliches Ziehen');
      expect(checkIn['quick'], isTrue);
      expect(checkIn['lastValue'], 4);
    });

    test('discreet with app lock: no plain text at all', () async {
      await seed(db, now);
      await SettingsRepository(db).setAppLock(true);
      final s = await buildWidgetSnapshot(db, now: now);
      expect(s['discreet'], isTrue);
      final json = jsonEncode(s);
      for (final secret in secrets) {
        expect(json, isNot(contains(secret)), reason: secret);
      }
      // Zeiten und IDs bleiben — das Widget funktioniert weiter.
      expect(s['appointments'], hasLength(1));
      expect(s['doses'], hasLength(2 * widgetDoseDays));
      expect((s['checkIn']! as Map)['lastValue'], 4);
    });

    test('explicit choice beats the automatic', () async {
      await seed(db, now);
      final settings = SettingsRepository(db);
      await settings.setAppLock(true);
      await settings.setWidgetDiscreet(false);
      expect((await buildWidgetSnapshot(db, now: now))['discreet'], isFalse);
      await settings.setAppLock(false);
      await settings.setWidgetDiscreet(true);
      final s = await buildWidgetSnapshot(db, now: now);
      expect(s['discreet'], isTrue);
      expect(jsonEncode(s), isNot(contains('Geheimol')));
      await settings.setWidgetDiscreet(null);
      expect((await buildWidgetSnapshot(db, now: now))['discreet'], isFalse);
    });

    test('past and cancelled appointments are left out', () async {
      final doctorId = await DoctorRepository(db).create(name: 'Dr. A');
      final repo = AppointmentRepository(db);
      await repo.create(
        doctorId: doctorId,
        scheduledAt: now.subtract(const Duration(hours: 3)),
        durationMin: 30,
      );
      final running = await repo.create(
        doctorId: doctorId,
        scheduledAt: now.subtract(const Duration(minutes: 10)),
        durationMin: 30,
      );
      final cancelled = await repo.create(
        doctorId: doctorId,
        scheduledAt: now.add(const Duration(days: 2)),
      );
      await repo.updateStatus(cancelled, AppointmentStatus.cancelled);
      final s = await buildWidgetSnapshot(db, now: now);
      expect([for (final a in s['appointments']! as List) (a as Map)['id']], [
        running,
      ]);
    });

    test('mood and other measures open the full check-in', () async {
      await SymptomRepository(db).create(
        label: 'Stimmung',
        measures: (primary: SymptomMeasure.mood, secondary: null),
      );
      final s = await buildWidgetSnapshot(db, now: now);
      expect((s['checkIn']! as Map)['quick'], isFalse);
    });

    test('no symptoms, no medications: empty but valid', () async {
      final s = await buildWidgetSnapshot(db, now: now);
      expect(s['appointments'], isEmpty);
      expect(s['doses'], isEmpty);
      expect(s['checkIn'], isNull);
    });

    test('Android reads the format (fixture for WidgetData.kt)', () async {
      await seed(db, now);
      await SettingsRepository(db).setWidgetDiscreet(false);
      final s = await buildWidgetSnapshot(db, now: now);
      // Feste Schlüssel, die `WidgetData.kt` liest.
      expect(s.keys, containsAll([
        'v',
        'discreet',
        'appointments',
        'doses',
        'dosesUntil',
        'checkIn',
      ]));
      expect((s['appointments']! as List).first, isA<Map<String, Object?>>());
      expect(
        ((s['appointments']! as List).first as Map).keys,
        containsAll(['id', 'at', 'end']),
      );
      expect(
        ((s['doses']! as List).first as Map).keys,
        containsAll(['med', 'at']),
      );
      expect(
        (s['checkIn']! as Map).keys,
        containsAll(['symptom', 'quick']),
      );
      final out = Platform.environment['WIDGET_SNAPSHOT_OUT'];
      if (out != null) File(out).writeAsStringSync(jsonEncode(s));
    });
  });

  group('actions from the widget', () {
    setUp(() => db = AppDatabase(NativeDatabase.memory()));
    tearDown(() => db.close());

    test('queue parsing tolerates junk and unknown types', () {
      const raw =
          '[{"id":"a","type":"intake","med":"m","at":1,"ts":2},'
          '{"id":"b","type":"checkin","symptom":"s","value":14,"ts":3},'
          '{"id":"c","type":"future","ts":4},'
          '{"id":"d","type":"intake","ts":5},'
          '"kaputt"]';
      final actions = WidgetAction.parseQueue(raw);
      expect(actions, hasLength(2));
      expect(actions.first, isA<IntakeAction>());
      expect((actions.last as CheckInAction).value, 10, reason: 'begrenzt');
      expect(WidgetAction.queueIds(raw), ['a', 'b', 'c', 'd']);
      expect(WidgetAction.parseQueue('{nope'), isEmpty);
      expect(WidgetAction.parseQueue(null), isEmpty);
    });

    test('intake is recorded once; the app wins over the widget', () async {
      final ids = await seed(db, now);
      final at = DateTime(2030, 3, 11, 8);
      final tappedAt = DateTime(2030, 3, 11, 8, 5);
      final action = IntakeAction(
        'x',
        tappedAt,
        medicationId: ids.medId,
        scheduledFor: at,
      );
      expect(await applyWidgetActions(db, [action]), 1);
      expect(await applyWidgetActions(db, [action]), 0, reason: 'doppelt');
      final intakes = await db.select(db.medicationIntakes).get();
      expect(intakes.single.status, IntakeStatus.taken);
      expect(intakes.single.recordedAt, tappedAt);
      expect(intakes.single.scheduledFor, at);

      // Abends in der App ausgelassen, danach am Widget getippt → bleibt.
      final evening = DateTime(2030, 3, 11, 20);
      await MedicationRepository(db).recordIntake(
        medicationId: ids.medId,
        scheduledFor: evening,
        status: IntakeStatus.skipped,
      );
      expect(
        await applyWidgetActions(db, [
          IntakeAction('y', now, medicationId: ids.medId, scheduledFor: evening),
        ]),
        0,
      );
      // Gelöschtes Medikament → verworfen statt Fehler.
      expect(
        await applyWidgetActions(db, [
          IntakeAction('z', now, medicationId: 'weg', scheduledFor: evening),
        ]),
        0,
      );
    });

    test('check-in becomes an intensity observation, once', () async {
      final ids = await seed(db, now);
      final tappedAt = DateTime(2030, 3, 11, 12, 30);
      final action = CheckInAction(
        'c',
        tappedAt,
        symptomId: ids.symptomId,
        value: 7,
      );
      expect(await applyWidgetActions(db, [action, action]), 1);
      final latest = await SymptomRepository(
        db,
      ).latestObservation(ids.symptomId);
      expect(latest!.recordedAt, tappedAt);
      expect(latest.valueNumber, 7);
      expect(latest.kind, ObservationKind.scale_1_10);
      expect(
        await applyWidgetActions(db, [
          CheckInAction('d', now, symptomId: 'weg', value: 3),
        ]),
        0,
      );
    });

    test('sync applies pending input, then acknowledges all of it', () async {
      final ids = await seed(db, now);
      final bridge = FakeBridge()
        ..pending = jsonEncode([
          {
            'id': 'a1',
            'type': 'intake',
            'med': ids.medId,
            'at': DateTime(2030, 3, 11, 8).millisecondsSinceEpoch,
            'ts': DateTime(2030, 3, 11, 8, 2).millisecondsSinceEpoch,
          },
          {'id': 'a2', 'type': 'unbekannt', 'ts': 1},
        ]);
      final sync = HomeWidgetSync(db, bridge: bridge, clock: () => now);
      expect(await sync.applyPending(), 1);
      final (snapshot, ack) = bridge.updates.single;
      expect(ack, ['a1', 'a2']);
      final doses = (jsonDecode(snapshot) as Map)['doses'] as List;
      expect(
        doses.where((d) => (d as Map)['status'] == 'taken'),
        hasLength(1),
      );
    });

    test('links from the widget', () {
      expect(WidgetLink.parse('appointment/a1'), isA<AppointmentLink>());
      expect((WidgetLink.parse('checkin/s1')! as CheckInLink).symptomId, 's1');
      expect((WidgetLink.parse('checkin')! as CheckInLink).symptomId, isNull);
      expect(WidgetLink.parse('medications'), isA<MedicationsLink>());
      expect(WidgetLink.parse('appointment/'), isNull);
      expect(WidgetLink.parse('irgendwas'), isNull);
      expect(WidgetLink.parse(null), isNull);
    });
  });

  testWidgets('settings: choose discreet or detailed widgets', (tester) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    await tester.pumpWidget(
      DatabaseScope(
        database: db,
        child: MaterialApp(
          home: Scaffold(
            body: StreamBuilder<AppSetting>(
              stream: SettingsRepository(db).watch(),
              builder: (context, snapshot) => snapshot.hasData
                  ? HomeWidgetsSection(settings: snapshot.data!)
                  : const SizedBox(),
            ),
          ),
        ),
      ),
    );
    Future<void> settle() async {
      for (var i = 0; i < 5; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 10)),
        );
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    await settle();
    expect(find.text('Automatisch'), findsOneWidget);
    expect(
      find.text('Zurzeit mit Details. Mit App-Sperre automatisch diskret.'),
      findsOneWidget,
    );
    await tester.tap(find.text('Diskret'));
    await settle();
    var settings = await tester.runAsync(() => SettingsRepository(db).get());
    expect(settings!.widgetDiscreet, isTrue);
    await tester.tap(find.text('Details'));
    await settle();
    settings = await tester.runAsync(() => SettingsRepository(db).get());
    expect(settings!.widgetDiscreet, isFalse);
    await tester.tap(find.text('Automatisch'));
    await settle();
    settings = await tester.runAsync(() => SettingsRepository(db).get());
    expect(settings!.widgetDiscreet, isNull);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 100));
  });

  test('watch apps: widget sync also runs on iOS (Apple Watch)', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    expect(HomeWidgetSync.isSupported, isTrue);
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    expect(HomeWidgetSync.isSupported, isTrue);
    debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
    expect(HomeWidgetSync.isSupported, isFalse);
  });

  testWidgets('settings: watch hint on Android, watch title on iOS', (
    tester,
  ) async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final settings = await tester.runAsync(() => SettingsRepository(db).get());
    Widget section() => DatabaseScope(
      database: db,
      child: MaterialApp(
        home: Scaffold(body: HomeWidgetsSection(settings: settings!)),
      ),
    );

    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    await tester.pumpWidget(section());
    expect(find.text('Startbildschirm-Widgets'), findsOneWidget);
    expect(find.textContaining('Wear-OS-Uhr'), findsOneWidget);

    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    await tester.pumpWidget(section());
    await tester.pump();
    expect(find.text('Apple Watch'), findsOneWidget);
    expect(find.textContaining('Wear-OS-Uhr'), findsNothing);
    debugDefaultTargetPlatformOverride = null;

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 100));
  });
}
