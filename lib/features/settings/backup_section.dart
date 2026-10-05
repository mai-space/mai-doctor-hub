import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/database_provider.dart';
import '../../data/repositories/records_repository.dart';
import '../../services/backup_service.dart';
import '../../services/report_import_service.dart';

/// Einstellungen → Datensicherung & Suchindex.
class BackupSection extends StatefulWidget {
  const BackupSection({super.key});

  @override
  State<BackupSection> createState() => _BackupSectionState();
}

class _BackupSectionState extends State<BackupSection> {
  String? _busy;

  Future<void> _run(String label, Future<void> Function() task) async {
    setState(() => _busy = label);
    try {
      await task();
    } on BackupException catch (e) {
      _snack(e.message);
    } catch (e) {
      debugPrint('$label fehlgeschlagen: $e');
      _snack('$label fehlgeschlagen.');
    } finally {
      if (mounted) setState(() => _busy = null);
    }
  }

  void _snack(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _export() async {
    final passphrase = await showPassphraseDialog(context, confirm: true);
    if (passphrase == null || !mounted) return;
    final service = BackupService(DatabaseScope.of(context));
    await _run('Sicherung', () async {
      final bytes = await service.createBackup(passphrase);
      final saved = await FilePicker.saveFile(
        fileName: BackupService.suggestedFileName(DateTime.now()),
        bytes: bytes,
        dialogTitle: 'Sicherung speichern',
      );
      if (saved != null) {
        _snack('Sicherung gespeichert — Passwort gut aufbewahren!');
      }
    });
  }

  Future<void> _import() async {
    final db = DatabaseScope.of(context);
    final files = await FilePicker.pickFiles(dialogTitle: 'Sicherung wählen');
    if (files.isEmpty || !mounted) return;
    final bytes = await files.first.readAsBytes();
    if (!BackupCrypto.looksLikeBackup(bytes)) {
      _snack('Keine Mai-Doctor-Hub-Sicherung (.maibackup).');
      return;
    }
    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sicherung wiederherstellen?'),
        content: const Text(
          'Alle aktuellen Daten und Berichte auf diesem Gerät werden durch '
          'die Sicherung ersetzt. Der Kalender-Export muss danach neu '
          'eingerichtet werden.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Ersetzen'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final passphrase = await showPassphraseDialog(context);
    if (passphrase == null) return;
    await _run('Wiederherstellung', () async {
      // Erinnerungen planen sich über den DB-Stream selbst neu.
      final result = await BackupService(db).restore(bytes, passphrase);
      final date = DateFormat('d. MMM yyyy', 'de').format(result.createdAt);
      _snack(
        'Sicherung vom $date wiederhergestellt'
        '${result.missingFiles > 0 ? ' (${result.missingFiles} Dateien fehlten)' : ''}.',
      );
    });
  }

  Future<void> _reindex() async {
    final records = RecordsRepository(DatabaseScope.of(context));
    await _run('Indexierung', () async {
      final count = await ReportImportService(records).reindexMissing();
      _snack(
        count == 0
            ? 'Alle Berichte sind bereits durchsuchbar.'
            : '$count Bericht(e) jetzt durchsuchbar.',
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final busy = _busy != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Datensicherung',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Verschlüsselte Datei mit allen Daten und Berichten — z. B. für '
          'einen Gerätewechsel. Ohne Passwort nicht lesbar.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        if (busy) ...[
          const SizedBox(height: 8),
          const LinearProgressIndicator(),
          const SizedBox(height: 4),
          Text('$_busy läuft…', style: theme.textTheme.bodySmall),
        ],
        if (backupSupported) ...[
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.backup_outlined),
            title: const Text('Sicherung erstellen'),
            enabled: !busy,
            onTap: _export,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.settings_backup_restore),
            title: const Text('Sicherung wiederherstellen'),
            enabled: !busy,
            onTap: _import,
          ),
        ] else
          const ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.backup_outlined),
            title: Text('Im Web nicht verfügbar'),
          ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.manage_search),
          title: const Text('Berichte durchsuchbar machen'),
          subtitle: const Text('Text aus älteren PDF-Berichten erkennen'),
          enabled: !busy,
          onTap: _reindex,
        ),
      ],
    );
  }
}

/// Fragt ein Passwort ab; mit [confirm] zweimal (beim Erstellen).
Future<String?> showPassphraseDialog(
  BuildContext context, {
  bool confirm = false,
}) {
  return showDialog<String>(
    context: context,
    builder: (context) => _PassphraseDialog(confirm: confirm),
  );
}

class _PassphraseDialog extends StatefulWidget {
  const _PassphraseDialog({required this.confirm});

  final bool confirm;

  @override
  State<_PassphraseDialog> createState() => _PassphraseDialogState();
}

class _PassphraseDialogState extends State<_PassphraseDialog> {
  final _first = TextEditingController();
  final _second = TextEditingController();
  String? _error;
  bool _obscure = true;

  @override
  void dispose() {
    _first.dispose();
    _second.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _first.text;
    if (widget.confirm && value.length < BackupCrypto.minPassphraseLength) {
      setState(
        () => _error =
            'Mindestens ${BackupCrypto.minPassphraseLength} Zeichen.',
      );
      return;
    }
    if (widget.confirm && value != _second.text) {
      setState(() => _error = 'Passwörter stimmen nicht überein.');
      return;
    }
    if (value.isEmpty) return;
    Navigator.pop(context, value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.confirm ? 'Passwort festlegen' : 'Passwort eingeben'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _first,
            obscureText: _obscure,
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Passwort',
              suffixIcon: IconButton(
                tooltip: _obscure ? 'Anzeigen' : 'Verbergen',
                icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
            ),
            onSubmitted: (_) => widget.confirm ? null : _submit(),
          ),
          if (widget.confirm)
            TextField(
              controller: _second,
              obscureText: _obscure,
              decoration: const InputDecoration(labelText: 'Wiederholen'),
              onSubmitted: (_) => _submit(),
            ),
          if (widget.confirm) ...[
            const SizedBox(height: 12),
            const Text(
              'Ohne dieses Passwort lässt sich die Sicherung nicht öffnen — '
              'es gibt keine Wiederherstellung.',
            ),
          ],
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        FilledButton(onPressed: _submit, child: const Text('OK')),
      ],
    );
  }
}
