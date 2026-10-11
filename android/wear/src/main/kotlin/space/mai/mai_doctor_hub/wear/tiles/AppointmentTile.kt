package space.mai.mai_doctor_hub.wear.tiles

import androidx.wear.protolayout.LayoutElementBuilders
import space.mai.mai_doctor_hub.wear.OverviewActivity
import space.mai.mai_doctor_hub.wear.R
import space.mai.mai_doctor_hub.wear.WatchData
import space.mai.mai_doctor_hub.wear.WatchFormat

/** „Nächster Termin“: Tag, Uhrzeit, Countdown; Arzt nur außerhalb des
 *  diskreten Modus. */
class AppointmentTile : BaseTile() {
    override fun layout(data: WatchData?, now: Long): LayoutElementBuilders.LayoutElement {
        val section = OverviewActivity.SECTION_APPOINTMENTS
        val icon = TileUi.icon(TileUi.ICON_CALENDAR)
        if (data == null) {
            return TileUi.root(this, section, icon, TileUi.gap(), TileUi.hint(getString(R.string.watch_open_phone), 3))
        }
        val next = data.upcoming(now).firstOrNull()
            ?: return TileUi.root(
                this,
                section,
                icon,
                TileUi.gap(),
                TileUi.body(getString(R.string.watch_no_appointments)),
            )
        val who = next.doctor ?: next.title ?: getString(R.string.watch_appointment_generic)
        val countdown = WatchFormat.countdown(this, next, now)
        return TileUi.root(
            this,
            section,
            icon,
            TileUi.gap(4f),
            TileUi.title(WatchFormat.day(this, next.at, now)),
            TileUi.headline(WatchFormat.time(this, next.at)),
            TileUi.gap(4f),
            TileUi.body(who),
            *(if (countdown != null) arrayOf(TileUi.hint(countdown, 1)) else emptyArray()),
        )
    }
}
