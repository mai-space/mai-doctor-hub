import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/database_provider.dart';
import 'package:mai_doctor_hub/data/repositories/records_repository.dart';
import 'package:mai_doctor_hub/data/repositories/symptom_repository.dart';
import 'package:mai_doctor_hub/features/assistant/assistant_page.dart';
import 'package:mai_doctor_hub/services/assistant/assistant_engine.dart';
import 'package:mai_doctor_hub/services/assistant/assistant_model.dart';
import 'package:mai_doctor_hub/services/assistant/record_embedder.dart';

import 'semantic_search_test.dart' show FakeEmbedder;

class DownloadingEmbedder extends FakeEmbedder {
  bool installed = false;
  String? token;
  StreamController<int>? controller;

  @override
  Future<bool> isInstalled() async => installed;

  @override
  Stream<int> install({String? token}) {
    this.token = token;
    return (controller = StreamController<int>()).stream;
  }
}

class FakeEngine implements AssistantEngine {
  AssistantSupport supportResult = const AssistantSupported();
  bool installed = false;
  StreamController<int>? downloadController;
  String? lastPrompt;
  String? lastSystem;
  final prompts = <String>[];

  /// Antworten der Reihe nach; leer = Standardantwort.
  final replies = <List<String>>[];

  @override
  String get modelName => 'Testmodell';

  @override
  String get downloadSize => '1 GB';

  @override
  int get contextChars => 6000;

  /// Antwort auf die Suchbegriff-Ergänzung.
  String expansionReply = '';
  final completions = <String>[];

  @override
  Future<String> complete({
    required String system,
    required String prompt,
    int maxTokens = 64,
  }) async {
    completions.add(prompt);
    return expansionReply;
  }

  @override
  Future<AssistantSupport> support() async => supportResult;

  @override
  Future<bool> isInstalled() async => installed;

  @override
  Stream<int> install() {
    downloadController = StreamController<int>();
    return downloadController!.stream;
  }

  @override
  void cancelInstall() {
    downloadController!.addError(const AssistantCancelled());
    downloadController!.close();
  }

  @override
  Future<void> uninstall() async => installed = false;

  @override
  Stream<String> answer({required String system, required String prompt}) {
    lastSystem = system;
    lastPrompt = prompt;
    prompts.add(prompt);
    if (replies.isNotEmpty) return Stream.fromIterable(replies.removeAt(0));
    return Stream.fromIterable(['Dein nächster ', 'Termin ist am 20.10.']);
  }
}

void main() {
  late AppDatabase db;
  late FakeEngine engine;
  late DownloadingEmbedder embedder;

  setUpAll(() => initializeDateFormatting('de'));
  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    engine = FakeEngine();
    AssistantEngine.current = engine;
    RecordEmbedder.current = embedder = DownloadingEmbedder();
    AssistantModel.reset();
  });
  tearDown(() async {
    AssistantModel.reset();
    await db.close();
  });

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 8; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 10)),
      );
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  Future<void> pump(WidgetTester tester) async {
    await tester.pumpWidget(
      DatabaseScope(
        database: db,
        child: const MaterialApp(home: AssistantPage()),
      ),
    );
    await settle(tester);
  }

  testWidgets('unsupported devices get an explanation', (tester) async {
    engine.supportResult = const AssistantUnsupported('Braucht Android 11.');
    await pump(tester);
    expect(find.text('Auf diesem Gerät nicht verfügbar'), findsOneWidget);
    expect(find.text('Braucht Android 11.'), findsOneWidget);
  });

  testWidgets('download with progress, then ask from the record', (
    tester,
  ) async {
    await tester.runAsync(
      () => RecordsRepository(db).createDiagnosis(title: 'Migräne'),
    );
    await pump(tester);
    expect(find.text('Modell herunterladen (1 GB)'), findsOneWidget);

    await tester.tap(find.text('Modell herunterladen (1 GB)'));
    await settle(tester);
    engine.downloadController!.add(42);
    await settle(tester);
    expect(find.textContaining('42 %'), findsOneWidget);

    engine.installed = true;
    await engine.downloadController!.close();
    await settle(tester);
    expect(find.text('Frag deine Akte'), findsOneWidget);

    await tester.tap(find.text('Wann ist mein nächster Termin?'));
    await settle(tester);
    expect(find.text('Dein nächster Termin ist am 20.10.'), findsOneWidget);
    expect(engine.lastPrompt, contains('- Migräne'));
    expect(engine.lastPrompt, contains('FRAGE:\nWann ist mein nächster Termin?'));
    expect(engine.lastSystem, contains('Stelle keine Diagnosen'));
  });

  testWidgets('cancelled download returns to setup', (tester) async {
    await pump(tester);
    await tester.tap(find.text('Modell herunterladen (1 GB)'));
    await settle(tester);
    await tester.tap(find.text('Abbrechen'));
    await settle(tester);
    expect(find.text('Modell herunterladen (1 GB)'), findsOneWidget);
    expect(find.textContaining('fehlgeschlagen'), findsNothing);
  });

  testWidgets('semantic search: token, download, index, then used', (
    tester,
  ) async {
    engine.installed = true;
    await tester.runAsync(
      () => RecordsRepository(db).createReport(
        title: 'Laborbefund',
        mimeType: 'application/pdf',
        localPath: '/tmp/l.pdf',
        source: ReportSource.pdf,
        extractedText: 'TSH 3,1 mU/l',
      ),
    );
    await pump(tester);
    await tester.scrollUntilVisible(
      find.text('Semantische Suche aktivieren'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(find.byType(TextField).first, 'hf_test');
    await settle(tester);
    await tester.tap(find.text('Semantische Suche aktivieren'));
    await settle(tester);
    expect(embedder.token, 'hf_test');
    embedder.controller!.add(50);
    await settle(tester);
    expect(find.textContaining('50 %'), findsOneWidget);

    embedder.installed = true;
    await embedder.controller!.close();
    await settle(tester);
    expect(find.textContaining('Aktiv:'), findsOneWidget);

    await tester.enterText(find.byType(TextField).last, 'Schilddrüse?');
    await tester.tap(find.byTooltip('Fragen'));
    await settle(tester);
    // Nur per Bedeutung auffindbar: „Schilddrüse“ steht nicht im Bericht.
    expect(engine.lastPrompt, contains('TSH 3,1'));
  });

  testWidgets('semantic card explains how to get the token, with links', (
    tester,
  ) async {
    engine.installed = true;
    await pump(tester);
    await tester.scrollUntilVisible(
      find.text('Token-Seite öffnen'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.textContaining('Agree and access repository'), findsOneWidget);
    expect(find.text('Hugging Face öffnen'), findsOneWidget);
    expect(find.text('Modellseite öffnen'), findsOneWidget);
    expect(find.text('Googles Originalseite'), findsOneWidget);
    expect(
      find.byTooltip(
        'https://huggingface.co/litert-community/embeddinggemma-300m',
      ),
      findsOneWidget,
    );
    expect(
      find.byTooltip('https://huggingface.co/settings/tokens'),
      findsOneWidget,
    );
  });

  testWidgets('empty answer is retried once with a shorter extract', (
    tester,
  ) async {
    engine.installed = true;
    await tester.runAsync(() async {
      for (var i = 0; i < 40; i++) {
        await RecordsRepository(
          db,
        ).createNote(body: 'Termin Notiz $i ${'x' * 300}');
      }
    });
    engine.replies
      ..add(const [])
      ..add(const ['Am 20.10.']);
    await pump(tester);
    await tester.tap(find.text('Wann ist mein nächster Termin?'));
    await settle(tester);
    expect(find.text('Am 20.10.'), findsOneWidget);
    expect(engine.prompts, hasLength(2));
    expect(engine.prompts[1].length, lessThan(engine.prompts[0].length));
    expect(engine.prompts[0].length, lessThanOrEqualTo(6000 + 200));
  });

  testWidgets('still empty after retry: user sees a hint', (tester) async {
    engine.installed = true;
    engine.replies
      ..add(const [])
      ..add(const []);
    await pump(tester);
    await tester.tap(find.text('Wann ist mein nächster Termin?'));
    await settle(tester);
    expect(find.textContaining('Keine Antwort erhalten'), findsOneWidget);
  });

  testWidgets('model-suggested terms find reports the question misses', (
    tester,
  ) async {
    engine.installed = true;
    engine.expansionReply = 'TSH, Hypothyreose';
    await tester.runAsync(
      () => RecordsRepository(db).createReport(
        title: 'Laborbefund',
        mimeType: 'application/pdf',
        localPath: '/tmp/l.pdf',
        source: ReportSource.pdf,
        extractedText: 'TSH 3,1 mU/l im Normbereich',
      ),
    );
    await pump(tester);
    await tester.enterText(find.byType(TextField).last, 'Wie geht es meiner Schilddrüse?');
    await tester.tap(find.byTooltip('Fragen'));
    await settle(tester);
    expect(engine.completions.single, contains('Schilddrüse'));
    expect(engine.lastPrompt, contains('TSH 3,1'));
  });

  testWidgets('answer renders as Markdown, follow-ups become chips', (
    tester,
  ) async {
    engine.installed = true;
    engine.replies.add(const [
      '**Mögliche Zusammenhänge**\n- Schlaf war ',
      'kurz\n\n**Was du tun kannst**\n- Schlaf notieren\n\n',
      'FOLGEFRAGEN: Woher kommt das? | Was soll ich beobachten?',
    ]);
    await pump(tester);
    await tester.tap(find.text('Wann ist mein nächster Termin?'));
    await settle(tester);
    expect(
      find.textContaining('Mögliche Zusammenhänge', findRichText: true),
      findsOneWidget,
    );
    expect(find.textContaining('Schlaf war kurz', findRichText: true), findsOneWidget);
    expect(find.textContaining('**', findRichText: true), findsNothing);
    expect(find.textContaining('FOLGEFRAGEN', findRichText: true), findsNothing);
    expect(find.widgetWithText(ActionChip, 'Woher kommt das?'), findsOneWidget);
    expect(
      find.widgetWithText(ActionChip, 'Was soll ich beobachten?'),
      findsOneWidget,
    );
  });

  testWidgets('tapping a chip asks it with the previous turn as context', (
    tester,
  ) async {
    engine.installed = true;
    await tester.runAsync(() async {
      await SymptomRepository(db).create(label: 'Kopfschmerzen');
      await RecordsRepository(
        db,
      ).createNote(body: 'Magnesium probiert wegen Kopfschmerzen');
    });
    engine.replies.add(['Mögliche Zusammenhänge: ${'Schlaf ' * 400}']);
    await pump(tester);
    await tester.enterText(
      find.byType(TextField).last,
      'Woher kommen meine Kopfschmerzen?',
    );
    await tester.tap(find.byTooltip('Fragen'));
    await settle(tester);
    // Keine Folgefragen vom Modell: feste, symptombezogene in beide Richtungen.
    for (final chip in [
      'Verlauf von Kopfschmerzen',
      'Was könnte bei Kopfschmerzen zusammenhängen?',
      'Fragen an die Ärztin zu Kopfschmerzen',
    ]) {
      expect(find.widgetWithText(ActionChip, chip), findsOneWidget);
    }

    final chip = find.widgetWithText(
      ActionChip,
      'Fragen an die Ärztin zu Kopfschmerzen',
    );
    await tester.ensureVisible(chip);
    await tester.tap(chip);
    await settle(tester);
    expect(engine.prompts, hasLength(2));
    final second = engine.prompts[1];
    expect(second, contains('FRAGE:\nFragen an die Ärztin zu Kopfschmerzen'));
    expect(second, contains('BISHERIGES GESPRÄCH:'));
    expect(second, contains('Nutzer: Woher kommen meine Kopfschmerzen?'));
    expect(second, contains('Assistent: Mögliche Zusammenhänge'));
    // Lange Antwort gekürzt, Prompt im Budget.
    expect(second, isNot(contains('Schlaf ' * 400)));
    expect(second.length, lessThanOrEqualTo(6000 + 200));

    // Begriffe der vorigen Frage suchen mit (die neue nennt sie nicht).
    await tester.enterText(find.byType(TextField).last, 'Was hilft dabei?');
    await tester.tap(find.byTooltip('Fragen'));
    await settle(tester);
    expect(engine.prompts, hasLength(3));
    expect(engine.prompts[2], contains('Magnesium'));
    expect(engine.prompts[2].length, lessThanOrEqualTo(6000 + 200));
  });
}
