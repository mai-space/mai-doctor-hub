import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';

import '../../data/app_database.dart';
import 'record_embedder.dart';

/// Ein Abschnitt der Akte, gefunden per Stichwort und/oder Bedeutung.
class RecordHit {
  const RecordHit({
    required this.entityType,
    required this.entityId,
    required this.title,
    required this.text,
    this.chunk = 0,
    this.score = 0,
  });

  final String entityType;
  final String entityId;
  final String title;
  final String text;

  /// Abschnittsnummer in `title + body` (siehe [SemanticIndex.chunk]).
  final int chunk;
  final double score;

  String get entityKey => '$entityType:$entityId';

  String get chunkKey => '$entityKey#$chunk';
}

/// Vektorindex über `records_fts` (alle Einträge inkl. Berichtstext), in der
/// verschlüsselten App-Datenbank. Nur geänderte Einträge werden neu
/// eingebettet.
class SemanticIndex {
  SemanticIndex(this._db, this._embedder);

  final AppDatabase _db;
  final RecordEmbedder _embedder;

  /// Zeichen pro Abschnitt (≈ 250–300 Tokens, passt sicher in seq512).
  /// Zeichen pro Abschnitt: klein genug, dass mehrere passende Stellen ins
  /// Kontextfenster passen; groß genug für einen zusammenhängenden Befund.
  static const chunkSize = 600;
  static const chunkOverlap = 100;

  /// Ändert sich die Zerlegung, wird der Index neu aufgebaut.
  static const chunkVersion = 2;

  /// Gespeicherte Modellkennung: Modell + Zerlegung.
  String get _model => '${_embedder.modelId}#c$chunkVersion';

  /// Text eines Eintrags, wie er zerlegt wird.
  static String source(String title, String body) => '$title\n$body';

  /// Teilt an Absatz-/Satzgrenzen, mit Überlappung.
  static List<String> chunk(String text) {
    final clean = text.replaceAll(RegExp(r'[ \t]+'), ' ').trim();
    if (clean.length <= chunkSize) return clean.isEmpty ? const [] : [clean];
    final chunks = <String>[];
    var start = 0;
    while (start < clean.length) {
      var end = (start + chunkSize).clamp(0, clean.length);
      if (end < clean.length) {
        final window = clean.substring(start, end);
        final cut = [
          window.lastIndexOf('\n'),
          window.lastIndexOf('. '),
          window.lastIndexOf(' '),
        ].firstWhere((i) => i > chunkSize ~/ 2, orElse: () => -1);
        if (cut > 0) end = start + cut + 1;
      }
      chunks.add(clean.substring(start, end).trim());
      if (end >= clean.length) break;
      start = end - chunkOverlap;
    }
    return chunks;
  }

  /// Gleicht den Index ab; meldet (erledigt, gesamt) der zu bearbeitenden
  /// Einträge. Gibt die Zahl neu eingebetteter Einträge zurück.
  Future<int> sync({void Function(int done, int total)? onProgress}) async {
    final model = _model;
    final sources = await _db
        .customSelect(
          'SELECT entity_type, entity_id, title, body FROM records_fts',
        )
        .get();
    final known = <String, String>{
      for (final row
          in await _db
              .customSelect(
                'SELECT DISTINCT entity_type, entity_id, source_hash FROM record_vectors '
                'WHERE model = ?',
                variables: [Variable.withString(model)],
              )
              .get())
        '${row.read<String>('entity_type')}:${row.read<String>('entity_id')}':
            row.read<String>('source_hash'),
    };

    final todo = <(String, String, String, String, String)>[];
    final present = <String>{};
    for (final row in sources) {
      final type = row.read<String>('entity_type');
      final id = row.read<String>('entity_id');
      final title = row.read<String>('title');
      final body = row.read<String>('body');
      final key = '$type:$id';
      present.add(key);
      final hash = sha1.convert(utf8.encode('$title\n$body')).toString();
      if (known[key] != hash) todo.add((type, id, title, body, hash));
    }

    // Gelöschte Einträge und Vektoren eines anderen Modells entfernen.
    await _db.customStatement('DELETE FROM record_vectors WHERE model <> ?', [
      model,
    ]);
    for (final key in known.keys.where((k) => !present.contains(k))) {
      final (type, id) = _split(key);
      await _delete(type, id);
    }

    var done = 0;
    onProgress?.call(0, todo.length);
    for (final (type, id, title, body, hash) in todo) {
      final chunks = chunk(source(title, body));
      final vectors = chunks.isEmpty
          ? const <Float32List>[]
          : await _embedder.embed(chunks, query: false);
      await _db.transaction(() async {
        await _delete(type, id);
        for (var i = 0; i < chunks.length; i++) {
          await _db.customStatement(
            'INSERT INTO record_vectors (entity_type, entity_id, chunk, model, '
            'source_hash, content, vector) VALUES (?, ?, ?, ?, ?, ?, ?)',
            [
              type,
              id,
              i,
              model,
              hash,
              chunks[i],
              vectors[i].buffer.asUint8List(),
            ],
          );
        }
      });
      onProgress?.call(++done, todo.length);
    }
    return todo.length;
  }

  /// Wie viele Einträge fehlen oder sind veraltet (ohne einzubetten)?
  Future<int> pending() async {
    final row = await _db
        .customSelect(
          '''
      SELECT COUNT(*) AS n FROM records_fts f
      WHERE NOT EXISTS (
        SELECT 1 FROM record_vectors v
        WHERE v.entity_type = f.entity_type AND v.entity_id = f.entity_id
          AND v.model = ?
      )
      ''',
          variables: [Variable.withString(_model)],
        )
        .getSingle();
    return row.read<int>('n');
  }

  /// Die [limit] ähnlichsten Abschnitte (Kosinus), ab [minScore].
  Future<List<RecordHit>> search(
    String question, {
    int limit = 8,
    double minScore = 0.3,
    Set<String> exclude = const {},
  }) async {
    final query = (await _embedder.embed([question], query: true)).single;
    final rows = await _db
        .customSelect(
          '''
      SELECT v.entity_type, v.entity_id, v.chunk, v.content, v.vector, f.title
      FROM record_vectors v
      JOIN records_fts f
        ON f.entity_type = v.entity_type AND f.entity_id = v.entity_id
      WHERE v.model = ?
      ''',
          variables: [Variable.withString(_model)],
        )
        .get();
    final hits = <RecordHit>[];
    for (final row in rows) {
      final key =
          '${row.read<String>('entity_type')}:${row.read<String>('entity_id')}';
      if (exclude.contains(key)) continue;
      final bytes = row.read<Uint8List>('vector');
      final vector = Float32List.view(
        bytes.buffer,
        bytes.offsetInBytes,
        bytes.lengthInBytes ~/ 4,
      );
      final score = _dot(query, vector);
      if (score < minScore) continue;
      hits.add(
        RecordHit(
          entityType: row.read<String>('entity_type'),
          entityId: row.read<String>('entity_id'),
          title: row.read<String>('title'),
          text: withoutTitle(
            row.read<String>('content'),
            row.read<String>('title'),
          ),
          chunk: row.read<int>('chunk'),
          score: score,
        ),
      );
    }
    hits.sort((a, b) => b.score.compareTo(a.score));
    return hits.take(limit).toList();
  }

  Future<void> clear() => _db.customStatement('DELETE FROM record_vectors');

  Future<void> _delete(String type, String id) => _db.customStatement(
    'DELETE FROM record_vectors WHERE entity_type = ? AND entity_id = ?',
    [type, id],
  );

  static (String, String) _split(String key) {
    final i = key.indexOf(':');
    return (key.substring(0, i), key.substring(i + 1));
  }

  static double _dot(Float32List a, Float32List b) {
    if (a.length != b.length) return -1;
    var sum = 0.0;
    for (var i = 0; i < a.length; i++) {
      sum += a[i] * b[i];
    }
    return sum;
  }
}

/// Abschnitt 0 beginnt mit dem Titel — der steht in der Ausgabe schon davor.
String withoutTitle(String text, String title) =>
    text.startsWith(title) ? text.substring(title.length).trimLeft() : text;

/// Stichworttreffer auf Abschnittsebene: die Einträge aus der Volltextsuche
/// werden wie für den Vektorindex zerlegt; ein Abschnitt zählt, wie oft
/// Suchbegriffe darin vorkommen (Wortanfang, ohne Groß/Klein). Pro Eintrag
/// höchstens [perEntry] Abschnitte, insgesamt [limit].
List<RecordHit> keywordChunks(
  List<({String type, String id, String title, String body})> entries,
  List<String> terms, {
  int limit = 10,
  int perEntry = 2,
}) {
  final patterns = [
    for (final term in terms.where((t) => t.length >= 2))
      RegExp(
        '(?<![\\p{L}\\p{N}])${RegExp.escape(term)}',
        caseSensitive: false,
        unicode: true,
      ),
  ];
  if (patterns.isEmpty) return const [];
  final scored = <(RecordHit, int, int)>[];
  for (final (rank, e) in entries.indexed) {
    final chunks = SemanticIndex.chunk(SemanticIndex.source(e.title, e.body));
    final best = <(int, int)>[];
    for (final (i, text) in chunks.indexed) {
      // Verschiedene Begriffe zählen mehr als Wiederholungen desselben.
      var distinct = 0;
      var total = 0;
      for (final p in patterns) {
        final n = p.allMatches(text).length;
        if (n > 0) distinct++;
        total += n;
      }
      if (total > 0) best.add((i, distinct * 100 + total));
    }
    best.sort((a, b) => b.$2.compareTo(a.$2));
    for (final (i, score) in best.take(perEntry)) {
      scored.add((
        RecordHit(
          entityType: e.type,
          entityId: e.id,
          title: e.title,
          text: withoutTitle(chunks[i], e.title),
          chunk: i,
          score: score.toDouble(),
        ),
        score,
        rank,
      ));
    }
  }
  // Bester Abschnitt zuerst; bei Gleichstand die Reihenfolge der Volltextsuche.
  scored.sort((a, b) {
    final byScore = b.$2.compareTo(a.$2);
    return byScore != 0 ? byScore : a.$3.compareTo(b.$3);
  });
  return [for (final (hit, _, _) in scored.take(limit)) hit];
}

/// Stichwort- und Bedeutungstreffer abwechselnd, ohne doppelte Abschnitte —
/// die jeweils besten zuerst, so dass beide Suchen gleich gewichtet sind.
List<RecordHit> mergeHits(List<RecordHit> keyword, List<RecordHit> semantic) {
  final seen = <String>{};
  final merged = <RecordHit>[];
  for (var i = 0; i < keyword.length || i < semantic.length; i++) {
    for (final list in [keyword, semantic]) {
      if (i >= list.length) continue;
      final hit = list[i];
      if (seen.add(hit.chunkKey)) merged.add(hit);
    }
  }
  return merged;
}
