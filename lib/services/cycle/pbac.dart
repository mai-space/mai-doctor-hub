/// Pictorial Blood loss Assessment Chart (PBAC).
///
/// Quelle: Higham JM, O'Brien PM, Shaw RW. Assessment of menstrual blood loss
/// using a pictorial chart. Br J Obstet Gynaecol 1990;97(8):734–739.
/// Punkte: Binden leicht/mittel/voll 1/5/20, Tampons leicht/mittel/voll
/// 1/5/10, Koagel klein/groß 1/5, „Flooding“ (Durchbluten) 5 je Episode.
/// Ein Zyklus-Summenwert über 100 spricht für eine verstärkte
/// Regelblutung (Sensitivität/Spezifität ≈ 86 %/89 % im Original).
library;

import 'dart:convert';

/// Schwelle, ab der eine starke Regelblutung wahrscheinlich ist (> 100).
const pbacHeavyThreshold = 100;

/// Zählungen eines Tages.
class PbacCounts {
  const PbacCounts({
    this.padsLight = 0,
    this.padsMedium = 0,
    this.padsFull = 0,
    this.tamponsLight = 0,
    this.tamponsMedium = 0,
    this.tamponsFull = 0,
    this.clotsSmall = 0,
    this.clotsLarge = 0,
    this.flooding = 0,
  });

  final int padsLight;
  final int padsMedium;
  final int padsFull;
  final int tamponsLight;
  final int tamponsMedium;
  final int tamponsFull;
  final int clotsSmall;
  final int clotsLarge;
  final int flooding;

  static const empty = PbacCounts();

  /// Reihenfolge der Felder = Reihenfolge in der Oberfläche.
  static const keys = [
    'padsLight',
    'padsMedium',
    'padsFull',
    'tamponsLight',
    'tamponsMedium',
    'tamponsFull',
    'clotsSmall',
    'clotsLarge',
    'flooding',
  ];

  /// Punkte je Feld (gleiche Reihenfolge wie [keys]).
  static const points = [1, 5, 20, 1, 5, 10, 1, 5, 5];

  List<int> get values => [
    padsLight,
    padsMedium,
    padsFull,
    tamponsLight,
    tamponsMedium,
    tamponsFull,
    clotsSmall,
    clotsLarge,
    flooding,
  ];

  int get score {
    var sum = 0;
    final v = values;
    for (var i = 0; i < v.length; i++) {
      sum += v[i] * points[i];
    }
    return sum;
  }

  bool get isEmpty => values.every((v) => v == 0);

  PbacCounts withValue(String key, int value) {
    final v = [...values];
    v[keys.indexOf(key)] = value < 0 ? 0 : value;
    return PbacCounts._fromList(v);
  }

  factory PbacCounts._fromList(List<int> v) => PbacCounts(
    padsLight: v[0],
    padsMedium: v[1],
    padsFull: v[2],
    tamponsLight: v[3],
    tamponsMedium: v[4],
    tamponsFull: v[5],
    clotsSmall: v[6],
    clotsLarge: v[7],
    flooding: v[8],
  );

  /// `null`, wenn nichts gezählt wurde (Spalte bleibt leer).
  String? encode() => isEmpty
      ? null
      : jsonEncode({
          for (var i = 0; i < keys.length; i++)
            if (values[i] > 0) keys[i]: values[i],
        });

  /// Fehlerhaftes JSON oder unbekannte Felder → ignoriert.
  static PbacCounts parse(String? raw) {
    if (raw == null || raw.trim().isEmpty) return empty;
    try {
      final json = jsonDecode(raw);
      if (json is! Map<String, Object?>) return empty;
      return PbacCounts._fromList([
        for (final key in keys)
          switch (json[key]) {
            final int v when v > 0 => v,
            _ => 0,
          },
      ]);
    } on FormatException {
      return empty;
    }
  }

  @override
  bool operator ==(Object other) =>
      other is PbacCounts && _listEquals(other.values, values);

  @override
  int get hashCode => Object.hashAll(values);
}

bool _listEquals(List<int> a, List<int> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}
