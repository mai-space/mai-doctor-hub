import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/medication_repository.dart';

Future<String?> showPharmacyForm(
  BuildContext context, {
  Pharmacy? pharmacy,
}) async {
  final name = TextEditingController(text: pharmacy?.name);
  final address = TextEditingController(text: pharmacy?.address);
  final phone = TextEditingController(text: pharmacy?.phone);
  final notes = TextEditingController(text: pharmacy?.notes);
  final repo = PharmacyRepository(DatabaseScope.of(context));
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(pharmacy == null ? 'Apotheke anlegen' : 'Apotheke bearbeiten'),
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: name,
            autofocus: pharmacy == null,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: address,
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'Adresse'),
          ),
          TextField(
            controller: phone,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Telefon'),
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
  );
  if (ok != true || name.text.trim().isEmpty) return null;
  String? t(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();
  return repo.save(
    id: pharmacy?.id,
    name: name.text.trim(),
    address: t(address),
    phone: t(phone),
    notes: t(notes),
  );
}
