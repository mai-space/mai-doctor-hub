import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/settings_repository.dart';
import '../../l10n/l10n.dart';
import '../home/add_appointment_sheet.dart';
import 'calendar_events.dart';
import 'calendar_layout.dart';
import 'calendar_views.dart';

/// Ansichten wie bei FullCalendar (neue nur am Ende anhängen).
enum CalendarViewMode { day, week, month, year, list }

/// Kalender: Werkzeugleiste ‹ Heute › mit Titel, Ansichtswahl
/// (Monat/Woche/Tag/Liste/Jahr), Wischen zum Blättern.
class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key, this.initialDate, this.initialView});

  /// Startdatum (Tests); sonst heute.
  final DateTime? initialDate;

  /// Startansicht (Tests); sonst die zuletzt gewählte dieser Sitzung.
  final CalendarViewMode? initialView;

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  /// Zuletzt gewählte Ansicht — gilt für die laufende Sitzung.
  static CalendarViewMode _sessionView = CalendarViewMode.month;

  late CalendarViewMode _mode = widget.initialView ?? _sessionView;
  late DateTime _focus = dateOnly(widget.initialDate ?? DateTime.now());

  Stream<AppSetting>? _settings;
  Stream<List<CalendarEvent>>? _events;
  (DateTime, DateTime)? _eventsRange;

  DateTime get _today => dateOnly(DateTime.now());

  static const _listDays = 30;

  void _setMode(CalendarViewMode mode) {
    setState(() {
      _mode = mode;
      _sessionView = mode;
    });
  }

  void _jumpToToday() => setState(() => _focus = _today);

  void _shift(int amount) {
    setState(() {
      _focus = switch (_mode) {
        CalendarViewMode.day => addDays(_focus, amount),
        CalendarViewMode.week => addDays(_focus, 7 * amount),
        CalendarViewMode.list => addDays(_focus, _listDays * amount),
        CalendarViewMode.month => DateTime(_focus.year, _focus.month + amount),
        CalendarViewMode.year => DateTime(_focus.year + amount),
      };
    });
  }

  void _openDay(DateTime day) {
    setState(() {
      _focus = day;
      _mode = CalendarViewMode.day;
      _sessionView = _mode;
    });
  }

  Future<void> _create(DateTime at) => showAddAppointmentSheet(context, at: at);

  /// Sichtbarer Zeitraum [start, end) der aktuellen Ansicht.
  (DateTime, DateTime) _range(int firstWeekday) {
    switch (_mode) {
      case CalendarViewMode.day:
        return (_focus, addDays(_focus, 1));
      case CalendarViewMode.week:
        final start = startOfWeek(_focus, firstWeekday);
        return (start, addDays(start, 7));
      case CalendarViewMode.list:
        return (_focus, addDays(_focus, _listDays));
      case CalendarViewMode.month:
        final start = monthGridDays(_focus, firstWeekday).first;
        return (start, addDays(start, 42));
      case CalendarViewMode.year:
        return (DateTime(_focus.year), DateTime(_focus.year + 1));
    }
  }

  Stream<List<CalendarEvent>> _eventsFor(
    AppDatabase db,
    (DateTime, DateTime) range,
  ) {
    if (_events == null || _eventsRange != range) {
      _eventsRange = range;
      _events = watchCalendarEvents(db, range.$1, range.$2);
    }
    return _events!;
  }

  @override
  Widget build(BuildContext context) {
    final db = DatabaseScope.of(context);
    _settings ??= SettingsRepository(db).watch();
    final localeIndex = MaterialLocalizations.of(context).firstDayOfWeekIndex;
    return SafeArea(
      child: StreamBuilder<AppSetting>(
        stream: _settings,
        builder: (context, settings) {
          final firstWeekday = resolveFirstWeekday(
            settings.data?.calendarFirstWeekday,
            localeIndex,
          );
          final range = _range(firstWeekday);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _toolbar(context, firstWeekday, range),
              const SizedBox(height: 8),
              Expanded(
                child: GestureDetector(
                  // Wischen nach links/rechts blättert (wie bei FullCalendar
                  // mobil); Pfeile bleiben für Screenreader.
                  onHorizontalDragEnd: (details) {
                    final velocity = details.primaryVelocity ?? 0;
                    if (velocity.abs() < 250) return;
                    _shift(velocity < 0 ? 1 : -1);
                  },
                  child: StreamBuilder<List<CalendarEvent>>(
                    key: ValueKey(('events', range)),
                    stream: _eventsFor(db, range),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const SizedBox.expand();
                      return _view(firstWeekday, range, snapshot.data!);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _view(
    int firstWeekday,
    (DateTime, DateTime) range,
    List<CalendarEvent> events,
  ) {
    final today = _today;
    switch (_mode) {
      case CalendarViewMode.month:
        return Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
          child: CalendarMonthView(
            month: _focus,
            firstWeekday: firstWeekday,
            events: events,
            today: today,
            onDayTap: _openDay,
            onCreate: _create,
          ),
        );
      case CalendarViewMode.week:
      case CalendarViewMode.day:
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: CalendarTimeGrid(
            key: ValueKey(('grid', _mode, range)),
            days: daysInRange(range.$1, range.$2),
            events: events,
            onCreate: _create,
            onDayTap: _mode == CalendarViewMode.week ? _openDay : null,
          ),
        );
      case CalendarViewMode.list:
        return CalendarListView(
          days: daysInRange(range.$1, range.$2),
          events: events,
          today: today,
        );
      case CalendarViewMode.year:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: CalendarYearView(
            year: _focus.year,
            firstWeekday: firstWeekday,
            events: events,
            today: today,
            onMonthTap: (month) => setState(() {
              _focus = DateTime(_focus.year, month);
              _mode = CalendarViewMode.month;
              _sessionView = _mode;
            }),
          ),
        );
    }
  }

  Widget _toolbar(
    BuildContext context,
    int firstWeekday,
    (DateTime, DateTime) range,
  ) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final title = calendarTitle(
      l10n,
      _mode,
      _focus,
      range,
      weekNumbers: firstWeekday == DateTime.monday,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 8, 4),
          child: Row(
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  liveRegion: true,
                  child: Text(
                    title,
                    key: const ValueKey('calendar-title'),
                    // Lange Titel (Woche/Tag/Liste) etwas kleiner.
                    style:
                        (_mode == CalendarViewMode.month ||
                                    _mode == CalendarViewMode.year
                                ? theme.textTheme.titleLarge
                                : theme.textTheme.titleMedium)
                            ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              IconButton(
                tooltip: l10n.calendarPrevious,
                onPressed: () => _shift(-1),
                icon: const Icon(Icons.chevron_left),
              ),
              OutlinedButton(
                onPressed: _jumpToToday,
                style: OutlinedButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  minimumSize: const Size(0, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: Text(l10n.commonToday),
              ),
              IconButton(
                tooltip: l10n.calendarNext,
                onPressed: () => _shift(1),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: SegmentedButton<CalendarViewMode>(
            showSelectedIcon: false,
            style: SegmentedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              tapTargetSize: MaterialTapTargetSize.padded,
            ),
            segments: [
              for (final (mode, label) in [
                (CalendarViewMode.month, l10n.homeCalendarMonth),
                (CalendarViewMode.week, l10n.homeCalendarWeek),
                (CalendarViewMode.day, l10n.homeCalendarDay),
                (CalendarViewMode.list, l10n.calendarViewList),
                (CalendarViewMode.year, l10n.homeCalendarYear),
              ])
                ButtonSegment(
                  value: mode,
                  label: Text(
                    label,
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.fade,
                  ),
                ),
            ],
            selected: {_mode},
            onSelectionChanged: (value) => _setMode(value.first),
          ),
        ),
      ],
    );
  }
}

/// Titel der Werkzeugleiste: „Oktober 2026“, „KW 41 · 5.–11. Okt. 2026“,
/// „Mo., 5. Okt. 2026“, Liste/Woche als Zeitraum, Jahr als Zahl.
String calendarTitle(
  AppLocalizations l10n,
  CalendarViewMode mode,
  DateTime focus,
  (DateTime, DateTime) range, {
  required bool weekNumbers,
}) {
  final lastDay = addDays(range.$2, -1);
  return switch (mode) {
    CalendarViewMode.month => DateFormat.yMMMM().format(focus),
    CalendarViewMode.year => '${focus.year}',
    CalendarViewMode.day => DateFormat(
      l10n.calendarDayTitlePattern,
    ).format(focus),
    CalendarViewMode.list => formatDateRange(l10n, range.$1, lastDay),
    CalendarViewMode.week =>
      weekNumbers
          ? '${l10n.calendarWeekNumber(isoWeekNumber(range.$1))} · '
                '${formatDateRange(l10n, range.$1, lastDay)}'
          : formatDateRange(l10n, range.$1, lastDay),
  };
}

/// Zeitraum kompakt: „5.–11. Okt. 2026“, „28. Sept. – 4. Okt. 2026“,
/// „29. Dez. 2026 – 4. Jan. 2027“ (englisch: „Oct 5–11, 2026“ …).
String formatDateRange(AppLocalizations l10n, DateTime from, DateTime to) {
  final full = DateFormat(l10n.calendarFullDatePattern);
  if (from.year != to.year) return '${full.format(from)} – ${full.format(to)}';
  if (from.month != to.month) {
    return '${DateFormat(l10n.calendarRangeSameYearStartPattern).format(from)}'
        ' – ${full.format(to)}';
  }
  return '${DateFormat(l10n.calendarRangeSameMonthStartPattern).format(from)}'
      '–${DateFormat(l10n.calendarRangeSameMonthEndPattern).format(to)}';
}
