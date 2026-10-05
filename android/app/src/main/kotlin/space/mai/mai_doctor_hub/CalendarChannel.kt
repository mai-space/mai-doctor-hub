package space.mai.mai_doctor_hub

import android.Manifest
import android.app.Activity
import android.content.ContentUris
import android.content.ContentValues
import android.content.pm.PackageManager
import android.os.Handler
import android.os.Looper
import android.provider.CalendarContract
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.util.TimeZone
import java.util.concurrent.Executors

/**
 * Einseitiger Export in den Gerätekalender (CalendarContract).
 *
 * Schreibt nur Events, deren ID die App selbst gespeichert hat; liest keine
 * fremden Events. Ein Google-Konto-Kalender wird von Android selbst zu
 * Google synchronisiert.
 */
class CalendarChannel(private val activity: Activity) : MethodChannel.MethodCallHandler {
    companion object {
        const val NAME = "mai/calendar"
        const val PERMISSION_REQUEST = 4711
    }

    private val io = Executors.newSingleThreadExecutor()
    private val main = Handler(Looper.getMainLooper())
    private var pendingPermission: MethodChannel.Result? = null

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "hasPermission" -> result.success(hasPermission())
            "requestPermission" -> requestPermission(result)
            "listCalendars" -> background(result) { listCalendars() }
            "upsertEvent" -> background(result) { upsertEvent(call) }
            "deleteEvent" -> background(result) {
                deleteEvent((call.argument<String>("eventId"))!!.toLong())
            }
            else -> result.notImplemented()
        }
    }

    private fun hasPermission(): Boolean =
        listOf(Manifest.permission.READ_CALENDAR, Manifest.permission.WRITE_CALENDAR).all {
            ContextCompat.checkSelfPermission(activity, it) == PackageManager.PERMISSION_GRANTED
        }

    private fun requestPermission(result: MethodChannel.Result) {
        if (hasPermission()) {
            result.success(true)
            return
        }
        pendingPermission?.success(false)
        pendingPermission = result
        ActivityCompat.requestPermissions(
            activity,
            arrayOf(Manifest.permission.READ_CALENDAR, Manifest.permission.WRITE_CALENDAR),
            PERMISSION_REQUEST,
        )
    }

    /** Aus MainActivity.onRequestPermissionsResult weitergereicht. */
    fun onPermissionResult(requestCode: Int): Boolean {
        if (requestCode != PERMISSION_REQUEST) return false
        pendingPermission?.success(hasPermission())
        pendingPermission = null
        return true
    }

    private fun background(result: MethodChannel.Result, task: () -> Any?) {
        if (!hasPermission()) {
            result.error("permission", "Kalenderzugriff nicht erlaubt", null)
            return
        }
        io.execute {
            try {
                val value = task()
                main.post { result.success(value) }
            } catch (e: Exception) {
                main.post { result.error("calendar", e.message, null) }
            }
        }
    }

    private fun listCalendars(): List<Map<String, Any?>> {
        val projection = arrayOf(
            CalendarContract.Calendars._ID,
            CalendarContract.Calendars.CALENDAR_DISPLAY_NAME,
            CalendarContract.Calendars.ACCOUNT_NAME,
            CalendarContract.Calendars.ACCOUNT_TYPE,
            CalendarContract.Calendars.IS_PRIMARY,
        )
        // Nur Kalender, in die wir schreiben dürfen.
        val selection = "${CalendarContract.Calendars.CALENDAR_ACCESS_LEVEL} >= ?"
        val args = arrayOf(CalendarContract.Calendars.CAL_ACCESS_CONTRIBUTOR.toString())
        val calendars = mutableListOf<Map<String, Any?>>()
        activity.contentResolver.query(
            CalendarContract.Calendars.CONTENT_URI, projection, selection, args, null,
        )?.use { c ->
            while (c.moveToNext()) {
                calendars.add(
                    mapOf(
                        "id" to c.getLong(0).toString(),
                        "name" to (c.getString(1) ?: ""),
                        "accountName" to (c.getString(2) ?: ""),
                        "accountType" to (c.getString(3) ?: ""),
                        "isPrimary" to (c.getInt(4) == 1),
                    ),
                )
            }
        }
        return calendars
    }

    private fun upsertEvent(call: MethodCall): String {
        val values = ContentValues().apply {
            put(CalendarContract.Events.CALENDAR_ID, call.argument<String>("calendarId")!!.toLong())
            put(CalendarContract.Events.TITLE, call.argument<String>("title"))
            put(CalendarContract.Events.DESCRIPTION, call.argument<String>("description"))
            put(CalendarContract.Events.EVENT_LOCATION, call.argument<String>("location"))
            put(CalendarContract.Events.DTSTART, call.argument<Number>("start")!!.toLong())
            put(CalendarContract.Events.DTEND, call.argument<Number>("end")!!.toLong())
            put(CalendarContract.Events.EVENT_TIMEZONE, TimeZone.getDefault().id)
        }
        val resolver = activity.contentResolver
        val existing = call.argument<String>("eventId")?.toLongOrNull()
        if (existing != null) {
            val uri = ContentUris.withAppendedId(CalendarContract.Events.CONTENT_URI, existing)
            // 0 Zeilen → Event wurde extern gelöscht: neu anlegen.
            if (resolver.update(uri, values, null, null) > 0) return existing.toString()
        }
        val inserted = resolver.insert(CalendarContract.Events.CONTENT_URI, values)
            ?: throw IllegalStateException("Event konnte nicht angelegt werden")
        return ContentUris.parseId(inserted).toString()
    }

    private fun deleteEvent(eventId: Long): Boolean {
        val uri = ContentUris.withAppendedId(CalendarContract.Events.CONTENT_URI, eventId)
        return activity.contentResolver.delete(uri, null, null) > 0
    }
}
