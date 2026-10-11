package space.mai.mai_doctor_hub.wear

import org.json.JSONArray
import org.json.JSONObject

/** Termin im Snapshot (siehe `widget_snapshot.dart`). */
data class WatchAppointment(
    val id: String,
    val at: Long,
    val end: Long,
    val doctor: String?,
    val title: String?,
)

/** Geplante Einnahme; [status] `taken`/`skipped`, `null` = offen. */
data class WatchDose(
    val medicationId: String,
    val at: Long,
    val status: String?,
    val name: String?,
    val dose: String?,
) {
    val done get() = status != null
}

/** Symptom für den Schnell-Check-in. */
data class WatchCheckIn(
    val symptomId: String,
    val quick: Boolean,
    val label: String?,
    val lastAt: Long?,
    val lastValue: Int?,
)

/**
 * Inhalt der Uhr-App — derselbe Snapshot wie für die Startbildschirm-Widgets
 * am Telefon (`WidgetData.kt`). Im diskreten Modus fehlen alle Klartexte.
 */
data class WatchData(
    val discreet: Boolean,
    val appointments: List<WatchAppointment>,
    val doses: List<WatchDose>,
    val dosesUntil: Long,
    val checkIn: WatchCheckIn?,
) {
    /** Nächste noch nicht vorbei gegangene Termine. */
    fun upcoming(now: Long): List<WatchAppointment> = appointments.filter { it.end > now }

    /** Einnahmen von heute; `null`, wenn der Plan nicht so weit reicht. */
    fun dosesToday(now: Long): List<WatchDose>? =
        if (now >= dosesUntil) null else doses.filter { WatchFormat.sameDay(now, it.at) }

    /** Heute schon eingetragener Check-in (Wert oder `null` ohne Wert). */
    fun checkInDoneToday(now: Long): Boolean =
        checkIn?.lastAt?.let { WatchFormat.sameDay(now, it) } == true

    companion object {
        /** Liest den Snapshot tolerant: unbekannte Felder werden ignoriert,
         *  fehlerhafte Einträge übersprungen. */
        fun parse(raw: String): WatchData? = try {
            val json = JSONObject(raw)
            // Im diskreten Modus nie Klartext zeigen, auch wenn ein Snapshot
            // ihn enthielte.
            val discreet = json.optBoolean("discreet", true)
            WatchData(
                discreet = discreet,
                appointments = json.objects("appointments").mapNotNull {
                    val id = it.text("id") ?: return@mapNotNull null
                    val at = it.long("at") ?: return@mapNotNull null
                    WatchAppointment(
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
                    WatchDose(
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
                    WatchCheckIn(
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
}

internal fun JSONObject.text(key: String): String? =
    if (has(key) && !isNull(key)) optString(key).takeIf { it.isNotEmpty() } else null

internal fun JSONObject.long(key: String): Long? =
    if (has(key) && !isNull(key)) optLong(key) else null

internal fun JSONObject.objects(key: String): List<JSONObject> {
    val array: JSONArray = optJSONArray(key) ?: return emptyList()
    return (0 until array.length()).mapNotNull { array.optJSONObject(it) }
}
