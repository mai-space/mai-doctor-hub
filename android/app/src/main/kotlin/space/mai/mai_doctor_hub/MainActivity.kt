package space.mai.mai_doctor_hub

import android.app.ActivityManager
import android.os.Build
import android.view.WindowManager
import java.util.TimeZone
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import androidx.work.WorkManager
import java.io.File

// FragmentActivity wird von local_auth (BiometricPrompt) benötigt.
class MainActivity : FlutterFragmentActivity() {
    private var calendar: CalendarChannel? = null

    // Registriert einen Activity-Result-Launcher: muss beim Erzeugen passieren.
    private val documentScanner = DocumentScannerChannel(this)

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // IANA-Zeitzone des Geräts (z. B. „Europe/Berlin“) — Dart kennt nur
        // Abkürzungen wie „CEST“, Erinnerungen und Kalender brauchen die ID.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "mai/device")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "timeZone" -> result.success(TimeZone.getDefault().id)
                    // Lokale KI (LiteRT-LM): nur Android 11+ auf arm64.
                    "localAi" -> {
                        val memory = ActivityManager.MemoryInfo()
                        (getSystemService(ACTIVITY_SERVICE) as ActivityManager).getMemoryInfo(memory)
                        result.success(
                            mapOf(
                                "sdk" to Build.VERSION.SDK_INT,
                                "arm64" to Build.SUPPORTED_ABIS.contains("arm64-v8a"),
                                "totalRam" to memory.totalMem,
                            ),
                        )
                    }
                    // Hugging-Face-Token aus gespeicherten Download-Aufträgen
                    // entfernen (WorkManager-DB, Einstellungen des Downloaders).
                    "scrubSecret" -> {
                        val secret = call.argument<String>("secret")
                        if (secret.isNullOrEmpty()) {
                            result.error("ARG", "secret fehlt", null)
                        } else {
                            Thread {
                                val removed = scrubSecret(secret)
                                runOnUiThread { result.success(removed) }
                            }.start()
                        }
                    }
                    else -> result.notImplemented()
                }
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DatabaseKeyChannel.NAME)
            .setMethodCallHandler(DatabaseKeyChannel(applicationContext))
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DocumentScannerChannel.NAME)
            .setMethodCallHandler(documentScanner)
        calendar = CalendarChannel(this).also {
            MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CalendarChannel.NAME)
                .setMethodCallHandler(it)
        }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "mai/secure_window")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    // Blendet App-Inhalte in „Zuletzt verwendet“ und Screenshots aus.
                    "setSecure" -> {
                        if (call.arguments as? Boolean == true) {
                            window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
                        } else {
                            window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                        }
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray,
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        calendar?.onPermissionResult(requestCode)
    }

    /** Entfernt Einträge mit [secret] aus allen Einstellungsdateien der App
     *  und räumt erledigte WorkManager-Aufträge ab. */
    private fun scrubSecret(secret: String): Int {
        var removed = 0
        val prefsDir = File(applicationInfo.dataDir, "shared_prefs")
        prefsDir.listFiles()?.filter { it.name.endsWith(".xml") }?.forEach { file ->
            val prefs = getSharedPreferences(file.name.removeSuffix(".xml"), MODE_PRIVATE)
            val stale = prefs.all.filter { (_, value) ->
                when (value) {
                    is String -> value.contains(secret)
                    is Set<*> -> value.any { it is String && it.contains(secret) }
                    else -> false
                }
            }.keys
            if (stale.isNotEmpty()) {
                prefs.edit().apply { stale.forEach { remove(it) } }.commit()
                removed += stale.size
            }
        }
        try {
            WorkManager.getInstance(applicationContext).pruneWork().result.get()
        } catch (_: Exception) {
        }
        return removed
    }
}
