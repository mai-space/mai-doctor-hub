package space.mai.mai_doctor_hub.wear

import com.google.android.gms.wearable.MessageEvent
import com.google.android.gms.wearable.WearableListenerService

/** Snapshot vom Telefon übernehmen und Kacheln/Komplikationen neu zeichnen. */
class WatchListenerService : WearableListenerService() {
    override fun onMessageReceived(event: MessageEvent) {
        if (event.path != PhoneLink.PATH_SNAPSHOT) return
        WatchStore(this).save(String(event.data, Charsets.UTF_8))
        WatchRefresh.all(this)
    }
}
