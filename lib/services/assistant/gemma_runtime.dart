import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_gemma_embeddings/flutter_gemma_embeddings.dart';
import 'package:flutter_gemma_litertlm/flutter_gemma_litertlm.dart';

/// Einmalige Registrierung von Sprach- und Embedding-Modell-Laufzeit.
abstract final class GemmaRuntime {
  static Future<void>? _init;

  static Future<void> ensureInitialized() => _init ??= FlutterGemma.initialize(
    inferenceEngines: [LiteRtLmEngine()],
    embeddingBackends: [LiteRtEmbeddingBackend()],
    embeddingTokenizers: [GemmaEmbeddingTokenizers()],
  );
}
