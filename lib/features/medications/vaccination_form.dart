import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/doctor_repository.dart';
import '../../data/repositories/suggestion_repository.dart';
import '../../data/repositories/vaccination_repository.dart';
import '../../widgets/suggestion_text_field.dart';
import '../records/entity_forms.dart';

Future<String?> showVaccinationForm(
  BuildContext context, {
  Vaccination? vaccination,
}) async {
  final db = DatabaseScope.of(context);
  final doctors = await DoctorRepository(db).watchAll().first;
  if (!context.mounted) return null;
  final vaccine = TextEditingController(text: vaccination?.vaccine);
  final product = TextEditingController(text: vaccination?.product);
  final dose = TextEditingController(text: vaccination?.doseNumber?.toString());
  final batch = TextEditingController(text: vaccination?.batch);
  final notes = TextEditingController(text: vaccination?.notes);
  var date = vaccination?.administeredAt ?? DateTime.now();
  var nextDue = vaccination?.nextDueAt;
  var doctorId = vaccination?.doctorId;

  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(vaccination == null ? 'Impfung eintragen' : 'Impfung bearbeiten'),
        scrollable: true,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SuggestionTextField(
              controller: vaccine,
              field: SuggestionField.vaccine,
              autofocus: vaccination == null,
              decoration: const InputDecoration(labelText: 'Impfung gegen'),
            ),
            TextField(
              controller: product,
              decoration: const InputDecoration(labelText: 'Impfstoff (Handelsname)'),
            ),
            DateField(
              label: 'Geimpft am',
              value: date,
              onChanged: (v) => setState(() => date = v ?? date),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: dose,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Dosis-Nr.'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: batch,
                    decoration: const InputDecoration(labelText: 'Charge'),
                  ),
                ),
              ],
            ),
            if (doctors.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: DropdownMenu<String?>(
                  initialSelection: doctorId,
                  label: const Text('Geimpft von'),
                  expandedInsets: EdgeInsets.zero,
                  dropdownMenuEntries: [
                    const DropdownMenuEntry(value: null, label: '—'),
                    for (final d in doctors)
                      DropdownMenuEntry(value: d.id, label: d.name),
                  ],
                  onSelected: (v) => setState(() => doctorId = v),
                ),
              ),
            DateField(
              label: 'Nächste Impfung fällig',
              value: nextDue,
              onChanged: (v) => setState(() => nextDue = v),
            ),
            Wrap(
              spacing: 6,
              children: [
                for (final (label, years) in [('+1 J.', 1), ('+5 J.', 5), ('+10 J.', 10)])
                  ActionChip(
                    label: Text(label),
                    onPressed: () => setState(
                      () => nextDue = DateTime(date.year + years, date.month, date.day),
                    ),
                  ),
              ],
            ),
            TextField(
              controller: notes,
              maxLines: 2,
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
    ),
  );
  if (ok != true || vaccine.text.trim().isEmpty) return null;
  String? t(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();
  return VaccinationRepository(db).save(
    id: vaccination?.id,
    vaccine: vaccine.text.trim(),
    product: t(product),
    administeredAt: date,
    doseNumber: int.tryParse(dose.text.trim()),
    batch: t(batch),
    doctorId: doctorId,
    nextDueAt: nextDue,
    notes: t(notes),
  );
}
