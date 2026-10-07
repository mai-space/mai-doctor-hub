import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/cycle_repository.dart';
import '../../l10n/l10n.dart';
import '../../theme/app_theme.dart';
import 'cycle_home_card.dart' show openCyclePage;
import 'cycle_widgets.dart';

/// Einstellungen → Zyklus & Frauengesundheit: dieselben Bereiche wie im
/// Onboarding, damit auch Bestandsnutzerinnen sie einschalten können.
class CycleSettingsSection extends StatefulWidget {
  const CycleSettingsSection({super.key, required this.settings});

  final AppSetting settings;

  @override
  State<CycleSettingsSection> createState() => _CycleSettingsSectionState();
}

class _CycleSettingsSectionState extends State<CycleSettingsSection> {
  Stream<Doctor?>? _gynecologist;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final db = DatabaseScope.of(context);
    _gynecologist ??= db.watchWith({
      db.doctors,
    }, () => CycleRepository(db).gynecologist());
  }

  Future<void> _deleteAll() async {
    final l10n = context.l10n;
    final repo = CycleRepository(DatabaseScope.of(context));
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.cycleDeleteAllTitle),
        content: Text(l10n.cycleDeleteAllText),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.danger),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await repo.deleteAll();
    messenger.showSnackBar(SnackBar(content: Text(l10n.cycleDeleteAllDone)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final s = widget.settings;
    final repo = CycleRepository(DatabaseScope.of(context));
    final any = s.cycleTracking || s.menopauseTracking || s.pregnancyTracking;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.cycleSettingsTitle,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(l10n.cycleSettingsIntro, style: theme.textTheme.bodySmall),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          secondary: const Icon(Icons.water_drop_outlined),
          title: Text(l10n.cycleModeCycle),
          subtitle: Text(l10n.cycleModeCycleSubtitle),
          value: s.cycleTracking,
          onChanged: repo.setCycleTracking,
        ),
        if (s.cycleTracking)
          SwitchListTile(
            contentPadding: const EdgeInsets.only(left: 40),
            title: Text(l10n.cycleShowFertile),
            subtitle: Text(l10n.cycleShowFertileSubtitle),
            value: s.showFertileWindow,
            onChanged: repo.setShowFertileWindow,
          ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          secondary: const Icon(Icons.spa_outlined),
          title: Text(l10n.cycleModeMenopause),
          subtitle: Text(l10n.cycleModeMenopauseSubtitle),
          value: s.menopauseTracking,
          onChanged: repo.setMenopauseTracking,
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          secondary: const Icon(Icons.pregnant_woman),
          title: Text(l10n.cycleModePregnancy),
          subtitle: Text(l10n.cycleModePregnancySubtitle),
          value: s.pregnancyTracking,
          onChanged: repo.setPregnancyTracking,
        ),
        if (any)
          StreamBuilder<Doctor?>(
            stream: _gynecologist,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  snapshot.data != null) {
                return const SizedBox.shrink();
              }
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.person_add_alt_outlined),
                title: Text(l10n.cycleCreateGynecologist),
                subtitle: Text(l10n.cycleCreateGynecologistSubtitle),
                onTap: repo.ensureGynecologist,
              );
            },
          ),
        if (any)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.insights_outlined),
            title: Text(l10n.cycleOpen),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => openCyclePage(context),
          ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.delete_outline, color: AppColors.danger),
          title: Text(l10n.cycleDeleteAllTitle),
          subtitle: Text(l10n.cycleDeleteAllSubtitle),
          onTap: _deleteAll,
        ),
        const SizedBox(height: 4),
        const CyclePrivacyNote(),
      ],
    );
  }
}
