package space.mai.mai_doctor_hub.widgets

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

/**
 * Eingaben am Widget (Einnahme abhaken, Check-in-Wert) und Anlässe zum
 * Neuzeichnen (Uhrzeit/Zeitzone/Sprache geändert, App aktualisiert).
 *
 * Die Datenbank ist verschlüsselt und hier nicht erreichbar: Eingaben landen
 * in der Warteschlange ([WidgetStore]) und erscheinen sofort am Widget; die
 * App trägt sie beim nächsten Öffnen ein.
 */
class WidgetActionReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        val store = WidgetStore(context)
        when (intent.action) {
            WidgetLinks.ACTION_INTAKE -> {
                val id = intent.getStringExtra(WidgetLinks.EXTRA_ID) ?: return
                val at = intent.getLongExtra(WidgetLinks.EXTRA_AT, -1L)
                if (at < 0) return
                store.enqueueIntake(id, at)
            }
            WidgetLinks.ACTION_CHECK_IN -> {
                val id = intent.getStringExtra(WidgetLinks.EXTRA_ID) ?: return
                val value = intent.getIntExtra(WidgetLinks.EXTRA_VALUE, -1)
                if (value !in 0..10) return
                store.enqueueCheckIn(id, value)
            }
        }
        WidgetUpdater.updateAll(context)
    }
}
