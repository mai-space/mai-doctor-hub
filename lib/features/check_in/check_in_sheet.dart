import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/symptom_repository.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state.dart';

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
  final Map<String, double> _scales = {};
  final Set<String> _healed = {};

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
            return const SizedBox(
              height: 280,
              child: CustomScrollView(
                slivers: [
                  EmptyState(
                    icon: Icons.favorite_border,
                    title: 'Keine offenen Symptome',
                    message:
                        'Alle Symptome sind geheilt oder noch keines angelegt.',
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
                'Check-in',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Skala 1–10 oder als geheilt markieren.',
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
                    final value = _scales[symptom.id] ?? 5;
                    final healed = _healed.contains(symptom.id);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          symptom.label,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        if (symptom.bodyRegion != null)
                          Text(
                            symptom.bodyRegion!,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.muted),
                          ),
                        const SizedBox(height: 8),
                        if (!healed) ...[
                          Row(
                            children: [
                              Text('${value.round()}', style: Theme.of(context).textTheme.titleMedium),
                              Expanded(
                                child: Slider(
                                  value: value,
                                  min: 1,
                                  max: 10,
                                  divisions: 9,
                                  label: value.round().toString(),
                                  onChanged: (v) =>
                                      setState(() => _scales[symptom.id] = v),
                                ),
                              ),
                            ],
                          ),
                          TextButton.icon(
                            onPressed: () =>
                                setState(() => _healed.add(symptom.id)),
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('Geheilt'),
                          ),
                        ] else
                          const Text(
                            'Wird als geheilt gespeichert',
                            style: TextStyle(color: AppColors.accent),
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
                    final value = _scales[symptom.id] ?? 5;
                    await repo.addObservation(
                      symptomId: symptom.id,
                      kind: ObservationKind.scale_1_10,
                      valueNumber: value,
                    );
                  }
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Check-in gespeichert')),
                  );
                },
                child: const Text('Speichern'),
              ),
            ],
          );
        },
      ),
    );
  }
}
