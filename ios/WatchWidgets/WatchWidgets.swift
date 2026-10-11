import SwiftUI
import WidgetKit

/// Komplikationen der Uhr-App (WidgetKit): nächster Termin, Medikamente
/// heute, Check-in. Daten aus der App-Gruppe ([SnapshotStore]); Namen gibt es
/// nur außerhalb des diskreten Modus und sie werden bei gesperrter Uhr bzw.
/// im Always-on-Modus ausgeblendet (`privacySensitive`).
@main
struct MaiWatchWidgets: WidgetBundle {
  var body: some Widget {
    AppointmentWidget()
    MedicationsWidget()
    CheckInWidget()
  }
}

struct MaiEntry: TimelineEntry {
  let date: Date
  let data: WatchData?
}

struct MaiProvider: TimelineProvider {
  func placeholder(in context: Context) -> MaiEntry {
    MaiEntry(date: Date(), data: nil)
  }

  func getSnapshot(in context: Context, completion: @escaping (MaiEntry) -> Void) {
    completion(MaiEntry(date: Date(), data: SnapshotStore().load()))
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<MaiEntry>) -> Void) {
    let data = SnapshotStore().load()
    let now = Date()
    // Alle 15 Minuten neu (Countdown), dazu der Tageswechsel.
    var dates = (0..<8).map { now.addingTimeInterval(Double($0) * 15 * 60) }
    if let midnight = Calendar.current.nextDate(
      after: now, matching: DateComponents(hour: 0, minute: 0), matchingPolicy: .nextTime)
    {
      dates.append(midnight)
    }
    let entries = dates.sorted().map { MaiEntry(date: $0, data: data) }
    completion(Timeline(entries: entries, policy: .after(now.addingTimeInterval(2 * 60 * 60))))
  }
}

private let families: [WidgetFamily] = [
  .accessoryCircular, .accessoryRectangular, .accessoryInline, .accessoryCorner,
]

// MARK: - Nächster Termin

struct AppointmentWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: "space.mai.appointment", provider: MaiProvider()) { entry in
      AppointmentView(entry: entry)
        .containerBackground(.clear, for: .widget)
    }
    .configurationDisplayName(WatchText.appointmentTitle)
    .description(WatchText.appointmentDescription)
    .supportedFamilies(families)
  }
}

struct AppointmentView: View {
  @Environment(\.widgetFamily) private var family
  let entry: MaiEntry

  var body: some View {
    let next = entry.data?.upcoming(entry.date).first
    let time = next.map { WatchText.time($0.at) } ?? "–"
    let day = next.map { WatchText.shortDay($0.at, now: entry.date) } ?? ""
    let who = next.map { $0.doctor ?? $0.title ?? WatchText.appointmentGeneric }
    switch family {
    case .accessoryCircular:
      VStack(spacing: 0) {
        Image(systemName: "calendar").font(.caption2)
        Text(time).font(.system(.caption, design: .rounded).weight(.semibold)).minimumScaleFactor(0.6)
        Text(day).font(.caption2).minimumScaleFactor(0.6)
      }
    case .accessoryInline:
      if let next {
        Text("\(Image(systemName: "calendar")) \(WatchText.dayTime(next.at, now: entry.date))")
      } else {
        Text(entry.data == nil ? WatchText.appointmentTitle : WatchText.noAppointments)
      }
    case .accessoryCorner:
      Image(systemName: "calendar")
        .font(.title3)
        .widgetLabel(next.map { WatchText.dayTime($0.at, now: entry.date) } ?? WatchText.noAppointments)
    default:
      VStack(alignment: .leading, spacing: 1) {
        Label(WatchText.appointmentTitle, systemImage: "calendar")
          .font(.caption2)
          .foregroundStyle(.secondary)
        if let next {
          Text(WatchText.dayTime(next.at, now: entry.date)).font(.headline).lineLimit(1)
          Text(who ?? WatchText.appointmentGeneric).lineLimit(1).privacySensitive()
        } else {
          Text(entry.data == nil ? WatchText.openPhone : WatchText.noAppointments)
            .font(.footnote)
            .lineLimit(2)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

// MARK: - Medikamente heute

struct MedicationsWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: "space.mai.medications", provider: MaiProvider()) { entry in
      MedicationsView(entry: entry)
        .containerBackground(.clear, for: .widget)
    }
    .configurationDisplayName(WatchText.medsTitle)
    .description(WatchText.medsDescription)
    .supportedFamilies(families)
  }
}

struct MedicationsView: View {
  @Environment(\.widgetFamily) private var family
  let entry: MaiEntry

  var body: some View {
    let today = entry.data?.dosesToday(entry.date)
    let total = today?.count ?? 0
    let taken = today?.filter(\.done).count ?? 0
    let next = today?.first { !$0.done }
    let count = total > 0 ? "\(taken)/\(total)" : "–"
    let nextText = next.map { WatchText.medsNext(WatchText.time($0.at)) } ?? WatchText.medsAllDone
    switch family {
    case .accessoryCircular:
      Gauge(value: Double(taken), in: 0...Double(max(total, 1))) {
        Image(systemName: "pills")
      } currentValueLabel: {
        Text(count)
      }
      .gaugeStyle(.accessoryCircularCapacity)
    case .accessoryInline:
      Text("\(Image(systemName: "pills")) \(total > 0 ? "\(count) · \(nextText)" : WatchText.medsNone)")
    case .accessoryCorner:
      Text(count)
        .widgetCurvesContent()
        .widgetLabel {
          Gauge(value: Double(taken), in: 0...Double(max(total, 1))) {
            Text(WatchText.medsTitle)
          }
        }
    default:
      VStack(alignment: .leading, spacing: 1) {
        Label(WatchText.medsTitle, systemImage: "pills")
          .font(.caption2)
          .foregroundStyle(.secondary)
        if let today {
          if today.isEmpty {
            Text(WatchText.medsNone).font(.footnote).lineLimit(2)
          } else {
            Text(WatchText.medsTakenOf(taken, total)).font(.headline).lineLimit(1)
            if let next {
              Text("\(WatchText.time(next.at)) · \(next.name ?? WatchText.doseGeneric)")
                .lineLimit(1)
                .privacySensitive()
            } else {
              Text(WatchText.medsAllDone).lineLimit(1)
            }
          }
        } else {
          Text(entry.data == nil ? WatchText.openPhone : WatchText.medsStale)
            .font(.footnote)
            .lineLimit(2)
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}

// MARK: - Check-in

struct CheckInWidget: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: "space.mai.checkin", provider: MaiProvider()) { entry in
      CheckInView(entry: entry)
        .containerBackground(.clear, for: .widget)
    }
    .configurationDisplayName(WatchText.checkInTitle)
    .description(WatchText.checkInDescription)
    .supportedFamilies(families)
  }
}

struct CheckInView: View {
  @Environment(\.widgetFamily) private var family
  let entry: MaiEntry

  var body: some View {
    let checkIn = entry.data?.checkIn
    let done = entry.data?.checkInDoneToday(entry.date) ?? false
    let value = done ? checkIn?.lastValue : nil
    let short = value.map(String.init) ?? (done ? "✓" : "–")
    let status: String = {
      guard checkIn != nil else { return WatchText.checkInNone }
      if let value { return WatchText.checkInValue(value) }
      return done ? WatchText.checkInDone : WatchText.checkInPending
    }()
    switch family {
    case .accessoryCircular:
      VStack(spacing: 0) {
        Image(systemName: "heart.text.square").font(.caption2)
        Text(short).font(.system(.title3, design: .rounded).weight(.semibold))
      }
    case .accessoryInline:
      Text("\(Image(systemName: "heart.text.square")) \(status)")
    case .accessoryCorner:
      Text(short)
        .widgetCurvesContent()
        .widgetLabel(status)
    default:
      VStack(alignment: .leading, spacing: 1) {
        Label(WatchText.checkInTitle, systemImage: "heart.text.square")
          .font(.caption2)
          .foregroundStyle(.secondary)
        if let label = checkIn?.label {
          Text(label).lineLimit(1).privacySensitive()
        }
        Text(entry.data == nil ? WatchText.openPhone : status).font(.headline).lineLimit(2)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }
}
