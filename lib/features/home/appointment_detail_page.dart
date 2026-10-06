import 'dart:convert';
import 'dart:typed_data';

import 'package:drift/drift.dart' show OrderingTerm;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/appointment_repository.dart';
import '../../data/repositories/records_repository.dart';
import '../../data/repositories/settings_repository.dart';
import '../../data/repositories/symptom_repository.dart';
import '../../l10n/l10n.dart';
import '../../services/calendar/calendar_sync_service.dart';
import '../../services/calendar/ics.dart';
import '../../theme/icon_mappings.dart';
import '../../widgets/symptom_report_card.dart';
import '../archive/archive_page.dart';
import '../records/detail_pages.dart';
import '../summary/visit_summary_page.dart';
import '../records/entity_forms.dart';
import 'add_appointment_sheet.dart';

class _AppointmentData {
  const _AppointmentData(
    this.summary,
    this.reports,
    this.notes,
    this.symptoms,
    this.window,
  );

  final AppointmentSummary summary;
  final List<Report> reports;
  final List<Note> notes;

  /// Zugeordnete Symptome mit den im [window] gemeldeten Check-ins.
  final List<(Symptom, List<SymptomObservation>)> symptoms;
  final (DateTime, DateTime) window;
}

enum _Action { done, cancel, reopen, summary, ics, delete }

class AppointmentDetailPage extends StatefulWidget {
  const AppointmentDetailPage({super.key, required this.appointmentId});

  final String appointmentId;

  @override
  State<AppointmentDetailPage> createState() => _AppointmentDetailPageState();
}

class _AppointmentDetailPageState extends State<AppointmentDetailPage> {
  Stream<_AppointmentData?>? _stream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final db = DatabaseScope.of(context);
    _stream ??= db.watchWith(
      {
        db.appointments,
        db.doctors,
        db.diagnoses,
        db.symptoms,
        db.appointmentDiagnoses,
        db.appointmentSymptoms,
        db.reports,
        db.notes,
        db.symptomObservations,
      },
      () async {
        final summary = await AppointmentRepository(
          db,
        ).summaryFor(widget.appointmentId);
        if (summary == null) return null;
        final reports = await RecordsRepository(
          db,
        ).reportsForAppointment(widget.appointmentId);
        final notes =
            await (db.selectActive(db.notes)
                  ..where(
                    (t) => t.relatedAppointmentId.equals(widget.appointmentId),
                  )
                  ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
                .get();
        final symptomRepo = SymptomRepository(db);
        final window = await AppointmentRepository(
          db,
        ).reportWindow(summary.appointment);
        final symptoms = <(Symptom, List<SymptomObservation>)>[];
        for (final id in summary.symptomIds) {
          final symptom = await symptomRepo.getById(id);
          if (symptom == null) continue;
          symptoms.add((
            symptom,
            await symptomRepo.observationsBetween(id, window.$1, window.$2),
          ));
        }
        return _AppointmentData(summary, reports, notes, symptoms, window);
      },
    );
  }

  Future<void> _onAction(_Action action, Appointment a) async {
    final repo = AppointmentRepository(DatabaseScope.of(context));
    switch (action) {
      case _Action.done:
        await repo.updateStatus(a.id, AppointmentStatus.done);
      case _Action.cancel:
        await repo.updateStatus(a.id, AppointmentStatus.cancelled);
      case _Action.reopen:
        await repo.updateStatus(a.id, AppointmentStatus.planned);
      case _Action.ics:
        await _exportIcs(a.id);
      case _Action.summary:
        await Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => VisitSummaryPage(appointmentId: a.id),
          ),
        );
      case _Action.delete:
        final navigator = Navigator.of(context);
        // Berichte wandern mit ins Archiv; „Rückgängig“ holt alles zurück.
        if (await archiveWithUndo(context, 'appointment', a.id)) {
          navigator.pop();
        }
    }
  }

  /// Fallback ohne Dauer-Export: einzelne .ics-Datei (auch im Web).
  Future<void> _exportIcs(String id) async {
    final db = DatabaseScope.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final summary = await AppointmentRepository(db).summaryFor(id);
    if (summary == null) return;
    final settings = await SettingsRepository(db).get();
    final ics = Ics.event(
      uid: id,
      event: CalendarSyncService.eventFor(
        summary,
        includeTitle: settings.calendarIncludeTitle,
      ),
    );
    final saved = await FilePicker.saveFile(
      fileName: 'termin-${DateFormat('yyyy-MM-dd').format(summary.appointment.scheduledAt)}.ics',
      bytes: Uint8List.fromList(utf8.encode(ics)),
      mimeType: 'text/calendar',
      dialogTitle: l10n.homeIcsSaveDialogTitle,
    );
    if (saved != null) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.homeIcsSaved)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<_AppointmentData?>(
      stream: _stream,
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null) {
          return Scaffold(
            appBar: AppBar(title: Text(context.l10n.entityAppointment)),
            body: Center(
              child: snapshot.connectionState == ConnectionState.waiting
                  ? const CircularProgressIndicator()
                  : Text(context.l10n.homeAppointmentNotFound),
            ),
          );
        }
        final summary = data.summary;
        final a = summary.appointment;
        return Scaffold(
          appBar: AppBar(
            title: Text(context.l10n.entityAppointment),
            actions: [
              IconButton(
                tooltip: context.l10n.commonEdit,
                icon: const Icon(Icons.edit_outlined),
                onPressed: () =>
                    showAddAppointmentSheet(context, initial: summary),
              ),
              PopupMenuButton<_Action>(
                onSelected: (action) => _onAction(action, a),
                itemBuilder: (context) => [
                  if (a.status != AppointmentStatus.done)
                    PopupMenuItem(
                      value: _Action.done,
                      child: Text(context.l10n.homeMarkDone),
                    ),
                  if (a.status != AppointmentStatus.cancelled)
                    PopupMenuItem(
                      value: _Action.cancel,
                      child: Text(context.l10n.homeCancelAppointment),
                    ),
                  if (a.status != AppointmentStatus.planned)
                    PopupMenuItem(
                      value: _Action.reopen,
                      child: Text(context.l10n.homeReopen),
                    ),
                  PopupMenuItem(
                    value: _Action.summary,
                    child: Text(context.l10n.homeDoctorSummaryPdf),
                  ),
                  PopupMenuItem(
                    value: _Action.ics,
                    child: Text(context.l10n.homeExportIcs),
                  ),
                  PopupMenuItem(
                    value: _Action.delete,
                    child: Text(context.l10n.commonDelete),
                  ),
                ],
              ),
            ],
          ),
          body: _AppointmentBody(data: data),
        );
      },
    );
  }
}

class _AppointmentBody extends StatelessWidget {
  const _AppointmentBody({required this.data});

  final _AppointmentData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final summary = data.summary;
    final a = summary.appointment;
    final l10n = context.l10n;
    final when = DateFormat(
      l10n.homeDetailDateTimePattern,
    ).format(a.scheduledAt);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: [
        DetailHeader(
          title: a.title?.isNotEmpty == true ? a.title! : l10n.entityAppointment,
          subtitle: [
            when,
            if (a.durationMin != null) l10n.homeDurationMinutes(a.durationMin!),
          ].join(' · '),
        ),
        Wrap(
          spacing: 8,
          children: [
            Chip(
              avatar: Icon(switch (a.status) {
                AppointmentStatus.planned => Icons.schedule,
                AppointmentStatus.done => Icons.check_circle_outline,
                AppointmentStatus.cancelled => Icons.cancel_outlined,
              }, size: 18),
              label: Text(appointmentStatusLabel(a.status)),
            ),
          ],
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            summary.doctor?.specialty != null
                ? IconMappings.specialtyIcon(summary.doctor!.specialty!)
                : Icons.medical_services_outlined,
          ),
          title: Text(summary.doctorName),
          subtitle: summary.doctor?.specialty == null
              ? null
              : Text(summary.doctor!.specialty!),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => openRecord(context, 'doctor', a.doctorId),
        ),
        if (a.notes != null && a.notes!.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(a.notes!),
        ],
        if (summary.diagnosisTitles.isNotEmpty)
          DetailSection(
            title: l10n.entityDiagnoses,
            children: [
              Wrap(
                spacing: 8,
                children: [
                  for (var i = 0; i < summary.diagnosisIds.length; i++)
                    ActionChip(
                      label: Text(summary.diagnosisTitles[i]),
                      onPressed: () => openRecord(
                        context,
                        'diagnosis',
                        summary.diagnosisIds[i],
                      ),
                    ),
                ],
              ),
            ],
          ),
        if (data.symptoms.isNotEmpty)
          DetailSection(
            title: l10n.homeSymptomsAndCheckIns,
            children: [
              for (final (symptom, observations) in data.symptoms)
                SymptomReportCard(
                  symptom: symptom,
                  observations: observations,
                  from: data.window.$1,
                  to: data.window.$2,
                  onTap: () => openRecord(context, 'symptom', symptom.id),
                ),
            ],
          ),
        DetailSection(
          title: l10n.entityReports,
          empty: l10n.homeNoReportYet,
          children: [
            for (final report in data.reports)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  switch (report.source) {
                    ReportSource.scan => Icons.document_scanner_outlined,
                    ReportSource.image => Icons.image_outlined,
                    ReportSource.pdf => Icons.picture_as_pdf_outlined,
                  },
                ),
                title: Text(report.title),
                subtitle: Text(
                  [
                    if (report.source == ReportSource.scan) l10n.homeReportScan,
                    report.extractedText?.isNotEmpty == true
                        ? l10n.homeReportTextSearchable
                        : l10n.homeReportNoText,
                  ].join(' · '),
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => openRecord(context, 'report', report.id),
              ),
          ],
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: () => importReport(context, appointmentId: a.id),
          icon: const Icon(Icons.attach_file),
          label: Text(l10n.homeAddReport),
        ),
        DetailSection(
          title: l10n.commonNotes,
          trailing: TextButton.icon(
            onPressed: () => showNoteForm(context, relatedAppointmentId: a.id),
            icon: const Icon(Icons.add),
            label: Text(l10n.commonNote),
          ),
          children: [
            for (final n in data.notes)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.sticky_note_2_outlined),
                title: Text(
                  n.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () => openRecord(context, 'note', n.id),
              ),
          ],
        ),
        if (data.notes.isEmpty)
          Text(
            l10n.homeNotesTip,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
      ],
    );
  }
}
