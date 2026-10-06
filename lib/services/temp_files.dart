import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Räumt Klartext-Kopien im Cache auf: Scans und Fotos, Kopien der
/// Dateiauswahl, geteilte Dateien, Exporte und Arbeitsordner.
///
/// Die Akte selbst ist verschlüsselt — diese Kopien wären es nicht. Läuft beim
/// Start, wenn nichts davon mehr gebraucht wird.
abstract final class TempFiles {
  /// Ordner, die Plugins bzw. der Scanner im Cache anlegen.
  static const _directories = {
    'file_picker',
    'share_plus',
    'scans',
    'vault_tmp',
  };

  /// Eigene Temp-Dateien/-Ordner (siehe Backup, Export, OCR, Scanner).
  static final _names = RegExp(
    r'^(scan|photo|ocr_|backup_|import_|export_|dokumente_|mlkit|audio_|'
    r'image_picker|scaled_|REC)',
  );

  static Future<int> purge({Directory? cache}) async {
    if (kIsWeb) return 0;
    final Directory dir;
    try {
      dir = cache ?? await getTemporaryDirectory();
    } catch (_) {
      return 0;
    }
    if (!await dir.exists()) return 0;
    var removed = 0;
    await for (final entry in dir.list(followLinks: false)) {
      final name = p.basename(entry.path);
      if (!_directories.contains(name) && !_names.hasMatch(name)) continue;
      try {
        await entry.delete(recursive: true);
        removed++;
      } catch (e) {
        debugPrint('Temp nicht gelöscht: $e');
      }
    }
    return removed;
  }

  /// Löscht einzelne Dateien (z. B. Scan nach dem Import); Fehler egal.
  static Future<void> delete(Iterable<String> paths) async {
    for (final path in paths) {
      try {
        final file = File(path);
        if (await file.exists()) await file.delete();
      } catch (_) {}
    }
  }
}
