import 'dart:async';

import 'package:flutter/material.dart';

import '../assistant/assistant_page.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/records_repository.dart';
import '../../l10n/l10n.dart';
import '../../theme/app_theme.dart';
import '../cycle/cycle_home_card.dart' show CycleRecordsTile;
import '../home/add_appointment_sheet.dart';
import 'detail_pages.dart';
import '../medications/pharmacy_form.dart';
import '../medications/vaccination_form.dart';
import '../summary/visit_summary_page.dart';
import 'entity_forms.dart';

enum RecordEntityFilter {
  all,
  doctors,
  diagnoses,
  symptoms,
  appointments,
  reports,
  medications,
  pharmacies,
  vaccinations,
  notes,
}

class RecordsPage extends StatefulWidget {
  const RecordsPage({super.key});

  @override
  State<RecordsPage> createState() => _RecordsPageState();
}

class _RecordsPageState extends State<RecordsPage> {
  RecordEntityFilter _filter = RecordEntityFilter.all;
  RecordSort _sort = RecordSort.date;
  final _searchController = TextEditingController();
  Stream<List<RecordListItem>>? _stream;
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  String? get _entityType => switch (_filter) {
    RecordEntityFilter.all => null,
    RecordEntityFilter.doctors => 'doctor',
    RecordEntityFilter.diagnoses => 'diagnosis',
    RecordEntityFilter.symptoms => 'symptom',
    RecordEntityFilter.appointments => 'appointment',
    RecordEntityFilter.reports => 'report',
    RecordEntityFilter.medications => 'medication',
    RecordEntityFilter.pharmacies => 'pharmacy',
    RecordEntityFilter.vaccinations => 'vaccination',
    RecordEntityFilter.notes => 'note',
  };

  /// Liste bzw. Suchergebnis — beides reaktiv auf Datenänderungen.
  Stream<List<RecordListItem>> _buildStream() {
    final db = DatabaseScope.of(context);
    final repo = RecordsRepository(db);
    final query = _searchController.text.trim();
    final type = _entityType;
    if (query.isEmpty) return repo.watchAll(sort: _sort, entityType: type);
    return db.watchWith(
      {
        db.doctors,
        db.diagnoses,
        db.symptoms,
        db.appointments,
        db.reports,
        db.medications,
        db.notes,
        db.pharmacies,
        db.vaccinations,
      },
      () async {
        final rows = await repo.search(query, entityType: type);
        return [
          for (final row in rows)
            _searchItem(
              row.read<String>('entity_type'),
              row.read<String>('entity_id'),
              row.read<String>('title'),
              row.read<String>('body'),
            ),
        ];
      },
    );
  }

  RecordListItem _searchItem(String type, String id, String title, String body) {
    final snippet = body.length > 60 ? '${body.substring(0, 60)}…' : body;
    return RecordListItem(
      entityType: type,
      entityId: id,
      title: title,
      subtitle: snippet.isEmpty
          ? _typeLabel(context, type)
          : '${_typeLabel(context, type)} · ${snippet.replaceAll('\n', ' ')}',
      sortDate: DateTime.now(),
    );
  }

  void _reload() => setState(() => _stream = _buildStream());

  void _onSearchChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      if (mounted) _reload();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _stream ??= _buildStream();
  }

  Future<void> _createForFilter() async {
    switch (_filter) {
      case RecordEntityFilter.doctors:
        await showCreateDoctorDialog(context);
      case RecordEntityFilter.diagnoses:
        await showCreateDiagnosisDialog(context);
      case RecordEntityFilter.symptoms:
        await showCreateSymptomDialog(context);
      case RecordEntityFilter.appointments:
        await showAddAppointmentSheet(context);
      case RecordEntityFilter.reports:
        await importReport(context);
      case RecordEntityFilter.medications:
        await showCreateMedicationDialog(context);
      case RecordEntityFilter.pharmacies:
        await showPharmacyForm(context);
      case RecordEntityFilter.vaccinations:
        await showVaccinationForm(context);
      case RecordEntityFilter.notes:
        await showCreateNoteDialog(context);
      case RecordEntityFilter.all:
        await _showCreateMenu();
    }
    if (mounted && _searchController.text.isNotEmpty) _reload();
  }

  Future<void> _showCreateMenu() async {
    final choice = await showModalBottomSheet<RecordEntityFilter>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final filter in RecordEntityFilter.values)
              if (filter != RecordEntityFilter.all)
                ListTile(
                  title: Text(_createLabel(context, filter)),
                  onTap: () => Navigator.pop(context, filter),
                ),
          ],
        ),
      ),
    );
    if (choice == null || !mounted) return;
    setState(() => _filter = choice);
    await _createForFilter();
  }

  void _openItem(RecordListItem item) =>
      openRecord(context, item.entityType, item.entityId);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.recordsTitle,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  tooltip: l10n.recordsAssistantTooltip,
                  icon: const Icon(Icons.auto_awesome_outlined),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const AssistantPage(),
                    ),
                  ),
                ),
                IconButton(
                  tooltip: l10n.recordsVisitSummaryTooltip,
                  icon: const Icon(Icons.summarize_outlined),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const VisitSummaryPage(),
                    ),
                  ),
                ),
                PopupMenuButton<RecordSort>(
                  tooltip: l10n.recordsSortTooltip,
                  initialValue: _sort,
                  onSelected: (value) {
                    setState(() => _sort = value);
                    _reload();
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: RecordSort.date,
                      child: Text(l10n.recordsSortDate),
                    ),
                    PopupMenuItem(
                      value: RecordSort.name,
                      child: Text(l10n.recordsSortName),
                    ),
                    PopupMenuItem(
                      value: RecordSort.updated,
                      child: Text(l10n.recordsSortUpdated),
                    ),
                  ],
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.sort),
                  ),
                ),
                IconButton(
                  tooltip: l10n.recordsAddEntry,
                  onPressed: _createForFilter,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SearchBar(
              controller: _searchController,
              hintText: l10n.recordsSearchHint,
              leading: const Icon(Icons.search),
              trailing: [
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      _reload();
                    },
                  ),
              ],
              onChanged: _onSearchChanged,
            ),
          ),
          const SizedBox(height: 12),
          const CycleRecordsTile(),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                for (final filter in RecordEntityFilter.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(_filterLabel(context, filter)),
                      selected: _filter == filter,
                      onSelected: (_) {
                        setState(() => _filter = filter);
                        _reload();
                      },
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<RecordListItem>>(
              stream: _stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: Text(l10n.recordsLoading));
                }
                final items = snapshot.data ?? const [];
                if (items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.folder_open_outlined,
                            size: 48,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _searchController.text.trim().isEmpty
                                ? l10n.recordsEmpty
                                : l10n.recordsNoResults(
                                    _searchController.text.trim(),
                                  ),
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.recordsEmptyHint,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.muted,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: _createForFilter,
                            icon: const Icon(Icons.add),
                            label: Text(l10n.recordsAddEntry),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 4),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      tileColor: theme.colorScheme.surface,
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Icon(
                          _iconFor(item.entityType),
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      title: Text(item.title),
                      subtitle: Text(item.subtitle),
                      onTap: () => _openItem(item),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

IconData _iconFor(String type) => switch (type) {
  'doctor' => Icons.medical_services_outlined,
  'diagnosis' => Icons.biotech_outlined,
  'symptom' => Icons.healing_outlined,
  'appointment' => Icons.event_outlined,
  'report' => Icons.description_outlined,
  'medication' => Icons.medication_outlined,
  'pharmacy' => Icons.local_pharmacy_outlined,
  'vaccination' => Icons.vaccines_outlined,
  'note' => Icons.sticky_note_2_outlined,
  _ => Icons.folder_outlined,
};

String _typeLabel(BuildContext context, String type) {
  final l10n = context.l10n;
  return switch (type) {
    'doctor' => l10n.entityDoctor,
    'diagnosis' => l10n.entityDiagnosis,
    'symptom' => l10n.entitySymptom,
    'appointment' => l10n.entityAppointment,
    'report' => l10n.entityReport,
    'medication' => l10n.entityMedication,
    'pharmacy' => l10n.entityPharmacy,
    'vaccination' => l10n.entityVaccination,
    'note' => l10n.entityNote,
    _ => type,
  };
}

String _filterLabel(BuildContext context, RecordEntityFilter filter) {
  final l10n = context.l10n;
  return switch (filter) {
    RecordEntityFilter.all => l10n.recordsFilterAll,
    RecordEntityFilter.doctors => l10n.entityDoctors,
    RecordEntityFilter.diagnoses => l10n.entityDiagnoses,
    RecordEntityFilter.symptoms => l10n.entitySymptoms,
    RecordEntityFilter.appointments => l10n.entityAppointments,
    RecordEntityFilter.reports => l10n.entityReports,
    RecordEntityFilter.medications => l10n.entityMedications,
    RecordEntityFilter.pharmacies => l10n.entityPharmacies,
    RecordEntityFilter.vaccinations => l10n.entityVaccinations,
    RecordEntityFilter.notes => l10n.entityNotes,
  };
}

/// Eintrag im „+“-Menü (Deutsch: Plural wie bisher, z. B. „Ärzte anlegen“).
String _createLabel(BuildContext context, RecordEntityFilter filter) {
  final l10n = context.l10n;
  return switch (filter) {
    RecordEntityFilter.all => l10n.recordsAddEntry,
    RecordEntityFilter.doctors => l10n.recordsCreateDoctors,
    RecordEntityFilter.diagnoses => l10n.recordsCreateDiagnoses,
    RecordEntityFilter.symptoms => l10n.recordsCreateSymptoms,
    RecordEntityFilter.appointments => l10n.recordsCreateAppointments,
    RecordEntityFilter.reports => l10n.recordsCreateReports,
    RecordEntityFilter.medications => l10n.recordsCreateMedications,
    RecordEntityFilter.pharmacies => l10n.recordsCreatePharmacies,
    RecordEntityFilter.vaccinations => l10n.recordsCreateVaccinations,
    RecordEntityFilter.notes => l10n.recordsCreateNotes,
  };
}
