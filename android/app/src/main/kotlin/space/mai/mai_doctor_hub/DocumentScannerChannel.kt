package space.mai.mai_doctor_hub

import android.app.Activity
import android.net.Uri
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.activity.result.ActivityResult
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.IntentSenderRequest
import androidx.activity.result.contract.ActivityResultContracts
import androidx.core.content.FileProvider
import com.google.mlkit.vision.documentscanner.GmsDocumentScannerOptions
import com.google.mlkit.vision.documentscanner.GmsDocumentScanning
import com.google.mlkit.vision.documentscanner.GmsDocumentScanningResult
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File

/**
 * ML Kit Dokumentenscanner über die Activity Result API.
 *
 * Ersetzt das Plugin: dessen Request-Code passt nicht in 16 Bit (FragmentActivity)
 * und es verwirft die eigentliche Fehlermeldung.
 */
class DocumentScannerChannel(private val activity: ComponentActivity) :
    MethodChannel.MethodCallHandler {

    companion object {
        const val NAME = "mai/document_scanner"
    }

    private var pending: MethodChannel.Result? = null
    private var pendingPhoto: Pair<MethodChannel.Result, File>? = null

    // Muss vor onCreate/STARTED registriert werden — daher im Konstruktor.
    private val launcher: ActivityResultLauncher<IntentSenderRequest> =
        activity.registerForActivityResult(
            ActivityResultContracts.StartIntentSenderForResult(),
            ::onResult,
        )

    // Ersatz ohne Google-Scanner: Foto mit der System-Kamera-App (braucht
    // keine Kamera-Berechtigung der App).
    private val photoLauncher: ActivityResultLauncher<Uri> =
        activity.registerForActivityResult(
            ActivityResultContracts.TakePicture(),
            ::onPhoto,
        )

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        // Jeder Fehler mit Typ und Meldung zurück — sonst kommt in Dart nur
        // „error“ ohne Details an.
        try {
            when (call.method) {
                "scan" -> start(result)
                "takePhoto" -> takePhoto(result)
                else -> result.notImplemented()
            }
        } catch (e: Throwable) {
            pending = null
            pendingPhoto = null
            result.error("unavailable", describe(e, "Aufruf ${call.method}"), null)
        }
    }

    private fun start(result: MethodChannel.Result) {
        if (pending != null) {
            result.error("busy", "Es läuft bereits ein Scan.", null)
            return
        }
        val options = GmsDocumentScannerOptions.Builder()
            .setGalleryImportAllowed(true)
            .setPageLimit(20)
            .setResultFormats(
                GmsDocumentScannerOptions.RESULT_FORMAT_PDF,
                GmsDocumentScannerOptions.RESULT_FORMAT_JPEG,
            )
            .setScannerMode(GmsDocumentScannerOptions.SCANNER_MODE_FULL)
            .build()
        pending = result
        GmsDocumentScanning.getClient(options)
            .getStartScanIntent(activity)
            .addOnSuccessListener { sender ->
                try {
                    launcher.launch(IntentSenderRequest.Builder(sender).build())
                } catch (e: Throwable) {
                    fail(e, "Start (launch)")
                }
            }
            .addOnFailureListener { fail(it, "Start (getStartScanIntent)") }
    }

    private fun onResult(activityResult: ActivityResult) {
        val result = pending ?: return
        pending = null
        if (activityResult.resultCode != Activity.RESULT_OK) {
            result.success(null)
            return
        }
        try {
            val data = activityResult.data
            if (data == null) {
                result.error("failed", "Scanner lieferte kein Ergebnis (leerer Intent).", null)
                return
            }
            val scan = GmsDocumentScanningResult.fromActivityResultIntent(data)
            val pdf = scan?.pdf
            if (pdf == null) {
                result.success(null)
                return
            }
            result.success(
                mapOf(
                    "pdf" to localPath(pdf.uri, "pdf"),
                    "images" to (scan.pages ?: emptyList())
                        .mapNotNull { page -> page.imageUri?.let { localPath(it, "jpg") } },
                ),
            )
        } catch (e: Throwable) {
            result.error("failed", describe(e, "Ergebnis"), null)
        }
    }

    private fun fail(e: Throwable, stage: String) {
        val result = pending ?: return
        pending = null
        result.error("unavailable", describe(e, stage), null)
    }

    private fun takePhoto(result: MethodChannel.Result) {
        if (pendingPhoto != null) {
            result.error("busy", "Es läuft bereits eine Aufnahme.", null)
            return
        }
        val dir = File(activity.cacheDir, "scans").apply { mkdirs() }
        val file = File.createTempFile("photo", ".jpg", dir)
        val uri = FileProvider.getUriForFile(
            activity,
            "${activity.packageName}.scanfiles",
            file,
        )
        pendingPhoto = result to file
        photoLauncher.launch(uri)
    }

    private fun onPhoto(saved: Boolean) {
        val (result, file) = pendingPhoto ?: return
        pendingPhoto = null
        if (saved && file.length() > 0) {
            result.success(file.absolutePath)
        } else {
            file.delete()
            result.success(null)
        }
    }

    /**
     * „Typ: Meldung (bei Klasse.methode:Zeile; Ursache: …)“ — auch wenn die
     * Meldung fehlt (z. B. NullPointerException), damit Fehlerberichte die
     * Stelle zeigen. Der volle Stacktrace landet zusätzlich im Logcat.
     */
    private fun describe(e: Throwable, stage: String = ""): String {
        Log.e("DocumentScanner", "Scanner-Fehler ($stage)", e)
        val text = listOfNotNull(e.javaClass.simpleName, e.message).joinToString(": ")
        // Erste Aufrufe außerhalb von java.*/kotlin.* — dort liegt die Ursache,
        // nicht in Hilfsfunktionen wie Objects.requireNonNull.
        val frames = e.stackTrace
            .filterNot { f ->
                f.className.startsWith("java.") || f.className.startsWith("kotlin.") ||
                    f.className.startsWith("libcore.") || f.className.startsWith("dalvik.")
            }
            .take(4)
            .joinToString(" < ") {
                "${it.className.substringAfterLast('.')}.${it.methodName}:${it.lineNumber}"
            }
        val cause = e.cause
        val parts = listOfNotNull(
            stage.ifEmpty { null },
            frames.ifEmpty { null }?.let { "bei $it" },
            cause?.let { "Ursache: ${it.javaClass.simpleName}: ${it.message}" },
        )
        return if (parts.isEmpty()) text else "$text (${parts.joinToString("; ")})"
    }

    /** Dateipfad für Dart; content://-URIs (oder file:// ohne Pfad) werden in
     *  den Cache kopiert. */
    private fun localPath(uri: Uri?, extension: String): String {
        requireNotNull(uri) { "Scanner lieferte keine Datei ($extension)" }
        val path = uri.path
        if (uri.scheme == "file" && path != null) return path
        val target = File.createTempFile("scan", ".$extension", activity.cacheDir)
        val input = activity.contentResolver.openInputStream(uri)
            ?: throw IllegalStateException("Scan-Datei nicht lesbar: $uri")
        input.use { source ->
            target.outputStream().use { source.copyTo(it) }
        }
        return target.absolutePath
    }
}
