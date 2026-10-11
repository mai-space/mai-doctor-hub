package space.mai.mai_doctor_hub.widgets

import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.net.Uri
import space.mai.mai_doctor_hub.MainActivity

/**
 * Tipps auf Widgets: App an einer Stelle öffnen oder eine Eingabe direkt am
 * Widget vormerken. Ziele (`appointment/<id>`, `medications`,
 * `checkin/<id>` …) liest `WidgetLink.parse` in Dart.
 */
object WidgetLinks {
    const val EXTRA_LINK = "space.mai.mai_doctor_hub.WIDGET_LINK"
    const val ACTION_OPEN = "space.mai.mai_doctor_hub.WIDGET_OPEN"
    const val ACTION_INTAKE = "space.mai.mai_doctor_hub.WIDGET_INTAKE"
    const val ACTION_CHECK_IN = "space.mai.mai_doctor_hub.WIDGET_CHECK_IN"
    const val EXTRA_ID = "id"
    const val EXTRA_AT = "at"
    const val EXTRA_VALUE = "value"

    private const val SCHEME = "maidoctorhub-widget"
    private const val FLAGS = PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE

    /** Öffnet die App (hinter der App-Sperre) beim Ziel [link]. */
    fun open(context: Context, link: String): PendingIntent {
        val intent = Intent(context, MainActivity::class.java)
            .setAction(ACTION_OPEN)
            // Eindeutige Daten-URI: sonst teilen sich alle Ziele einen Intent.
            .setData(uri("open", link))
            .putExtra(EXTRA_LINK, link)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP)
        return PendingIntent.getActivity(context, 0, intent, FLAGS)
    }

    /** Einnahme direkt am Widget als genommen vormerken. */
    fun intake(context: Context, medicationId: String, scheduledFor: Long): PendingIntent {
        val intent = Intent(context, WidgetActionReceiver::class.java)
            .setAction(ACTION_INTAKE)
            .setData(uri("intake", "$medicationId/$scheduledFor"))
            .putExtra(EXTRA_ID, medicationId)
            .putExtra(EXTRA_AT, scheduledFor)
        return PendingIntent.getBroadcast(context, 0, intent, FLAGS)
    }

    /** Stärke [value] für ein Symptom direkt am Widget vormerken. */
    fun checkIn(context: Context, symptomId: String, value: Int): PendingIntent {
        val intent = Intent(context, WidgetActionReceiver::class.java)
            .setAction(ACTION_CHECK_IN)
            .setData(uri("checkin", "$symptomId/$value"))
            .putExtra(EXTRA_ID, symptomId)
            .putExtra(EXTRA_VALUE, value)
        return PendingIntent.getBroadcast(context, 0, intent, FLAGS)
    }

    /** Ziel aus einem Start-Intent der App (einmalig: wird entfernt). */
    fun take(intent: Intent?): String? {
        if (intent?.action != ACTION_OPEN) return null
        val link = intent.getStringExtra(EXTRA_LINK) ?: return null
        intent.removeExtra(EXTRA_LINK)
        return link
    }

    private fun uri(kind: String, path: String): Uri =
        Uri.Builder().scheme(SCHEME).authority(kind).appendEncodedPath(Uri.encode(path, "/")).build()
}
