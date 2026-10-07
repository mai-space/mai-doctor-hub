import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/symptom_repository.dart';
import '../../data/symptom_description.dart';
import '../../data/symptom_measure.dart';
import '../../l10n/l10n.dart';
import '../../services/psych/psych_safety.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state.dart';
import '../psych/support_card.dart';
import 'measure_input.dart';
import 'symptom_description_composer.dart';

/// Bottom-Sheet für schnelle Symptom-Observations (Check-in).
///
/// Mit [symptomIds] (z. B. aus einer symptombezogenen Erinnerung) werden nur
/// diese Symptome gezeigt; leer = alle offenen.
Future<void> showCheckInSheet(
  BuildContext context, {
  List<String> symptomIds = const [],
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => CheckInSheet(symptomIds: symptomIds),
  );
}

/// v15: Eingaben eines Symptoms im Check-in — der Messwert steht im
/// Vordergrund; Beschreibung kommt aus dem Symptom („Details ändern“).
class _Entry {
  _Entry(this.symptom)
    : measures = symptomMeasures(symptom),
      description = SymptomDescription.fromSymptom(symptom) {
    value = measures.primary.initialValue;
    if (measures.primary == SymptomMeasure.bloodPressure) value2 = 80;
    journalOpen = isPsychSymptom(symptom);
  }

  final Symptom symptom;
  final MeasurePair measures;
  SymptomDescription description;
  late double value;
  double? value2;

  /// Zusatzwert (`null` = nicht erfasst).
  double? secondary;
  int? energy;
  double? sleepHours;
  int? anxiety;
  final journal = TextEditingController();
  bool detailsOpen = false;
  bool extrasOpen = false;
  late bool journalOpen;

  /// Wert schon angefasst — dann nicht mehr mit dem letzten Wert vorbelegen.
  bool touched = false;

  bool get needsSupport => checkInNeedsSupport(
    symptom: symptom,
    measure: measures.primary,
    value: value,
    journal: journal.text,
  );
}

class CheckInSheet extends StatefulWidget {
  const CheckInSheet({super.key, this.symptomIds = const []});

  final List<String> symptomIds;

  @override
  State<CheckInSheet> createState() => _CheckInSheetState();
}

class _CheckInSheetState extends State<CheckInSheet> {
  /// Eingaben je Symptom, vorbelegt aus dessen Standard-Beschreibung —
  /// ein schneller Check-in bleibt so ein Zug am Schieberegler.
  final Map<String, _Entry> _entries = {};
  final Set<String> _healed = {};

  @override
  void dispose() {
    for (final e in _entries.values) {
      e.journal.dispose();
    }
    super.dispose();
  }

  _Entry _entryFor(Symptom symptom, SymptomRepository repo) {
    final existing = _entries[symptom.id];
    if (existing != null) return existing;
    final entry = _entries[symptom.id] = _Entry(symptom);
    // Gemessene Größen (Temperatur, Gewicht …) mit dem letzten Wert
    // vorbelegen; Stärke, Anzahl, Dauer und Stimmung nicht.
    final m = entry.measures.primary;
    if (!{
      SymptomMeasure.intensity,
      SymptomMeasure.count,
      SymptomMeasure.duration,
      SymptomMeasure.mood,
    }.contains(m)) {
      repo.latestValue(symptom.id, m).then((last) {
        if (last == null || entry.touched || !mounted) return;
        setState(() {
          entry.value = last.$1;
          entry.value2 = last.$2 ?? entry.value2;
        });
      });
    }
    return entry;
  }

  @override
  Widget build(BuildContext context) {
    final db = DatabaseScope.of(context);
    final repo = SymptomRepository(db);
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 20 + bottom),
      child: StreamBuilder<List<Symptom>>(
        stream: repo.watchOpen(),
        builder: (context, snapshot) {
          final all = snapshot.data ?? const <Symptom>[];
          final symptoms = widget.symptomIds.isEmpty
              ? all
              : all.where((s) => widget.symptomIds.contains(s.id)).toList();
          if (symptoms.isEmpty) {
            return SizedBox(
              height: 280,
              child: CustomScrollView(
                slivers: [
                  EmptyState(
                    icon: Icons.favorite_border,
                    title: context.l10n.homeCheckInEmptyTitle,
                    message: context.l10n.homeCheckInEmptyMessage,
                  ),
                ],
              ),
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                context.l10n.homeCheckIn,
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.checkInHintMeasure,
                style: Theme.of(context).textTheme.bodyMedium
                    ?.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: symptoms.length,
                  separatorBuilder: (_, _) => const Divider(height: 24),
                  itemBuilder: (context, index) {
                    final symptom = symptoms[index];
                    final entry = _entryFor(symptom, repo);
                    final healed = _healed.contains(symptom.id);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          symptom.label,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        if (!healed) ...[
                          _EntryEditor(
                            entry: entry,
                            onChanged: () => setState(() {}),
                          ),
                          TextButton.icon(
                            onPressed: () =>
                                setState(() => _healed.add(symptom.id)),
                            icon: const Icon(Icons.check_circle_outline),
                            label: Text(context.l10n.homeCheckInHealed),
                          ),
                        ] else
                          Text(
                            context.l10n.homeCheckInWillBeHealed,
                            style: const TextStyle(color: AppColors.accent),
                          ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () async {
                  var support = false;
                  for (final symptom in symptoms) {
                    if (_healed.contains(symptom.id)) {
                      await repo.markHealed(symptom.id);
                      continue;
                    }
                    final e = _entryFor(symptom, repo);
                    final d = e.description;
                    support = support || e.needsSupport;
                    final mood = e.measures.primary == SymptomMeasure.mood;
                    await repo.addMeasurement(
                      symptomId: symptom.id,
                      measure: e.measures.primary,
                      value: e.value,
                      value2: e.value2,
                      measure2: e.measures.secondary,
                      secondaryValue: e.secondary,
                      energy: mood ? e.energy : null,
                      sleepHours: mood ? e.sleepHours : null,
                      anxiety: mood ? e.anxiety : null,
                      journal: e.journal.text,
                      sensation: d.sensation,
                      quality: d.qualityText,
                      location: d.location,
                      side: d.side,
                      pattern: d.patternText,
                    );
                  }
                  if (!context.mounted) return;
                  final saved = context.l10n.homeCheckInSaved;
                  final navigator = Navigator.of(context);
                  final messenger = ScaffoldMessenger.of(context);
                  final parent = navigator.context;
                  navigator.pop();
                  messenger.showSnackBar(SnackBar(content: Text(saved)));
                  // Ruhiges Hilfsangebot auch nach dem Schließen.
                  if (support && parent.mounted) {
                    await showSupportDialog(parent);
                  }
                },
                child: Text(context.l10n.commonSave),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _EntryEditor extends StatelessWidget {
  const _EntryEditor({required this.entry, required this.onChanged});

  final _Entry entry;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final e = entry;
    final primary = e.measures.primary;
    final secondary = e.measures.secondary;
    // Vorschau inkl. Stärke, wie bisher („Schmerz · Hinterkopf (links) ·
    // 5/10 mittel“).
    final preview = primary == SymptomMeasure.intensity
        ? e.description.copyWith(intensity: () => e.value)
        : e.description;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MeasureInput(
          measure: primary,
          value: e.value,
          value2: e.value2,
          onChanged: (v, v2) {
            e
              ..value = v
              ..value2 = v2 ?? e.value2
              ..touched = true;
            onChanged();
          },
        ),
        if (secondary != null) ...[
          const SizedBox(height: 8),
          if (e.secondary == null)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () {
                  e.secondary = secondary.initialValue;
                  onChanged();
                },
                icon: const Icon(Icons.add),
                label: Text(l10n.measureAdd(measureLabel(secondary, l10n))),
              ),
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: MeasureInput(
                    measure: secondary,
                    value: e.secondary!,
                    onChanged: (v, _) {
                      e.secondary = v;
                      onChanged();
                    },
                  ),
                ),
                IconButton(
                  tooltip: l10n.measureRemove,
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    e.secondary = null;
                    onChanged();
                  },
                ),
              ],
            ),
        ],
        if (primary == SymptomMeasure.mood) ...[
          _Toggle(
            icon: Icons.bolt_outlined,
            label: l10n.moodExtras,
            open: e.extrasOpen,
            onPressed: () {
              e.extrasOpen = !e.extrasOpen;
              onChanged();
            },
          ),
          if (e.extrasOpen)
            MoodExtrasInput(
              energy: e.energy,
              sleepHours: e.sleepHours,
              anxiety: e.anxiety,
              onChanged: (energy, sleep, anxiety) {
                e
                  ..energy = energy
                  ..sleepHours = sleep
                  ..anxiety = anxiety;
                onChanged();
              },
            ),
        ],
        Wrap(
          children: [
            _Toggle(
              icon: Icons.tune,
              label: l10n.checkInDetails,
              open: e.detailsOpen,
              onPressed: () {
                e.detailsOpen = !e.detailsOpen;
                onChanged();
              },
            ),
            _Toggle(
              icon: Icons.edit_note,
              label: l10n.journalAdd,
              open: e.journalOpen,
              onPressed: () {
                e.journalOpen = !e.journalOpen;
                onChanged();
              },
            ),
          ],
        ),
        if (e.detailsOpen)
          SymptomDescriptionComposer(
            value: preview,
            onChanged: (v) {
              e.description = v.copyWith(intensity: () => null);
              onChanged();
            },
            showIntensity: false,
          ),
        if (e.journalOpen) ...[
          const SizedBox(height: 4),
          TextField(
            key: ValueKey('journal-${e.symptom.id}'),
            controller: e.journal,
            minLines: 2,
            maxLines: 6,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: l10n.journalHint,
              border: const OutlineInputBorder(),
            ),
            onChanged: (_) => onChanged(),
          ),
          const SizedBox(height: 4),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: [
              for (final prompt in [
                l10n.journalPromptHelped,
                l10n.journalPromptBurden,
                l10n.journalPromptGrateful,
              ])
                ActionChip(
                  label: Text(prompt),
                  onPressed: () {
                    final text = e.journal.text.trimRight();
                    e.journal.text = text.isEmpty
                        ? '$prompt '
                        : '$text\n$prompt ';
                    onChanged();
                  },
                ),
            ],
          ),
          Text(
            l10n.journalPrivacy,
            style: theme.textTheme.bodySmall?.copyWith(color: AppColors.muted),
          ),
        ],
        if (e.needsSupport) ...[const SizedBox(height: 8), const SupportCard()],
      ],
    );
  }
}

class _Toggle extends StatelessWidget {
  const _Toggle({
    required this.icon,
    required this.label,
    required this.open,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final bool open;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => TextButton.icon(
    onPressed: onPressed,
    icon: Icon(open ? Icons.expand_less : icon, size: 18),
    label: Text(label),
  );
}
