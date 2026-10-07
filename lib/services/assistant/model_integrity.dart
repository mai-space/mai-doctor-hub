import 'dart:io';
import 'dart:isolate';

import 'package:background_downloader/background_downloader.dart'
    show FileDownloader;
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter/services.dart';

/// Eine Modelldatei, festgelegt auf eine Hugging-Face-Revision und ihren
/// SHA-256 (aus der LFS-Metadatenliste des Repos). So kann weder ein
/// geändertes Repo noch ein manipulierter Download unbemerkt ein anderes
/// Modell unterschieben.
class PinnedModelFile {
  const PinnedModelFile({
    required this.repo,
    required this.revision,
    required this.fileName,
    required this.sha256,
    required this.size,
  });

  final String repo;

  /// Commit im Hugging-Face-Repo (nicht `main`).
  final String revision;
  final String fileName;
  final String sha256;
  final int size;

  String get url =>
      'https://huggingface.co/$repo/resolve/$revision/$fileName';
}

class ModelIntegrityException implements Exception {
  const ModelIntegrityException(this.fileName, this.reason);

  final String fileName;
  final String reason;

  @override
  String toString() => 'ModelIntegrityException: $fileName ($reason)';
}

/// Prüft Größe und SHA-256 einer Datei; rechnet in einem Hintergrund-Isolate
/// (Modelle sind bis zu einigen GB groß).
Future<void> verifyFile(String path, PinnedModelFile pin) async {
  final file = File(path);
  if (!await file.exists()) {
    throw ModelIntegrityException(pin.fileName, 'fehlt');
  }
  final length = await file.length();
  if (length != pin.size) {
    throw ModelIntegrityException(
      pin.fileName,
      'Größe $length statt ${pin.size}',
    );
  }
  final digest = await Isolate.run(() async {
    return (await sha256.bind(File(path).openRead()).first).toString();
  });
  if (digest != pin.sha256) {
    throw ModelIntegrityException(pin.fileName, 'Prüfsumme weicht ab');
  }
}

/// Prüft die installierten Dateien von flutter_gemma.
///
/// [installedNames]: Dateinamen laut flutter_gemma-Spezifikation. Begleit-
/// dateien liegen dort mit Präfix (`<modell>__sentencepiece.model`), damit
/// gleichnamige Tokenizer verschiedener Modelle sich nicht überschreiben.
Future<void> verifyInstalled(
  List<PinnedModelFile> pins, {
  List<String> installedNames = const [],
}) async {
  for (final pin in pins) {
    final name = installedNameFor(pin, installedNames);
    await verifyFile(await FlutterGemma.getModelPath(name), pin);
  }
}

/// Name, unter dem flutter_gemma [pin] ablegt: exakt oder mit
/// `<modell>__`-Präfix; ohne Treffer der Originalname.
@visibleForTesting
String installedNameFor(PinnedModelFile pin, List<String> installedNames) {
  for (final name in installedNames) {
    if (name == pin.fileName || name.endsWith('__${pin.fileName}')) {
      return name;
    }
  }
  return pin.fileName;
}

/// Entfernt Download-Aufträge, die einen Token enthalten, aus dem Speicher
/// des Downloaders (WorkManager-Datenbank und Einstellungen) — der Token
/// soll nach dem Download nirgends liegen bleiben.
Future<void> scrubDownloadSecret(String? secret) async {
  if (secret == null || secret.isEmpty || kIsWeb) return;
  try {
    final db = FileDownloader().database;
    final records = await db.allRecords();
    await db.deleteRecordsWithIds([
      for (final r in records)
        if (r.task.headers.values.any((v) => v.contains(secret))) r.taskId,
    ]);
  } catch (e) {
    debugPrint('Download-Verlauf nicht bereinigt: $e');
  }
  try {
    await const MethodChannel(
      'mai/device',
    ).invokeMethod<void>('scrubSecret', {'secret': secret});
  } catch (e) {
    debugPrint('Download-Daten nicht bereinigt: $e');
  }
}
