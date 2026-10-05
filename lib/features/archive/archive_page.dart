import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../data/database_provider.dart';
import '../../data/repositories/archive_repository.dart';

const _typeLabels = {
  'doctor': 'Arzt',
  'diagnosis': 'Diagnose',
  'symptom': 'Symptom',
  'appointment': 'Termin',
  'report': 'Bericht',
  'medication': 'Medikament',
  'note': 'Notiz',
  'pharmacy': 'Apotheke',
  'vaccination': 'Impfung',
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
        content: Text('${label ?? _typeLabels[type] ?? 'Eintrag'} im Archiv'),
        duration: const Duration(seconds: 6),
        action: SnackBarAction(
          label: 'Rückgängig',
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
              child: const Text('Abbrechen'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Endgültig löschen'),
            ),
          ],
        ),
      ) ==
      true;

  Future<void> _purge(ArchivedItem item) async {
    final repo = ArchiveRepository(DatabaseScope.of(context));
    final messenger = ScaffoldMessenger.of(context);
    if (!await _confirm(
      'Endgültig löschen?',
      '„${item.title}“ wird unwiderruflich gelöscht (inkl. Dateien).',
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
    if (!await _confirm(
      'Archiv leeren?',
      'Alle archivierten Einträge werden unwiderruflich gelöscht.',
    )) {
      return;
    }
    final count = await repo.purgeAll();
    messenger.showSnackBar(
      SnackBar(content: Text('$count Einträge endgültig gelöscht')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = ArchiveRepository(DatabaseScope.of(context));
    final format = DateFormat('d. MMM, HH:mm', 'de');
    return StreamBuilder<List<ArchivedItem>>(
      stream: _items,
      builder: (context, snapshot) {
        final items = snapshot.data ?? const <ArchivedItem>[];
        return Scaffold(
          appBar: AppBar(
            title: const Text('Archiv'),
            actions: [
              if (items.isNotEmpty)
                TextButton(
                  onPressed: _purgeAll,
                  child: const Text('Leeren'),
                ),
            ],
          ),
          body: items.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Text(
                      snapshot.hasData
                          ? 'Das Archiv ist leer. Gelöschte Einträge landen '
                                'hier und lassen sich wiederherstellen.'
                          : 'Wird geladen…',
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
                        '${_typeLabels[item.entityType]} · archiviert '
                        '${format.format(item.archivedAt)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Wiederherstellen',
                            icon: const Icon(Icons.restore),
                            onPressed: () =>
                                repo.restore(item.entityType, item.id),
                          ),
                          IconButton(
                            tooltip: 'Endgültig löschen',
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
