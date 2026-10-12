import 'package:url_launcher/url_launcher.dart';

/// Grund einer Meldung zu einer KI-Antwort.
enum ReportReason { wrong, harmful, inappropriate, other }

/// Meldung einer Assistenten-Antwort (Google-Play-Richtlinie zu
/// KI-generierten Inhalten).
///
/// Die App schickt nichts selbst: Es entsteht nur ein E-Mail-Entwurf, den
/// die Person in ihrer Mail-App prüft und selbst absendet. Die Frage und
/// die Akte gehen nie mit, die Antwort nur auf ausdrücklichen Wunsch.
class AnswerReport {
  const AnswerReport({
    required this.reason,
    this.comment = '',
    this.answer,
    this.modelName,
  });

  /// Empfänger der Meldungen.
  static const address = 'joel@maispace.de';

  /// Öffnet den Entwurf; in Tests austauschbar.
  static Future<bool> Function(Uri uri) launcher = _launch;

  static Future<bool> _launch(Uri uri) async {
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  final ReportReason reason;
  final String comment;

  /// Antworttext — nur gesetzt, wenn die Person ihn mitschicken will.
  final String? answer;

  /// Name des lokalen Modells (keine Nutzerdaten, hilft beim Einordnen).
  final String? modelName;

  /// Baut den `mailto:`-Link. Leerzeichen als `%20`, nicht `+` (manche
  /// Mail-Apps zeigen sonst Pluszeichen).
  Uri mailto({
    required String subject,
    required String reasonLabel,
    required String reasonHeading,
    required String commentHeading,
    required String answerHeading,
    required String modelHeading,
  }) {
    final body = StringBuffer()
      ..writeln('$reasonHeading: $reasonLabel');
    final note = comment.trim();
    if (note.isNotEmpty) {
      body
        ..writeln()
        ..writeln('$commentHeading:')
        ..writeln(note);
    }
    final text = answer?.trim() ?? '';
    if (text.isNotEmpty) {
      body
        ..writeln()
        ..writeln('$answerHeading:')
        ..writeln(text);
    }
    if (modelName != null && modelName!.isNotEmpty) {
      body
        ..writeln()
        ..writeln('$modelHeading: $modelName');
    }
    return Uri(
      scheme: 'mailto',
      path: address,
      query:
          'subject=${Uri.encodeComponent(subject)}'
          '&body=${Uri.encodeComponent(body.toString())}',
    );
  }
}
