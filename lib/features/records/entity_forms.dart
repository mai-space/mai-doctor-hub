import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/doctor_repository.dart';
import '../../data/repositories/records_repository.dart';
import '../../data/repositories/suggestion_repository.dart';
import '../../data/repositories/symptom_repository.dart';
import '../../services/report_import_service.dart';
import '../../widgets/suggestion_text_field.dart';
import '../medications/medication_form_page.dart';

String? _trimOrNull(TextEditingController c) {
  final value = c.text.trim();
  return value.isEmpty ? null : value;
}

/// Gemeinsamer Dialog-Rahmen für Anlegen/Bearbeiten.
Future<bool> _showFormDialog(
  BuildContext context, {
  required String title,
  required List<Widget> Function(StateSetter setState) fields,
}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(title),
        scrollable: true,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: fields(setState),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Speichern'),
          ),
        ],
      ),
    ),
  );
  return ok == true && context.mounted;
}

/// Auswahl einer (optionalen) Diagnose als Dropdown.
class DiagnosisPicker extends StatelessWidget {
  const DiagnosisPicker({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Diagnose>>(
      future: RecordsRepository(
        DatabaseScope.of(context),
      ).watchDiagnoses().first,
      builder: (context, snapshot) {
        final diagnoses = snapshot.data ?? const <Diagnose>[];
        if (diagnoses.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: DropdownMenu<String?>(
            initialSelection: value,
            label: const Text('Diagnose'),
            expandedInsets: EdgeInsets.zero,
            dropdownMenuEntries: [
              const DropdownMenuEntry(value: null, label: 'Keine'),
              for (final d in diagnoses)
                DropdownMenuEntry(value: d.id, label: d.title),
            ],
            onSelected: onChanged,
          ),
        );
      },
    );
  }
}

/// Datumsfeld mit Löschen-Knopf.
class DateField extends StatelessWidget {
  const DateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(
        value == null ? '—' : DateFormat('d. MMM yyyy', 'de').format(value!),
      ),
      trailing: value == null
          ? const Icon(Icons.event_outlined)
          : IconButton(
              tooltip: '$label entfernen',
              icon: const Icon(Icons.clear),
              onPressed: () => onChanged(null),
            ),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (picked != null) onChanged(picked);
      },
    );
  }
}

Future<String?> showDoctorForm(BuildContext context, {Doctor? doctor}) async {
  final name = TextEditingController(text: doctor?.name);
  final specialty = TextEditingController(text: doctor?.specialty);
  final practice = TextEditingController(text: doctor?.practiceName);
  final phone = TextEditingController(text: doctor?.phone);
  final address = TextEditingController(text: doctor?.address);
  final notes = TextEditingController(text: doctor?.notes);
  final repo = DoctorRepository(DatabaseScope.of(context));

  final ok = await _showFormDialog(
    context,
    title: doctor == null ? 'Arzt anlegen' : 'Arzt bearbeiten',
    fields: (_) => [
      TextField(
        controller: name,
        decoration: const InputDecoration(labelText: 'Name'),
        textCapitalization: TextCapitalization.words,
        autofocus: doctor == null,
      ),
      SuggestionTextField(
        controller: specialty,
        field: SuggestionField.specialty,
        decoration: const InputDecoration(labelText: 'Fachrichtung'),
      ),
      TextField(
        controller: practice,
        decoration: const InputDecoration(labelText: 'Praxis / Klinik'),
      ),
      TextField(
        controller: phone,
        keyboardType: TextInputType.phone,
        decoration: const InputDecoration(labelText: 'Telefon'),
      ),
      TextField(
        controller: address,
        maxLines: 2,
        decoration: const InputDecoration(labelText: 'Adresse'),
      ),
      TextField(
        controller: notes,
        maxLines: 3,
        decoration: const InputDecoration(labelText: 'Notizen'),
      ),
    ],
  );
  if (!ok || name.text.trim().isEmpty) return null;
  if (doctor == null) {
    return repo.create(
      name: name.text.trim(),
      specialty: _trimOrNull(specialty),
      practiceName: _trimOrNull(practice),
      phone: _trimOrNull(phone),
      address: _trimOrNull(address),
      notes: _trimOrNull(notes),
    );
  }
  await repo.update(
    id: doctor.id,
    name: name.text.trim(),
    specialty: _trimOrNull(specialty),
    practiceName: _trimOrNull(practice),
    phone: _trimOrNull(phone),
    address: _trimOrNull(address),
    notes: _trimOrNull(notes),
  );
  return doctor.id;
}

Future<String?> showDiagnosisForm(
  BuildContext context, {
  Diagnose? diagnosis,
}) async {
  final title = TextEditingController(text: diagnosis?.title);
  final notes = TextEditingController(text: diagnosis?.notes);
  var status = diagnosis?.status ?? DiagnosisStatus.active;
  var startedAt = diagnosis?.startedAt;
  var endedAt = diagnosis?.endedAt;
  final repo = RecordsRepository(DatabaseScope.of(context));

  final ok = await _showFormDialog(
    context,
    title: diagnosis == null ? 'Diagnose anlegen' : 'Diagnose bearbeiten',
    fields: (setState) => [
      SuggestionTextField(
        controller: title,
        field: SuggestionField.diagnosisTitle,
        decoration: const InputDecoration(labelText: 'Titel'),
        autofocus: diagnosis == null,
      ),
      TextField(
        controller: notes,
        maxLines: 3,
        decoration: const InputDecoration(labelText: 'Notizen'),
      ),
      const SizedBox(height: 12),
      SegmentedButton<DiagnosisStatus>(
        segments: const [
          ButtonSegment(value: DiagnosisStatus.active, label: Text('Aktiv')),
          ButtonSegment(
            value: DiagnosisStatus.resolved,
            label: Text('Abgeschlossen'),
          ),
        ],
        selected: {status},
        onSelectionChanged: (v) => setState(() => status = v.first),
      ),
      DateField(
        label: 'Seit',
        value: startedAt,
        onChanged: (v) => setState(() => startedAt = v),
      ),
      if (status == DiagnosisStatus.resolved)
        DateField(
          label: 'Bis',
          value: endedAt,
          onChanged: (v) => setState(() => endedAt = v),
        ),
    ],
  );
  if (!ok || title.text.trim().isEmpty) return null;
  if (diagnosis == null) {
    final id = await repo.createDiagnosis(
      title: title.text.trim(),
      notes: _trimOrNull(notes),
      status: status,
    );
    if (startedAt != null || endedAt != null) {
      await repo.updateDiagnosis(
        id: id,
        title: title.text.trim(),
        notes: _trimOrNull(notes),
        status: status,
        startedAt: startedAt,
        endedAt: status == DiagnosisStatus.resolved ? endedAt : null,
      );
    }
    return id;
  }
  await repo.updateDiagnosis(
    id: diagnosis.id,
    title: title.text.trim(),
    notes: _trimOrNull(notes),
    status: status,
    startedAt: startedAt,
    endedAt: status == DiagnosisStatus.resolved ? endedAt : null,
  );
  return diagnosis.id;
}

Future<String?> showSymptomForm(BuildContext context, {Symptom? symptom}) async {
  final label = TextEditingController(text: symptom?.label);
  final region = TextEditingController(text: symptom?.bodyRegion);
  var diagnosisId = symptom?.diagnosisId;
  final db = DatabaseScope.of(context);
  final repo = SymptomRepository(db);
  final doctors = await DoctorRepository(db).watchAll().first;
  final doctorIds = {
    if (symptom != null)
      for (final d in await repo.doctorsFor(symptom.id)) d.id,
  };
  if (!context.mounted) return null;

  final ok = await _showFormDialog(
    context,
    title: symptom == null ? 'Symptom anlegen' : 'Symptom bearbeiten',
    fields: (setState) => [
      SuggestionTextField(
        controller: label,
        field: SuggestionField.symptomLabel,
        decoration: const InputDecoration(labelText: 'Bezeichnung'),
        autofocus: symptom == null,
      ),
      SuggestionTextField(
        controller: region,
        field: SuggestionField.bodyRegion,
        decoration: const InputDecoration(labelText: 'Körperregion'),
      ),
      DiagnosisPicker(
        value: diagnosisId,
        onChanged: (v) => setState(() => diagnosisId = v),
      ),
      if (doctors.isNotEmpty) ...[
        const SizedBox(height: 12),
        const Text('Ärzte'),
        const SizedBox(height: 4),
        Wrap(
          spacing: 6,
          children: [
            for (final d in doctors)
              FilterChip(
                label: Text(d.name),
                selected: doctorIds.contains(d.id),
                onSelected: (v) => setState(
                  () => v ? doctorIds.add(d.id) : doctorIds.remove(d.id),
                ),
              ),
          ],
        ),
      ],
    ],
  );
  if (!ok || label.text.trim().isEmpty) return null;
  final String id;
  if (symptom == null) {
    id = await repo.create(
      label: label.text.trim(),
      bodyRegion: _trimOrNull(region),
      diagnosisId: diagnosisId,
    );
  } else {
    id = symptom.id;
    await repo.update(
      id: id,
      label: label.text.trim(),
      bodyRegion: _trimOrNull(region),
      diagnosisId: diagnosisId,
    );
  }
  await repo.setDoctors(id, doctorIds.toList());
  return id;
}

Future<String?> showMedicationForm(
  BuildContext context, {
  Medication? medication,
}) => showMedicationFormPage(context, medicationId: medication?.id);

Future<String?> showNoteForm(
  BuildContext context, {
  Note? note,
  String? relatedAppointmentId,
  String? relatedDiagnosisId,
}) async {
  final body = TextEditingController(text: note?.body);
  var diagnosisId = note?.relatedDiagnosisId ?? relatedDiagnosisId;
  final repo = RecordsRepository(DatabaseScope.of(context));

  final ok = await _showFormDialog(
    context,
    title: note == null ? 'Notiz anlegen' : 'Notiz bearbeiten',
    fields: (setState) => [
      TextField(
        controller: body,
        maxLines: 6,
        minLines: 3,
        decoration: const InputDecoration(labelText: 'Text'),
        autofocus: note == null,
      ),
      DiagnosisPicker(
        value: diagnosisId,
        onChanged: (v) => setState(() => diagnosisId = v),
      ),
    ],
  );
  if (!ok || body.text.trim().isEmpty) return null;
  if (note == null) {
    return repo.createNote(
      body: body.text.trim(),
      relatedAppointmentId: relatedAppointmentId,
      relatedDiagnosisId: diagnosisId,
    );
  }
  await repo.updateNote(
    id: note.id,
    body: body.text.trim(),
    relatedAppointmentId: note.relatedAppointmentId,
    relatedDiagnosisId: diagnosisId,
  );
  return note.id;
}

Future<void> showReportRenameForm(BuildContext context, Report report) async {
  final title = TextEditingController(text: report.title);
  final repo = RecordsRepository(DatabaseScope.of(context));
  final ok = await _showFormDialog(
    context,
    title: 'Bericht umbenennen',
    fields: (_) => [
      TextField(
        controller: title,
        autofocus: true,
        decoration: const InputDecoration(labelText: 'Titel'),
      ),
    ],
  );
  if (!ok || title.text.trim().isEmpty) return;
  await repo.updateReport(
    id: report.id,
    title: title.text.trim(),
    appointmentId: report.appointmentId,
  );
}

/// Sicherheitsabfrage vor dem Löschen.
Future<bool> confirmDelete(
  BuildContext context, {
  required String what,
  String? detail,
}) async {
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('$what löschen?'),
      content: Text(detail ?? 'Das kann nicht rückgängig gemacht werden.'),
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
          child: const Text('Löschen'),
        ),
      ],
    ),
  );
  return ok == true;
}

// Bestehende Einstiegspunkte (Akte „+“-Menü).
Future<void> showCreateDoctorDialog(BuildContext context) =>
    showDoctorForm(context);
Future<void> showCreateDiagnosisDialog(BuildContext context) =>
    showDiagnosisForm(context);
Future<void> showCreateSymptomDialog(BuildContext context) =>
    showSymptomForm(context);
Future<void> showCreateMedicationDialog(BuildContext context) =>
    showMedicationForm(context);
Future<void> showCreateNoteDialog(BuildContext context) => showNoteForm(context);

/// Wählt eine Datei und legt sie als Bericht ab; Fehler landen als Snackbar.
Future<ImportedReport?> importReport(
  BuildContext context, {
  String? appointmentId,
}) async {
  final records = RecordsRepository(DatabaseScope.of(context));
  final messenger = ScaffoldMessenger.of(context);
  try {
    final imported = await ReportImportService(
      records,
    ).pickAndImport(appointmentId: appointmentId);
    if (imported != null) {
      messenger.showSnackBar(
        SnackBar(content: Text('Bericht „${imported.title}“ gespeichert')),
      );
    }
    return imported;
  } on ReportImportException catch (e) {
    debugPrint('$e');
    messenger.showSnackBar(SnackBar(content: Text(e.message)));
    return null;
  }
}
