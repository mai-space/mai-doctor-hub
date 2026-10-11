package space.mai.mai_doctor_hub.wear

import android.content.Context
import android.text.format.DateFormat
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale

/** Datum/Uhrzeit — relativ zu „jetzt“, in Gerätesprache (wie `WidgetFormat.kt`). */
object WatchFormat {
    private const val DAY_MS = 24 * 60 * 60 * 1000L

    private fun locale(context: Context): Locale =
        context.resources.configuration.locales[0] ?: Locale.getDefault()

    /** Uhrzeit nach Geräteeinstellung (12/24 h). */
    fun time(context: Context, at: Long): String =
        DateFormat.getTimeFormat(context).format(Date(at))

    /** „Heute“, „Morgen“, Wochentag (bis 6 Tage) oder „Do., 16. Okt.“. */
    fun day(context: Context, at: Long, now: Long): String {
        val locale = locale(context)
        return when (val days = daysBetween(now, at)) {
            0 -> context.getString(R.string.watch_today)
            1 -> context.getString(R.string.watch_tomorrow)
            in 2..6 -> SimpleDateFormat("EEEE", locale).format(Date(at))
            else -> {
                val pattern = DateFormat.getBestDateTimePattern(
                    locale,
                    if (days > 300) "EEEdMMMy" else "EEEdMMM",
                )
                SimpleDateFormat(pattern, locale).format(Date(at))
            }
        }
    }

    /** Sehr kurzer Tag für Komplikationen: „Heute“, „Mo.“, „16.10.“. */
    fun shortDay(context: Context, at: Long, now: Long): String {
        val locale = locale(context)
        return when (daysBetween(now, at)) {
            0 -> context.getString(R.string.watch_today)
            in 1..6 -> SimpleDateFormat("EEE", locale).format(Date(at))
            else -> SimpleDateFormat(DateFormat.getBestDateTimePattern(locale, "dM"), locale)
                .format(Date(at))
        }
    }

    /** „Morgen · 10:00“. */
    fun dayTime(context: Context, at: Long, now: Long): String =
        context.getString(R.string.watch_date_time, day(context, at, now), time(context, at))

    /** Abstand zum Termin; `null`, wenn der Tag ihn schon sagt (morgen). */
    fun countdown(context: Context, appointment: WatchAppointment, now: Long): String? {
        if (now >= appointment.at) return context.getString(R.string.watch_running)
        val days = daysBetween(now, appointment.at)
        if (days == 0) {
            val hours = ((appointment.at - now) / (60 * 60 * 1000L)).toInt()
            return if (hours < 1) {
                context.getString(R.string.watch_soon)
            } else {
                context.resources.getQuantityString(R.plurals.watch_in_hours, hours, hours)
            }
        }
        if (days < 2) return null
        return context.resources.getQuantityString(R.plurals.watch_in_days, days, days)
    }

    fun sameDay(a: Long, b: Long) = daysBetween(a, b) == 0

    /** Kalendertage zwischen [from] und [to] (lokale Zeit, sommerzeitfest). */
    fun daysBetween(from: Long, to: Long): Int =
        Math.round((startOfDay(to) - startOfDay(from)).toDouble() / DAY_MS).toInt()

    private fun startOfDay(at: Long): Long = Calendar.getInstance().run {
        timeInMillis = at
        set(Calendar.HOUR_OF_DAY, 0)
        set(Calendar.MINUTE, 0)
        set(Calendar.SECOND, 0)
        set(Calendar.MILLISECOND, 0)
        timeInMillis
    }
}
