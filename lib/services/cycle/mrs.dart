/// Menopause Rating Scale (MRS).
///
/// Quellen: Heinemann LAJ, Potthoff P, Schneider HPG. International versions
/// of the Menopause Rating Scale (MRS). Health Qual Life Outcomes 2003;1:28.
/// Heinemann K, Ruebig A, Potthoff P et al. The Menopause Rating Scale (MRS)
/// scale: A methodological review. Health Qual Life Outcomes 2004;2:45.
///
/// 11 Items, je 0 (keine) bis 4 (sehr stark). Subskalen: somatisch (Items 1,
/// 2, 3, 11), psychisch (4–7), urogenital (8–10); Summe 0–44.
/// Schweregrade (Heinemann 2004, Tab. „Severity“):
///   gesamt       0–4 keine/kaum · 5–8 leicht · 9–16 mittel · ≥17 stark
///   somatisch    0–2           · 3–4        · 5–8         · ≥9
///   psychisch    0–1           · 2–3        · 4–6         · ≥7
///   urogenital   0             · 1          · 2–3         · ≥4
library;

/// Anzahl der Items.
const mrsItemCount = 11;

/// Höchstwert je Item.
const mrsMaxItem = 4;

enum MrsSubscale { somatic, psychological, urogenital }

/// Items je Subskala (0-basiert).
const mrsSubscaleItems = {
  MrsSubscale.somatic: [0, 1, 2, 10],
  MrsSubscale.psychological: [3, 4, 5, 6],
  MrsSubscale.urogenital: [7, 8, 9],
};

enum MrsSeverity { none, mild, moderate, severe }

/// Obergrenzen (inklusive) für keine/leicht/mittel; darüber stark.
const _totalBands = (4, 8, 16);
const _subscaleBands = {
  MrsSubscale.somatic: (2, 4, 8),
  MrsSubscale.psychological: (1, 3, 6),
  MrsSubscale.urogenital: (0, 1, 3),
};

MrsSeverity _band(int value, (int, int, int) bands) {
  if (value <= bands.$1) return MrsSeverity.none;
  if (value <= bands.$2) return MrsSeverity.mild;
  if (value <= bands.$3) return MrsSeverity.moderate;
  return MrsSeverity.severe;
}

/// Ergebnis eines ausgefüllten Fragebogens.
class MrsResult {
  MrsResult(List<int> scores)
    : scores = List.unmodifiable([
        for (var i = 0; i < mrsItemCount; i++)
          i < scores.length ? scores[i].clamp(0, mrsMaxItem) : 0,
      ]);

  final List<int> scores;

  int get total => scores.fold(0, (a, b) => a + b);

  int subscale(MrsSubscale s) =>
      mrsSubscaleItems[s]!.fold(0, (sum, i) => sum + scores[i]);

  MrsSeverity get severity => _band(total, _totalBands);

  MrsSeverity subscaleSeverity(MrsSubscale s) =>
      _band(subscale(s), _subscaleBands[s]!);

  /// Speicherform: „0,1,2,…“.
  String encode() => scores.join(',');

  /// Unvollständige/ungültige Werte zählen als 0.
  static MrsResult parse(String raw) => MrsResult([
    for (final part in raw.split(',')) int.tryParse(part.trim()) ?? 0,
  ]);
}
