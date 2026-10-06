import '../l10n/l10n.dart';
import 'app_database.dart';

/// Strukturierte Beschreibung eines Symptoms bzw. Check-ins:
/// Empfindung (Schmerz), Qualität(en) (brennend), Ort (Hinterkopf), Seite,
/// Verlauf (anfallsartig) und Stärke 0–10.
///
/// Bewusst ohne deutsche Adjektiv-Beugung: „Schmerz (brennend) · Hinterkopf
/// (links) · 7/10 stark“ ist in beiden Sprachen korrekt, „brennender Schmerz“
/// wäre es nur für einen Teil der Begriffe.
class SymptomDescription {
  const SymptomDescription({
    this.sensation,
    this.qualities = const [],
    this.location,
    this.side,
    this.patterns = const [],
    this.intensity,
  });

  /// Standard-Beschreibung eines Symptoms (Ort = Körperregion).
  factory SymptomDescription.fromSymptom(Symptom s) => SymptomDescription(
    sensation: _clean(s.sensation),
    qualities: splitList(s.quality),
    location: _clean(s.bodyRegion),
    side: BodySide.fromCode(s.side),
  );

  factory SymptomDescription.fromObservation(SymptomObservation o) =>
      SymptomDescription(
        sensation: _clean(o.sensation),
        qualities: splitList(o.quality),
        location: _clean(o.location),
        side: BodySide.fromCode(o.side),
        patterns: splitList(o.pattern),
        intensity: o.kind == ObservationKind.scale_1_10 ? o.valueNumber : null,
      );

  final String? sensation;
  final List<String> qualities;
  final String? location;
  final BodySide? side;
  final List<String> patterns;
  final double? intensity;

  /// Keine beschreibenden Angaben (Stärke zählt nicht).
  bool get isEmpty =>
      sensation == null &&
      qualities.isEmpty &&
      location == null &&
      side == null &&
      patterns.isEmpty;

  /// Speicherform für Mehrfachwerte: kommagetrennt, `null` wenn leer.
  String? get qualityText => joinList(qualities);
  String? get patternText => joinList(patterns);

  SymptomDescription copyWith({
    String? Function()? sensation,
    List<String>? qualities,
    String? Function()? location,
    BodySide? Function()? side,
    List<String>? patterns,
    double? Function()? intensity,
  }) => SymptomDescription(
    sensation: sensation == null ? this.sensation : _clean(sensation()),
    qualities: qualities ?? this.qualities,
    location: location == null ? this.location : _clean(location()),
    side: side == null ? this.side : side(),
    patterns: patterns ?? this.patterns,
    intensity: intensity == null ? this.intensity : intensity(),
  );

  /// Lesbarer Satz, z. B. „Schmerz (brennend, pochend) · Hinterkopf (links)
  /// · anfallsartig · 7/10 stark“. Leere Teile entfallen.
  String describe(AppLocalizations l10n, {bool withIntensity = true}) {
    final what = switch ((sensation, qualities.join(', '))) {
      (null, '') => null,
      (final s?, '') => s,
      (null, final q) => q,
      (final s?, final q) => '$s ($q)',
    };
    final sideLabel = side == null ? null : bodySideLabel(side!, l10n);
    final where = switch ((location, sideLabel)) {
      (final l?, final s?) => l10n.symptomLocationSide(l, s),
      (final l, final s) => l ?? s,
    };
    final value = intensity;
    return [
      ?what,
      ?where,
      if (patterns.isNotEmpty) patterns.join(', '),
      if (withIntensity && value != null) intensityText(value, l10n),
    ].join(' · ');
  }

  /// Kommagetrennte Liste → Einträge (getrimmt, ohne Doppelte).
  static List<String> splitList(String? text) {
    if (text == null) return const [];
    final seen = <String>{};
    return [
      for (final part in text.split(','))
        if (part.trim().isNotEmpty && seen.add(part.trim().toLowerCase()))
          part.trim(),
    ];
  }

  static String? joinList(List<String> values) =>
      values.isEmpty ? null : values.join(', ');

  static String? _clean(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}

String bodySideLabel(BodySide side, AppLocalizations l10n) => switch (side) {
  BodySide.left => l10n.symptomSideLeft,
  BodySide.right => l10n.symptomSideRight,
  BodySide.both => l10n.symptomSideBoth,
  BodySide.center => l10n.symptomSideCenter,
};

/// Stufe der Numerischen Rating-Skala (NRS 0–10).
enum IntensityBand { none, mild, moderate, severe, unbearable }

IntensityBand intensityBand(num value) {
  final v = value.round().clamp(0, 10);
  if (v == 0) return IntensityBand.none;
  if (v <= 3) return IntensityBand.mild;
  if (v <= 6) return IntensityBand.moderate;
  if (v <= 9) return IntensityBand.severe;
  return IntensityBand.unbearable;
}

String intensityBandLabel(IntensityBand band, AppLocalizations l10n) =>
    switch (band) {
      IntensityBand.none => l10n.symptomBandNone,
      IntensityBand.mild => l10n.symptomBandMild,
      IntensityBand.moderate => l10n.symptomBandModerate,
      IntensityBand.severe => l10n.symptomBandSevere,
      IntensityBand.unbearable => l10n.symptomBandUnbearable,
    };

/// „7/10 stark“.
String intensityText(num value, AppLocalizations l10n) =>
    l10n.symptomIntensityValue(
      value.round().clamp(0, 10).toString(),
      intensityBandLabel(intensityBand(value), l10n),
    );

/// Verbaler Anker je Wert, damit 7/10 jedes Mal dasselbe bedeutet.
String intensityAnchor(num value, AppLocalizations l10n) =>
    switch (value.round().clamp(0, 10)) {
      0 => l10n.symptomAnchor0,
      1 => l10n.symptomAnchor1,
      2 => l10n.symptomAnchor2,
      3 => l10n.symptomAnchor3,
      4 => l10n.symptomAnchor4,
      5 => l10n.symptomAnchor5,
      6 => l10n.symptomAnchor6,
      7 => l10n.symptomAnchor7,
      8 => l10n.symptomAnchor8,
      9 => l10n.symptomAnchor9,
      _ => l10n.symptomAnchor10,
    };
