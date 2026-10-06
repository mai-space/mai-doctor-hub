import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/suggestion_repository.dart';
import '../../data/repositories/symptom_repository.dart';
import '../../data/symptom_description.dart';
import '../../data/symptom_descriptors.dart';
import '../../l10n/l10n.dart';

/// Baukasten aus Empfindung, Charakter, Ort, Seite, Verlauf und Stärke:
/// antippbare Bausteine (Auswahl-Sheet mit Suche und Liste), Schieberegler
/// 0–10 mit verbalem Anker und eine Vorschau als Satz.
///
/// Im Check-in mit Stärke und Vorschau; im Symptom-Formular nur die
/// Standard-Beschreibung (Ort steht dort im Feld „Körperregion“).
class SymptomDescriptionComposer extends StatelessWidget {
  const SymptomDescriptionComposer({
    super.key,
    required this.value,
    required this.onChanged,
    this.showLocation = true,
    this.showPattern = true,
    this.showIntensity = true,
    this.showPreview = true,
  });

  final SymptomDescription value;
  final ValueChanged<SymptomDescription> onChanged;
  final bool showLocation;
  final bool showPattern;
  final bool showIntensity;
  final bool showPreview;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final intensity = value.intensity;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: [
            _PartChip(
              icon: Icons.bolt_outlined,
              field: l10n.symptomSensation,
              value: value.sensation,
              onPressed: () => _pick(
                context,
                DescriptorField.sensation,
                title: l10n.symptomSensation,
                groups: SymptomDescriptors.sensations,
                selected: [?value.sensation],
                apply: (v) => value.copyWith(sensation: () => v.firstOrNull),
              ),
            ),
            _PartChip(
              icon: Icons.tune,
              field: l10n.symptomQuality,
              value: SymptomDescription.joinList(value.qualities),
              onPressed: () => _pick(
                context,
                DescriptorField.quality,
                title: l10n.symptomQuality,
                groups: SymptomDescriptors.qualitiesFor(value.sensation),
                selected: value.qualities,
                multiple: true,
                apply: (v) => value.copyWith(qualities: v),
              ),
            ),
            if (showLocation)
              _PartChip(
                icon: Icons.place_outlined,
                field: l10n.symptomLocation,
                value: value.location,
                onPressed: () => _pick(
                  context,
                  DescriptorField.location,
                  title: l10n.symptomLocation,
                  groups: SymptomDescriptors.locations,
                  selected: [?value.location],
                  apply: (v) => value.copyWith(location: () => v.firstOrNull),
                ),
              ),
            _PartChip(
              icon: Icons.swap_horiz,
              field: l10n.symptomSide,
              value: value.side == null
                  ? null
                  : bodySideLabel(value.side!, l10n),
              onPressed: () async {
                final picked = await showBodySidePicker(context, value.side);
                if (picked == null) return;
                onChanged(value.copyWith(side: () => picked.side));
              },
            ),
            if (showPattern)
              _PartChip(
                icon: Icons.schedule,
                field: l10n.symptomPattern,
                value: SymptomDescription.joinList(value.patterns),
                onPressed: () => _pick(
                  context,
                  DescriptorField.pattern,
                  title: l10n.symptomPattern,
                  groups: SymptomDescriptors.patterns,
                  selected: value.patterns,
                  multiple: true,
                  apply: (v) => value.copyWith(patterns: v),
                ),
              ),
          ],
        ),
        if (showIntensity && intensity != null) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              SizedBox(
                width: 28,
                child: Text(
                  '${intensity.round()}',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Expanded(
                child: Slider(
                  value: intensity.clamp(0, 10).toDouble(),
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: intensityText(intensity, l10n),
                  semanticFormatterCallback: (v) => intensityText(v, l10n),
                  onChanged: (v) =>
                      onChanged(value.copyWith(intensity: () => v)),
                ),
              ),
            ],
          ),
          Text(
            '${intensityText(intensity, l10n)} — '
            '${intensityAnchor(intensity, l10n)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
        if (showPreview) ...[
          const SizedBox(height: 8),
          _Preview(text: value.describe(l10n)),
        ],
      ],
    );
  }

  Future<void> _pick(
    BuildContext context,
    DescriptorField field, {
    required String title,
    required List<LocalizedGroup> groups,
    required List<String> selected,
    required SymptomDescription Function(List<String> values) apply,
    bool multiple = false,
  }) async {
    final recent = await SymptomRepository(DatabaseScope.of(context))
        .usedDescriptors(field);
    if (!context.mounted) return;
    final picked = await showDescriptorPicker(
      context,
      title: title,
      groups: groups,
      recent: recent,
      selected: selected,
      multiple: multiple,
    );
    if (picked != null) onChanged(apply(picked));
  }
}

class _PartChip extends StatelessWidget {
  const _PartChip({
    required this.icon,
    required this.field,
    required this.value,
    required this.onPressed,
  });

  final IconData icon;
  final String field;
  final String? value;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final set = value != null;
    return ActionChip(
      avatar: Icon(set ? icon : Icons.add, size: 18),
      label: Text(value ?? field),
      tooltip: field,
      backgroundColor: set ? scheme.secondaryContainer : null,
      side: set ? BorderSide.none : null,
      onPressed: onPressed,
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.short_text,
            size: 18,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

/// Seite wählen; `null` = abgebrochen, `(side: null)` = keine Angabe.
Future<({BodySide? side})?> showBodySidePicker(
  BuildContext context,
  BodySide? current,
) {
  final l10n = context.l10n;
  return showModalBottomSheet<({BodySide? side})>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final side in [...BodySide.values, null])
            ListTile(
              leading: Icon(
                side == current
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
              ),
              title: Text(
                side == null ? l10n.symptomSideNone : bodySideLabel(side, l10n),
              ),
              onTap: () => Navigator.pop(context, (side: side)),
            ),
        ],
      ),
    ),
  );
}

/// Auswahl-Sheet: Suchfeld (Freitext erlaubt) und gruppierte Liste „zum
/// Reflektieren“. Liefert die neue Auswahl (leer = entfernt) oder `null`
/// bei Abbruch. Mit [multiple] werden Einträge an- und abgewählt und mit
/// „Übernehmen“ bestätigt; sonst übernimmt ein Tipp sofort.
Future<List<String>?> showDescriptorPicker(
  BuildContext context, {
  required String title,
  required List<LocalizedGroup> groups,
  List<String> recent = const [],
  List<String> selected = const [],
  bool multiple = false,
}) {
  return showModalBottomSheet<List<String>>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _DescriptorPicker(
      title: title,
      groups: groups,
      recent: recent,
      selected: selected,
      multiple: multiple,
    ),
  );
}

class _DescriptorPicker extends StatefulWidget {
  const _DescriptorPicker({
    required this.title,
    required this.groups,
    required this.recent,
    required this.selected,
    required this.multiple,
  });

  final String title;
  final List<LocalizedGroup> groups;
  final List<String> recent;
  final List<String> selected;
  final bool multiple;

  @override
  State<_DescriptorPicker> createState() => _DescriptorPickerState();
}

class _DescriptorPickerState extends State<_DescriptorPicker> {
  final _search = TextEditingController();
  late final List<String> _selected = [...widget.selected];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  bool _isSelected(String value) {
    final key = SuggestionRepository.normalize(value);
    return _selected.any((s) => SuggestionRepository.normalize(s) == key);
  }

  void _choose(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;
    if (!widget.multiple) {
      Navigator.pop(context, [trimmed]);
      return;
    }
    setState(() {
      if (_isSelected(trimmed)) {
        final key = SuggestionRepository.normalize(trimmed);
        _selected.removeWhere((s) => SuggestionRepository.normalize(s) == key);
      } else {
        _selected.add(trimmed);
      }
      _search.clear();
    });
  }

  /// Treffer: Wortanfänge zuerst, dann irgendwo im Wort; ohne Doppelte.
  List<String> _matches(String query) {
    final q = SuggestionRepository.normalize(query.trim());
    final seen = <String>{};
    final prefix = <String>[];
    final contains = <String>[];
    for (final value in [
      ...widget.recent,
      ...SymptomDescriptors.flat(widget.groups),
    ]) {
      final text = SuggestionRepository.normalize(value);
      if (!seen.add(text)) continue;
      if (text.split(RegExp(r'[\s,/()-]+')).any((w) => w.startsWith(q))) {
        prefix.add(value);
      } else if (text.contains(q)) {
        contains.add(value);
      }
    }
    return [...prefix, ...contains];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final query = _search.text.trim();
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    final height = MediaQuery.sizeOf(context).height * 0.8;

    Widget chip(String value) {
      final selected = _isSelected(value);
      return widget.multiple
          ? FilterChip(
              label: Text(value),
              selected: selected,
              onSelected: (_) => _choose(value),
            )
          : ChoiceChip(
              label: Text(value),
              selected: selected,
              onSelected: (_) => _choose(value),
            );
    }

    Widget group(String title, List<String> items) => Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [for (final item in items) chip(item)],
          ),
        ],
      ),
    );

    final List<Widget> content;
    if (query.isEmpty) {
      content = [
        Text(
          l10n.symptomPickerReflect,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        if (widget.recent.isNotEmpty)
          group(l10n.symptomPickerRecent, widget.recent),
        for (final g in widget.groups) group(g.title, g.items),
      ];
    } else {
      final matches = _matches(query);
      final exact = matches.any(
        (m) =>
            SuggestionRepository.normalize(m) ==
            SuggestionRepository.normalize(query),
      );
      content = [
        if (!exact)
          ListTile(
            leading: const Icon(Icons.add),
            title: Text(l10n.symptomPickerUseCustom(query)),
            onTap: () => _choose(query),
          ),
        for (final m in matches)
          ListTile(
            leading: Icon(
              _isSelected(m) ? Icons.check_box : Icons.check_box_outline_blank,
            ),
            title: Text(m),
            onTap: () => _choose(m),
          ),
      ];
    }

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SizedBox(
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (widget.multiple)
                    Text(
                      l10n.symptomPickerMultiHint,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _search,
                    decoration: InputDecoration(
                      hintText: l10n.symptomPickerSearchHint,
                      prefixIcon: const Icon(Icons.search),
                      isDense: true,
                    ),
                    textCapitalization: TextCapitalization.none,
                    onChanged: (_) => setState(() {}),
                    onSubmitted: _choose,
                  ),
                  if (widget.multiple && _selected.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final s in _selected)
                          InputChip(
                            label: Text(s),
                            onDeleted: () =>
                                setState(() => _selected.remove(s)),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                children: content,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, const <String>[]),
                    child: Text(l10n.symptomPickerClear),
                  ),
                  const Spacer(),
                  if (widget.multiple)
                    FilledButton(
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(120, 48),
                      ),
                      onPressed: () => Navigator.pop(context, _selected),
                      child: Text(l10n.symptomPickerApply),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
