import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/doctor_repository.dart';
import '../../data/repositories/suggestion_repository.dart';
import '../../data/repositories/vaccination_repository.dart';
import '../../l10n/l10n.dart';
import '../../widgets/suggestion_text_field.dart';
import '../records/entity_forms.dart';

Future<String?> showVaccinationForm(
  BuildContext context, {
  Vaccination? vaccination,
}) async {
  final db = DatabaseScope.of(context);
  final doctors = await DoctorRepository(db).watchAll().first;
  if (!context.mounted) return null;
  final l10n = context.l10n;
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
        title: Text(
          vaccination == null ? l10n.homeVaccinationAdd : l10n.homeVaccinationEdit,
        ),
        scrollable: true,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SuggestionTextField(
              controller: vaccine,
              field: SuggestionField.vaccine,
              autofocus: vaccination == null,
              decoration: InputDecoration(labelText: l10n.homeVaccinationAgainst),
            ),
            TextField(
              controller: product,
              decoration: InputDecoration(labelText: l10n.homeVaccinationProduct),
            ),
            DateField(
              label: l10n.homeVaccinationDate,
              value: date,
              onChanged: (v) => setState(() => date = v ?? date),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: dose,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: l10n.homeVaccinationDoseNumber),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: batch,
                    decoration: InputDecoration(labelText: l10n.homeVaccinationBatch),
                  ),
                ),
              ],
            ),
            if (doctors.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: DropdownMenu<String?>(
                  initialSelection: doctorId,
                  label: Text(l10n.homeVaccinationBy),
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
              label: l10n.homeVaccinationNextDue,
              value: nextDue,
              onChanged: (v) => setState(() => nextDue = v),
            ),
            Wrap(
              spacing: 6,
              children: [
                for (final years in const [1, 5, 10])
                  ActionChip(
                    label: Text(l10n.homeVaccinationPlusYears(years)),
                    onPressed: () => setState(
                      () => nextDue = DateTime(date.year + years, date.month, date.day),
                    ),
                  ),
              ],
            ),
            TextField(
              controller: notes,
              maxLines: 2,
              decoration: InputDecoration(labelText: l10n.commonNotes),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.commonSave),
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
