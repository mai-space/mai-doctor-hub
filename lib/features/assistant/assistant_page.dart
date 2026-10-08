import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/database_provider.dart';
import '../../l10n/l10n.dart';
import '../../services/assistant/assistant_model.dart';
import '../../services/assistant/follow_ups.dart';
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

  /// Vom Modell ergänzte Suchbegriffe (einmal pro Frage).
  List<String> expansion = const [];

  /// Erfasstes Symptom, das die Frage nennt (für feste Folgefragen).
  String? symptom;

  /// Vorschläge unter der fertigen Antwort.
  List<FollowUp> followUps = const [];

  /// Sichtbarer Antworttext ohne die Zeile mit den Folgefragen.
  String get visibleAnswer =>
      splitFollowUps(answer.toString(), streaming: !done).text.trim();
}

class _AssistantPageState extends State<AssistantPage> {
  final _model = AssistantModel.instance;
  final _input = TextEditingController();
  final _scroll = ScrollController();
  final _turns = <_Turn>[];
  StreamSubscription<String>? _answering;

  List<String> _examples(AppLocalizations l10n) => [
    l10n.svcAssistantExample1,
    l10n.svcAssistantExample2,
    l10n.svcAssistantExample3,
    l10n.svcAssistantExample4,
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
    final db = DatabaseScope.of(context);
    setState(() {
      _turns.add(turn);
      _input.clear();
    });
    _scrollToEnd();
    turn.expansion = await expandQuery(_model.engine, turn.question);
    try {
      turn.symptom = await mentionedSymptom(db, turn.question);
    } catch (_) {}
    if (!mounted) return;
    await _answer(turn, _model.engine.contextChars);
  }

  /// Die Fragen vor [turn], für Anschlussfragen.
  List<_Turn> _before(_Turn turn) => _turns.sublist(0, _turns.indexOf(turn));

  /// Bisheriges Gespräch (höchstens zwei Runden) für den Prompt.
  String _history(_Turn turn, int maxChars) => conversationHistory(
    [
      for (final t in _before(turn))
        if (t.done && t.error == null && t.visibleAnswer.isNotEmpty)
          (question: t.question, answer: t.visibleAnswer),
    ],
    maxChars,
    context.l10n,
  );

  void _finish(_Turn turn) {
    final parts = splitFollowUps(turn.answer.toString());
    turn
      ..done = true
      ..followUps = followUpsFor(
        parts.followUps,
        question: turn.question,
        l10n: context.l10n,
        symptom: turn.symptom,
      );
  }

  /// Antwortet mit einem Akte-Auszug von höchstens [maxChars] Zeichen.
  /// Bleibt die Antwort leer (Auszug passt nicht ins Kontextfenster), wird
  /// einmal mit halbem Auszug neu gefragt.
  /// Das bisherige Gespräch geht vom selben Budget ab (höchstens ein
  /// Viertel).
  Future<void> _answer(_Turn turn, int maxChars, {bool retried = false}) async {
    final db = DatabaseScope.of(context);
    final history = _history(turn, maxChars ~/ 4);
    final before = _before(turn);
    final reminder = context.l10n.assistantPromptReminder.length;
    final extract = await AssistantContextBuilder(
      db,
      maxChars: maxChars - history.length - reminder,
      semantic: await _model.ensureIndexed(db),
    ).build(
      turn.question,
      expansion: turn.expansion,
      previous: before.isEmpty ? null : before.last.question,
    );
    if (!mounted) return;
    _answering = _model.engine
        .answer(
          system: assistantSystemPrompt,
          prompt: assistantPrompt(extract, turn.question, history: history),
        )
        .listen(
          (token) {
            if (!mounted) return;
            setState(() => turn.answer.write(token));
            _scrollToEnd();
          },
          onError: (Object e) {
            if (!mounted) return;
            if (!retried && turn.answer.isEmpty) {
              _answer(turn, maxChars ~/ 2, retried: true);
              return;
            }
            setState(() {
              turn.error = '$e';
              turn.done = true;
            });
          },
          onDone: () {
            if (!mounted) return;
            if (!retried &&
                splitFollowUps(turn.answer.toString()).text.trim().isEmpty) {
              turn.answer.clear();
              _answer(turn, maxChars ~/ 2, retried: true);
              return;
            }
            setState(() => _finish(turn));
            _scrollToEnd();
          },
          cancelOnError: true,
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
        title: Text(context.l10n.svcAssistantDeleteModelQuestion),
        content: Text(
          context.l10n.svcAssistantDeleteModelBody(_model.engine.downloadSize),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.commonDelete),
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
        title: Text(context.l10n.svcAssistantTitle),
        actions: [
          if (_model.phase == AssistantPhase.ready)
            PopupMenuButton<String>(
              onSelected: (value) => value == 'semantic'
                  ? _model.deleteSemantic(DatabaseScope.of(context))
                  : _confirmDelete(),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'delete',
                  child: Text(context.l10n.svcAssistantDeleteModel),
                ),
                if (_model.semanticPhase == SemanticPhase.ready)
                  PopupMenuItem(
                    value: 'semantic',
                    child: Text(context.l10n.svcAssistantDeleteSearchModel),
                  ),
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
            title: context.l10n.svcAssistantUnsupportedTitle,
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
    final l10n = context.l10n;
    return Column(
      children: [
        Expanded(
          child: _turns.isEmpty
              ? ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text(
                      l10n.svcAssistantAskTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.svcAssistantIntro,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final q in _examples(l10n))
                          ActionChip(label: Text(q), onPressed: () => _ask(q)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _SemanticCard(model: _model),
                  ],
                )
              : ListView.builder(
                  controller: _scroll,
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  itemCount: _turns.length,
                  itemBuilder: (context, i) => _TurnView(
                    turn: _turns[i],
                    onAsk: _busy ? null : _ask,
                  ),
                ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            l10n.svcAssistantDisclaimer,
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
                  decoration: InputDecoration(
                    hintText: l10n.svcAssistantInputHint,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                tooltip: l10n.svcAssistantSend,
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
  const _TurnView({required this.turn, this.onAsk});

  final _Turn turn;

  /// Stellt eine Folgefrage; `null`, solange eine Antwort läuft.
  final ValueChanged<String>? onAsk;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final answer = turn.visibleAnswer;
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
                    context.l10n.svcAssistantNoAnswer('${turn.error}'),
                    style: TextStyle(color: theme.colorScheme.error),
                  )
                : answer.isEmpty && !turn.done
                ? Row(
                    children: [
                      const SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 12),
                      Text(context.l10n.svcAssistantReading),
                    ],
                  )
                : answer.isEmpty
                ? Text(
                    context.l10n.svcAssistantEmptyAnswer,
                    style: TextStyle(color: theme.colorScheme.error),
                  )
                : _AnswerMarkdown(answer),
          ),
          if (turn.done && turn.error == null && answer.isNotEmpty)
            _FollowUpChips(followUps: turn.followUps, onAsk: onAsk),
        ],
      ),
    );
  }
}

/// Antwort als Markdown (Fett, Überschriften, Aufzählungen) — auch schon
/// während des Streamens. Keine Bilder; Links erst nach Rückfrage.
class _AnswerMarkdown extends StatelessWidget {
  const _AnswerMarkdown(this.data);

  final String data;

  Future<void> _openLink(BuildContext context, String? href) async {
    final uri = href == null ? null : Uri.tryParse(href);
    if (uri == null || !(uri.isScheme('http') || uri.isScheme('https'))) {
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.assistantOpenLinkTitle),
        content: Text(context.l10n.assistantOpenLinkBody('$uri')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.commonCancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(context.l10n.assistantOpenLink),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = theme.textTheme;
    final bold = text.titleSmall?.copyWith(fontWeight: FontWeight.w700);
    return MarkdownBody(
      data: data,
      selectable: true,
      softLineBreak: true,
      styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
        p: text.bodyMedium,
        listBullet: text.bodyMedium,
        h1: text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        h2: bold,
        h3: bold,
        h4: bold,
        h5: bold,
        h6: bold,
        blockSpacing: 8,
        a: TextStyle(
          color: theme.colorScheme.primary,
          decoration: TextDecoration.underline,
        ),
      ),
      onTapLink: (_, href, _) => _openLink(context, href),
      imageBuilder: (_, _, alt) => Text(alt ?? ''),
    );
  }
}

/// Folgefragen in zwei Richtungen: verstehen und handeln.
class _FollowUpChips extends StatelessWidget {
  const _FollowUpChips({required this.followUps, this.onAsk});

  final List<FollowUp> followUps;
  final ValueChanged<String>? onAsk;

  @override
  Widget build(BuildContext context) {
    if (followUps.isEmpty) return const SizedBox.shrink();
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final f in followUps)
            Tooltip(
              message: f.kind == FollowUpKind.act
                  ? l10n.assistantFollowUpActTooltip
                  : l10n.assistantFollowUpUnderstandTooltip,
              child: ActionChip(
                avatar: Icon(
                  f.kind == FollowUpKind.act
                      ? Icons.checklist
                      : Icons.lightbulb_outline,
                  size: 18,
                ),
                label: Text(f.text),
                onPressed: onAsk == null ? null : () => onAsk!(f.text),
              ),
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
    final l10n = context.l10n;
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
          l10n.svcAssistantSetupTitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          l10n.svcAssistantSetupBody(
            model.engine.modelName,
            model.engine.downloadSize,
          ),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge,
        ),
        if (model.lowMemory) ...[
          const SizedBox(height: 12),
          Text(
            l10n.svcAssistantLowMemory,
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
            l10n.svcAssistantDownloading(model.progress),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: model.cancel,
            child: Text(l10n.commonCancel),
          ),
        ] else
          FilledButton.icon(
            onPressed: model.download,
            icon: const Icon(Icons.download),
            label: Text(l10n.svcAssistantDownloadModel(model.engine.downloadSize)),
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

/// Optionale semantische Suche: findet auch Berichte, in denen die Wörter
/// der Frage nicht vorkommen (z. B. „Schilddrüse“ → „TSH“).
class _SemanticCard extends StatefulWidget {
  const _SemanticCard({required this.model});

  final AssistantModel model;

  @override
  State<_SemanticCard> createState() => _SemanticCardState();
}

const _hfJoin = 'https://huggingface.co/join';
const _modelPage = 'https://huggingface.co/litert-community/embeddinggemma-300m';
const _googlePage = 'https://huggingface.co/google/embeddinggemma-300m';
const _tokenPage = 'https://huggingface.co/settings/tokens';

/// Nummerierter Schritt der Token-Anleitung mit antippbaren Links.
class _Step extends StatelessWidget {
  const _Step(this.number, this.text, this.links);

  final int number;
  final String text;
  final List<(String label, String url)> links;

  Future<void> _open(BuildContext context, String url) async {
    var opened = false;
    try {
      opened = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } catch (_) {}
    if (opened || !context.mounted) return;
    await Clipboard.setData(ClipboardData(text: url));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.svcLinkCopied(url))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 11,
            backgroundColor: theme.colorScheme.primaryContainer,
            child: Text(
              '$number',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text),
                for (final (label, url) in links)
                  Tooltip(
                    message: url,
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                      onPressed: () => _open(context, url),
                      onLongPress: () =>
                          Clipboard.setData(ClipboardData(text: url)),
                      icon: const Icon(Icons.open_in_new, size: 18),
                      label: Text(label),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SemanticCardState extends State<_SemanticCard> {
  final _token = TextEditingController();

  @override
  void dispose() {
    _token.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = widget.model;
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final body = switch (model.semanticPhase) {
      SemanticPhase.ready => <Widget>[
        Text(l10n.svcSemanticActive),
      ],
      SemanticPhase.indexing => <Widget>[
        LinearProgressIndicator(
          value: model.indexTotal == 0
              ? null
              : model.indexDone / model.indexTotal,
        ),
        const SizedBox(height: 8),
        Text(l10n.svcSemanticIndexing(model.indexDone, model.indexTotal)),
      ],
      SemanticPhase.downloading => <Widget>[
        LinearProgressIndicator(value: model.semanticProgress / 100),
        const SizedBox(height: 8),
        Text(l10n.svcSemanticDownloading(model.semanticProgress)),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: model.cancelSemantic,
          child: Text(l10n.commonCancel),
        ),
      ],
      SemanticPhase.notInstalled => <Widget>[
        Text(
          l10n.svcSemanticIntro(
            model.embedder.modelName,
            model.embedder.downloadSize,
          ),
        ),
        const SizedBox(height: 8),
        _Step(1, l10n.svcSemanticStep1, [
          (l10n.svcSemanticStep1Link, _hfJoin),
        ]),
        _Step(2, l10n.svcSemanticStep2, [
          (l10n.svcSemanticStep2Link, _modelPage),
          (l10n.svcSemanticStep2Google, _googlePage),
        ]),
        _Step(3, l10n.svcSemanticStep3, [
          (l10n.svcSemanticStep3Link, _tokenPage),
        ]),
        _Step(4, l10n.svcSemanticStep4, const []),
        if (model.semanticMessage != null) ...[
          const SizedBox(height: 8),
          Text(
            model.semanticMessage!,
            style: TextStyle(color: theme.colorScheme.error),
          ),
          const SizedBox(height: 4),
          Text(l10n.svcSemanticLicenseHint),
        ],
        const SizedBox(height: 12),
        TextField(
          controller: _token,
          obscureText: true,
          autocorrect: false,
          decoration: InputDecoration(
            labelText: l10n.svcSemanticTokenLabel,
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: _token.text.trim().isEmpty
              ? null
              : () => model.downloadSemantic(
                  DatabaseScope.of(context),
                  token: _token.text.trim(),
                ),
          icon: const Icon(Icons.download),
          label: Text(l10n.svcSemanticEnable),
        ),
      ],
    };
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.hub_outlined, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  l10n.svcSemanticTitle,
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...body,
          ],
        ),
      ),
    );
  }
}
