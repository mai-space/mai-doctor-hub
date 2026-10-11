package space.mai.mai_doctor_hub.widgets

import android.content.Context
import android.util.SizeF
import android.view.View
import android.widget.RemoteViews
import space.mai.mai_doctor_hub.R

/**
 * „Check-in“ für das zuletzt erfasste offene Symptom.
 * - klein: öffnet den Check-in, zeigt den heutigen Wert
 * - breiter: Skala zum Antippen (5, 6 oder 11 Werte je nach Breite)
 * - ab zwei Zeilen: 0–5 und 6–10 in zwei Reihen, darunter die Legende
 * Messgrößen außer der Stärke (Temperatur, Blutdruck …) und psychische
 * Symptome öffnen immer den vollständigen Check-in in der App.
 * Diskret: „Wie geht es dir heute?“ statt des Symptomnamens.
 */
class CheckInWidget : BaseWidgetProvider() {
    override val sizes = listOf(
        SizeF(40f, 40f),
        SizeF(WIDE, 40f),
        SizeF(SIX, 40f),
        SizeF(ALL, 40f),
        SizeF(WIDE, TWO_ROWS),
        SizeF(WIDE, LEGEND),
    )

    override fun build(context: Context, data: WidgetData?, width: Float, height: Float): RemoteViews {
        val now = System.currentTimeMillis()
        if (data == null) {
            return message(
                context,
                R.drawable.ic_widget_checkin,
                R.string.widget_open_app,
                WidgetLinks.open(context, "checkin"),
            )
        }
        val checkIn = data.checkIn
            ?: return message(
                context,
                R.drawable.ic_widget_checkin,
                R.string.widget_checkin_none,
                WidgetLinks.open(context, "checkin"),
            )
        val openCheckIn = WidgetLinks.open(context, "checkin/${checkIn.symptomId}")
        val doneToday = checkIn.lastAt != null && WidgetFormat.sameDay(now, checkIn.lastAt)
        val todayValue = if (doneToday) checkIn.lastValue else null

        if (width < WIDE) {
            return RemoteViews(context.packageName, R.layout.widget_checkin_compact).apply {
                setTextViewText(
                    R.id.widget_status,
                    when {
                        todayValue != null -> context.getString(R.string.widget_checkin_today_value, todayValue)
                        doneToday -> context.getString(R.string.widget_checkin_today_done)
                        else -> context.getString(R.string.widget_checkin_pending)
                    },
                )
                setOnClickPendingIntent(android.R.id.background, openCheckIn)
            }
        }

        return RemoteViews(context.packageName, R.layout.widget_checkin).apply {
            setTextViewText(
                R.id.widget_title,
                checkIn.label ?: context.getString(R.string.widget_checkin_question),
            )
            setOnClickPendingIntent(R.id.widget_header, openCheckIn)
            val status = when {
                todayValue != null -> context.getString(R.string.widget_checkin_today_value, todayValue)
                doneToday -> context.getString(R.string.widget_checkin_today_done)
                else -> null
            }
            setViewVisibility(R.id.widget_status, if (status == null) View.GONE else View.VISIBLE)
            setTextViewText(R.id.widget_status, status ?: "")
            removeAllViews(R.id.widget_row1)
            removeAllViews(R.id.widget_row2)

            if (!checkIn.quick) {
                setViewVisibility(R.id.widget_row1, View.GONE)
                setViewVisibility(R.id.widget_row2, View.GONE)
                setViewVisibility(R.id.widget_hint, View.GONE)
                setViewVisibility(R.id.widget_start, View.VISIBLE)
                setOnClickPendingIntent(R.id.widget_start, openCheckIn)
                return@apply
            }
            setViewVisibility(R.id.widget_start, View.GONE)
            setViewVisibility(R.id.widget_row1, View.VISIBLE)
            val rows: List<List<Int>> = when {
                height >= TWO_ROWS -> listOf((0..5).toList(), (6..10).toList())
                width >= ALL -> listOf((0..10).toList())
                width >= SIX -> listOf(listOf(0, 2, 4, 6, 8, 10))
                else -> listOf(listOf(0, 3, 5, 7, 10))
            }
            rows.forEachIndexed { index, values ->
                val container = if (index == 0) R.id.widget_row1 else R.id.widget_row2
                for (value in values) {
                    addView(container, button(context, checkIn.symptomId, value, value == todayValue))
                }
            }
            setViewVisibility(R.id.widget_row2, if (rows.size > 1) View.VISIBLE else View.GONE)
            setViewVisibility(R.id.widget_hint, if (height >= LEGEND) View.VISIBLE else View.GONE)
        }
    }

    private fun button(context: Context, symptomId: String, value: Int, selected: Boolean): RemoteViews {
        val layout = if (selected) R.layout.widget_scale_button_selected else R.layout.widget_scale_button
        return RemoteViews(context.packageName, layout).apply {
            setTextViewText(R.id.widget_value, value.toString())
            setContentDescription(R.id.widget_value, context.getString(R.string.widget_checkin_rate, value))
            setOnClickPendingIntent(R.id.widget_value, WidgetLinks.checkIn(context, symptomId, value))
        }
    }

    private companion object {
        const val WIDE = 150f
        const val SIX = 250f
        const val ALL = 340f
        const val TWO_ROWS = 110f
        const val LEGEND = 160f
    }
}
