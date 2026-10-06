import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../data/app_database.dart';
import '../l10n/l10n.dart';

/// Ergebnis eines Dokument-Exports.
class DocumentExport {
  const DocumentExport({required this.file, required this.count});

  /// Unverschlüsseltes ZIP im Temp-Ordner — nach dem Teilen löschen.
  final File file;
  final int count;
}

/// Exportiert alle (nicht archivierten) Berichte und Scans als ZIP mit
/// lesbaren Dateinamen, z. B. `2026-03-01_Dr. Nord_Arztbrief.pdf`, plus
/// `Übersicht.csv`. Dateien werden einzeln gestreamt.
///
/// Anders als die Sicherung ist das Archiv **nicht verschlüsselt** — für die
/// Weitergabe an Ärzte oder die eigene Ablage.
class DocumentExportService {
  DocumentExportService(this._db, {Future<Directory> Function()? tempDir})
    : _tempDir = tempDir ?? getTemporaryDirectory;

  final AppDatabase _db;
  final Future<Directory> Function() _tempDir;

  static String suggestedFileName(DateTime now) =>
      AppLocale.strings.svcExportFileName(
        DateFormat('yyyy-MM-dd').format(now),
      );

  Future<DocumentExport?> export() async {
    final reports = await _db.selectActive(_db.reports).get();
    final appointments = {
      for (final a in await _db.select(_db.appointments).get()) a.id: a,
    };
    final doctors = {
      for (final d in await _db.select(_db.doctors).get()) d.id: d.name,
    };

    final rows = <_Row>[];
    for (final report in reports) {
      if (report.localPath.startsWith('web-memory://') ||
          !await File(report.localPath).exists()) {
        continue;
      }
      final appointment = appointments[report.appointmentId];
      rows.add(
        _Row(
          report,
          date: appointment?.scheduledAt ?? report.createdAt,
          doctor: doctors[appointment?.doctorId],
          appointment: appointment?.title,
        ),
      );
    }
    if (rows.isEmpty) return null;
    rows.sort((a, b) => a.date.compareTo(b.date));

    final out = File(
      p.join(
        (await _tempDir()).path,
        'dokumente_${DateTime.now().microsecondsSinceEpoch}.zip',
      ),
    );
    final encoder = ZipFileEncoder()..create(out.path);
    try {
      final used = <String>{};
      final l10n = AppLocale.strings;
      final csv = StringBuffer('${l10n.svcExportCsvHeader}\r\n');
      final day = DateFormat('yyyy-MM-dd');
      for (final row in rows) {
        final name = _unique(_fileNameFor(row), used);
        // PDFs/Bilder sind schon komprimiert → nur speichern.
        await encoder.addFile(
          File(row.report.localPath),
          name,
          ZipFileEncoder.store,
        );
        csv.write(
          [
            day.format(row.date),
            row.report.title,
            row.doctor ?? '',
            row.appointment ?? '',
            _sourceLabel(row.report.source),
            row.report.pageCount?.toString() ?? '',
            name,
          ].map(_csvCell).join(';'),
        );
        csv.write('\r\n');
      }
      // BOM, damit Excel die Umlaute erkennt.
      encoder.addArchiveFile(
        ArchiveFile.string(l10n.svcExportOverviewFile, '﻿$csv'),
      );
    } finally {
      await encoder.close();
    }
    return DocumentExport(file: out, count: rows.length);
  }

  static String _fileNameFor(_Row row) {
    final parts = [
      DateFormat('yyyy-MM-dd').format(row.date),
      if (row.doctor != null) row.doctor!,
      row.report.title,
    ];
    var base = parts.map(_safe).where((s) => s.isNotEmpty).join('_');
    if (base.length > 100) base = base.substring(0, 100).trim();
    var ext = p.extension(row.report.localPath).toLowerCase();
    if (ext.isEmpty) {
      ext = row.report.mimeType == 'application/pdf' ? '.pdf' : '';
    }
    return '$base$ext';
  }

  /// Ohne Zeichen, die Dateisysteme oder ZIP-Pfade stören.
  static String _safe(String text) => text
      .replaceAll(RegExp(r'[\\/:*?"<>|\x00-\x1F]'), '-')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim()
      .replaceAll(RegExp(r'^\.+'), '');

  static String _unique(String name, Set<String> used) {
    var candidate = name;
    final ext = p.extension(name);
    final stem = name.substring(0, name.length - ext.length);
    for (var i = 2; !used.add(candidate.toLowerCase()); i++) {
      candidate = '$stem ($i)$ext';
    }
    return candidate;
  }

  static String _csvCell(String value) {
    // Formel-Injection in Tabellenprogrammen verhindern.
    final safe = RegExp(r'^[=+\-@\t\r]').hasMatch(value) ? "'$value" : value;
    if (!safe.contains(RegExp('[;"\r\n]'))) return safe;
    return '"${safe.replaceAll('"', '""')}"';
  }

  static String _sourceLabel(ReportSource source) => switch (source) {
    ReportSource.pdf => 'PDF',
    ReportSource.image => AppLocale.strings.svcExportSourceImage,
    ReportSource.scan => 'Scan',
  };
}

class _Row {
  _Row(this.report, {required this.date, this.doctor, this.appointment});

  final Report report;
  final DateTime date;
  final String? doctor;
  final String? appointment;
}
