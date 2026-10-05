import 'package:drift/drift.dart' show OrderingTerm;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/appointment_repository.dart';
import '../../data/repositories/diagnosis_hub_repository.dart';
import '../../data/repositories/doctor_repository.dart';
import '../../data/repositories/records_repository.dart';
import '../../data/repositories/symptom_repository.dart';
import '../../widgets/observation_chart.dart';
import '../home/appointment_detail_page.dart';
import '../reports/report_viewer_page.dart';
import 'entity_forms.dart';

final _date = DateFormat('d. MMM yyyy', 'de');
final _dateTime = DateFormat('d. MMM yyyy · HH:mm', 'de');

/// Öffnet die passende Detailseite für einen Akten-Eintrag.
void openRecord(BuildContext context, String entityType, String id) {
  final Widget page = switch (entityType) {
    'appointment' => AppointmentDetailPage(appointmentId: id),
    'report' => ReportViewerPage(reportId: id),
    'doctor' => DoctorDetailPage(doctorId: id),
    'diagnosis' => DiagnosisDetailPage(diagnosisId: id),
    'symptom' => SymptomDetailPage(symptomId: id),
    'medication' => MedicationDetailPage(medicationId: id),
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
                      tooltip: 'Bearbeiten',
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () => widget.onEdit(context, value),
                    ),
                    IconButton(
                      tooltip: 'Löschen',
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
                      : const Text('Eintrag nicht gefunden'),
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
  const DetailHeader({super.key, required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
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
      _dateTime.format(a.scheduledAt),
      if (a.status != AppointmentStatus.planned)
        appointmentStatusLabel(a.status),
    ].join(' · '),
    entityType: 'appointment',
    id: a.id,
  );
}

// --- Arzt ------------------------------------------------------------------

class _DoctorData {
  const _DoctorData(this.doctor, this.appointments);

  final Doctor doctor;
  final List<AppointmentSummary> appointments;
}

class DoctorDetailPage extends StatelessWidget {
  const DoctorDetailPage({super.key, required this.doctorId});

  final String doctorId;

  @override
  Widget build(BuildContext context) {
    return _DetailScaffold<_DoctorData>(
      title: 'Arzt',
      watch: (db) => db.watchWith({db.doctors, db.appointments}, () async {
        final doctor = await DoctorRepository(db).getById(doctorId);
        if (doctor == null) return null;
        final appointments =
            await (db.select(db.appointments)
                  ..where((t) => t.doctorId.equals(doctorId))
                  ..orderBy([(t) => OrderingTerm.desc(t.scheduledAt)]))
                .get();
        return _DoctorData(
          doctor,
          await AppointmentRepository(db).summariesFor(appointments),
        );
      }),
      onEdit: (context, data) => showDoctorForm(context, doctor: data.doctor),
      onDelete: (context, data) async {
        if (data.appointments.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Arzt hat noch Termine — erst Termine löschen oder umhängen.',
              ),
            ),
          );
          return false;
        }
        final repo = DoctorRepository(DatabaseScope.of(context));
        if (!await confirmDelete(context, what: 'Arzt')) return false;
        return repo.delete(data.doctor.id);
      },
      body: (context, data) {
        final d = data.doctor;
        return [
          DetailHeader(title: d.name, subtitle: d.specialty),
          _infoTile(Icons.business_outlined, 'Praxis', d.practiceName),
          _infoTile(
            Icons.phone_outlined,
            'Telefon · tippen zum Anrufen',
            d.phone,
            onTap: () => launchUrl(Uri(scheme: 'tel', path: d.phone)),
          ),
          _infoTile(
            Icons.place_outlined,
            'Adresse · in Karten öffnen',
            d.address,
            onTap: () => launchUrl(
              Uri.parse('geo:0,0?q=${Uri.encodeComponent(d.address ?? '')}'),
            ),
          ),
          _infoTile(Icons.notes_outlined, 'Notizen', d.notes),
          DetailSection(
            title: 'Termine',
            empty: 'Keine Termine bei diesem Arzt.',
            children: [
              for (final s in data.appointments) _appointmentTile(context, s),
            ],
          ),
        ];
      },
    );
  }
}

// --- Diagnose (Hub) --------------------------------------------------------

class DiagnosisDetailPage extends StatelessWidget {
  const DiagnosisDetailPage({super.key, required this.diagnosisId});

  final String diagnosisId;

  @override
  Widget build(BuildContext context) {
    return _DetailScaffold<DiagnosisHub>(
      title: 'Diagnose',
      watch: (db) => DiagnosisHubRepository(db).watch(diagnosisId),
      onEdit: (context, hub) =>
          showDiagnosisForm(context, diagnosis: hub.diagnosis),
      onDelete: (context, hub) async {
        final repo = RecordsRepository(DatabaseScope.of(context));
        if (!await confirmDelete(
          context,
          what: 'Diagnose',
          detail:
              'Verknüpfte Termine, Symptome, Medikamente und Notizen bleiben '
              'erhalten, verlieren aber den Bezug.',
        )) {
          return false;
        }
        await repo.deleteDiagnosis(hub.diagnosis.id);
        return true;
      },
      body: (context, hub) {
        final d = hub.diagnosis;
        final period = [
          if (d.startedAt != null) 'seit ${_date.format(d.startedAt!)}',
          if (d.endedAt != null) 'bis ${_date.format(d.endedAt!)}',
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
            title: 'Termine',
            empty: 'Noch keinem Termin zugeordnet.',
            children: [
              for (final s in hub.appointments) _appointmentTile(context, s),
            ],
          ),
          DetailSection(
            title: 'Symptome',
            empty: 'Keine Symptome verknüpft.',
            children: [
              for (final s in hub.symptoms)
                _linkTile(
                  context,
                  icon: Icons.healing_outlined,
                  title: s.label,
                  subtitle: s.healedAt == null ? 'aktiv' : 'geheilt',
                  entityType: 'symptom',
                  id: s.id,
                ),
            ],
          ),
          DetailSection(
            title: 'Medikamente',
            empty: 'Keine Medikamente verknüpft.',
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
            title: 'Berichte',
            empty: 'Keine Berichte zu den Terminen.',
            children: [
              for (final r in hub.reports)
                _linkTile(
                  context,
                  icon: Icons.description_outlined,
                  title: r.title,
                  subtitle: _date.format(r.createdAt),
                  entityType: 'report',
                  id: r.id,
                ),
            ],
          ),
          DetailSection(
            title: 'Notizen',
            trailing: TextButton.icon(
              onPressed: () =>
                  showNoteForm(context, relatedDiagnosisId: d.id),
              icon: const Icon(Icons.add),
              label: const Text('Notiz'),
            ),
            children: [
              for (final n in hub.notes)
                _linkTile(
                  context,
                  icon: Icons.sticky_note_2_outlined,
                  title: n.body.length > 60
                      ? '${n.body.substring(0, 60)}…'
                      : n.body,
                  subtitle: _date.format(n.updatedAt),
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
  const _SymptomData(this.symptom, this.observations, this.diagnosis);

  final Symptom symptom;
  final List<SymptomObservation> observations;
  final Diagnose? diagnosis;
}

class SymptomDetailPage extends StatelessWidget {
  const SymptomDetailPage({super.key, required this.symptomId});

  final String symptomId;

  @override
  Widget build(BuildContext context) {
    return _DetailScaffold<_SymptomData>(
      title: 'Symptom',
      watch: (db) => db.watchWith(
        {db.symptoms, db.symptomObservations, db.diagnoses},
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
          return _SymptomData(symptom, observations, diagnosis);
        },
      ),
      onEdit: (context, data) =>
          showSymptomForm(context, symptom: data.symptom),
      onDelete: (context, data) async {
        final repo = SymptomRepository(DatabaseScope.of(context));
        if (!await confirmDelete(
          context,
          what: 'Symptom',
          detail: 'Alle Check-in-Werte dieses Symptoms werden mitgelöscht.',
        )) {
          return false;
        }
        await repo.delete(data.symptom.id);
        return true;
      },
      body: (context, data) {
        final s = data.symptom;
        final repo = SymptomRepository(DatabaseScope.of(context));
        return [
          DetailHeader(
            title: s.label,
            subtitle: [
              if (s.bodyRegion != null) s.bodyRegion!,
              s.healedAt == null
                  ? 'aktiv'
                  : 'geheilt am ${_date.format(s.healedAt!)}',
            ].join(' · '),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: s.healedAt == null
                ? OutlinedButton.icon(
                    onPressed: () => repo.markHealed(s.id),
                    icon: const Icon(Icons.check),
                    label: const Text('Als geheilt markieren'),
                  )
                : OutlinedButton.icon(
                    onPressed: () => repo.reopen(s.id),
                    icon: const Icon(Icons.replay),
                    label: const Text('Wieder aktiv'),
                  ),
          ),
          if (data.diagnosis != null)
            _linkTile(
              context,
              icon: Icons.biotech_outlined,
              title: data.diagnosis!.title,
              subtitle: 'Diagnose',
              entityType: 'diagnosis',
              id: data.diagnosis!.id,
            ),
          DetailSection(
            title: 'Verlauf',
            children: [
              ObservationChart(points: scalePoints(data.observations)),
            ],
          ),
          DetailSection(
            title: 'Check-ins',
            empty: 'Noch keine Check-ins.',
            children: [
              for (final o in data.observations.take(50))
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(_observationLabel(o)),
                  subtitle: Text(
                    [
                      _dateTime.format(o.recordedAt),
                      if (o.note?.isNotEmpty == true) o.note!,
                    ].join(' · '),
                  ),
                  trailing: IconButton(
                    tooltip: 'Wert löschen',
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

String _observationLabel(SymptomObservation o) => switch (o.kind) {
  ObservationKind.scale_1_10 =>
    'Stärke ${o.valueNumber?.toStringAsFixed(0) ?? '–'}/10',
  ObservationKind.quantity =>
    '${o.valueNumber?.toString() ?? '–'} ${o.unit ?? ''}'.trim(),
  ObservationKind.color => 'Farbe ${o.valueColor ?? o.valueText ?? ''}',
  ObservationKind.note => o.valueText ?? o.note ?? 'Notiz',
};

// --- Medikament ------------------------------------------------------------

class _MedicationData {
  const _MedicationData(this.medication, this.diagnosis);

  final Medication medication;
  final Diagnose? diagnosis;
}

class MedicationDetailPage extends StatelessWidget {
  const MedicationDetailPage({super.key, required this.medicationId});

  final String medicationId;

  @override
  Widget build(BuildContext context) {
    return _DetailScaffold<_MedicationData>(
      title: 'Medikament',
      watch: (db) => db.watchWith({db.medications, db.diagnoses}, () async {
        final records = RecordsRepository(db);
        final m = await records.getMedication(medicationId);
        if (m == null) return null;
        final d = m.diagnosisId == null
            ? null
            : await records.getDiagnosis(m.diagnosisId!);
        return _MedicationData(m, d);
      }),
      onEdit: (context, data) =>
          showMedicationForm(context, medication: data.medication),
      onDelete: (context, data) async {
        final repo = RecordsRepository(DatabaseScope.of(context));
        if (!await confirmDelete(context, what: 'Medikament')) return false;
        await repo.deleteMedication(data.medication.id);
        return true;
      },
      body: (context, data) {
        final m = data.medication;
        final period = [
          if (m.startedAt != null) 'ab ${_date.format(m.startedAt!)}',
          if (m.endedAt != null) 'bis ${_date.format(m.endedAt!)}',
        ].join(' ');
        return [
          DetailHeader(title: m.name, subtitle: m.dosage),
          _infoTile(Icons.schedule_outlined, 'Einnahmeplan', m.scheduleText),
          _infoTile(Icons.date_range_outlined, 'Zeitraum', period),
          _infoTile(Icons.notes_outlined, 'Notizen', m.notes),
          if (data.diagnosis != null)
            _linkTile(
              context,
              icon: Icons.biotech_outlined,
              title: data.diagnosis!.title,
              subtitle: 'Diagnose',
              entityType: 'diagnosis',
              id: data.diagnosis!.id,
            ),
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
      title: 'Notiz',
      watch: (db) =>
          db.watchWith({db.notes}, () => RecordsRepository(db).getNote(noteId)),
      onEdit: (context, note) => showNoteForm(context, note: note),
      onDelete: (context, note) async {
        final repo = RecordsRepository(DatabaseScope.of(context));
        if (!await confirmDelete(context, what: 'Notiz')) return false;
        await repo.deleteNote(note.id);
        return true;
      },
      body: (context, note) => [
        Text(
          'Zuletzt geändert ${_dateTime.format(note.updatedAt)}',
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
            title: 'Zugehöriger Termin',
            entityType: 'appointment',
            id: note.relatedAppointmentId!,
          ),
        if (note.relatedDiagnosisId != null)
          _linkTile(
            context,
            icon: Icons.biotech_outlined,
            title: 'Zugehörige Diagnose',
            entityType: 'diagnosis',
            id: note.relatedDiagnosisId!,
          ),
      ],
    );
  }
}
