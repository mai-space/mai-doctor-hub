package space.mai.mai_doctor_hub.widgets

import android.content.Context
import android.util.SizeF
import android.view.View
import android.widget.RemoteViews
import space.mai.mai_doctor_hub.R

/**
 * „Nächster Termin“.
 * - schmal (1×1): Tag + Uhrzeit
 * - eine Zeile hoch: „Morgen · 09:30“, Arzt/Titel, ab ~4 Spalten Countdown
 * - ab zwei Zeilen: groß, darunter je nach Höhe die folgenden Termine
 * Diskret: „Arzttermin“ statt Arzt und Titel.
 */
class AppointmentWidget : BaseWidgetProvider() {
    override val sizes = listOf(
        SizeF(40f, 40f),
        SizeF(WIDE, 40f),
        SizeF(COUNTDOWN, 40f),
        SizeF(WIDE, TALL),
        SizeF(WIDE, TALL + ROW),
        SizeF(WIDE, TALL + 2 * ROW),
        SizeF(WIDE, TALL + 3 * ROW),
    )

    override fun build(context: Context, data: WidgetData?, width: Float, height: Float): RemoteViews {
        val now = System.currentTimeMillis()
        if (data == null) {
            return message(
                context,
                R.drawable.ic_widget_calendar,
                R.string.widget_open_app,
                WidgetLinks.open(context, "appointments"),
            )
        }
        val upcoming = data.appointments.filter { it.end > now }
        val next = upcoming.firstOrNull()
            ?: return message(
                context,
                R.drawable.ic_widget_calendar,
                R.string.widget_no_appointments,
                WidgetLinks.open(context, "appointments"),
            )
        val click = WidgetLinks.open(context, "appointment/${next.id}")
        val day = WidgetFormat.day(context, next.at, now)
        val time = WidgetFormat.time(context, next.at)
        val countdown = WidgetFormat.countdown(context, next, now)

        if (width < WIDE) {
            return RemoteViews(context.packageName, R.layout.widget_appointment_compact).apply {
                setTextViewText(R.id.widget_day, day)
                setTextViewText(R.id.widget_time, time)
                setOnClickPendingIntent(android.R.id.background, click)
            }
        }
        if (height < TALL) {
            return RemoteViews(context.packageName, R.layout.widget_appointment_wide).apply {
                setTextViewText(R.id.widget_when, context.getString(R.string.widget_date_time, day, time))
                setTextViewText(R.id.widget_subtitle, subtitle(context, next))
                showCountdown(this, if (width >= COUNTDOWN) countdown else null)
                setOnClickPendingIntent(android.R.id.background, click)
            }
        }
        return RemoteViews(context.packageName, R.layout.widget_appointment_large).apply {
            setTextViewText(R.id.widget_day, day)
            setTextViewText(R.id.widget_time, time)
            setTextViewText(R.id.widget_subtitle, subtitle(context, next))
            showCountdown(this, countdown)
            setOnClickPendingIntent(android.R.id.background, click)
            removeAllViews(R.id.widget_list)
            val rows = ((height - TALL) / ROW).toInt().coerceIn(0, 3)
            for (a in upcoming.drop(1).take(rows)) {
                val item = RemoteViews(context.packageName, R.layout.widget_appointment_item)
                item.setTextViewText(R.id.widget_when, WidgetFormat.dayTime(context, a.at, now))
                item.setTextViewText(R.id.widget_subtitle, subtitle(context, a))
                item.setOnClickPendingIntent(R.id.widget_item, WidgetLinks.open(context, "appointment/${a.id}"))
                addView(R.id.widget_list, item)
            }
        }
    }

    private fun subtitle(context: Context, a: WidgetAppointment): String {
        val parts = listOfNotNull(a.doctor, a.title)
        return if (parts.isEmpty()) {
            context.getString(R.string.widget_appointment_generic)
        } else {
            parts.joinToString(" · ")
        }
    }

    private fun showCountdown(views: RemoteViews, text: String?) {
        views.setViewVisibility(R.id.widget_countdown, if (text == null) View.GONE else View.VISIBLE)
        views.setTextViewText(R.id.widget_countdown, text ?: "")
    }

    private companion object {
        /** Ab dieser Breite (dp) Text neben dem Symbol. */
        const val WIDE = 150f

        /** Ab dieser Breite (dp) zusätzlich der Countdown. */
        const val COUNTDOWN = 250f

        /** Ab dieser Höhe (dp) die große Ansicht. */
        const val TALL = 140f

        /** Höhe (dp) je weiterem Termin. */
        const val ROW = 36f
    }
}
