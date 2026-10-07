/// Kalendertage für das Zyklus-Tagebuch.
///
/// Ein Tag ist immer ein *lokales* Datum ohne Uhrzeit. Gespeichert wird er als
/// Schlüssel `yyyy-MM-dd`, gerechnet wird über UTC-Mitternacht — so bleiben
/// Differenzen auch über Sommer-/Winterzeit hinweg ganze Tage.
library;

/// Lokaler Tag (Mitternacht) eines Zeitpunkts.
DateTime cycleDay(DateTime at) {
  final local = at.isUtc ? at.toLocal() : at;
  return DateTime(local.year, local.month, local.day);
}

/// `yyyy-MM-dd` des lokalen Tages.
String dayKey(DateTime at) {
  final d = cycleDay(at);
  String two(int v) => v.toString().padLeft(2, '0');
  return '${d.year.toString().padLeft(4, '0')}-${two(d.month)}-${two(d.day)}';
}

/// Schlüssel → lokaler Tag; `null` bei ungültigem Text.
DateTime? parseDayKey(String? key) {
  if (key == null) return null;
  final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(key.trim());
  if (match == null) return null;
  final y = int.parse(match[1]!);
  final m = int.parse(match[2]!);
  final d = int.parse(match[3]!);
  final date = DateTime(y, m, d);
  // 2026-02-31 o. Ä. ablehnen.
  if (date.month != m || date.day != d) return null;
  return date;
}

/// [day] plus [days] Kalendertage (DST-sicher über den Konstruktor).
DateTime plusDays(DateTime day, int days) =>
    DateTime(day.year, day.month, day.day + days);

/// Ganze Kalendertage von [from] bis [to] (negativ, wenn [to] früher liegt).
int dayDiff(DateTime from, DateTime to) => DateTime.utc(
  to.year,
  to.month,
  to.day,
).difference(DateTime.utc(from.year, from.month, from.day)).inDays;
