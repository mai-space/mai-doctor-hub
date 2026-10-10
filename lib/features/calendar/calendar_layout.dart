/// Reine Layout-Rechnungen für den Kalender (ohne Flutter, testbar).
///
/// Angelehnt an FullCalendar: Wochenbeginn, ISO-Kalenderwochen, 6-Zeilen-
/// Monatsraster, Spalten-Packen überlappender Termine und Zeilen-Lanes für
/// ganztägige Balken. Tage sind immer lokale Daten ohne Uhrzeit; gerechnet
/// wird über den `DateTime`-Konstruktor bzw. UTC — so bleiben Tage auch über
/// Sommer-/Winterzeit hinweg ganze Tage.
library;

/// Erlaubte Werte der Einstellung „Woche beginnt am“ (`DateTime.weekday`).
const calendarWeekStartOptions = [
  DateTime.monday,
  DateTime.sunday,
  DateTime.saturday,
];

/// Wirksamer Wochenbeginn (`DateTime.weekday`, 1 = Montag … 7 = Sonntag).
///
/// [setting] ist der gespeicherte Wert (`null` = automatisch);
/// [localeFirstDayIndex] ist `MaterialLocalizations.firstDayOfWeekIndex`
/// (0 = Sonntag, 1 = Montag … 6 = Samstag).
int resolveFirstWeekday(int? setting, int localeFirstDayIndex) {
  if (setting != null && setting >= 1 && setting <= 7) return setting;
  final index = localeFirstDayIndex % 7;
  return index == 0 ? DateTime.sunday : index;
}

/// Lokaler Tag (Mitternacht) eines Zeitpunkts.
DateTime dateOnly(DateTime at) => DateTime(at.year, at.month, at.day);

/// [day] plus [days] Kalendertage (DST-sicher über den Konstruktor).
DateTime addDays(DateTime day, int days) =>
    DateTime(day.year, day.month, day.day + days);

/// Ganze Kalendertage von [from] bis [to].
int daysBetween(DateTime from, DateTime to) => DateTime.utc(
  to.year,
  to.month,
  to.day,
).difference(DateTime.utc(from.year, from.month, from.day)).inDays;

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Alle Tage von [start] (inklusive) bis [end] (exklusive).
List<DateTime> daysInRange(DateTime start, DateTime end) {
  final count = daysBetween(start, end);
  return [for (var i = 0; i < count; i++) addDays(dateOnly(start), i)];
}

/// Erster Tag der Woche, in der [day] liegt.
DateTime startOfWeek(DateTime day, int firstWeekday) =>
    addDays(dateOnly(day), -((day.weekday - firstWeekday) % 7));

/// Wochentage in Anzeigereihenfolge (`DateTime.weekday`-Werte).
List<int> weekdayOrder(int firstWeekday) => [
  for (var i = 0; i < 7; i++) (firstWeekday - 1 + i) % 7 + 1,
];

/// ISO-8601-Kalenderwoche (Woche mit dem Donnerstag zählt).
int isoWeekNumber(DateTime day) {
  final thursday = addDays(dateOnly(day), DateTime.thursday - day.weekday);
  final dayOfYear = daysBetween(DateTime(thursday.year), thursday);
  return dayOfYear ~/ 7 + 1;
}

/// Jahr, zu dem die ISO-Kalenderwoche von [day] gehört.
int isoWeekYear(DateTime day) =>
    addDays(dateOnly(day), DateTime.thursday - day.weekday).year;

/// Tage des Monatsrasters (immer 6 Wochen à 7 Tage, wie FullCalendar):
/// beginnt am Wochenbeginn vor bzw. am Monatsersten.
List<DateTime> monthGridDays(DateTime month, int firstWeekday) {
  final first = startOfWeek(DateTime(month.year, month.month), firstWeekday);
  return [for (var i = 0; i < 42; i++) addDays(first, i)];
}

/// Minute des Tages (0–1439) eines Zeitpunkts.
int minuteOfDay(DateTime at) => at.hour * 60 + at.minute;

// ------------------------------------------------------- Zeitraster (Tag)

/// Sichtbare Stunden des Zeitrasters: Standard [defaultStart]–[defaultEnd],
/// erweitert, damit alle Termine ([intervals] in Tagesminuten) hineinpassen.
(int, int) visibleHourRange(
  Iterable<(int, int)> intervals, {
  int defaultStart = 6,
  int defaultEnd = 22,
}) {
  var start = defaultStart;
  var end = defaultEnd;
  for (final (from, to) in intervals) {
    final s = (from.clamp(0, 1440) / 60).floor();
    final e = (to.clamp(0, 1440) / 60).ceil();
    if (s < start) start = s;
    if (e > end) end = e;
  }
  return (start.clamp(0, 23), end.clamp(1, 24));
}

/// Startposition zum Scrollen (Tagesminute): erster Termin minus
/// [lead] Minuten, sonst [fallback] (08:00); nie vor [rangeStart].
int initialScrollMinute(
  Iterable<int> eventStarts, {
  required int rangeStart,
  int fallback = 8 * 60,
  int lead = 30,
}) {
  int? first;
  for (final s in eventStarts) {
    if (first == null || s < first) first = s;
  }
  final target = first == null ? fallback : first - lead;
  return target < rangeStart ? rangeStart : target;
}

/// Platz eines Termins im Zeitraster: Spalte [column] von [columns] im
/// Überlappungs-Cluster; [span] Spalten breit (nach rechts erweitert, wenn
/// dort für die ganze Dauer frei ist — wie FullCalendar).
class ColumnPlacement {
  const ColumnPlacement(this.column, this.columns, [this.span = 1]);

  final int column;
  final int columns;
  final int span;

  @override
  bool operator ==(Object other) =>
      other is ColumnPlacement &&
      other.column == column &&
      other.columns == columns &&
      other.span == span;

  @override
  int get hashCode => Object.hash(column, columns, span);

  @override
  String toString() => 'ColumnPlacement($column/$columns×$span)';
}

/// Packt Intervalle (`start`, `end` in Minuten, `end` exklusiv) in Spalten.
/// Ergebnis in Eingabereihenfolge.
///
/// 1. Sortieren nach Beginn, längere zuerst.
/// 2. Cluster bilden: Intervalle, die sich (transitiv) überlappen.
/// 3. Im Cluster erste Spalte nehmen, deren letzter Termin schon endete.
/// 4. Breite nach rechts erweitern, solange die Nachbarspalte frei ist.
List<ColumnPlacement> packColumns(List<(int, int)> intervals) {
  final n = intervals.length;
  final result = List<ColumnPlacement>.filled(n, const ColumnPlacement(0, 1));
  if (n == 0) return result;
  int endOf(int i) {
    final (s, e) = intervals[i];
    return e > s ? e : s + 1;
  }

  final order = List<int>.generate(n, (i) => i)
    ..sort((a, b) {
      final byStart = intervals[a].$1.compareTo(intervals[b].$1);
      if (byStart != 0) return byStart;
      final byEnd = endOf(b).compareTo(endOf(a));
      return byEnd != 0 ? byEnd : a.compareTo(b);
    });

  var cluster = <int>[];
  var clusterEnd = -1;
  final columnOf = List<int>.filled(n, 0);

  void finish() {
    if (cluster.isEmpty) return;
    final columnEnds = <int>[];
    final members = <int, List<int>>{};
    for (final i in cluster) {
      final start = intervals[i].$1;
      var col = columnEnds.indexWhere((end) => end <= start);
      if (col < 0) {
        col = columnEnds.length;
        columnEnds.add(0);
      }
      columnEnds[col] = endOf(i);
      columnOf[i] = col;
      members.putIfAbsent(col, () => []).add(i);
    }
    final columns = columnEnds.length;
    for (final i in cluster) {
      final start = intervals[i].$1;
      final end = endOf(i);
      var span = 1;
      for (var c = columnOf[i] + 1; c < columns; c++) {
        final blocked = members[c]!.any(
          (j) => intervals[j].$1 < end && endOf(j) > start,
        );
        if (blocked) break;
        span++;
      }
      result[i] = ColumnPlacement(columnOf[i], columns, span);
    }
    cluster = [];
  }

  for (final i in order) {
    if (cluster.isNotEmpty && intervals[i].$1 >= clusterEnd) finish();
    final end = endOf(i);
    if (cluster.isEmpty || end > clusterEnd) clusterEnd = end;
    cluster.add(i);
  }
  finish();
  return result;
}

// ------------------------------------------------ Lanes (Monat/ganztägig)

/// Ergebnis von [layoutRowLanes].
class RowLanes {
  const RowLanes({
    required this.lanes,
    required this.visible,
    required this.hiddenPerColumn,
  });

  /// Lane (Zeile) je Eintrag, Eingabereihenfolge.
  final List<int> lanes;

  /// Sichtbar? Sonst steckt der Eintrag in „+N weitere“.
  final List<bool> visible;

  /// Anzahl ausgeblendeter Einträge je Spalte (Tag).
  final List<int> hiddenPerColumn;

  /// Belegte Lanes (sichtbar).
  int get usedLanes {
    var max = 0;
    for (var i = 0; i < lanes.length; i++) {
      if (visible[i] && lanes[i] + 1 > max) max = lanes[i] + 1;
    }
    return max;
  }
}

/// Verteilt Einträge einer Wochenzeile ([spans]: erste/letzte Spalte,
/// inklusive) auf Lanes — in der gegebenen Reihenfolge (ganztägige zuerst,
/// dann nach Uhrzeit). Passen in eine Spalte mehr als [maxLanes] Einträge,
/// bleibt die letzte Lane für „+N weitere“ frei. Ein mehrtägiger Balken ist
/// nur sichtbar, wenn er in allen seinen Spalten Platz hat.
RowLanes layoutRowLanes(
  List<(int, int)> spans, {
  required int maxLanes,
  int columns = 7,
}) {
  final taken = List.generate(columns, (_) => <int>{});
  final lanes = <int>[];
  for (final (from, to) in spans) {
    var lane = 0;
    while (true) {
      var free = true;
      for (var c = from; c <= to; c++) {
        if (taken[c].contains(lane)) {
          free = false;
          break;
        }
      }
      if (free) break;
      lane++;
    }
    for (var c = from; c <= to; c++) {
      taken[c].add(lane);
    }
    lanes.add(lane);
  }
  final max = maxLanes < 1 ? 1 : maxLanes;
  // Spalten, die überlaufen, reservieren die letzte Lane für „+N“.
  final limit = [
    for (var c = 0; c < columns; c++)
      taken[c].any((l) => l >= max) ? max - 1 : max,
  ];
  final visible = <bool>[];
  final hidden = List<int>.filled(columns, 0);
  for (var i = 0; i < spans.length; i++) {
    final (from, to) = spans[i];
    var fits = true;
    for (var c = from; c <= to; c++) {
      if (lanes[i] >= limit[c]) fits = false;
    }
    visible.add(fits);
    if (!fits) {
      for (var c = from; c <= to; c++) {
        hidden[c]++;
      }
    }
  }
  return RowLanes(lanes: lanes, visible: visible, hiddenPerColumn: hidden);
}
