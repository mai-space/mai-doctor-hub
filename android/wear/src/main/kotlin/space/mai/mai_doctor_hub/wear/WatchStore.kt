package space.mai.mai_doctor_hub.wear

import android.content.Context
import android.content.SharedPreferences
import org.json.JSONArray
import org.json.JSONObject
import java.util.UUID

/**
 * Letzter Snapshot vom Telefon und Eingaben an der Uhr, die das Telefon noch
 * nicht bestätigt hat (Ausgang). Liegt in den privaten Einstellungen der
 * Uhr-App; der Snapshot enthält im diskreten Modus keine Namen.
 */
class WatchStore(context: Context) {
    val prefs: SharedPreferences = context.applicationContext
        .getSharedPreferences(PREFS, Context.MODE_PRIVATE)

    /** Snapshot inkl. eigener, noch offener Eingaben; `null` = noch keiner. */
    fun load(): WatchData? = synchronized(lock) {
        val raw = prefs.getString(KEY_SNAPSHOT, null) ?: return null
        WatchData.parse(withOutbox(raw))
    }

    /** Wann zuletzt ein Snapshot ankam (0 = nie). */
    fun receivedAt(): Long = prefs.getLong(KEY_RECEIVED_AT, 0L)

    /** Neuer Snapshot vom Telefon. Eingaben, die er schon enthält (oder die
     *  zu alt sind), verlassen den Ausgang; die übrigen werden weiter
     *  gesendet. */
    fun save(snapshot: String): Unit = synchronized(lock) {
        val data = WatchData.parse(snapshot) ?: return
        val now = System.currentTimeMillis()
        val remaining = readOutbox().filterNot { arrived(it, data, now) }
        prefs.edit()
            .putString(KEY_SNAPSHOT, snapshot)
            .putLong(KEY_RECEIVED_AT, now)
            .putString(KEY_OUTBOX, JSONArray(remaining).toString())
            .apply()
    }

    private fun arrived(action: JSONObject, data: WatchData, now: Long): Boolean {
        val ts = action.long("ts") ?: return true
        if (now - ts > MAX_AGE_MS) return true
        return when (action.text("type")) {
            TYPE_INTAKE -> data.doses.none {
                it.medicationId == action.text("med") && it.at == action.long("at") && !it.done
            }
            TYPE_CHECK_IN -> {
                val checkIn = data.checkIn
                checkIn == null || checkIn.symptomId != action.text("symptom") ||
                    (checkIn.lastAt ?: 0L) >= ts
            }
            else -> true
        }
    }

    /** Einnahme an der Uhr abhaken (Ausgang, bis das Telefon sie bestätigt). */
    fun enqueueIntake(medicationId: String, scheduledFor: Long): JSONObject = enqueue(
        JSONObject()
            .put("type", TYPE_INTAKE)
            .put("med", medicationId)
            .put("at", scheduledFor),
    )

    /** Check-in-Wert an der Uhr. */
    fun enqueueCheckIn(symptomId: String, value: Int): JSONObject = enqueue(
        JSONObject()
            .put("type", TYPE_CHECK_IN)
            .put("symptom", symptomId)
            .put("value", value.coerceIn(0, 10)),
    )

    /** Noch nicht vom Telefon bestätigte Eingaben. */
    fun outbox(): List<JSONObject> = synchronized(lock) { readOutbox() }

    private fun enqueue(action: JSONObject): JSONObject = synchronized(lock) {
        action.put("id", UUID.randomUUID().toString())
        action.put("ts", System.currentTimeMillis())
        val list = (readOutbox() + action).takeLast(MAX_OUTBOX)
        prefs.edit().putString(KEY_OUTBOX, JSONArray(list).toString()).commit()
        action
    }

    private fun readOutbox(): List<JSONObject> {
        val raw = prefs.getString(KEY_OUTBOX, null) ?: return emptyList()
        return try {
            val array = JSONArray(raw)
            (0 until array.length()).mapNotNull { array.optJSONObject(it) }
        } catch (_: Exception) {
            emptyList()
        }
    }

    /** Eigene Eingaben schon anzeigen (abgehakt bzw. heutiger Wert). */
    private fun withOutbox(raw: String): String {
        val outbox = readOutbox()
        if (outbox.isEmpty()) return raw
        return try {
            val json = JSONObject(raw)
            val doses = json.optJSONArray("doses") ?: JSONArray()
            for (action in outbox) {
                when (action.text("type")) {
                    TYPE_INTAKE -> for (i in 0 until doses.length()) {
                        val dose = doses.optJSONObject(i) ?: continue
                        if (dose.text("med") == action.text("med") &&
                            dose.long("at") == action.long("at") &&
                            dose.text("status") == null
                        ) {
                            dose.put("status", "taken")
                        }
                    }
                    TYPE_CHECK_IN -> {
                        val checkIn = json.optJSONObject("checkIn") ?: continue
                        if (checkIn.text("symptom") != action.text("symptom")) continue
                        checkIn.put("lastAt", action.optLong("ts")).put("lastValue", action.optInt("value"))
                    }
                }
            }
            json.toString()
        } catch (_: Exception) {
            raw
        }
    }

    companion object {
        const val PREFS = "mai_watch"
        const val KEY_SNAPSHOT = "snapshot"
        const val TYPE_INTAKE = "intake"
        const val TYPE_CHECK_IN = "checkin"
        private const val KEY_RECEIVED_AT = "receivedAt"
        private const val KEY_OUTBOX = "outbox"
        private const val MAX_OUTBOX = 50
        private const val MAX_AGE_MS = 2 * 24 * 60 * 60 * 1000L
        private val lock = Any()
    }
}
