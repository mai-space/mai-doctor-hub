/// v15: Symptom-Titel aus Bausteinen — Charakter, Empfindung, Ort, Seite:
/// „Brennender Schmerz am Hinterkopf (links)“ bzw. „Burning pain, back of
/// head (left)“.
///
/// Deutsch mit Adjektiv-Beugung im Nominativ ohne Artikel (starke
/// Deklination) nach dem Geschlecht der Empfindung: brennender Schmerz (m),
/// brennende Übelkeit (f), stechendes Brennen (n), brennende Blähungen (Pl.).
/// Was sich nicht sicher beugen lässt (unbekannte Empfindung, Ausdrücke wie
/// „wie Nadelstiche“, eigene Begriffe), steht unverändert dahinter — lieber
/// schlicht als falsch.
library;

import '../l10n/l10n.dart';
import 'app_database.dart';
import 'symptom_description.dart';
import 'symptom_descriptors.dart';

/// Bausteine eines Titels. Mehrere Charakter-Begriffe möglich.
class TitleBlocks {
  const TitleBlocks({
    this.sensation,
    this.qualities = const [],
    this.location,
    this.side,
  });

  factory TitleBlocks.fromDescription(SymptomDescription d) => TitleBlocks(
    sensation: d.sensation,
    qualities: d.qualities,
    location: d.location,
    side: d.side,
  );

  final String? sensation;
  final List<String> qualities;
  final String? location;
  final BodySide? side;

  bool get isEmpty =>
      (sensation?.trim().isEmpty ?? true) &&
      qualities.every((q) => q.trim().isEmpty) &&
      (location?.trim().isEmpty ?? true) &&
      side == null;
}

/// Titel in der Sprache von [l10n]; leer, wenn keine Bausteine gesetzt sind.
String composeSymptomTitle(TitleBlocks blocks, AppLocalizations l10n) {
  if (blocks.isEmpty) return '';
  final german = l10n.localeName.startsWith('de');
  final title = german
      ? _composeGerman(blocks, l10n)
      : _composeEnglish(blocks, l10n);
  return _capitalize(title.trim());
}

// --- Deutsch -----------------------------------------------------------------

String _composeGerman(TitleBlocks b, AppLocalizations l10n) {
  final sensation = _clean(b.sensation);
  final qualities = [for (final q in b.qualities) ?_clean(q)];
  final gender = sensation == null ? null : germanGender(sensation);

  final before = <String>[];
  final after = <String>[];
  for (final q in qualities) {
    final declined = gender == null ? null : declineGerman(q, gender);
    if (declined != null) {
      before.add(declined);
    } else if (q.toLowerCase().startsWith('wie ')) {
      after.add(q);
    } else {
      after.add('($q)');
    }
  }

  final parts = <String>[];
  if (sensation != null) {
    // Mehrwortige Empfindung („Innere Unruhe“) hinter Adjektiven klein.
    final noun = before.isEmpty ? sensation : _lowerLeadingAdjective(sensation);
    parts.add(
      [if (before.isNotEmpty) before.join(', '), noun, ...after].join(' '),
    );
  } else if (qualities.isNotEmpty) {
    parts.add(qualities.join(', '));
  }

  final location = _clean(b.location);
  final side = b.side == null ? null : bodySideLabel(b.side!, l10n);
  if (location != null) {
    final phrase = _locationPhrase(location);
    if (parts.isEmpty) {
      parts.add(location);
    } else if (phrase != null) {
      parts.add(phrase);
    } else {
      parts.add('· $location');
    }
  }
  if (side != null) parts.add('($side)');
  return parts.join(' ');
}

/// Geschlecht einer deutschen Empfindung: Katalog, dann Wortende eines
/// Katalogbegriffs („Rückenschmerz“ → Schmerz), dann typische Endungen;
/// `null`, wenn unsicher.
NounGender? germanGender(String sensation) {
  final key = sensation.trim().toLowerCase();
  if (key.isEmpty) return null;
  for (final MapEntry(key: term, value: g) in sensationGenders.entries) {
    if (term.toLowerCase() == key) return g;
  }
  // Komposita: Geschlecht des letzten Glieds („Kopfschmerz“, „Gelenkschmerzen“).
  const plurals = {
    'schmerzen': NounGender.plural,
    'beschwerden': NounGender.plural,
    'krämpfe': NounGender.plural,
    'probleme': NounGender.plural,
    'störungen': NounGender.plural,
    'schwierigkeiten': NounGender.plural,
    'gedanken': NounGender.plural,
    'attacken': NounGender.plural,
    'anfälle': NounGender.plural,
    'ungen': NounGender.plural,
    'heiten': NounGender.plural,
    'keiten': NounGender.plural,
  };
  for (final MapEntry(key: suffix, value: g) in plurals.entries) {
    if (key.endsWith(suffix)) return g;
  }
  final word = key.split(RegExp(r'\s+')).last;
  String? best;
  NounGender? bestGender;
  for (final MapEntry(key: term, value: g) in sensationGenders.entries) {
    final t = term.toLowerCase();
    if (t.contains(' ') || t.length < 4) continue;
    if (word.endsWith(t) && (best == null || t.length > best.length)) {
      best = t;
      bestGender = g;
    }
  }
  if (bestGender != null) return bestGender;
  // Sichere Endungen.
  if (RegExp(r'(ung|heit|keit|schaft|tion|sion|tät|ie|ik)$').hasMatch(word)) {
    return NounGender.feminine;
  }
  if (RegExp(r'(chen|lein|gefühl|ment)$').hasMatch(word)) {
    return NounGender.neuter;
  }
  return null;
}

/// Bekannte Adjektive (Grundform) außerhalb des Katalogs.
const _commonAdjectives = {
  'stark',
  'leicht',
  'schwach',
  'mild',
  'heftig',
  'akut',
  'chronisch',
  'dauerhaft',
  'plötzlich',
  'tief',
  'hoch',
  'dumpf',
  'scharf',
  'warm',
  'kalt',
  'heiß',
  'schwer',
  'eng',
  'leer',
  'flau',
  'wund',
  'taub',
  'steif',
  'trocken',
  'starr',
  'matt',
  'müde',
  'leise',
  'laut',
  'dunkel',
  'hell',
  'innerlich',
  'ständig',
  'wiederkehrend',
  'neu',
  'alt',
  'anhaltend',
};

/// Adjektiv-Endungen, die sich sicher stark beugen lassen.
final _adjectiveSuffix = RegExp(
  r'(end|ig|lich|isch|bar|sam|artig|haft|los|voll|iv|al|ell|ant|ent|ös)$',
);

/// Partizip II („geschwollen“, „gerötet“, „verspannt“).
final _participle = RegExp(
  r'^(ge|ver|be|er|zer|ent)\p{L}+(t|en)$',
  unicode: true,
);

bool _isGermanAdjective(String word) {
  if (word.isEmpty || word != word.toLowerCase()) return false;
  if (_commonAdjectives.contains(word)) return true;
  for (final g in qualityGroups) {
    for (final (de, _) in g.terms) {
      if (de == word) return true;
    }
  }
  return _adjectiveSuffix.hasMatch(word) || _participle.hasMatch(word);
}

/// Stark gebeugtes Adjektiv im Nominativ, z. B. („stechend“, m) →
/// „stechender“; `null`, wenn sich der Ausdruck nicht beugen lässt (z. B.
/// „wie Nadelstiche“). Bei mehreren Wörtern („innerlich unruhig“) wird nur
/// das letzte gebeugt; die übrigen müssen klein geschriebene Adverbien sein.
String? declineGerman(String adjective, NounGender gender) {
  final words = adjective.trim().split(RegExp(r'\s+'));
  final last = words.last;
  if (words.first.toLowerCase() == 'wie') return null;
  for (final w in words) {
    if (w != w.toLowerCase()) return null;
  }
  if (!_isGermanAdjective(last)) return null;
  final head = words.take(words.length - 1);
  return [...head, _declineWord(last, gender)].join(' ');
}

String _declineWord(String base, NounGender gender) {
  var stem = base;
  if (base == 'hoch') {
    stem = 'hoh';
  } else if (base.endsWith('e')) {
    // „müde“ → müder, müde, müdes.
    stem = base.substring(0, base.length - 1);
  } else if (base.endsWith('el') && base.length > 3) {
    // „dunkel“ → dunkler.
    stem = '${base.substring(0, base.length - 2)}l';
  } else if (base.endsWith('euer') || base.endsWith('auer')) {
    // „teuer“ → teurer, „sauer“ → saurer.
    stem = '${base.substring(0, base.length - 2)}r';
  }
  return switch (gender) {
    NounGender.masculine => '${stem}er',
    NounGender.feminine || NounGender.plural => '${stem}e',
    NounGender.neuter => '${stem}es',
  };
}

String _lowerLeadingAdjective(String sensation) {
  final words = sensation.split(' ');
  if (words.length < 2) return sensation;
  final first = words.first;
  // „Verstopfte Nase“, „Innere Unruhe“, „Sozialer Rückzug“: Adjektiv vorn.
  if (RegExp(r'(e|er|es)$').hasMatch(first)) {
    return [_lowerFirst(first), ...words.skip(1)].join(' ');
  }
  return sensation;
}

String? _locationPhrase(String location) {
  final key = location.trim().toLowerCase();
  for (final MapEntry(key: term, value: phrase) in locationPhrases.entries) {
    if (term.toLowerCase() == key) return phrase;
  }
  return null;
}

// --- Englisch ----------------------------------------------------------------

String _composeEnglish(TitleBlocks b, AppLocalizations l10n) {
  final sensation = _clean(b.sensation);
  final qualities = [for (final q in b.qualities) ?_clean(q)];
  final before = [
    for (final q in qualities)
      if (!q.toLowerCase().startsWith('like ')) q,
  ];
  final after = [
    for (final q in qualities)
      if (q.toLowerCase().startsWith('like ')) q,
  ];
  final parts = <String>[];
  if (sensation != null) {
    final noun = before.isEmpty ? sensation : _lowerFirst(sensation);
    parts.add(
      [if (before.isNotEmpty) before.join(', '), noun, ...after].join(' '),
    );
  } else if (qualities.isNotEmpty) {
    parts.add(qualities.join(', '));
  }
  final location = _clean(b.location);
  final side = b.side == null ? null : bodySideLabel(b.side!, l10n);
  var text = parts.join();
  if (location != null) {
    text = text.isEmpty ? location : '$text, ${_lowerFirst(location)}';
  }
  if (side != null) text = text.isEmpty ? '($side)' : '$text ($side)';
  return text;
}

// --- Hilfen ------------------------------------------------------------------

String? _clean(String? value) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}

/// Erster Buchstabe klein — nicht bei Abkürzungen („SpO2“, „HWS“).
String _lowerFirst(String text) {
  if (text.length < 2) return text.toLowerCase();
  final second = text[1];
  if (second != second.toLowerCase()) return text;
  return text[0].toLowerCase() + text.substring(1);
}

String _capitalize(String text) =>
    text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
