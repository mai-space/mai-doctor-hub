import Foundation

/// Texte der Uhr-App (Deutsch/Englisch nach Systemsprache, wie die App) und
/// Datumsformate relativ zu „jetzt“ (wie `WidgetFormat.kt`).
enum WatchText {
  static let german = Locale.preferredLanguages.first?.hasPrefix("de") ?? false

  private static func t(_ de: String, _ en: String) -> String { german ? de : en }

  static var appointmentTitle: String { t("Nächster Termin", "Next appointment") }
  static var medsTitle: String { t("Medikamente heute", "Medications today") }
  static var checkInTitle: String { "Check-in" }
  static var appointmentDescription: String {
    t("Datum und Uhrzeit deines nächsten Arzttermins", "Date and time of your next doctor's appointment")
  }
  static var medsDescription: String { t("Einnahmen von heute", "Today's doses") }
  static var checkInDescription: String { t("Heutiger Check-in", "Today's check-in") }

  static var openPhone: String {
    t("Öffne die App „Ärzte“ einmal am iPhone, um das zu laden",
      "Open the Ärzte app on your iPhone once to load this")
  }
  static var queued: String {
    t("Wird eingetragen, sobald du die App am iPhone öffnest",
      "Will be added when you next open the app on your iPhone")
  }
  static var today: String { t("Heute", "Today") }
  static var tomorrow: String { t("Morgen", "Tomorrow") }
  static var now: String { t("Jetzt", "Now") }
  static var soon: String { t("Gleich", "Soon") }
  static func inHours(_ n: Int) -> String {
    german ? "in \(n) Std." : (n == 1 ? "in 1 hour" : "in \(n) hours")
  }
  static func inDays(_ n: Int) -> String {
    german ? (n == 1 ? "in 1 Tag" : "in \(n) Tagen") : (n == 1 ? "in 1 day" : "in \(n) days")
  }

  static var appointmentGeneric: String { t("Arzttermin", "Doctor's appointment") }
  static var noAppointments: String { t("Keine Termine geplant", "No upcoming appointments") }

  static var medsNone: String { t("Heute keine Einnahmen geplant", "No doses planned today") }
  static var medsStale: String {
    t("Öffne die App „Ärzte“ am iPhone, um den Plan zu aktualisieren",
      "Open the Ärzte app on your iPhone to update the plan")
  }
  static func medsTakenOf(_ taken: Int, _ total: Int) -> String {
    german ? "\(taken) von \(total) genommen" : "\(taken) of \(total) taken"
  }
  static func medsNext(_ time: String) -> String { german ? "nächste \(time)" : "next \(time)" }
  static var medsAllDone: String { t("Alles erledigt", "All done") }
  static var doseGeneric: String { t("Einnahme", "Dose") }
  static var doseOpen: String { t("Fällig", "Due") }
  static var doseTaken: String { t("Genommen", "Taken") }
  static var doseSkipped: String { t("Ausgelassen", "Skipped") }
  static func doseMark(_ what: String) -> String {
    german ? "\(what) als genommen markieren" : "Mark \(what) as taken"
  }

  static var checkInQuestion: String { t("Wie geht es dir heute?", "How are you today?") }
  static var checkInNone: String { t("Keine offenen Symptome", "No open symptoms") }
  static func checkInValue(_ v: Int) -> String { german ? "Heute \(v)/10" : "Today \(v)/10" }
  static var checkInDone: String { t("Heute ✓", "Today ✓") }
  static var checkInPending: String { t("Heute offen", "Open today") }
  static var checkInHint: String { t("0 = keine · 10 = am stärksten", "0 = none · 10 = worst") }
  static func checkInRate(_ v: Int) -> String {
    german ? "Stärke \(v) von 10 eintragen" : "Record intensity \(v) of 10"
  }
  static var checkInOnPhone: String {
    t("Diesen Check-in bitte in der App am iPhone machen", "Do this check-in in the app on your iPhone")
  }

  // MARK: - Datum und Uhrzeit

  static func time(_ date: Date) -> String {
    date.formatted(date: .omitted, time: .shortened)
  }

  /// „Heute“, „Morgen“, Wochentag (bis 6 Tage) oder „Do., 16. Okt.“.
  static func day(_ date: Date, now: Date) -> String {
    switch daysBetween(now, date) {
    case 0: return today
    case 1: return tomorrow
    case 2...6: return date.formatted(.dateTime.weekday(.wide))
    default: return date.formatted(.dateTime.weekday(.abbreviated).day().month(.abbreviated))
    }
  }

  /// Sehr kurzer Tag für Komplikationen: „Heute“, „Mo.“, „16.10.“.
  static func shortDay(_ date: Date, now: Date) -> String {
    switch daysBetween(now, date) {
    case 0: return today
    case 1...6: return date.formatted(.dateTime.weekday(.abbreviated))
    default: return date.formatted(.dateTime.day().month(.defaultDigits))
    }
  }

  static func dayTime(_ date: Date, now: Date) -> String {
    "\(day(date, now: now)) · \(time(date))"
  }

  /// Abstand zum Termin; `nil`, wenn der Tag ihn schon sagt (morgen).
  static func countdown(_ appointment: WatchAppointment, now: Date) -> String? {
    if now >= appointment.at { return self.now }
    let days = daysBetween(now, appointment.at)
    if days == 0 {
      let hours = Int(appointment.at.timeIntervalSince(now) / 3600)
      return hours < 1 ? soon : inHours(hours)
    }
    if days < 2 { return nil }
    return inDays(days)
  }

  static func daysBetween(_ from: Date, _ to: Date) -> Int {
    let calendar = Calendar.current
    return calendar.dateComponents(
      [.day], from: calendar.startOfDay(for: from), to: calendar.startOfDay(for: to)
    ).day ?? 0
  }
}
