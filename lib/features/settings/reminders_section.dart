import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/reminder_repository.dart';
import '../../data/repositories/symptom_repository.dart';
import '../../l10n/l10n.dart';
import '../../services/notification_service.dart';
import '../check_in/check_in_sheet.dart';
import '../records/entity_forms.dart';

/// Einstellungen → Erinnerungen (beliebig viele Check-in-Erinnerungen).
class RemindersSection extends StatefulWidget {
  const RemindersSection({super.key});

  @override
  State<RemindersSection> createState() => _RemindersSectionState();
}

class _RemindersSectionState extends State<RemindersSection> {
  Stream<List<ReminderWithSymptoms>>? _stream;
  bool? _permitted;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _stream ??= ReminderRepository(DatabaseScope.of(context)).watchAll();
  }

  Future<void> _checkPermission() async {
    final ok = await NotificationPermissions.current.has();
    if (mounted) setState(() => _permitted = ok);
  }

  Future<void> _ensurePermission() async {
    if (_permitted == true) return;
    final ok = await ensureNotificationPermission(context);
    if (mounted) setState(() => _permitted = ok);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = ReminderRepository(DatabaseScope.of(context));
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.settingsRemindersSection,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () async {
                await showReminderForm(context);
                await _ensurePermission();
              },
              icon: const Icon(Icons.add_alarm),
              label: Text(l10n.settingsRemindersNew),
            ),
          ],
        ),
        if (_permitted == false)
          Card(
            elevation: 0,
            color: theme.colorScheme.errorContainer,
            child: ListTile(
              leading: Icon(
                Icons.notifications_off_outlined,
                color: theme.colorScheme.onErrorContainer,
              ),
              title: Text(
                l10n.settingsRemindersNotificationsOff,
                style: TextStyle(color: theme.colorScheme.onErrorContainer),
              ),
              subtitle: Text(
                l10n.settingsRemindersNotificationsOffText,
                style: TextStyle(color: theme.colorScheme.onErrorContainer),
              ),
              trailing: TextButton(
                onPressed: _ensurePermission,
                child: Text(l10n.settingsRemindersAllow),
              ),
            ),
          ),
        StreamBuilder<List<ReminderWithSymptoms>>(
          stream: _stream,
          builder: (context, snapshot) {
            final items = snapshot.data ?? const <ReminderWithSymptoms>[];
            if (items.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  l10n.settingsRemindersEmpty,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }
            return Column(
              children: [
                for (final item in items)
                  _ReminderTile(
                    item: item,
                    onToggle: (v) async {
                      await repo.setEnabled(item.reminder.id, v);
                      if (v) await _ensurePermission();
                    },
                    onTap: () => showReminderForm(context, existing: item),
                  ),
              ],
            );
          },
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => showCheckInSheet(context),
          icon: const Icon(Icons.favorite_outline),
          label: Text(l10n.settingsRemindersOpenCheckIn),
        ),
      ],
    );
  }
}

class _ReminderTile extends StatelessWidget {
  const _ReminderTile({
    required this.item,
    required this.onToggle,
    required this.onTap,
  });

  final ReminderWithSymptoms item;
  final ValueChanged<bool> onToggle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final r = item.reminder;
    final time = TimeOfDay(hour: r.hour, minute: r.minute).format(context);
    final scope = item.symptoms.isEmpty
        ? context.l10n.settingsRemindersAllOpenSymptoms
        : item.symptoms.map((s) => s.label).join(', ');
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      secondary: const Icon(Icons.alarm),
      title: Text('$time · ${r.title}'),
      subtitle: Text('${Weekdays.describe(r.weekdays)} · $scope'),
      value: r.enabled,
      onChanged: onToggle,
      // Tippen auf den Text bearbeitet; der Schalter schaltet.
      controlAffinity: ListTileControlAffinity.trailing,
    ).withTap(onTap);
  }
}

extension on Widget {
  Widget withTap(VoidCallback onTap) =>
      InkWell(onTap: onTap, borderRadius: BorderRadius.circular(12), child: this);
}

/// Erklärt kurz und fragt dann die Benachrichtigungs-Berechtigung an.
Future<bool> ensureNotificationPermission(BuildContext context) async {
  final permissions = NotificationPermissions.current;
  if (await permissions.has()) return true;
  if (!context.mounted) return false;
  final ask = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(Icons.notifications_active_outlined),
      title: Text(context.l10n.settingsRemindersPermissionTitle),
      content: Text(context.l10n.settingsRemindersPermissionText),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(context.l10n.settingsRemindersLater),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(context.l10n.settingsRemindersAllow),
        ),
      ],
    ),
  );
  if (ask != true) return false;
  return permissions.request();
}

/// Anlegen/Bearbeiten einer Erinnerung.
Future<void> showReminderForm(
  BuildContext context, {
  ReminderWithSymptoms? existing,
}) async {
  final db = DatabaseScope.of(context);
  final repo = ReminderRepository(db);
  final symptoms = await SymptomRepository(db).watchAll().first;
  if (!context.mounted) return;

  final r = existing?.reminder;
  final title = TextEditingController(text: r?.title ?? 'Check-in');
  final body = TextEditingController(text: r?.body);
  var time = TimeOfDay(hour: r?.hour ?? 12, minute: r?.minute ?? 0);
  var weekdays = r?.weekdays ?? Weekdays.all;
  final selected = {...?existing?.symptoms.map((s) => s.id)};

  final l10n = context.l10n;
  final result = await showDialog<String>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(
          existing == null
              ? l10n.settingsReminderNewTitle
              : l10n.settingsReminderTitle,
        ),
        scrollable: true,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: title,
              decoration: InputDecoration(
                labelText: l10n.settingsReminderFieldTitle,
              ),
            ),
            TextField(
              controller: body,
              decoration: InputDecoration(
                labelText: l10n.settingsReminderFieldBody,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.schedule),
              title: Text(time.format(context)),
              subtitle: Text(l10n.settingsReminderTime),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: time,
                );
                if (picked != null) setState(() => time = picked);
              },
            ),
            Text(l10n.settingsReminderWeekdays),
            const SizedBox(height: 4),
            Wrap(
              spacing: 4,
              children: [
                for (var d = 1; d <= 7; d++)
                  FilterChip(
                    label: Text(Weekdays.labels[d - 1]),
                    selected: Weekdays.contains(weekdays, d),
                    onSelected: (_) => setState(() {
                      final next = Weekdays.toggle(weekdays, d);
                      if (next != 0) weekdays = next;
                    }),
                  ),
              ],
            ),
            if (symptoms.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(l10n.settingsReminderSymptomsHint),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                children: [
                  for (final s in symptoms)
                    if (s.healedAt == null || selected.contains(s.id))
                      FilterChip(
                        label: Text(s.label),
                        selected: selected.contains(s.id),
                        onSelected: (v) => setState(
                          () => v ? selected.add(s.id) : selected.remove(s.id),
                        ),
                      ),
                ],
              ),
            ],
          ],
        ),
        actions: [
          if (existing != null)
            TextButton(
              onPressed: () => Navigator.pop(context, 'delete'),
              child: Text(l10n.commonDelete),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, 'save'),
            child: Text(l10n.commonSave),
          ),
        ],
      ),
    ),
  );
  if (!context.mounted || result == null) return;
  if (result == 'delete') {
    if (await confirmDelete(context, what: l10n.settingsReminderTitle)) {
      await repo.delete(existing!.reminder.id);
    }
    return;
  }
  final name = title.text.trim().isEmpty ? 'Check-in' : title.text.trim();
  final text = body.text.trim().isEmpty ? null : body.text.trim();
  if (existing == null) {
    await repo.create(
      title: name,
      body: text,
      hour: time.hour,
      minute: time.minute,
      weekdays: weekdays,
      symptomIds: selected.toList(),
    );
  } else {
    await repo.update(
      id: existing.reminder.id,
      title: name,
      body: text,
      hour: time.hour,
      minute: time.minute,
      weekdays: weekdays,
      symptomIds: selected.toList(),
    );
  }
}

/// Für Tests: aktuelle Erinnerungen ohne Widget.
Future<List<Reminder>> loadReminders(AppDatabase db) async =>
    [for (final r in await ReminderRepository(db).all()) r.reminder];
