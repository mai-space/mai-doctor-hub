import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/settings_repository.dart';
import '../../services/calendar/calendar_gateway.dart';
import '../../services/calendar/calendar_sync_service.dart';

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
    if (enabled) {
      await _loadCalendars(request: true);
      if (_calendars == null) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Ohne Kalenderzugriff kein Export.')),
        );
        return;
      }
      if (_calendars!.isEmpty) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Kein beschreibbarer Kalender auf dem Gerät.'),
          ),
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
        title: const Text('Kalender-Export beenden'),
        content: const Text(
          'Sollen die bereits übertragenen Termine aus dem Kalender '
          'entfernt werden?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Behalten'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Entfernen'),
          ),
        ],
      ),
    );
    if (remove == null) return;
    await _save(enabled: false);
    if (remove) await _run(() async => _service().removeAll(), 'entfernt');
  }

  Future<void> _run(Future<Object?> Function() task, String verb) async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      final result = await task();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            result is int
                ? '$result Termin(e) aus dem Kalender $verb.'
                : 'Kalender $verb: $result',
          ),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Kalender',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          secondary: const Icon(Icons.event_available_outlined),
          title: const Text('Termine in Kalender übertragen'),
          subtitle: Text(
            supported
                ? 'Nur in eine Richtung, z. B. in deinen Google Kalender. '
                      'Es wird nur „Arzttermin“, Arzt und Ort übertragen — '
                      'keine Diagnosen oder Notizen.'
                : 'Nur in der Android-App verfügbar.',
          ),
          value: _s.calendarSyncEnabled,
          onChanged: !supported || _busy ? null : _toggle,
        ),
        if (_s.calendarSyncEnabled) ...[
          if (calendars != null)
            DropdownMenu<String>(
              initialSelection: _s.calendarId,
              label: const Text('Zielkalender'),
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
              label: const Text('Kalenderzugriff erlauben'),
            ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Termintitel mit übertragen'),
            subtitle: const Text(
              'Aus: „Arzttermin · Dr. …“. An: z. B. „MRT Knie · Dr. …“.',
            ),
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
                  '${links.length - errors} Termin(e) im Kalender'
                  '${errors > 0 ? ' · $errors Fehler' : ''}',
                ),
                subtitle: last == null
                    ? null
                    : Text(
                        'Zuletzt ${DateFormat('d. MMM, HH:mm', 'de').format(last)}',
                      ),
                trailing: TextButton(
                  onPressed: _busy
                      ? null
                      : () => _run(() => _service().syncAll(), 'abgeglichen'),
                  child: const Text('Jetzt'),
                ),
              );
            },
          ),
        ],
      ],
    );
  }
}
