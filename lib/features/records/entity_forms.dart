import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/doctor_repository.dart';
import '../../data/repositories/records_repository.dart';
import '../../data/repositories/suggestion_repository.dart';
import '../../data/repositories/symptom_repository.dart';
import '../../data/symptom_description.dart';
import '../../data/symptom_measure.dart';
import '../../data/symptom_title.dart';
import '../../l10n/l10n.dart';
import '../../services/ocr/document_scanner.dart';
import '../../services/report_import_service.dart';
import '../../services/temp_files.dart';
import '../../widgets/suggestion_text_field.dart';
import '../check_in/symptom_description_composer.dart';
import '../medications/medication_form_page.dart';
import 'measure_change_dialog.dart';

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
      future: RecordsRepository(DatabaseScope.of(context))
          .watchDiagnoses()
          .first,
      builder: (context, snapshot) {
        final diagnoses = snapshot.data ?? const <Diagnose>[];
        if (diagnoses.isEmpty) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(top: 12),
          child: DropdownMenu<String?>(
            initialSelection: value,
            label: Text(context.l10n.entityDiagnosis),
            expandedInsets: EdgeInsets.zero,
            dropdownMenuEntries: [
              DropdownMenuEntry(
                value: null,
                label: context.l10n.recordsDiagnosisNone,
              ),
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
        value == null
            ? '—'
            : DateFormat(context.l10n.recordsDatePattern).format(value!),
      ),
      trailing: value == null
          ? const Icon(Icons.event_outlined)
          : IconButton(
              tooltip: context.l10n.recordsDateClearTooltip(label),
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
  final l10n = context.l10n;

  final ok = await _showFormDialog(
    context,
    title: doctor == null
        ? l10n.recordsDoctorCreateTitle
        : l10n.recordsDoctorEditTitle,
    fields: (_) => [
      TextField(
        controller: name,
        decoration: InputDecoration(labelText: l10n.recordsFieldName),
        textCapitalization: TextCapitalization.words,
        autofocus: doctor == null,
      ),
      SuggestionTextField(
        controller: specialty,
        field: SuggestionField.specialty,
        decoration: InputDecoration(labelText: l10n.recordsFieldSpecialty),
      ),
      TextField(
        controller: practice,
        decoration: InputDecoration(labelText: l10n.recordsFieldPractice),
      ),
      TextField(
        controller: phone,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(labelText: l10n.recordsFieldPhone),
      ),
      TextField(
        controller: address,
        maxLines: 2,
        decoration: InputDecoration(labelText: l10n.recordsFieldAddress),
      ),
      TextField(
        controller: notes,
        maxLines: 3,
        decoration: InputDecoration(labelText: l10n.commonNotes),
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
  final l10n = context.l10n;

  final ok = await _showFormDialog(
    context,
    title: diagnosis == null
        ? l10n.recordsDiagnosisCreateTitle
        : l10n.recordsDiagnosisEditTitle,
    fields: (setState) => [
      SuggestionTextField(
        controller: title,
        field: SuggestionField.diagnosisTitle,
        decoration: InputDecoration(labelText: l10n.recordsFieldTitle),
        autofocus: diagnosis == null,
      ),
      TextField(
        controller: notes,
        maxLines: 3,
        decoration: InputDecoration(labelText: l10n.commonNotes),
      ),
      const SizedBox(height: 12),
      SegmentedButton<DiagnosisStatus>(
        segments: [
          ButtonSegment(
            value: DiagnosisStatus.active,
            label: Text(l10n.recordsDiagnosisActive),
          ),
          ButtonSegment(
            value: DiagnosisStatus.resolved,
            label: Text(l10n.recordsDiagnosisResolved),
          ),
        ],
        selected: {status},
        onSelectionChanged: (v) => setState(() => status = v.first),
      ),
      DateField(
        label: l10n.recordsDiagnosisSince,
        value: startedAt,
        onChanged: (v) => setState(() => startedAt = v),
      ),
      if (status == DiagnosisStatus.resolved)
        DateField(
          label: l10n.recordsDiagnosisUntil,
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

Future<String?> showSymptomForm(
  BuildContext context, {
  Symptom? symptom,
}) async {
  final label = TextEditingController(text: symptom?.label);
  var diagnosisId = symptom?.diagnosisId;
  // v15: Bausteine (Charakter, Empfindung, Ort = Körperregion, Seite) setzen
  // den Namen zusammen und werden für Auswertungen weiter einzeln gespeichert.
  var description = symptom == null
      ? const SymptomDescription()
      : SymptomDescription.fromSymptom(symptom);
  // Messgröße: bestehendes Symptom behält seine (alte Symptome: Stärke,
  // damit bisherige Check-ins vergleichbar bleiben); neu = Vorschlag aus dem
  // Namen, bis man selbst wählt.
  var measures = symptom == null
      ? suggestMeasures('')
      : symptomMeasures(symptom);
  var measureChosen = symptom != null;
  final db = DatabaseScope.of(context);
  final repo = SymptomRepository(db);
  // v16: bisherige Check-ins — Hinweis, wenn ein Wechsel der Messgröße
  // Werte zurücklässt; ggf. umrechnen beim Speichern.
  final history = symptom == null
      ? const <SymptomObservation>[]
      : await repo.watchObservations(symptom.id).first;
  var convertOld = false;
  final doctors = await DoctorRepository(db).watchAll().first;
  final doctorIds = {
    if (symptom != null)
      for (final d in await repo.doctorsFor(symptom.id)) d.id,
  };
  if (!context.mounted) return null;
  final l10n = context.l10n;

  String composed() =>
      composeSymptomTitle(TitleBlocks.fromDescription(description), l10n);
  // Automatisch, solange der Name leer ist oder genau den Bausteinen
  // entspricht; eigene Eingabe wird nie überschrieben.
  var autoTitle =
      label.text.trim().isEmpty || label.text.trim() == composed();
  var programmatic = false;
  StateSetter? rebuild;

  void suggest() {
    if (!measureChosen) {
      measures = suggestMeasures(label.text, sensation: description.sensation);
    }
  }

  void setTitle(String text) {
    programmatic = true;
    label.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    programmatic = false;
  }

  label.addListener(() {
    if (programmatic) return;
    final text = label.text.trim();
    final auto = text.isEmpty || text == composed();
    if (auto == autoTitle && measureChosen) return;
    autoTitle = auto;
    suggest();
    rebuild?.call(() {});
  });

  final ok = await _showFormDialog(
    context,
    title: symptom == null
        ? l10n.recordsSymptomCreateTitle
        : l10n.recordsSymptomEditTitle,
    fields: (setState) {
      rebuild = setState;
      final title = composed();
      return [
        Text(
          l10n.symptomBlocksHint,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 6),
        SymptomDescriptionComposer(
          value: description,
          onChanged: (v) => setState(() {
            description = v;
            if (autoTitle) setTitle(composed());
            suggest();
          }),
          qualityFirst: true,
          showPattern: false,
          showIntensity: false,
          showPreview: false,
        ),
        SuggestionTextField(
          controller: label,
          field: SuggestionField.symptomLabel,
          decoration: InputDecoration(labelText: l10n.recordsFieldSymptomLabel),
          autofocus: symptom == null,
        ),
        if (!autoTitle && title.isNotEmpty && title != label.text.trim())
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => setState(() {
                autoTitle = true;
                setTitle(title);
                suggest();
              }),
              icon: const Icon(Icons.auto_fix_high, size: 18),
              label: Text(l10n.symptomTitleRegenerate),
            ),
          ),
        const SizedBox(height: 4),
        ListTile(
          key: const ValueKey('symptom-measure'),
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.straighten),
          title: Text(l10n.measureHowTitle),
          subtitle: Text(
            [
              measureLabel(measures.primary, l10n),
              if (measures.secondary != null)
                measureLabel(measures.secondary!, l10n),
            ].join(' + '),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () async {
            final picked = await showMeasurePicker(context, measures);
            if (picked == null || !context.mounted) return;
            // Nur Werte, die durch diesen Wechsel neu „zurückbleiben“.
            final before = measuresLeftBehind(history, measures);
            final choice = await confirmMeasureChange(
              context,
              leftBehind: {
                for (final e in measuresLeftBehind(history, picked).entries)
                  if (!before.containsKey(e.key)) e.key: e.value,
              },
              next: picked,
            );
            if (choice == null) return;
            setState(() {
              measures = picked;
              measureChosen = true;
              convertOld = choice == MeasureChange.convert;
            });
          },
        ),
        DiagnosisPicker(
          value: diagnosisId,
          onChanged: (v) => setState(() => diagnosisId = v),
        ),
        if (doctors.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(l10n.entityDoctors),
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
      ];
    },
  );
  rebuild = null;
  final name = label.text.trim().isEmpty ? composed() : label.text.trim();
  if (!ok || name.isEmpty) return null;
  final String id;
  if (symptom == null) {
    id = await repo.create(
      label: name,
      bodyRegion: description.location,
      diagnosisId: diagnosisId,
      sensation: description.sensation,
      quality: description.qualityText,
      side: description.side,
      measures: measures,
    );
  } else {
    id = symptom.id;
    await repo.update(
      id: id,
      label: name,
      bodyRegion: description.location,
      diagnosisId: diagnosisId,
      sensation: description.sensation,
      quality: description.qualityText,
      side: description.side,
      measures: measures,
    );
    if (convertOld) await repo.convertObservations(id, measures.primary);
  }
  await repo.setDoctors(id, doctorIds.toList());
  return id;
}

/// „Wie messen?“: erste Messgröße und optional eine zweite. `null` =
/// abgebrochen.
Future<MeasurePair?> showMeasurePicker(
  BuildContext context,
  MeasurePair current,
) {
  var primary = current.primary;
  var secondary = current.secondary;
  return showModalBottomSheet<MeasurePair>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) {
        final l10n = context.l10n;
        final theme = Theme.of(context);
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.85,
            ),
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              children: [
                Text(
                  l10n.measureHowTitle,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(l10n.measureHowHint, style: theme.textTheme.bodySmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final m in SymptomMeasure.values)
                      ChoiceChip(
                        key: ValueKey('measure-${m.code}'),
                        label: Text(measureLabel(m, l10n)),
                        selected: primary == m,
                        onSelected: (_) => setState(() {
                          primary = m;
                          if (secondary == m || !m.canHaveSecondary) {
                            secondary = null;
                          }
                        }),
                      ),
                  ],
                ),
                if (primary.canHaveSecondary) ...[
                  const SizedBox(height: 16),
                  Text(l10n.measureSecondary, style: theme.textTheme.titleSmall),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      ChoiceChip(
                        label: Text(l10n.measureSecondaryNone),
                        selected: secondary == null,
                        onSelected: (_) => setState(() => secondary = null),
                      ),
                      for (final m in SymptomMeasure.values)
                        if (m != primary && m.canBeSecondary)
                          ChoiceChip(
                            key: ValueKey('measure2-${m.code}'),
                            label: Text(measureLabel(m, l10n)),
                            selected: secondary == m,
                            onSelected: (_) => setState(() => secondary = m),
                          ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => Navigator.pop(
                    context,
                    (primary: primary, secondary: secondary),
                  ),
                  child: Text(l10n.symptomPickerApply),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
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
  final l10n = context.l10n;

  final ok = await _showFormDialog(
    context,
    title: note == null ? l10n.recordsNoteCreateTitle : l10n.recordsNoteEditTitle,
    fields: (setState) => [
      TextField(
        controller: body,
        maxLines: 6,
        minLines: 3,
        decoration: InputDecoration(labelText: l10n.recordsFieldText),
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
  final l10n = context.l10n;
  final ok = await _showFormDialog(
    context,
    title: l10n.recordsReportRenameTitle,
    fields: (_) => [
      TextField(
        controller: title,
        autofocus: true,
        decoration: InputDecoration(labelText: l10n.recordsFieldTitle),
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
      title: Text(context.l10n.recordsDeleteConfirmTitle(what)),
      content: Text(detail ?? context.l10n.recordsDeleteConfirmBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(context.l10n.commonCancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          onPressed: () => Navigator.pop(context, true),
          child: Text(context.l10n.commonDelete),
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
Future<void> showCreateNoteDialog(BuildContext context) =>
    showNoteForm(context);

/// Bericht hinzufügen: scannen (Kamera) oder Datei wählen.
Future<ImportedReport?> importReport(
  BuildContext context, {
  String? appointmentId,
}) async {
  final scanner = DocumentScannerApi.current;
  if (!scanner.isSupported) {
    return pickReportFile(context, appointmentId: appointmentId);
  }
  final choice = await showModalBottomSheet<String>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.document_scanner_outlined),
            title: Text(context.l10n.recordsScanDocument),
            subtitle: Text(context.l10n.recordsScanDocumentHint),
            onTap: () => Navigator.pop(context, 'scan'),
          ),
          ListTile(
            leading: const Icon(Icons.photo_camera_outlined),
            title: Text(context.l10n.recordsTakePhoto),
            subtitle: Text(context.l10n.recordsTakePhotoHint),
            onTap: () => Navigator.pop(context, 'photo'),
          ),
          ListTile(
            leading: const Icon(Icons.upload_file),
            title: Text(context.l10n.recordsPickFiles),
            subtitle: Text(context.l10n.recordsPickFilesHint),
            onTap: () => Navigator.pop(context, 'file'),
          ),
        ],
      ),
    ),
  );
  if (!context.mounted || choice == null) return null;
  return switch (choice) {
    'scan' => scanReport(context, appointmentId: appointmentId),
    'photo' => scanReport(context, appointmentId: appointmentId, photo: true),
    _ => pickReportFile(context, appointmentId: appointmentId),
  };
}

/// Foto als einseitiges PDF — wird wie ein Scan abgelegt und per OCR erkannt.
Future<ScannedDocument?> _photoAsScan() async {
  final photo = await DocumentScannerApi.current.takePhoto();
  if (photo == null) return null;
  final image = pw.MemoryImage(await File(photo).readAsBytes());
  final doc = pw.Document()
    ..addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (_) => pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain)),
      ),
    );
  final pdf = File('${File(photo).parent.path}/${DateTime.now().millisecondsSinceEpoch}.pdf');
  await pdf.writeAsBytes(await doc.save());
  return ScannedDocument(pdfPath: pdf.path, imagePaths: [photo]);
}

/// Scannt ein Dokument und legt es als PDF-Bericht (Quelle „Scan“) ab.
Future<ImportedReport?> scanReport(
  BuildContext context, {
  String? appointmentId,
  bool photo = false,
}) async {
  final records = RecordsRepository(DatabaseScope.of(context));
  final messenger = ScaffoldMessenger.of(context);
  final l10n = context.l10n;
  final ScannedDocument? result;
  try {
    result = photo
        ? await _photoAsScan()
        : await DocumentScannerApi.current.scan();
  } on ScannerUnavailable catch (e) {
    if (!context.mounted) return null;
    final next = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.recordsScannerUnavailableTitle),
        content: Text(l10n.recordsScannerUnavailableBody('$e')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'file'),
            child: Text(l10n.recordsPickFile),
          ),
          if (!photo)
            FilledButton(
              onPressed: () => Navigator.pop(context, 'photo'),
              child: Text(l10n.recordsTakePhoto),
            ),
        ],
      ),
    );
    if (!context.mounted) return null;
    return switch (next) {
      'photo' => scanReport(context, appointmentId: appointmentId, photo: true),
      'file' => pickReportFile(context, appointmentId: appointmentId),
      _ => null,
    };
  }
  if (result == null) return null;
  final scan = result;
  messenger.showSnackBar(
    SnackBar(content: Text(l10n.recordsScanSaving)),
  );
  try {
    final name = l10n.recordsScanFileName(
      DateFormat(l10n.recordsScanFileDatePattern).format(DateTime.now()),
    );
    final imported = await ReportImportService(records).importFile(
      name: name,
      sourcePath: scan.pdfPath,
      readBytes: () => File(scan.pdfPath).readAsBytes(),
      appointmentId: appointmentId,
      source: ReportSource.scan,
      ocrImages: scan.imagePaths,
    );
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            imported.extractedText == null
                ? l10n.recordsScanSavedNoText
                : l10n.recordsScanSavedWithText,
          ),
        ),
      );
    return imported;
  } on ReportImportException catch (e) {
    messenger.showSnackBar(SnackBar(content: Text(e.message)));
    return null;
  } finally {
    // Klartext-Scan im Cache: liegt jetzt (oder gar nicht) in der Akte.
    await TempFiles.delete([scan.pdfPath, ...scan.imagePaths]);
  }
}

/// Wählt Dateien und legt sie als Berichte ab; Ergebnis als Snackbar.
/// Liefert den ersten importierten Bericht (oder `null`).
Future<ImportedReport?> pickReportFile(
  BuildContext context, {
  String? appointmentId,
}) async {
  final records = RecordsRepository(DatabaseScope.of(context));
  final messenger = ScaffoldMessenger.of(context);
  final l10n = context.l10n;
  try {
    final result = await ReportImportService(records)
        .pickAndImport(appointmentId: appointmentId);
    if (result.isEmpty) return null;
    final ok = result.imported;
    final failed = result.failed;
    final String message;
    if (failed.isEmpty) {
      message = ok.length == 1
          ? l10n.recordsReportSaved(ok.single.title)
          : l10n.recordsReportsSaved(ok.length);
    } else if (ok.isEmpty && failed.length == 1) {
      message = failed.values.single;
    } else {
      message = l10n.recordsImportPartial(
        ok.length,
        failed.length,
        failed.keys.join(', '),
      );
    }
    messenger.showSnackBar(SnackBar(content: Text(message)));
    return ok.isEmpty ? null : ok.first;
  } on ReportImportException catch (e) {
    debugPrint('$e');
    messenger.showSnackBar(SnackBar(content: Text(e.message)));
    return null;
  }
}
