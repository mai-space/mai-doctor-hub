import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/database_provider.dart';
import 'package:mai_doctor_hub/data/repositories/appointment_repository.dart';
import 'package:mai_doctor_hub/data/repositories/cycle_repository.dart';
import 'package:mai_doctor_hub/data/repositories/doctor_repository.dart';
import 'package:mai_doctor_hub/data/repositories/settings_repository.dart';
import 'package:mai_doctor_hub/data/repositories/vaccination_repository.dart';
import 'package:mai_doctor_hub/features/calendar/calendar_events.dart';
import 'package:mai_doctor_hub/features/calendar/calendar_page.dart';
import 'package:mai_doctor_hub/features/calendar/calendar_views.dart';
import 'package:mai_doctor_hub/features/home/add_appointment_sheet.dart';
import 'package:mai_doctor_hub/features/settings/calendar_section.dart';
import 'package:mai_doctor_hub/l10n/l10n.dart';
import 'package:mai_doctor_hub/theme/app_theme.dart';

import 'helpers/fake_calendar.dart';

void main() {
  late AppDatabase db;
  late String doctorId;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  /// Mittwoch, 7. Oktober 2026 (KW 41).
  final focus = DateTime(2026, 10, 7);

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 6; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 10)),
      );
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  void phone(WidgetTester tester) {
    tester.view.physicalSize = const Size(1200, 2000);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
  }

  Future<String> appointment(
    WidgetTester tester,
    DateTime at, {
    int? minutes,
    String? title,
  }) async {
    return (await tester.runAsync(() async {
      doctorId = await DoctorRepository(db).create(name: 'Dr. Weber');
      return AppointmentRepository(db).create(
        doctorId: doctorId,
        scheduledAt: at,
        durationMin: minutes,
        title: title,
      );
    }))!;
  }

  Future<void> weekStart(WidgetTester tester, int? weekday) async {
    await tester.runAsync(
      () => SettingsRepository(db).setCalendarFirstWeekday(weekday),
    );
  }

  Future<void> pumpCalendar(
    WidgetTester tester, {
    CalendarViewMode view = CalendarViewMode.month,
  }) async {
    phone(tester);
    await tester.pumpWidget(
      DatabaseScope(
        database: db,
        child: MaterialApp(
          theme: AppTheme.light(),
          locale: AppLocale.german,
          supportedLocales: AppLocale.supported,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: CalendarPage(initialDate: focus, initialView: view),
          ),
        ),
      ),
    );
    await settle(tester);
  }

  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 100));
  }

  String title(WidgetTester tester) =>
      tester.widget<Text>(find.byKey(const ValueKey('calendar-title'))).data!;

  String firstWeekday(WidgetTester tester) => tester
      .widget<Text>(find.byKey(const ValueKey('calendar-first-weekday')))
      .data!;

  testWidgets('week start: automatic (DE) is Monday with KW, Sunday setting '
      'moves the first column', (tester) async {
    await pumpCalendar(tester);
    expect(firstWeekday(tester), 'Mo');
    expect(find.text('KW'), findsOneWidget);
    expect(find.text('41'), findsOneWidget);
    // Erstes Feld im Raster: Montag, 28. September — darunter der 5. Oktober.
    final first = tester.getTopLeft(
      find.byKey(const ValueKey('calendar-day-2026-09-28')),
    );
    final below = tester.getTopLeft(
      find.byKey(const ValueKey('calendar-day-2026-10-05')),
    );
    expect(first.dx, below.dx);
    expect(first.dy, lessThan(below.dy));

    await weekStart(tester, DateTime.sunday);
    await settle(tester);
    expect(firstWeekday(tester), 'So');
    expect(find.text('KW'), findsNothing, reason: 'KW nur bei Montag');
    expect(
      find.byKey(const ValueKey('calendar-day-2026-09-27')),
      findsOneWidget,
    );
    final sunday = tester.getTopLeft(
      find.byKey(const ValueKey('calendar-day-2026-10-04')),
    );
    final monday = tester.getTopLeft(
      find.byKey(const ValueKey('calendar-day-2026-10-05')),
    );
    expect(sunday.dx, lessThan(monday.dx));
    expect(sunday.dy, monday.dy);

    await weekStart(tester, DateTime.saturday);
    await settle(tester);
    expect(firstWeekday(tester), 'Sa');

    // Wochenansicht übernimmt den Wochenbeginn (ohne KW im Titel).
    await tester.tap(find.text('Woche'));
    await settle(tester);
    expect(title(tester), '3.–9. Okt. 2026');
    await unmount(tester);
  });

  testWidgets('week view: event block height follows the duration', (
    tester,
  ) async {
    final hour = await appointment(
      tester,
      DateTime(2026, 10, 7, 10),
      minutes: 60,
      title: 'Kontrolle',
    );
    final short = await appointment(tester, DateTime(2026, 10, 8, 14));
    await pumpCalendar(tester, view: CalendarViewMode.week);
    expect(title(tester), 'KW 41 · 5.–11. Okt. 2026');

    final block = find.byKey(ValueKey('calendar-event-$hour'));
    expect(block, findsOneWidget);
    expect(tester.getSize(block).height, CalendarTimeGrid.hourHeight);
    // Ohne Dauer: 30 Minuten.
    expect(
      tester.getSize(find.byKey(ValueKey('calendar-event-$short'))).height,
      CalendarTimeGrid.hourHeight / 2,
    );
    // 10:00 liegt eine Stunde unter 09:00 (gleiche Spalte, Raster ab 06:00).
    final slots = find.byKey(const ValueKey('calendar-slots-2026-10-07'));
    expect(
      tester.getTopLeft(block).dy - tester.getTopLeft(slots).dy,
      4 * CalendarTimeGrid.hourHeight,
    );
    expect(tester.getTopLeft(block).dx, tester.getTopLeft(slots).dx);
    expect(
      find.bySemanticsLabel(RegExp('10:00–11:00, Kontrolle, Dr. Weber')),
      findsOneWidget,
    );
    await unmount(tester);
  });

  testWidgets('week view: overlapping events sit side by side', (tester) async {
    final a = await appointment(tester, DateTime(2026, 10, 7, 9), minutes: 60);
    final b = await appointment(
      tester,
      DateTime(2026, 10, 7, 9, 30),
      minutes: 60,
    );
    await pumpCalendar(tester, view: CalendarViewMode.week);
    final ra = tester.getRect(find.byKey(ValueKey('calendar-event-$a')));
    final rb = tester.getRect(find.byKey(ValueKey('calendar-event-$b')));
    final column = tester.getRect(
      find.byKey(const ValueKey('calendar-slots-2026-10-07')),
    );
    expect(ra.width, closeTo(column.width / 2, 0.01));
    expect(rb.width, closeTo(column.width / 2, 0.01));
    expect(ra.left, closeTo(column.left, 0.01));
    expect(rb.left, closeTo(ra.right, 0.01));
    expect(rb.top - ra.top, CalendarTimeGrid.hourHeight / 2);
    await unmount(tester);
  });

  testWidgets('month: chips per day, "+N weitere" opens the day sheet', (
    tester,
  ) async {
    for (var i = 0; i < 9; i++) {
      await appointment(
        tester,
        DateTime(2026, 10, 14, 8 + i),
        title: 'Termin $i',
      );
    }
    await pumpCalendar(tester);
    expect(title(tester), 'Oktober 2026');
    expect(find.textContaining('08:00 Termin 0'), findsOneWidget);
    final more = find.byKey(const ValueKey('calendar-more-2026-10-14'));
    expect(more, findsOneWidget);
    final label = tester
        .widget<Semantics>(
          find.descendant(of: more, matching: find.byType(Semantics)).first,
        )
        .properties
        .label!;
    expect(label, matches(RegExp(r'^\+\d weitere$')));
    final shown = find.textContaining(RegExp(r'^\d\d:00 Termin')).evaluate();
    expect(shown.length + int.parse(label.substring(1, 2)), 9);

    await tester.tap(more);
    await settle(tester);
    expect(find.text('Mittwoch, 14. Oktober 2026'), findsOneWidget);
    expect(find.byType(CalendarEventTile), findsNWidgets(9));
    await unmount(tester);
  });

  testWidgets('view switching, navigation titles, swipe and day tap', (
    tester,
  ) async {
    await pumpCalendar(tester);
    expect(title(tester), 'Oktober 2026');
    await tester.tap(find.byTooltip('Weiter'));
    await settle(tester);
    expect(title(tester), 'November 2026');
    await tester.tap(find.byTooltip('Zurück'));
    await settle(tester);
    expect(title(tester), 'Oktober 2026');

    // Wischen nach links → nächster Monat.
    await tester.fling(
      find.byType(CalendarMonthView),
      const Offset(-300, 0),
      1000,
    );
    await settle(tester);
    expect(title(tester), 'November 2026');
    await tester.fling(
      find.byType(CalendarMonthView),
      const Offset(300, 0),
      1000,
    );
    await settle(tester);
    expect(title(tester), 'Oktober 2026');

    // Tag antippen → Tagesansicht.
    await tester.tap(find.byKey(const ValueKey('calendar-day-2026-10-08')));
    await settle(tester);
    expect(title(tester), 'Do., 8. Okt. 2026');
    await tester.tap(find.byTooltip('Weiter'));
    await settle(tester);
    expect(title(tester), 'Fr., 9. Okt. 2026');

    await tester.tap(find.text('Woche'));
    await settle(tester);
    expect(title(tester), 'KW 41 · 5.–11. Okt. 2026');
    await tester.tap(find.byTooltip('Weiter'));
    await settle(tester);
    expect(title(tester), 'KW 42 · 12.–18. Okt. 2026');

    await tester.tap(find.text('Liste'));
    await settle(tester);
    expect(title(tester), '16. Okt. – 14. Nov. 2026');

    await tester.tap(find.text('Jahr'));
    await settle(tester);
    expect(title(tester), '2026');
    await tester.tap(find.byTooltip('Weiter'));
    await settle(tester);
    expect(title(tester), '2027');
    await tester.tap(find.byKey(const ValueKey('calendar-year-month-3')));
    await settle(tester);
    expect(title(tester), 'März 2027');

    await tester.tap(find.text('Heute'));
    await settle(tester);
    expect(title(tester), DateFormat.yMMMM().format(DateTime.now()));
    await unmount(tester);

    // Die Ansicht bleibt für die Sitzung gemerkt.
    phone(tester);
    await tester.pumpWidget(
      DatabaseScope(
        database: db,
        child: MaterialApp(
          locale: AppLocale.german,
          supportedLocales: AppLocale.supported,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(body: CalendarPage(initialDate: focus)),
        ),
      ),
    );
    await settle(tester);
    expect(title(tester), 'Oktober 2026');
    await tester.tap(find.text('Liste'));
    await settle(tester);
    await unmount(tester);
    await tester.pumpWidget(
      DatabaseScope(
        database: db,
        child: MaterialApp(
          locale: AppLocale.german,
          supportedLocales: AppLocale.supported,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(body: CalendarPage(initialDate: focus)),
        ),
      ),
    );
    await settle(tester);
    expect(title(tester), '7. Okt. – 5. Nov. 2026');
    await tester.tap(find.text('Monat'));
    await settle(tester);
    await unmount(tester);
  });

  testWidgets('list: grouped by day, all-day items included, empty state', (
    tester,
  ) async {
    await pumpCalendar(tester, view: CalendarViewMode.list);
    expect(find.text('Keine Einträge in diesem Zeitraum'), findsOneWidget);
    await unmount(tester);

    await appointment(tester, DateTime(2026, 10, 8, 9), title: 'Blutbild');
    await appointment(tester, DateTime(2026, 10, 8, 15), title: 'Röntgen');
    await appointment(tester, DateTime(2026, 10, 12, 11), title: 'Befund');
    await tester.runAsync(
      () => VaccinationRepository(db).save(
        vaccine: 'Tetanus',
        administeredAt: DateTime(2016, 10, 10),
        nextDueAt: DateTime(2026, 10, 10),
      ),
    );
    await pumpCalendar(tester, view: CalendarViewMode.list);
    expect(find.text('Keine Einträge in diesem Zeitraum'), findsNothing);
    final days = [
      for (final key in ['2026-10-08', '2026-10-10', '2026-10-12'])
        tester.getTopLeft(find.byKey(ValueKey('calendar-list-day-$key'))).dy,
    ];
    expect(days, orderedEquals([...days]..sort()));
    expect(find.text('Donnerstag, 8. Oktober 2026'), findsOneWidget);
    final blood = tester.getTopLeft(find.text('Blutbild')).dy;
    final xray = tester.getTopLeft(find.text('Röntgen')).dy;
    expect(blood, greaterThan(days[0]));
    expect(xray, greaterThan(blood));
    expect(xray, lessThan(days[1]));
    expect(find.text('Impfung fällig: Tetanus'), findsOneWidget);
    expect(find.text('Befund'), findsOneWidget);
    await unmount(tester);
  });

  testWidgets('long-press on an empty slot prefills the new appointment', (
    tester,
  ) async {
    await pumpCalendar(tester, view: CalendarViewMode.day);
    expect(title(tester), 'Mi., 7. Okt. 2026');
    final slots = find.byKey(const ValueKey('calendar-slots-2026-10-07'));
    // 06:00 + 3,5 h → 09:30.
    final top = tester.getTopLeft(slots);
    await tester.longPressAt(
      top + Offset(20, 3.6 * CalendarTimeGrid.hourHeight),
    );
    await settle(tester);
    expect(find.byType(AddAppointmentSheet), findsOneWidget);
    final pattern = AppLocale.strings.homeSheetDateTimePattern;
    expect(
      find.textContaining(
        DateFormat(pattern).format(DateTime(2026, 10, 7, 9, 30)),
      ),
      findsOneWidget,
    );
    await unmount(tester);
  });

  testWidgets('all views render on a small phone without overflow', (
    tester,
  ) async {
    for (var i = 0; i < 4; i++) {
      await appointment(
        tester,
        DateTime(2026, 10, 7, 9 + i ~/ 2, 15 * i),
        minutes: 45,
        title: 'Sehr langer Termintitel $i',
      );
    }
    await appointment(tester, DateTime(2026, 10, 7, 23, 30), minutes: 90);
    await tester.runAsync(
      () => VaccinationRepository(db).save(
        vaccine: 'Influenza',
        administeredAt: DateTime(2025, 10, 7),
        nextDueAt: DateTime(2026, 10, 7),
      ),
    );
    await pumpCalendar(tester);
    tester.view.physicalSize = const Size(720, 1280);
    tester.view.devicePixelRatio = 2;
    await settle(tester);
    for (final view in ['Woche', 'Tag', 'Liste', 'Jahr', 'Monat']) {
      await tester.tap(find.text(view));
      await settle(tester);
      expect(tester.takeException(), isNull, reason: view);
    }
    await unmount(tester);
  });

  test('events: appointments with default duration, due vaccinations, '
      'cycle periods and prediction only when tracking is on', () async {
    final doctor = await DoctorRepository(db).create(name: 'Dr. Weber');
    await AppointmentRepository(db)
        .create(doctorId: doctor, scheduledAt: DateTime(2026, 10, 7, 9));
    await VaccinationRepository(db).save(
      vaccine: 'Tetanus',
      administeredAt: DateTime(2016, 10, 10),
      nextDueAt: DateTime(2026, 10, 10),
    );
    final cycle = CycleRepository(db);
    for (var i = 0; i < 4; i++) {
      await cycle.saveDay(
        DateTime(2026, 10, 1 + i),
        const CycleDaysCompanion(flow: Value(CycleFlow.medium)),
      );
    }
    final start = DateTime(2026, 9, 28);
    final end = DateTime(2026, 11, 9);
    final now = DateTime(2026, 10, 7, 12);

    var events = await loadCalendarEvents(db, start, end, now: now);
    expect(events.map((e) => e.kind), [
      CalendarEventKind.vaccination,
      CalendarEventKind.appointment,
    ]);
    final appointment = events.last;
    expect(appointment.title, 'Dr. Weber');
    expect(appointment.durationMinutes, 30);
    expect(events.first.title, 'Impfung fällig: Tetanus');
    expect(events.first.coversDay(DateTime(2026, 10, 10)), isTrue);

    await cycle.setCycleTracking(true);
    events = await loadCalendarEvents(db, start, end, now: now);
    final period = events.firstWhere((e) => e.kind == CalendarEventKind.period);
    expect(
      (period.firstDay, period.lastDay),
      (DateTime(2026, 10, 1), DateTime(2026, 10, 4)),
    );
    expect(period.allDay, isTrue);
    final expected = events.firstWhere(
      (e) => e.kind == CalendarEventKind.periodExpected,
    );
    expect(expected.firstDay.isAfter(DateTime(2026, 10, 7)), isTrue);
    expect(
      events.where((e) => e.kind == CalendarEventKind.fertile),
      isEmpty,
      reason: 'fruchtbares Fenster nur auf Wunsch',
    );
  });

  testWidgets('settings: week start dropdown stores the choice', (
    tester,
  ) async {
    phone(tester);
    await tester.pumpWidget(
      DatabaseScope(
        database: db,
        child: MaterialApp(
          locale: AppLocale.german,
          supportedLocales: AppLocale.supported,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: Scaffold(
            body: StreamBuilder<AppSetting>(
              stream: SettingsRepository(db).watch(),
              builder: (context, snapshot) => snapshot.hasData
                  ? SingleChildScrollView(
                      child: CalendarSection(
                        settings: snapshot.data!,
                        gateway: FakeCalendar(),
                      ),
                    )
                  : const SizedBox(),
            ),
          ),
        ),
      ),
    );
    await settle(tester);
    expect(find.text('Woche beginnt am'), findsWidgets);
    await tester.tap(find.byKey(const ValueKey('calendar-week-start')));
    await settle(tester);
    expect(find.text('Automatisch (Montag)'), findsWidgets);
    await tester.tap(find.text('Sonntag').last);
    await settle(tester);
    var settings = (await tester.runAsync(() => SettingsRepository(db).get()))!;
    expect(settings.calendarFirstWeekday, DateTime.sunday);

    await tester.tap(find.byKey(const ValueKey('calendar-week-start')));
    await settle(tester);
    await tester.tap(find.text('Automatisch (Montag)').last);
    await settle(tester);
    settings = (await tester.runAsync(() => SettingsRepository(db).get()))!;
    expect(settings.calendarFirstWeekday, isNull);
    await unmount(tester);
  });
}
