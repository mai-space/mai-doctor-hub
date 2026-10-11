package space.mai.mai_doctor_hub.wear.complications

import androidx.wear.watchface.complications.data.ComplicationData
import androidx.wear.watchface.complications.data.ComplicationType
import space.mai.mai_doctor_hub.wear.OverviewActivity
import space.mai.mai_doctor_hub.wear.R
import space.mai.mai_doctor_hub.wear.WatchData

/** Check-in: heutiger Wert („3“) oder offen („–“); Tipp öffnet die Skala. */
class CheckInComplication : BaseComplication() {
    override val iconRes = R.drawable.ic_checkin
    override val section = OverviewActivity.SECTION_CHECK_IN

    override fun build(type: ComplicationType, data: WatchData, now: Long): ComplicationData? {
        val checkIn = data.checkIn ?: return null
        val done = data.checkInDoneToday(now)
        val status = when {
            done && checkIn.lastValue != null -> getString(R.string.watch_checkin_today_value, checkIn.lastValue)
            done -> getString(R.string.watch_checkin_today_done)
            else -> getString(R.string.watch_checkin_pending)
        }
        val short = when {
            done && checkIn.lastValue != null -> checkIn.lastValue.toString()
            done -> "✓"
            else -> "–"
        }
        return when (type) {
            ComplicationType.SHORT_TEXT -> textData(type, short, getString(R.string.tile_checkin_name), status)
            else -> textData(type, status, checkIn.label ?: getString(R.string.tile_checkin_name), status)
        }
    }

    override fun preview(type: ComplicationType): ComplicationData? = when (type) {
        ComplicationType.SHORT_TEXT -> textData(type, "3", getString(R.string.tile_checkin_name), "3/10")
        else -> textData(
            type,
            getString(R.string.watch_checkin_today_value, 3),
            getString(R.string.tile_checkin_name),
            "3/10",
        )
    }
}
