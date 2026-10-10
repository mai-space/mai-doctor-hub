import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/appointment_repository.dart';
import '../../data/repositories/doctor_repository.dart';
import '../../data/repositories/records_repository.dart';
import '../../data/repositories/suggestion_repository.dart';
import '../../data/repositories/symptom_repository.dart';
import '../../l10n/l10n.dart';
import '../../theme/app_theme.dart';
import '../../widgets/suggestion_text_field.dart';

Future<String?> showAddAppointmentSheet(
  BuildContext context, {
  AppointmentSummary? initial,
  DateTime? at,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => AddAppointmentSheet(initial: initial, at: at),
  );
}

const _durationOptions = [15, 30, 45, 60, 90, 120];

/// Anlegen oder — mit [initial] — Bearbeiten eines Termins.
class AddAppointmentSheet extends StatefulWidget {
  const AddAppointmentSheet({super.key, this.initial, this.at});

  final AppointmentSummary? initial;

  /// Vorgabe für Datum/Uhrzeit eines neuen Termins (z. B. aus dem Kalender).
  final DateTime? at;

  @override
  State<AddAppointmentSheet> createState() => _AddAppointmentSheetState();
}

class _AddAppointmentSheetState extends State<AddAppointmentSheet> {
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  final _newDoctorController = TextEditingController();
  final _newDoctorSpecialty = TextEditingController();

  DateTime _scheduledAt = DateTime.now().add(const Duration(hours: 1));
  String? _doctorId;
  bool _creatingDoctor = false;
  final Set<String> _diagnosisIds = {};
  final Set<String> _symptomIds = {};
  int? _durationMin;
  bool _saving = false;

  Stream<List<Doctor>>? _doctors;
  Stream<List<Diagnose>>? _diagnoses;
  Stream<List<Symptom>>? _symptoms;

  bool get _editing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    if (initial == null && widget.at != null) _scheduledAt = widget.at!;
    if (initial != null) {
      final a = initial.appointment;
      _scheduledAt = a.scheduledAt;
      _doctorId = a.doctorId;
      _durationMin = a.durationMin;
      _titleController.text = a.title ?? '';
      _notesController.text = a.notes ?? '';
      _diagnosisIds.addAll(initial.diagnosisIds);
      _symptomIds.addAll(initial.symptomIds);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final db = DatabaseScope.of(context);
    _doctors ??= DoctorRepository(db).watchAll();
    _diagnoses ??= RecordsRepository(db).watchDiagnoses();
    _symptoms ??= SymptomRepository(db).watchAll();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _newDoctorController.dispose();
    _newDoctorSpecialty.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _scheduledAt,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_scheduledAt),
    );
    if (time == null) return;
    setState(() {
      _scheduledAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  Future<void> _save() async {
    final db = DatabaseScope.of(context);
    final doctors = DoctorRepository(db);
    final appointments = AppointmentRepository(db);

    setState(() => _saving = true);
    try {
      var doctorId = _doctorId;
      if (_creatingDoctor) {
        final name = _newDoctorController.text.trim();
        if (name.isEmpty) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.homeDoctorNameMissing)),
          );
          return;
        }
        doctorId = await doctors.create(
          name: name,
          specialty: _newDoctorSpecialty.text.trim().isEmpty
              ? null
              : _newDoctorSpecialty.text.trim(),
        );
      }
      if (doctorId == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(context.l10n.homePleaseChooseDoctor)),
        );
        return;
      }

      final title = _titleController.text.trim().isEmpty
          ? null
          : _titleController.text.trim();
      final notes = _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim();
      final String id;
      if (_editing) {
        id = widget.initial!.appointment.id;
        await appointments.update(
          id: id,
          doctorId: doctorId,
          scheduledAt: _scheduledAt,
          durationMin: _durationMin,
          title: title,
          notes: notes,
          diagnosisIds: _diagnosisIds.toList(),
          symptomIds: _symptomIds.toList(),
        );
      } else {
        id = await appointments.create(
          doctorId: doctorId,
          scheduledAt: _scheduledAt,
          durationMin: _durationMin,
          title: title,
          notes: notes,
          diagnosisIds: _diagnosisIds.toList(),
          symptomIds: _symptomIds.toList(),
        );
      }

      if (!mounted) return;
      Navigator.of(context).pop(id);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    final l10n = context.l10n;
    final dateLabel = DateFormat(l10n.homeSheetDateTimePattern).format(
      _scheduledAt,
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 20 + bottom),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _editing ? l10n.homeEditAppointment : l10n.homeAddAppointment,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.schedule),
              title: Text(l10n.homeDateAndTime),
              subtitle: Text(dateLabel),
              trailing: const Icon(Icons.edit_outlined),
              onTap: _pickDateTime,
            ),
            DropdownMenu<int?>(
              initialSelection: _durationMin,
              label: Text(l10n.homeDuration),
              expandedInsets: EdgeInsets.zero,
              dropdownMenuEntries: [
                DropdownMenuEntry(value: null, label: l10n.commonNone),
                for (final minutes in _durationOptions)
                  DropdownMenuEntry(
                    value: minutes,
                    label: l10n.homeDurationMinutes(minutes),
                  ),
              ],
              onSelected: (value) => setState(() => _durationMin = value),
            ),
            const SizedBox(height: 12),
            SuggestionTextField(
              controller: _titleController,
              field: SuggestionField.appointmentTitle,
              decoration: InputDecoration(
                labelText: l10n.homeTitleOptional,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.entityDoctor,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            SegmentedButton<bool>(
              segments: [
                ButtonSegment(value: false, label: Text(l10n.homeDoctorExisting)),
                ButtonSegment(value: true, label: Text(l10n.homeDoctorCreateNew)),
              ],
              selected: {_creatingDoctor},
              onSelectionChanged: (value) {
                setState(() {
                  _creatingDoctor = value.first;
                  if (_creatingDoctor) _doctorId = null;
                });
              },
            ),
            const SizedBox(height: 12),
            if (_creatingDoctor) ...[
              TextField(
                controller: _newDoctorController,
                decoration: InputDecoration(
                  labelText: l10n.homeDoctorName,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              SuggestionTextField(
                controller: _newDoctorSpecialty,
                field: SuggestionField.specialty,
                decoration: InputDecoration(
                  labelText: l10n.homeSpecialtyOptional,
                  border: OutlineInputBorder(),
                ),
              ),
            ] else
              StreamBuilder<List<Doctor>>(
                stream: _doctors,
                builder: (context, snapshot) {
                  final doctors = snapshot.data ?? const [];
                  if (doctors.isEmpty) {
                    return Text(
                      l10n.homeNoDoctorsYet,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
                    );
                  }
                  return DropdownMenu<String>(
                    initialSelection: _doctorId,
                    label: Text(l10n.homeChooseDoctor),
                    expandedInsets: EdgeInsets.zero,
                    dropdownMenuEntries: [
                      for (final doctor in doctors)
                        DropdownMenuEntry(
                          value: doctor.id,
                          label: doctor.name,
                        ),
                    ],
                    onSelected: (value) => setState(() => _doctorId = value),
                  );
                },
              ),
            const SizedBox(height: 16),
            Text(
              l10n.homeDiagnosesOptional,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            StreamBuilder<List<Diagnose>>(
              stream: _diagnoses,
              builder: (context, snapshot) {
                final diagnoses = snapshot.data ?? const [];
                if (diagnoses.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      l10n.homeNoDiagnoses,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
                    ),
                  );
                }
                return Wrap(
                  spacing: 8,
                  children: [
                    for (final d in diagnoses)
                      FilterChip(
                        label: Text(d.title),
                        selected: _diagnosisIds.contains(d.id),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _diagnosisIds.add(d.id);
                            } else {
                              _diagnosisIds.remove(d.id);
                            }
                          });
                        },
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            Text(
              l10n.homeSymptomsOptional,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            StreamBuilder<List<Symptom>>(
              stream: _symptoms,
              builder: (context, snapshot) {
                // Offene Symptome + bereits verknüpfte (auch geheilte).
                final symptoms = (snapshot.data ?? const <Symptom>[])
                    .where(
                      (s) => s.healedAt == null || _symptomIds.contains(s.id),
                    )
                    .toList();
                if (symptoms.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      l10n.homeNoOpenSymptoms,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.muted),
                    ),
                  );
                }
                return Wrap(
                  spacing: 8,
                  children: [
                    for (final s in symptoms)
                      FilterChip(
                        label: Text(s.label),
                        selected: _symptomIds.contains(s.id),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _symptomIds.add(s.id);
                            } else {
                              _symptomIds.remove(s.id);
                            }
                          });
                        },
                      ),
                  ],
                );
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: l10n.commonNotes,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(
                _saving
                    ? l10n.homeSaving
                    : _editing
                    ? l10n.homeSaveChanges
                    : l10n.homeSaveAppointment,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
