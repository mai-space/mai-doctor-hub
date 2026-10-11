import SwiftUI

/// Uhr-App „Ärzte“ (watchOS): kurze Übersicht; die Komplikationen liegen in
/// der Widget-Erweiterung „WatchWidgets“.
@main
struct MaiWatchApp: App {
  @StateObject private var model = WatchModel.shared

  var body: some Scene {
    WindowGroup {
      OverviewView()
        .environmentObject(model)
    }
  }
}
