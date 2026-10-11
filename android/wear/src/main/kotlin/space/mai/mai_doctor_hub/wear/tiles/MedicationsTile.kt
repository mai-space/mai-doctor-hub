package space.mai.mai_doctor_hub.wear.tiles

import androidx.wear.protolayout.LayoutElementBuilders
import space.mai.mai_doctor_hub.wear.OverviewActivity
import space.mai.mai_doctor_hub.wear.R
import space.mai.mai_doctor_hub.wear.WatchData
import space.mai.mai_doctor_hub.wear.WatchFormat
import space.mai.mai_doctor_hub.wear.WatchStore

/**
 * „Medikamente heute“: Stand (2/4), nächste offene Einnahme und ein Knopf
 * zum Abhaken. Diskret: „Einnahme“ statt Medikament.
 */
class MedicationsTile : BaseTile() {
    override fun layout(data: WatchData?, now: Long): LayoutElementBuilders.LayoutElement {
        val section = OverviewActivity.SECTION_MEDICATIONS
        val icon = TileUi.icon(TileUi.ICON_MEDICATION)
        if (data == null) {
            return TileUi.root(this, section, icon, TileUi.gap(), TileUi.hint(getString(R.string.watch_open_phone), 3))
        }
        val today = data.dosesToday(now)
            ?: return TileUi.root(this, section, icon, TileUi.gap(), TileUi.hint(getString(R.string.watch_meds_stale), 3))
        if (today.isEmpty()) {
            return TileUi.root(this, section, icon, TileUi.gap(), TileUi.body(getString(R.string.watch_meds_none)))
        }
        val taken = today.count { it.done }
        val next = today.firstOrNull { !it.done }
            ?: return TileUi.root(
                this,
                section,
                icon,
                TileUi.gap(4f),
                TileUi.headline(getString(R.string.watch_meds_count, taken, today.size)),
                TileUi.body(getString(R.string.watch_meds_all_done)),
            )
        val what = next.name ?: getString(R.string.watch_dose_generic)
        val detail = listOfNotNull(WatchFormat.time(this, next.at), next.dose).joinToString(" · ")
        return TileUi.root(
            this,
            section,
            icon,
            TileUi.gap(4f),
            TileUi.headline(getString(R.string.watch_meds_count, taken, today.size)),
            TileUi.body(what, 1),
            TileUi.hint(detail, 1),
            TileUi.gap(8f),
            TileUi.button(
                getString(R.string.watch_dose_button),
                "$CLICK_INTAKE${next.medicationId}|${next.at}",
                getString(R.string.watch_dose_mark, "$what ${WatchFormat.time(this, next.at)}"),
            ),
        )
    }

    override fun onClick(store: WatchStore, clickId: String): Boolean {
        if (!clickId.startsWith(CLICK_INTAKE)) return false
        val parts = clickId.removePrefix(CLICK_INTAKE).split('|')
        val med = parts.getOrNull(0)?.takeIf { it.isNotEmpty() } ?: return false
        val at = parts.getOrNull(1)?.toLongOrNull() ?: return false
        // Schon erledigt (z. B. Tipp doppelt zugestellt): nichts tun.
        val open = store.load()?.doses?.any { it.medicationId == med && it.at == at && !it.done } == true
        if (!open) return false
        store.enqueueIntake(med, at)
        return true
    }

    private companion object {
        const val CLICK_INTAKE = "intake:"
    }
}
