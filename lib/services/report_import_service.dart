import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../data/app_database.dart';
import '../data/repositories/records_repository.dart';
import 'pdf_extractor.dart';

class ImportedReport {
  const ImportedReport({
    required this.reportId,
    required this.title,
    this.extractedText,
  });

  final String reportId;
  final String title;
  final String? extractedText;
}

/// Wählt eine Datei, speichert sie lokal und indexiert PDF-Text in FTS.
class ReportImportService {
  ReportImportService(this._records);

  final RecordsRepository _records;

  Future<ImportedReport?> pickAndImport({String? appointmentId}) async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'png', 'jpg', 'jpeg', 'webp'],
    );
    if (files.isEmpty) return null;

    final file = files.first;
    final name = file.name;
    final rawExt = file.extension ?? p.extension(name).replaceFirst('.', '');
    final ext = '.${rawExt.toLowerCase()}';
    final mimeType = _mimeForExtension(ext);
    final source = ext == '.pdf' ? ReportSource.pdf : ReportSource.image;

    final localPath = await _persistFile(file, name);
    String? extracted;
    int? pageCount;

    if (ext == '.pdf' && !kIsWeb && !localPath.startsWith('web')) {
      final result = await extractPdfText(localPath);
      extracted = result.text;
      pageCount = result.pageCount;
    }

    final id = await _records.createReport(
      title: name,
      mimeType: mimeType,
      localPath: localPath,
      source: source,
      appointmentId: appointmentId,
      extractedText: extracted,
      pageCount: pageCount,
    );

    return ImportedReport(
      reportId: id,
      title: name,
      extractedText: extracted,
    );
  }

  Future<String> _persistFile(PlatformFile file, String name) async {
    if (kIsWeb) {
      final bytes = await file.readAsBytes();
      return 'web-memory://$name#${bytes.length}';
    }

    final dir = await getApplicationDocumentsDirectory();
    final safeName =
        '${DateTime.now().millisecondsSinceEpoch}_'
        '${name.replaceAll(RegExp(r'[^\w.\-]+'), '_')}';
    final targetPath = p.join(dir.path, 'reports', safeName);
    await file.xFile.saveTo(targetPath);
    return targetPath;
  }

  String _mimeForExtension(String ext) => switch (ext) {
    '.pdf' => 'application/pdf',
    '.png' => 'image/png',
    '.jpg' || '.jpeg' => 'image/jpeg',
    '.webp' => 'image/webp',
    _ => 'application/octet-stream',
  };
}
