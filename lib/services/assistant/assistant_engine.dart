import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemma/flutter_gemma.dart';

import '../../l10n/l10n.dart';
import '../device_platform.dart';
import 'gemma_runtime.dart';
import 'model_integrity.dart';

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

  /// Höchstlänge des Akte-Auszugs in Zeichen, so dass Systemanweisung,
  /// Auszug, Frage und Antwort ins Kontextfenster passen.
  int get contextChars;

  /// Streamt die Antwort Token für Token.
  Stream<String> answer({required String system, required String prompt});

  /// Kurze, sachliche Vervollständigung (z. B. Suchbegriffe), ganz.
  Future<String> complete({
    required String system,
    required String prompt,
    int maxTokens = 64,
  });
}

class AssistantCancelled implements Exception {
  const AssistantCancelled();
}

/// iOS: Gemma (~2,5 GB) braucht ein 64-Bit-Gerät mit mindestens 6 GB
/// Arbeitsspeicher (iOS meldet etwas weniger, daher 5 GiB als Grenze);
/// unter ~8 GB gilt das Gerät als knapp.
@visibleForTesting
AssistantSupport iosAssistantSupport(Map<Object?, Object?>? info) {
  const gib = 1024 * 1024 * 1024;
  if (info?['arm64'] != true) {
    return AssistantUnsupported(AppLocale.strings.svcAssistantNeedsArm64);
  }
  final ram = info?['totalRam'] as int? ?? 0;
  if (ram < 5 * gib) {
    return AssistantUnsupported(AppLocale.strings.svcAssistantNeedsMoreMemory);
  }
  return AssistantSupported(lowMemory: ram < 7 * gib);
}

class GemmaAssistantEngine implements AssistantEngine {
  /// Feste Revision + SHA-256 (nicht `main`): siehe [PinnedModelFile].
  static const modelFile = PinnedModelFile(
    repo: 'litert-community/gemma-4-E2B-it-litert-lm',
    revision: 'b3ca0d2f076785a8f4b2219ddbd2bdb99954eae1',
    fileName: 'gemma-4-E2B-it.litertlm',
    sha256: '181938105e0eefd105961417e8da75903eacda102c4fce9ce90f50b97139a63c',
    size: 2588147712,
  );
  static final _url = modelFile.url;
  static final _modelId = modelFile.fileName;
  static const _device = MethodChannel('mai/device');

  /// Antwortlänge in Tokens.
  static const answerTokens = 768;

  bool _initialized = false;
  int _totalRam = 0;

  /// Kontextfenster: Systemanweisung + Akte-Auszug + Frage + Antwort. Mehr
  /// Kontext braucht mehr Arbeitsspeicher (KV-Cache).
  int get contextTokens => _totalRam >= 7.5 * 1024 * 1024 * 1024 ? 8192 : 4096;

  // Deutsch mit Daten/Zahlen: grob 2–3 Zeichen pro Token — vorsichtig
  // rechnen, sonst läuft das Fenster über und die Antwort bleibt leer.
  // 900 Tokens Reserve: Systemanweisung (mit Antwortstruktur) + Frage.
  @override
  int get contextChars => ((contextTokens - answerTokens - 900) * 2.2).floor();
  CancelToken? _cancel;
  InferenceModel? _model;

  @override
  String get modelName => 'Gemma 4 E2B';

  @override
  String get downloadSize => AppLocale.strings.svcAssistantModelSize;

  Future<void> _init() async {
    if (_initialized) return;
    await GemmaRuntime.ensureInitialized();
    _initialized = true;
  }

  InferenceInstallationBuilder _builder() => FlutterGemma.installModel(
    modelType: ModelType.gemma4,
    fileType: ModelFileType.litertlm,
  ).fromNetwork(_url, foreground: true);

  @override
  Future<AssistantSupport> support() async {
    if (!DevicePlatform.isMobile) {
      return AssistantUnsupported(AppLocale.strings.svcAssistantMobileOnly);
    }
    final Map<Object?, Object?>? info;
    try {
      info = await _device.invokeMapMethod<Object?, Object?>('localAi');
    } on PlatformException catch (e) {
      return AssistantUnsupported(
        AppLocale.strings.svcAssistantDeviceCheckFailed('${e.message}'),
      );
    }
    if (DevicePlatform.isIOS) {
      final support = iosAssistantSupport(info);
      if (support is AssistantSupported) {
        _totalRam = info?['totalRam'] as int? ?? 0;
      }
      return support;
    }
    final sdk = info?['sdk'] as int? ?? 0;
    if (sdk < 30) {
      return AssistantUnsupported(AppLocale.strings.svcAssistantNeedsAndroid11);
    }
    if (info?['arm64'] != true) {
      return AssistantUnsupported(AppLocale.strings.svcAssistantNeedsArm64);
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
        try {
          await verifyInstalled([modelFile]);
        } on ModelIntegrityException {
          await FlutterGemma.uninstallModel(_modelId);
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
      maxOutputTokens: answerTokens,
    );
    try {
      await session.addQueryChunk(Message(text: prompt, isUser: true));
      yield* session.getResponseAsync();
    } finally {
      await session.close();
    }
  }

  @override
  Future<String> complete({
    required String system,
    required String prompt,
    int maxTokens = 64,
  }) async {
    final model = await _load();
    final session = await model.createSession(
      systemInstruction: system,
      temperature: 0.2,
      topK: 40,
      maxOutputTokens: maxTokens,
    );
    try {
      await session.addQueryChunk(Message(text: prompt, isUser: true));
      return await session.getResponse();
    } finally {
      await session.close();
    }
  }
}
