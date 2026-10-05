import 'dart:io';

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

/// Fehler beim Ablegen eines Berichts — Nachricht ist für die UI gedacht.
class ReportImportException implements Exception {
  const ReportImportException(this.message, [this.cause]);

  final String message;
  final Object? cause;

  @override
  String toString() => 'ReportImportException: $message ($cause)';
}

const allowedReportExtensions = ['pdf', 'png', 'jpg', 'jpeg', 'webp'];

/// Wählt eine Datei, speichert sie lokal und indexiert PDF-Text in FTS.
class ReportImportService {
  ReportImportService(this._records, {Future<Directory> Function()? baseDir})
    : _baseDir = baseDir ?? getApplicationDocumentsDirectory;

  final RecordsRepository _records;
  final Future<Directory> Function() _baseDir;

  Future<ImportedReport?> pickAndImport({String? appointmentId}) async {
    final List<PlatformFile> files;
    try {
      files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedReportExtensions,
      );
    } catch (e) {
      throw ReportImportException('Dateiauswahl fehlgeschlagen', e);
    }
    if (files.isEmpty) return null;

    final file = files.first;
    return importFile(
      name: file.name,
      sourcePath: kIsWeb ? null : file.path,
      readBytes: file.readAsBytes,
      appointmentId: appointmentId,
    );
  }

  /// Legt eine bereits gewählte Datei als Bericht ab.
  ///
  /// [sourcePath] wird bevorzugt kopiert; ohne lokalen Pfad (Web, SAF-URI)
  /// werden die Bytes über [readBytes] geschrieben.
  Future<ImportedReport> importFile({
    required String name,
    required Future<Uint8List> Function() readBytes,
    String? sourcePath,
    String? appointmentId,
  }) async {
    final ext = p.extension(name).toLowerCase();
    if (!allowedReportExtensions.contains(ext.replaceFirst('.', ''))) {
      throw ReportImportException(
        'Dateityp „$ext“ wird nicht unterstützt (PDF oder Bild).',
      );
    }
    final mimeType = _mimeForExtension(ext);
    final source = ext == '.pdf' ? ReportSource.pdf : ReportSource.image;

    final String localPath;
    try {
      localPath = await _persistFile(name, sourcePath, readBytes);
    } catch (e) {
      throw ReportImportException(
        'Datei konnte nicht lokal gespeichert werden.',
        e,
      );
    }

    String? extracted;
    int? pageCount;
    if (ext == '.pdf' && !kIsWeb) {
      try {
        final result = await extractPdfText(localPath);
        extracted = result.text;
        pageCount = result.pageCount;
      } catch (_) {
        // Best effort: Bericht bleibt ohne Volltext gespeichert.
      }
    }

    try {
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
    } catch (e) {
      await _deleteQuietly(localPath);
      throw ReportImportException(
        'Bericht konnte nicht gespeichert werden.',
        e,
      );
    }
  }

  Future<String> _persistFile(
    String name,
    String? sourcePath,
    Future<Uint8List> Function() readBytes,
  ) async {
    if (kIsWeb) {
      final bytes = await readBytes();
      return 'web-memory://$name#${bytes.length}';
    }

    final dir = Directory(p.join((await _baseDir()).path, 'reports'));
    await dir.create(recursive: true);
    final safeName =
        '${DateTime.now().millisecondsSinceEpoch}_'
        '${name.replaceAll(RegExp(r'[^\w.\-]+'), '_')}';
    final targetPath = p.join(dir.path, safeName);

    if (sourcePath != null &&
        sourcePath.isNotEmpty &&
        await File(sourcePath).exists()) {
      await File(sourcePath).copy(targetPath);
    } else {
      await File(targetPath).writeAsBytes(await readBytes(), flush: true);
    }
    return targetPath;
  }

  Future<void> _deleteQuietly(String path) async {
    if (kIsWeb) return;
    try {
      await File(path).delete();
    } catch (_) {}
  }

  String _mimeForExtension(String ext) => switch (ext) {
    '.pdf' => 'application/pdf',
    '.png' => 'image/png',
    '.jpg' || '.jpeg' => 'image/jpeg',
    '.webp' => 'image/webp',
    _ => 'application/octet-stream',
  };
}
