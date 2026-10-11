import Foundation

/// Letzter Snapshot vom Telefon und eigene Eingaben, die er noch nicht
/// enthält (Ausgang). Liegt in der App-Gruppe, damit die Komplikationen
/// (Widget-Erweiterung) ihn lesen können; im diskreten Modus ohne Namen.
struct SnapshotStore {
  static let appGroup = "group.space.mai.maiDoctorHub"
  private static let keySnapshot = "snapshot"
  private static let keyReceivedAt = "receivedAt"
  private static let keyOutbox = "outbox"
  private static let maxAge: TimeInterval = 2 * 24 * 60 * 60

  private let defaults: UserDefaults

  init() {
    // Ohne App-Gruppe (z. B. unsignierter Build) wenigstens die App selbst.
    defaults = UserDefaults(suiteName: SnapshotStore.appGroup) ?? .standard
  }

  /// Snapshot inkl. eigener, noch offener Eingaben; `nil` = noch keiner.
  func load() -> WatchData? {
    guard let raw = defaults.string(forKey: SnapshotStore.keySnapshot),
      var data = WatchData.parse(raw)
    else { return nil }
    for action in outbox() {
      switch action["type"] as? String {
      case "intake":
        let med = action["med"] as? String
        let at = WatchData.millis(action["at"])
        for i in data.doses.indices
        where data.doses[i].medicationId == med && data.doses[i].atMillis == at
          && !data.doses[i].done
        {
          data.doses[i].status = "taken"
        }
      case "checkin":
        if data.checkIn?.symptomId == action["symptom"] as? String,
          let ts = WatchData.millis(action["ts"])
        {
          data.checkIn?.lastAt = Date(millis: ts)
          data.checkIn?.lastValue = (action["value"] as? NSNumber)?.intValue
        }
      default:
        break
      }
    }
    return data
  }

  var receivedAt: Date? {
    defaults.object(forKey: SnapshotStore.keyReceivedAt) as? Date
  }

  /// Neuer Snapshot vom Telefon. Eingaben, die er schon enthält (oder die
  /// zu alt sind), verlassen den Ausgang.
  func save(_ snapshot: String) {
    guard let data = WatchData.parse(snapshot) else { return }
    let now = Date()
    let remaining = outbox().filter { !SnapshotStore.arrived($0, in: data, now: now) }
    defaults.set(snapshot, forKey: SnapshotStore.keySnapshot)
    defaults.set(now, forKey: SnapshotStore.keyReceivedAt)
    writeOutbox(remaining)
  }

  /// Einnahme an der Uhr abhaken; liefert die Eingabe zum Senden.
  func enqueueIntake(medicationId: String, at: Int64) -> [String: Any] {
    enqueue(["type": "intake", "med": medicationId, "at": NSNumber(value: at)])
  }

  /// Check-in-Wert (0–10) an der Uhr.
  func enqueueCheckIn(symptomId: String, value: Int) -> [String: Any] {
    enqueue(["type": "checkin", "symptom": symptomId, "value": min(max(value, 0), 10)])
  }

  func outbox() -> [[String: Any]] {
    guard let raw = defaults.string(forKey: SnapshotStore.keyOutbox),
      let bytes = raw.data(using: .utf8),
      let list = (try? JSONSerialization.jsonObject(with: bytes)) as? [[String: Any]]
    else { return [] }
    return list
  }

  private func enqueue(_ fields: [String: Any]) -> [String: Any] {
    var action = fields
    action["id"] = UUID().uuidString
    action["ts"] = NSNumber(value: Date().millis)
    writeOutbox(Array((outbox() + [action]).suffix(50)))
    return action
  }

  private func writeOutbox(_ list: [[String: Any]]) {
    guard let bytes = try? JSONSerialization.data(withJSONObject: list) else { return }
    defaults.set(String(decoding: bytes, as: UTF8.self), forKey: SnapshotStore.keyOutbox)
  }

  private static func arrived(_ action: [String: Any], in data: WatchData, now: Date) -> Bool {
    guard let ts = WatchData.millis(action["ts"]) else { return true }
    if now.timeIntervalSince(Date(millis: ts)) > maxAge { return true }
    switch action["type"] as? String {
    case "intake":
      let med = action["med"] as? String
      let at = WatchData.millis(action["at"])
      return !data.doses.contains { $0.medicationId == med && $0.atMillis == at && !$0.done }
    case "checkin":
      guard let checkIn = data.checkIn, checkIn.symptomId == action["symptom"] as? String
      else { return true }
      return (checkIn.lastAt?.millis ?? 0) >= ts
    default:
      return true
    }
  }
}
