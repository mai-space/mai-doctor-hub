import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/psych_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../l10n/l10n.dart';
import '../../services/psych/psych_questionnaires.dart';
import '../../widgets/cycle_charts.dart' show CycleLineChart, LineSeries;
import '../../widgets/observation_chart.dart' show ChartPoint;
import '../settings/reminders_section.dart' show ensureNotificationPermission;
import 'support_card.dart';

/// v15: Bereich „Psyche“ — PHQ-9 und GAD-7 ausfüllen, Verlauf, monatliche
/// Erinnerung. Erreichbar über psychische Symptome und die Einstellungen.
class PsychPage extends StatefulWidget {
  const PsychPage({super.key});

  @override
  State<PsychPage> createState() => _PsychPageState();
}

class _PsychPageState extends State<PsychPage> {
  Stream<List<PsychEntry>>? _entries;
  Stream<AppSetting>? _settings;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final db = DatabaseScope.of(context);
    _entries ??= PsychRepository(db).watchAll();
    _settings ??= SettingsRepository(db).watch();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final db = DatabaseScope.of(context);
    final date = DateFormat(l10n.recordsDatePattern);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.psychTitle)),
      body: StreamBuilder<List<PsychEntry>>(
        stream: _entries,
        builder: (context, snapshot) {
          final entries = snapshot.data ?? const <PsychEntry>[];
          final latestPhq = entries
              .where((e) => e.result.instrument == PsychInstrument.phq9)
              .lastOrNull;
          List<ChartPoint> points(PsychInstrument i) => [
            for (final e in entries)
              if (e.result.instrument == i)
                ChartPoint(e.recordedAt, e.result.total.toDouble()),
          ];
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            children: [
              Text(l10n.psychIntro, style: theme.textTheme.bodyMedium),
              if (latestPhq?.result.selfHarmFlag ?? false) ...[
                const SizedBox(height: 12),
                const SupportCard(),
              ],
              const SizedBox(height: 12),
              for (final i in PsychInstrument.values)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: FilledButton.tonalIcon(
                    key: ValueKey('psych-fill-${i.code}'),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => PsychQuestionnairePage(instrument: i),
                      ),
                    ),
                    icon: const Icon(Icons.checklist),
                    label: Text(l10n.psychFill(psychInstrumentLabel(i, l10n))),
                  ),
                ),
              StreamBuilder<AppSetting>(
                stream: _settings,
                builder: (context, snapshot) {
                  final s = snapshot.data;
                  if (s == null) return const SizedBox.shrink();
                  return SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    secondary: const Icon(Icons.event_repeat),
                    title: Text(l10n.psychQuestionnairesToggle),
                    subtitle: Text(l10n.psychQuestionnairesSubtitle),
                    value: s.psychQuestionnaires,
                    onChanged: (v) async {
                      await PsychRepository(db).setQuestionnaires(v);
                      if (v && context.mounted) {
                        await ensureNotificationPermission(context);
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 12),
              Text(
                l10n.psychTrend,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              if (entries.isEmpty)
                Text(l10n.psychNoResults)
              else ...[
                CycleLineChart(
                  semanticsLabel: [
                    for (final e in [
                      latestPhq,
                      entries
                          .where(
                            (e) => e.result.instrument == PsychInstrument.gad7,
                          )
                          .lastOrNull,
                    ])
                      if (e != null) psychSummary(e.result, l10n),
                  ].join('; '),
                  minY: 0,
                  maxY: 27,
                  series: [
                    LineSeries(
                      l10n.psychPhq9Title,
                      theme.colorScheme.primary,
                      points(PsychInstrument.phq9),
                    ),
                    LineSeries(
                      l10n.psychGad7Title,
                      theme.colorScheme.tertiary,
                      points(PsychInstrument.gad7),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(l10n.psychBands, style: theme.textTheme.bodySmall),
                const SizedBox(height: 8),
                for (final e in entries.reversed)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(psychSummary(e.result, l10n)),
                    subtitle: Text(date.format(e.recordedAt)),
                    trailing: IconButton(
                      tooltip: l10n.recordsDeleteEntry,
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => PsychRepository(db).delete(e.row.id),
                    ),
                  ),
              ],
              const SizedBox(height: 12),
              Text(l10n.psychSource, style: theme.textTheme.bodySmall),
            ],
          );
        },
      ),
    );
  }
}

/// Ein Fragebogen (PHQ-9 oder GAD-7): alle Items mit vier Stufen.
class PsychQuestionnairePage extends StatefulWidget {
  const PsychQuestionnairePage({super.key, required this.instrument});

  final PsychInstrument instrument;

  @override
  State<PsychQuestionnairePage> createState() => _PsychQuestionnairePageState();
}

class _PsychQuestionnairePageState extends State<PsychQuestionnairePage> {
  late final List<int?> _scores = List.filled(
    widget.instrument.itemCount,
    null,
  );

  Future<void> _save() async {
    final l10n = context.l10n;
    final repo = PsychRepository(DatabaseScope.of(context));
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final result = PsychResult(widget.instrument, [
      for (final s in _scores) s ?? 0,
    ]);
    await repo.add(result);
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.psychSaved(psychSummary(result, l10n)))),
    );
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final items = psychItems(widget.instrument, l10n);
    final answers = psychAnswerLabels(l10n);
    final answered = _scores.whereType<int>().length;
    final count = widget.instrument.itemCount;
    // Hilfsangebot sofort, wenn PHQ-9 Item 9 > 0 angekreuzt wird.
    final selfHarm =
        widget.instrument == PsychInstrument.phq9 &&
        (_scores[phq9SelfHarmItem] ?? 0) > 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(psychInstrumentLabel(widget.instrument, l10n)),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: FilledButton(
            onPressed: answered == count ? _save : null,
            child: Text(l10n.psychSave(answered, count)),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text(l10n.psychQuestion, style: theme.textTheme.bodyMedium),
          for (var i = 0; i < count; i++) ...[
            const SizedBox(height: 18),
            Text(
              '${i + 1}. ${items[i]}',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (var v = 0; v <= psychMaxItem; v++)
                  ChoiceChip(
                    key: ValueKey('psych-$i-$v'),
                    label: Text(answers[v]),
                    selected: _scores[i] == v,
                    onSelected: (_) => setState(() => _scores[i] = v),
                  ),
              ],
            ),
            if (i == phq9SelfHarmItem && selfHarm) ...[
              const SizedBox(height: 8),
              const SupportCard(),
            ],
          ],
          const SizedBox(height: 16),
          Text(l10n.psychSource, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
