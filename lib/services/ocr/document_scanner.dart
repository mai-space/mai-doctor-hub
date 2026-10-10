import 'package:flutter/services.dart';

import '../device_platform.dart';

/// Ergebnis eines Kamera-Scans: PDF + Seitenbilder (für die Texterkennung).
class ScannedDocument {
  const ScannedDocument({required this.pdfPath, required this.imagePaths});

  final String pdfPath;
  final List<String> imagePaths;
}

/// Der Scanner konnte nicht starten (z. B. Google-Play-Dienste fehlen oder
/// das Scanner-Modul wird noch geladen).
class ScannerUnavailable implements Exception {
  const ScannerUnavailable(this.message);

  final String message;

  @override
  String toString() => message;
}

abstract interface class DocumentScannerApi {
  /// Standard: ML Kit über den nativen Kanal; Tests setzen eine Attrappe.
  static DocumentScannerApi current = MlKitDocumentScanner();

  bool get isSupported;

  /// `null`, wenn abgebrochen; [ScannerUnavailable], wenn er nicht startet.
  Future<ScannedDocument?> scan();

  /// Foto mit der Kamera-App (Ersatz ohne Google-Scanner): Pfad des JPEG
  /// oder `null`, wenn abgebrochen.
  Future<String?> takePhoto();
}

/// Google ML Kit Dokumentenscanner (Android): Kantenerkennung, Zuschnitt,
/// Filter — läuft auf dem Gerät, ohne Kamera-Berechtigung der App.
/// iOS: gleicher Kanal mit VisionKit (`DocumentScannerChannel.swift`).
class MlKitDocumentScanner implements DocumentScannerApi {
  static const _channel = MethodChannel('mai/document_scanner');

  @override
  bool get isSupported => DevicePlatform.isMobile;

  @override
  Future<ScannedDocument?> scan() async {
    final Map<Object?, Object?>? result;
    try {
      result = await _channel.invokeMapMethod<Object?, Object?>('scan');
    } on PlatformException catch (e) {
      throw ScannerUnavailable(e.message ?? e.code);
    }
    if (result == null) return null;
    return ScannedDocument(
      pdfPath: result['pdf']! as String,
      imagePaths: [
        for (final path in result['images'] as List<Object?>? ?? const [])
          path! as String,
      ],
    );
  }

  @override
  Future<String?> takePhoto() async {
    try {
      return await _channel.invokeMethod<String>('takePhoto');
    } on PlatformException catch (e) {
      throw ScannerUnavailable(e.message ?? e.code);
    }
  }
}
