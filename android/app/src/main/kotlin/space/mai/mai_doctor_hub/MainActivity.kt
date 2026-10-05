package space.mai.mai_doctor_hub

import android.view.WindowManager
import java.util.TimeZone
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

// FragmentActivity wird von local_auth (BiometricPrompt) benötigt.
class MainActivity : FlutterFragmentActivity() {
    private var calendar: CalendarChannel? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // IANA-Zeitzone des Geräts (z. B. „Europe/Berlin“) — Dart kennt nur
        // Abkürzungen wie „CEST“, Erinnerungen und Kalender brauchen die ID.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "mai/device")
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "timeZone" -> result.success(TimeZone.getDefault().id)
                    else -> result.notImplemented()
                }
            }
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DatabaseKeyChannel.NAME)
            .setMethodCallHandler(DatabaseKeyChannel(applicationContext))
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
}
