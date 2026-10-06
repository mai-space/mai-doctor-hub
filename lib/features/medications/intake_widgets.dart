import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/medication_repository.dart';
import '../../l10n/l10n.dart';

/// „Medikamente heute“: geplante Einnahmen abhaken oder auslassen.
Future<void> showTodayMedicationsSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => const _TodaySheet(),
    );

class _TodaySheet extends StatefulWidget {
  const _TodaySheet();

  @override
  State<_TodaySheet> createState() => _TodaySheetState();
}

class _TodaySheetState extends State<_TodaySheet> {
  Stream<List<PlannedDose>>? _doses;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _doses ??= MedicationRepository(
      DatabaseScope.of(context),
    ).watchDosesOn(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final repo = MedicationRepository(DatabaseScope.of(context));
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: StreamBuilder<List<PlannedDose>>(
        stream: _doses,
        builder: (context, snapshot) {
          final doses = snapshot.data ?? const <PlannedDose>[];
          final open = doses.where((d) => !d.done).length;
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.homeMedsTodayTitle,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                doses.isEmpty
                    ? l10n.homeMedsTodayNone
                    : open == 0
                    ? l10n.homeMedsTodayAllDone
                    : l10n.homeMedsTodayOpen(open, doses.length),
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final dose in doses)
                      DoseTile(
                        dose: dose,
                        onTaken: () => repo.recordIntake(
                          medicationId: dose.details.medication.id,
                          scheduledFor: dose.at,
                          doseAmount:
                              dose.schedule.doseAmount ??
                              dose.details.medication.doseAmount,
                        ),
                        onSkipped: () => repo.recordIntake(
                          medicationId: dose.details.medication.id,
                          scheduledFor: dose.at,
                          status: IntakeStatus.skipped,
                        ),
                        onUndo: () => repo.deleteIntake(dose.intake!.id),
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class DoseTile extends StatelessWidget {
  const DoseTile({
    super.key,
    required this.dose,
    required this.onTaken,
    required this.onSkipped,
    required this.onUndo,
  });

  final PlannedDose dose;
  final VoidCallback onTaken;
  final VoidCallback onSkipped;
  final VoidCallback onUndo;

  @override
  Widget build(BuildContext context) {
    final m = dose.details.medication;
    final l10n = context.l10n;
    final time = DateFormat(l10n.homeTimePattern).format(dose.at);
    final intake = dose.intake;
    final subtitle = [
      ?dose.details.doseFor(dose.schedule),
      if (m.instructions?.isNotEmpty == true) m.instructions!,
    ].join(' · ');
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(child: Text(time, style: const TextStyle(fontSize: 11))),
      title: Text(m.name),
      subtitle: subtitle.isEmpty ? null : Text(subtitle),
      trailing: intake == null
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: l10n.homeIntakeSkipped,
                  icon: const Icon(Icons.close),
                  onPressed: onSkipped,
                ),
                IconButton.filledTonal(
                  tooltip: l10n.homeIntakeTaken,
                  icon: const Icon(Icons.check),
                  onPressed: onTaken,
                ),
              ],
            )
          : TextButton.icon(
              onPressed: onUndo,
              icon: Icon(
                intake.status == IntakeStatus.taken
                    ? Icons.check_circle
                    : Icons.remove_circle_outline,
              ),
              label: Text(
                intake.status == IntakeStatus.taken
                    ? l10n.homeIntakeTakenShort
                    : l10n.homeIntakeSkipped,
              ),
            ),
    );
  }
}

/// Aus einer Erinnerung: Einnahme bestätigen. Wiederkehrende Erinnerungen
/// tragen nur die Uhrzeit — der Zeitpunkt wird dann auf heute bezogen.
Future<void> showIntakeConfirmDialog(
  BuildContext context,
  String medicationId,
  DateTime scheduledFor,
) async {
  final repo = MedicationRepository(DatabaseScope.of(context));
  final details = await repo.get(medicationId);
  if (details == null || !context.mounted) return;
  final now = DateTime.now();
  final at = scheduledFor.year < 2000
      ? DateTime(now.year, now.month, now.day, scheduledFor.hour, scheduledFor.minute)
      : scheduledFor;
  final schedule = details.schedules
      .where((s) => s.hour == at.hour && s.minute == at.minute)
      .firstOrNull;
  final result = await showDialog<IntakeStatus>(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(Icons.medication_outlined),
      title: Text(details.medication.name),
      content: Text(
        [
          context.l10n.homeIntakePlannedAt(
            DateFormat(context.l10n.homeTimePattern).format(at),
          ),
          ?details.doseFor(schedule),
          if (details.medication.instructions?.isNotEmpty == true)
            details.medication.instructions!,
        ].join(' · '),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, IntakeStatus.skipped),
          child: Text(context.l10n.homeIntakeSkipped),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, IntakeStatus.taken),
          child: Text(context.l10n.homeIntakeTaken),
        ),
      ],
    ),
  );
  if (result == null) return;
  await repo.recordIntake(
    medicationId: medicationId,
    scheduledFor: at,
    status: result,
    doseAmount: result == IntakeStatus.taken
        ? schedule?.doseAmount ?? details.medication.doseAmount
        : null,
  );
}
