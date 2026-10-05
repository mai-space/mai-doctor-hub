import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:share_plus/share_plus.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/appointment_repository.dart';
import '../../data/repositories/medication_repository.dart';
import '../../services/visit_summary.dart';

/// Zusammenfassung für den Arztbesuch zusammenstellen und als PDF teilen.
class VisitSummaryPage extends StatefulWidget {
  const VisitSummaryPage({super.key, this.appointmentId});

  final String? appointmentId;

  @override
  State<VisitSummaryPage> createState() => _VisitSummaryPageState();
}

class _VisitSummaryPageState extends State<VisitSummaryPage> {
  final _questions = TextEditingController();
  final _name = TextEditingController();
  late String? _appointmentId = widget.appointmentId;
  bool _allSymptoms = true;
  bool _allMedications = true;
  final Set<String> _symptomIds = {};
  final Set<String> _medicationIds = {};
  bool _diagnoses = true;
  bool _vaccinations = true;
  bool _busy = false;

  List<Symptom> _symptoms = const [];
  List<MedicationDetails> _medications = const [];
  List<AppointmentSummary> _appointments = const [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_appointments.isEmpty) _load();
  }

  Future<void> _load() async {
    final (symptoms, medications, appointments) = await loadSummaryChoices(
      DatabaseScope.of(context),
    );
    if (!mounted) return;
    setState(() {
      _symptoms = symptoms;
      _medications = medications;
      _appointments = appointments;
      _symptomIds.addAll(symptoms.where((s) => s.healedAt == null).map((s) => s.id));
      _medicationIds.addAll(medications.map((m) => m.medication.id));
    });
  }

  @override
  void dispose() {
    _questions.dispose();
    _name.dispose();
    super.dispose();
  }

  VisitSummaryOptions get _options => VisitSummaryOptions(
    appointmentId: _appointmentId,
    symptomIds: _allSymptoms ? null : _symptomIds,
    medicationIds: _allMedications ? null : _medicationIds,
    includeDiagnoses: _diagnoses,
    includeVaccinations: _vaccinations,
    questions: _questions.text,
    patientName: _name.text,
  );

  Future<void> _export({required bool share}) async {
    final db = DatabaseScope.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      final data = await VisitSummaryBuilder(db).build(_options);
      final bytes = await VisitSummaryPdf.render(data);
      final name = VisitSummaryPdf.fileName(data);
      if (share) {
        await SharePlus.instance.share(
          ShareParams(
            files: [XFile.fromData(bytes, mimeType: visitSummaryMime, name: name)],
            fileNameOverrides: [name],
            subject: 'Zusammenfassung für den Arztbesuch',
          ),
        );
      } else {
        final saved = await FilePicker.saveFile(
          fileName: name,
          bytes: bytes,
          mimeType: visitSummaryMime,
          dialogTitle: 'Zusammenfassung speichern',
        );
        if (saved != null) {
          messenger.showSnackBar(const SnackBar(content: Text('PDF gespeichert')));
        }
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Export fehlgeschlagen: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final format = DateFormat('d. MMM yyyy', 'de');
    Widget heading(String text) => Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 4),
      child: Text(
        text,
        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Für den Arztbesuch')),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _busy ? null : () => _export(share: false),
                  icon: const Icon(Icons.save_alt),
                  label: const Text('Speichern'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(minimumSize: const Size(0, 48)),
                  onPressed: _busy ? null : () => _export(share: true),
                  icon: const Icon(Icons.share),
                  label: const Text('PDF teilen'),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          if (_busy) const LinearProgressIndicator(),
          Text(
            'Fragen, Symptom-Verläufe, Medikamente und Impfungen auf einen '
            'Blick — als PDF für die Praxis.',
            style: theme.textTheme.bodyMedium,
          ),
          heading('Termin'),
          DropdownMenu<String?>(
            key: ValueKey(_appointments.length),
            initialSelection: _appointmentId,
            label: const Text('Bezug (bestimmt Zeitraum)'),
            expandedInsets: EdgeInsets.zero,
            dropdownMenuEntries: [
              const DropdownMenuEntry(value: null, label: 'Ohne — letzte 30 Tage'),
              for (final a in _appointments)
                DropdownMenuEntry(
                  value: a.appointment.id,
                  label:
                      '${format.format(a.appointment.scheduledAt)} · ${a.doctorName}',
                ),
            ],
            onSelected: (v) => setState(() => _appointmentId = v),
          ),
          TextField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Name (optional, steht im PDF)'),
          ),
          heading('Fragen & Anliegen'),
          TextField(
            controller: _questions,
            minLines: 3,
            maxLines: 8,
            decoration: const InputDecoration(
              hintText: 'Eine Frage pro Zeile — Notizen zum Termin kommen automatisch dazu',
              border: OutlineInputBorder(),
            ),
          ),
          heading('Symptome'),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Alle offenen Symptome'),
            value: _allSymptoms,
            onChanged: (v) => setState(() => _allSymptoms = v),
          ),
          if (!_allSymptoms)
            Wrap(
              spacing: 6,
              children: [
                for (final s in _symptoms)
                  FilterChip(
                    label: Text(s.label),
                    selected: _symptomIds.contains(s.id),
                    onSelected: (v) => setState(
                      () => v ? _symptomIds.add(s.id) : _symptomIds.remove(s.id),
                    ),
                  ),
              ],
            ),
          heading('Medikamente'),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Alle aktuellen Medikamente'),
            value: _allMedications,
            onChanged: (v) => setState(() => _allMedications = v),
          ),
          if (!_allMedications)
            Wrap(
              spacing: 6,
              children: [
                for (final m in _medications)
                  FilterChip(
                    label: Text(m.medication.name),
                    selected: _medicationIds.contains(m.medication.id),
                    onSelected: (v) => setState(
                      () => v
                          ? _medicationIds.add(m.medication.id)
                          : _medicationIds.remove(m.medication.id),
                    ),
                  ),
              ],
            ),
          heading('Weiteres'),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Diagnosen'),
            value: _diagnoses,
            onChanged: (v) => setState(() => _diagnoses = v),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Impfungen'),
            value: _vaccinations,
            onChanged: (v) => setState(() => _vaccinations = v),
          ),
        ],
      ),
    );
  }
}
