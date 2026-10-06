import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../data/database_provider.dart';
import '../../data/repositories/archive_repository.dart';
import '../../l10n/l10n.dart';

String? _typeLabel(AppLocalizations l10n, String type) => switch (type) {
  'doctor' => l10n.entityDoctor,
  'diagnosis' => l10n.entityDiagnosis,
  'symptom' => l10n.entitySymptom,
  'appointment' => l10n.entityAppointment,
  'report' => l10n.entityReport,
  'medication' => l10n.entityMedication,
  'note' => l10n.entityNote,
  'pharmacy' => l10n.entityPharmacy,
  'vaccination' => l10n.entityVaccination,
  _ => null,
};

const _typeIcons = {
  'doctor': Icons.medical_services_outlined,
  'diagnosis': Icons.biotech_outlined,
  'symptom': Icons.healing_outlined,
  'appointment': Icons.event_outlined,
  'report': Icons.description_outlined,
  'medication': Icons.medication_outlined,
  'note': Icons.sticky_note_2_outlined,
  'pharmacy': Icons.local_pharmacy_outlined,
  'vaccination': Icons.vaccines_outlined,
};

/// Löschen = archivieren, mit „Rückgängig“. Gibt `true` zurück, wenn
/// archiviert wurde (Detailseite schließt sich dann).
Future<bool> archiveWithUndo(
  BuildContext context,
  String type,
  String id, {
  String? label,
}) async {
  final repo = ArchiveRepository(DatabaseScope.of(context));
  final messenger = ScaffoldMessenger.of(context);
  final l10n = context.l10n;
  try {
    await repo.archive(type, id);
  } on ArchiveBlocked catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(e.message)));
    return false;
  }
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          l10n.settingsArchiveSnack(
            label ?? _typeLabel(l10n, type) ?? l10n.entityEntry,
          ),
        ),
        duration: const Duration(seconds: 6),
        // Mit Action bleibt eine SnackBar sonst stehen, bis man sie wegwischt.
        persist: false,
        action: SnackBarAction(
          label: l10n.commonUndo,
          onPressed: () => repo.restore(type, id),
        ),
      ),
    );
  return true;
}

/// Einstellungen → Archiv: wiederherstellen oder endgültig löschen.
class ArchivePage extends StatefulWidget {
  const ArchivePage({super.key});

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {
  Stream<List<ArchivedItem>>? _items;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _items ??= ArchiveRepository(DatabaseScope.of(context)).watchArchived();
  }

  Future<bool> _confirm(String title, String text) async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(text),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.commonCancel),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.l10n.settingsArchivePurgeAction),
            ),
          ],
        ),
      ) ==
      true;

  Future<void> _purge(ArchivedItem item) async {
    final repo = ArchiveRepository(DatabaseScope.of(context));
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    if (!await _confirm(
      l10n.settingsArchivePurgeTitle,
      l10n.settingsArchivePurgeText(item.title),
    )) {
      return;
    }
    try {
      await repo.purge(item.entityType, item.id);
    } on ArchiveBlocked catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _purgeAll() async {
    final repo = ArchiveRepository(DatabaseScope.of(context));
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    if (!await _confirm(
      l10n.settingsArchivePurgeAllTitle,
      l10n.settingsArchivePurgeAllText,
    )) {
      return;
    }
    final count = await repo.purgeAll();
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.settingsArchivePurgedCount(count))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = ArchiveRepository(DatabaseScope.of(context));
    final l10n = context.l10n;
    final format = DateFormat(l10n.settingsDateTimePattern);
    return StreamBuilder<List<ArchivedItem>>(
      stream: _items,
      builder: (context, snapshot) {
        final items = snapshot.data ?? const <ArchivedItem>[];
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.settingsArchiveTitle),
            actions: [
              if (items.isNotEmpty)
                TextButton(
                  onPressed: _purgeAll,
                  child: Text(l10n.settingsArchiveEmptyAction),
                ),
            ],
          ),
          body: items.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      snapshot.hasData
                          ? l10n.settingsArchiveEmpty
                          : l10n.settingsArchiveLoading,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 4),
                  itemBuilder: (context, i) {
                    final item = items[i];
                    return ListTile(
                      leading: Icon(_typeIcons[item.entityType]),
                      title: Text(item.title),
                      subtitle: Text(
                        l10n.settingsArchiveItemSubtitle(
                          '${_typeLabel(l10n, item.entityType)}',
                          format.format(item.archivedAt),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: l10n.commonRestore,
                            icon: const Icon(Icons.restore),
                            onPressed: () =>
                                repo.restore(item.entityType, item.id),
                          ),
                          IconButton(
                            tooltip: l10n.settingsArchivePurgeAction,
                            icon: const Icon(Icons.delete_forever_outlined),
                            onPressed: () => _purge(item),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
