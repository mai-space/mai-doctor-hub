import 'package:flutter/material.dart';

import '../../data/database_provider.dart';
import '../../data/repositories/cycle_repository.dart';
import '../../l10n/l10n.dart';
import '../../services/cycle/cycle_text.dart';
import '../../services/cycle/mrs.dart';

/// Menopause Rating Scale: 11 Beschwerden, je „keine“ bis „sehr stark“.
class MrsPage extends StatefulWidget {
  const MrsPage({super.key});

  @override
  State<MrsPage> createState() => _MrsPageState();
}

class _MrsPageState extends State<MrsPage> {
  final List<int?> _scores = List.filled(mrsItemCount, null);

  Future<void> _save() async {
    final l10n = context.l10n;
    final repo = CycleRepository(DatabaseScope.of(context));
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final result = MrsResult([for (final s in _scores) s ?? 0]);
    await repo.addMrs(result);
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.cycleMrsSaved(mrsSummary(result, l10n)))),
    );
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final items = mrsItemLabels(l10n);
    final levels = [
      l10n.cycleMrsLevel0,
      l10n.cycleMrsLevel1,
      l10n.cycleMrsLevel2,
      l10n.cycleMrsLevel3,
      l10n.cycleMrsLevel4,
    ];
    final answered = _scores.whereType<int>().length;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.cycleMrsTitle)),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: FilledButton(
            onPressed: answered == mrsItemCount ? _save : null,
            child: Text(l10n.cycleMrsSave(answered, mrsItemCount)),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Text(l10n.cycleMrsIntro, style: theme.textTheme.bodyMedium),
          for (var i = 0; i < mrsItemCount; i++) ...[
            const SizedBox(height: 18),
            Text(
              '${i + 1}. ${items[i]}',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (var v = 0; v <= mrsMaxItem; v++)
                  ChoiceChip(
                    key: ValueKey('mrs-$i-$v'),
                    label: Text(levels[v]),
                    selected: _scores[i] == v,
                    onSelected: (_) => setState(() => _scores[i] = v),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 16),
          Text(l10n.cycleMrsSource, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
