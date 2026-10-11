package space.mai.mai_doctor_hub.widgets

import android.content.Context
import android.util.SizeF
import android.view.View
import android.widget.RemoteViews
import space.mai.mai_doctor_hub.R

/**
 * „Medikamente heute“.
 * - klein: „2/4“ und nächste Uhrzeit
 * - eine Zeile hoch: Stand + Haken für die nächste offene Einnahme
 * - ab zwei Zeilen: Liste zum Abhaken (so viele Zeilen, wie Platz ist)
 * Diskret: „Einnahme“ und Status statt Medikament und Dosis.
 */
class MedicationsWidget : BaseWidgetProvider() {
    override val sizes = listOf(
        SizeF(40f, 40f),
        SizeF(WIDE, 40f),
        SizeF(WIDE, TALL),
        SizeF(WIDE, TALL + ROW),
        SizeF(WIDE, TALL + 2 * ROW),
        SizeF(WIDE, TALL + 3 * ROW),
        SizeF(WIDE, TALL + 4 * ROW),
        SizeF(WIDE, TALL + 6 * ROW),
    )

    override fun build(context: Context, data: WidgetData?, width: Float, height: Float): RemoteViews {
        val now = System.currentTimeMillis()
        val openSheet = WidgetLinks.open(context, "medications")
        if (data == null) {
            return message(context, R.drawable.ic_widget_medication, R.string.widget_open_app, openSheet)
        }
        // Plan reicht nur so weit, wie die App ihn zuletzt geschrieben hat.
        if (now >= data.dosesUntil) {
            return message(context, R.drawable.ic_widget_medication, R.string.widget_meds_stale, openSheet)
        }
        val today = data.doses.filter { WidgetFormat.sameDay(now, it.at) }
        if (today.isEmpty()) {
            return message(context, R.drawable.ic_widget_medication, R.string.widget_meds_none, openSheet)
        }
        val taken = today.count { it.done }
        val next = today.firstOrNull { !it.done }
        val nextText = next?.let {
            context.getString(R.string.widget_meds_next, WidgetFormat.time(context, it.at))
        } ?: context.getString(R.string.widget_meds_all_done)

        if (width < WIDE) {
            return RemoteViews(context.packageName, R.layout.widget_meds_compact).apply {
                setTextViewText(R.id.widget_count, context.getString(R.string.widget_meds_count, taken, today.size))
                setTextViewText(R.id.widget_subtitle, nextText)
                setOnClickPendingIntent(android.R.id.background, openSheet)
            }
        }
        if (height < TALL) {
            return RemoteViews(context.packageName, R.layout.widget_meds_wide).apply {
                setTextViewText(
                    R.id.widget_subtitle,
                    context.getString(R.string.widget_meds_taken_of, taken, today.size) + " · " + nextText,
                )
                setOnClickPendingIntent(android.R.id.background, openSheet)
                if (next == null) {
                    setImageViewResource(R.id.widget_status, R.drawable.ic_widget_checked)
                    setContentDescription(R.id.widget_status, context.getString(R.string.widget_meds_all_done))
                    setOnClickPendingIntent(R.id.widget_status, openSheet)
                } else {
                    setImageViewResource(R.id.widget_status, R.drawable.ic_widget_unchecked)
                    setContentDescription(R.id.widget_status, markLabel(context, next))
                    setOnClickPendingIntent(
                        R.id.widget_status,
                        WidgetLinks.intake(context, next.medicationId, next.at),
                    )
                }
            }
        }
        return RemoteViews(context.packageName, R.layout.widget_meds_list).apply {
            setTextViewText(R.id.widget_count, context.getString(R.string.widget_meds_count, taken, today.size))
            setOnClickPendingIntent(R.id.widget_header, openSheet)
            removeAllViews(R.id.widget_list)
            var rows = ((height - HEADER) / ROW).toInt().coerceAtLeast(1)
            if (today.size > rows) rows = (rows - 1).coerceAtLeast(1) // Platz für „+N weitere“
            // Fenster ab der ersten offenen Einnahme (Erledigtes rutscht raus).
            val firstOpen = today.indexOfFirst { !it.done }.let { if (it < 0) today.size else it }
            val start = firstOpen.coerceAtMost((today.size - rows).coerceAtLeast(0))
            val shown = today.drop(start).take(rows)
            for (dose in shown) addView(R.id.widget_list, row(context, data.discreet, dose, openSheet))
            val hidden = today.size - shown.size
            setViewVisibility(R.id.widget_more, if (hidden > 0) View.VISIBLE else View.GONE)
            setTextViewText(R.id.widget_more, context.getString(R.string.widget_meds_more, hidden))
            setOnClickPendingIntent(R.id.widget_more, openSheet)
        }
    }

    private fun row(
        context: Context,
        discreet: Boolean,
        dose: WidgetDose,
        openSheet: android.app.PendingIntent,
    ): RemoteViews = RemoteViews(context.packageName, R.layout.widget_meds_item).apply {
        val status = context.getString(
            when (dose.status) {
                null -> R.string.widget_dose_open
                "skipped" -> R.string.widget_dose_skipped
                else -> R.string.widget_dose_taken
            },
        )
        setTextViewText(R.id.widget_time, WidgetFormat.time(context, dose.at))
        setTextViewText(R.id.widget_title, dose.name ?: context.getString(R.string.widget_dose_generic))
        // Diskret bzw. ohne Dosisangabe: Status statt Dosis.
        setTextViewText(R.id.widget_subtitle, if (discreet || dose.dose == null) status else dose.dose)
        setImageViewResource(
            R.id.widget_status,
            when (dose.status) {
                null -> R.drawable.ic_widget_unchecked
                "skipped" -> R.drawable.ic_widget_skipped
                else -> R.drawable.ic_widget_checked
            },
        )
        if (dose.done) {
            setContentDescription(R.id.widget_status, status)
            setOnClickPendingIntent(R.id.widget_item, openSheet)
        } else {
            setContentDescription(R.id.widget_status, markLabel(context, dose))
            setOnClickPendingIntent(R.id.widget_item, WidgetLinks.intake(context, dose.medicationId, dose.at))
        }
    }

    private fun markLabel(context: Context, dose: WidgetDose): String {
        val what = dose.name ?: context.getString(R.string.widget_dose_generic)
        return context.getString(R.string.widget_dose_mark, "$what ${WidgetFormat.time(context, dose.at)}")
    }

    private companion object {
        const val WIDE = 150f
        const val TALL = 110f
        const val HEADER = 56f
        const val ROW = 40f
    }
}
