package space.mai.mai_doctor_hub.widgets

import android.content.Context
import android.content.Intent
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Kanal `mai/home_widgets` (`home_widget_sync.dart`): Snapshot schreiben,
 * Eingaben am Widget abholen, per Widget-Tipp gewählte Ziele melden.
 */
class HomeWidgetChannel(
    context: Context,
    messenger: BinaryMessenger,
) : MethodChannel.MethodCallHandler {
    private val context = context.applicationContext
    private val channel = MethodChannel(messenger, NAME).also { it.setMethodCallHandler(this) }

    /** Ziel, mit dem die App gestartet wurde (bis Dart es abholt). */
    private var launchLink: String? = null

    fun onLaunch(intent: Intent?) {
        WidgetLinks.take(intent)?.let { launchLink = it }
    }

    /** Tipp aufs Widget, während die App läuft. */
    fun onNewIntent(intent: Intent) {
        WidgetLinks.take(intent)?.let { channel.invokeMethod("open", it) }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "update" -> {
                val snapshot = call.argument<String>("snapshot")
                if (snapshot == null) {
                    result.error("ARG", "snapshot fehlt", null)
                    return
                }
                val ack = call.argument<List<String>>("ack") ?: emptyList()
                WidgetStore(context).save(snapshot, ack)
                WidgetUpdater.updateAll(context)
                result.success(null)
            }
            "pendingActions" -> result.success(WidgetStore(context).pendingJson())
            "takeLaunchLink" -> {
                result.success(launchLink)
                launchLink = null
            }
            else -> result.notImplemented()
        }
    }

    companion object {
        const val NAME = "mai/home_widgets"
    }
}
