import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_gemma/flutter_gemma.dart';

import '../../l10n/l10n.dart';
import 'assistant_engine.dart' show AssistantCancelled;
import 'gemma_runtime.dart';
import 'model_integrity.dart';

/// Lokales Embedding-Modell für die semantische Suche.
abstract interface class RecordEmbedder {
  /// Standard: EmbeddingGemma; Tests setzen eine Attrappe.
  static RecordEmbedder current = GemmaRecordEmbedder();

  /// Kennung des Modells; ändert sie sich, wird neu indexiert.
  String get modelId;

  String get modelName;

  String get downloadSize;

  Future<bool> isInstalled();

  /// Lädt Modell + Tokenizer; [token] = Hugging-Face-Token (Gemma-Lizenz).
  Stream<int> install({String? token});

  void cancelInstall();

  Future<void> uninstall();

  /// Ein normierter Vektor je Text.
  Future<List<Float32List>> embed(List<String> texts, {required bool query});
}

class GemmaRecordEmbedder implements RecordEmbedder {
  /// Feste Revision + SHA-256 (nicht `main`): siehe [PinnedModelFile].
  static const _revision = '29888fcee3216acadc7e844906e5fe0d79a61875';
  static const modelFile = PinnedModelFile(
    repo: 'litert-community/embeddinggemma-300m',
    revision: _revision,
    fileName: 'embeddinggemma-300M_seq512_mixed-precision.tflite',
    sha256: 'ad09e81557203cb0e177abf9bf8727dfe138a7d394aa0f70f0b2ed16432e121a',
    size: 179132472,
  );
  static const tokenizerFile = PinnedModelFile(
    repo: 'litert-community/embeddinggemma-300m',
    revision: _revision,
    fileName: 'sentencepiece.model',
    sha256: 'd6daa52d93d7aad10e8388bd526c4e501d914b47177398d1d9621f1fe48438c7',
    size: 4683319,
  );
  static final _modelUrl = modelFile.url;
  static final _tokenizerUrl = tokenizerFile.url;

  /// Gleiche Spezifikation wie bei der Installation — liefert die Namen, unter
  /// denen flutter_gemma die Dateien ablegt.
  static final _spec = EmbeddingModelSpec(
    name: 'embeddinggemma-300M_seq512_mixed-precision',
    modelSource: ModelSource.network(_modelUrl),
    tokenizerSource: ModelSource.network(_tokenizerUrl),
  );

  CancelToken? _cancel;
  EmbeddingModel? _model;

  @override
  String get modelId => 'embeddinggemma-300m-seq512';

  @override
  String get modelName => 'EmbeddingGemma';

  @override
  String get downloadSize => AppLocale.strings.svcEmbedderModelSize;

  EmbeddingInstallationBuilder _builder({String? token}) =>
      FlutterGemma.installEmbedder()
          .modelFromNetwork(_modelUrl, token: token)
          .tokenizerFromNetwork(_tokenizerUrl, token: token);

  @override
  Future<bool> isInstalled() async {
    await GemmaRuntime.ensureInitialized();
    for (final file in _spec.files) {
      if (!await FlutterGemma.isModelInstalled(file.filename)) return false;
    }
    return true;
  }

  @override
  Stream<int> install({String? token}) {
    final controller = StreamController<int>();
    final cancel = _cancel = CancelToken();
    () async {
      try {
        await GemmaRuntime.ensureInitialized();
        await _builder(token: token)
            .withModelProgress(controller.add)
            .withCancelToken(cancel)
            .install();
        try {
          await verifyInstalled(
            [modelFile, tokenizerFile],
            installedNames: [for (final f in _spec.files) f.filename],
          );
        } on ModelIntegrityException {
          await FlutterGemma.uninstallEmbedder();
          rethrow;
        }
        await controller.close();
      } catch (e, s) {
        controller.addError(
          CancelToken.isCancel(e) ? const AssistantCancelled() : e,
          s,
        );
        await controller.close();
      } finally {
        if (identical(_cancel, cancel)) _cancel = null;
        await scrubDownloadSecret(token);
      }
    }();
    return controller.stream;
  }

  @override
  void cancelInstall() => _cancel?.cancel('Vom Nutzer abgebrochen');

  @override
  Future<void> uninstall() async {
    await GemmaRuntime.ensureInitialized();
    await _model?.close();
    _model = null;
    await FlutterGemma.uninstallEmbedder();
  }

  Future<EmbeddingModel> _load() async {
    final loaded = _model;
    if (loaded != null) return loaded;
    await GemmaRuntime.ensureInitialized();
    // Aktiviert das bereits geladene Modell (kein erneuter Download).
    await _builder().install();
    return _model = await FlutterGemma.getActiveEmbedder();
  }

  @override
  Future<List<Float32List>> embed(
    List<String> texts, {
    required bool query,
  }) async {
    final model = await _load();
    final vectors = await model.generateEmbeddings(
      texts,
      taskType: query ? TaskType.retrievalQuery : TaskType.retrievalDocument,
    );
    return [for (final v in vectors) normalize(v)];
  }
}

/// Auf Länge 1 normiert: Kosinus-Ähnlichkeit = Skalarprodukt.
Float32List normalize(List<double> vector) {
  var sum = 0.0;
  for (final x in vector) {
    sum += x * x;
  }
  final out = Float32List(vector.length);
  if (sum == 0) return out;
  final inv = 1 / math.sqrt(sum);
  for (var i = 0; i < vector.length; i++) {
    out[i] = vector[i] * inv;
  }
  return out;
}
