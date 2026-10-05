import 'package:flutter/material.dart';

import '../../data/database_provider.dart';
import '../../data/repositories/doctor_repository.dart';
import '../../data/repositories/records_repository.dart';
import '../../data/repositories/symptom_repository.dart';
import '../../services/report_import_service.dart';

Future<void> showCreateDoctorDialog(BuildContext context) async {
  final name = TextEditingController();
  final specialty = TextEditingController();
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Arzt anlegen'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: name,
            decoration: const InputDecoration(labelText: 'Name'),
            autofocus: true,
          ),
          TextField(
            controller: specialty,
            decoration: const InputDecoration(labelText: 'Fachrichtung'),
          ),
        ],
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
  );
  if (ok != true || !context.mounted) return;
  if (name.text.trim().isEmpty) return;
  await DoctorRepository(DatabaseScope.of(context)).create(
    name: name.text.trim(),
    specialty: specialty.text.trim().isEmpty ? null : specialty.text.trim(),
  );
}

Future<void> showCreateDiagnosisDialog(BuildContext context) async {
  final title = TextEditingController();
  final notes = TextEditingController();
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Diagnose anlegen'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: title,
            decoration: const InputDecoration(labelText: 'Titel'),
            autofocus: true,
          ),
          TextField(
            controller: notes,
            decoration: const InputDecoration(labelText: 'Notizen'),
          ),
        ],
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
  );
  if (ok != true || !context.mounted) return;
  if (title.text.trim().isEmpty) return;
  await RecordsRepository(DatabaseScope.of(context)).createDiagnosis(
    title: title.text.trim(),
    notes: notes.text.trim().isEmpty ? null : notes.text.trim(),
  );
}

Future<void> showCreateSymptomDialog(BuildContext context) async {
  final label = TextEditingController();
  final region = TextEditingController();
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Symptom anlegen'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: label,
            decoration: const InputDecoration(labelText: 'Bezeichnung'),
            autofocus: true,
          ),
          TextField(
            controller: region,
            decoration: const InputDecoration(labelText: 'Körperregion'),
          ),
        ],
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
  );
  if (ok != true || !context.mounted) return;
  if (label.text.trim().isEmpty) return;
  await SymptomRepository(DatabaseScope.of(context)).create(
    label: label.text.trim(),
    bodyRegion: region.text.trim().isEmpty ? null : region.text.trim(),
  );
}

Future<void> showCreateMedicationDialog(BuildContext context) async {
  final name = TextEditingController();
  final dosage = TextEditingController();
  final schedule = TextEditingController();
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Medikament anlegen'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: name,
            decoration: const InputDecoration(labelText: 'Name'),
            autofocus: true,
          ),
          TextField(
            controller: dosage,
            decoration: const InputDecoration(labelText: 'Dosierung'),
          ),
          TextField(
            controller: schedule,
            decoration: const InputDecoration(labelText: 'Einnahmeplan'),
          ),
        ],
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
  );
  if (ok != true || !context.mounted) return;
  if (name.text.trim().isEmpty) return;
  await RecordsRepository(DatabaseScope.of(context)).createMedication(
    name: name.text.trim(),
    dosage: dosage.text.trim().isEmpty ? null : dosage.text.trim(),
    scheduleText: schedule.text.trim().isEmpty ? null : schedule.text.trim(),
  );
}

Future<void> showCreateNoteDialog(BuildContext context) async {
  final body = TextEditingController();
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Notiz anlegen'),
      content: TextField(
        controller: body,
        maxLines: 5,
        decoration: const InputDecoration(labelText: 'Text'),
        autofocus: true,
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
  );
  if (ok != true || !context.mounted) return;
  if (body.text.trim().isEmpty) return;
  await RecordsRepository(
    DatabaseScope.of(context),
  ).createNote(body: body.text.trim());
}

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
