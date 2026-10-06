import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../data/app_database.dart';
import '../../l10n/l10n.dart';
import 'assistant_engine.dart';
import 'record_embedder.dart';
import 'semantic_index.dart';

enum AssistantPhase { checking, unsupported, notInstalled, downloading, ready }

/// Semantische Suche: optionales Zusatzmodell (Embeddings).
enum SemanticPhase { notInstalled, downloading, indexing, ready }

/// Zustand der lokalen Modelle — lebt außerhalb der Seite, damit laufende
/// Downloads beim Verlassen weiterlaufen und sichtbar bleiben.
class AssistantModel extends ChangeNotifier {
  AssistantModel(this.engine, this.embedder);

  static AssistantModel? _instance;
  static AssistantModel get instance => _instance ??= AssistantModel(
    AssistantEngine.current,
    RecordEmbedder.current,
  );

  @visibleForTesting
  static void reset() => _instance = null;

  final AssistantEngine engine;
  final RecordEmbedder embedder;

  AssistantPhase phase = AssistantPhase.checking;
  int progress = 0;
  bool lowMemory = false;

  /// Grund für „nicht unterstützt“ oder letzte Fehlermeldung.
  String? message;

  SemanticPhase semanticPhase = SemanticPhase.notInstalled;
  int semanticProgress = 0;
  int indexDone = 0;
  int indexTotal = 0;
  String? semanticMessage;

  StreamSubscription<int>? _download;
  StreamSubscription<int>? _semanticDownload;
  Future<void>? _indexing;

  Future<void> refresh() async {
    if (phase == AssistantPhase.downloading) return;
    final support = await engine.support();
    switch (support) {
      case AssistantUnsupported(:final reason):
        phase = AssistantPhase.unsupported;
        message = reason;
      case AssistantSupported(lowMemory: final low):
        lowMemory = low;
        phase = await engine.isInstalled()
            ? AssistantPhase.ready
            : AssistantPhase.notInstalled;
        if (semanticPhase == SemanticPhase.notInstalled &&
            await embedder.isInstalled()) {
          semanticPhase = SemanticPhase.ready;
        }
    }
    notifyListeners();
  }

  void download() {
    if (phase == AssistantPhase.downloading) return;
    phase = AssistantPhase.downloading;
    progress = 0;
    message = null;
    notifyListeners();
    _download = engine.install().listen(
      (percent) {
        progress = percent;
        notifyListeners();
      },
      onError: (Object e) {
        phase = AssistantPhase.notInstalled;
        message = e is AssistantCancelled
            ? null
            : AppLocale.strings.svcDownloadFailed('$e');
        notifyListeners();
      },
      onDone: () {
        if (phase == AssistantPhase.downloading) {
          phase = AssistantPhase.ready;
          notifyListeners();
        }
      },
    );
  }

  void cancel() => engine.cancelInstall();

  Future<void> delete() async {
    await _download?.cancel();
    await engine.uninstall();
    phase = AssistantPhase.notInstalled;
    notifyListeners();
  }

  /// Lädt das Embedding-Modell und baut danach den Index auf.
  void downloadSemantic(AppDatabase db, {String? token}) {
    if (semanticPhase != SemanticPhase.notInstalled) return;
    semanticPhase = SemanticPhase.downloading;
    semanticProgress = 0;
    semanticMessage = null;
    notifyListeners();
    _semanticDownload = embedder.install(token: token).listen(
      (percent) {
        semanticProgress = percent;
        notifyListeners();
      },
      onError: (Object e) {
        semanticPhase = SemanticPhase.notInstalled;
        semanticMessage = e is AssistantCancelled
            ? null
            : AppLocale.strings.svcSemanticDownloadFailed('$e');
        notifyListeners();
      },
      onDone: () {
        if (semanticPhase != SemanticPhase.downloading) return;
        semanticPhase = SemanticPhase.ready;
        notifyListeners();
        ensureIndexed(db);
      },
    );
  }

  void cancelSemantic() => embedder.cancelInstall();

  /// Index auf Stand bringen (nur geänderte Einträge); `null` ohne Modell.
  Future<SemanticIndex?> ensureIndexed(AppDatabase db) async {
    if (semanticPhase != SemanticPhase.ready &&
        semanticPhase != SemanticPhase.indexing) {
      return null;
    }
    final index = SemanticIndex(db, embedder);
    try {
      await (_indexing ??= _sync(index));
    } catch (e) {
      // Ohne aktuellen Index trotzdem antworten: nur Stichwortsuche.
      semanticMessage = AppLocale.strings.svcIndexNotUpdated('$e');
      notifyListeners();
      return null;
    } finally {
      _indexing = null;
    }
    return index;
  }

  Future<void> _sync(SemanticIndex index) async {
    semanticPhase = SemanticPhase.indexing;
    indexDone = 0;
    indexTotal = 0;
    notifyListeners();
    try {
      await index.sync(
        onProgress: (done, total) {
          indexDone = done;
          indexTotal = total;
          notifyListeners();
        },
      );
    } finally {
      semanticPhase = SemanticPhase.ready;
      notifyListeners();
    }
  }

  Future<void> deleteSemantic(AppDatabase db) async {
    await _semanticDownload?.cancel();
    await embedder.uninstall();
    await SemanticIndex(db, embedder).clear();
    semanticPhase = SemanticPhase.notInstalled;
    notifyListeners();
  }
}
