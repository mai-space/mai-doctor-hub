import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/database_provider.dart';
import '../../data/repositories/appointment_repository.dart';
import '../../data/repositories/records_repository.dart';
import '../../services/report_import_service.dart';
import '../../theme/app_theme.dart';

class AppointmentDetailPage extends StatefulWidget {
  const AppointmentDetailPage({super.key, required this.appointmentId});

  final String appointmentId;

  @override
  State<AppointmentDetailPage> createState() => _AppointmentDetailPageState();
}

class _AppointmentDetailPageState extends State<AppointmentDetailPage> {
  Future<AppointmentSummary?>? _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _future ??= AppointmentRepository(
      DatabaseScope.of(context),
    ).summaryFor(widget.appointmentId);
  }

  Future<void> _reload() async {
    final summary = await AppointmentRepository(
      DatabaseScope.of(context),
    ).summaryFor(widget.appointmentId);
    if (!mounted) return;
    setState(() => _future = Future.value(summary));
  }

  @override
  Widget build(BuildContext context) {
    final db = DatabaseScope.of(context);
    final records = RecordsRepository(db);

    return Scaffold(
      appBar: AppBar(title: const Text('Termin')),
      body: FutureBuilder<AppointmentSummary?>(
        future: _future,
        builder: (context, snapshot) {
          final summary = snapshot.data;
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (summary == null) {
            return const Center(child: Text('Termin nicht gefunden'));
          }

          final a = summary.appointment;
          final when = DateFormat(
            'EEEE, d. MMMM yyyy · HH:mm',
            'de',
          ).format(a.scheduledAt);

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              Text(
                a.title?.isNotEmpty == true ? a.title! : 'Termin',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(when, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                summary.doctorName,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.muted),
              ),
              if (a.notes != null && a.notes!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(a.notes!),
              ],
              if (summary.diagnosisTitles.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(
                  'Diagnosen',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final title in summary.diagnosisTitles)
                      Chip(label: Text(title)),
                  ],
                ),
              ],
              if (summary.symptomLabels.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Symptome',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    for (final label in summary.symptomLabels)
                      Chip(label: Text(label)),
                  ],
                ),
              ],
              const SizedBox(height: 24),
              Text(
                'Berichte',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              FutureBuilder(
                future: records.reportsForAppointment(a.id),
                builder: (context, reportSnap) {
                  final reports = reportSnap.data ?? const [];
                  if (reports.isEmpty) {
                    return Text(
                      'Noch kein Bericht — nach dem Termin ablegen.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
                    );
                  }
                  return Column(
                    children: [
                      for (final report in reports)
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.description_outlined),
                          title: Text(report.title),
                          subtitle: Text(
                            report.extractedText?.isNotEmpty == true
                                ? 'Text indexiert für Suche'
                                : report.mimeType,
                          ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () async {
                  final imported = await ReportImportService(
                    records,
                  ).pickAndImport(appointmentId: a.id);
                  if (!context.mounted) return;
                  if (imported != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Bericht „${imported.title}“ gespeichert'),
                      ),
                    );
                    await _reload();
                  }
                },
                icon: const Icon(Icons.attach_file),
                label: const Text('Bericht hinzufügen'),
              ),
            ],
          );
        },
      ),
    );
  }
}
