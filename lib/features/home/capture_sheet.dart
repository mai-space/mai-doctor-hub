import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/repositories/symptom_repository.dart';
import '../../data/symptom_measure.dart';
import '../../l10n/l10n.dart';
import '../../widgets/symptom_media_section.dart';
import '../check_in/check_in_sheet.dart';
import '../cycle/cycle_day_page.dart';
import '../records/entity_forms.dart';
import 'add_appointment_sheet.dart';

/// Aktionen im „Erfassen“-Sheet der Startseite.
enum CaptureAction {
  checkIn,
  symptom,
  scan,
  file,
  media,
  appointment,
  journal,
  period,
}

/// Öffnet „Erfassen“: ruhiges Raster mit allen Einstiegen (höchstens zwei
/// Reihen à vier) und startet danach den gewählten, bestehenden Ablauf.
Future<void> showCaptureSheet(BuildContext context) async {
  final action = await showModalBottomSheet<CaptureAction>(
    context: context,
    showDragHandle: true,
    builder: (context) => const CaptureSheet(),
  );
  if (action == null || !context.mounted) return;
  await runCaptureAction(context, action);
}

/// Startet den Ablauf zu [action] (nach dem Schließen des Sheets).
Future<void> runCaptureAction(
  BuildContext context,
  CaptureAction action,
) async {
  switch (action) {
    case CaptureAction.checkIn:
      await showCheckInSheet(context);
    case CaptureAction.symptom:
      await showSymptomForm(context);
    case CaptureAction.scan:
      await scanReport(context);
    case CaptureAction.file:
      await pickReportFile(context);
    case CaptureAction.media:
      await _captureMedia(context);
    case CaptureAction.appointment:
      final messenger = ScaffoldMessenger.of(context);
      final saved = context.l10n.homeAppointmentSaved;
      final id = await showAddAppointmentSheet(context);
      if (id != null) {
        messenger.showSnackBar(SnackBar(content: Text(saved)));
      }
    case CaptureAction.journal:
      await _openJournal(context);
    case CaptureAction.period:
      final now = DateTime.now();
      await openCycleDay(context, DateTime(now.year, now.month, now.day));
  }
}

/// Beleg: erst das Symptom wählen (oder neu anlegen), dann aufnehmen.
Future<void> _captureMedia(BuildContext context) async {
  final repo = SymptomRepository(DatabaseScope.of(context));
  final l10n = context.l10n;
  final open = await repo.watchOpen().first;
  if (!context.mounted) return;
  // `''` = neues Symptom anlegen.
  final picked = await showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.7,
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Text(
                l10n.homeCaptureMediaPickTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            for (final s in open)
              ListTile(
                leading: const Icon(Icons.healing_outlined),
                title: Text(s.label),
                onTap: () => Navigator.pop(context, s.id),
              ),
            ListTile(
              leading: const Icon(Icons.add),
              title: Text(l10n.homeCaptureMediaNewSymptom),
              onTap: () => Navigator.pop(context, ''),
            ),
          ],
        ),
      ),
    ),
  );
  if (picked == null || !context.mounted) return;
  final id = picked.isEmpty ? await showSymptomForm(context) : picked;
  if (id == null || !context.mounted) return;
  final symptom = await repo.getById(id);
  if (symptom == null || !context.mounted) return;
  await showSymptomMediaCapture(
    context,
    symptomId: id,
    title: l10n.homeCaptureMediaKindTitle(symptom.label),
  );
}

/// Tagebuch: Check-in der psychischen Symptome (dort ist das Tagebuch
/// aufgeklappt). Gibt es keines, wird „Stimmung“ nach Rückfrage angelegt.
Future<void> _openJournal(BuildContext context) async {
  final repo = SymptomRepository(DatabaseScope.of(context));
  final l10n = context.l10n;
  final psych = (await repo.watchOpen().first).where(isPsychSymptom).toList();
  if (!context.mounted) return;
  if (psych.isNotEmpty) {
    await showCheckInSheet(context, symptomIds: [for (final s in psych) s.id]);
    return;
  }
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.homeCaptureJournalCreateTitle),
      content: Text(l10n.homeCaptureJournalCreateBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.commonCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(l10n.homeCaptureJournalCreate),
        ),
      ],
    ),
  );
  if (ok != true || !context.mounted) return;
  final id = await repo.create(
    label: l10n.homeCaptureJournalSymptomLabel,
    measures: (primary: SymptomMeasure.mood, secondary: null),
  );
  if (!context.mounted) return;
  await showCheckInSheet(context, symptomIds: [id]);
}

/// Inhalt des „Erfassen“-Sheets; schließt mit der gewählten [CaptureAction].
class CaptureSheet extends StatefulWidget {
  const CaptureSheet({super.key});

  @override
  State<CaptureSheet> createState() => _CaptureSheetState();
}

class _CaptureSheetState extends State<CaptureSheet> {
  Stream<AppSetting>? _settings;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settings ??= SettingsRepository(DatabaseScope.of(context)).watch();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: StreamBuilder<AppSetting>(
          stream: _settings,
          builder: (context, snapshot) {
            final cycle = snapshot.data?.cycleTracking ?? false;
            final items = [
              (
                CaptureAction.checkIn,
                Icons.favorite_outline,
                l10n.homeCaptureCheckIn,
              ),
              (
                CaptureAction.symptom,
                Icons.healing_outlined,
                l10n.homeCaptureSymptom,
              ),
              (
                CaptureAction.scan,
                Icons.document_scanner_outlined,
                l10n.homeCaptureScan,
              ),
              (CaptureAction.file, Icons.upload_file, l10n.homeCaptureFile),
              (
                CaptureAction.media,
                Icons.perm_media_outlined,
                l10n.homeCaptureMedia,
              ),
              (
                CaptureAction.appointment,
                Icons.event_outlined,
                l10n.homeCaptureAppointment,
              ),
              (CaptureAction.journal, Icons.edit_note, l10n.homeCaptureJournal),
              if (cycle)
                (
                  CaptureAction.period,
                  Icons.water_drop_outlined,
                  l10n.homeCapturePeriod,
                ),
            ];
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    l10n.homeCaptureTitle,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 2, 8, 16),
                  child: Text(
                    l10n.homeCaptureHint,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 4,
                  childAspectRatio: 0.8,
                  children: [
                    for (final (action, icon, label) in items)
                      _CaptureTile(
                        key: ValueKey('capture-${action.name}'),
                        icon: icon,
                        label: label,
                        onTap: () => Navigator.pop(context, action),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _CaptureTile extends StatelessWidget {
  const _CaptureTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: scheme.onPrimaryContainer, size: 28),
          ),
          const SizedBox(height: 6),
          // Flexible: bei großer Schrift kürzen statt überlaufen.
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ],
      ),
    );
  }
}
