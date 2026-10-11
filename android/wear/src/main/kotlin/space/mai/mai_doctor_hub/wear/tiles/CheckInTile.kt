package space.mai.mai_doctor_hub.wear.tiles

import androidx.wear.protolayout.LayoutElementBuilders
import space.mai.mai_doctor_hub.wear.OverviewActivity
import space.mai.mai_doctor_hub.wear.R
import space.mai.mai_doctor_hub.wear.WatchData

/**
 * „Check-in“: heutiger Wert oder „Heute offen“. Tipp öffnet die Skala auf
 * der Uhr (bzw. den Hinweis, den Check-in am Telefon zu machen).
 */
class CheckInTile : BaseTile() {
    override fun layout(data: WatchData?, now: Long): LayoutElementBuilders.LayoutElement {
        val section = OverviewActivity.SECTION_CHECK_IN
        val icon = TileUi.icon(TileUi.ICON_CHECKIN)
        if (data == null) {
            return TileUi.root(this, section, icon, TileUi.gap(), TileUi.hint(getString(R.string.watch_open_phone), 3))
        }
        val checkIn = data.checkIn
            ?: return TileUi.root(this, section, icon, TileUi.gap(), TileUi.body(getString(R.string.watch_checkin_none)))
        val done = data.checkInDoneToday(now)
        val status = when {
            done && checkIn.lastValue != null -> getString(R.string.watch_checkin_today_value, checkIn.lastValue)
            done -> getString(R.string.watch_checkin_today_done)
            else -> getString(R.string.watch_checkin_pending)
        }
        return TileUi.root(
            this,
            section,
            icon,
            TileUi.gap(4f),
            TileUi.title(checkIn.label ?: getString(R.string.tile_checkin_name)),
            TileUi.headline(status),
            TileUi.gap(4f),
            TileUi.hint(getString(R.string.watch_checkin_question), 1),
        )
    }
}
