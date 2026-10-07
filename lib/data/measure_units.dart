/// v15: Einheiten für Messwerte. Gespeichert wird immer kanonisch (°C,
/// mg/dL, kg); umgerechnet wird nur für Anzeige und Eingabe.
library;

import 'dart:ui' show PlatformDispatcher;

import 'package:flutter/widgets.dart';

import 'app_database.dart';

enum TemperatureUnit {
  celsius('°C'),
  fahrenheit('°F');

  const TemperatureUnit(this.symbol);

  final String symbol;
}

enum GlucoseUnit {
  mgdl('mg/dL'),
  mmol('mmol/L');

  const GlucoseUnit(this.symbol);

  final String symbol;
}

enum WeightUnit {
  kg('kg'),
  lb('lb');

  const WeightUnit(this.symbol);

  final String symbol;
}

/// Glukose: 1 mmol/L = 18,016 mg/dL (Molmasse 180,16 g/mol).
const mgdlPerMmol = 18.016;

/// Internationales Pfund (exakt).
const kgPerLb = 0.45359237;

double celsiusToFahrenheit(double c) => c * 9 / 5 + 32;
double fahrenheitToCelsius(double f) => (f - 32) * 5 / 9;
double mgdlToMmol(double mgdl) => mgdl / mgdlPerMmol;
double mmolToMgdl(double mmol) => mmol * mgdlPerMmol;
double kgToLb(double kg) => kg / kgPerLb;
double lbToKg(double lb) => lb * kgPerLb;

/// Regionen mit Fahrenheit im Alltag.
const _fahrenheitRegions = {'US', 'LR', 'MM', 'BS', 'BZ', 'KY', 'PW', 'FM'};

/// Regionen mit Pfund als Körpergewicht.
const _poundRegions = {'US', 'LR', 'MM'};

/// Regionen, in denen Blutzucker überwiegend in mmol/L angegeben wird;
/// sonst mg/dL (u. a. USA, Deutschland, Österreich, Frankreich, Italien).
const _mmolRegions = {
  'GB', 'IE', 'CA', 'AU', 'NZ', 'ZA', 'NL', 'SE', 'NO', 'DK', 'FI', 'IS', //
  'CH', 'CZ', 'SK', 'HU', 'EE', 'LV', 'LT', 'RU', 'UA', 'CN', 'HK', 'SG', //
  'MY', 'KZ',
};

/// Region des Geräts (z. B. `DE`), `null` wenn unbekannt. Über das Binding,
/// damit Tests die Gerätesprache vorgeben können.
String? deviceRegion() {
  try {
    return WidgetsBinding.instance.platformDispatcher.locale.countryCode;
  } catch (_) {
    return PlatformDispatcher.instance.locale.countryCode;
  }
}

/// Gewählte Einheiten; leere Einstellung = Standard der Region.
@immutable
class UnitPreferences {
  const UnitPreferences({
    this.temperature = TemperatureUnit.celsius,
    this.glucose = GlucoseUnit.mgdl,
    this.weight = WeightUnit.kg,
  });

  /// Standard je Region: USA °F, mg/dL, lb; Deutschland °C, mg/dL, kg;
  /// Großbritannien u. a. mmol/L.
  factory UnitPreferences.forRegion(String? region) {
    final r = region?.toUpperCase();
    return UnitPreferences(
      temperature: _fahrenheitRegions.contains(r)
          ? TemperatureUnit.fahrenheit
          : TemperatureUnit.celsius,
      glucose: _mmolRegions.contains(r) ? GlucoseUnit.mmol : GlucoseUnit.mgdl,
      weight: _poundRegions.contains(r) ? WeightUnit.lb : WeightUnit.kg,
    );
  }

  /// Aus den App-Einstellungen; fehlende Werte nach [region].
  factory UnitPreferences.fromSettings(AppSetting s, {String? region}) {
    final fallback = UnitPreferences.forRegion(region ?? deviceRegion());
    return UnitPreferences(
      temperature:
          _byName(TemperatureUnit.values, s.temperatureUnit) ??
          fallback.temperature,
      glucose: _byName(GlucoseUnit.values, s.glucoseUnit) ?? fallback.glucose,
      weight: _byName(WeightUnit.values, s.weightUnit) ?? fallback.weight,
    );
  }

  final TemperatureUnit temperature;
  final GlucoseUnit glucose;
  final WeightUnit weight;

  UnitPreferences copyWith({
    TemperatureUnit? temperature,
    GlucoseUnit? glucose,
    WeightUnit? weight,
  }) => UnitPreferences(
    temperature: temperature ?? this.temperature,
    glucose: glucose ?? this.glucose,
    weight: weight ?? this.weight,
  );

  // --- Umrechnung kanonisch ↔ Anzeige -------------------------------------

  double temperatureToDisplay(double celsius) =>
      temperature == TemperatureUnit.celsius
      ? celsius
      : celsiusToFahrenheit(celsius);
  double temperatureFromDisplay(double value) =>
      temperature == TemperatureUnit.celsius
      ? value
      : fahrenheitToCelsius(value);

  double glucoseToDisplay(double mgdl) =>
      glucose == GlucoseUnit.mgdl ? mgdl : mgdlToMmol(mgdl);
  double glucoseFromDisplay(double value) =>
      glucose == GlucoseUnit.mgdl ? value : mmolToMgdl(value);

  double weightToDisplay(double kg) =>
      weight == WeightUnit.kg ? kg : kgToLb(kg);
  double weightFromDisplay(double value) =>
      weight == WeightUnit.kg ? value : lbToKg(value);

  @override
  bool operator ==(Object other) =>
      other is UnitPreferences &&
      other.temperature == temperature &&
      other.glucose == glucose &&
      other.weight == weight;

  @override
  int get hashCode => Object.hash(temperature, glucose, weight);

  static T? _byName<T extends Enum>(List<T> values, String? name) =>
      values.where((v) => v.name == name).firstOrNull;
}

/// Aktuelle Einheiten — auch außerhalb von Widgets (PDF, Assistent), wie
/// `AppLocale`. Beim Start und bei jeder Änderung aus den Einstellungen
/// gesetzt (siehe `SettingsRepository.setUnits`).
abstract final class AppUnits {
  static final notifier = ValueNotifier<UnitPreferences>(
    UnitPreferences.forRegion(deviceRegion()),
  );

  static UnitPreferences get current => notifier.value;

  static void update(UnitPreferences preferences) =>
      notifier.value = preferences;

  /// Zurück auf den Standard der Region (Tests, Wiederherstellung).
  static void reset() => update(UnitPreferences.forRegion(deviceRegion()));
}
