import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/records_repository.dart';
import '../../l10n/l10n.dart';
import '../../services/report_import_service.dart';
import '../archive/archive_page.dart';
import '../records/entity_forms.dart';

/// Zeigt einen Bericht (PDF oder Bild) inkl. erkanntem Text.
class ReportViewerPage extends StatefulWidget {
  const ReportViewerPage({super.key, required this.reportId});

  final String reportId;

  @override
  State<ReportViewerPage> createState() => _ReportViewerPageState();
}

enum _ReportAction { rename, text, reindex, delete }

class _ReportViewerPageState extends State<ReportViewerPage> {
  Stream<Report?>? _report;
  bool _reindexing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final db = DatabaseScope.of(context);
    _report ??= db.watchWith({
      db.reports,
    }, () => RecordsRepository(db).getReport(widget.reportId));
  }

  Future<void> _onAction(_ReportAction action, Report report) async {
    final db = DatabaseScope.of(context);
    final records = RecordsRepository(db);
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    switch (action) {
      case _ReportAction.rename:
        await showReportRenameForm(context, report);
      case _ReportAction.text:
        _showText(report);
      case _ReportAction.reindex:
        setState(() => _reindexing = true);
        final found = await ReportImportService(records).reindex(report);
        if (!mounted) return;
        setState(() => _reindexing = false);
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              found
                  ? l10n.homeReportTextRecognized
                  : l10n.homeReportNoText,
            ),
          ),
        );
      case _ReportAction.delete:
        final navigator = Navigator.of(context);
        if (await archiveWithUndo(context, 'report', report.id)) {
          navigator.pop();
        }
    }
  }

  void _showText(Report report) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        builder: (context, controller) => ListView(
          controller: controller,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          children: [
            Text(
              context.l10n.homeReportRecognizedText,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            SelectableText(
              report.extractedText?.isNotEmpty == true
                  ? report.extractedText!
                  : context.l10n.homeReportNoTextDot,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Report?>(
      stream: _report,
      builder: (context, snapshot) {
        final report = snapshot.data;
        if (report == null) {
          return Scaffold(
            appBar: AppBar(title: Text(context.l10n.entityReport)),
            body: Center(
              child: snapshot.connectionState == ConnectionState.waiting
                  ? const CircularProgressIndicator()
                  : Text(context.l10n.homeReportNotFound),
            ),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(report.title, overflow: TextOverflow.ellipsis),
            bottom: _reindexing
                ? const PreferredSize(
                    preferredSize: Size.fromHeight(4),
                    child: LinearProgressIndicator(),
                  )
                : null,
            actions: [
              PopupMenuButton<_ReportAction>(
                onSelected: (a) => _onAction(a, report),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: _ReportAction.rename,
                    child: Text(context.l10n.homeReportRename),
                  ),
                  PopupMenuItem(
                    value: _ReportAction.text,
                    child: Text(context.l10n.homeReportShowText),
                  ),
                  PopupMenuItem(
                    value: _ReportAction.reindex,
                    child: Text(context.l10n.homeReportReindex),
                  ),
                  PopupMenuItem(
                    value: _ReportAction.delete,
                    child: Text(context.l10n.commonDelete),
                  ),
                ],
              ),
            ],
          ),
          body: _ReportBody(report: report),
        );
      },
    );
  }
}

class _ReportBody extends StatelessWidget {
  const _ReportBody({required this.report});

  final Report report;

  @override
  Widget build(BuildContext context) {
    final missing = kIsWeb || report.localPath.startsWith('web-memory://');
    if (missing || !File(report.localPath).existsSync()) {
      return _Unavailable(report: report);
    }
    if (report.mimeType == 'application/pdf') {
      return PdfViewer.file(report.localPath);
    }
    return InteractiveViewer(
      maxScale: 6,
      child: Center(child: Image.file(File(report.localPath))),
    );
  }
}

class _Unavailable extends StatelessWidget {
  const _Unavailable({required this.report});

  final Report report;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final created = DateFormat(
      l10n.homeReportDatePattern,
    ).format(report.createdAt);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.insert_drive_file_outlined, size: 48),
            const SizedBox(height: 12),
            Text(
              l10n.homeReportFileUnavailable,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.homeReportFileUnavailableHint(created),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
