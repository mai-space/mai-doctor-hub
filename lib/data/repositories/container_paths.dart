import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;

import '../app_database.dart';

/// iOS vergibt dem App-Container (`…/Data/Application/<UUID>/`) nach
/// Updates oder einer Geräte-Wiederherstellung einen neuen Pfad. Die Akte
/// speichert absolute Dateipfade — diese zeigen dann ins Leere.
final _containerDocuments = RegExp(
  r'/Data/Application/[0-9A-Fa-f-]+/Documents/(.+)$',
);

/// Neuer Pfad unter [documentsDir], wenn [stored] in einem (früheren)
/// iOS-Container lag; sonst `null` (unverändert lassen).
String? relocatedContainerPath(String stored, String documentsDir) {
  if (stored.isEmpty || p.isWithin(documentsDir, stored)) return null;
  final match = _containerDocuments.firstMatch(stored);
  if (match == null) return null;
  final relative = match.group(1)!;
  // Nur in den eigenen Ordnern (reports/, media/) — keine „..“-Tricks.
  if (p.split(relative).contains('..')) return null;
  return p.join(documentsDir, relative);
}

/// Biegt Berichts- und Belegpfade auf den aktuellen Container um (nur iOS
/// aufrufen). Gibt die Anzahl geänderter Einträge zurück.
Future<int> relocateContainerPaths(
  AppDatabase db, {
  required String documentsDir,
}) async {
  var changed = 0;
  await db.transaction(() async {
    for (final report in await db.select(db.reports).get()) {
      final moved = relocatedContainerPath(report.localPath, documentsDir);
      if (moved == null) continue;
      await (db.update(db.reports)..where((t) => t.id.equals(report.id))).write(
        ReportsCompanion(localPath: Value(moved)),
      );
      changed++;
    }
    for (final item in await db.select(db.symptomMedia).get()) {
      final moved = relocatedContainerPath(item.localPath, documentsDir);
      if (moved == null) continue;
      await (db.update(db.symptomMedia)..where((t) => t.id.equals(item.id)))
          .write(SymptomMediaCompanion(localPath: Value(moved)));
      changed++;
    }
  });
  return changed;
}
