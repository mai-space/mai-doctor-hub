import 'package:pdf_text/pdf_text.dart';

Future<({String? text, int? pageCount})> extractPdfText(String path) async {
  try {
    final doc = await PDFDoc.fromPath(path);
    return (text: await doc.text, pageCount: doc.length);
  } catch (_) {
    return (text: null, pageCount: null);
  }
}
