package space.mai.mai_doctor_hub.watch

import android.content.Context
import android.util.Log
import com.google.android.gms.wearable.CapabilityClient
import com.google.android.gms.wearable.Wearable
import space.mai.mai_doctor_hub.widgets.WidgetStore

/**
 * Abgleich mit der Uhr-App (Wear OS, Modul `android/wear`).
 *
 * Die Uhr bekommt denselben Snapshot wie die Startbildschirm-Widgets — im
 * diskreten Modus also ohne Namen. Gesendet wird nur als Nachricht direkt an
 * erreichbare Uhren, auf denen die Uhr-App installiert ist (Capability
 * [WATCH_CAPABILITY]); ohne Uhr-App verlässt nichts das Telefon. Kein
 * `DataItem`: das würde Google Play-Dienste auch für nicht verbundene Geräte
 * zwischenspeichern.
 */
object WatchSync {
    // Gleiche Werte wie `WatchProtocol` im Modul `wear`.
    const val WATCH_CAPABILITY = "mai_doctor_hub_watch"
    const val PATH_SNAPSHOT = "/mai/widgets/snapshot"
    const val PATH_REQUEST = "/mai/widgets/request"
    const val PATH_ACTION = "/mai/widgets/action"
    private const val TAG = "MaiWatch"

    /** Aktuellen Snapshot an alle erreichbaren Uhren mit Uhr-App senden. */
    fun push(context: Context) {
        val app = context.applicationContext
        try {
            Wearable.getCapabilityClient(app)
                .getCapability(WATCH_CAPABILITY, CapabilityClient.FILTER_REACHABLE)
                .addOnSuccessListener { info ->
                    if (info.nodes.isEmpty()) return@addOnSuccessListener
                    val payload = WidgetStore(app).watchJson() ?: return@addOnSuccessListener
                    val bytes = payload.toByteArray(Charsets.UTF_8)
                    for (node in info.nodes) send(app, node.id, bytes)
                }
                .addOnFailureListener { Log.d(TAG, "Keine Uhr erreichbar: ${it.message}") }
        } catch (e: Exception) {
            // Ohne Google Play-Dienste (z. B. Custom-ROM) gibt es keine Uhr.
            Log.d(TAG, "Wearable-API nicht verfügbar: ${e.message}")
        }
    }

    /** Snapshot gezielt an eine Uhr (auf deren Anfrage). */
    fun sendTo(context: Context, nodeId: String) {
        val payload = WidgetStore(context).watchJson() ?: return
        send(context.applicationContext, nodeId, payload.toByteArray(Charsets.UTF_8))
    }

    private fun send(context: Context, nodeId: String, bytes: ByteArray) {
        Wearable.getMessageClient(context)
            .sendMessage(nodeId, PATH_SNAPSHOT, bytes)
            .addOnFailureListener { Log.d(TAG, "Senden fehlgeschlagen: ${it.message}") }
    }
}
