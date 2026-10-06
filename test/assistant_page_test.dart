import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/database_provider.dart';
import 'package:mai_doctor_hub/data/repositories/records_repository.dart';
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

  @override
  String get modelName => 'Testmodell';

  @override
  String get downloadSize => '1 GB';

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
}
