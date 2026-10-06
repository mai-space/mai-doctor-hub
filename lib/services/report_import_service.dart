import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../data/app_database.dart';
import '../data/repositories/records_repository.dart';
import '../l10n/l10n.dart';
import 'file_vault.dart';
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

/// Eine gewählte Datei: lokaler Pfad bevorzugt, sonst Bytes.
typedef PickedReportFile = ({
  String name,
  String? path,
  Future<Uint8List> Function() readBytes,
});

/// Ergebnis einer Mehrfachauswahl.
class BulkImportResult {
  final imported = <ImportedReport>[];

  /// Dateiname → Fehlermeldung.
  final failed = <String, String>{};

  bool get isEmpty => imported.isEmpty && failed.isEmpty;
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
    Future<Directory> Function()? tempDir,
    OcrService? ocr,
  }) : _baseDir = baseDir ?? getApplicationDocumentsDirectory,
       _tempDir = tempDir ?? _cacheDir,
       _ocr = ocr ?? OcrService(TextRecognizerApi.current);

  final OcrService _ocr;

  final RecordsRepository _records;
  final Future<Directory> Function() _baseDir;

  /// Für kurzlebige Klartext-Kopien (Texterkennung); `TempFiles` räumt auf.
  final Future<Directory> Function() _tempDir;

  static Future<Directory> _cacheDir() async {
    try {
      return await getTemporaryDirectory();
    } catch (_) {
      return Directory.systemTemp; // ohne Plugin (Tests, Desktop)
    }
  }

  /// Wählt eine oder mehrere Dateien und legt jede als Bericht ab.
  /// Einzelne Fehler brechen den Rest nicht ab.
  Future<BulkImportResult> pickAndImport({String? appointmentId}) async {
    final List<PlatformFile> files;
    try {
      files = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedReportExtensions,
      );
    } catch (e) {
      throw ReportImportException(AppLocale.strings.svcImportPickFailed, e);
    }
    try {
      return await importAll([
        for (final file in files)
          (
            name: file.name,
            path: kIsWeb ? null : file.path,
            readBytes: file.readAsBytes,
          ),
      ], appointmentId: appointmentId);
    } finally {
      // Android kopiert die Auswahl unverschlüsselt in den Cache.
      if (!kIsWeb && files.isNotEmpty) {
        await FilePicker.clearTemporaryFiles().catchError((Object _) {});
      }
    }
  }

  /// Legt mehrere Dateien nacheinander ab (je Datei nur eine im Speicher).
  Future<BulkImportResult> importAll(
    List<PickedReportFile> files, {
    String? appointmentId,
  }) async {
    final result = BulkImportResult();
    for (final file in files) {
      try {
        result.imported.add(
          await importFile(
            name: file.name,
            sourcePath: file.path,
            readBytes: file.readBytes,
            appointmentId: appointmentId,
          ),
        );
      } on ReportImportException catch (e) {
        debugPrint('$e');
        result.failed[file.name] = e.message;
      }
    }
    return result;
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
        AppLocale.strings.svcImportUnsupportedType(ext),
      );
    }
    final mimeType = _mimeForExtension(ext);
    final reportSource =
        source ?? (ext == '.pdf' ? ReportSource.pdf : ReportSource.image);

    // Text aus dem Klartext lesen, bevor die Datei verschlüsselt abgelegt
    // wird; ohne lokalen Pfad (SAF-URI) über eine Kopie im Cache.
    String? plainPath = kIsWeb ? null : sourcePath;
    File? staged;
    if (!kIsWeb &&
        (plainPath == null ||
            plainPath.isEmpty ||
            !await File(plainPath).exists())) {
      plainPath = null;
      try {
        staged = await _stage(name, await readBytes());
        plainPath = staged.path;
      } catch (e) {
        // Ohne Kopie kein Volltext; abgelegt wird trotzdem (aus den Bytes).
        debugPrint('Keine Arbeitskopie für Texterkennung: $e');
      }
    }

    String? extracted;
    int? pageCount;
    final String localPath;
    try {
      if (ext == '.pdf' && plainPath != null) {
        try {
          final result = await extractPdfText(plainPath);
          extracted = result.text;
          pageCount = result.pageCount;
        } catch (_) {
          // Best effort: Bericht bleibt ohne Volltext gespeichert.
        }
      }
      if (extracted == null && plainPath != null) {
        extracted = await _recognize(
          plainPath,
          isPdf: ext == '.pdf',
          images: ocrImages,
        );
      }
      try {
        localPath = await _persistFile(name, plainPath, readBytes);
      } catch (e) {
        throw ReportImportException(AppLocale.strings.svcImportFileNotSaved, e);
      }
    } finally {
      if (staged != null) await _deleteQuietly(staged.path);
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
        AppLocale.strings.svcImportReportNotSaved,
        e,
      );
    }
  }

  /// Extrahiert den Text eines gespeicherten PDF-Berichts (erneut) und
  /// aktualisiert den Suchindex. Gibt `true` zurück, wenn Text gefunden wurde.
  Future<bool> reindex(Report report) async {
    if (kIsWeb || !await File(report.localPath).exists()) return false;
    final isPdf = report.mimeType == 'application/pdf';
    // Verschlüsselte Datei: Klartext nur kurz im Cache für PDFium/OCR.
    final plain = File(
      p.join(
        (await _tempDir()).path,
        'import_${DateTime.now().microsecondsSinceEpoch}'
        '${p.extension(report.localPath)}',
      ),
    );
    await FileVault.current.decryptTo(report.localPath, plain.path);
    String? text;
    int? pageCount = report.pageCount;
    try {
      if (isPdf) {
        try {
          final result = await extractPdfText(plain.path);
          text = result.text;
          pageCount = result.pageCount;
        } catch (e) {
          debugPrint('PDF-Text für ${report.id} fehlgeschlagen: $e');
        }
      }
      text ??= await _recognize(plain.path, isPdf: isPdf);
    } finally {
      await _deleteQuietly(plain.path);
    }
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

    final dir = await reportsDirectory(_baseDir);
    await dir.create(recursive: true);
    final safeName =
        '${DateTime.now().millisecondsSinceEpoch}_'
        '${name.replaceAll(RegExp(r'[^\w.\-]+'), '_')}';
    final targetPath = p.join(dir.path, safeName);

    // Auf dem Gerät nur verschlüsselt (siehe FileVault).
    if (sourcePath != null &&
        sourcePath.isNotEmpty &&
        await File(sourcePath).exists()) {
      await FileVault.current.encryptFile(sourcePath, targetPath);
    } else {
      await FileVault.current.writeBytes(targetPath, await readBytes());
    }
    return targetPath;
  }

  /// Klartext-Kopie im Cache (für Text/OCR), danach gelöscht.
  Future<File> _stage(String name, Uint8List bytes) async {
    final dir = await _tempDir();
    final file = File(
      p.join(
        dir.path,
        'import_${DateTime.now().microsecondsSinceEpoch}'
        '${p.extension(name).toLowerCase()}',
      ),
    );
    return file.writeAsBytes(bytes, flush: true);
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
