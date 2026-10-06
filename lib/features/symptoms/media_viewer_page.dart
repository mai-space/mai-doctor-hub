import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/symptom_media_repository.dart';
import '../../l10n/l10n.dart';
import '../../services/file_vault.dart';
import '../../widgets/symptom_media_section.dart' show formatMediaDuration;

/// Zeigt bzw. spielt einen Beleg ab. Fotos werden im Speicher entschlüsselt;
/// Video/Audio brauchen eine Datei — Klartext-Kopie im Cache, die beim
/// Schließen gelöscht wird (Reste räumt `TempFiles.purge` ab).
class MediaViewerPage extends StatefulWidget {
  const MediaViewerPage({super.key, required this.item});

  final SymptomMediaItem item;

  @override
  State<MediaViewerPage> createState() => _MediaViewerPageState();
}

class _MediaViewerPageState extends State<MediaViewerPage> {
  late final TextEditingController _note = TextEditingController(
    text: widget.item.note,
  );
  Future<Object>? _source;
  File? _plain;
  VideoPlayerController? _video;
  AudioPlayer? _audio;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    if (!File(item.localPath).existsSync()) return;
    _source = switch (item.kind) {
      MediaKind.photo => FileVault.current.readBytes(item.localPath),
      MediaKind.video => _prepareVideo(),
      MediaKind.audio => _prepareAudio(),
    };
  }

  Future<Object> _prepareVideo() async {
    final plain = _plain = await FileVault.current.decryptToTemp(
      widget.item.localPath,
    );
    final controller = _video = VideoPlayerController.file(plain);
    await controller.initialize();
    await controller.setLooping(false);
    return controller;
  }

  Future<Object> _prepareAudio() async {
    final plain = _plain = await FileVault.current.decryptToTemp(
      widget.item.localPath,
    );
    final player = _audio = AudioPlayer();
    await player.setSource(DeviceFileSource(plain.path));
    return player;
  }

  @override
  void dispose() {
    _video?.dispose();
    _audio?.dispose();
    _note.dispose();
    final plain = _plain;
    if (plain != null) plain.delete().ignore();
    super.dispose();
  }

  Future<void> _delete() async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.mediaDeleteTitle),
        content: Text(l10n.mediaDeleteText),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    await SymptomMediaRepository(DatabaseScope.of(context)).delete(widget.item);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final item = widget.item;
    final title = switch (item.kind) {
      MediaKind.photo => l10n.mediaPhoto,
      MediaKind.video => l10n.mediaVideo,
      MediaKind.audio => l10n.mediaAudio,
    };
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: l10n.commonDelete,
            icon: const Icon(Icons.delete_outline),
            onPressed: _delete,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(DateFormat(l10n.mediaDatePattern).format(item.recordedAt)),
          const SizedBox(height: 12),
          _body(context),
          const SizedBox(height: 16),
          TextField(
            controller: _note,
            minLines: 1,
            maxLines: 4,
            decoration: InputDecoration(labelText: l10n.mediaNoteLabel),
            onChanged: (v) => SymptomMediaRepository(
              DatabaseScope.of(context),
            ).updateNote(item.id, v),
          ),
        ],
      ),
    );
  }

  Widget _body(BuildContext context) {
    final source = _source;
    if (source == null) return Text(context.l10n.mediaUnavailable);
    return FutureBuilder<Object>(
      future: source,
      builder: (context, snap) {
        if (snap.hasError) return Text(context.l10n.mediaUnavailable);
        final data = snap.data;
        if (data == null) {
          return const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        return switch (data) {
          final Uint8List bytes => InteractiveViewer(
            maxScale: 6,
            child: Image.memory(bytes),
          ),
          final VideoPlayerController video => _VideoView(controller: video),
          final AudioPlayer audio => _AudioView(player: audio),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}

class _VideoView extends StatefulWidget {
  const _VideoView({required this.controller});

  final VideoPlayerController controller;

  @override
  State<_VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<_VideoView> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_update);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_update);
    super.dispose();
  }

  void _update() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.controller;
    final value = c.value;
    return Column(
      children: [
        AspectRatio(
          aspectRatio: value.aspectRatio == 0 ? 16 / 9 : value.aspectRatio,
          child: VideoPlayer(c),
        ),
        VideoProgressIndicator(c, allowScrubbing: true),
        Row(
          children: [
            IconButton(
              icon: Icon(value.isPlaying ? Icons.pause : Icons.play_arrow),
              onPressed: () => value.isPlaying ? c.pause() : c.play(),
            ),
            Text(
              '${formatMediaDuration(value.position)} / '
              '${formatMediaDuration(value.duration)}',
            ),
          ],
        ),
      ],
    );
  }
}

class _AudioView extends StatefulWidget {
  const _AudioView({required this.player});

  final AudioPlayer player;

  @override
  State<_AudioView> createState() => _AudioViewState();
}

class _AudioViewState extends State<_AudioView> {
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  PlayerState _state = PlayerState.stopped;

  @override
  void initState() {
    super.initState();
    final p = widget.player;
    p.onPositionChanged.listen((d) => mounted ? setState(() => _position = d) : null);
    p.onDurationChanged.listen((d) => mounted ? setState(() => _duration = d) : null);
    p.onPlayerStateChanged.listen((s) => mounted ? setState(() => _state = s) : null);
    p.getDuration().then((d) {
      if (d != null && mounted) setState(() => _duration = d);
    });
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.player;
    final playing = _state == PlayerState.playing;
    final max = _duration.inMilliseconds.toDouble();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            IconButton.filled(
              icon: Icon(playing ? Icons.pause : Icons.play_arrow),
              onPressed: () => playing ? p.pause() : p.resume(),
            ),
            Expanded(
              child: Slider(
                value: _position.inMilliseconds
                    .clamp(0, max <= 0 ? 0 : max)
                    .toDouble(),
                max: max <= 0 ? 1 : max,
                onChanged: max <= 0
                    ? null
                    : (v) => p.seek(Duration(milliseconds: v.round())),
              ),
            ),
            Text(formatMediaDuration(_duration)),
          ],
        ),
      ),
    );
  }
}
