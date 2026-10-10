import 'package:flutter/services.dart';

import 'device_platform.dart';

/// Zeitzone des Geräts als IANA-ID (z. B. `Europe/Berlin`).
///
/// `DateTime.now().timeZoneName` liefert nur Abkürzungen („CEST“), die für
/// Erinnerungen (tz-Datenbank) und Kalender-Events nicht eindeutig sind.
abstract final class DeviceTime {
  static const _channel = MethodChannel('mai/device');

  /// Wenn die Plattform keine Zone liefert (Web, Tests).
  static const fallbackTimeZone = 'Europe/Berlin';

  static Future<String> timeZone() async {
    // Android und iOS liefern die Zone über `mai/device`.
    if (!DevicePlatform.isMobile) return fallbackTimeZone;
    try {
      final zone = await _channel.invokeMethod<String>('timeZone');
      return zone == null || zone.isEmpty ? fallbackTimeZone : zone;
    } catch (_) {
      // Kein Kanal (Tests, ältere Builds) → Standardzone statt Abbruch.
      return fallbackTimeZone;
    }
  }
}
