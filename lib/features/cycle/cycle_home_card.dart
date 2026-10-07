import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/cycle_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../l10n/l10n.dart';
import '../../services/cycle/cycle_text.dart';
import 'cycle_page.dart';

void openCyclePage(BuildContext context, {int tab = 0}) => Navigator.of(context)
    .push(MaterialPageRoute<void>(builder: (_) => CyclePage(initialTab: tab)));

/// Startseite: Status von heute (Zyklustag, SSW, Wechseljahre). Unsichtbar,
/// solange kein Bereich eingeschaltet ist.
class CycleHomeCard extends StatefulWidget {
  const CycleHomeCard({super.key});

  @override
  State<CycleHomeCard> createState() => _CycleHomeCardState();
}

class _CycleHomeCardState extends State<CycleHomeCard> {
  Stream<CycleOverview>? _stream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _stream ??= CycleRepository(DatabaseScope.of(context)).watchOverview();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CycleOverview>(
      stream: _stream,
      builder: (context, snapshot) {
        final o = snapshot.data;
        if (o == null || !o.enabled) return const SizedBox.shrink();
        final theme = Theme.of(context);
        final l10n = context.l10n;
        final lines = cycleStatusLines(o, l10n);
        final urgent = o.analysis.hints.any((h) => h.urgent);
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Card(
            key: const ValueKey('cycle-home-card'),
            margin: EdgeInsets.zero,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => openCyclePage(context),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: theme.colorScheme.primaryContainer,
                      child: Icon(
                        o.pregnant
                            ? Icons.pregnant_woman
                            : Icons.water_drop_outlined,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.cycleTitle,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          for (final line in lines)
                            Text(line, style: theme.textTheme.bodyMedium),
                          if (urgent)
                            Text(
                              l10n.cycleHintsUrgentTitle,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.error,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Eintrag „Zyklus“ in der Akte (nur bei eingeschaltetem Bereich).
class CycleRecordsTile extends StatelessWidget {
  const CycleRecordsTile({super.key});

  @override
  Widget build(BuildContext context) {
    final db = DatabaseScope.of(context);
    return StreamBuilder<AppSetting>(
      stream: SettingsRepository(db).watch(),
      builder: (context, snapshot) {
        final s = snapshot.data;
        if (s == null ||
            !(s.cycleTracking || s.menopauseTracking || s.pregnancyTracking)) {
          return const SizedBox.shrink();
        }
        final theme = Theme.of(context);
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: ListTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            tileColor: theme.colorScheme.surface,
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Icon(
                Icons.water_drop_outlined,
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            title: Text(context.l10n.cycleTitle),
            subtitle: Text(context.l10n.cycleRecordsSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => openCyclePage(context, tab: 2),
          ),
        );
      },
    );
  }
}
