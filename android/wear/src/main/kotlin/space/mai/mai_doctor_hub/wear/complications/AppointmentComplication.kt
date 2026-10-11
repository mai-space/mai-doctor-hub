package space.mai.mai_doctor_hub.wear.complications

import androidx.wear.watchface.complications.data.ComplicationData
import androidx.wear.watchface.complications.data.ComplicationType
import space.mai.mai_doctor_hub.wear.OverviewActivity
import space.mai.mai_doctor_hub.wear.R
import space.mai.mai_doctor_hub.wear.WatchData
import space.mai.mai_doctor_hub.wear.WatchFormat

/** Nächster Termin: kurz „10:30 / Mo.“, lang „Morgen · 10:30 / Dr. …“. */
class AppointmentComplication : BaseComplication() {
    override val iconRes = R.drawable.ic_calendar
    override val section = OverviewActivity.SECTION_APPOINTMENTS

    override fun build(type: ComplicationType, data: WatchData, now: Long): ComplicationData? {
        val next = data.upcoming(now).firstOrNull()
            ?: return textData(
                type,
                if (type == ComplicationType.SHORT_TEXT) "–" else getString(R.string.watch_no_appointments),
                null,
                getString(R.string.watch_no_appointments),
            )
        val who = next.doctor ?: next.title ?: getString(R.string.watch_appointment_generic)
        val time = WatchFormat.time(this, next.at)
        return when (type) {
            ComplicationType.SHORT_TEXT -> textData(
                type,
                time,
                WatchFormat.shortDay(this, next.at, now),
                "$who, ${WatchFormat.dayTime(this, next.at, now)}",
            )
            else -> textData(
                type,
                WatchFormat.dayTime(this, next.at, now),
                who,
                "$who, ${WatchFormat.dayTime(this, next.at, now)}",
            )
        }
    }

    override fun preview(type: ComplicationType): ComplicationData? = textData(
        type,
        "10:30",
        if (type == ComplicationType.SHORT_TEXT) getString(R.string.watch_today) else getString(R.string.watch_appointment_generic),
        getString(R.string.watch_appointment_generic),
    )
}
