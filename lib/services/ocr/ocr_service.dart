import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:pdfrx/pdfrx.dart';

/// Texterkennung auf einem Bild — austauschbar für Tests.
abstract interface class TextRecognizerApi {
  /// Standard: ML Kit; Tests setzen eine Attrappe.
  static TextRecognizerApi current = MlKitTextRecognizer();

  bool get isSupported;
  Future<String?> recognizeFile(String imagePath);
  Future<void> close();
}

/// On-Device-Texterkennung mit ML Kit (lateinische Schrift, offline;
/// es werden keine Bilder hochgeladen).
class MlKitTextRecognizer implements TextRecognizerApi {
  TextRecognizer? _recognizer;

  @override
  bool get isSupported =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.android ||
          defaultTargetPlatform == TargetPlatform.iOS);

  @override
  Future<String?> recognizeFile(String imagePath) async {
    if (!isSupported) return null;
    final recognizer = _recognizer ??= TextRecognizer(
      script: TextRecognitionScript.latin,
    );
    final result = await recognizer.processImage(
      InputImage.fromFilePath(imagePath),
    );
    final text = result.text.trim();
    return text.isEmpty ? null : text;
  }

  @override
  Future<void> close() async {
    await _recognizer?.close();
    _recognizer = null;
  }
}

/// Text aus Fotos, Scans und PDFs ohne Textebene.
class OcrService {
  OcrService(this._recognizer, {Future<Directory> Function()? tempDir})
    : _tempDir = tempDir ?? (() async => Directory.systemTemp);

  final TextRecognizerApi _recognizer;
  final Future<Directory> Function() _tempDir;

  /// Obergrenze für Seiten (OCR ist langsam).
  static const maxPages = 20;

  /// Auflösung für die Erkennung: lange Kante in Pixeln.
  static const renderSize = 2200;

  bool get isSupported => _recognizer.isSupported;

  Future<String?> recognizeImages(List<String> paths) async {
    if (!isSupported) return null;
    final parts = <String>[];
    for (final path in paths.take(maxPages)) {
      final text = await _recognizer.recognizeFile(path);
      if (text != null) parts.add(text);
    }
    return parts.isEmpty ? null : parts.join('\n\n');
  }

  /// Rendert die Seiten eines PDFs und erkennt deren Text.
  Future<String?> recognizePdf(String pdfPath) async {
    if (!isSupported) return null;
    final work = await (await _tempDir()).createTemp('ocr_');
    final document = await PdfDocument.openFile(pdfPath);
    try {
      final images = <String>[];
      for (final page in document.pages.take(maxPages)) {
        final scale = renderSize / (page.width > page.height ? page.width : page.height);
        final rendered = await page.render(
          fullWidth: page.width * scale,
          fullHeight: page.height * scale,
          backgroundColor: 0xffffffff,
        );
        if (rendered == null) continue;
        try {
          final image = img.Image.fromBytes(
            width: rendered.width,
            height: rendered.height,
            bytes: rendered.pixels.buffer,
            numChannels: 4,
            order: img.ChannelOrder.bgra,
          );
          final file = File(p.join(work.path, 'page_${page.pageNumber}.png'));
          await file.writeAsBytes(img.encodePng(image));
          images.add(file.path);
        } finally {
          rendered.dispose();
        }
      }
      return await recognizeImages(images);
    } finally {
      await document.dispose();
      await work.delete(recursive: true);
    }
  }
}
