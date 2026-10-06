import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/database_provider.dart';
import '../../services/assistant/assistant_model.dart';
import '../../services/assistant/record_context.dart';

/// „Frag deine Akte“ — Antworten vom lokalen Modell, nichts verlässt das Gerät.
class AssistantPage extends StatefulWidget {
  const AssistantPage({super.key});

  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _Turn {
  _Turn(this.question);

  final String question;
  final answer = StringBuffer();
  bool done = false;
  String? error;
}

class _AssistantPageState extends State<AssistantPage> {
  final _model = AssistantModel.instance;
  final _input = TextEditingController();
  final _scroll = ScrollController();
  final _turns = <_Turn>[];
  StreamSubscription<String>? _answering;

  static const _examples = [
    'Wann ist mein nächster Termin?',
    'Welche Medikamente nehme ich gerade?',
    'Wie haben sich meine Symptome entwickelt?',
    'Was stand im letzten Bericht?',
  ];

  @override
  void initState() {
    super.initState();
    _model.addListener(_changed);
    _model.refresh();
  }

  @override
  void dispose() {
    _model.removeListener(_changed);
    _answering?.cancel();
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _changed() {
    if (mounted) setState(() {});
  }

  bool get _busy => _turns.isNotEmpty && !_turns.last.done;

  Future<void> _ask(String question) async {
    if (question.trim().isEmpty || _busy) return;
    final turn = _Turn(question.trim());
    setState(() {
      _turns.add(turn);
      _input.clear();
    });
    final context = await AssistantContextBuilder(
      DatabaseScope.of(this.context),
    ).build(turn.question);
    if (!mounted) return;
    _answering = _model.engine
        .answer(
          system: assistantSystemPrompt,
          prompt: assistantPrompt(context, turn.question),
        )
        .listen(
          (token) {
            if (!mounted) return;
            setState(() => turn.answer.write(token));
            _scrollToEnd();
          },
          onError: (Object e) {
            if (!mounted) return;
            setState(() {
              turn.error = '$e';
              turn.done = true;
            });
          },
          onDone: () {
            if (mounted) setState(() => turn.done = true);
          },
        );
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.jumpTo(_scroll.position.maxScrollExtent);
      }
    });
  }

  Future<void> _confirmDelete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modell löschen?'),
        content: Text(
          'Gibt ${_model.engine.downloadSize} Speicher frei. Für den '
          'Assistenten musst du es danach neu herunterladen.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await _answering?.cancel();
      setState(_turns.clear);
      await _model.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assistent'),
        actions: [
          if (_model.phase == AssistantPhase.ready)
            PopupMenuButton<String>(
              onSelected: (_) => _confirmDelete(),
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'delete', child: Text('Modell löschen')),
              ],
            ),
        ],
      ),
      body: SafeArea(
        child: switch (_model.phase) {
          AssistantPhase.checking => const Center(
            child: CircularProgressIndicator(),
          ),
          AssistantPhase.unsupported => _Info(
            icon: Icons.phonelink_erase_outlined,
            title: 'Auf diesem Gerät nicht verfügbar',
            text: _model.message ?? '',
          ),
          AssistantPhase.notInstalled ||
          AssistantPhase.downloading => _Setup(model: _model),
          AssistantPhase.ready => _chat(context),
        },
      ),
    );
  }

  Widget _chat(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Expanded(
          child: _turns.isEmpty
              ? ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text(
                      'Frag deine Akte',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Antworten entstehen auf diesem Gerät aus deinen '
                      'Einträgen und Berichten — nichts wird hochgeladen, '
                      'der Verlauf wird nicht gespeichert.',
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final q in _examples)
                          ActionChip(label: Text(q), onPressed: () => _ask(q)),
                      ],
                    ),
                  ],
                )
              : ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  itemCount: _turns.length,
                  itemBuilder: (context, i) => _TurnView(turn: _turns[i]),
                ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Keine ärztliche Beratung — Antworten können Fehler enthalten.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _input,
                  enabled: !_busy,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  onSubmitted: _ask,
                  decoration: const InputDecoration(
                    hintText: 'Frage zu deiner Akte…',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                tooltip: 'Fragen',
                onPressed: _busy ? null : () => _ask(_input.text),
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TurnView extends StatelessWidget {
  const _TurnView({required this.turn});

  final _Turn turn;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final answer = turn.answer.toString().trim();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(turn.question),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: turn.error != null
                ? Text(
                    'Keine Antwort: ${turn.error}',
                    style: TextStyle(color: theme.colorScheme.error),
                  )
                : answer.isEmpty && !turn.done
                ? const Row(
                    children: [
                      SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text('Liest deine Akte…'),
                    ],
                  )
                : SelectableText(answer),
          ),
        ],
      ),
    );
  }
}

class _Setup extends StatelessWidget {
  const _Setup({required this.model});

  final AssistantModel model;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final downloading = model.phase == AssistantPhase.downloading;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Icon(
          Icons.auto_awesome_outlined,
          size: 64,
          color: theme.colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Lokaler Assistent',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Stell Fragen zu Terminen, Medikamenten, Symptomen und Berichten. '
          'Das KI-Modell ${model.engine.modelName} läuft vollständig auf '
          'diesem Gerät — deine Akte wird nie hochgeladen. Nur das Modell '
          'selbst wird einmalig heruntergeladen (${model.engine.downloadSize}, '
          'am besten im WLAN).',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge,
        ),
        if (model.lowMemory) ...[
          const SizedBox(height: 12),
          Text(
            'Hinweis: Dieses Gerät hat wenig Arbeitsspeicher. Der Assistent '
            'kann langsam sein oder von Android beendet werden.',
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ],
        if (model.message != null) ...[
          const SizedBox(height: 12),
          Text(
            model.message!,
            textAlign: TextAlign.center,
            style: TextStyle(color: theme.colorScheme.error),
          ),
        ],
        const SizedBox(height: 24),
        if (downloading) ...[
          LinearProgressIndicator(value: model.progress / 100),
          const SizedBox(height: 8),
          Text(
            'Wird geladen… ${model.progress} % — läuft auch weiter, wenn du '
            'die App verlässt.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: model.cancel,
            child: const Text('Abbrechen'),
          ),
        ] else
          FilledButton.icon(
            onPressed: model.download,
            icon: const Icon(Icons.download),
            label: Text('Modell herunterladen (${model.engine.downloadSize})'),
          ),
      ],
    );
  }
}

class _Info extends StatelessWidget {
  const _Info({required this.icon, required this.title, required this.text});

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56, color: theme.colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(text, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
