import EventKit
import Flutter
import Foundation

/// Einseitiger Export in den Gerätekalender (EventKit; Gegenstück zu
/// CalendarChannel.kt).
///
/// Schreibt nur Events, deren ID die App selbst gespeichert hat; liest keine
/// fremden Events. iCloud-/Google-/Exchange-Kalender synchronisiert iOS selbst.
final class CalendarChannel {
  static let name = "mai/calendar"

  private let store = EKEventStore()
  private let queue = DispatchQueue(label: "space.mai.calendar")

  private struct CalendarError: LocalizedError {
    let message: String
    var errorDescription: String? { message }
  }

  func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let args = call.arguments as? [String: Any] ?? [:]
    switch call.method {
    case "hasPermission":
      result(Self.hasPermission())
    case "requestPermission":
      requestPermission(result)
    case "listCalendars":
      background(result) { self.listCalendars() }
    case "upsertEvent":
      background(result) { try self.upsertEvent(args) }
    case "deleteEvent":
      background(result) { try self.deleteEvent(Self.string(args, "eventId")) }
    case "requestSync":
      background(result) { self.requestSync(Self.string(args, "calendarId")) }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  /// Voller Zugriff nötig: Kalender auflisten und eigene Events wiederfinden.
  static func hasPermission() -> Bool {
    let status = EKEventStore.authorizationStatus(for: .event)
    if #available(iOS 17.0, *) {
      return status == .fullAccess
    }
    return status == .authorized
  }

  private func requestPermission(_ result: @escaping FlutterResult) {
    if Self.hasPermission() {
      result(true)
      return
    }
    let done: (Bool, Error?) -> Void = { [weak self] granted, _ in
      // Nach der Freigabe sieht ein bestehender Store die Kalender erst
      // nach reset() zuverlässig.
      if granted { self?.queue.async { self?.store.reset() } }
      DispatchQueue.main.async { result(granted && Self.hasPermission()) }
    }
    if #available(iOS 17.0, *) {
      store.requestFullAccessToEvents(completion: done)
    } else {
      store.requestAccess(to: .event, completion: done)
    }
  }

  private func background(_ result: @escaping FlutterResult, _ task: @escaping () throws -> Any?) {
    guard Self.hasPermission() else {
      result(FlutterError(code: "permission", message: "Kalenderzugriff nicht erlaubt", details: nil))
      return
    }
    queue.async {
      let value: Any?
      do {
        value = try task()
      } catch {
        value = FlutterError(code: "calendar", message: error.localizedDescription, details: nil)
      }
      DispatchQueue.main.async { result(value) }
    }
  }

  private static func string(_ args: [String: Any], _ key: String) -> String {
    return args[key] as? String ?? ""
  }

  private func listCalendars() -> [[String: Any]] {
    let primary = store.defaultCalendarForNewEvents?.calendarIdentifier
    // Nur Kalender, in die wir schreiben dürfen.
    return store.calendars(for: .event)
      .filter { $0.allowsContentModifications }
      .map { calendar -> [String: Any] in
        [
          "id": calendar.calendarIdentifier,
          "name": calendar.title,
          "accountName": calendar.source?.title ?? "",
          "accountType": Self.accountType(calendar),
          "isPrimary": calendar.calendarIdentifier == primary,
        ]
      }
  }

  /// Kontotyp in der Schreibweise, die Dart kennt (`com.google` = Google).
  private static func accountType(_ calendar: EKCalendar) -> String {
    guard let source = calendar.source else { return "" }
    switch source.sourceType {
    case .local:
      return "local"
    case .exchange:
      return "exchange"
    case .calDAV:
      // Google-Konten erscheinen unter iOS als CalDAV-Quelle „Gmail“/„Google“.
      let title = source.title.lowercased()
      return title.contains("gmail") || title.contains("google") ? "com.google" : "caldav"
    case .mobileMe:
      return "icloud"
    case .subscribed:
      return "subscribed"
    case .birthdays:
      return "birthdays"
    @unknown default:
      return "other"
    }
  }

  private func upsertEvent(_ args: [String: Any]) throws -> String {
    let calendarId = Self.string(args, "calendarId")
    guard let calendar = store.calendar(withIdentifier: calendarId) else {
      throw CalendarError(message: "Kalender nicht gefunden")
    }
    guard let start = (args["start"] as? NSNumber)?.doubleValue,
      let end = (args["end"] as? NSNumber)?.doubleValue
    else {
      throw CalendarError(message: "Start/Ende fehlen")
    }
    // Gibt es das Event noch in diesem Kalender? Sonst neu anlegen.
    var event: EKEvent?
    if let existing = args["eventId"] as? String, !existing.isEmpty,
      let found = store.event(withIdentifier: existing),
      found.calendar?.calendarIdentifier == calendarId
    {
      event = found
    }
    let target = event ?? EKEvent(eventStore: store)
    target.calendar = calendar
    target.title = args["title"] as? String ?? ""
    target.notes = args["description"] as? String
    target.location = args["location"] as? String
    // Zeitpunkte kommen absolut (ms seit Epoch); die Zone bestimmt nur die
    // Anzeige im Kalender.
    target.startDate = Date(timeIntervalSince1970: start / 1000)
    target.endDate = Date(timeIntervalSince1970: end / 1000)
    let zone = args["timeZone"] as? String
    target.timeZone = zone.flatMap { TimeZone(identifier: $0) } ?? TimeZone.current
    try store.save(target, span: .thisEvent, commit: true)
    guard let id = target.eventIdentifier, !id.isEmpty else {
      throw CalendarError(message: "Event konnte nicht angelegt werden")
    }
    return id
  }

  private func deleteEvent(_ eventId: String) throws -> Bool {
    guard !eventId.isEmpty, let event = store.event(withIdentifier: eventId) else {
      return false
    }
    try store.remove(event, span: .thisEvent, commit: true)
    return true
  }

  /// Konten neu abgleichen lassen (iOS entscheidet selbst über den Zeitpunkt).
  private func requestSync(_ calendarId: String) -> Bool {
    guard let calendar = store.calendar(withIdentifier: calendarId),
      calendar.source?.sourceType != .local
    else { return false }
    store.refreshSourcesIfNecessary()
    return true
  }
}
