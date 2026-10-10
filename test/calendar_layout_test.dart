import 'package:flutter_test/flutter_test.dart';
import 'package:mai_doctor_hub/features/calendar/calendar_layout.dart';

void main() {
  group('week start', () {
    test('setting wins, otherwise the locale (0 = Sunday)', () {
      expect(resolveFirstWeekday(null, 1), DateTime.monday, reason: 'DE');
      expect(resolveFirstWeekday(null, 0), DateTime.sunday, reason: 'US');
      expect(resolveFirstWeekday(null, 6), DateTime.saturday);
      expect(resolveFirstWeekday(DateTime.monday, 0), DateTime.monday);
      expect(resolveFirstWeekday(DateTime.sunday, 1), DateTime.sunday);
      expect(resolveFirstWeekday(DateTime.saturday, 1), DateTime.saturday);
      // Ungültige gespeicherte Werte → automatisch.
      expect(resolveFirstWeekday(0, 1), DateTime.monday);
      expect(resolveFirstWeekday(9, 0), DateTime.sunday);
    });

    test('startOfWeek for each option', () {
      final wed = DateTime(2026, 10, 7); // Mittwoch
      expect(startOfWeek(wed, DateTime.monday), DateTime(2026, 10, 5));
      expect(startOfWeek(wed, DateTime.sunday), DateTime(2026, 10, 4));
      expect(startOfWeek(wed, DateTime.saturday), DateTime(2026, 10, 3));
      // Der Wochenbeginn selbst bleibt.
      final mon = DateTime(2026, 10, 5, 14, 30);
      expect(startOfWeek(mon, DateTime.monday), DateTime(2026, 10, 5));
      final sun = DateTime(2026, 10, 11);
      expect(startOfWeek(sun, DateTime.monday), DateTime(2026, 10, 5));
      expect(startOfWeek(sun, DateTime.sunday), DateTime(2026, 10, 11));
      // Über den Jahreswechsel.
      expect(
        startOfWeek(DateTime(2027, 1, 1), DateTime.monday),
        DateTime(2026, 12, 28),
      );
    });

    test('weekdayOrder rotates', () {
      expect(weekdayOrder(DateTime.monday), [1, 2, 3, 4, 5, 6, 7]);
      expect(weekdayOrder(DateTime.sunday), [7, 1, 2, 3, 4, 5, 6]);
      expect(weekdayOrder(DateTime.saturday), [6, 7, 1, 2, 3, 4, 5]);
    });
  });

  group('ISO week number', () {
    test('ordinary weeks', () {
      expect(isoWeekNumber(DateTime(2026, 10, 5)), 41);
      expect(isoWeekNumber(DateTime(2026, 10, 11)), 41);
      expect(isoWeekNumber(DateTime(2026, 10, 12)), 42);
    });

    test('year boundaries and 53-week years', () {
      // 2026 beginnt an einem Donnerstag → 53 Wochen.
      expect(isoWeekNumber(DateTime(2026, 12, 31)), 53);
      expect(isoWeekYear(DateTime(2026, 12, 31)), 2026);
      expect(isoWeekNumber(DateTime(2027, 1, 1)), 53);
      expect(isoWeekYear(DateTime(2027, 1, 1)), 2026);
      expect(isoWeekNumber(DateTime(2027, 1, 3)), 53);
      expect(isoWeekNumber(DateTime(2027, 1, 4)), 1);
      expect(isoWeekNumber(DateTime(2026, 1, 1)), 1);
      // 30.12.2024 (Montag) gehört schon zu KW 1/2025.
      expect(isoWeekNumber(DateTime(2024, 12, 30)), 1);
      expect(isoWeekYear(DateTime(2024, 12, 30)), 2025);
      // 1.1.2021 (Freitag) gehört zu KW 53/2020.
      expect(isoWeekNumber(DateTime(2021, 1, 1)), 53);
      expect(isoWeekNumber(DateTime(2023, 1, 1)), 52);
    });
  });

  group('month grid', () {
    test('6 weeks starting at the configured weekday', () {
      final monday = monthGridDays(DateTime(2026, 10, 17), DateTime.monday);
      expect(monday, hasLength(42));
      expect(monday.first, DateTime(2026, 9, 28));
      expect(monday.last, DateTime(2026, 11, 8));
      expect(monday.first.weekday, DateTime.monday);

      final sunday = monthGridDays(DateTime(2026, 10), DateTime.sunday);
      expect(sunday.first, DateTime(2026, 9, 27));
      expect(sunday.first.weekday, DateTime.sunday);

      final saturday = monthGridDays(DateTime(2026, 10), DateTime.saturday);
      expect(saturday.first, DateTime(2026, 9, 26));
    });

    test('month starting on the week start begins with the 1st', () {
      // Februar 2027 beginnt an einem Montag.
      final days = monthGridDays(DateTime(2027, 2), DateTime.monday);
      expect(days.first, DateTime(2027, 2, 1));
      expect(days.every((d) => d.hour == 0), isTrue);
    });
  });

  group('DST-safe days', () {
    test('day iteration over the clock change stays at midnight', () {
      // Zeitumstellung in Deutschland: 25.10.2026 und 28.03.2027.
      final october = daysInRange(
        DateTime(2026, 10, 24),
        DateTime(2026, 10, 27),
      );
      expect(october, [
        DateTime(2026, 10, 24),
        DateTime(2026, 10, 25),
        DateTime(2026, 10, 26),
      ]);
      final march = daysInRange(DateTime(2027, 3, 27), DateTime(2027, 3, 30));
      expect(march.map((d) => (d.day, d.hour, d.minute)), [
        (27, 0, 0),
        (28, 0, 0),
        (29, 0, 0),
      ]);
      expect(addDays(DateTime(2026, 10, 25), 1), DateTime(2026, 10, 26));
      expect(daysBetween(DateTime(2026, 10, 24), DateTime(2026, 10, 26)), 2);
      expect(daysBetween(DateTime(2027, 3, 28, 23), DateTime(2027, 3, 29)), 1);
    });
  });

  group('time grid', () {
    test('visible hours expand to fit events', () {
      expect(visibleHourRange(const []), (6, 22));
      expect(visibleHourRange(const [(8 * 60, 9 * 60)]), (6, 22));
      expect(visibleHourRange(const [(5 * 60 + 30, 6 * 60)]), (5, 22));
      expect(visibleHourRange(const [(21 * 60 + 45, 22 * 60 + 15)]), (6, 23));
      expect(visibleHourRange(const [(23 * 60, 24 * 60)]), (6, 24));
      expect(visibleHourRange(const [(0, 30)]), (0, 22));
    });

    test('initial scroll: first event minus 30 min, else 08:00', () {
      expect(initialScrollMinute(const [], rangeStart: 360), 480);
      expect(initialScrollMinute(const [600, 540], rangeStart: 360), 510);
      expect(initialScrollMinute(const [370], rangeStart: 360), 360);
    });

    test('non-overlapping events take the full width', () {
      expect(packColumns(const [(540, 600), (600, 660)]), const [
        ColumnPlacement(0, 1),
        ColumnPlacement(0, 1),
      ]);
    });

    test('overlapping events sit side by side', () {
      final p = packColumns(const [(540, 600), (570, 630), (585, 615)]);
      expect(p, const [
        ColumnPlacement(0, 3),
        ColumnPlacement(1, 3),
        ColumnPlacement(2, 3),
      ]);
    });

    test('free columns reuse and expand to the right', () {
      // A 9–11, B 9–10, C 10–11: C nimmt Spalte 1 (B ist vorbei).
      final p = packColumns(const [(540, 660), (540, 600), (600, 660)]);
      expect(p, const [
        ColumnPlacement(0, 2),
        ColumnPlacement(1, 2),
        ColumnPlacement(1, 2),
      ]);
      // Cluster mit drei Spalten; der späte Termin hat rechts frei.
      final q = packColumns(const [
        (540, 660), // A
        (550, 580), // B
        (560, 600), // C
        (600, 630), // D: neben A, Spalte 1, Spalte 2 frei → Breite 2
      ]);
      expect(q[0], const ColumnPlacement(0, 3));
      expect(q[1], const ColumnPlacement(1, 3));
      expect(q[2], const ColumnPlacement(2, 3));
      expect(q[3], const ColumnPlacement(1, 3, 2));
    });

    test('separate clusters are independent; input order kept', () {
      final p = packColumns(const [(720, 780), (540, 600), (550, 560)]);
      expect(p, const [
        ColumnPlacement(0, 1),
        ColumnPlacement(0, 2),
        ColumnPlacement(1, 2),
      ]);
    });
  });

  group('row lanes', () {
    test('all-day bar spans columns; timed items fill lanes', () {
      final r = layoutRowLanes(const [(1, 3), (2, 2), (2, 2)], maxLanes: 3);
      expect(r.lanes, [0, 1, 2]);
      expect(r.visible, [true, true, true]);
      expect(r.hiddenPerColumn, [0, 0, 0, 0, 0, 0, 0]);
    });

    test('overflow reserves the last lane for "+N"', () {
      final r = layoutRowLanes(const [
        (4, 4),
        (4, 4),
        (4, 4),
        (4, 4),
        (5, 5),
      ], maxLanes: 3);
      expect(r.visible, [true, true, false, false, true]);
      expect(r.hiddenPerColumn[4], 2);
      expect(r.hiddenPerColumn[5], 0);
      expect(r.usedLanes, 2);
    });

    test('a bar hides when one of its days overflows', () {
      final r = layoutRowLanes(const [
        (0, 0),
        (0, 0),
        (0, 1),
        (0, 0),
      ], maxLanes: 3);
      // Bar in Lane 2 passt in Spalte 0 nicht (Überlauf) → ausgeblendet.
      expect(r.lanes, [0, 1, 2, 3]);
      expect(r.visible, [true, true, false, false]);
      expect(r.hiddenPerColumn.take(2), [2, 1]);
    });
  });
}
