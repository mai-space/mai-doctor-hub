package space.mai.mai_doctor_hub.wear

import android.content.Context
import android.util.Log
import com.google.android.gms.wearable.CapabilityClient
import com.google.android.gms.wearable.Wearable

/**
 * Nachrichten an die Telefon-App (`WatchListenerService.kt` dort): Snapshot
 * anfordern, Eingaben an der Uhr melden. Nur an erreichbare Telefone mit
 * installierter App (Capability [PHONE_CAPABILITY]).
 */
object PhoneLink {
    // Gleiche Werte wie `WatchSync` in der Telefon-App.
    const val PHONE_CAPABILITY = "mai_doctor_hub_phone"
    const val PATH_SNAPSHOT = "/mai/widgets/snapshot"
    const val PATH_REQUEST = "/mai/widgets/request"
    const val PATH_ACTION = "/mai/widgets/action"
    private const val TAG = "MaiWatch"

    /** Aktuellen Snapshot anfordern und offene Eingaben (erneut) senden. */
    fun sync(context: Context) {
        val outbox = WatchStore(context).outbox()
        withPhones(context) { nodeId ->
            // Eingaben zuerst: die Antwort auf die Anfrage enthält sie dann.
            for (action in outbox) send(context, nodeId, PATH_ACTION, action.toString())
            send(context, nodeId, PATH_REQUEST, "")
        }
    }

    private fun withPhones(context: Context, block: (String) -> Unit) {
        val app = context.applicationContext
        try {
            Wearable.getCapabilityClient(app)
                .getCapability(PHONE_CAPABILITY, CapabilityClient.FILTER_REACHABLE)
                .addOnSuccessListener { info -> info.nodes.forEach { block(it.id) } }
                .addOnFailureListener { Log.d(TAG, "Kein Telefon erreichbar: ${it.message}") }
        } catch (e: Exception) {
            Log.d(TAG, "Wearable-API nicht verfügbar: ${e.message}")
        }
    }

    private fun send(context: Context, nodeId: String, path: String, payload: String) {
        Wearable.getMessageClient(context.applicationContext)
            .sendMessage(nodeId, path, payload.toByteArray(Charsets.UTF_8))
            .addOnFailureListener { Log.d(TAG, "Senden fehlgeschlagen: ${it.message}") }
    }
}
