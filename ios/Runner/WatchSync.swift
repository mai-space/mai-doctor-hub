import Foundation
import WatchConnectivity

/// Abgleich mit der Uhr-App (watchOS, Ziel „Watch“).
///
/// Die Uhr bekommt denselben Snapshot wie die Startbildschirm-Widgets unter
/// Android — im diskreten Modus also ohne Namen. Übertragen wird nur per
/// WatchConnectivity direkt an die gekoppelte Apple Watch und nur, wenn die
/// Uhr-App dort installiert ist; ohne Uhr-App verlässt nichts das Telefon.
/// Eingaben an der Uhr (Einnahme abgehakt, Check-in-Wert) landen in einer
/// Warteschlange, die Dart wie die der Android-Widgets übernimmt.
final class WatchSync: NSObject, WCSessionDelegate {
  static let shared = WatchSync()

  private let queue = DispatchQueue(label: "space.mai.watch-sync")
  private var lastSnapshot: String?

  /// Beim App-Start: Sitzung aktivieren, damit Eingaben der Uhr auch im
  /// Hintergrund ankommen.
  func activate() {
    guard WCSession.isSupported() else { return }
    let session = WCSession.default
    session.delegate = self
    session.activate()
  }

  /// Neuer Snapshot von Dart; [ack] = dort übernommene Eingaben.
  func update(snapshot: String, ack: [String]) {
    queue.async {
      self.lastSnapshot = snapshot
      if !ack.isEmpty {
        let acked = Set(ack)
        self.writeActions(self.readActions().filter { !acked.contains($0["id"] as? String ?? "") })
      }
      self.push()
    }
  }

  /// Noch nicht übernommene Eingaben der Uhr (JSON-Liste, wie unter Android).
  func pendingJSON() -> String {
    queue.sync {
      let data = (try? JSONSerialization.data(withJSONObject: readActions())) ?? Data("[]".utf8)
      return String(decoding: data, as: UTF8.self)
    }
  }

  // MARK: - Senden

  private func push() {
    guard WCSession.isSupported(), let snapshot = lastSnapshot else { return }
    let session = WCSession.default
    guard session.activationState == .activated, session.isPaired, session.isWatchAppInstalled
    else { return }
    // Anwendungskontext: das System behält nur den neuesten Stand und stellt
    // ihn zu, sobald die Uhr erreichbar ist.
    try? session.updateApplicationContext([
      "snapshot": snapshot,
      "sentAt": Date().timeIntervalSince1970,
    ])
  }

  // MARK: - WCSessionDelegate

  func session(
    _ session: WCSession,
    activationDidCompleteWith activationState: WCSessionActivationState,
    error: Error?
  ) {
    queue.async { self.push() }
  }

  func sessionDidBecomeInactive(_ session: WCSession) {}

  func sessionDidDeactivate(_ session: WCSession) {
    // Uhr gewechselt: neu aktivieren, damit die neue Uhr den Stand bekommt.
    session.activate()
  }

  func sessionWatchStateDidChange(_ session: WCSession) {
    queue.async { self.push() }
  }

  func session(_ session: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
    guard let raw = userInfo["action"] as? String,
      let action = WatchSync.parseAction(raw)
    else { return }
    queue.async {
      var actions = self.readActions()
      if actions.contains(where: { ($0["id"] as? String) == (action["id"] as? String) }) { return }
      actions.append(action)
      // Obergrenze, falls die App lange nicht geöffnet wird.
      self.writeActions(Array(actions.suffix(200)))
    }
  }

  /// Nur bekannte, vollständige Eingaben übernehmen.
  static func parseAction(_ raw: String) -> [String: Any]? {
    guard let data = raw.data(using: .utf8),
      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
      json["id"] is String, json["ts"] is NSNumber
    else { return nil }
    switch json["type"] as? String {
    case "intake":
      guard json["med"] is String, json["at"] is NSNumber else { return nil }
    case "checkin":
      guard json["symptom"] is String, json["value"] is NSNumber else { return nil }
    default:
      return nil
    }
    return json
  }

  // MARK: - Warteschlange (Application Support, nicht im Backup)

  private var actionsURL: URL? {
    try? FileManager.default
      .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
      .appendingPathComponent("mai_watch_actions.json")
  }

  private func readActions() -> [[String: Any]] {
    guard let url = actionsURL, let data = try? Data(contentsOf: url),
      let list = try? JSONSerialization.jsonObject(with: data) as? [[String: Any]]
    else { return [] }
    return list
  }

  private func writeActions(_ actions: [[String: Any]]) {
    guard let url = actionsURL,
      let data = try? JSONSerialization.data(withJSONObject: actions)
    else { return }
    try? data.write(to: url, options: [.atomic, .completeFileProtectionUntilFirstUserAuthentication])
  }
}
