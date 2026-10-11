package space.mai.mai_doctor_hub.widgets

import android.content.Context
import org.json.JSONArray
import org.json.JSONObject
import java.util.UUID

/**
 * Snapshot der Widgets und Warteschlange der Eingaben am Widget.
 *
 * Liegt in den privaten App-Einstellungen (nicht in der verschlüsselten
 * Datenbank — die kann das Widget nicht öffnen). Deshalb schreibt die App
 * hier nur das Nötigste hinein, im diskreten Modus ohne Klartext.
 */
class WidgetStore(context: Context) {
    private val prefs = context.applicationContext
        .getSharedPreferences(PREFS, Context.MODE_PRIVATE)

    /** Snapshot inkl. noch nicht übernommener Eingaben; `null` = noch keiner. */
    fun load(): WidgetData? = synchronized(lock) {
        val raw = prefs.getString(KEY_SNAPSHOT, null) ?: return null
        WidgetData.parse(raw)?.withPending(actions())
    }

    /** Neuer Snapshot von der App; [ack] = dort übernommene Eingaben. */
    fun save(snapshot: String, ack: Collection<String>) = synchronized(lock) {
        val remaining = actions().filterNot { it.text("id") in ack }
        prefs.edit()
            .putString(KEY_SNAPSHOT, snapshot)
            .putString(KEY_ACTIONS, JSONArray(remaining).toString())
            .commit()
    }

    /** Warteschlange als JSON-Liste (für die App). */
    fun pendingJson(): String = synchronized(lock) {
        JSONArray(actions()).toString()
    }

    fun enqueueIntake(medicationId: String, scheduledFor: Long) = enqueue(
        JSONObject()
            .put("type", TYPE_INTAKE)
            .put("med", medicationId)
            .put("at", scheduledFor),
    )

    fun enqueueCheckIn(symptomId: String, value: Int) = enqueue(
        JSONObject()
            .put("type", TYPE_CHECK_IN)
            .put("symptom", symptomId)
            .put("value", value.coerceIn(0, 10)),
    )

    private fun enqueue(action: JSONObject) = synchronized(lock) {
        action.put("id", UUID.randomUUID().toString())
        action.put("ts", System.currentTimeMillis())
        // Obergrenze, falls die App lange nicht geöffnet wird.
        val list = (actions() + action).takeLast(MAX_ACTIONS)
        prefs.edit().putString(KEY_ACTIONS, JSONArray(list).toString()).commit()
    }

    private fun actions(): List<JSONObject> {
        val raw = prefs.getString(KEY_ACTIONS, null) ?: return emptyList()
        return try {
            val array = JSONArray(raw)
            (0 until array.length()).mapNotNull { array.optJSONObject(it) }
        } catch (_: Exception) {
            emptyList()
        }
    }

    companion object {
        const val PREFS = "mai_home_widgets"
        const val TYPE_INTAKE = "intake"
        const val TYPE_CHECK_IN = "checkin"
        private const val KEY_SNAPSHOT = "snapshot"
        private const val KEY_ACTIONS = "actions"
        private const val MAX_ACTIONS = 200
        private val lock = Any()
    }
}
