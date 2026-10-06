import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/medication_repository.dart';
import '../../l10n/l10n.dart';

Future<String?> showPharmacyForm(
  BuildContext context, {
  Pharmacy? pharmacy,
}) async {
  final name = TextEditingController(text: pharmacy?.name);
  final address = TextEditingController(text: pharmacy?.address);
  final phone = TextEditingController(text: pharmacy?.phone);
  final notes = TextEditingController(text: pharmacy?.notes);
  final repo = PharmacyRepository(DatabaseScope.of(context));
  final l10n = context.l10n;
  final ok = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(
        pharmacy == null ? l10n.homeMedAddPharmacy : l10n.homePharmacyEdit,
      ),
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: name,
            autofocus: pharmacy == null,
            decoration: InputDecoration(labelText: l10n.homeDoctorName),
          ),
          TextField(
            controller: address,
            maxLines: 2,
            decoration: InputDecoration(labelText: l10n.homePharmacyAddress),
          ),
          TextField(
            controller: phone,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(labelText: l10n.homePharmacyPhone),
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
