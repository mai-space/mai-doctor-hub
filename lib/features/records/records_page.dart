import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/database_provider.dart';
import '../../data/repositories/records_repository.dart';
import '../../theme/app_theme.dart';
import '../home/add_appointment_sheet.dart';
import 'detail_pages.dart';
import 'entity_forms.dart';

enum RecordEntityFilter {
  all,
  doctors,
  diagnoses,
  symptoms,
  appointments,
  reports,
  medications,
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
          ? _typeLabel(type)
          : '${_typeLabel(type)} · ${snippet.replaceAll('\n', ' ')}',
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
            for (final entry in _filterLabels.entries)
              if (entry.key != RecordEntityFilter.all)
                ListTile(
                  title: Text('${entry.value} anlegen'),
                  onTap: () => Navigator.pop(context, entry.key),
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
                    'Meine Akte',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                PopupMenuButton<RecordSort>(
                  tooltip: 'Sortierung',
                  initialValue: _sort,
                  onSelected: (value) {
                    setState(() => _sort = value);
                    _reload();
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                      value: RecordSort.date,
                      child: Text('Datum'),
                    ),
                    PopupMenuItem(
                      value: RecordSort.name,
                      child: Text('Name'),
                    ),
                    PopupMenuItem(
                      value: RecordSort.updated,
                      child: Text('Zuletzt geändert'),
                    ),
                  ],
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.sort),
                  ),
                ),
                IconButton(
                  tooltip: 'Eintrag anlegen',
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
              hintText: 'Suche in Akte & Berichten…',
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
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                for (final entry in _filterLabels.entries)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(entry.value),
                      selected: _filter == entry.key,
                      onSelected: (_) {
                        setState(() => _filter = entry.key);
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
                  return const Center(child: Text('Akte wird geladen…'));
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
                                ? 'Noch keine Einträge'
                                : 'Keine Treffer für „${_searchController.text.trim()}“',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Filter und Suche sind bereit — lege den ersten Eintrag an.',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.muted,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          OutlinedButton.icon(
                            onPressed: _createForFilter,
                            icon: const Icon(Icons.add),
                            label: const Text('Eintrag anlegen'),
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
  'note' => Icons.sticky_note_2_outlined,
  _ => Icons.folder_outlined,
};

String _typeLabel(String type) => switch (type) {
  'doctor' => 'Arzt',
  'diagnosis' => 'Diagnose',
  'symptom' => 'Symptom',
  'appointment' => 'Termin',
  'report' => 'Bericht',
  'medication' => 'Medikament',
  'note' => 'Notiz',
  _ => type,
};

const _filterLabels = <RecordEntityFilter, String>{
  RecordEntityFilter.all: 'Alle',
  RecordEntityFilter.doctors: 'Ärzte',
  RecordEntityFilter.diagnoses: 'Diagnosen',
  RecordEntityFilter.symptoms: 'Symptome',
  RecordEntityFilter.appointments: 'Termine',
  RecordEntityFilter.reports: 'Berichte',
  RecordEntityFilter.medications: 'Medikamente',
  RecordEntityFilter.notes: 'Notizen',
};
