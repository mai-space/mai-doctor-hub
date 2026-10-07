import 'package:flutter/material.dart';

import '../../data/symptom_measure.dart';
import '../../l10n/l10n.dart';

/// v16: Antwort auf den Hinweis beim Wechsel der Messgröße.
enum MeasureChange {
  /// Neue Messgröße, alte Werte bleiben wie sie sind (eigener Abschnitt).
  keep,

  /// Zusätzlich alte Werte umrechnen (nur wenn physikalisch identisch).
  convert,
}

/// Fragt nach, wenn nach dem Wechsel auf [next] bisherige Check-ins
/// ([leftBehind], siehe [measuresLeftBehind]) nicht mehr zur Messgröße
/// passen. Ohne solche Check-ins gibt es keinen Dialog ([MeasureChange.keep]).
/// `null` = abgebrochen, Messgröße bleibt.
Future<MeasureChange?> confirmMeasureChange(
  BuildContext context, {
  required Map<SymptomMeasure, int> leftBehind,
  required MeasurePair next,
}) async {
  if (leftBehind.isEmpty) return MeasureChange.keep;
  final l10n = context.l10n;
  // Umrechnen nur anbieten, wenn jede alte Größe verlustfrei umrechenbar ist.
  final convertible = leftBehind.keys.every(
    (m) => measureConverter(m, next.primary) != null,
  );
  return showDialog<MeasureChange>(
    context: context,
    builder: (context) => AlertDialog(
      key: const ValueKey('measure-change-dialog'),
      title: Text(l10n.measureChangeTitle),
      content: Text(
        l10n.measureChangeBody(
          [
            for (final e in leftBehind.entries)
              '${measureLabel(e.key, l10n)}: ${e.value}',
          ].join(', '),
          [
            measureLabel(next.primary, l10n),
            if (next.secondary != null) measureLabel(next.secondary!, l10n),
          ].join(' + '),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.commonCancel),
        ),
        if (convertible)
          TextButton(
            onPressed: () => Navigator.pop(context, MeasureChange.convert),
            child: Text(l10n.measureChangeConvert),
          ),
        FilledButton(
          onPressed: () => Navigator.pop(context, MeasureChange.keep),
          child: Text(l10n.measureChangeKeep),
        ),
      ],
    ),
  );
}
