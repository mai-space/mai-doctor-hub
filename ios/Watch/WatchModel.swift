import Foundation
import WatchConnectivity
import WidgetKit

/// Stand der Uhr-App: Snapshot vom iPhone (WatchConnectivity) und Eingaben an
/// der Uhr, die per `transferUserInfo` zuverlässig nachgereicht werden.
final class WatchModel: NSObject, ObservableObject, WCSessionDelegate {
  static let shared = WatchModel()

  @Published private(set) var data: WatchData?
  @Published private(set) var pending = 0

  private let store = SnapshotStore()

  override init() {
    super.init()
    reload()
    if WCSession.isSupported() {
      let session = WCSession.default
      session.delegate = self
      session.activate()
    }
  }

  func reload() {
    data = store.load()
    pending = store.outbox().count
  }

  /// Einnahme abhaken (erscheint sofort, das iPhone trägt sie nach).
  func markTaken(_ dose: WatchDose) {
    send(store.enqueueIntake(medicationId: dose.medicationId, at: dose.atMillis))
  }

  /// Check-in-Wert 0–10.
  func checkIn(symptomId: String, value: Int) {
    send(store.enqueueCheckIn(symptomId: symptomId, value: value))
  }

  private func send(_ action: [String: Any]) {
    reload()
    WidgetCenter.shared.reloadAllTimelines()
    guard WCSession.isSupported(),
      WCSession.default.activationState == .activated,
      let bytes = try? JSONSerialization.data(withJSONObject: action)
    else { return }
    WCSession.default.transferUserInfo(["action": String(decoding: bytes, as: UTF8.self)])
  }

  private func receive(_ context: [String: Any]) {
    guard let snapshot = context["snapshot"] as? String else { return }
    store.save(snapshot)
    WidgetCenter.shared.reloadAllTimelines()
    DispatchQueue.main.async { self.reload() }
  }

  // MARK: - WCSessionDelegate

  func session(
    _ session: WCSession,
    activationDidCompleteWith activationState: WCSessionActivationState,
    error: Error?
  ) {
    receive(session.receivedApplicationContext)
  }

  func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
    receive(applicationContext)
  }
}
