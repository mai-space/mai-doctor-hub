import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

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
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Text(
              'Meine Akte',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Suche in Akte & Berichten…',
              leading: const Icon(Icons.search),
              onChanged: (_) => setState(() {}),
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
                      onSelected: (_) => setState(() => _filter = entry.key),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  _searchController.text.trim().isEmpty
                      ? 'Noch keine Einträge — Filter und Suche sind bereit.'
                      : 'Keine Treffer für „${_searchController.text.trim()}“',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: AppColors.muted,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

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
