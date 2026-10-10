import Flutter
import UIKit

/// Kanal „mai/secure_window“ (Gegenstück zu `FLAG_SECURE` unter Android).
///
/// iOS erlaubt kein Sperren von Screenshots. Stattdessen wird der Inhalt
/// verdeckt, sobald die App inaktiv wird — so landet im App-Umschalter nur
/// eine neutrale Fläche statt Gesundheitsdaten.
final class SecureWindowChannel {
  static let name = "mai/secure_window"

  private var secure = false
  private var cover: UIView?
  private var observers: [NSObjectProtocol] = []

  init() {
    let center = NotificationCenter.default
    let hide: (Notification) -> Void = { [weak self] _ in self?.showCover() }
    let show: (Notification) -> Void = { [weak self] _ in self?.removeCover() }
    // Szenen- und App-Ereignisse: je nach Lebenszyklus kommt eines davon
    // zuerst; doppeltes Verdecken ist harmlos.
    observers = [
      center.addObserver(
        forName: UIScene.willDeactivateNotification, object: nil, queue: .main, using: hide),
      center.addObserver(
        forName: UIApplication.willResignActiveNotification, object: nil, queue: .main,
        using: hide),
      center.addObserver(
        forName: UIScene.didActivateNotification, object: nil, queue: .main, using: show),
      center.addObserver(
        forName: UIApplication.didBecomeActiveNotification, object: nil, queue: .main,
        using: show),
    ]
  }

  deinit {
    observers.forEach { NotificationCenter.default.removeObserver($0) }
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "setSecure":
      secure = (call.arguments as? Bool) == true
      if !secure { removeCover() }
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func showCover() {
    guard secure, cover == nil, let window = MaiChannels.keyWindow() else { return }
    let view = UIView(frame: window.bounds)
    view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.backgroundColor = .systemBackground
    let icon = UIImageView(image: UIImage(systemName: "lock.fill"))
    icon.tintColor = .secondaryLabel
    icon.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(icon)
    NSLayoutConstraint.activate([
      icon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      icon.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      icon.widthAnchor.constraint(equalToConstant: 44),
      icon.heightAnchor.constraint(equalToConstant: 52),
    ])
    icon.contentMode = .scaleAspectFit
    window.addSubview(view)
    cover = view
  }

  private func removeCover() {
    cover?.removeFromSuperview()
    cover = nil
  }
}
