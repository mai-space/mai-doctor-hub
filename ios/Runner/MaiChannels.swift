import Flutter
import UIKit

/// Registriert die eigenen Methodenkanäle — gleiche Namen, Methoden,
/// Argumente und Fehlercodes wie unter Android (MainActivity.kt), damit der
/// Dart-Code plattformunabhängig bleibt.
final class MaiChannels {
  private let registrar: FlutterPluginRegistrar
  private let device = DeviceChannel()
  private let databaseKey = DatabaseKeyChannel()
  private let calendar = CalendarChannel()
  private let secureWindow = SecureWindowChannel()
  private let documentScanner: DocumentScannerChannel
  private var methodChannels: [FlutterMethodChannel] = []

  init(registrar: FlutterPluginRegistrar) {
    self.registrar = registrar
    documentScanner = DocumentScannerChannel(presenter: { [registrar] in
      MaiChannels.topViewController(from: registrar.viewController)
    })
    let messenger = registrar.messenger()
    bind(DeviceChannel.name, messenger) { [device] call, result in
      device.handle(call, result: result)
    }
    bind(DatabaseKeyChannel.name, messenger) { [databaseKey] call, result in
      databaseKey.handle(call, result: result)
    }
    bind(DocumentScannerChannel.name, messenger) { [documentScanner] call, result in
      documentScanner.handle(call, result: result)
    }
    bind(CalendarChannel.name, messenger) { [calendar] call, result in
      calendar.handle(call, result: result)
    }
    bind(SecureWindowChannel.name, messenger) { [secureWindow] call, result in
      secureWindow.handle(call, result: result)
    }
  }

  private func bind(
    _ name: String,
    _ messenger: FlutterBinaryMessenger,
    _ handler: @escaping FlutterMethodCallHandler
  ) {
    let channel = FlutterMethodChannel(name: name, binaryMessenger: messenger)
    channel.setMethodCallHandler(handler)
    methodChannels.append(channel)
  }

  /// Oberster sichtbarer View-Controller — dort werden Scanner und Kamera
  /// angezeigt. Ohne Registrar-Controller: Wurzel des Schlüsselfensters.
  static func topViewController(from start: UIViewController?) -> UIViewController? {
    var top = start ?? keyWindow()?.rootViewController
    while let presented = top?.presentedViewController, !presented.isBeingDismissed {
      top = presented
    }
    return top
  }

  /// Schlüsselfenster der aktiven Szene (UIScene-Lebenszyklus).
  static func keyWindow() -> UIWindow? {
    let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
    let windows = scenes.flatMap { $0.windows }
    return windows.first(where: { $0.isKeyWindow }) ?? windows.first
  }
}
