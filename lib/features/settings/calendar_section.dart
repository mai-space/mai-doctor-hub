import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/settings_repository.dart';
import '../../l10n/l10n.dart';
import '../../services/calendar/calendar_gateway.dart';
import '../../services/calendar/calendar_sync_service.dart';
import '../calendar/calendar_layout.dart';

/// Einstellungen → Kalender-Export (einseitig, z. B. Google Kalender).
class CalendarSection extends StatefulWidget {
  const CalendarSection({super.key, required this.settings, this.gateway});

  final AppSetting settings;

  /// Für Tests austauschbar.
  final CalendarGateway? gateway;

  @override
  State<CalendarSection> createState() => _CalendarSectionState();
}

class _CalendarSectionState extends State<CalendarSection> {
  late final CalendarGateway _gateway =
      widget.gateway ?? AndroidCalendarGateway();
  List<DeviceCalendar>? _calendars;
  bool _busy = false;

  AppSetting get _s => widget.settings;

  @override
  void initState() {
    super.initState();
    if (_s.calendarSyncEnabled) _loadCalendars(request: false);
  }

  Future<void> _loadCalendars({required bool request}) async {
    if (!_gateway.isSupported) return;
    final granted = request
        ? await _gateway.requestPermission()
        : await _gateway.hasPermission();
    if (!granted) return;
    final calendars = await _gateway.listCalendars();
    if (mounted) setState(() => _calendars = calendars);
  }

  Future<void> _save({bool? enabled, String? calendarId, bool? includeTitle}) {
    return SettingsRepository(DatabaseScope.of(context)).updateCalendarExport(
      enabled: enabled ?? _s.calendarSyncEnabled,
      calendarId: calendarId ?? _s.calendarId,
      includeTitle: includeTitle ?? _s.calendarIncludeTitle,
    );
  }

  CalendarSyncService _service() =>
      CalendarSyncService(DatabaseScope.of(context), _gateway);

  Future<void> _toggle(bool enabled) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    if (enabled) {
      await _loadCalendars(request: true);
      if (_calendars == null) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.settingsCalendarNoPermission)),
        );
        return;
      }
      if (_calendars!.isEmpty) {
        messenger.showSnackBar(
          SnackBar(content: Text(l10n.settingsCalendarNoWritable)),
        );
        return;
      }
      final preferred = _calendars!.firstWhere(
        (c) => c.id == _s.calendarId,
        orElse: () => _calendars!.firstWhere(
          (c) => c.isGoogle && c.isPrimary,
          orElse: () => _calendars!.firstWhere(
            (c) => c.isGoogle,
            orElse: () => _calendars!.first,
          ),
        ),
      );
      await _save(enabled: true, calendarId: preferred.id);
      return;
    }
    final remove = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.settingsCalendarStopTitle),
        content: Text(l10n.settingsCalendarStopText),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.settingsCalendarKeep),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.settingsCalendarRemove),
          ),
        ],
      ),
    );
    if (remove == null) return;
    await _save(enabled: false);
    if (remove) {
      await _run(
        () async => _service().removeAll(),
        count: l10n.settingsCalendarRemovedCount,
        other: l10n.settingsCalendarRemovedResult,
      );
    }
  }

  Future<void> _run(
    Future<Object?> Function() task, {
    required String Function(int count) count,
    required String Function(String result) other,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      final result = await task();
      messenger.showSnackBar(
        SnackBar(
          content: Text(result is int ? count(result) : other('$result')),
        ),
      );
    } on CalendarException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final db = DatabaseScope.of(context);
    final supported = _gateway.isSupported;
    final calendars = _calendars;
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.settingsCalendarSection,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        _WeekStartTile(setting: _s.calendarFirstWeekday),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          secondary: const Icon(Icons.event_available_outlined),
          title: Text(l10n.settingsCalendarExportTitle),
          subtitle: Text(
            supported
                ? l10n.settingsCalendarExportSubtitle
                : l10n.settingsCalendarMobileOnly,
          ),
          value: _s.calendarSyncEnabled,
          onChanged: !supported || _busy ? null : _toggle,
        ),
        if (_s.calendarSyncEnabled) ...[
          if (calendars != null)
            DropdownMenu<String>(
              initialSelection: _s.calendarId,
              label: Text(l10n.settingsCalendarTarget),
              expandedInsets: EdgeInsets.zero,
              dropdownMenuEntries: [
                for (final c in calendars)
                  DropdownMenuEntry(
                    value: c.id,
                    label: c.label,
                    leadingIcon: Icon(
                      c.isGoogle ? Icons.cloud_outlined : Icons.phone_android,
                    ),
                  ),
              ],
              onSelected: (id) => _save(calendarId: id),
            )
          else
            TextButton.icon(
              onPressed: () => _loadCalendars(request: true),
              icon: const Icon(Icons.lock_open),
              label: Text(l10n.settingsCalendarAllowAccess),
            ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.settingsCalendarIncludeTitle),
            subtitle: Text(l10n.settingsCalendarIncludeTitleSubtitle),
            value: _s.calendarIncludeTitle,
            onChanged: (v) => _save(includeTitle: v),
          ),
          StreamBuilder<List<CalendarLink>>(
            stream: db.select(db.calendarLinks).watch(),
            builder: (context, snapshot) {
              final links = snapshot.data ?? const <CalendarLink>[];
              final errors = links.where((l) => l.lastError != null).length;
              final last = links
                  .map((l) => l.syncedAt)
                  .whereType<DateTime>()
                  .fold<DateTime?>(
                    null,
                    (a, b) => a == null || b.isAfter(a) ? b : a,
                  );
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  errors > 0 ? Icons.sync_problem : Icons.sync,
                  color: errors > 0 ? theme.colorScheme.error : null,
                ),
                title: Text(
                  errors > 0
                      ? l10n.settingsCalendarLinkedWithErrors(
                          links.length - errors,
                          errors,
                        )
                      : l10n.settingsCalendarLinkedCount(links.length),
                ),
                subtitle: last == null
                    ? null
                    : Text(
                        l10n.settingsCalendarLastSynced(
                          DateFormat(l10n.settingsDateTimePattern).format(last),
                        ),
                      ),
                trailing: TextButton(
                  onPressed: _busy
                      ? null
                      : () => _run(
                          () => _service().syncAll(),
                          count: l10n.settingsCalendarSyncedCount,
                          other: l10n.settingsCalendarSyncedResult,
                        ),
                  child: Text(l10n.settingsCalendarSyncNow),
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}

/// v18: „Woche beginnt am“ — Automatisch (Region), Montag, Sonntag, Samstag.
class _WeekStartTile extends StatelessWidget {
  const _WeekStartTile({required this.setting});

  final int? setting;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final weekdays = DateFormat.EEEE(l10n.localeName);
    // Montag, 5. Januar 2026 → Wochentag nach `DateTime.weekday`.
    String name(int weekday) =>
        weekdays.format(DateTime(2026, 1, 4 + weekday));
    final auto = resolveFirstWeekday(
      null,
      MaterialLocalizations.of(context).firstDayOfWeekIndex,
    );
    // 0 steht im Menü für „automatisch“ (gespeichert: null).
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownMenu<int>(
        key: const ValueKey('calendar-week-start'),
        initialSelection: setting ?? 0,
        label: Text(l10n.calendarWeekStart),
        helperText: l10n.calendarWeekStartSubtitle,
        expandedInsets: EdgeInsets.zero,
        leadingIcon: const Icon(Icons.view_week_outlined),
        dropdownMenuEntries: [
          DropdownMenuEntry(
            value: 0,
            label: l10n.calendarWeekStartAuto(name(auto)),
          ),
          for (final weekday in calendarWeekStartOptions)
            DropdownMenuEntry(value: weekday, label: name(weekday)),
        ],
        onSelected: (value) => SettingsRepository(
          DatabaseScope.of(context),
        ).setCalendarFirstWeekday(value == null || value == 0 ? null : value),
      ),
    );
  }
}
