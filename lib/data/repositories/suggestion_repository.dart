import '../app_database.dart';
import '../suggestion_catalog.dart';

/// Freitextfelder, für die bereits eingegebene Werte vorgeschlagen werden.
enum SuggestionField {
  bodyRegion,
  specialty,
  symptomLabel,
  diagnosisTitle,
  medicationName,
  dosage,
  medicationSchedule,
  appointmentTitle,
}

/// Liefert früher eingegebene Werte eines Feldes — häufigste zuerst,
/// bei Gleichstand die zuletzt genutzten. Groß-/Kleinschreibung wird
/// zusammengefasst (die zuletzt verwendete Schreibweise gewinnt).
class SuggestionRepository {
  SuggestionRepository(this._db);

  final AppDatabase _db;

  static const _sources = <SuggestionField, (String, String, String)>{
    SuggestionField.bodyRegion: ('symptoms', 'body_region', 'updated_at'),
    SuggestionField.specialty: ('doctors', 'specialty', 'updated_at'),
    SuggestionField.symptomLabel: ('symptoms', 'label', 'updated_at'),
    SuggestionField.diagnosisTitle: ('diagnoses', 'title', 'updated_at'),
    SuggestionField.medicationName: ('medications', 'name', 'created_at'),
    SuggestionField.dosage: ('medications', 'dosage', 'created_at'),
    SuggestionField.medicationSchedule: (
      'medications',
      'schedule_text',
      'created_at',
    ),
    SuggestionField.appointmentTitle: ('appointments', 'title', 'updated_at'),
  };

  /// Statische Vorschläge — nach den eigenen Werten angehängt.
  static const _defaults = <SuggestionField, List<String>>{
    SuggestionField.bodyRegion: bodyRegionCatalog,
    SuggestionField.specialty: specialtyCatalog,
    SuggestionField.symptomLabel: symptomCatalog,
  };

  Future<List<String>> valuesFor(SuggestionField field) async {
    final (table, column, timestamp) = _sources[field]!;
    final rows = await _db.customSelect('''
          SELECT TRIM($column) AS value
          FROM $table
          WHERE $column IS NOT NULL AND TRIM($column) <> ''
          ORDER BY $timestamp DESC
          ''', readsFrom: {}).get();

    // In Dart gruppieren: SQLite-LOWER() kennt keine Umlaute; [normalize]
    // fasst auch „Übelkeit“/„Uebelkeit“ zusammen.
    final uses = <String, int>{};
    final spelling = <String, String>{}; // Einfügereihenfolge = Aktualität
    for (final row in rows) {
      final value = row.read<String>('value');
      final key = normalize(value);
      uses[key] = (uses[key] ?? 0) + 1;
      spelling.putIfAbsent(key, () => value);
    }
    // List.sort ist nicht stabil → Aktualität explizit als Tiebreaker.
    final keys = spelling.keys.toList();
    final recency = {for (var i = 0; i < keys.length; i++) keys[i]: i};
    keys.sort((a, b) {
      final byUses = uses[b]!.compareTo(uses[a]!);
      return byUses != 0 ? byUses : recency[a]!.compareTo(recency[b]!);
    });

    final values = [for (final key in keys) spelling[key]!];
    for (final value in _defaults[field] ?? const <String>[]) {
      if (!uses.containsKey(normalize(value))) values.add(value);
    }
    return values;
  }

  /// Präfix-Treffer zuerst, dann Wortanfänge, dann Treffer im Wort.
  /// Wörtlich schon Getipptes wird ausgeblendet (nichts mehr zu ergänzen).
  /// Groß-/Kleinschreibung und Umlaut-Schreibweisen sind egal
  /// („ubelkeit“, „uebelkeit“ → „Übelkeit“).
  static List<String> filter(List<String> values, String input) {
    final raw = input.trim().toLowerCase();
    final query = normalize(raw);
    if (query.isEmpty) return values.take(8).toList();
    final prefix = <String>[];
    final wordStart = <String>[];
    final contains = <String>[];
    for (final value in values) {
      // Nur wörtlich Getipptes ausblenden — „ubelkeit“ schlägt „Übelkeit“ vor.
      if (value.toLowerCase() == raw) continue;
      final text = normalize(value);
      if (text.startsWith(query)) {
        prefix.add(value);
      } else if (text
          .split(RegExp(r'[\s,/()-]+'))
          .any((w) => w.startsWith(query))) {
        wordStart.add(value);
      } else if (text.contains(query)) {
        contains.add(value);
      }
    }
    return [...prefix, ...wordStart, ...contains].take(8).toList();
  }

  /// Vergleichsform: klein, Umlaute/ß aufgelöst (ä/ae → a usw.).
  static String normalize(String text) => text
      .toLowerCase()
      .replaceAll('ä', 'a')
      .replaceAll('ö', 'o')
      .replaceAll('ü', 'u')
      .replaceAll('ß', 'ss')
      .replaceAll('ae', 'a')
      .replaceAll('oe', 'o')
      .replaceAll('ue', 'u');
}
