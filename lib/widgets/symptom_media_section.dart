import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/app_database.dart';
import '../data/database_provider.dart';
import '../data/repositories/symptom_media_repository.dart';
import '../features/symptoms/media_viewer_page.dart';
import '../l10n/l10n.dart';
import '../services/device_platform.dart';
import '../services/file_vault.dart';
import '../services/media/media_capture.dart';

/// Belege zu einem Symptom: Fotos, Videos, Sprachnotizen (verschlüsselt).
class SymptomMediaSection extends StatelessWidget {
  const SymptomMediaSection({
    super.key,
    required this.symptomId,
    this.observationId,
  });

  final String symptomId;

  /// Optional: Beleg gehört zu diesem Check-in.
  final String? observationId;

  @override
  Widget build(BuildContext context) {
    final db = DatabaseScope.of(context);
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return StreamBuilder<List<SymptomMediaItem>>(
      stream: SymptomMediaRepository(db).watchForSymptom(symptomId),
      builder: (context, snapshot) {
        final items = snapshot.data ?? const <SymptomMediaItem>[];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.perm_media_outlined, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.mediaSectionTitle,
                    style: theme.textTheme.titleMedium,
                  ),
                ),
                if (items.isNotEmpty)
                  Text(
                    l10n.mediaCount(items.length),
                    style: theme.textTheme.bodySmall,
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(l10n.mediaSectionHint, style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                ActionChip(
                  avatar: const Icon(Icons.photo_camera_outlined),
                  label: Text(l10n.mediaTakePhoto),
                  onPressed: () => _capture(context, MediaKind.photo, true),
                ),
                ActionChip(
                  avatar: const Icon(Icons.videocam_outlined),
                  label: Text(l10n.mediaRecordVideo),
                  onPressed: () => _capture(context, MediaKind.video, true),
                ),
                ActionChip(
                  avatar: const Icon(Icons.mic_none),
                  label: Text(l10n.mediaRecordAudio),
                  onPressed: () => _recordAudio(context),
                ),
                ActionChip(
                  avatar: const Icon(Icons.photo_library_outlined),
                  label: Text(l10n.mediaFromGallery),
                  onPressed: () => _fromGallery(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (items.isEmpty)
              Text(l10n.mediaEmpty, style: theme.textTheme.bodySmall)
            else
              SizedBox(
                height: 104,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, i) => MediaThumbnail(
                    item: items[i],
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => MediaViewerPage(item: items[i]),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _fromGallery(BuildContext context) async {
    final l10n = context.l10n;
    final kind = await showModalBottomSheet<MediaKind>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.image_outlined),
              title: Text(l10n.mediaGalleryPhoto),
              onTap: () => Navigator.pop(context, MediaKind.photo),
            ),
            ListTile(
              leading: const Icon(Icons.video_library_outlined),
              title: Text(l10n.mediaGalleryVideo),
              onTap: () => Navigator.pop(context, MediaKind.video),
            ),
          ],
        ),
      ),
    );
    if (kind == null || !context.mounted) return;
    await _capture(context, kind, false);
  }

  Future<void> _capture(
    BuildContext context,
    MediaKind kind,
    bool camera,
  ) async {
    final CapturedMedia? captured;
    try {
      captured = await MediaCapture.current.pick(kind, camera: camera);
    } catch (e) {
      if (context.mounted) _showError(context, e);
      return;
    }
    if (captured == null || !context.mounted) return;
    await _save(context, captured);
  }

  Future<void> _recordAudio(BuildContext context) async {
    final captured = await showModalBottomSheet<CapturedMedia>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      showDragHandle: true,
      builder: (_) => const AudioRecorderSheet(),
    );
    if (captured == null || !context.mounted) return;
    await _save(context, captured);
  }

  Future<void> _save(BuildContext context, CapturedMedia captured) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = context.l10n;
    final repo = SymptomMediaRepository(DatabaseScope.of(context));
    messenger.showSnackBar(SnackBar(content: Text(l10n.mediaSaving)));
    try {
      await repo.add(
        symptomId: symptomId,
        observationId: observationId,
        captured: captured,
      );
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(l10n.mediaSaved)));
    } catch (e) {
      messenger.hideCurrentSnackBar();
      if (context.mounted) _showError(context, e);
    }
  }

  void _showError(BuildContext context, Object e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.mediaFailed('$e'))),
    );
  }
}

/// Startseite „Erfassen“: Beleg direkt aufnehmen — dieselben Abläufe wie
/// die Knöpfe in [SymptomMediaSection], nur ohne Detailseite.
Future<void> showSymptomMediaCapture(
  BuildContext context, {
  required String symptomId,
  required String title,
}) async {
  final section = SymptomMediaSection(symptomId: symptomId);
  final l10n = context.l10n;
  final choice = await showModalBottomSheet<int>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
          for (final (i, icon, label) in [
            (0, Icons.photo_camera_outlined, l10n.mediaTakePhoto),
            (1, Icons.videocam_outlined, l10n.mediaRecordVideo),
            (2, Icons.mic_none, l10n.mediaRecordAudio),
            (3, Icons.photo_library_outlined, l10n.mediaFromGallery),
          ])
            ListTile(
              leading: Icon(icon),
              title: Text(label),
              onTap: () => Navigator.pop(context, i),
            ),
        ],
      ),
    ),
  );
  if (choice == null || !context.mounted) return;
  await switch (choice) {
    0 => section._capture(context, MediaKind.photo, true),
    1 => section._capture(context, MediaKind.video, true),
    2 => section._recordAudio(context),
    _ => section._fromGallery(context),
  };
}

/// Vorschau: Fotos entschlüsselt im Speicher, Video/Audio als Symbol.
class MediaThumbnail extends StatefulWidget {
  const MediaThumbnail({super.key, required this.item, this.onTap});

  final SymptomMediaItem item;
  final VoidCallback? onTap;

  @override
  State<MediaThumbnail> createState() => _MediaThumbnailState();
}

class _MediaThumbnailState extends State<MediaThumbnail> {
  Future<Uint8List>? _bytes;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    if (item.kind == MediaKind.photo &&
        !kIsWeb &&
        File(item.localPath).existsSync()) {
      _bytes = FileVault.current.readBytes(item.localPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final item = widget.item;
    final date = DateFormat(l10n.mediaDatePattern).format(item.recordedAt);
    final label = switch (item.kind) {
      MediaKind.photo => l10n.mediaPhoto,
      MediaKind.video => l10n.mediaVideo,
      MediaKind.audio => l10n.mediaAudio,
    };
    final duration = item.durationMs == null
        ? null
        : formatMediaDuration(Duration(milliseconds: item.durationMs!));
    final Widget placeholder = Container(
      color: theme.colorScheme.surfaceContainerHighest,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            switch (item.kind) {
              MediaKind.photo => Icons.image_outlined,
              MediaKind.video => Icons.play_circle_outline,
              MediaKind.audio => Icons.graphic_eq,
            },
            size: 32,
          ),
          if (duration != null) Text(duration, style: theme.textTheme.labelSmall),
        ],
      ),
    );
    final bytes = _bytes;
    final content = bytes == null
        ? placeholder
        : FutureBuilder<Uint8List>(
            future: bytes,
            builder: (context, snap) => snap.hasData
                ? Image.memory(snap.data!, fit: BoxFit.cover, cacheWidth: 300)
                : placeholder,
          );
    return Semantics(
      button: true,
      label: '$label, $date',
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(width: 104, height: 104, child: content),
        ),
      ),
    );
  }
}

String formatMediaDuration(Duration d) {
  final m = d.inMinutes;
  final s = d.inSeconds % 60;
  return '$m:${s.toString().padLeft(2, '0')}';
}

/// Aufnahme-Sheet für Sprachnotizen: Pegel, Zeit, Stopp/Abbrechen.
class AudioRecorderSheet extends StatefulWidget {
  const AudioRecorderSheet({super.key});

  @override
  State<AudioRecorderSheet> createState() => _AudioRecorderSheetState();
}

class _AudioRecorderSheetState extends State<AudioRecorderSheet> {
  final _started = DateTime.now();
  Timer? _ticker;
  StreamSubscription<double>? _levels;
  double _level = 0;
  bool? _recording;
  bool _stopping = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    final capture = MediaCapture.current;
    bool ok;
    try {
      ok = await capture.startAudio();
    } catch (_) {
      ok = false;
    }
    if (!mounted) {
      if (ok) await capture.cancelAudio();
      return;
    }
    setState(() => _recording = ok);
    if (!ok) return;
    _ticker = Timer.periodic(
      const Duration(milliseconds: 250),
      (_) => setState(() {}),
    );
    _levels = capture.audioLevel.listen((v) => setState(() => _level = v));
  }

  @override
  void dispose() {
    _ticker?.cancel();
    _levels?.cancel();
    super.dispose();
  }

  Future<void> _stop() async {
    setState(() => _stopping = true);
    final captured = await MediaCapture.current.stopAudio();
    if (mounted) Navigator.pop(context, captured);
  }

  Future<void> _cancel() async {
    if (_recording == true) await MediaCapture.current.cancelAudio();
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final elapsed = DateTime.now().difference(_started);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.mediaRecordingTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            if (_recording == false)
              Text(
                DevicePlatform.isIOS
                    ? l10n.mediaMicDeniedIos
                    : l10n.mediaMicDenied,
                style: TextStyle(color: theme.colorScheme.error),
              )
            else ...[
              Text(l10n.mediaRecordingHint),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  formatMediaDuration(elapsed),
                  style: theme.textTheme.displaySmall,
                ),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(value: _recording == true ? _level : null),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _stopping ? null : _cancel,
                    child: Text(l10n.commonCancel),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _recording == true && !_stopping ? _stop : null,
                    icon: const Icon(Icons.stop),
                    label: Text(l10n.mediaRecordingStop),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
