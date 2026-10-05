import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

enum CalendarViewMode { day, week, month, year }

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarViewMode _mode = CalendarViewMode.month;
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedDay = DateTime(now.year, now.month, now.day);
  }

  void _jumpToToday() {
    final now = DateTime.now();
    setState(() => _focusedDay = DateTime(now.year, now.month, now.day));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                TextButton(onPressed: _jumpToToday, child: const Text('Heute')),
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
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _mode == CalendarViewMode.month
                  ? _MonthGrid(focusedDay: _focusedDay)
                  : Center(
                      child: Text(
                        '${_modeLabel(_mode)}-Ansicht — Termine folgen',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: AppColors.muted,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  String _modeLabel(CalendarViewMode mode) => switch (mode) {
    CalendarViewMode.day => 'Tag',
    CalendarViewMode.week => 'Woche',
    CalendarViewMode.month => 'Monat',
    CalendarViewMode.year => 'Jahr',
  };
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({required this.focusedDay});

  final DateTime focusedDay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final firstOfMonth = DateTime(focusedDay.year, focusedDay.month);
    final daysInMonth = DateTime(focusedDay.year, focusedDay.month + 1, 0).day;
    final startWeekday = firstOfMonth.weekday % 7; // Sunday-aligned grid

    final cells = <Widget>[
      for (final label in const ['So', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa'])
        Center(
          child: Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(color: AppColors.muted),
          ),
        ),
      for (var i = 0; i < startWeekday; i++) const SizedBox.shrink(),
      for (var day = 1; day <= daysInMonth; day++)
        Center(
          child: Text(
            '$day',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: day == focusedDay.day
                  ? FontWeight.w700
                  : FontWeight.w400,
              color: day == focusedDay.day
                  ? theme.colorScheme.primary
                  : AppColors.ink,
            ),
          ),
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _monthTitle(focusedDay),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: GridView.count(
            crossAxisCount: 7,
            children: cells,
          ),
        ),
      ],
    );
  }

  String _monthTitle(DateTime day) {
    const months = [
      'Januar',
      'Februar',
      'März',
      'April',
      'Mai',
      'Juni',
      'Juli',
      'August',
      'September',
      'Oktober',
      'November',
      'Dezember',
    ];
    return '${months[day.month - 1]} ${day.year}';
  }
}
