import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../data/measure_units.dart' show deviceRegion;
import '../../l10n/l10n.dart';
import '../../services/psych/psych_safety.dart';

/// v15: Ruhiges Hilfsangebot (keine Warnfarbe, kein Alarm): Krisentelefon
/// und Notruf nach Region, antippen zum Anrufen. Es wird nichts gesendet.
class SupportCard extends StatelessWidget {
  const SupportCard({super.key, this.region});

  /// Für Tests; sonst die Region des Geräts.
  final String? region;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final contacts = supportContactsFor(
      region ?? deviceRegion(),
      language: l10n.localeName,
    );
    Widget call(String label, Uri uri) => Padding(
      padding: const EdgeInsets.only(top: 6),
      child: OutlinedButton.icon(
        onPressed: () => launchUrl(uri),
        icon: const Icon(Icons.phone_outlined),
        label: Text(label),
      ),
    );
    return Card(
      key: const ValueKey('support-card'),
      elevation: 0,
      color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.6),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.favorite_outline,
                  color: theme.colorScheme.onSecondaryContainer,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n.psychSupportTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              contacts.lines.isEmpty
                  ? l10n.psychSupportGeneric
                  : l10n.psychSupportText,
            ),
            for (final line in contacts.lines)
              call(
                l10n.psychSupportCall(
                  line.hours == null
                      ? line.name
                      : '${line.name} (${line.hours})',
                  line.number,
                ),
                line.uri,
              ),
            if (contacts.emergency case final e?)
              call(l10n.psychSupportEmergency(e.number), e.uri),
            const SizedBox(height: 8),
            Text(l10n.psychSupportPrivacy, style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

/// Hilfsangebot als Dialog (nach dem Speichern eines Check-ins).
Future<void> showSupportDialog(BuildContext context) => showDialog<void>(
  context: context,
  builder: (context) => AlertDialog(
    contentPadding: const EdgeInsets.fromLTRB(12, 16, 12, 0),
    scrollable: true,
    content: const SupportCard(),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(context.l10n.commonClose),
      ),
    ],
  ),
);
