import 'package:flutter/foundation.dart';
import 'package:google_mlkit_document_scanner/google_mlkit_document_scanner.dart';

/// Ergebnis eines Kamera-Scans: PDF + Seitenbilder (für die Texterkennung).
class ScannedDocument {
  const ScannedDocument({required this.pdfPath, required this.imagePaths});

  final String pdfPath;
  final List<String> imagePaths;
}

abstract interface class DocumentScannerApi {
  /// Standard: ML Kit; Tests setzen eine Attrappe.
  static DocumentScannerApi current = MlKitDocumentScanner();

  bool get isSupported;

  /// `null`, wenn abgebrochen.
  Future<ScannedDocument?> scan();
}

/// Google ML Kit Dokumentenscanner (Android): Kantenerkennung, Zuschnitt,
/// Filter — läuft auf dem Gerät, ohne Kamera-Berechtigung der App.
class MlKitDocumentScanner implements DocumentScannerApi {
  @override
  bool get isSupported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  @override
  Future<ScannedDocument?> scan() async {
    final scanner = DocumentScanner(
      options: DocumentScannerOptions(
        documentFormats: {DocumentFormat.pdf, DocumentFormat.jpeg},
        mode: ScannerMode.full,
        pageLimit: 20,
        isGalleryImport: true,
      ),
    );
    try {
      final result = await scanner.scanDocument();
      final pdf = result.pdf;
      if (pdf == null) return null;
      return ScannedDocument(
        pdfPath: _path(pdf.uri),
        imagePaths: [for (final uri in result.images ?? const <String>[]) _path(uri)],
      );
    } on Exception catch (e) {
      // Abbruch durch den Nutzer kommt als Fehler zurück.
      debugPrint('Scan abgebrochen/fehlgeschlagen: $e');
      return null;
    } finally {
      await scanner.close();
    }
  }

  static String _path(String uri) =>
      uri.startsWith('file:') ? Uri.parse(uri).toFilePath() : uri;
}
