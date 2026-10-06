import 'dart:typed_data';

import 'package:drift/drift.dart' show Variable;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/repositories/archive_repository.dart';
import 'package:mai_doctor_hub/data/repositories/records_repository.dart';
import 'package:mai_doctor_hub/services/assistant/record_context.dart';
import 'package:mai_doctor_hub/services/assistant/record_embedder.dart';
import 'package:mai_doctor_hub/services/assistant/semantic_index.dart';

/// „Bedeutung“ = Themen-Dimensionen: verwandte Wörter landen gemeinsam.
class FakeEmbedder implements RecordEmbedder {
  static const topics = {
    'schilddrüse': 0, 'tsh': 0, 'hypothyreose': 0, 'thyroxin': 0,
    'kopf': 1, 'kopfschmerz': 1, 'migräne': 1,
    'knie': 2, 'meniskus': 2, 'gelenk': 2,
  };

  int embedded = 0;

  @override
  String get modelId => 'fake-1';

  @override
  String get modelName => 'Fake';

  @override
  String get downloadSize => '0';

  @override
  Future<bool> isInstalled() async => true;

  @override
  Stream<int> install({String? token}) => const Stream.empty();

  @override
  void cancelInstall() {}

  @override
  Future<void> uninstall() async {}

  @override
  Future<List<Float32List>> embed(
    List<String> texts, {
    required bool query,
  }) async {
    if (!query) embedded += texts.length;
    return [
      for (final text in texts)
        normalize([
          for (var d = 0; d < 3; d++)
            text
                .toLowerCase()
                .split(RegExp(r'[^\p{L}]+', unicode: true))
                .where((w) => topics[w] == d)
                .length
                .toDouble(),
        ]),
    ];
  }
}

void main() {
  keywordChunkTests();

  late AppDatabase db;
  late RecordsRepository records;
  late FakeEmbedder embedder;
  late SemanticIndex index;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    records = RecordsRepository(db);
    embedder = FakeEmbedder();
    index = SemanticIndex(db, embedder);
  });
  tearDown(() => db.close());

  Future<String> report(String title, String text) => records.createReport(
    title: title,
    mimeType: 'application/pdf',
    localPath: '/tmp/$title.pdf',
    source: ReportSource.pdf,
    extractedText: text,
  );

  test('chunks long text with overlap at sentence boundaries', () {
    final text = List.generate(60, (i) => 'Satz Nummer $i endet hier.').join(' ');
    final chunks = SemanticIndex.chunk(text);
    expect(chunks.length, greaterThan(1));
    expect(chunks.every((c) => c.length <= SemanticIndex.chunkSize), isTrue);
    expect(chunks.first, endsWith('.'));
    // Überlappung: Ende von Abschnitt 1 steht am Anfang von Abschnitt 2.
    final tail = chunks[0].substring(chunks[0].length - 40);
    expect(chunks[1], contains(tail.trim().split(' ').last));
  });

  test('sync is incremental: unchanged entries are not embedded again', () async {
    final id = await report('Labor', 'TSH 3,1 mU/l');
    await records.createNote(body: 'Kopfschmerz nach dem Sport');
    expect(await index.pending(), 2);
    expect(await index.sync(), 2);
    expect(await index.pending(), 0);

    final before = embedder.embedded;
    expect(await index.sync(), 0);
    expect(embedder.embedded, before);

    await db.upsertFts(
      entityType: 'report',
      entityId: id,
      title: 'Labor',
      body: 'TSH 4,2 mU/l',
    );
    expect(await index.sync(), 1);

    await db.deleteFts('report', id);
    await index.sync();
    final left = await db.customSelect(
      'SELECT COUNT(*) AS n FROM record_vectors WHERE entity_id = ?',
      variables: [Variable.withString(id)],
    ).getSingle();
    expect(left.read<int>('n'), 0);
  });

  test('semantic search finds what keywords miss; archived stay out', () async {
    await report('Laborbefund', 'TSH 3,1 mU/l im Normbereich');
    await report('MRT', 'Meniskus rechts unauffällig');
    final archived = await records.createNote(body: 'Thyroxin alte Dosis');
    await ArchiveRepository(db).archive('note', archived);
    await index.sync();

    final keyword = await records.searchAny(
      AssistantContextBuilder.keywords('Wie steht es um meine Schilddrüse?'),
    );
    expect(keyword, isEmpty);

    final hits = await index.search(
      'Wie steht es um meine Schilddrüse?',
      exclude: await records.archivedKeys(),
    );
    expect(hits.first.title, 'Laborbefund');
    expect(hits.map((h) => h.entityId), isNot(contains(archived)));
    expect(hits.map((h) => h.title), isNot(contains('MRT')));
  });

  test('merge alternates keyword and semantic hits without duplicates', () {
    RecordHit hit(String id, String text) => RecordHit(
      entityType: 'note',
      entityId: id,
      title: id,
      text: text,
    );
    final merged = mergeHits(
      [hit('k1', 'a'), hit('both', 'x'), hit('k3', 'c')],
      [hit('both', 'x'), hit('s2', 'b')],
    );
    expect(merged.map((h) => h.entityId), ['k1', 'both', 's2', 'k3']);
  });

  test('assistant context combines both and fills the budget', () async {
    await report('Laborbefund', 'TSH 3,1 mU/l im Normbereich');
    await records.createNote(body: 'Fragen zur Schilddrüse an Dr. Weiß');
    for (var i = 0; i < 20; i++) {
      await records.createNote(body: 'Werte vom Tag $i ${'x' * 400}');
    }
    await index.sync();

    final context = await AssistantContextBuilder(
      db,
      maxChars: 4000,
      semantic: index,
    ).build('Schilddrüse Werte');
    expect(context, contains('Fragen zur Schilddrüse')); // beide Suchen
    expect(context, contains('TSH 3,1')); // nur per Bedeutung
    expect(context, contains('Werte vom Tag')); // nur per Stichwort
    expect(context.length, lessThanOrEqualTo(4000));
    expect(context.length, greaterThan(3500)); // so viel wie Platz ist
  });
}

void keywordChunkTests() {
  test('keyword hits pick the best sections of long reports', () {
    final filler = List.generate(40, (i) => 'Allgemeiner Befundtext Nummer $i.').join(' ');
    final body = '$filler Schilddrüse: TSH 3,1 mU/l, fT4 normal. $filler '
        'Kontrolle der Schilddrüse in 6 Monaten. $filler';
    final hits = keywordChunks(
      [
        (type: 'report', id: 'r1', title: 'Labor', body: body),
        (type: 'note', id: 'n1', title: 'Notiz', body: 'Frage zu TSH'),
      ],
      ['schilddrüse', 'tsh'],
    );
    // Abschnitt mit beiden Begriffen zuerst, nicht der Anfang des Berichts.
    expect(hits.first.text, contains('TSH 3,1'));
    expect(hits.first.chunk, greaterThan(0));
    // Höchstens zwei Abschnitte pro Eintrag.
    expect(hits.where((h) => h.entityId == 'r1'), hasLength(2));
    expect(hits.map((h) => h.entityId), contains('n1'));
    expect(hits.every((h) => h.text.length <= SemanticIndex.chunkSize), isTrue);
  });

  test('keyword and semantic hit on the same section appear once', () {
    const a = RecordHit(entityType: 'report', entityId: 'r', title: 'L', text: 'x', chunk: 2);
    const b = RecordHit(entityType: 'report', entityId: 'r', title: 'L', text: 'x (anders zugeschnitten)', chunk: 2);
    const c = RecordHit(entityType: 'report', entityId: 'r', title: 'L', text: 'y', chunk: 3);
    expect(mergeHits([a], [b, c]).map((h) => h.chunk), [2, 3]);
  });
}
