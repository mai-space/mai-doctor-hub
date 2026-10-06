import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../data/database_provider.dart';
import '../../data/repositories/records_repository.dart';
import '../../l10n/l10n.dart';
import '../../services/backup_service.dart';
import '../../services/document_export_service.dart';
import '../../services/report_import_service.dart';
import '../records/entity_forms.dart';

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
      if (mounted) _snack(context.l10n.settingsBackupFailed(label));
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
    final l10n = context.l10n;
    await _run(l10n.settingsBackupTaskBackup, () async {
      final file = await service.createBackupFile(passphrase);
      try {
        // Teilen-Dialog liest die Datei selbst (z. B. „In Dateien
        // speichern“, Drive) — nichts muss komplett in den Speicher.
        final result = await SharePlus.instance.share(
          ShareParams(
            files: [XFile(file.path, mimeType: 'application/octet-stream')],
            fileNameOverrides: [
              BackupService.suggestedFileName(DateTime.now()),
            ],
            subject: l10n.settingsBackupShareSubject,
          ),
        );
        if (result.status != ShareResultStatus.dismissed) {
          _snack(l10n.settingsBackupCreated);
        }
      } finally {
        try {
          await file.delete();
        } catch (_) {}
      }
    });
  }

  Future<void> _import() async {
    final l10n = context.l10n;
    final files = await FilePicker.pickFiles(
      dialogTitle: l10n.settingsBackupPickTitle,
    );
    if (files.isEmpty || !mounted) return;
    final (path, staged) = await _localPath(files.first);
    try {
      if (await BackupStream.versionOf(path) == 0) {
        _snack(l10n.settingsBackupNotABackup);
        return;
      }
      await _confirmAndRestore(path);
    } finally {
      if (staged) {
        try {
          await File(path).delete();
        } catch (_) {}
      }
    }
  }

  /// Lokaler Pfad der Auswahl; `content://`-Dateien werden gestreamt in den
  /// Temp-Ordner kopiert (staged = danach löschen).
  Future<(String, bool)> _localPath(PlatformFile file) async {
    final direct = file.path;
    if (direct != null) return (direct, false);
    final target = File(
      p.join(
        (await getTemporaryDirectory()).path,
        'import_${DateTime.now().microsecondsSinceEpoch}.maibackup',
      ),
    );
    final sink = target.openWrite();
    try {
      await sink.addStream(file.readAsByteStream());
    } finally {
      await sink.close();
    }
    return (target.path, true);
  }

  Future<void> _confirmAndRestore(String path) async {
    final db = DatabaseScope.of(context);
    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.settingsBackupRestoreConfirmTitle),
        content: Text(context.l10n.settingsBackupRestoreConfirmText),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.settingsBackupReplace),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    final passphrase = await showPassphraseDialog(context);
    if (passphrase == null || !mounted) return;
    final l10n = context.l10n;
    await _run(l10n.settingsBackupTaskRestore, () async {
      // Erinnerungen planen sich über den DB-Stream selbst neu.
      final result = await BackupService(db).restoreFile(path, passphrase);
      final date = DateFormat(
        l10n.settingsBackupDatePattern,
      ).format(result.createdAt);
      _snack(
        result.missingFiles > 0
            ? l10n.settingsBackupRestoredMissing(date, result.missingFiles)
            : l10n.settingsBackupRestored(date),
      );
    });
  }

  Future<void> _exportDocuments() async {
    final db = DatabaseScope.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.settingsDocumentsExportConfirmTitle),
        content: Text(context.l10n.settingsDocumentsExportConfirmText),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.settingsDocumentsExportAction),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final l10n = context.l10n;
    await _run(l10n.settingsBackupTaskExport, () async {
      final export = await DocumentExportService(db).export();
      if (export == null) {
        _snack(l10n.settingsDocumentsExportNone);
        return;
      }
      try {
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile(export.file.path, mimeType: 'application/zip')],
            fileNameOverrides: [
              DocumentExportService.suggestedFileName(DateTime.now()),
            ],
            subject: l10n.settingsDocumentsShareSubject(export.count),
          ),
        );
      } finally {
        try {
          await export.file.delete();
        } catch (_) {}
      }
    });
  }

  Future<void> _reindex() async {
    final records = RecordsRepository(DatabaseScope.of(context));
    final l10n = context.l10n;
    await _run(l10n.settingsBackupTaskReindex, () async {
      final count = await ReportImportService(records).reindexMissing();
      _snack(
        count == 0
            ? l10n.settingsReindexAllDone
            : l10n.settingsReindexCount(count),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final busy = _busy != null;
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.settingsBackupSection,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.settingsBackupDescription,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        if (busy) ...[
          const SizedBox(height: 8),
          const LinearProgressIndicator(),
          const SizedBox(height: 4),
          Text(
            l10n.settingsBackupRunning(_busy!),
            style: theme.textTheme.bodySmall,
          ),
        ],
        if (backupSupported) ...[
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.backup_outlined),
            title: Text(l10n.settingsBackupCreate),
            enabled: !busy,
            onTap: _export,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.settings_backup_restore),
            title: Text(l10n.settingsBackupRestore),
            enabled: !busy,
            onTap: _import,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.folder_zip_outlined),
            title: Text(l10n.settingsDocumentsExport),
            subtitle: Text(l10n.settingsDocumentsExportSubtitle),
            enabled: !busy,
            onTap: _exportDocuments,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.drive_folder_upload_outlined),
            title: Text(l10n.settingsDocumentsImport),
            subtitle: Text(l10n.settingsDocumentsImportSubtitle),
            enabled: !busy,
            onTap: () => _run(l10n.settingsBackupTaskImport, () async {
              await pickReportFile(context);
            }),
          ),
        ] else
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.backup_outlined),
            title: Text(l10n.settingsBackupWebUnavailable),
          ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.manage_search),
          title: Text(l10n.settingsReindexTitle),
          subtitle: Text(l10n.settingsReindexSubtitle),
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
        () => _error = context.l10n.settingsPassphraseMinLength(
          BackupCrypto.minPassphraseLength,
        ),
      );
      return;
    }
    if (widget.confirm && value != _second.text) {
      setState(() => _error = context.l10n.settingsPassphraseMismatch);
      return;
    }
    if (value.isEmpty) return;
    Navigator.pop(context, value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(
        widget.confirm
            ? l10n.settingsPassphraseSetTitle
            : l10n.settingsPassphraseEnterTitle,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _first,
            obscureText: _obscure,
            autofocus: true,
            decoration: InputDecoration(
              labelText: l10n.settingsPassphraseLabel,
              suffixIcon: IconButton(
                tooltip: _obscure
                    ? l10n.settingsPassphraseShow
                    : l10n.settingsPassphraseHide,
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
              decoration: InputDecoration(
                labelText: l10n.settingsPassphraseRepeat,
              ),
              onSubmitted: (_) => _submit(),
            ),
          if (widget.confirm) ...[
            const SizedBox(height: 12),
            Text(l10n.settingsPassphraseWarning),
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
          child: Text(l10n.commonCancel),
        ),
        FilledButton(onPressed: _submit, child: Text(l10n.commonOk)),
      ],
    );
  }
}
