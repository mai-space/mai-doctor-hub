import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../data/app_database.dart' show MediaKind;

export '../../data/app_database.dart' show MediaKind;

/// Aufgenommene Datei (Klartext im Cache) — wird danach verschlüsselt
/// abgelegt und die Klartext-Datei gelöscht.
class CapturedMedia {
  const CapturedMedia({
    required this.path,
    required this.kind,
    required this.mimeType,
    this.durationMs,
  });

  final String path;
  final MediaKind kind;
  final String mimeType;
  final int? durationMs;
}

/// Kamera, Galerie und Mikrofon — austauschbar für Tests.
abstract interface class MediaCapture {
  static MediaCapture current = DeviceMediaCapture();

  /// Foto oder Video, von der Kamera oder aus der Galerie.
  Future<CapturedMedia?> pick(MediaKind kind, {required bool camera});

  /// Startet eine Sprachaufnahme; `false` ohne Mikrofon-Berechtigung.
  Future<bool> startAudio();

  /// Beendet die Aufnahme und liefert die Datei.
  Future<CapturedMedia?> stopAudio();

  Future<void> cancelAudio();

  /// Pegel 0…1 für die Anzeige während der Aufnahme.
  Stream<double> get audioLevel;
}

class DeviceMediaCapture implements MediaCapture {
  final _picker = ImagePicker();
  AudioRecorder? _recorder;
  String? _audioPath;
  DateTime? _audioStart;

  @override
  Future<CapturedMedia?> pick(MediaKind kind, {required bool camera}) async {
    final source = camera ? ImageSource.camera : ImageSource.gallery;
    final XFile? file = switch (kind) {
      // Fotos verkleinern: Belege, keine Kunstwerke — spart Platz und Zeit.
      MediaKind.photo => await _picker.pickImage(
        source: source,
        maxWidth: 2560,
        maxHeight: 2560,
        imageQuality: 85,
      ),
      MediaKind.video => await _picker.pickVideo(
        source: source,
        maxDuration: const Duration(minutes: 3),
      ),
      MediaKind.audio => null,
    };
    if (file == null) return null;
    final ext = p.extension(file.path).toLowerCase();
    return CapturedMedia(
      path: file.path,
      kind: kind,
      mimeType: file.mimeType ?? mimeFor(kind, ext),
    );
  }

  @override
  Future<bool> startAudio() async {
    final recorder = _recorder ??= AudioRecorder();
    if (!await recorder.hasPermission()) return false;
    final dir = await getTemporaryDirectory();
    final path = p.join(
      dir.path,
      'audio_${DateTime.now().microsecondsSinceEpoch}.m4a',
    );
    await recorder.start(
      const RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 96000),
      path: path,
    );
    _audioPath = path;
    _audioStart = DateTime.now();
    return true;
  }

  @override
  Future<CapturedMedia?> stopAudio() async {
    final path = await _recorder?.stop() ?? _audioPath;
    final started = _audioStart;
    _audioPath = null;
    _audioStart = null;
    if (path == null || !await File(path).exists()) return null;
    return CapturedMedia(
      path: path,
      kind: MediaKind.audio,
      mimeType: 'audio/mp4',
      durationMs: started == null
          ? null
          : DateTime.now().difference(started).inMilliseconds,
    );
  }

  @override
  Future<void> cancelAudio() async {
    await _recorder?.cancel();
    _audioPath = null;
    _audioStart = null;
  }

  @override
  Stream<double> get audioLevel {
    final recorder = _recorder;
    if (recorder == null) return const Stream.empty();
    return recorder
        .onAmplitudeChanged(const Duration(milliseconds: 120))
        // dBFS (−60…0) → 0…1
        .map((a) => ((a.current + 60) / 60).clamp(0.0, 1.0).toDouble());
  }
}

/// MIME-Typ aus der Endung, falls das Plugin keinen liefert.
@visibleForTesting
String mimeFor(MediaKind kind, String ext) => switch ((kind, ext)) {
  (_, '.jpg' || '.jpeg') => 'image/jpeg',
  (_, '.png') => 'image/png',
  (_, '.heic') => 'image/heic',
  (_, '.webp') => 'image/webp',
  (_, '.mp4') => 'video/mp4',
  (_, '.mov') => 'video/quicktime',
  (_, '.3gp') => 'video/3gpp',
  (_, '.webm') => 'video/webm',
  (_, '.m4a' || '.aac') => 'audio/mp4',
  (MediaKind.photo, _) => 'image/jpeg',
  (MediaKind.video, _) => 'video/mp4',
  (MediaKind.audio, _) => 'audio/mp4',
};
