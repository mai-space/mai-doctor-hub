import SwiftUI

/// Übersicht: nächste Termine, Einnahmen von heute (zum Abhaken) und
/// Check-in (Stärke 0–10).
struct OverviewView: View {
  @EnvironmentObject private var model: WatchModel

  var body: some View {
    TimelineView(.everyMinute) { context in
      List {
        if let data = model.data {
          appointments(data, now: context.date)
          medications(data, now: context.date)
          checkIn(data, now: context.date)
          if model.pending > 0 {
            Text(WatchText.queued).font(.footnote).foregroundStyle(.secondary)
          }
        } else {
          Text(WatchText.openPhone).foregroundStyle(.secondary)
        }
      }
    }
    .onAppear { model.reload() }
  }

  @ViewBuilder
  private func appointments(_ data: WatchData, now: Date) -> some View {
    Section(WatchText.appointmentTitle) {
      let upcoming = Array(data.upcoming(now).prefix(3))
      if upcoming.isEmpty {
        Text(WatchText.noAppointments).foregroundStyle(.secondary)
      }
      ForEach(upcoming, id: \.id) { a in
        VStack(alignment: .leading, spacing: 2) {
          Text(WatchText.dayTime(a.at, now: now)).font(.headline)
          Text(a.doctor ?? a.title ?? WatchText.appointmentGeneric)
            .font(.footnote)
            .foregroundStyle(.secondary)
          if let countdown = WatchText.countdown(a, now: now) {
            Text(countdown).font(.footnote).foregroundStyle(.tint)
          }
        }
      }
    }
  }

  @ViewBuilder
  private func medications(_ data: WatchData, now: Date) -> some View {
    Section(WatchText.medsTitle) {
      if let today = data.dosesToday(now) {
        if today.isEmpty {
          Text(WatchText.medsNone).foregroundStyle(.secondary)
        } else {
          Text(WatchText.medsTakenOf(today.filter(\.done).count, today.count))
            .font(.footnote)
            .foregroundStyle(.secondary)
          ForEach(today) { dose in doseRow(dose) }
        }
      } else {
        Text(WatchText.medsStale).foregroundStyle(.secondary)
      }
    }
  }

  private func doseRow(_ dose: WatchDose) -> some View {
    let what = dose.name ?? WatchText.doseGeneric
    let status: String
    switch dose.status {
    case nil: status = WatchText.doseOpen
    case "skipped": status = WatchText.doseSkipped
    default: status = WatchText.doseTaken
    }
    return Button {
      model.markTaken(dose)
    } label: {
      HStack {
        Image(systemName: dose.status == nil ? "circle" : dose.status == "skipped" ? "minus.circle" : "checkmark.circle.fill")
          .foregroundStyle(dose.done ? Color.accentColor : Color.primary)
        VStack(alignment: .leading) {
          Text(what).font(.headline).lineLimit(1)
          Text([WatchText.time(dose.at), dose.dose ?? status].joined(separator: " · "))
            .font(.footnote)
            .foregroundStyle(.secondary)
        }
      }
    }
    .disabled(dose.done)
    .accessibilityLabel(dose.done ? "\(what), \(status)" : WatchText.doseMark("\(what) \(WatchText.time(dose.at))"))
  }

  @ViewBuilder
  private func checkIn(_ data: WatchData, now: Date) -> some View {
    Section(WatchText.checkInTitle) {
      if let checkIn = data.checkIn {
        let done = data.checkInDoneToday(now)
        let todayValue = done ? checkIn.lastValue : nil
        if let label = checkIn.label {
          Text(label).font(.headline)
        }
        Text(todayValue.map(WatchText.checkInValue) ?? (done ? WatchText.checkInDone : WatchText.checkInQuestion))
          .foregroundStyle(.secondary)
        if checkIn.quick {
          // 0–10 in drei Reihen (4 · 4 · 3), groß genug zum Tippen.
          ForEach([Array(0...3), Array(4...7), Array(8...10)], id: \.self) { row in
            HStack(spacing: 4) {
              ForEach(row, id: \.self) { value in
                Button("\(value)") {
                  model.checkIn(symptomId: checkIn.symptomId, value: value)
                }
                .buttonStyle(.borderedProminent)
                .tint(value == todayValue ? Color.accentColor : Color.gray)
                .accessibilityLabel(WatchText.checkInRate(value))
              }
            }
            .listRowBackground(Color.clear)
          }
          Text(WatchText.checkInHint).font(.footnote).foregroundStyle(.secondary)
        } else {
          Text(WatchText.checkInOnPhone).font(.footnote).foregroundStyle(.secondary)
        }
      } else {
        Text(WatchText.checkInNone).foregroundStyle(.secondary)
      }
    }
  }
}
