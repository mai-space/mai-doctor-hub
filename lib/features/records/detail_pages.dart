import 'package:drift/drift.dart' show OrderingTerm, innerJoin;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/appointment_repository.dart';
import '../../data/repositories/diagnosis_hub_repository.dart';
import '../../data/repositories/doctor_repository.dart';
import '../../data/repositories/medication_repository.dart';
import '../../data/repositories/records_repository.dart';
import '../../data/repositories/reminder_repository.dart' show Weekdays;
import '../../data/repositories/symptom_repository.dart';
import '../../data/repositories/vaccination_repository.dart';
import '../../data/symptom_description.dart';
import '../../l10n/l10n.dart';
import '../../theme/icon_mappings.dart';
import '../../widgets/observation_chart.dart';
import '../../widgets/symptom_heatmap.dart';
import '../../widgets/symptom_report_card.dart';
import '../archive/archive_page.dart';
import '../home/appointment_detail_page.dart';
import '../medications/medication_form_page.dart';
import '../medications/pharmacy_form.dart';
import '../medications/vaccination_form.dart';
import '../settings/reminders_section.dart' show ensureNotificationPermission;
import '../reports/report_viewer_page.dart';
import 'entity_forms.dart';

DateFormat _date(BuildContext context) =>
    DateFormat(context.l10n.recordsDatePattern);
DateFormat _dateTime(BuildContext context) =>
    DateFormat(context.l10n.recordsDateTimePattern);

/// Öffnet die passende Detailseite für einen Akten-Eintrag.
void openRecord(BuildContext context, String entityType, String id) {
  final Widget page = switch (entityType) {
    'appointment' => AppointmentDetailPage(appointmentId: id),
    'report' => ReportViewerPage(reportId: id),
    'doctor' => DoctorDetailPage(doctorId: id),
    'diagnosis' => DiagnosisDetailPage(diagnosisId: id),
    'symptom' => SymptomDetailPage(symptomId: id),
    'medication' => MedicationDetailPage(medicationId: id),
    'pharmacy' => PharmacyDetailPage(pharmacyId: id),
    'vaccination' => VaccinationDetailPage(vaccinationId: id),
    'note' => NoteDetailPage(noteId: id),
    _ => throw ArgumentError('Unbekannter Typ $entityType'),
  };
  Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => page));
}

/// Gerüst: lädt reaktiv, zeigt Bearbeiten/Löschen in der AppBar.
class _DetailScaffold<T> extends StatefulWidget {
  const _DetailScaffold({
    required this.title,
    required this.watch,
    required this.body,
    required this.onEdit,
    required this.onDelete,
    this.extraActions,
  });

  final String title;
  final Stream<T?> Function(AppDatabase db) watch;
  final List<Widget> Function(BuildContext context, T value) body;
  final Future<void> Function(BuildContext context, T value) onEdit;

  /// Gibt `true` zurück, wenn gelöscht wurde (Seite schließt sich).
  final Future<bool> Function(BuildContext context, T value) onDelete;
  final List<Widget> Function(BuildContext context, T value)? extraActions;

  @override
  State<_DetailScaffold<T>> createState() => _DetailScaffoldState<T>();
}

class _DetailScaffoldState<T> extends State<_DetailScaffold<T>> {
  Stream<T?>? _stream;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _stream ??= widget.watch(DatabaseScope.of(context));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<T?>(
      stream: _stream,
      builder: (context, snapshot) {
        final value = snapshot.data;
        return Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            actions: value == null
                ? null
                : [
                    ...?widget.extraActions?.call(context, value),
                    IconButton(
                      tooltip: context.l10n.commonEdit,
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => widget.onEdit(context, value),
                    ),
                    IconButton(
                      tooltip: context.l10n.recordsDeleteToArchive,
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async {
                        final navigator = Navigator.of(context);
                        if (await widget.onDelete(context, value)) {
                          navigator.pop();
                        }
                      },
                    ),
                  ],
          ),
          body: value == null
              ? Center(
                  child: snapshot.connectionState == ConnectionState.waiting
                      ? const CircularProgressIndicator()
                      : Text(context.l10n.recordsNotFound),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                  children: widget.body(context, value),
                ),
        );
      },
    );
  }
}

class DetailHeader extends StatelessWidget {
  const DetailHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 32,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class DetailSection extends StatelessWidget {
  const DetailSection({
    super.key,
    required this.title,
    required this.children,
    this.empty,
    this.trailing,
  });

  final String title;
  final List<Widget> children;
  final String? empty;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (children.isEmpty && empty == null && trailing == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          const SizedBox(height: 4),
          if (children.isEmpty && empty != null)
            Text(
              empty!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            )
          else
            ...children,
        ],
      ),
    );
  }
}

Widget _infoTile(IconData icon, String label, String? value, {VoidCallback? onTap}) {
  if (value == null || value.isEmpty) return const SizedBox.shrink();
  return ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(icon),
    title: Text(value),
    subtitle: Text(label),
    onTap: onTap,
  );
}

Widget _linkTile(
  BuildContext context, {
  required IconData icon,
  required String title,
  String? subtitle,
  required String entityType,
  required String id,
}) {
  return ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(icon),
    title: Text(title),
    subtitle: subtitle == null ? null : Text(subtitle),
    trailing: const Icon(Icons.chevron_right),
    onTap: () => openRecord(context, entityType, id),
  );
}

Widget _appointmentTile(BuildContext context, AppointmentSummary s) {
  final a = s.appointment;
  return _linkTile(
    context,
    icon: Icons.event_outlined,
    title: a.title?.isNotEmpty == true ? a.title! : s.doctorName,
    subtitle: [
      _dateTime(context).format(a.scheduledAt),
      if (a.status != AppointmentStatus.planned)
        appointmentStatusLabel(a.status),
    ].join(' · '),
    entityType: 'appointment',
    id: a.id,
  );
}

// --- Arzt ------------------------------------------------------------------

class _DoctorData {
  const _DoctorData(this.doctor, this.appointments, this.symptoms);

  final Doctor doctor;
  final List<AppointmentSummary> appointments;

  /// Symptom + direkt zugeordnet (sonst über einen Termin).
  final List<(Symptom, bool)> symptoms;
}

class DoctorDetailPage extends StatelessWidget {
  const DoctorDetailPage({super.key, required this.doctorId});

  final String doctorId;

  @override
  Widget build(BuildContext context) {
    return _DetailScaffold<_DoctorData>(
      title: context.l10n.entityDoctor,
      watch: (db) => db.watchWith({
        db.doctors,
        db.appointments,
        db.symptoms,
        db.doctorSymptoms,
        db.appointmentSymptoms,
      }, () async {
        final doctor = await DoctorRepository(db).getById(doctorId);
        if (doctor == null) return null;
        final appointments =
            await (db.selectActive(db.appointments)
                  ..where((t) => t.doctorId.equals(doctorId))
                  ..orderBy([(t) => OrderingTerm.desc(t.scheduledAt)]))
                .get();
        return _DoctorData(
          doctor,
          await AppointmentRepository(db).summariesFor(appointments),
          await SymptomRepository(db).symptomsForDoctor(doctorId),
        );
      }),
      onEdit: (context, data) => showDoctorForm(context, doctor: data.doctor),
      onDelete: (context, data) =>
          archiveWithUndo(context, 'doctor', data.doctor.id),
      body: (context, data) {
        final d = data.doctor;
        final l10n = context.l10n;
        return [
          DetailHeader(
            title: d.name,
            subtitle: d.specialty,
            icon: d.specialty != null
                ? IconMappings.specialtyIcon(d.specialty!)
                : null,
          ),
          _infoTile(Icons.business_outlined, l10n.recordsPractice, d.practiceName),
          _infoTile(
            Icons.phone_outlined,
            l10n.recordsPhoneTapToCall,
            d.phone,
            onTap: () => launchUrl(Uri(scheme: 'tel', path: d.phone)),
          ),
          _infoTile(
            Icons.place_outlined,
            l10n.recordsAddressOpenMaps,
            d.address,
            onTap: () => launchUrl(
              Uri.parse('geo:0,0?q=${Uri.encodeComponent(d.address ?? '')}'),
            ),
          ),
          _infoTile(Icons.notes_outlined, l10n.commonNotes, d.notes),
          DetailSection(
            title: l10n.entitySymptoms,
            empty: l10n.recordsDoctorNoSymptoms,
            trailing: TextButton.icon(
              onPressed: () => _assignSymptoms(context, data),
              icon: const Icon(Icons.add),
              label: Text(l10n.recordsAssign),
            ),
            children: [
              for (final (symptom, direct) in data.symptoms)
                _linkTile(
                  context,
                  icon: Icons.healing_outlined,
                  title: symptom.label,
                  subtitle: [
                    symptom.healedAt == null
                        ? l10n.recordsStatusActive
                        : l10n.recordsStatusHealed,
                    direct
                        ? l10n.recordsLinkedDirect
                        : l10n.recordsLinkedViaAppointments,
                  ].join(' · '),
                  entityType: 'symptom',
                  id: symptom.id,
                ),
            ],
          ),
          DetailSection(
            title: l10n.entityAppointments,
            empty: l10n.recordsDoctorNoAppointments,
            children: [
              for (final s in data.appointments) _appointmentTile(context, s),
            ],
          ),
        ];
      },
    );
  }
}

/// Symptome einem Arzt direkt zuordnen (n:m).
Future<void> _assignSymptoms(BuildContext context, _DoctorData data) async {
  final repo = SymptomRepository(DatabaseScope.of(context));
  final all = await repo.watchAll().first;
  if (!context.mounted) return;
  final selected = {
    for (final (s, direct) in data.symptoms)
      if (direct) s.id,
  };
  final initial = {...selected};
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(context.l10n.recordsAssignSymptomsTitle(data.doctor.name)),
        scrollable: true,
        content: all.isEmpty
            ? Text(context.l10n.recordsNoSymptomsYet)
            : Wrap(
                spacing: 6,
                children: [
                  for (final s in all)
                    FilterChip(
                      label: Text(s.label),
                      selected: selected.contains(s.id),
                      onSelected: (v) => setState(
                        () => v ? selected.add(s.id) : selected.remove(s.id),
                      ),
                    ),
                ],
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.commonSave),
          ),
        ],
      ),
    ),
  );
  if (ok != true) return;
  for (final id in selected.difference(initial)) {
    await repo.linkDoctor(data.doctor.id, id);
  }
  for (final id in initial.difference(selected)) {
    await repo.unlinkDoctor(data.doctor.id, id);
  }
}

// --- Diagnose (Hub) --------------------------------------------------------

class DiagnosisDetailPage extends StatelessWidget {
  const DiagnosisDetailPage({super.key, required this.diagnosisId});

  final String diagnosisId;

  @override
  Widget build(BuildContext context) {
    return _DetailScaffold<DiagnosisHub>(
      title: context.l10n.entityDiagnosis,
      watch: (db) => DiagnosisHubRepository(db).watch(diagnosisId),
      onEdit: (context, hub) =>
          showDiagnosisForm(context, diagnosis: hub.diagnosis),
      onDelete: (context, hub) =>
          archiveWithUndo(context, 'diagnosis', hub.diagnosis.id),
      body: (context, hub) {
        final d = hub.diagnosis;
        final l10n = context.l10n;
        final period = [
          if (d.startedAt != null)
            l10n.recordsSince(_date(context).format(d.startedAt!)),
          if (d.endedAt != null)
            l10n.recordsUntil(_date(context).format(d.endedAt!)),
        ].join(' ');
        return [
          DetailHeader(
            title: d.title,
            subtitle: [
              diagnosisStatusLabel(d.status),
              if (period.isNotEmpty) period,
            ].join(' · '),
          ),
          if (d.notes?.isNotEmpty == true) Text(d.notes!),
          DetailSection(
            title: l10n.entityAppointments,
            empty: l10n.recordsDiagnosisNoAppointments,
            children: [
              for (final s in hub.appointments) _appointmentTile(context, s),
            ],
          ),
          DetailSection(
            title: l10n.entitySymptoms,
            empty: l10n.recordsNoSymptomsLinked,
            children: [
              for (final s in hub.symptoms)
                _linkTile(
                  context,
                  icon: Icons.healing_outlined,
                  title: s.label,
                  subtitle: s.healedAt == null
                      ? l10n.recordsStatusActive
                      : l10n.recordsStatusHealed,
                  entityType: 'symptom',
                  id: s.id,
                ),
            ],
          ),
          DetailSection(
            title: l10n.entityMedications,
            empty: l10n.recordsNoMedicationsLinked,
            children: [
              for (final m in hub.medications)
                _linkTile(
                  context,
                  icon: Icons.medication_outlined,
                  title: m.name,
                  subtitle: [m.dosage, m.scheduleText]
                      .whereType<String>()
                      .join(' · '),
                  entityType: 'medication',
                  id: m.id,
                ),
            ],
          ),
          DetailSection(
            title: l10n.entityReports,
            empty: l10n.recordsDiagnosisNoReports,
            children: [
              for (final r in hub.reports)
                _linkTile(
                  context,
                  icon: Icons.description_outlined,
                  title: r.title,
                  subtitle: _date(context).format(r.createdAt),
                  entityType: 'report',
                  id: r.id,
                ),
            ],
          ),
          DetailSection(
            title: l10n.entityNotes,
            trailing: TextButton.icon(
              onPressed: () =>
                  showNoteForm(context, relatedDiagnosisId: d.id),
              icon: const Icon(Icons.add),
              label: Text(l10n.commonNote),
            ),
            children: [
              for (final n in hub.notes)
                _linkTile(
                  context,
                  icon: Icons.sticky_note_2_outlined,
                  title: n.body.length > 60
                      ? '${n.body.substring(0, 60)}…'
                      : n.body,
                  subtitle: _date(context).format(n.updatedAt),
                  entityType: 'note',
                  id: n.id,
                ),
            ],
          ),
        ];
      },
    );
  }
}

// --- Symptom ---------------------------------------------------------------

class _SymptomData {
  const _SymptomData(
    this.symptom,
    this.observations,
    this.diagnosis,
    this.doctors,
    this.appointments,
  );

  final Symptom symptom;
  final List<SymptomObservation> observations;
  final Diagnose? diagnosis;
  final List<Doctor> doctors;
  final List<AppointmentSummary> appointments;
}

class SymptomDetailPage extends StatelessWidget {
  const SymptomDetailPage({super.key, required this.symptomId});

  final String symptomId;

  @override
  Widget build(BuildContext context) {
    return _DetailScaffold<_SymptomData>(
      title: context.l10n.entitySymptom,
      watch: (db) => db.watchWith(
        {
          db.symptoms,
          db.symptomObservations,
          db.diagnoses,
          db.doctors,
          db.doctorSymptoms,
          db.appointments,
          db.appointmentSymptoms,
        },
        () async {
          final symptom = await SymptomRepository(db).getById(symptomId);
          if (symptom == null) return null;
          final observations =
              await (db.select(db.symptomObservations)
                    ..where((t) => t.symptomId.equals(symptomId))
                    ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)]))
                  .get();
          final diagnosis = symptom.diagnosisId == null
              ? null
              : await RecordsRepository(db).getDiagnosis(symptom.diagnosisId!);
          final symptomRepo = SymptomRepository(db);
          final appointmentRows =
              await (db.select(db.appointments).join([
                      innerJoin(
                        db.appointmentSymptoms,
                        db.appointmentSymptoms.appointmentId.equalsExp(
                          db.appointments.id,
                        ),
                      ),
                    ])
                    ..where(db.appointmentSymptoms.symptomId.equals(symptomId))
                    ..where(db.appointments.archivedAt.isNull())
                    ..orderBy([OrderingTerm.desc(db.appointments.scheduledAt)]))
                  .get();
          return _SymptomData(
            symptom,
            observations,
            diagnosis,
            await symptomRepo.doctorsFor(symptomId),
            await AppointmentRepository(db).summariesFor([
              for (final r in appointmentRows) r.readTable(db.appointments),
            ]),
          );
        },
      ),
      onEdit: (context, data) =>
          showSymptomForm(context, symptom: data.symptom),
      onDelete: (context, data) =>
          archiveWithUndo(context, 'symptom', data.symptom.id),
      body: (context, data) {
        final s = data.symptom;
        final repo = SymptomRepository(DatabaseScope.of(context));
        final l10n = context.l10n;
        // Ort steht schon im Untertitel; hier Empfindung, Charakter, Seite.
        final defaults = SymptomDescription.fromSymptom(
          s,
        ).copyWith(location: () => null);
        final latest = data.observations
            .where((o) => !SymptomDescription.fromObservation(o).isEmpty)
            .firstOrNull;
        return [
          DetailHeader(
            title: s.label,
            subtitle: [
              if (s.bodyRegion != null) s.bodyRegion!,
              s.healedAt == null
                  ? l10n.recordsStatusActive
                  : l10n.recordsHealedOn(_date(context).format(s.healedAt!)),
            ].join(' · '),
            icon: s.bodyRegion != null
                ? IconMappings.bodyRegionIcon(s.bodyRegion!)
                : null,
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: s.healedAt == null
                ? OutlinedButton.icon(
                    onPressed: () => repo.markHealed(s.id),
                    icon: const Icon(Icons.check),
                    label: Text(l10n.recordsMarkHealed),
                  )
                : OutlinedButton.icon(
                    onPressed: () => repo.reopen(s.id),
                    icon: const Icon(Icons.replay),
                    label: Text(l10n.recordsReopen),
                  ),
          ),
          if (!defaults.isEmpty)
            _infoTile(
              Icons.tune,
              l10n.symptomDefaultsTitle,
              defaults.describe(l10n),
            ),
          if (latest != null)
            _infoTile(
              Icons.short_text,
              '${l10n.symptomLatestDescription} · '
                  '${_dateTime(context).format(latest.recordedAt)}',
              SymptomDescription.fromObservation(latest).describe(l10n),
            ),
          if (data.diagnosis != null)
            _linkTile(
              context,
              icon: Icons.biotech_outlined,
              title: data.diagnosis!.title,
              subtitle: l10n.entityDiagnosis,
              entityType: 'diagnosis',
              id: data.diagnosis!.id,
            ),
          if (data.doctors.isNotEmpty)
            DetailSection(
              title: l10n.entityDoctors,
              children: [
                for (final d in data.doctors)
                  _linkTile(
                    context,
                    icon: d.specialty != null
                        ? IconMappings.specialtyIcon(d.specialty!)
                        : Icons.medical_services_outlined,
                    title: d.name,
                    subtitle: d.specialty,
                    entityType: 'doctor',
                    id: d.id,
                  ),
              ],
            ),
          if (data.appointments.isNotEmpty)
            DetailSection(
              title: l10n.recordsDiscussedAtAppointments,
              children: [
                for (final a in data.appointments) _appointmentTile(context, a),
              ],
            ),
          DetailSection(
            title: l10n.recordsHistory,
            children: [
              ObservationChart(points: scalePoints(data.observations)),
            ],
          ),
          if (data.observations.isNotEmpty)
            DetailSection(
              title: l10n.symptomHeatmapTitle,
              children: [SymptomHeatmap(observations: data.observations)],
            ),
          DetailSection(
            title: l10n.recordsCheckIns,
            empty: l10n.recordsNoCheckIns,
            children: [
              for (final o in data.observations.take(50))
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(observationLabel(o)),
                  subtitle: Text(
                    [
                      _dateTime(context).format(o.recordedAt),
                      if (o.note?.isNotEmpty == true) o.note!,
                    ].join(' · '),
                  ),
                  trailing: IconButton(
                    tooltip: l10n.recordsDeleteValue,
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => repo.deleteObservation(o.id),
                  ),
                ),
            ],
          ),
        ];
      },
    );
  }
}


// --- Medikament ------------------------------------------------------------

class _MedicationData {
  const _MedicationData(this.details, this.intakes, this.adherence);

  final MedicationDetails details;
  final List<MedicationIntake> intakes;
  final double? adherence;
}

class MedicationDetailPage extends StatelessWidget {
  const MedicationDetailPage({super.key, required this.medicationId});

  final String medicationId;

  @override
  Widget build(BuildContext context) {
    return _DetailScaffold<_MedicationData>(
      title: context.l10n.entityMedication,
      watch: (db) {
        final repo = MedicationRepository(db);
        return db.watchWith(repo.tables, () async {
          final details = await repo.get(medicationId);
          if (details == null) return null;
          return _MedicationData(
            details,
            await repo.intakes(medicationId, limit: 30),
            await repo.adherence(medicationId),
          );
        });
      },
      onEdit: (context, data) => showMedicationFormPage(
        context,
        medicationId: data.details.medication.id,
      ),
      onDelete: (context, data) =>
          archiveWithUndo(context, 'medication', data.details.medication.id),
      body: (context, data) {
        final d = data.details;
        final m = d.medication;
        final repo = MedicationRepository(DatabaseScope.of(context));
        final l10n = context.l10n;
        final period = [
          if (m.startedAt != null)
            l10n.recordsFrom(_date(context).format(m.startedAt!)),
          m.endedAt != null
              ? l10n.recordsUntil(_date(context).format(m.endedAt!))
              : l10n.recordsOngoing,
        ].join(' ');
        return [
          DetailHeader(
            title: m.name,
            subtitle: [
              ?m.dosage,
              if (m.form != null) medicationFormLabel(m.form!),
            ].join(' · '),
          ),
          _infoTile(Icons.medication_liquid_outlined, l10n.recordsDosePerIntake, d.doseFor(null)),
          _infoTile(Icons.info_outline, l10n.recordsInstructions, m.instructions),
          _infoTile(Icons.date_range_outlined, l10n.recordsPeriod, period),
          DetailSection(
            title: l10n.recordsIntakeTimes,
            empty: l10n.recordsNoIntakeTimes,
            children: [
              for (final s in d.schedules)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.schedule),
                  title: Text(
                    '${s.hour.toString().padLeft(2, '0')}:'
                    '${s.minute.toString().padLeft(2, '0')}'
                    ' · ${d.doseFor(s) ?? l10n.recordsIntake}',
                  ),
                  subtitle: Text(Weekdays.describe(s.weekdays)),
                ),
              if (d.schedules.isNotEmpty)
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.recordsRemindIntake),
                  value: m.remindersEnabled,
                  onChanged: (v) async {
                    await repo.setRemindersEnabled(m.id, v);
                    if (v && context.mounted) {
                      await ensureNotificationPermission(context);
                    }
                  },
                ),
            ],
          ),
          if (d.prescriber != null)
            _linkTile(
              context,
              icon: Icons.medical_services_outlined,
              title: d.prescriber!.name,
              subtitle: l10n.recordsPrescribedBy,
              entityType: 'doctor',
              id: d.prescriber!.id,
            ),
          if (d.pharmacy != null)
            _linkTile(
              context,
              icon: Icons.local_pharmacy_outlined,
              title: d.pharmacy!.name,
              subtitle: l10n.entityPharmacy,
              entityType: 'pharmacy',
              id: d.pharmacy!.id,
            ),
          if (d.diagnosis != null)
            _linkTile(
              context,
              icon: Icons.biotech_outlined,
              title: d.diagnosis!.title,
              subtitle: l10n.entityDiagnosis,
              entityType: 'diagnosis',
              id: d.diagnosis!.id,
            ),
          _infoTile(Icons.notes_outlined, l10n.commonNotes, m.notes),
          DetailSection(
            title: l10n.recordsIntakeLog,
            trailing: TextButton.icon(
              onPressed: () => repo.recordIntake(
                medicationId: m.id,
                doseAmount: m.doseAmount,
              ),
              icon: const Icon(Icons.add_task),
              label: Text(l10n.recordsTakenNow),
            ),
            empty: l10n.recordsNoIntakesYet,
            children: [
              if (data.adherence != null)
                Text(
                  l10n.recordsAdherence((data.adherence! * 100).round()),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              for (final i in data.intakes)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(
                    i.status == IntakeStatus.taken
                        ? Icons.check_circle_outline
                        : Icons.remove_circle_outline,
                  ),
                  title: Text(
                    i.status == IntakeStatus.taken
                        ? '${l10n.recordsTaken}${i.doseAmount == null ? '' : ' · ${formatAmount(i.doseAmount!)} ${m.doseUnit ?? ''}'}'
                        : l10n.recordsSkipped,
                  ),
                  subtitle: Text(
                    [
                      _dateTime(context).format(i.recordedAt),
                      if (i.scheduledFor != null)
                        l10n.recordsPlannedAt(
                          DateFormat(l10n.recordsTimePattern)
                              .format(i.scheduledFor!),
                        ),
                    ].join(' · '),
                  ),
                  trailing: IconButton(
                    tooltip: l10n.recordsDeleteEntry,
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => repo.deleteIntake(i.id),
                  ),
                ),
            ],
          ),
        ];
      },
    );
  }
}

// --- Apotheke --------------------------------------------------------------

class _PharmacyData {
  const _PharmacyData(this.pharmacy, this.medications);

  final Pharmacy pharmacy;
  final List<Medication> medications;
}

class PharmacyDetailPage extends StatelessWidget {
  const PharmacyDetailPage({super.key, required this.pharmacyId});

  final String pharmacyId;

  @override
  Widget build(BuildContext context) {
    return _DetailScaffold<_PharmacyData>(
      title: context.l10n.entityPharmacy,
      watch: (db) => db.watchWith({db.pharmacies, db.medications}, () async {
        final repo = PharmacyRepository(db);
        final p = await repo.get(pharmacyId);
        if (p == null) return null;
        return _PharmacyData(p, await repo.medicationsFor(pharmacyId));
      }),
      onEdit: (context, data) =>
          showPharmacyForm(context, pharmacy: data.pharmacy),
      onDelete: (context, data) =>
          archiveWithUndo(context, 'pharmacy', data.pharmacy.id),
      body: (context, data) {
        final p = data.pharmacy;
        final l10n = context.l10n;
        return [
          DetailHeader(title: p.name),
          _infoTile(
            Icons.phone_outlined,
            l10n.recordsPhoneTapToCall,
            p.phone,
            onTap: () => launchUrl(Uri(scheme: 'tel', path: p.phone)),
          ),
          _infoTile(
            Icons.place_outlined,
            l10n.recordsAddressOpenMaps,
            p.address,
            onTap: () => launchUrl(
              Uri.parse('geo:0,0?q=${Uri.encodeComponent(p.address ?? '')}'),
            ),
          ),
          _infoTile(Icons.notes_outlined, l10n.commonNotes, p.notes),
          DetailSection(
            title: l10n.entityMedications,
            empty: l10n.recordsPharmacyNoMedications,
            children: [
              for (final m in data.medications)
                _linkTile(
                  context,
                  icon: Icons.medication_outlined,
                  title: m.name,
                  subtitle: m.dosage,
                  entityType: 'medication',
                  id: m.id,
                ),
            ],
          ),
        ];
      },
    );
  }
}

// --- Impfung --------------------------------------------------------------

class VaccinationDetailPage extends StatelessWidget {
  const VaccinationDetailPage({super.key, required this.vaccinationId});

  final String vaccinationId;

  @override
  Widget build(BuildContext context) {
    return _DetailScaffold<(Vaccination, Doctor?)>(
      title: context.l10n.entityVaccination,
      watch: (db) => db.watchWith({db.vaccinations, db.doctors}, () async {
        final v = await VaccinationRepository(db).get(vaccinationId);
        if (v == null) return null;
        final doctor = v.doctorId == null
            ? null
            : await DoctorRepository(db).getById(v.doctorId!);
        return (v, doctor);
      }),
      onEdit: (context, data) =>
          showVaccinationForm(context, vaccination: data.$1),
      onDelete: (context, data) =>
          archiveWithUndo(context, 'vaccination', data.$1.id),
      body: (context, data) {
        final (v, doctor) = data;
        final due = v.nextDueAt;
        final l10n = context.l10n;
        return [
          DetailHeader(
            title: v.vaccine,
            subtitle: [
              _date(context).format(v.administeredAt),
              if (v.doseNumber != null) l10n.recordsDoseNumber(v.doseNumber!),
            ].join(' · '),
          ),
          _infoTile(Icons.vaccines_outlined, l10n.recordsVaccineProduct, v.product),
          _infoTile(Icons.qr_code_2, l10n.recordsBatch, v.batch),
          if (due != null)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.event_repeat,
                color: due.isBefore(DateTime.now())
                    ? Theme.of(context).colorScheme.error
                    : null,
              ),
              title: Text(_date(context).format(due)),
              subtitle: Text(
                due.isBefore(DateTime.now())
                    ? l10n.recordsBoosterOverdue
                    : l10n.recordsNextDoseDue,
              ),
            ),
          if (doctor != null)
            _linkTile(
              context,
              icon: Icons.medical_services_outlined,
              title: doctor.name,
              subtitle: l10n.recordsVaccinatedBy,
              entityType: 'doctor',
              id: doctor.id,
            ),
          _infoTile(Icons.notes_outlined, l10n.commonNotes, v.notes),
        ];
      },
    );
  }
}

// --- Notiz -----------------------------------------------------------------

class NoteDetailPage extends StatelessWidget {
  const NoteDetailPage({super.key, required this.noteId});

  final String noteId;

  @override
  Widget build(BuildContext context) {
    return _DetailScaffold<Note>(
      title: context.l10n.entityNote,
      watch: (db) =>
          db.watchWith({db.notes}, () => RecordsRepository(db).getNote(noteId)),
      onEdit: (context, note) => showNoteForm(context, note: note),
      onDelete: (context, note) =>
          archiveWithUndo(context, 'note', note.id),
      body: (context, note) => [
        Text(
          context.l10n.recordsLastModified(
            _dateTime(context).format(note.updatedAt),
          ),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        SelectableText(
          note.body,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        if (note.relatedAppointmentId != null)
          _linkTile(
            context,
            icon: Icons.event_outlined,
            title: context.l10n.recordsRelatedAppointment,
            entityType: 'appointment',
            id: note.relatedAppointmentId!,
          ),
        if (note.relatedDiagnosisId != null)
          _linkTile(
            context,
            icon: Icons.biotech_outlined,
            title: context.l10n.recordsRelatedDiagnosis,
            entityType: 'diagnosis',
            id: note.relatedDiagnosisId!,
          ),
      ],
    );
  }
}
