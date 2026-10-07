import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:share_plus/share_plus.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/cycle_catalog.dart';
import '../../data/repositories/appointment_repository.dart';
import '../../data/repositories/cycle_repository.dart';
import '../../data/repositories/medication_repository.dart';
import '../../l10n/l10n.dart';
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

  /// v15: Tagebuch-Einträge — standardmäßig aus.
  bool _journal = false;
  bool _busy = false;

  /// Zyklus-Abschnitt: nur anbietbar, wenn ein Bereich aktiv ist; Standard
  /// an, wenn der Termin bei der Gynäkologie ist (bis man umschaltet).
  bool _cycleEnabled = false;
  bool? _cycleChoice;

  List<Symptom> _symptoms = const [];
  List<MedicationDetails> _medications = const [];
  List<AppointmentSummary> _appointments = const [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_appointments.isEmpty) _load();
  }

  Future<void> _load() async {
    final db = DatabaseScope.of(context);
    final (symptoms, medications, appointments) = await loadSummaryChoices(db);
    final cycle = await CycleRepository(db).overview();
    if (!mounted) return;
    setState(() {
      _cycleEnabled = cycle.enabled;
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

  bool get _includeCycle {
    if (!_cycleEnabled) return false;
    final choice = _cycleChoice;
    if (choice != null) return choice;
    final doctor = _appointments
        .where((a) => a.appointment.id == _appointmentId)
        .firstOrNull
        ?.doctor;
    return isGynecologySpecialty(doctor?.specialty);
  }

  VisitSummaryOptions get _options => VisitSummaryOptions(
    includeCycle: _includeCycle,
    appointmentId: _appointmentId,
    symptomIds: _allSymptoms ? null : _symptomIds,
    medicationIds: _allMedications ? null : _medicationIds,
    includeDiagnoses: _diagnoses,
    includeVaccinations: _vaccinations,
    questions: _questions.text,
    patientName: _name.text,
    includeJournal: _journal,
  );

  Future<void> _export({required bool share}) async {
    final db = DatabaseScope.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
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
            subject: l10n.svcSummaryPdfTitle,
          ),
        );
      } else {
        final saved = await FilePicker.saveFile(
          fileName: name,
          bytes: bytes,
          mimeType: visitSummaryMime,
          dialogTitle: l10n.svcSummarySaveDialog,
        );
        if (saved != null) {
          messenger.showSnackBar(SnackBar(content: Text(l10n.svcSummarySaved)));
        }
      }
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.svcSummaryExportFailed('$e'))),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final format = DateFormat(l10n.svcSummaryAppointmentDatePattern);
    Widget heading(String text) => Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 4),
      child: Text(
        text,
        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.svcSummaryTitle)),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _busy ? null : () => _export(share: false),
                  icon: const Icon(Icons.save_alt),
                  label: Text(l10n.commonSave),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(minimumSize: const Size(0, 48)),
                  onPressed: _busy ? null : () => _export(share: true),
                  icon: const Icon(Icons.share),
                  label: Text(l10n.svcSummaryShare),
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
            l10n.svcSummaryIntro,
            style: theme.textTheme.bodyMedium,
          ),
          heading(l10n.entityAppointment),
          DropdownMenu<String?>(
            key: ValueKey(_appointments.length),
            initialSelection: _appointmentId,
            label: Text(l10n.svcSummaryReference),
            expandedInsets: EdgeInsets.zero,
            dropdownMenuEntries: [
              DropdownMenuEntry(value: null, label: l10n.svcSummaryNoAppointment),
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
            decoration: InputDecoration(labelText: l10n.svcSummaryName),
          ),
          heading(l10n.svcSummaryQuestions),
          TextField(
            controller: _questions,
            minLines: 3,
            maxLines: 8,
            decoration: InputDecoration(
              hintText: l10n.svcSummaryQuestionsHint,
              border: const OutlineInputBorder(),
            ),
          ),
          heading(l10n.entitySymptoms),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.svcSummaryAllSymptoms),
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
          heading(l10n.entityMedications),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.svcSummaryAllMedications),
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
          heading(l10n.svcSummaryMore),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.entityDiagnoses),
            value: _diagnoses,
            onChanged: (v) => setState(() => _diagnoses = v),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.entityVaccinations),
            value: _vaccinations,
            onChanged: (v) => setState(() => _vaccinations = v),
          ),
          if (_cycleEnabled)
            SwitchListTile(
              key: const ValueKey('summary-cycle'),
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.cycleSettingsTitle),
              subtitle: Text(l10n.cycleSummarySubtitle),
              value: _includeCycle,
              onChanged: (v) => setState(() => _cycleChoice = v),
            ),
          SwitchListTile(
            key: const ValueKey('summary-journal'),
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.summaryIncludeJournal),
            subtitle: Text(l10n.summaryIncludeJournalSubtitle),
            value: _journal,
            onChanged: (v) => setState(() => _journal = v),
          ),
        ],
      ),
    );
  }
}
