import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/reminder_repository.dart';
import '../../data/repositories/symptom_repository.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _stream ??= ReminderRepository(DatabaseScope.of(context)).watchAll();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final repo = ReminderRepository(DatabaseScope.of(context));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Erinnerungen',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton.icon(
              onPressed: () => showReminderForm(context),
              icon: const Icon(Icons.add_alarm),
              label: const Text('Neu'),
            ),
          ],
        ),
        StreamBuilder<List<ReminderWithSymptoms>>(
          stream: _stream,
          builder: (context, snapshot) {
            final items = snapshot.data ?? const <ReminderWithSymptoms>[];
            if (items.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Keine Erinnerungen — mit „Neu“ anlegen.',
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
                    onToggle: (v) => repo.setEnabled(item.reminder.id, v),
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
          label: const Text('Check-in jetzt öffnen'),
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
        ? 'alle offenen Symptome'
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

  final result = await showDialog<String>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(existing == null ? 'Neue Erinnerung' : 'Erinnerung'),
        scrollable: true,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(labelText: 'Titel'),
            ),
            TextField(
              controller: body,
              decoration: const InputDecoration(
                labelText: 'Text (optional)',
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.schedule),
              title: Text(time.format(context)),
              subtitle: const Text('Uhrzeit'),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: time,
                );
                if (picked != null) setState(() => time = picked);
              },
            ),
            const Text('Wochentage'),
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
              const Text('Nur für Symptome (leer = alle offenen)'),
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
              child: const Text('Löschen'),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, 'save'),
            child: const Text('Speichern'),
          ),
        ],
      ),
    ),
  );
  if (!context.mounted || result == null) return;
  if (result == 'delete') {
    if (await confirmDelete(context, what: 'Erinnerung')) {
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
