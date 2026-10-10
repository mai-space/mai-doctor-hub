import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/app_database.dart';
import '../../data/repositories/appointment_repository.dart';
import '../../l10n/l10n.dart';
import '../../theme/app_theme.dart';
import '../cycle/cycle_page.dart';
import '../home/appointment_detail_page.dart';
import '../records/detail_pages.dart' show VaccinationDetailPage;
import 'calendar_events.dart';
import 'calendar_layout.dart';

// ------------------------------------------------------------- Gemeinsam

/// Farben eines Eintrags: Termine nach Status, sonst nach Herkunft.
class CalendarEventStyle {
  const CalendarEventStyle(this.color, {this.tinted = false});

  /// Akzentfarbe (Punkt, Rand, Balken).
  final Color color;

  /// Geschätzte Einträge nur getönt statt voll gefüllt.
  final bool tinted;

  Color get background => tinted ? color.withValues(alpha: 0.16) : color;
  Color get foreground => tinted ? AppColors.ink : Colors.white;

  static CalendarEventStyle of(CalendarEvent e, ColorScheme scheme) =>
      switch (e.kind) {
        CalendarEventKind.appointment => switch (e.status) {
          AppointmentStatus.done => CalendarEventStyle(scheme.tertiary),
          AppointmentStatus.cancelled => CalendarEventStyle(
            scheme.outline,
            tinted: true,
          ),
          _ => CalendarEventStyle(scheme.primary),
        },
        CalendarEventKind.vaccination => const CalendarEventStyle(
          AppColors.accent,
        ),
        CalendarEventKind.period => const CalendarEventStyle(AppColors.danger),
        CalendarEventKind.periodExpected => const CalendarEventStyle(
          AppColors.danger,
          tinted: true,
        ),
        CalendarEventKind.fertile => CalendarEventStyle(
          scheme.secondary,
          tinted: true,
        ),
      };
}

final _time = DateFormat('HH:mm');

bool _cancelled(CalendarEvent e) => e.status == AppointmentStatus.cancelled;

/// Zeitangabe eines Eintrags („09:30–10:00“ bzw. „ganztägig“).
String calendarEventTime(CalendarEvent e, AppLocalizations l10n) => e.allDay
    ? l10n.calendarAllDay
    : '${_time.format(e.start)}–${_time.format(e.end)}';

/// Vorlesetext: Zeit, Titel, Arzt, Status.
String calendarEventSemantics(CalendarEvent e, AppLocalizations l10n) => [
  calendarEventTime(e, l10n),
  e.title,
  ?e.subtitle,
  if (e.status != null) appointmentStatusLabel(e.status!),
].join(', ');

/// Öffnet die passende Detailseite.
void openCalendarEvent(BuildContext context, CalendarEvent e) {
  final page = switch (e.kind) {
    CalendarEventKind.appointment => AppointmentDetailPage(appointmentId: e.id),
    CalendarEventKind.vaccination => VaccinationDetailPage(vaccinationId: e.id),
    _ => const CyclePage(initialTab: 1),
  };
  Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
}

/// Eintrag als Listenzeile (Liste, „+N weitere“).
class CalendarEventTile extends StatelessWidget {
  const CalendarEventTile({super.key, required this.event});

  final CalendarEvent event;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final e = event;
    final style = CalendarEventStyle.of(e, Theme.of(context).colorScheme);
    return Semantics(
      button: true,
      label: calendarEventSemantics(e, l10n),
      excludeSemantics: true,
      child: ListTile(
        key: ValueKey('calendar-tile-${e.kind.name}-${e.id}'),
        leading: SizedBox(
          width: 64,
          child: Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: style.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    e.allDay ? l10n.calendarAllDay : _time.format(e.start),
                    style: Theme.of(context).textTheme.labelMedium,
                    maxLines: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
        title: Text(
          e.title,
          style: _cancelled(e)
              ? const TextStyle(decoration: TextDecoration.lineThrough)
              : null,
        ),
        subtitle: Text(
          [
            if (!e.allDay) calendarEventTime(e, l10n),
            ?e.subtitle,
            if (e.status != null) appointmentStatusLabel(e.status!),
          ].join(' · '),
        ),
        onTap: () => openCalendarEvent(context, e),
      ),
    );
  }
}

/// „+N weitere“: alle Einträge eines Tages im Bottom Sheet.
Future<void> showCalendarDaySheet(
  BuildContext context,
  DateTime day,
  List<CalendarEvent> events,
) {
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) {
      final l10n = context.l10n;
      final items = events.where((e) => e.coversDay(day)).toList();
      return SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: Semantics(
                  header: true,
                  child: Text(
                    DateFormat(l10n.calendarDayHeaderPattern).format(day),
                    style: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              if (items.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(l10n.homeCalendarNoAppointmentsOnDay),
                )
              else
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        for (final e in items) CalendarEventTile(event: e),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    },
  );
}

/// Kompakter Eintrag im Monat bzw. in der Ganztags-Zeile: ganztägig als
/// gefüllter Balken, Termine als Punkt + Uhrzeit + Titel (wie FullCalendar).
class _EventChip extends StatelessWidget {
  const _EventChip({required this.event, this.showTime = true});

  final CalendarEvent event;

  /// Schmale Spalten (Telefon): nur Titel, Uhrzeit steht im Vorlesetext.
  final bool showTime;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final e = event;
    final theme = Theme.of(context);
    final style = CalendarEventStyle.of(e, theme.colorScheme);
    final text = theme.textTheme.labelSmall!.copyWith(
      fontSize: 10,
      height: 1.2,
      decoration: _cancelled(e) ? TextDecoration.lineThrough : null,
    );
    final Widget body;
    if (e.allDay) {
      body = Container(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: style.background,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          e.title,
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.fade,
          style: text.copyWith(color: style.foreground),
        ),
      );
    } else {
      body = Row(
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(left: 2, right: 2),
            decoration: BoxDecoration(
              color: style.color,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              showTime ? '${_time.format(e.start)} ${e.title}' : e.title,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.fade,
              style: text.copyWith(color: AppColors.ink),
            ),
          ),
        ],
      );
    }
    return Semantics(
      button: true,
      label: calendarEventSemantics(e, l10n),
      excludeSemantics: true,
      child: InkWell(
        key: ValueKey('calendar-chip-${e.kind.name}-${e.id}'),
        borderRadius: BorderRadius.circular(4),
        onTap: () => openCalendarEvent(context, e),
        child: body,
      ),
    );
  }
}

class _MoreLink extends StatelessWidget {
  const _MoreLink({super.key, required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = context.l10n.calendarMore(count);
    return Semantics(
      button: true,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        borderRadius: BorderRadius.circular(4),
        onTap: onTap,
        child: Align(
          alignment: Alignment.centerLeft,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Einträge einer Zeile (Woche) in Lanes: ganztägige Balken über mehrere
/// Spalten, Termine in ihrer Spalte, Überlauf als „+N weitere“.
class _LaneLayer extends StatelessWidget {
  const _LaneLayer({
    required this.days,
    required this.events,
    required this.maxLanes,
    required this.columnWidth,
    required this.top,
    required this.laneHeight,
    required this.allEvents,
  });

  final List<DateTime> days;
  final List<CalendarEvent> events;
  final List<CalendarEvent> allEvents;
  final int maxLanes;
  final double columnWidth;
  final double top;
  final double laneHeight;

  @override
  Widget build(BuildContext context) {
    final first = days.first;
    final last = days.last;
    final items = [
      for (final e in events)
        if (!e.lastDay.isBefore(first) && !e.firstDay.isAfter(last)) e,
    ];
    final spans = [
      for (final e in items)
        (
          daysBetween(first, e.firstDay).clamp(0, days.length - 1),
          daysBetween(first, e.lastDay).clamp(0, days.length - 1),
        ),
    ];
    final lanes = layoutRowLanes(
      spans,
      maxLanes: maxLanes,
      columns: days.length,
    );
    return Stack(
      clipBehavior: Clip.hardEdge,
      children: [
        for (var i = 0; i < items.length; i++)
          if (lanes.visible[i])
            Positioned(
              left: spans[i].$1 * columnWidth + 2,
              width: (spans[i].$2 - spans[i].$1 + 1) * columnWidth - 4,
              top: top + lanes.lanes[i] * laneHeight,
              height: laneHeight - 2,
              child: _EventChip(event: items[i], showTime: columnWidth >= 64),
            ),
        for (var c = 0; c < days.length; c++)
          if (lanes.hiddenPerColumn[c] > 0)
            Positioned(
              left: c * columnWidth + 1,
              width: columnWidth - 2,
              top: top + (maxLanes - 1) * laneHeight,
              height: laneHeight - 2,
              child: _MoreLink(
                key: ValueKey('calendar-more-${dayKeyOf(days[c])}'),
                count: lanes.hiddenPerColumn[c],
                onTap: () => showCalendarDaySheet(context, days[c], allEvents),
              ),
            ),
      ],
    );
  }
}

/// `yyyy-MM-dd` für Test-Schlüssel.
String dayKeyOf(DateTime day) =>
    '${day.year.toString().padLeft(4, '0')}-'
    '${day.month.toString().padLeft(2, '0')}-'
    '${day.day.toString().padLeft(2, '0')}';

// ----------------------------------------------------------------- Monat

/// Monatsraster (dayGridMonth): 6 Wochen, Tage außerhalb des Monats
/// gedimmt, heute hervorgehoben, bis zu 2–3 Einträge je Tag.
class CalendarMonthView extends StatelessWidget {
  const CalendarMonthView({
    super.key,
    required this.month,
    required this.firstWeekday,
    required this.events,
    required this.today,
    required this.onDayTap,
    required this.onCreate,
  });

  final DateTime month;
  final int firstWeekday;
  final List<CalendarEvent> events;
  final DateTime today;
  final ValueChanged<DateTime> onDayTap;
  final ValueChanged<DateTime> onCreate;

  static const _laneHeight = 17.0;
  static const _dayHeader = 22.0;

  bool get _weekNumbers => firstWeekday == DateTime.monday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final days = monthGridDays(month, firstWeekday);
    final weekdayFormat = DateFormat('ccc');
    final muted = theme.textTheme.labelSmall?.copyWith(color: AppColors.muted);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExcludeSemantics(
          child: Row(
            children: [
              if (_weekNumbers)
                SizedBox(
                  width: 26,
                  child: Text(
                    l10n.calendarWeekNumberShort,
                    textAlign: TextAlign.center,
                    style: muted,
                  ),
                ),
              for (var i = 0; i < 7; i++)
                Expanded(
                  child: Text(
                    weekdayFormat.format(days[i]),
                    key: i == 0
                        ? const ValueKey('calendar-first-weekday')
                        : null,
                    textAlign: TextAlign.center,
                    style: muted,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: Column(
            children: [
              for (var row = 0; row < 6; row++)
                Expanded(
                  child: _weekRow(context, days.sublist(row * 7, row * 7 + 7)),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _weekRow(BuildContext context, List<DateTime> week) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final dateFormat = DateFormat(l10n.calendarDayHeaderPattern);
    final kw = isoWeekNumber(week.first);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_weekNumbers)
          SizedBox(
            width: 26,
            child: Semantics(
              label: l10n.calendarWeekNumberSemantics(kw),
              excludeSemantics: true,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  '$kw',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.muted,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, box) {
              final columnWidth = box.maxWidth / 7;
              final maxLanes = ((box.maxHeight - _dayHeader - 2) / _laneHeight)
                  .floor()
                  .clamp(1, 3);
              return Stack(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final day in week)
                        Expanded(
                          child: _MonthDayCell(
                            day: day,
                            inMonth: day.month == month.month,
                            isToday: isSameDay(day, today),
                            label: [
                              dateFormat.format(day),
                              if (isSameDay(day, today)) l10n.commonToday,
                              l10n.calendarEventCount(
                                events.where((e) => e.coversDay(day)).length,
                              ),
                            ].join(', '),
                            onTap: () => onDayTap(day),
                            onLongPress: () => onCreate(
                              DateTime(day.year, day.month, day.day, 9),
                            ),
                          ),
                        ),
                    ],
                  ),
                  Positioned.fill(
                    child: _LaneLayer(
                      days: week,
                      events: events,
                      allEvents: events,
                      maxLanes: maxLanes,
                      columnWidth: columnWidth,
                      top: _dayHeader,
                      laneHeight: _laneHeight,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MonthDayCell extends StatelessWidget {
  const _MonthDayCell({
    required this.day,
    required this.inMonth,
    required this.isToday,
    required this.label,
    required this.onTap,
    required this.onLongPress,
  });

  final DateTime day;
  final bool inMonth;
  final bool isToday;
  final String label;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Semantics(
      key: ValueKey('calendar-day-${dayKeyOf(day)}'),
      button: true,
      label: label,
      onLongPressHint: context.l10n.calendarCreateHint,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          decoration: BoxDecoration(
            color: isToday
                ? scheme.primaryContainer.withValues(alpha: 0.35)
                : inMonth
                ? null
                : scheme.surfaceContainerHighest.withValues(alpha: 0.35),
            border: Border(
              top: BorderSide(color: scheme.outlineVariant, width: 0.5),
              left: BorderSide(color: scheme.outlineVariant, width: 0.5),
            ),
          ),
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(top: 2),
          child: Container(
            width: 20,
            height: 18,
            alignment: Alignment.center,
            decoration: isToday
                ? BoxDecoration(
                    color: scheme.primary,
                    borderRadius: BorderRadius.circular(9),
                  )
                : null,
            child: Text(
              '${day.day}',
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                color: isToday
                    ? scheme.onPrimary
                    : inMonth
                    ? AppColors.ink
                    : AppColors.muted.withValues(alpha: 0.6),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------- Woche / Tag (Zeit)

/// Zeitraster (timeGridWeek/timeGridDay): Ganztags-Zeile oben, Termine nach
/// Beginn und Dauer, Überlappungen nebeneinander, rote Jetzt-Linie.
class CalendarTimeGrid extends StatefulWidget {
  const CalendarTimeGrid({
    super.key,
    required this.days,
    required this.events,
    required this.onCreate,
    this.onDayTap,
  });

  final List<DateTime> days;
  final List<CalendarEvent> events;
  final ValueChanged<DateTime> onCreate;
  final ValueChanged<DateTime>? onDayTap;

  /// Höhe einer Stunde in logischen Pixeln.
  static const hourHeight = 48.0;

  /// Mindesthöhe eines Termins (kurze Termine bleiben antippbar).
  static const minEventHeight = 20.0;

  @override
  State<CalendarTimeGrid> createState() => _CalendarTimeGridState();
}

class _CalendarTimeGridState extends State<CalendarTimeGrid> {
  final _scroll = ScrollController();
  Timer? _ticker;
  DateTime _now = DateTime.now();

  static const _gutter = 44.0;
  static const _laneHeight = 18.0;

  List<CalendarEvent> get _timed =>
      widget.events.where((e) => !e.allDay).toList();

  (int, int) get _hours => visibleHourRange([
    for (final e in _timed)
      if (widget.days.any((d) => isSameDay(d, e.start)))
        (minuteOfDay(e.start), minuteOfDay(e.start) + e.durationMinutes),
  ]);

  @override
  void initState() {
    super.initState();
    if (widget.days.any((d) => isSameDay(d, _now))) {
      // Jetzt-Linie minütlich nachführen (nur, wenn heute sichtbar ist).
      _ticker = Timer.periodic(const Duration(minutes: 1), (_) {
        if (mounted) setState(() => _now = DateTime.now());
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      final (start, _) = _hours;
      final minute = initialScrollMinute([
        for (final e in _timed)
          if (widget.days.any((d) => isSameDay(d, e.start)))
            minuteOfDay(e.start),
      ], rangeStart: start * 60);
      final offset = (minute - start * 60) / 60 * CalendarTimeGrid.hourHeight;
      _scroll.jumpTo(offset.clamp(0.0, _scroll.position.maxScrollExtent));
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = context.l10n;
    final days = widget.days;
    final (startHour, endHour) = _hours;
    final hh = CalendarTimeGrid.hourHeight;
    final allDay = [
      for (final e in widget.events)
        if (e.allDay &&
            !e.lastDay.isBefore(days.first) &&
            !e.firstDay.isAfter(days.last))
          e,
    ];
    final muted = theme.textTheme.labelSmall?.copyWith(color: AppColors.muted);

    final header = Row(
      children: [
        const SizedBox(width: _gutter),
        for (final day in days) Expanded(child: _dayHeader(context, day)),
      ],
    );

    Widget? allDayRow;
    if (allDay.isNotEmpty) {
      final spans = [
        for (final e in allDay)
          (
            daysBetween(days.first, e.firstDay).clamp(0, days.length - 1),
            daysBetween(days.first, e.lastDay).clamp(0, days.length - 1),
          ),
      ];
      final used = layoutRowLanes(spans, maxLanes: 3, columns: days.length);
      final lanes = used.hiddenPerColumn.any((h) => h > 0)
          ? 3
          : used.usedLanes.clamp(1, 3);
      allDayRow = SizedBox(
        height: lanes * _laneHeight + 4,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: _gutter,
              child: Padding(
                padding: const EdgeInsets.only(top: 3, right: 4),
                child: Text(
                  l10n.calendarAllDay,
                  textAlign: TextAlign.right,
                  style: muted?.copyWith(fontSize: 9),
                ),
              ),
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, box) => _LaneLayer(
                  days: days,
                  events: allDay,
                  allEvents: widget.events,
                  maxLanes: 3,
                  columnWidth: box.maxWidth / days.length,
                  top: 2,
                  laneHeight: _laneHeight,
                ),
              ),
            ),
          ],
        ),
      );
    }

    final hours = endHour - startHour;
    final body = SingleChildScrollView(
      controller: _scroll,
      child: SizedBox(
        height: hours * hh,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: _gutter,
              child: ExcludeSemantics(
                child: Stack(
                  children: [
                    for (var h = startHour; h < endHour; h++)
                      Positioned(
                        top: (h - startHour) * hh + 2,
                        right: 6,
                        child: Text(
                          '${h.toString().padLeft(2, '0')}:00',
                          style: muted?.copyWith(fontSize: 10),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            for (final day in days)
              Expanded(child: _dayColumn(context, day, startHour, endHour)),
          ],
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        header,
        ?allDayRow,
        Divider(height: 1, color: scheme.outlineVariant),
        Expanded(child: body),
      ],
    );
  }

  Widget _dayHeader(BuildContext context, DateTime day) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final l10n = context.l10n;
    final isToday = isSameDay(day, _now);
    final count = widget.events.where((e) => e.coversDay(day)).length;
    final single = widget.days.length == 1;
    return Semantics(
      button: widget.onDayTap != null,
      label: [
        DateFormat(l10n.calendarDayHeaderPattern).format(day),
        if (isToday) l10n.commonToday,
        l10n.calendarEventCount(count),
      ].join(', '),
      excludeSemantics: true,
      child: InkWell(
        key: ValueKey('calendar-header-${dayKeyOf(day)}'),
        onTap: widget.onDayTap == null ? null : () => widget.onDayTap!(day),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            children: [
              Text(
                DateFormat(single ? 'EEEE' : 'ccc').format(day),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isToday ? scheme.primary : AppColors.muted,
                ),
              ),
              const SizedBox(height: 2),
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: isToday
                    ? BoxDecoration(
                        color: scheme.primary,
                        shape: BoxShape.circle,
                      )
                    : null,
                child: Text(
                  '${day.day}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isToday ? scheme.onPrimary : AppColors.ink,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dayColumn(
    BuildContext context,
    DateTime day,
    int startHour,
    int endHour,
  ) {
    final scheme = Theme.of(context).colorScheme;
    final hh = CalendarTimeGrid.hourHeight;
    final rangeStart = startHour * 60;
    final rangeEnd = endHour * 60;
    final events = [
      for (final e in _timed)
        if (isSameDay(e.start, day)) e,
    ];
    // Für das Packen zählt die sichtbare Höhe (Mindesthöhe kurzer Termine).
    final minMinutes = (CalendarTimeGrid.minEventHeight / hh * 60).ceil();
    final intervals = [
      for (final e in events)
        (
          minuteOfDay(e.start),
          (minuteOfDay(e.start) +
                  (e.durationMinutes < minMinutes
                      ? minMinutes
                      : e.durationMinutes))
              .clamp(0, 1440),
        ),
    ];
    final placements = packColumns(intervals);
    final isToday = isSameDay(day, _now);
    final nowMinute = minuteOfDay(_now);

    return LayoutBuilder(
      builder: (context, box) {
        final width = box.maxWidth;
        return Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned.fill(
              child: Semantics(
                onLongPressHint: context.l10n.calendarCreateHint,
                child: GestureDetector(
                  key: ValueKey('calendar-slots-${dayKeyOf(day)}'),
                  behavior: HitTestBehavior.opaque,
                  onLongPressStart: (details) {
                    final raw = rangeStart + details.localPosition.dy / hh * 60;
                    final minute = (raw ~/ 30) * 30;
                    widget.onCreate(
                      DateTime(day.year, day.month, day.day, 0, minute),
                    );
                  },
                  child: CustomPaint(
                    painter: _HourLinesPainter(
                      hours: endHour - startHour,
                      hourHeight: hh,
                      line: scheme.outlineVariant,
                      today: isToday
                          ? scheme.primaryContainer.withValues(alpha: 0.18)
                          : null,
                    ),
                  ),
                ),
              ),
            ),
            for (var i = 0; i < events.length; i++)
              _positioned(
                events[i],
                placements[i],
                intervals[i],
                width,
                rangeStart,
                rangeEnd,
              ),
            if (isToday && nowMinute >= rangeStart && nowMinute <= rangeEnd)
              Positioned(
                left: 0,
                right: 0,
                top: (nowMinute - rangeStart) / 60 * hh - 4,
                height: 8,
                child: IgnorePointer(
                  child: Semantics(
                    label: '${context.l10n.calendarNow} ${_time.format(_now)}',
                    child: Row(
                      key: const ValueKey('calendar-now'),
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Container(height: 2, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _positioned(
    CalendarEvent e,
    ColumnPlacement p,
    (int, int) interval,
    double width,
    int rangeStart,
    int rangeEnd,
  ) {
    final hh = CalendarTimeGrid.hourHeight;
    final start = minuteOfDay(e.start).clamp(rangeStart, rangeEnd);
    final end = (minuteOfDay(e.start) + e.durationMinutes).clamp(
      rangeStart,
      rangeEnd,
    );
    var height = (end - start) / 60 * hh;
    if (height < CalendarTimeGrid.minEventHeight) {
      height = CalendarTimeGrid.minEventHeight;
    }
    final columnWidth = width / p.columns;
    return Positioned(
      top: (start - rangeStart) / 60 * hh,
      height: height,
      left: p.column * columnWidth,
      width: columnWidth * p.span,
      child: _TimedEventBlock(
        key: ValueKey('calendar-event-${e.id}'),
        event: e,
        wide: widget.days.length == 1,
      ),
    );
  }
}

class _HourLinesPainter extends CustomPainter {
  _HourLinesPainter({
    required this.hours,
    required this.hourHeight,
    required this.line,
    this.today,
  });

  final int hours;
  final double hourHeight;
  final Color line;
  final Color? today;

  @override
  void paint(Canvas canvas, Size size) {
    if (today != null) {
      canvas.drawRect(Offset.zero & size, Paint()..color = today!);
    }
    final paint = Paint()
      ..color = line
      ..strokeWidth = 0.5;
    final half = Paint()
      ..color = line.withValues(alpha: 0.4)
      ..strokeWidth = 0.5;
    for (var h = 0; h <= hours; h++) {
      final y = h * hourHeight;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
      if (h < hours) {
        final y2 = y + hourHeight / 2;
        canvas.drawLine(Offset(0, y2), Offset(size.width, y2), half);
      }
    }
    canvas.drawLine(Offset.zero, Offset(0, size.height), paint);
  }

  @override
  bool shouldRepaint(_HourLinesPainter old) =>
      old.hours != hours ||
      old.hourHeight != hourHeight ||
      old.line != line ||
      old.today != today;
}

class _TimedEventBlock extends StatelessWidget {
  const _TimedEventBlock({super.key, required this.event, required this.wide});

  final CalendarEvent event;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final e = event;
    final style = CalendarEventStyle.of(e, theme.colorScheme);
    final text = theme.textTheme.labelSmall!.copyWith(
      color: style.foreground,
      fontSize: wide ? 12 : 10,
      height: 1.15,
      decoration: _cancelled(e) ? TextDecoration.lineThrough : null,
    );
    return Semantics(
      button: true,
      label: calendarEventSemantics(e, l10n),
      excludeSemantics: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(1, 1, 1, 1),
        child: Material(
          color: style.background,
          borderRadius: BorderRadius.circular(4),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => openCalendarEvent(context, e),
            child: Container(
              decoration: style.tinted
                  ? BoxDecoration(
                      border: Border(
                        left: BorderSide(color: style.color, width: 3),
                      ),
                    )
                  : null,
              padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
              alignment: Alignment.topLeft,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: wide
                          ? '${calendarEventTime(e, l10n)}  '
                          : '${_time.format(e.start)}\n',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: e.title),
                    if (e.subtitle != null) TextSpan(text: '\n${e.subtitle}'),
                  ],
                ),
                style: text,
                softWrap: wide,
                overflow: TextOverflow.clip,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------- Liste

/// Liste (listWeek/Agenda): Einträge nach Tagen gruppiert.
class CalendarListView extends StatelessWidget {
  const CalendarListView({
    super.key,
    required this.days,
    required this.events,
    required this.today,
  });

  final List<DateTime> days;
  final List<CalendarEvent> events;
  final DateTime today;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final format = DateFormat(l10n.calendarDayHeaderPattern);
    final children = <Widget>[];
    for (final day in days) {
      final items = events.where((e) => e.coversDay(day)).toList();
      if (items.isEmpty) continue;
      final isToday = isSameDay(day, today);
      children.add(
        Container(
          key: ValueKey('calendar-list-day-${dayKeyOf(day)}'),
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.5,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Semantics(
            header: true,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    format.format(day),
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isToday ? theme.colorScheme.primary : null,
                    ),
                  ),
                ),
                if (isToday)
                  Text(
                    l10n.commonToday,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
      for (final e in items) {
        children.add(CalendarEventTile(event: e));
      }
    }
    if (children.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.calendarListEmpty,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.muted),
          ),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.only(bottom: 24),
      children: children,
    );
  }
}

// ------------------------------------------------------------------ Jahr

/// Jahresübersicht: 12 Mini-Monate (Wochenbeginn wie eingestellt), Tage
/// mit Einträgen markiert; Tippen öffnet den Monat.
class CalendarYearView extends StatelessWidget {
  const CalendarYearView({
    super.key,
    required this.year,
    required this.firstWeekday,
    required this.events,
    required this.today,
    required this.onMonthTap,
  });

  final int year;
  final int firstWeekday;
  final List<CalendarEvent> events;
  final DateTime today;
  final ValueChanged<int> onMonthTap;

  @override
  Widget build(BuildContext context) {
    final busy = <DateTime>{};
    for (final e in events) {
      var d = e.firstDay;
      while (!d.isAfter(e.lastDay)) {
        if (d.year == year) busy.add(d);
        d = addDays(d, 1);
      }
    }
    return LayoutBuilder(
      builder: (context, box) {
        final columns = box.maxWidth >= 600 ? 4 : 3;
        return GridView.count(
          crossAxisCount: columns,
          childAspectRatio: 0.82,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          padding: const EdgeInsets.only(bottom: 16),
          children: [
            for (var month = 1; month <= 12; month++)
              _MiniMonth(
                month: DateTime(year, month),
                firstWeekday: firstWeekday,
                busy: busy,
                today: today,
                count: events
                    .where(
                      (e) =>
                          !e.lastDay.isBefore(DateTime(year, month)) &&
                          e.firstDay.isBefore(DateTime(year, month + 1)),
                    )
                    .length,
                onTap: () => onMonthTap(month),
              ),
          ],
        );
      },
    );
  }
}

class _MiniMonth extends StatelessWidget {
  const _MiniMonth({
    required this.month,
    required this.firstWeekday,
    required this.busy,
    required this.today,
    required this.count,
    required this.onTap,
  });

  final DateTime month;
  final int firstWeekday;
  final Set<DateTime> busy;
  final DateTime today;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final days = monthGridDays(month, firstWeekday);
    final small = theme.textTheme.labelSmall!.copyWith(fontSize: 9, height: 1);
    final name = DateFormat('LLLL').format(month);
    return Semantics(
      key: ValueKey('calendar-year-month-${month.month}'),
      button: true,
      label: '$name ${month.year}, ${context.l10n.calendarEventCount(count)}',
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                name,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: month.year == today.year && month.month == today.month
                      ? scheme.primary
                      : null,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  for (var i = 0; i < 7; i++)
                    Expanded(
                      child: Text(
                        DateFormat('ccccc').format(days[i]),
                        textAlign: TextAlign.center,
                        style: small.copyWith(color: AppColors.muted),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              for (var row = 0; row < 6; row++)
                Expanded(
                  child: Row(
                    children: [
                      for (final day in days.sublist(row * 7, row * 7 + 7))
                        Expanded(child: _miniDay(context, day, small)),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniDay(BuildContext context, DateTime day, TextStyle small) {
    if (day.month != month.month) return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;
    final isToday = isSameDay(day, today);
    final hasEvents = busy.contains(day);
    return Container(
      alignment: Alignment.center,
      decoration: isToday
          ? BoxDecoration(color: scheme.primary, shape: BoxShape.circle)
          : hasEvents
          ? BoxDecoration(
              color: scheme.primaryContainer,
              shape: BoxShape.circle,
            )
          : null,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          '${day.day}',
          style: small.copyWith(
            fontWeight: hasEvents || isToday ? FontWeight.w700 : null,
            color: isToday ? scheme.onPrimary : AppColors.ink,
          ),
        ),
      ),
    );
  }
}
