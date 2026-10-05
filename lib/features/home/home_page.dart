import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../../widgets/empty_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: CustomScrollView(
        reverse: false,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Mai Doctor Hub',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Deine Termine — lokal auf diesem Gerät',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.muted,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Termin anlegen folgt mit der Persistenz-Schicht',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Termin hinzufügen'),
                  ),
                ],
              ),
            ),
          ),
          const EmptyState(
            icon: Icons.event_available_outlined,
            title: 'Noch keine Termine',
            message:
                'Lege deinen ersten Termin an — danach erscheinen hier '
                'nächste Termine nach unten und vergangene nach oben.',
            actionLabel: 'Ersten Termin anlegen',
          ),
        ],
      ),
    );
  }
}
