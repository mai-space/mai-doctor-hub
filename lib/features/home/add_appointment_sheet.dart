import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/appointment_repository.dart';
import '../../data/repositories/doctor_repository.dart';
import '../../data/repositories/records_repository.dart';
import '../../data/repositories/suggestion_repository.dart';
import '../../data/repositories/symptom_repository.dart';
import '../../theme/app_theme.dart';
import '../../widgets/suggestion_text_field.dart';

Future<String?> showAddAppointmentSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => const AddAppointmentSheet(),
  );
}

class AddAppointmentSheet extends StatefulWidget {
  const AddAppointmentSheet({super.key});

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
  bool _saving = false;

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
            const SnackBar(content: Text('Arztname fehlt')),
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
          const SnackBar(content: Text('Bitte einen Arzt wählen')),
        );
        return;
      }

      final id = await appointments.create(
        doctorId: doctorId,
        scheduledAt: _scheduledAt,
        title: _titleController.text.trim().isEmpty
            ? null
            : _titleController.text.trim(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        diagnosisIds: _diagnosisIds.toList(),
        symptomIds: _symptomIds.toList(),
      );

      if (!mounted) return;
      Navigator.of(context).pop(id);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = DatabaseScope.of(context);
    final doctorRepo = DoctorRepository(db);
    final recordsRepo = RecordsRepository(db);
    final symptomRepo = SymptomRepository(db);
    final bottom = MediaQuery.viewInsetsOf(context).bottom;
    final dateLabel = DateFormat('EEE, d. MMM yyyy · HH:mm', 'de').format(
      _scheduledAt,
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 20 + bottom),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Termin hinzufügen',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.schedule),
              title: const Text('Datum & Uhrzeit'),
              subtitle: Text(dateLabel),
              trailing: const Icon(Icons.edit_outlined),
              onTap: _pickDateTime,
            ),
            const SizedBox(height: 8),
            SuggestionTextField(
              controller: _titleController,
              field: SuggestionField.appointmentTitle,
              decoration: const InputDecoration(
                labelText: 'Titel (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Arzt',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Vorhanden')),
                ButtonSegment(value: true, label: Text('Neu anlegen')),
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
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              SuggestionTextField(
                controller: _newDoctorSpecialty,
                field: SuggestionField.specialty,
                decoration: const InputDecoration(
                  labelText: 'Fachrichtung (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ] else
              StreamBuilder<List<Doctor>>(
                stream: doctorRepo.watchAll(),
                builder: (context, snapshot) {
                  final doctors = snapshot.data ?? const [];
                  if (doctors.isEmpty) {
                    return Text(
                      'Noch keine Ärzte — wechsle zu „Neu anlegen“.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: AppColors.muted),
                    );
                  }
                  return DropdownMenu<String>(
                    initialSelection: _doctorId,
                    label: const Text('Arzt wählen'),
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
              'Diagnosen (optional)',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            StreamBuilder<List<Diagnose>>(
              stream: recordsRepo.watchDiagnoses(),
              builder: (context, snapshot) {
                final diagnoses = snapshot.data ?? const [];
                if (diagnoses.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Keine Diagnosen — in der Akte anlegbar.',
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
              'Symptome (optional)',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            StreamBuilder<List<Symptom>>(
              stream: symptomRepo.watchOpen(),
              builder: (context, snapshot) {
                final symptoms = snapshot.data ?? const [];
                if (symptoms.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Keine offenen Symptome — in der Akte anlegbar.',
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
              decoration: const InputDecoration(
                labelText: 'Notizen',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(_saving ? 'Speichern…' : 'Termin speichern'),
            ),
          ],
        ),
      ),
    );
  }
}
