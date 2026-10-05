import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/appointment_repository.dart';
import '../../theme/app_theme.dart';
import '../home/appointment_detail_page.dart';

enum CalendarViewMode { day, week, month, year }

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarViewMode _mode = CalendarViewMode.month;
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedDay = DateTime(now.year, now.month, now.day);
    _selectedDay = _focusedDay;
  }

  void _jumpToToday() {
    final now = DateTime.now();
    setState(() {
      _focusedDay = DateTime(now.year, now.month, now.day);
      _selectedDay = _focusedDay;
    });
  }

  void _shift(int amount) {
    setState(() {
      switch (_mode) {
        case CalendarViewMode.day:
          _focusedDay = _focusedDay.add(Duration(days: amount));
          _selectedDay = _focusedDay;
        case CalendarViewMode.week:
          _focusedDay = _focusedDay.add(Duration(days: 7 * amount));
          _selectedDay = _focusedDay;
        case CalendarViewMode.month:
          _focusedDay = DateTime(
            _focusedDay.year,
            _focusedDay.month + amount,
            1,
          );
        case CalendarViewMode.year:
          _focusedDay = DateTime(_focusedDay.year + amount, 1, 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final db = DatabaseScope.of(context);
    final repo = AppointmentRepository(db);

    final range = _rangeForMode(_mode, _focusedDay);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Kalender',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Zurück',
                  onPressed: () => _shift(-1),
                  icon: const Icon(Icons.chevron_left),
                ),
                TextButton(onPressed: _jumpToToday, child: const Text('Heute')),
                IconButton(
                  tooltip: 'Vor',
                  onPressed: () => _shift(1),
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SegmentedButton<CalendarViewMode>(
              segments: const [
                ButtonSegment(value: CalendarViewMode.day, label: Text('Tag')),
                ButtonSegment(
                  value: CalendarViewMode.week,
                  label: Text('Woche'),
                ),
                ButtonSegment(
                  value: CalendarViewMode.month,
                  label: Text('Monat'),
                ),
                ButtonSegment(
                  value: CalendarViewMode.year,
                  label: Text('Jahr'),
                ),
              ],
              selected: {_mode},
              onSelectionChanged: (value) {
                setState(() => _mode = value.first);
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: StreamBuilder<List<Appointment>>(
              stream: repo.watchInRange(range.$1, range.$2),
              builder: (context, snapshot) {
                final appointments = snapshot.data ?? const [];
                final byDay = <DateTime, List<Appointment>>{};
                for (final a in appointments) {
                  final key = DateTime(
                    a.scheduledAt.year,
                    a.scheduledAt.month,
                    a.scheduledAt.day,
                  );
                  byDay.putIfAbsent(key, () => []).add(a);
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: switch (_mode) {
                    CalendarViewMode.month => _MonthGrid(
                      focusedDay: _focusedDay,
                      selectedDay: _selectedDay,
                      markers: byDay.keys.toSet(),
                      onSelect: (day) => setState(() {
                        _selectedDay = day;
                        _focusedDay = day;
                      }),
                    ),
                    CalendarViewMode.week => _WeekView(
                      focusedDay: _focusedDay,
                      selectedDay: _selectedDay,
                      markers: byDay.keys.toSet(),
                      onSelect: (day) => setState(() {
                        _selectedDay = day;
                        _focusedDay = day;
                      }),
                    ),
                    CalendarViewMode.year => _YearView(
                      year: _focusedDay.year,
                      markers: byDay.keys.toSet(),
                      onSelectMonth: (month) {
                        setState(() {
                          _focusedDay = DateTime(_focusedDay.year, month, 1);
                          _mode = CalendarViewMode.month;
                        });
                      },
                    ),
                    CalendarViewMode.day => const SizedBox.shrink(),
                  },
                );
              },
            ),
          ),
          if (_mode != CalendarViewMode.year)
            SizedBox(
              height: 180,
              child: _DayAppointmentList(
                day: _selectedDay ?? _focusedDay,
                repo: repo,
              ),
            ),
        ],
      ),
    );
  }

  (DateTime, DateTime) _rangeForMode(CalendarViewMode mode, DateTime focus) {
    switch (mode) {
      case CalendarViewMode.day:
        final start = DateTime(focus.year, focus.month, focus.day);
        return (start, start.add(const Duration(days: 1)));
      case CalendarViewMode.week:
        final start = focus.subtract(Duration(days: focus.weekday % 7));
        final weekStart = DateTime(start.year, start.month, start.day);
        return (weekStart, weekStart.add(const Duration(days: 7)));
      case CalendarViewMode.month:
        final start = DateTime(focus.year, focus.month, 1);
        return (start, DateTime(focus.year, focus.month + 1, 1));
      case CalendarViewMode.year:
        final start = DateTime(focus.year, 1, 1);
        return (start, DateTime(focus.year + 1, 1, 1));
    }
  }
}

class _DayAppointmentList extends StatelessWidget {
  const _DayAppointmentList({required this.day, required this.repo});

  final DateTime day;
  final AppointmentRepository repo;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Appointment>>(
      future: repo.forDay(day),
      builder: (context, snapshot) {
        final items = snapshot.data ?? const [];
        final title = DateFormat('EEEE, d. MMMM', 'de').format(day);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              child: items.isEmpty
                  ? Center(
                      child: Text(
                        'Keine Termine an diesem Tag',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.muted,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final a = items[index];
                        return ListTile(
                          leading: const Icon(Icons.event),
                          title: Text(a.title ?? 'Termin'),
                          subtitle: Text(
                            DateFormat('HH:mm').format(a.scheduledAt),
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => AppointmentDetailPage(
                                  appointmentId: a.id,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.focusedDay,
    required this.selectedDay,
    required this.markers,
    required this.onSelect,
  });

  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Set<DateTime> markers;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final firstOfMonth = DateTime(focusedDay.year, focusedDay.month);
    final daysInMonth = DateTime(focusedDay.year, focusedDay.month + 1, 0).day;
    final startWeekday = firstOfMonth.weekday % 7;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('MMMM yyyy', 'de').format(focusedDay),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: GridView.count(
            crossAxisCount: 7,
            children: [
              for (final label in const [
                'So',
                'Mo',
                'Di',
                'Mi',
                'Do',
                'Fr',
                'Sa',
              ])
                Center(
                  child: Text(
                    label,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.muted,
                    ),
                  ),
                ),
              for (var i = 0; i < startWeekday; i++) const SizedBox.shrink(),
              for (var day = 1; day <= daysInMonth; day++)
                _DayCell(
                  day: DateTime(focusedDay.year, focusedDay.month, day),
                  selected: selectedDay,
                  hasMarker: markers.contains(
                    DateTime(focusedDay.year, focusedDay.month, day),
                  ),
                  onSelect: onSelect,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WeekView extends StatelessWidget {
  const _WeekView({
    required this.focusedDay,
    required this.selectedDay,
    required this.markers,
    required this.onSelect,
  });

  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Set<DateTime> markers;
  final ValueChanged<DateTime> onSelect;

  @override
  Widget build(BuildContext context) {
    final start = focusedDay.subtract(Duration(days: focusedDay.weekday % 7));
    final days = List.generate(
      7,
      (i) => DateTime(start.year, start.month, start.day + i),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Woche ab ${DateFormat('d. MMM', 'de').format(days.first)}',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Row(
            children: [
              for (final day in days)
                Expanded(
                  child: _DayCell(
                    day: day,
                    selected: selectedDay,
                    hasMarker: markers.contains(day),
                    onSelect: onSelect,
                    showWeekday: true,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _YearView extends StatelessWidget {
  const _YearView({
    required this.year,
    required this.markers,
    required this.onSelectMonth,
  });

  final int year;
  final Set<DateTime> markers;
  final ValueChanged<int> onSelectMonth;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$year',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 1.4,
            children: [
              for (var month = 1; month <= 12; month++)
                InkWell(
                  onTap: () => onSelectMonth(month),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    margin: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat(
                            'MMM',
                            'de',
                          ).format(DateTime(year, month)),
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${markers.where((d) => d.year == year && d.month == month).length} Termine',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: AppColors.muted),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.selected,
    required this.hasMarker,
    required this.onSelect,
    this.showWeekday = false,
  });

  final DateTime day;
  final DateTime? selected;
  final bool hasMarker;
  final ValueChanged<DateTime> onSelect;
  final bool showWeekday;

  @override
  Widget build(BuildContext context) {
    final isSelected =
        selected != null &&
        selected!.year == day.year &&
        selected!.month == day.month &&
        selected!.day == day.day;
    final isToday = DateUtils.isSameDay(day, DateTime.now());

    return InkWell(
      onTap: () => onSelect(day),
      borderRadius: BorderRadius.circular(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (showWeekday)
            Text(
              DateFormat('E', 'de').format(day),
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: AppColors.muted),
            ),
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : isToday
                  ? Theme.of(context).colorScheme.primaryContainer
                  : null,
            ),
            child: Text(
              '${day.day}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: isSelected || isToday
                    ? FontWeight.w700
                    : FontWeight.w400,
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimary
                    : AppColors.ink,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: hasMarker
                  ? Theme.of(context).colorScheme.tertiary
                  : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
