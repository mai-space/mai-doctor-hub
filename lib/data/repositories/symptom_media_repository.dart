import 'dart:io';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../services/file_vault.dart';
import '../../services/media/media_capture.dart';
import '../app_database.dart';

const _uuid = Uuid();

/// `<appDocs>/media` — Fotos, Videos und Sprachnotizen zu Symptomen.
Future<Directory> mediaDirectory([
  Future<Directory> Function()? baseDir,
]) async {
  final base = await (baseDir ?? getApplicationDocumentsDirectory)();
  return Directory(p.join(base.path, 'media'));
}

/// Belege (Foto/Video/Audio) zu Symptomen — verschlüsselt auf dem Gerät.
class SymptomMediaRepository {
  SymptomMediaRepository(this._db, {Future<Directory> Function()? baseDir})
    : _baseDir = baseDir; // ignore: prefer_initializing_formals

  final AppDatabase _db;
  final Future<Directory> Function()? _baseDir;

  Stream<List<SymptomMediaItem>> watchForSymptom(String symptomId) =>
      (_db.select(_db.symptomMedia)
            ..where((t) => t.symptomId.equals(symptomId))
            ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)]))
          .watch();

  Future<List<SymptomMediaItem>> forSymptom(String symptomId) =>
      (_db.select(_db.symptomMedia)
            ..where((t) => t.symptomId.equals(symptomId))
            ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)]))
          .get();

  Future<List<SymptomMediaItem>> all() => _db.select(_db.symptomMedia).get();

  /// Legt [captured] verschlüsselt ab und löscht die Klartext-Datei.
  Future<String> add({
    required String symptomId,
    required CapturedMedia captured,
    String? observationId,
    String? note,
    DateTime? recordedAt,
  }) async {
    final dir = await mediaDirectory(_baseDir);
    await dir.create(recursive: true);
    final id = _uuid.v4();
    final ext = p.extension(captured.path).toLowerCase();
    final target = p.join(dir.path, '$id$ext');
    try {
      await FileVault.current.encryptFile(captured.path, target);
      await _db
          .into(_db.symptomMedia)
          .insert(
            SymptomMediaCompanion.insert(
              id: id,
              symptomId: symptomId,
              observationId: Value(observationId),
              kind: captured.kind,
              mimeType: captured.mimeType,
              localPath: target,
              durationMs: Value(captured.durationMs),
              note: Value(note?.trim().isEmpty == true ? null : note?.trim()),
              recordedAt: recordedAt ?? DateTime.now(),
            ),
          );
    } catch (_) {
      await _deleteQuietly(target);
      rethrow;
    } finally {
      await _deleteQuietly(captured.path);
    }
    return id;
  }

  Future<void> updateNote(String id, String? note) =>
      (_db.update(_db.symptomMedia)..where((t) => t.id.equals(id))).write(
        SymptomMediaCompanion(
          note: Value(note?.trim().isEmpty == true ? null : note?.trim()),
        ),
      );

  Future<void> delete(SymptomMediaItem item) async {
    await (_db.delete(_db.symptomMedia)..where((t) => t.id.equals(item.id)))
        .go();
    await deleteMediaFile(item.localPath, baseDir: _baseDir);
  }

  /// Alle Belege eines Symptoms (z. B. beim endgültigen Löschen).
  Future<void> deleteForSymptom(String symptomId) async {
    for (final item in await forSymptom(symptomId)) {
      await delete(item);
    }
  }

  Future<void> _deleteQuietly(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) await file.delete();
    } catch (_) {}
  }
}

/// Löscht nur Dateien im eigenen Medienordner (Pfad kann aus einer
/// fremden Sicherung stammen).
Future<void> deleteMediaFile(
  String path, {
  Future<Directory> Function()? baseDir,
}) async {
  if (kIsWeb || path.isEmpty) return;
  try {
    final dir = await (await mediaDirectory(baseDir)).resolveSymbolicLinks();
    final file = File(path);
    if (!await file.exists()) return;
    final resolved = await file.resolveSymbolicLinks();
    if (!p.isWithin(dir, resolved)) return;
    await File(resolved).delete();
  } catch (e) {
    debugPrint('Beleg nicht gelöscht: $e');
  }
}
