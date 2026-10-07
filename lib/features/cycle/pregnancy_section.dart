import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../data/database_provider.dart';
import '../../data/repositories/appointment_repository.dart';
import '../../data/repositories/cycle_repository.dart';
import '../../l10n/l10n.dart';
import '../../services/cycle/cycle_dates.dart';
import '../../services/cycle/cycle_text.dart' show milestoneTitle;
import '../../services/cycle/pregnancy_math.dart';

/// Schwangerschaft: SSW, Trimester, Termin, Vorsorge-Zeitstrahl.
class PregnancyCard extends StatefulWidget {
  const PregnancyCard({super.key, required this.overview});

  final CycleOverview overview;

  @override
  State<PregnancyCard> createState() => _PregnancyCardState();
}

class _PregnancyCardState extends State<PregnancyCard> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final o = widget.overview;
    final status = o.pregnancyStatus;
    final date = DateFormat(l10n.cycleDatePattern);
    final timeline = status == null
        ? const <PregnancyMilestone>[]
        : pregnancyTimeline(status, upcomingOnly: true);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.pregnant_woman, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.cyclePregnancyTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: l10n.cyclePregnancyEditDates,
                  icon: const Icon(Icons.edit_calendar_outlined),
                  onPressed: () => showPregnancyDatesDialog(context, o),
                ),
              ],
            ),
            if (status == null) ...[
              Text(l10n.cyclePregnancyNoDates),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => showPregnancyDatesDialog(context, o),
                icon: const Icon(Icons.edit_calendar_outlined),
                label: Text(l10n.cyclePregnancyEditDates),
              ),
            ] else ...[
              Text(
                l10n.cyclePregnancyWeek(status.age.label),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                [
                  l10n.cyclePregnancyTrimester(status.age.trimester),
                  l10n.cyclePregnancyDue(date.format(status.dueDate)),
                  if (status.daysToDue >= 0)
                    l10n.cyclePregnancyDaysToDue(status.daysToDue),
                ].join(' · '),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.cyclePregnancyDueNote,
                style: theme.textTheme.bodySmall,
              ),
              if (timeline.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  l10n.cyclePregnancyTimeline,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                for (final m in _showAll ? timeline : timeline.take(3))
                  _MilestoneTile(milestone: m),
                if (timeline.length > 3)
                  TextButton(
                    onPressed: () => setState(() => _showAll = !_showAll),
                    child: Text(
                      _showAll
                          ? l10n.cyclePregnancyShowLess
                          : l10n.cyclePregnancyShowAll(timeline.length),
                    ),
                  ),
                Text(
                  l10n.cyclePregnancyTimelineSource,
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => showEndPregnancyDialog(context, o),
                child: Text(l10n.cyclePregnancyEnd),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MilestoneTile extends StatelessWidget {
  const _MilestoneTile({required this.milestone});

  final PregnancyMilestone milestone;

  Future<void> _createAppointment(BuildContext context) async {
    final l10n = context.l10n;
    final db = DatabaseScope.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final today = cycleDay(DateTime.now());
    final initial = milestone.from.isBefore(today) ? today : milestone.from;
    final day = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: today,
      lastDate: plusDays(today, 400),
      helpText: milestoneTitle(milestone, l10n),
    );
    if (day == null || !context.mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (time == null) return;
    final doctorId = await CycleRepository(db).ensureGynecologist();
    await AppointmentRepository(db).create(
      doctorId: doctorId,
      scheduledAt: DateTime(
        day.year,
        day.month,
        day.day,
        time.hour,
        time.minute,
      ),
      title: milestoneTitle(milestone, l10n),
    );
    messenger.showSnackBar(SnackBar(content: Text(l10n.cycleMilestoneCreated)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final date = DateFormat(l10n.cycleDatePattern);
    final m = milestone;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        m.kind == MilestoneKind.ultrasound
            ? Icons.monitor_heart_outlined
            : Icons.event_note_outlined,
      ),
      title: Text(milestoneTitle(m, l10n)),
      subtitle: Text(
        m.kind == MilestoneKind.checkup
            ? l10n.cycleMilestoneAround(date.format(m.from))
            : '${date.format(m.from)} – ${date.format(m.to)}',
      ),
      trailing: IconButton(
        tooltip: l10n.cycleMilestoneCreate,
        icon: const Icon(Icons.add_alarm_outlined),
        onPressed: () => _createAppointment(context),
      ),
    );
  }
}

/// Letzte Periode und/oder errechneter Termin (Ultraschall hat Vorrang).
Future<void> showPregnancyDatesDialog(
  BuildContext context,
  CycleOverview overview,
) {
  return showDialog<void>(
    context: context,
    builder: (_) => DatabaseScope(
      database: DatabaseScope.of(context),
      child: _PregnancyDatesDialog(overview: overview),
    ),
  );
}

class _PregnancyDatesDialog extends StatefulWidget {
  const _PregnancyDatesDialog({required this.overview});

  final CycleOverview overview;

  @override
  State<_PregnancyDatesDialog> createState() => _PregnancyDatesDialogState();
}

class _PregnancyDatesDialogState extends State<_PregnancyDatesDialog> {
  late DateTime? _lmp = parseDayKey(widget.overview.pregnancy?.lmp);
  late DateTime? _due = parseDayKey(widget.overview.pregnancy?.dueDate);

  Future<DateTime?> _pick(DateTime? initial, DateTime first, DateTime last) {
    final today = widget.overview.today;
    var start = initial ?? today;
    if (start.isBefore(first)) start = first;
    if (start.isAfter(last)) start = last;
    return showDatePicker(
      context: context,
      initialDate: start,
      firstDate: first,
      lastDate: last,
    );
  }

  Future<void> _save() async {
    final repo = CycleRepository(DatabaseScope.of(context));
    final navigator = Navigator.of(context);
    final id = widget.overview.pregnancy?.id;
    if (id == null) {
      await repo.startPregnancy(lmp: _lmp, dueDate: _due);
    } else {
      await repo.updatePregnancy(id, lmp: _lmp, dueDate: _due);
    }
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final date = DateFormat(l10n.cycleDatePattern);
    final today = widget.overview.today;
    final lmp = _lmp;
    return AlertDialog(
      title: Text(l10n.cyclePregnancyEditDates),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.cyclePregnancyLmp),
            subtitle: Text(lmp == null ? '–' : date.format(lmp)),
            trailing: lmp == null
                ? const Icon(Icons.calendar_today_outlined)
                : IconButton(
                    tooltip: l10n.cyclePainClear,
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _lmp = null),
                  ),
            onTap: () async {
              final d = await _pick(_lmp, plusDays(today, -300), today);
              if (d != null) setState(() => _lmp = d);
            },
          ),
          if (lmp != null)
            Text(
              l10n.cyclePregnancyNaegele(date.format(naegeleDueDate(lmp))),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.cyclePregnancyDueOverride),
            subtitle: Text(_due == null ? '–' : date.format(_due!)),
            trailing: _due == null
                ? const Icon(Icons.calendar_today_outlined)
                : IconButton(
                    tooltip: l10n.cyclePainClear,
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _due = null),
                  ),
            onTap: () async {
              final d = await _pick(
                _due ?? (lmp == null ? null : naegeleDueDate(lmp)),
                plusDays(today, -30),
                plusDays(today, 300),
              );
              if (d != null) setState(() => _due = d);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(onPressed: _save, child: Text(l10n.commonSave)),
      ],
    );
  }
}

/// Schwangerschaft beenden — neutral, ohne Glückwunsch-Text. Das Ergebnis
/// ist optional („möchte ich nicht angeben“).
Future<void> showEndPregnancyDialog(
  BuildContext context,
  CycleOverview overview,
) async {
  final id = overview.pregnancy?.id;
  if (id == null) return;
  final l10n = context.l10n;
  final repo = CycleRepository(DatabaseScope.of(context));
  final messenger = ScaffoldMessenger.of(context);
  final note = TextEditingController();
  String? outcome;
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(l10n.cyclePregnancyEnd),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(l10n.cyclePregnancyEndText),
              const SizedBox(height: 8),
              RadioGroup<String?>(
                groupValue: outcome,
                onChanged: (v) => setState(() => outcome = v),
                child: Column(
                  children: [
                    for (final (value, label) in [
                      ('birth', l10n.cyclePregnancyOutcomeBirth),
                      ('loss', l10n.cyclePregnancyOutcomeLoss),
                      (null, l10n.cyclePregnancyOutcomeNone),
                    ])
                      RadioListTile<String?>(
                        contentPadding: EdgeInsets.zero,
                        value: value,
                        title: Text(label),
                      ),
                  ],
                ),
              ),
              TextField(
                controller: note,
                minLines: 1,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: '${l10n.entityNote} (${l10n.commonOptional})',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.cyclePregnancyEndConfirm),
          ),
        ],
      ),
    ),
  );
  final text = note.text;
  note.dispose();
  if (ok != true) return;
  await repo.endPregnancy(id, outcome: outcome, note: text);
  messenger.showSnackBar(SnackBar(content: Text(l10n.cyclePregnancyEnded)));
}
