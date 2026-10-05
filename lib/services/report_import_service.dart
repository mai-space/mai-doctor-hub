import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../data/app_database.dart';
import '../data/repositories/records_repository.dart';
import 'ocr/ocr_service.dart';
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
  ReportImportService(
    this._records, {
    Future<Directory> Function()? baseDir,
    OcrService? ocr,
  }) : _baseDir = baseDir ?? getApplicationDocumentsDirectory,
       _ocr = ocr ?? OcrService(TextRecognizerApi.current);

  final OcrService _ocr;

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
  ///
  /// Ohne Textebene (Fotos, Scans) wird der Text per On-Device-OCR
  /// erkannt — bei Scans aus den Seitenbildern [ocrImages].
  Future<ImportedReport> importFile({
    required String name,
    required Future<Uint8List> Function() readBytes,
    String? sourcePath,
    String? appointmentId,
    ReportSource? source,
    List<String> ocrImages = const [],
  }) async {
    final ext = p.extension(name).toLowerCase();
    if (!allowedReportExtensions.contains(ext.replaceFirst('.', ''))) {
      throw ReportImportException(
        'Dateityp „$ext“ wird nicht unterstützt (PDF oder Bild).',
      );
    }
    final mimeType = _mimeForExtension(ext);
    final reportSource =
        source ?? (ext == '.pdf' ? ReportSource.pdf : ReportSource.image);

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
    if (extracted == null && !kIsWeb) {
      extracted = await _recognize(
        localPath,
        isPdf: ext == '.pdf',
        images: ocrImages,
      );
    }

    try {
      final id = await _records.createReport(
        title: name,
        mimeType: mimeType,
        localPath: localPath,
        source: reportSource,
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

  /// Extrahiert den Text eines gespeicherten PDF-Berichts (erneut) und
  /// aktualisiert den Suchindex. Gibt `true` zurück, wenn Text gefunden wurde.
  Future<bool> reindex(Report report) async {
    if (kIsWeb || !await File(report.localPath).exists()) return false;
    final isPdf = report.mimeType == 'application/pdf';
    String? text;
    int? pageCount = report.pageCount;
    if (isPdf) {
      try {
        final result = await extractPdfText(report.localPath);
        text = result.text;
        pageCount = result.pageCount;
      } catch (e) {
        debugPrint('PDF-Text für ${report.id} fehlgeschlagen: $e');
      }
    }
    text ??= await _recognize(report.localPath, isPdf: isPdf);
    await _records.setReportText(report.id, text, pageCount);
    return text != null;
  }

  /// OCR als Best Effort — ohne Erkennung bleibt der Bericht trotzdem.
  Future<String?> _recognize(
    String path, {
    required bool isPdf,
    List<String> images = const [],
  }) async {
    if (!_ocr.isSupported) return null;
    try {
      if (images.isNotEmpty) return await _ocr.recognizeImages(images);
      return isPdf
          ? await _ocr.recognizePdf(path)
          : await _ocr.recognizeImages([path]);
    } catch (e) {
      debugPrint('Texterkennung fehlgeschlagen: $e');
      return null;
    }
  }

  /// Indexiert alle PDF-Berichte ohne Text (z. B. Import vor I2).
  /// Gibt die Anzahl neu indexierter Berichte zurück.
  Future<int> reindexMissing() async {
    var count = 0;
    for (final report in await _records.allReports()) {
      if (report.extractedText != null) continue;
      if (await reindex(report)) count++;
    }
    return count;
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
