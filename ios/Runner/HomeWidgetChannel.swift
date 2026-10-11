import Flutter
import Foundation

/// Kanal `mai/home_widgets` (`home_widget_sync.dart`). Unter iOS gibt es
/// (noch) keine Startbildschirm-Widgets — der Snapshot geht an die Uhr-App.
final class HomeWidgetChannel {
  static let name = "mai/home_widgets"

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "update":
      guard let args = call.arguments as? [String: Any],
        let snapshot = args["snapshot"] as? String
      else {
        result(FlutterError(code: "ARG", message: "snapshot fehlt", details: nil))
        return
      }
      WatchSync.shared.update(snapshot: snapshot, ack: args["ack"] as? [String] ?? [])
      result(nil)
    case "pendingActions":
      result(WatchSync.shared.pendingJSON())
    case "takeLaunchLink":
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
