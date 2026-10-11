package space.mai.mai_doctor_hub.widgets

import org.json.JSONArray
import org.json.JSONObject

/** Termin im Snapshot (siehe `widget_snapshot.dart`). */
data class WidgetAppointment(
    val id: String,
    val at: Long,
    val end: Long,
    val doctor: String?,
    val title: String?,
)

/** Geplante Einnahme; [status] `taken`/`skipped`, `null` = offen. */
data class WidgetDose(
    val medicationId: String,
    val at: Long,
    val status: String?,
    val name: String?,
    val dose: String?,
) {
    val done get() = status != null
}

/** Symptom für den Schnell-Check-in. */
data class WidgetCheckIn(
    val symptomId: String,
    val quick: Boolean,
    val label: String?,
    val lastAt: Long?,
    val lastValue: Int?,
)

/** Inhalt aller Widgets. Im diskreten Modus fehlen alle Klartexte. */
data class WidgetData(
    val discreet: Boolean,
    val appointments: List<WidgetAppointment>,
    val doses: List<WidgetDose>,
    val dosesUntil: Long,
    val checkIn: WidgetCheckIn?,
) {
    companion object {
        /** Liest den Snapshot tolerant: unbekannte Felder werden ignoriert,
         *  fehlerhafte Einträge übersprungen. */
        fun parse(raw: String): WidgetData? = try {
            val json = JSONObject(raw)
            // Doppelt hält besser: im diskreten Modus nie Klartext zeigen,
            // auch wenn ein (älterer) Snapshot ihn enthielte.
            val discreet = json.optBoolean("discreet", true)
            WidgetData(
                discreet = discreet,
                appointments = json.objects("appointments").mapNotNull {
                    val id = it.text("id") ?: return@mapNotNull null
                    val at = it.long("at") ?: return@mapNotNull null
                    WidgetAppointment(
                        id = id,
                        at = at,
                        end = it.long("end") ?: (at + 60 * 60 * 1000L),
                        doctor = if (discreet) null else it.text("doctor"),
                        title = if (discreet) null else it.text("title"),
                    )
                }.sortedBy { it.at },
                doses = json.objects("doses").mapNotNull {
                    val med = it.text("med") ?: return@mapNotNull null
                    val at = it.long("at") ?: return@mapNotNull null
                    WidgetDose(
                        medicationId = med,
                        at = at,
                        status = it.text("status"),
                        name = if (discreet) null else it.text("name"),
                        dose = if (discreet) null else it.text("dose"),
                    )
                }.sortedBy { it.at },
                dosesUntil = json.optLong("dosesUntil", 0L),
                checkIn = json.optJSONObject("checkIn")?.let {
                    val id = it.text("symptom") ?: return@let null
                    WidgetCheckIn(
                        symptomId = id,
                        quick = it.optBoolean("quick", false),
                        label = if (discreet) null else it.text("label"),
                        lastAt = it.long("lastAt"),
                        lastValue = if (it.has("lastValue")) it.optInt("lastValue") else null,
                    )
                },
            )
        } catch (_: Exception) {
            null
        }
    }

    /** Eingaben am Widget, die die App noch nicht übernommen hat, schon
     *  anzeigen (abgehakt bzw. heutiger Wert). */
    fun withPending(actions: List<JSONObject>): WidgetData {
        var result = this
        for (action in actions) {
            when (action.text("type")) {
                WidgetStore.TYPE_INTAKE -> {
                    val med = action.text("med") ?: continue
                    val at = action.long("at") ?: continue
                    result = result.copy(
                        doses = result.doses.map {
                            if (it.medicationId == med && it.at == at && !it.done) {
                                it.copy(status = "taken")
                            } else {
                                it
                            }
                        },
                    )
                }
                WidgetStore.TYPE_CHECK_IN -> {
                    val current = result.checkIn ?: continue
                    val symptom = action.text("symptom") ?: continue
                    val ts = action.long("ts") ?: continue
                    if (symptom != current.symptomId) continue
                    if (current.lastAt != null && current.lastAt > ts) continue
                    result = result.copy(
                        checkIn = current.copy(lastAt = ts, lastValue = action.optInt("value")),
                    )
                }
            }
        }
        return result
    }
}

internal fun JSONObject.text(key: String): String? =
    if (has(key) && !isNull(key)) optString(key).takeIf { it.isNotEmpty() } else null

internal fun JSONObject.long(key: String): Long? =
    if (has(key) && !isNull(key)) optLong(key) else null

private fun JSONObject.objects(key: String): List<JSONObject> {
    val array: JSONArray = optJSONArray(key) ?: return emptyList()
    return (0 until array.length()).mapNotNull { array.optJSONObject(it) }
}
