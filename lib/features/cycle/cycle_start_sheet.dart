import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../data/database_provider.dart';
import '../../data/repositories/cycle_repository.dart';
import '../../l10n/l10n.dart';
import '../../services/cycle/cycle_dates.dart';

/// v17: „Zyklus-Start“ — fragt beim Einschalten des Periodentrackings nach
/// der letzten Periode und der üblichen Zykluslänge, damit die Schätzung
/// sofort beginnt. Gibt die Angaben zurück; `null` = „Später“/geschlossen.
Future<CycleStartAnswers?> showCycleStartSheet(
  BuildContext context, {
  DateTime? now,
}) => showModalBottomSheet<CycleStartAnswers>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (_) => CycleStartSheet(today: cycleDay(now ?? DateTime.now())),
);

/// Sheet zeigen und das Ergebnis direkt speichern (Einstellungen, „Heute“).
Future<void> runCycleStart(BuildContext context) async {
  final l10n = context.l10n;
  final repo = CycleRepository(DatabaseScope.of(context));
  final messenger = ScaffoldMessenger.maybeOf(context);
  final answers = await showCycleStartSheet(context);
  if (answers == null) {
    await repo.skipCycleStart();
    return;
  }
  await repo.saveCycleStart(answers);
  messenger?.showSnackBar(SnackBar(content: Text(l10n.cycleStartSaved)));
}

class CycleStartSheet extends StatefulWidget {
  const CycleStartSheet({super.key, required this.today});

  final DateTime today;

  @override
  State<CycleStartSheet> createState() => _CycleStartSheetState();
}

class _CycleStartSheetState extends State<CycleStartSheet> {
  DateTime? _start;
  DateTime? _end;
  int _days = CycleStartAnswers.defaultPeriodDays;
  bool _daysUnknown = false;
  int _length = CycleStartAnswers.defaultCycleLength;
  bool _lengthUnknown = false;

  DateTime get _today => widget.today;

  /// Höchstens etwa ein Jahr zurück.
  DateTime get _earliest => plusDays(_today, -365);

  void _setStart(DateTime day) => setState(() {
    _start = day;
    _end = null;
  });

  Future<void> _pickStart() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _start ?? _today,
      firstDate: _earliest,
      lastDate: _today,
    );
    if (picked != null) _setStart(cycleDay(picked));
  }

  Future<void> _pickEnd() async {
    final start = _start!;
    final last = plusDays(start, CycleStartAnswers.maxPeriodDays - 1);
    final lastDate = last.isAfter(_today) ? _today : last;
    final picked = await showDatePicker(
      context: context,
      initialDate: _end ?? lastDate,
      firstDate: start,
      lastDate: lastDate,
    );
    if (picked == null) return;
    setState(() {
      _end = cycleDay(picked);
      _days = dayDiff(start, _end!) + 1;
      _daysUnknown = false;
    });
  }

  CycleStartAnswers get _answers => CycleStartAnswers(
    lastStart: _start,
    periodDays: _daysUnknown ? CycleStartAnswers.defaultPeriodDays : _days,
    typicalCycleLength: _lengthUnknown ? null : _length,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final date = DateFormat(l10n.cycleDatePattern);
    final start = _start;

    Widget question(String text) => Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 6),
      child: Text(
        text,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    Widget stepper({
      required String keyPrefix,
      required String label,
      required int value,
      required int min,
      required int max,
      required bool enabled,
      required ValueChanged<int> onChanged,
    }) => Row(
      children: [
        IconButton.outlined(
          key: ValueKey('$keyPrefix-minus'),
          tooltip: l10n.cycleStartDecrease,
          onPressed: enabled && value > min ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.remove),
        ),
        Expanded(
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              color: enabled ? null : theme.disabledColor,
            ),
          ),
        ),
        IconButton.outlined(
          key: ValueKey('$keyPrefix-plus'),
          tooltip: l10n.cycleStartIncrease,
          onPressed: enabled && value < max ? () => onChanged(value + 1) : null,
          icon: const Icon(Icons.add),
        ),
      ],
    );

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.cycleStartTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(l10n.cycleStartIntro, style: theme.textTheme.bodyMedium),

              // 1) Beginn der letzten Periode.
              question(l10n.cycleStartLastQuestion),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final weeks in [1, 2, 3, 4])
                    ChoiceChip(
                      key: ValueKey('cycle-start-weeks-$weeks'),
                      label: Text(l10n.cycleStartWeeksAgo(weeks)),
                      selected: start == plusDays(_today, -7 * weeks),
                      onSelected: (_) =>
                          _setStart(plusDays(_today, -7 * weeks)),
                    ),
                  ActionChip(
                    key: const ValueKey('cycle-start-pick-date'),
                    avatar: const Icon(Icons.event_outlined, size: 18),
                    label: Text(l10n.cycleStartPickDate),
                    onPressed: _pickStart,
                  ),
                ],
              ),
              if (start != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    l10n.cycleStartChosenDate(date.format(start)),
                    style: theme.textTheme.bodySmall,
                  ),
                ),

              // 2) Dauer — oder Ende wählen.
              question(l10n.cycleStartDurationQuestion),
              stepper(
                keyPrefix: 'cycle-start-days',
                label: l10n.cycleStartDays(
                  _daysUnknown ? CycleStartAnswers.defaultPeriodDays : _days,
                ),
                value: _days,
                min: CycleStartAnswers.minPeriodDays,
                max: CycleStartAnswers.maxPeriodDays,
                enabled: !_daysUnknown,
                onChanged: (v) => setState(() {
                  _days = v;
                  _end = null;
                }),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  FilterChip(
                    key: const ValueKey('cycle-start-days-unknown'),
                    label: Text(l10n.cycleStartDontKnow),
                    selected: _daysUnknown,
                    onSelected: (v) => setState(() {
                      _daysUnknown = v;
                      _end = null;
                    }),
                  ),
                  TextButton.icon(
                    key: const ValueKey('cycle-start-end'),
                    onPressed: start == null ? null : _pickEnd,
                    icon: const Icon(Icons.event_available_outlined),
                    label: Text(
                      _end == null
                          ? l10n.cycleStartPickEnd
                          : l10n.cycleStartEndDate(date.format(_end!)),
                    ),
                  ),
                ],
              ),

              // 3) Übliche Zykluslänge.
              question(l10n.cycleStartLengthQuestion),
              Text(l10n.cycleStartLengthHelp, style: theme.textTheme.bodySmall),
              const SizedBox(height: 6),
              stepper(
                keyPrefix: 'cycle-start-length',
                label: l10n.cycleStartDays(_length),
                value: _length,
                min: CycleStartAnswers.minCycleLength,
                max: CycleStartAnswers.maxCycleLength,
                enabled: !_lengthUnknown,
                onChanged: (v) => setState(() => _length = v),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: FilterChip(
                  key: const ValueKey('cycle-start-length-unknown'),
                  label: Text(l10n.cycleStartIrregular),
                  selected: _lengthUnknown,
                  onSelected: (v) => setState(() => _lengthUnknown = v),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  TextButton(
                    key: const ValueKey('cycle-start-later'),
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.cycleStartLater),
                  ),
                  const Spacer(),
                  FilledButton(
                    key: const ValueKey('cycle-start-save'),
                    // Theme-Standard ist volle Breite — in einer Row unmöglich.
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(140, 48),
                    ),
                    onPressed: () => Navigator.pop(context, _answers),
                    child: Text(l10n.cycleStartSave),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Karte auf „Heute“, solange noch keine Periode erfasst ist — fragt auch
/// Bestandsnutzerinnen, die das Tracking vor v17 eingeschaltet haben.
class CycleStartPrompt extends StatelessWidget {
  const CycleStartPrompt({super.key, required this.overview});

  final CycleOverview overview;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    if (overview.cycleSetupDone) {
      // Übersprungen: nur noch dezent anbieten.
      return Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          key: const ValueKey('cycle-start-add'),
          onPressed: () => runCycleStart(context),
          icon: const Icon(Icons.history),
          label: Text(l10n.cycleStartAddLast),
        ),
      );
    }
    return Card(
      key: const ValueKey('cycle-start-prompt'),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.cycleStartCardTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(l10n.cycleStartCardText),
            const SizedBox(height: 8),
            // Schmale Bildschirme: Knöpfe untereinander statt Überlauf.
            OverflowBar(
              alignment: MainAxisAlignment.spaceBetween,
              overflowAlignment: OverflowBarAlignment.end,
              children: [
                TextButton(
                  key: const ValueKey('cycle-start-prompt-later'),
                  onPressed: () =>
                      CycleRepository(DatabaseScope.of(context))
                          .skipCycleStart(),
                  child: Text(l10n.cycleStartLater),
                ),
                FilledButton.icon(
                  key: const ValueKey('cycle-start-open'),
                  style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
                  onPressed: () => runCycleStart(context),
                  icon: const Icon(Icons.water_drop_outlined),
                  label: Text(l10n.cycleStartCardAction),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
