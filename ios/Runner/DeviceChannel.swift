import Flutter
import Foundation

/// Kanal „mai/device“ (Gegenstück zu MainActivity.kt).
final class DeviceChannel {
  static let name = "mai/device"

  private let queue = DispatchQueue(label: "space.mai.device", qos: .utility)

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    // IANA-Zeitzone des Geräts (z. B. „Europe/Berlin“).
    case "timeZone":
      result(TimeZone.current.identifier)
    // Lokale KI (LiteRT-LM): Dart entscheidet anhand von Arbeitsspeicher
    // und Architektur. „platform“ unterscheidet von der Android-Antwort.
    case "localAi":
      result(Self.localAiInfo())
    // Hugging-Face-Token aus gespeicherten Einstellungen (UserDefaults, dort
    // legt u. a. der Downloader Aufträge ab) entfernen.
    case "scrubSecret":
      let args = call.arguments as? [String: Any]
      guard let secret = args?["secret"] as? String, !secret.isEmpty else {
        result(FlutterError(code: "ARG", message: "secret fehlt", details: nil))
        return
      }
      queue.async {
        let removed = Self.scrubSecret(secret)
        DispatchQueue.main.async { result(removed) }
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  static func localAiInfo() -> [String: Any] {
    #if arch(arm64)
      let arm64 = true
    #else
      let arm64 = false
    #endif
    return [
      "platform": "ios",
      "osMajor": ProcessInfo.processInfo.operatingSystemVersion.majorVersion,
      "arm64": arm64,
      // Int ist auf 64-Bit-Geräten 64 Bit breit — passt für Dart-int.
      "totalRam": Int(clamping: ProcessInfo.processInfo.physicalMemory),
    ]
  }

  /// Entfernt Einträge mit [secret] aus den Einstellungen der App (eigene
  /// Domäne der UserDefaults) — so gut es geht, wie unter Android.
  static func scrubSecret(_ secret: String) -> Int {
    let defaults = UserDefaults.standard
    guard let domain = Bundle.main.bundleIdentifier,
      let values = defaults.persistentDomain(forName: domain)
    else { return 0 }
    var removed = 0
    for (key, value) in values where holds(value, secret) {
      defaults.removeObject(forKey: key)
      removed += 1
    }
    return removed
  }

  /// Sucht auch in Listen, Wörterbüchern und Daten (z. B. JSON als Data).
  private static func holds(_ value: Any, _ secret: String) -> Bool {
    switch value {
    case let text as String:
      return text.contains(secret)
    case let list as [Any]:
      return list.contains { holds($0, secret) }
    case let map as [String: Any]:
      return map.values.contains { holds($0, secret) }
    case let data as Data:
      return String(data: data, encoding: .utf8)?.contains(secret) ?? false
    default:
      return false
    }
  }
}
