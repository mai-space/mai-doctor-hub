import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/symptom_repository.dart';
import '../../data/symptom_description.dart';
import '../../l10n/l10n.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state.dart';
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

class CheckInSheet extends StatefulWidget {
  const CheckInSheet({super.key, this.symptomIds = const []});

  final List<String> symptomIds;

  @override
  State<CheckInSheet> createState() => _CheckInSheetState();
}

class _CheckInSheetState extends State<CheckInSheet> {
  /// Beschreibung je Symptom, vorbelegt aus dessen Standard-Beschreibung —
  /// ein schneller Check-in bleibt so ein Zug am Schieberegler.
  final Map<String, SymptomDescription> _descriptions = {};
  final Set<String> _healed = {};

  SymptomDescription _descriptionFor(Symptom symptom) =>
      _descriptions[symptom.id] ??= SymptomDescription.fromSymptom(
        symptom,
      ).copyWith(intensity: () => 5);

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
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                context.l10n.symptomCheckInHint,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: symptoms.length,
                  separatorBuilder: (_, _) => const Divider(height: 24),
                  itemBuilder: (context, index) {
                    final symptom = symptoms[index];
                    final description = _descriptionFor(symptom);
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
                          SymptomDescriptionComposer(
                            value: description,
                            onChanged: (v) =>
                                setState(() => _descriptions[symptom.id] = v),
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
                  for (final symptom in symptoms) {
                    if (_healed.contains(symptom.id)) {
                      await repo.markHealed(symptom.id);
                      continue;
                    }
                    final d = _descriptionFor(symptom);
                    await repo.addObservation(
                      symptomId: symptom.id,
                      kind: ObservationKind.scale_1_10,
                      valueNumber: d.intensity,
                      sensation: d.sensation,
                      quality: d.qualityText,
                      location: d.location,
                      side: d.side,
                      pattern: d.patternText,
                    );
                  }
                  if (!context.mounted) return;
                  final saved = context.l10n.homeCheckInSaved;
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(saved)),
                  );
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
