import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat, NumberFormat;

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/measure_units.dart';
import '../../data/repositories/cycle_repository.dart';
import '../../l10n/l10n.dart';
import '../../services/cycle/cycle_analytics.dart';
import '../../services/cycle/cycle_dates.dart';
import '../../services/cycle/cycle_text.dart';
import '../../services/cycle/mrs.dart';
import '../../theme/app_theme.dart';
import '../../widgets/cycle_charts.dart';
import '../../widgets/observation_chart.dart' show ChartPoint;
import 'cycle_day_page.dart';
import 'cycle_start_sheet.dart';
import 'cycle_widgets.dart';
import 'mrs_page.dart';
import 'pregnancy_section.dart';

/// Zyklus & Frauengesundheit: Heute (schnell erfassen), Kalender, Auswertung.
class CyclePage extends StatefulWidget {
  const CyclePage({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<CyclePage> createState() => _CyclePageState();
}

class _CyclePageState extends State<CyclePage> {
  Stream<CycleOverview>? _stream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _stream ??= CycleRepository(DatabaseScope.of(context)).watchOverview();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DefaultTabController(
      length: 3,
      initialIndex: widget.initialTab,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.cycleTitle),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.cycleTabToday),
              Tab(text: l10n.cycleTabCalendar),
              Tab(text: l10n.cycleTabInsights),
            ],
          ),
        ),
        body: StreamBuilder<CycleOverview>(
          stream: _stream,
          builder: (context, snapshot) {
            final o = snapshot.data;
            if (o == null) return const SizedBox.shrink();
            return TabBarView(
              children: [
                _TodayTab(overview: o),
                _CalendarTab(overview: o),
                _InsightsTab(overview: o),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ------------------------------------------------------------------ Heute

class _TodayTab extends StatelessWidget {
  const _TodayTab({required this.overview});

  final CycleOverview overview;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final o = overview;
    final lines = cycleStatusLines(o, l10n);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        if (lines.isNotEmpty)
          Card(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.45),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final (i, line) in lines.indexed)
                    Text(
                      line,
                      style: i == 0
                          ? theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            )
                          : theme.textTheme.bodyMedium,
                    ),
                  if (o.cycleTracking && o.analysis.prediction != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      cycleEstimateNote(o.analysis.prediction!, l10n),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
          ),
        if (o.needsCycleStart) CycleStartPrompt(overview: o),
        CycleHintsCard(hints: o.analysis.hints),
        const SizedBox(height: 8),
        _QuickLog(overview: o),
        if (o.pregnancyTracking) ...[
          const SizedBox(height: 8),
          PregnancyCard(overview: o),
        ],
        if (o.menopauseTracking) ...[
          const SizedBox(height: 8),
          _MrsCard(overview: o),
        ],
        const SizedBox(height: 16),
        const CyclePrivacyNote(),
      ],
    );
  }
}

/// Heute schnell erfassen: Blutung und Schmerz speichern sofort.
class _QuickLog extends StatefulWidget {
  const _QuickLog({required this.overview});

  final CycleOverview overview;

  @override
  State<_QuickLog> createState() => _QuickLogState();
}

class _QuickLogState extends State<_QuickLog> {
  /// Während des Ziehens (vor dem Speichern) lokal.
  int? _draftPain;
  bool _dragging = false;

  Future<void> _save(CycleDaysCompanion values) =>
      CycleRepository(DatabaseScope.of(context))
          .saveDay(widget.overview.today, values);

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final o = widget.overview;
    final row = o.rowFor(o.today);
    final pain = _dragging ? _draftPain : row?.pain;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.cycleQuickLogTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(l10n.cycleFlowTitle, style: theme.textTheme.labelLarge),
            const SizedBox(height: 4),
            FlowSelector(
              value: row?.flow,
              onChanged: (f) => _save(CycleDaysCompanion(flow: Value(f))),
            ),
            const SizedBox(height: 12),
            Text(l10n.cyclePainTitle, style: theme.textTheme.labelLarge),
            PainSlider(
              value: pain,
              onChanged: (v) => setState(() {
                _dragging = true;
                _draftPain = v;
              }),
              onChangeEnd: (v) async {
                await _save(CycleDaysCompanion(pain: Value(v)));
                if (mounted) setState(() => _dragging = false);
              },
            ),
            if (row != null && splitKeys(row.symptoms).isNotEmpty)
              Text(
                l10n.cycleQuickLogSymptoms(splitKeys(row.symptoms).length),
                style: theme.textTheme.bodySmall,
              ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              key: const ValueKey('cycle-more'),
              onPressed: () => openCycleDay(context, o.today),
              icon: const Icon(Icons.edit_note),
              label: Text(l10n.cycleQuickLogMore),
            ),
          ],
        ),
      ),
    );
  }
}

class _MrsCard extends StatelessWidget {
  const _MrsCard({required this.overview});

  final CycleOverview overview;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final latest = overview.latestMrs;
    final result = latest == null ? null : MrsResult.parse(latest.scores);
    final date = DateFormat(l10n.cycleDatePattern);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.cycleMrsTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              result == null
                  ? l10n.cycleMrsExplain
                  : '${date.format(latest!.recordedAt)}: '
                        '${mrsSummary(result, l10n)}',
            ),
            const SizedBox(height: 8),
            overview.mrsDue
                ? FilledButton.icon(
                    onPressed: () => _openMrs(context),
                    icon: const Icon(Icons.checklist),
                    label: Text(l10n.cycleMrsFill),
                  )
                : OutlinedButton.icon(
                    onPressed: () => _openMrs(context),
                    icon: const Icon(Icons.checklist),
                    label: Text(l10n.cycleMrsFill),
                  ),
          ],
        ),
      ),
    );
  }

  void _openMrs(BuildContext context) =>
      Navigator.of(context)
          .push(MaterialPageRoute<void>(builder: (_) => const MrsPage()));
}

// --------------------------------------------------------------- Kalender

class _CalendarTab extends StatefulWidget {
  const _CalendarTab({required this.overview});

  final CycleOverview overview;

  @override
  State<_CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends State<_CalendarTab> {
  late DateTime _month = DateTime(
    widget.overview.today.year,
    widget.overview.today.month,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final o = widget.overview;
    final p = o.analysis.prediction;
    final date = DateFormat(l10n.cycleDatePattern);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        Row(
          children: [
            IconButton(
              tooltip: l10n.cyclePrevMonth,
              icon: const Icon(Icons.chevron_left),
              onPressed: () => setState(
                () => _month = DateTime(_month.year, _month.month - 1),
              ),
            ),
            Expanded(
              child: Text(
                DateFormat(l10n.cycleMonthPattern).format(_month),
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
            ),
            IconButton(
              tooltip: l10n.cycleNextMonth,
              icon: const Icon(Icons.chevron_right),
              onPressed: () => setState(
                () => _month = DateTime(_month.year, _month.month + 1),
              ),
            ),
          ],
        ),
        CycleMonthCalendar(
          month: _month,
          analysis: o.analysis,
          today: o.today,
          showFertileWindow: o.showFertileWindow && o.cycleTracking,
          onDayTap: (day) => openCycleDay(context, day),
        ),
        const SizedBox(height: 12),
        if (p != null && o.cycleTracking)
          Text(
            l10n.cyclePredictionRange(
              date.format(p.earliest),
              date.format(p.latest),
            ),
          ),
        if (p != null && o.cycleTracking && o.showFertileWindow)
          Text(
            l10n.cycleFertileRange(
              date.format(p.fertileFrom),
              date.format(p.fertileTo),
            ),
            style: theme.textTheme.bodySmall,
          ),
        const SizedBox(height: 8),
        Text(l10n.cycleCalendarHint, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

// ------------------------------------------------------------- Auswertung

class _InsightsTab extends StatelessWidget {
  const _InsightsTab({required this.overview});

  final CycleOverview overview;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final o = overview;
    final a = o.analysis;
    final s = a.stats;
    final decimal = NumberFormat.decimalPattern(l10n.localeName);
    final date = DateFormat(l10n.cycleDatePattern);
    final completed = a.completedCycles;
    final byPhase = a.symptomsByPhase();
    final hasPbac = a.cycles.any((c) => c.pbac > 0);
    final hasPain = a.cycles.any((c) => c.pain.isNotEmpty);

    Widget section(String title, Widget child, {String? help}) => Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (help != null) Text(help, style: theme.textTheme.bodySmall),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );

    final children = <Widget>[
      if (o.cycleTracking && !o.pregnant)
        section(
          l10n.cycleInsightsOverview,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (s == null)
                Text(l10n.cycleInsightsNotEnough)
              else ...[
                Text(
                  l10n.cycleInsightsAverage(
                    decimal.format(double.parse(s.average.toStringAsFixed(1))),
                    s.median,
                    s.min,
                    s.max,
                  ),
                ),
                Text(
                  l10n.cycleInsightsPeriod(
                    decimal.format(
                      double.parse(s.averagePeriodLength.toStringAsFixed(1)),
                    ),
                    s.count,
                  ),
                ),
              ],
              if (a.prediction case final p?) ...[
                const SizedBox(height: 6),
                Text(
                  l10n.cyclePredictionRange(
                    date.format(p.earliest),
                    date.format(p.latest),
                  ),
                ),
                if (o.showFertileWindow)
                  Text(
                    l10n.cycleFertileRange(
                      date.format(p.fertileFrom),
                      date.format(p.fertileTo),
                    ),
                  ),
                const SizedBox(height: 4),
                Text(
                  cycleEstimateNote(p, l10n),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      CycleHintsCard(hints: a.hints),
      if (completed.isNotEmpty)
        section(
          l10n.cycleChartLengthTitle,
          CycleLengthChart(cycles: completed, average: s?.average),
          help: l10n.cycleChartLengthHelp,
        ),
      if (hasPain)
        section(
          l10n.cycleChartPainTitle,
          PainHeatStrip(cycles: a.cycles),
          help: l10n.cycleChartPainHelp,
        ),
      if (byPhase.isNotEmpty)
        section(
          l10n.cycleChartPhaseTitle,
          PhaseSymptomChart(data: byPhase),
          help: l10n.cycleChartPhaseHelp,
        ),
      if (hasPbac)
        section(
          l10n.cycleChartPbacTitle,
          PbacChart(cycles: a.cycles),
          help: l10n.cyclePbacExplain,
        ),
      if (o.menopauseTracking) ..._menopause(context, o, section),
      if (o.pregnant) ..._pregnancy(context, o, section),
    ];
    if (children.whereType<Card>().isEmpty && a.hints.isEmpty) {
      children.add(
        Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.cycleInsightsEmpty,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.muted),
          ),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        for (final c in children)
          Padding(padding: const EdgeInsets.only(bottom: 8), child: c),
      ],
    );
  }

  List<Widget> _menopause(
    BuildContext context,
    CycleOverview o,
    Widget Function(String, Widget, {String? help}) section,
  ) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final format = DateFormat(l10n.cycleShortDatePattern);
    // Hitzewallungen je Woche (letzte 12 Wochen, Montag als Wochenbeginn).
    final weekStart = plusDays(o.today, -(o.today.weekday - 1));
    final weeks = [for (var i = 11; i >= 0; i--) plusDays(weekStart, -7 * i)];
    final perWeek = {for (final w in weeks) w: 0};
    for (final log in o.analysis.logs) {
      final n = log.hotFlashes;
      if (n == null) continue;
      final w = plusDays(log.day, -(log.day.weekday - 1));
      if (perWeek.containsKey(w)) perWeek[w] = perWeek[w]! + n;
    }
    final mrs = [
      for (final m in o.mrs) (m.recordedAt, MrsResult.parse(m.scores)),
    ];
    return [
      if (perWeek.values.any((v) => v > 0))
        section(
          l10n.cycleChartHotFlashTitle,
          CycleBarChart(
            semanticsLabel: l10n.cycleChartHotFlashSemantics(
              perWeek.values.join(', '),
            ),
            color: AppColors.accent,
            bars: [
              for (final w in weeks)
                BarDatum(
                  label: format.format(w),
                  value: perWeek[w]!.toDouble(),
                ),
            ],
          ),
        ),
      if (mrs.isNotEmpty)
        section(
          l10n.cycleChartMrsTitle,
          CycleLineChart(
            minY: 0,
            maxY: 44,
            semanticsLabel: l10n.cycleChartMrsSemantics(
              mrs.map((m) => '${m.$2.total}').join(', '),
            ),
            series: [
              LineSeries(l10n.cycleMrsTotalLabel, scheme.primary, [
                for (final (at, r) in mrs) ChartPoint(at, r.total.toDouble()),
              ]),
              for (final (sub, color) in [
                (MrsSubscale.somatic, AppColors.accent),
                (MrsSubscale.psychological, scheme.tertiary),
                (MrsSubscale.urogenital, AppColors.danger),
              ])
                LineSeries(mrsSubscaleLabel(sub, l10n), color, [
                  for (final (at, r) in mrs)
                    ChartPoint(at, r.subscale(sub).toDouble()),
                ]),
            ],
          ),
          help: l10n.cycleMrsBands,
        ),
    ];
  }

  List<Widget> _pregnancy(
    BuildContext context,
    CycleOverview o,
    Widget Function(String, Widget, {String? help}) section,
  ) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final since = o.pregnancyStatus?.start;
    final logs = [
      for (final l in o.analysis.logs)
        if (since == null || !l.day.isBefore(since)) l,
    ];
    final weight = [
      for (final l in logs)
        // v15: in der gewählten Einheit (kg/lb).
        if (l.weightKg != null)
          ChartPoint(l.day, AppUnits.current.weightToDisplay(l.weightKg!)),
    ];
    final sys = [
      for (final l in logs)
        if (l.bpSystolic != null) ChartPoint(l.day, l.bpSystolic!.toDouble()),
    ];
    final dia = [
      for (final l in logs)
        if (l.bpDiastolic != null) ChartPoint(l.day, l.bpDiastolic!.toDouble()),
    ];
    return [
      if (weight.isNotEmpty)
        section(
          l10n.cycleChartWeightTitle,
          CycleLineChart(
            semanticsLabel: l10n.cycleChartWeightSemanticsValue(
              weight.length,
              '${weight.last.value.toStringAsFixed(1)} '
              '${AppUnits.current.weight.symbol}',
            ),
            series: [LineSeries(l10n.cycleWeight, scheme.primary, weight)],
          ),
        ),
      if (sys.isNotEmpty || dia.isNotEmpty)
        section(
          l10n.cycleChartBpTitle,
          CycleLineChart(
            semanticsLabel: l10n.cycleChartBpSemantics(sys.length),
            series: [
              LineSeries(l10n.cycleBpSystolic, AppColors.danger, sys),
              LineSeries(l10n.cycleBpDiastolic, scheme.primary, dia),
            ],
          ),
          help: l10n.cycleChartBpHelp,
        ),
    ];
  }
}
