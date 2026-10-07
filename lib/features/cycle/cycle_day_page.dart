import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' show DateFormat, NumberFormat;

import '../../data/app_database.dart';
import '../../data/cycle_catalog.dart';
import '../../data/database_provider.dart';
import '../../data/measure_units.dart';
import '../../data/repositories/cycle_repository.dart';
import '../../l10n/l10n.dart';
import '../../services/cycle/cycle_analytics.dart' show joinKeys, splitKeys;
import '../../services/cycle/pbac.dart';
import '../../theme/app_theme.dart';
import 'cycle_widgets.dart';

/// Öffnet den Tagebuch-Eintrag eines Tages (auch für vergangene Tage).
Future<void> openCycleDay(BuildContext context, DateTime day) =>
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => CycleDayPage(day: day)));

/// Alle Angaben eines Tages: Blutung (optional PBAC), Schmerz und Orte,
/// Symptome, Ausfluss, Schmerzmittel, Notiz — plus Wechseljahre- bzw.
/// Schwangerschaftsfelder, wenn diese Bereiche aktiv sind.
class CycleDayPage extends StatefulWidget {
  const CycleDayPage({super.key, required this.day});

  final DateTime day;

  @override
  State<CycleDayPage> createState() => _CycleDayPageState();
}

class _CycleDayPageState extends State<CycleDayPage> {
  bool _loaded = false;
  bool _exists = false;
  CycleOverview? _overview;

  CycleFlow? _flow;
  PbacCounts _pbac = PbacCounts.empty;
  int? _pain;
  final Set<String> _locations = {};
  final List<String> _symptoms = [];
  String? _discharge;
  bool _painkiller = false;
  bool? _helped;
  int _hotFlashes = 0;
  int? _hotFlashIntensity;
  int? _nightSweats;
  FetalMovement? _fetal;

  final _painkillerName = TextEditingController();
  final _weight = TextEditingController();
  final _bpSys = TextEditingController();
  final _bpDia = TextEditingController();
  final _note = TextEditingController();
  final _other = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) _load();
  }

  @override
  void dispose() {
    for (final c in [_painkillerName, _weight, _bpSys, _bpDia, _note, _other]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    _loaded = true;
    final repo = CycleRepository(DatabaseScope.of(context));
    final row = await repo.getDay(widget.day);
    final overview = await repo.overview();
    if (!mounted) return;
    final decimal = NumberFormat.decimalPattern(context.l10n.localeName);
    setState(() {
      _overview = overview;
      if (row == null) return;
      _exists = true;
      _flow = row.flow;
      _pbac = PbacCounts.parse(row.pbacJson);
      _pain = row.pain;
      _locations.addAll(splitKeys(row.painLocations));
      _symptoms.addAll(splitKeys(row.symptoms));
      _discharge = row.discharge;
      _painkiller = row.painkiller ?? false;
      _helped = row.painkillerHelped;
      _painkillerName.text = row.painkillerName ?? '';
      _hotFlashes = row.hotFlashes ?? 0;
      _hotFlashIntensity = row.hotFlashIntensity;
      _nightSweats = row.nightSweats;
      _fetal = row.fetalMovement;
      // v15: Anzeige in kg oder lb (gespeichert immer kg).
      _weight.text = row.weightKg == null
          ? ''
          : decimal.format(
              double.parse(
                AppUnits.current.weightToDisplay(row.weightKg!).toStringAsFixed(1),
              ),
            );
      _bpSys.text = row.bpSystolic?.toString() ?? '';
      _bpDia.text = row.bpDiastolic?.toString() ?? '';
      _note.text = row.note ?? '';
    });
  }

  String? _text(TextEditingController c) =>
      c.text.trim().isEmpty ? null : c.text.trim();

  double? _decimal(String text) =>
      double.tryParse(text.trim().replaceAll(',', '.'));

  Future<void> _save() async {
    final o = _overview;
    final repo = CycleRepository(DatabaseScope.of(context));
    final navigator = Navigator.of(context);
    await repo.saveDay(
      widget.day,
      CycleDaysCompanion(
        flow: Value(_flow),
        pbacJson: Value(_pbac.encode()),
        pain: Value(_pain),
        painLocations: Value(joinKeys(_locations)),
        symptoms: Value(joinKeys(_symptoms)),
        discharge: Value(_discharge),
        painkiller: Value(_painkiller ? true : null),
        painkillerName: Value(_painkiller ? _text(_painkillerName) : null),
        painkillerHelped: Value(_painkiller ? _helped : null),
        hotFlashes: Value(
          o?.menopauseTracking == true && _hotFlashes > 0 ? _hotFlashes : null,
        ),
        hotFlashIntensity: Value(
          o?.menopauseTracking == true && _hotFlashes > 0
              ? _hotFlashIntensity
              : null,
        ),
        nightSweats: Value(_nightSweats),
        fetalMovement: Value(_fetal),
        weightKg: Value(
          _decimal(_weight.text) == null
              ? null
              : AppUnits.current.weightFromDisplay(_decimal(_weight.text)!),
        ),
        bpSystolic: Value(int.tryParse(_bpSys.text.trim())),
        bpDiastolic: Value(int.tryParse(_bpDia.text.trim())),
        note: Value(_text(_note)),
      ),
    );
    navigator.pop();
  }

  Future<void> _delete() async {
    final l10n = context.l10n;
    final repo = CycleRepository(DatabaseScope.of(context));
    final navigator = Navigator.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.cycleDayDeleteTitle),
        content: Text(l10n.cycleDayDeleteText),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await repo.deleteDay(widget.day);
    navigator.pop();
  }

  void _addOther(String raw) {
    final value = raw.trim().replaceAll(',', ' ');
    if (value.isEmpty) return;
    setState(() {
      if (!_symptoms.contains(value)) _symptoms.add(value);
      _other.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final o = _overview;
    final title = DateFormat(l10n.cycleDayTitlePattern).format(widget.day);
    Widget heading(String text, [String? help]) => Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          if (help != null) Text(help, style: theme.textTheme.bodySmall),
        ],
      ),
    );

    final pregnant = o?.pregnant == true;
    final bleedingWhilePregnant =
        pregnant && _flow != null && _flow != CycleFlow.none;
    final week = o?.pregnancyStatus?.age.weeks;
    final showFetal = pregnant && (week == null || week >= 16);
    final customSymptoms = [
      for (final s in _symptoms)
        if (!CycleCatalog.isKnownSymptom(s)) s,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (_exists)
            IconButton(
              tooltip: l10n.commonDelete,
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: FilledButton.icon(
            key: const ValueKey('cycle-day-save'),
            onPressed: o == null ? null : _save,
            icon: const Icon(Icons.check),
            label: Text(l10n.commonSave),
          ),
        ),
      ),
      body: o == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              children: [
                heading(l10n.cycleFlowTitle),
                FlowSelector(
                  value: _flow,
                  onChanged: (f) => setState(() => _flow = f),
                ),
                if (bleedingWhilePregnant)
                  _CalmNote(text: l10n.cycleHintPregnancyBleeding),
                const SizedBox(height: 4),
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  initiallyExpanded: !_pbac.isEmpty,
                  title: Text(l10n.cyclePbacTitle),
                  subtitle: Text(
                    _pbac.isEmpty
                        ? l10n.cyclePbacSubtitle
                        : l10n.cyclePbacScore(_pbac.score),
                  ),
                  childrenPadding: const EdgeInsets.only(bottom: 8),
                  children: [
                    Text(
                      l10n.cyclePbacExplain,
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    for (final (i, key) in PbacCounts.keys.indexed)
                      CountStepper(
                        label: _pbacLabel(key, l10n),
                        subtitle: l10n.cyclePbacPoints(PbacCounts.points[i]),
                        value: _pbac.values[i],
                        onChanged: (v) =>
                            setState(() => _pbac = _pbac.withValue(key, v)),
                      ),
                  ],
                ),
                heading(l10n.cyclePainTitle),
                PainSlider(
                  value: _pain,
                  onChanged: (v) => setState(() => _pain = v),
                ),
                Text(
                  l10n.cyclePainLocations,
                  style: theme.textTheme.labelLarge,
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final t in CycleCatalog.painLocations)
                      FilterChip(
                        label: Text(t.localized),
                        selected: _locations.contains(t.key),
                        onSelected: (v) => setState(
                          () => v
                              ? _locations.add(t.key)
                              : _locations.remove(t.key),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.cyclePainkiller),
                  value: _painkiller,
                  onChanged: (v) => setState(() => _painkiller = v),
                ),
                if (_painkiller) ...[
                  TextField(
                    controller: _painkillerName,
                    decoration: InputDecoration(
                      labelText: l10n.cyclePainkillerName,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.cyclePainkillerHelped),
                  const SizedBox(height: 4),
                  SegmentedButton<bool?>(
                    showSelectedIcon: false,
                    segments: [
                      ButtonSegment(value: true, label: Text(l10n.commonYes)),
                      ButtonSegment(value: false, label: Text(l10n.commonNo)),
                      ButtonSegment(
                        value: null,
                        label: Text(l10n.cycleNoAnswer),
                      ),
                    ],
                    selected: {_helped},
                    onSelectionChanged: (s) =>
                        setState(() => _helped = s.first),
                  ),
                ],
                for (final group in CycleCatalog.symptomGroups(
                  menopause: o.menopauseTracking,
                  pregnancy: pregnant,
                )) ...[
                  heading(group.localizedTitle),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final t in group.terms)
                        FilterChip(
                          label: Text(t.localized),
                          selected: _symptoms.contains(t.key),
                          onSelected: (v) => setState(
                            () => v
                                ? _symptoms.add(t.key)
                                : _symptoms.remove(t.key),
                          ),
                        ),
                    ],
                  ),
                ],
                heading(l10n.cycleOtherSymptoms),
                if (customSymptoms.isNotEmpty)
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      for (final s in customSymptoms)
                        InputChip(
                          label: Text(s),
                          onDeleted: () => setState(() => _symptoms.remove(s)),
                        ),
                    ],
                  ),
                Autocomplete<String>(
                  optionsBuilder: (value) {
                    final q = value.text.trim().toLowerCase();
                    return CycleCatalog.localizedOtherSuggestions.where(
                      (s) =>
                          !_symptoms.contains(s) &&
                          (q.isEmpty || s.toLowerCase().contains(q)),
                    );
                  },
                  onSelected: _addOther,
                  fieldViewBuilder: (context, controller, focus, submit) =>
                      TextField(
                        controller: controller,
                        focusNode: focus,
                        decoration: InputDecoration(
                          labelText: l10n.cycleOtherHint,
                          suffixIcon: IconButton(
                            tooltip: l10n.cycleOtherAdd,
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              _addOther(controller.text);
                              controller.clear();
                            },
                          ),
                        ),
                        onSubmitted: (v) {
                          _addOther(v);
                          controller.clear();
                        },
                      ),
                ),
                heading(l10n.cycleDischargeTitle),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final t in CycleCatalog.discharge)
                      ChoiceChip(
                        label: Text(t.localized),
                        selected: _discharge == t.key,
                        onSelected: (v) =>
                            setState(() => _discharge = v ? t.key : null),
                      ),
                  ],
                ),
                if (o.menopauseTracking) ...[
                  heading(l10n.cycleMenopauseTitle),
                  CountStepper(
                    label: l10n.cycleHotFlashes,
                    value: _hotFlashes,
                    onChanged: (v) => setState(() => _hotFlashes = v),
                  ),
                  if (_hotFlashes > 0) ...[
                    Text(l10n.cycleHotFlashIntensity),
                    const SizedBox(height: 4),
                    _LevelChips(
                      labels: [
                        l10n.symptomBandMild,
                        l10n.symptomBandModerate,
                        l10n.symptomBandSevere,
                      ],
                      first: 1,
                      value: _hotFlashIntensity,
                      onChanged: (v) => setState(() => _hotFlashIntensity = v),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(l10n.cycleNightSweats),
                  const SizedBox(height: 4),
                  _LevelChips(
                    labels: [
                      l10n.symptomBandNone,
                      l10n.symptomBandMild,
                      l10n.symptomBandModerate,
                      l10n.symptomBandSevere,
                    ],
                    first: 0,
                    value: _nightSweats,
                    onChanged: (v) => setState(() => _nightSweats = v),
                  ),
                ],
                if (pregnant) ...[
                  heading(l10n.cyclePregnancyTitle),
                  if (showFetal) ...[
                    Text(l10n.cycleFetalMovement),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      children: [
                        for (final (m, label) in [
                          (FetalMovement.notYet, l10n.cycleFetalNotYet),
                          (FetalMovement.normal, l10n.cycleFetalNormal),
                          (FetalMovement.less, l10n.cycleFetalLess),
                        ])
                          ChoiceChip(
                            label: Text(label),
                            selected: _fetal == m,
                            onSelected: (v) =>
                                setState(() => _fetal = v ? m : null),
                          ),
                      ],
                    ),
                    if (_fetal == FetalMovement.less)
                      _CalmNote(text: l10n.cycleHintFetalMovement),
                    const SizedBox(height: 12),
                  ],
                  TextField(
                    controller: _weight,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      labelText: l10n.cycleWeight,
                      suffixText: AppUnits.current.weight.symbol,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _bpSys,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            labelText: l10n.cycleBpSystolic,
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text('/'),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _bpDia,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            labelText: l10n.cycleBpDiastolic,
                            suffixText: 'mmHg',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                heading(l10n.entityNote),
                TextField(
                  controller: _note,
                  minLines: 2,
                  maxLines: 6,
                  decoration: InputDecoration(hintText: l10n.cycleNoteHint),
                ),
              ],
            ),
    );
  }
}

String _pbacLabel(String key, AppLocalizations l10n) => switch (key) {
  'padsLight' => l10n.cyclePbacPadsLight,
  'padsMedium' => l10n.cyclePbacPadsMedium,
  'padsFull' => l10n.cyclePbacPadsFull,
  'tamponsLight' => l10n.cyclePbacTamponsLight,
  'tamponsMedium' => l10n.cyclePbacTamponsMedium,
  'tamponsFull' => l10n.cyclePbacTamponsFull,
  'clotsSmall' => l10n.cyclePbacClotsSmall,
  'clotsLarge' => l10n.cyclePbacClotsLarge,
  _ => l10n.cyclePbacFlooding,
};

class _LevelChips extends StatelessWidget {
  const _LevelChips({
    required this.labels,
    required this.first,
    required this.value,
    required this.onChanged,
  });

  final List<String> labels;
  final int first;
  final int? value;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 6,
    children: [
      for (final (i, label) in labels.indexed)
        ChoiceChip(
          label: Text(label),
          selected: value == first + i,
          onSelected: (v) => onChanged(v ? first + i : null),
        ),
    ],
  );
}

/// Ruhiger Hinweis (kein Alarm-Rot als Fläche).
class _CalmNote extends StatelessWidget {
  const _CalmNote({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(top: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.danger.withValues(alpha: 0.07),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.info_outline, size: 20, color: AppColors.danger),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    ),
  );
}
