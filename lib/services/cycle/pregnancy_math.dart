/// Rechnen rund um eine Schwangerschaft — reine Kalenderarithmetik, keine
/// medizinische Bewertung.
///
/// * Naegele-Regel: errechneter Termin = erster Tag der letzten Periode
///   (LMP) + 280 Tage (40 Wochen). Ein Termin aus dem Ultraschall hat Vorrang.
/// * Schwangerschaftswoche (SSW) „14+3“ = 14 vollendete Wochen + 3 Tage seit
///   LMP (bzw. Termin − 280 Tage).
/// * Trimester (ACOG): 1. bis 13+6, 2. bis 27+6, 3. ab 28+0.
/// * Mutterschafts-Richtlinien (G-BA): Vorsorge alle 4 Wochen, ab der
///   32. SSW alle 2 Wochen; drei Basis-Ultraschalle in 9+0–12+6, 19+0–22+6
///   und 29+0–32+6.
library;

import 'cycle_dates.dart';

/// Dauer bis zum errechneten Termin.
const pregnancyDays = 280;

/// Errechneter Termin nach Naegele.
DateTime naegeleDueDate(DateTime lmp) => plusDays(cycleDay(lmp), pregnancyDays);

/// SSW als vollendete Wochen + Tage.
class GestationalAge {
  const GestationalAge(this.totalDays);

  final int totalDays;

  int get weeks => totalDays ~/ 7;
  int get days => totalDays % 7;

  /// 1, 2 oder 3.
  int get trimester => totalDays < 14 * 7
      ? 1
      : totalDays < 28 * 7
      ? 2
      : 3;

  /// „14+3“.
  String get label => '$weeks+$days';

  @override
  bool operator ==(Object other) =>
      other is GestationalAge && other.totalDays == totalDays;

  @override
  int get hashCode => totalDays.hashCode;

  @override
  String toString() => 'SSW $label';
}

/// Stand einer Schwangerschaft an einem Tag.
class PregnancyStatus {
  const PregnancyStatus({required this.dueDate, required this.today});

  /// `null`, wenn weder LMP noch Termin bekannt sind.
  static PregnancyStatus? from({
    DateTime? lmp,
    DateTime? dueDate,
    required DateTime today,
  }) {
    final due = dueDate != null
        ? cycleDay(dueDate)
        : lmp != null
        ? naegeleDueDate(lmp)
        : null;
    if (due == null) return null;
    return PregnancyStatus(dueDate: due, today: cycleDay(today));
  }

  final DateTime dueDate;
  final DateTime today;

  /// Rechnerischer Beginn (Tag 0 = „LMP“).
  DateTime get start => plusDays(dueDate, -pregnancyDays);

  GestationalAge get age => GestationalAge(dayDiff(start, today));

  int get daysToDue => dayDiff(today, dueDate);

  /// Tag, an dem die SSW [weeks]+[days] beginnt.
  DateTime dateAt(int weeks, [int days = 0]) =>
      plusDays(start, weeks * 7 + days);
}

enum MilestoneKind { checkup, ultrasound }

/// Vorschlag aus der Mutterschaftsvorsorge, z. B. „Ultraschall 19+0–22+6“.
class PregnancyMilestone {
  const PregnancyMilestone({
    required this.kind,
    required this.fromWeek,
    required this.toWeek,
    required this.from,
    required this.to,
  });

  final MilestoneKind kind;
  final int fromWeek;

  /// Letzte Woche (inklusive, bis +6 Tage).
  final int toWeek;
  final DateTime from;
  final DateTime to;

  /// Vorgeschlagener Termin (Beginn des Fensters).
  DateTime get suggested => from;

  String get weeksLabel =>
      fromWeek == toWeek ? '$fromWeek' : '$fromWeek–$toWeek';
}

/// Vorsorge-Wochen: alle 4 Wochen bis zur 32., danach alle 2 Wochen.
const checkupWeeks = [8, 12, 16, 20, 24, 28, 32, 34, 36, 38, 40];

/// Fenster der drei Basis-Ultraschalle.
const ultrasoundWindows = [(9, 12), (19, 22), (29, 32)];

/// Zeitstrahl (nach Datum sortiert). Mit [upcomingOnly] nur Einträge, deren
/// Fenster heute noch nicht vorbei ist.
List<PregnancyMilestone> pregnancyTimeline(
  PregnancyStatus status, {
  bool upcomingOnly = false,
}) {
  final items =
      <PregnancyMilestone>[
        for (final w in checkupWeeks)
          PregnancyMilestone(
            kind: MilestoneKind.checkup,
            fromWeek: w,
            toWeek: w,
            from: status.dateAt(w),
            to: status.dateAt(w, 6),
          ),
        for (final (a, b) in ultrasoundWindows)
          PregnancyMilestone(
            kind: MilestoneKind.ultrasound,
            fromWeek: a,
            toWeek: b,
            from: status.dateAt(a),
            to: status.dateAt(b, 6),
          ),
      ]..sort((a, b) {
        final byDate = a.from.compareTo(b.from);
        // Bei gleichem Beginn zuerst der Ultraschall.
        return byDate != 0 ? byDate : b.kind.index.compareTo(a.kind.index);
      });
  if (!upcomingOnly) return items;
  return [
    for (final m in items)
      if (!m.to.isBefore(status.today)) m,
  ];
}
