package space.mai.mai_doctor_hub.watch

import com.google.android.gms.wearable.MessageEvent
import com.google.android.gms.wearable.WearableListenerService
import org.json.JSONObject
import space.mai.mai_doctor_hub.widgets.WidgetStore
import space.mai.mai_doctor_hub.widgets.WidgetUpdater

/**
 * Nachrichten der Uhr-App: Snapshot anfordern oder eine Eingabe an der Uhr
 * (Einnahme abgehakt, Check-in-Wert). Eingaben landen wie die der Widgets in
 * der Warteschlange ([WidgetStore]); die App trägt sie beim nächsten Öffnen
 * ein. Google Play-Dienste stellen nur Nachrichten gekoppelter Geräte mit
 * derselben App (gleiche Paket-ID und Signatur) zu.
 */
class WatchListenerService : WearableListenerService() {
    override fun onMessageReceived(event: MessageEvent) {
        when (event.path) {
            WatchSync.PATH_REQUEST -> WatchSync.sendTo(this, event.sourceNodeId)
            WatchSync.PATH_ACTION -> {
                if (enqueue(event.data)) {
                    // Widgets neu zeichnen; schickt den Stand auch an die Uhr.
                    WidgetUpdater.updateAll(this)
                } else {
                    WatchSync.sendTo(this, event.sourceNodeId)
                }
            }
        }
    }

    private fun enqueue(data: ByteArray): Boolean {
        val action = try {
            JSONObject(String(data, Charsets.UTF_8))
        } catch (_: Exception) {
            return false
        }
        val store = WidgetStore(this)
        when (action.optString("type")) {
            WidgetStore.TYPE_INTAKE -> {
                val med = action.optString("med").takeIf { it.isNotEmpty() } ?: return false
                val at = action.optLong("at", -1L).takeIf { it >= 0 } ?: return false
                store.enqueueIntake(med, at)
            }
            WidgetStore.TYPE_CHECK_IN -> {
                val symptom = action.optString("symptom").takeIf { it.isNotEmpty() } ?: return false
                val value = action.optInt("value", -1).takeIf { it in 0..10 } ?: return false
                store.enqueueCheckIn(symptom, value)
            }
            else -> return false
        }
        return true
    }
}
