import Foundation

/// Termin im Snapshot (siehe `widget_snapshot.dart`).
struct WatchAppointment {
  let id: String
  let at: Date
  let end: Date
  let doctor: String?
  let title: String?
}

/// Geplante Einnahme; `status` „taken“/„skipped“, `nil` = offen.
struct WatchDose: Identifiable {
  let medicationId: String
  /// Geplanter Zeitpunkt in Millisekunden (Schlüssel der Einnahme).
  let atMillis: Int64
  var status: String?
  let name: String?
  let dose: String?

  var id: String { "\(medicationId)|\(atMillis)" }
  var at: Date { Date(millis: atMillis) }
  var done: Bool { status != nil }
}

/// Symptom für den Schnell-Check-in.
struct WatchCheckIn {
  let symptomId: String
  let quick: Bool
  let label: String?
  var lastAt: Date?
  var lastValue: Int?
}

/// Inhalt der Uhr-App — derselbe Snapshot wie für die Android-Widgets
/// (`WidgetData.kt`). Im diskreten Modus fehlen alle Klartexte.
struct WatchData {
  let discreet: Bool
  let appointments: [WatchAppointment]
  var doses: [WatchDose]
  let dosesUntil: Date
  var checkIn: WatchCheckIn?

  /// Termine, die noch nicht vorbei sind.
  func upcoming(_ now: Date) -> [WatchAppointment] {
    appointments.filter { $0.end > now }
  }

  /// Einnahmen von heute; `nil`, wenn der Plan nicht so weit reicht.
  func dosesToday(_ now: Date) -> [WatchDose]? {
    guard now < dosesUntil else { return nil }
    return doses.filter { Calendar.current.isDate($0.at, inSameDayAs: now) }
  }

  /// Heute schon eingetragener Check-in.
  func checkInDoneToday(_ now: Date) -> Bool {
    guard let last = checkIn?.lastAt else { return false }
    return Calendar.current.isDate(last, inSameDayAs: now)
  }

  /// Liest den Snapshot tolerant: unbekannte Felder werden ignoriert,
  /// fehlerhafte Einträge übersprungen.
  static func parse(_ raw: String) -> WatchData? {
    guard let bytes = raw.data(using: .utf8),
      let json = (try? JSONSerialization.jsonObject(with: bytes)) as? [String: Any]
    else { return nil }
    // Im diskreten Modus nie Klartext zeigen, auch wenn er enthalten wäre.
    let discreet = (json["discreet"] as? Bool) ?? true
    let appointments: [WatchAppointment] = objects(json["appointments"]).compactMap {
      guard let id = text($0["id"]), let at = millis($0["at"]) else { return nil }
      return WatchAppointment(
        id: id,
        at: Date(millis: at),
        end: Date(millis: millis($0["end"]) ?? (at + 60 * 60 * 1000)),
        doctor: discreet ? nil : text($0["doctor"]),
        title: discreet ? nil : text($0["title"]))
    }
    let doses: [WatchDose] = objects(json["doses"]).compactMap {
      guard let med = text($0["med"]), let at = millis($0["at"]) else { return nil }
      return WatchDose(
        medicationId: med,
        atMillis: at,
        status: text($0["status"]),
        name: discreet ? nil : text($0["name"]),
        dose: discreet ? nil : text($0["dose"]))
    }
    var checkIn: WatchCheckIn?
    if let c = json["checkIn"] as? [String: Any], let symptom = text(c["symptom"]) {
      checkIn = WatchCheckIn(
        symptomId: symptom,
        quick: (c["quick"] as? Bool) ?? false,
        label: discreet ? nil : text(c["label"]),
        lastAt: millis(c["lastAt"]).map { Date(millis: $0) },
        lastValue: millis(c["lastValue"]).map { Int($0) })
    }
    return WatchData(
      discreet: discreet,
      appointments: appointments.sorted { $0.at < $1.at },
      doses: doses.sorted { $0.atMillis < $1.atMillis },
      dosesUntil: Date(millis: millis(json["dosesUntil"]) ?? 0),
      checkIn: checkIn)
  }

  private static func objects(_ value: Any?) -> [[String: Any]] {
    (value as? [Any])?.compactMap { $0 as? [String: Any] } ?? []
  }

  private static func text(_ value: Any?) -> String? {
    guard let s = value as? String, !s.isEmpty else { return nil }
    return s
  }

  static func millis(_ value: Any?) -> Int64? {
    (value as? NSNumber)?.int64Value
  }
}

extension Date {
  init(millis: Int64) {
    self.init(timeIntervalSince1970: TimeInterval(millis) / 1000)
  }

  var millis: Int64 { Int64((timeIntervalSince1970 * 1000).rounded()) }
}
