import 'dart:async';

import 'package:flutter/foundation.dart';

import 'assistant_engine.dart';

enum AssistantPhase { checking, unsupported, notInstalled, downloading, ready }

/// Zustand des lokalen Modells — lebt außerhalb der Seite, damit ein
/// laufender Download beim Verlassen weiterläuft und sichtbar bleibt.
class AssistantModel extends ChangeNotifier {
  AssistantModel(this.engine);

  static AssistantModel? _instance;
  static AssistantModel get instance =>
      _instance ??= AssistantModel(AssistantEngine.current);

  @visibleForTesting
  static void reset() => _instance = null;

  final AssistantEngine engine;

  AssistantPhase phase = AssistantPhase.checking;
  int progress = 0;
  bool lowMemory = false;

  /// Grund für „nicht unterstützt“ oder letzte Fehlermeldung.
  String? message;

  StreamSubscription<int>? _download;

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
            : 'Download fehlgeschlagen: $e';
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
}
