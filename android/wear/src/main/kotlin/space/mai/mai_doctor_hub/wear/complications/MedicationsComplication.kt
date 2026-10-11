package space.mai.mai_doctor_hub.wear.complications

import androidx.wear.watchface.complications.data.ComplicationData
import androidx.wear.watchface.complications.data.ComplicationType
import androidx.wear.watchface.complications.data.RangedValueComplicationData
import space.mai.mai_doctor_hub.wear.OverviewActivity
import space.mai.mai_doctor_hub.wear.R
import space.mai.mai_doctor_hub.wear.WatchData
import space.mai.mai_doctor_hub.wear.WatchFormat

/** Medikamente heute: Ring „2/4“, kurz „2/4 · 14:00“, lang mit Text. */
class MedicationsComplication : BaseComplication() {
    override val iconRes = R.drawable.ic_medication
    override val section = OverviewActivity.SECTION_MEDICATIONS

    override fun build(type: ComplicationType, data: WatchData, now: Long): ComplicationData? {
        val today = data.dosesToday(now) ?: return null
        if (today.isEmpty()) {
            return if (type == ComplicationType.RANGED_VALUE) {
                null
            } else {
                textData(
                    type,
                    if (type == ComplicationType.SHORT_TEXT) "–" else getString(R.string.watch_meds_none),
                    null,
                    getString(R.string.watch_meds_none),
                )
            }
        }
        val taken = today.count { it.done }
        val next = today.firstOrNull { !it.done }
        return content(
            type,
            taken,
            today.size,
            next?.let { WatchFormat.time(this, it.at) },
        )
    }

    override fun preview(type: ComplicationType): ComplicationData? = content(type, 1, 2, "20:00")

    private fun content(type: ComplicationType, taken: Int, total: Int, nextTime: String?): ComplicationData? {
        val count = getString(R.string.watch_meds_count, taken, total)
        val next = nextTime?.let { getString(R.string.watch_meds_next, it) }
            ?: getString(R.string.watch_meds_all_done)
        val description = getString(R.string.watch_meds_taken_of, taken, total) + ", " + next
        return when (type) {
            ComplicationType.RANGED_VALUE -> RangedValueComplicationData.Builder(
                taken.toFloat(),
                0f,
                total.toFloat(),
                plain(description),
            )
                .setText(plain(count))
                .setMonochromaticImage(icon())
                .setTapAction(tap())
                .build()
            ComplicationType.SHORT_TEXT -> textData(type, count, nextTime ?: "✓", description)
            else -> textData(type, getString(R.string.watch_meds_taken_of, taken, total), next, description)
        }
    }
}
