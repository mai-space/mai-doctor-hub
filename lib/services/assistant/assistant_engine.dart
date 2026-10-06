import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_gemma_litertlm/flutter_gemma_litertlm.dart';

/// Kann dieses Gerät das lokale Modell ausführen?
sealed class AssistantSupport {
  const AssistantSupport();
}

class AssistantSupported extends AssistantSupport {
  const AssistantSupported({this.lowMemory = false});

  /// Unter ~6 GB RAM: läuft, aber langsam oder wird ggf. beendet.
  final bool lowMemory;
}

class AssistantUnsupported extends AssistantSupport {
  const AssistantUnsupported(this.reason);

  final String reason;
}

/// Lokales Sprachmodell: herunterladen, löschen, Fragen beantworten.
abstract interface class AssistantEngine {
  /// Standard: Gemma 4 E2B über LiteRT-LM; Tests setzen eine Attrappe.
  static AssistantEngine current = GemmaAssistantEngine();

  String get modelName;

  /// Ungefähre Downloadgröße für die Anzeige.
  String get downloadSize;

  Future<AssistantSupport> support();

  Future<bool> isInstalled();

  /// Lädt das Modell; meldet Fortschritt in Prozent. Abbrechen mit
  /// [cancelInstall] beendet den Stream mit [AssistantCancelled].
  Stream<int> install();

  void cancelInstall();

  Future<void> uninstall();

  /// Streamt die Antwort Token für Token.
  Stream<String> answer({required String system, required String prompt});
}

class AssistantCancelled implements Exception {
  const AssistantCancelled();
}

class GemmaAssistantEngine implements AssistantEngine {
  static const _url =
      'https://huggingface.co/litert-community/gemma-4-E2B-it-litert-lm/'
      'resolve/main/gemma-4-E2B-it.litertlm';
  static const _modelId = 'gemma-4-E2B-it.litertlm';
  static const _device = MethodChannel('mai/device');

  /// Kontextfenster: Akte-Auszug + Frage + Antwort.
  static const contextTokens = 4096;

  bool _initialized = false;
  int _totalRam = 0;
  CancelToken? _cancel;
  InferenceModel? _model;

  @override
  String get modelName => 'Gemma 4 E2B';

  @override
  String get downloadSize => 'ca. 2,6 GB';

  Future<void> _init() async {
    if (_initialized) return;
    await FlutterGemma.initialize(inferenceEngines: [LiteRtLmEngine()]);
    _initialized = true;
  }

  InferenceInstallationBuilder _builder() => FlutterGemma.installModel(
    modelType: ModelType.gemma4,
    fileType: ModelFileType.litertlm,
  ).fromNetwork(_url, foreground: true);

  @override
  Future<AssistantSupport> support() async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      return const AssistantUnsupported('Der Assistent läuft nur auf Android.');
    }
    final Map<Object?, Object?>? info;
    try {
      info = await _device.invokeMapMethod<Object?, Object?>('localAi');
    } on PlatformException catch (e) {
      return AssistantUnsupported('Gerät nicht prüfbar: ${e.message}');
    }
    final sdk = info?['sdk'] as int? ?? 0;
    if (sdk < 30) {
      return const AssistantUnsupported(
        'Der lokale Assistent braucht mindestens Android 11.',
      );
    }
    if (info?['arm64'] != true) {
      return const AssistantUnsupported(
        'Der lokale Assistent braucht einen 64-Bit-ARM-Prozessor.',
      );
    }
    final ram = _totalRam = info?['totalRam'] as int? ?? 0;
    return AssistantSupported(lowMemory: ram < 5.5 * 1024 * 1024 * 1024);
  }

  @override
  Future<bool> isInstalled() async {
    await _init();
    return FlutterGemma.isModelInstalled(_modelId);
  }

  @override
  Stream<int> install() {
    final controller = StreamController<int>();
    final cancel = _cancel = CancelToken();
    () async {
      try {
        await _init();
        await _builder()
            .withProgress(controller.add)
            .withCancelToken(cancel)
            .install();
        await controller.close();
      } catch (e, s) {
        controller.addError(
          CancelToken.isCancel(e) ? const AssistantCancelled() : e,
          s,
        );
        await controller.close();
      } finally {
        if (identical(_cancel, cancel)) _cancel = null;
      }
    }();
    return controller.stream;
  }

  @override
  void cancelInstall() => _cancel?.cancel('Vom Nutzer abgebrochen');

  @override
  Future<void> uninstall() async {
    await _init();
    await _model?.close();
    _model = null;
    if (await FlutterGemma.isModelInstalled(_modelId)) {
      await FlutterGemma.uninstallModel(_modelId);
    }
  }

  Future<InferenceModel> _load() async {
    final loaded = _model;
    if (loaded != null) return loaded;
    await _init();
    // Setzt das (bereits geladene) Modell aktiv — ohne erneuten Download.
    await _builder().install();
    return _model = await FlutterGemma.getActiveModel(
      maxTokens: contextTokens,
      // Volle Genauigkeit überträgt Daten/Dosierungen zuverlässig (LiteRT-LM
      // #3012), braucht aber mehr Speicher — erst ab ~8 GB RAM.
      activationDataType: _totalRam >= 7.5 * 1024 * 1024 * 1024
          ? ActivationDataType.float32
          : null,
    );
  }

  @override
  Stream<String> answer({
    required String system,
    required String prompt,
  }) async* {
    final model = await _load();
    final session = await model.createSession(
      systemInstruction: system,
      temperature: 0.3,
      topK: 40,
      maxOutputTokens: 768,
    );
    try {
      await session.addQueryChunk(Message(text: prompt, isUser: true));
      yield* session.getResponseAsync();
    } finally {
      await session.close();
    }
  }
}
