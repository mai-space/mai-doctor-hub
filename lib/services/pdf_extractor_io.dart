import 'package:pdfrx/pdfrx.dart';

/// Obergrenze, damit sehr große Scans die App nicht blockieren.
const maxExtractPages = 300;

/// Extrahiert den Text aller Seiten (PDFium via pdfrx).
///
/// Gescannte PDFs ohne Textebene liefern `text: null` — OCR folgt separat.
/// Setzt voraus, dass pdfrx initialisiert ist (`pdfrxFlutterInitialize()` in
/// `main`, in Tests `pdfrxInitialize()`).
Future<({String? text, int? pageCount})> extractPdfText(String path) async {
  final document = await PdfDocument.openFile(path);
  try {
    final buffer = StringBuffer();
    final pages = document.pages.take(maxExtractPages);
    for (final page in pages) {
      final text = await page.loadText();
      final content = text?.fullText.trim() ?? '';
      if (content.isEmpty) continue;
      if (buffer.isNotEmpty) buffer.write('\n\n');
      buffer.write(content);
    }
    final text = buffer.toString();
    return (
      text: text.trim().isEmpty ? null : text,
      pageCount: document.pages.length,
    );
  } finally {
    await document.dispose();
  }
}
