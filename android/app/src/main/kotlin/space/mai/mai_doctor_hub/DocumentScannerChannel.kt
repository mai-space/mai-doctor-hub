package space.mai.mai_doctor_hub

import android.app.Activity
import android.net.Uri
import androidx.activity.ComponentActivity
import androidx.activity.result.ActivityResult
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.IntentSenderRequest
import androidx.activity.result.contract.ActivityResultContracts
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

    // Muss vor onCreate/STARTED registriert werden — daher im Konstruktor.
    private val launcher: ActivityResultLauncher<IntentSenderRequest> =
        activity.registerForActivityResult(
            ActivityResultContracts.StartIntentSenderForResult(),
            ::onResult,
        )

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "scan" -> start(result)
            else -> result.notImplemented()
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
                } catch (e: Exception) {
                    fail(e)
                }
            }
            .addOnFailureListener(::fail)
    }

    private fun onResult(activityResult: ActivityResult) {
        val result = pending ?: return
        pending = null
        if (activityResult.resultCode != Activity.RESULT_OK) {
            result.success(null)
            return
        }
        try {
            val scan = GmsDocumentScanningResult.fromActivityResultIntent(activityResult.data)
            val pdf = scan?.pdf
            if (pdf == null) {
                result.success(null)
                return
            }
            result.success(
                mapOf(
                    "pdf" to localPath(pdf.uri, "pdf"),
                    "images" to (scan.pages ?: emptyList()).map { localPath(it.imageUri, "jpg") },
                ),
            )
        } catch (e: Exception) {
            result.error("failed", e.message ?: e.javaClass.simpleName, null)
        }
    }

    private fun fail(e: Exception) {
        val result = pending ?: return
        pending = null
        result.error("unavailable", e.message ?: e.javaClass.simpleName, null)
    }

    /** Dateipfad für Dart; content://-URIs werden in den Cache kopiert. */
    private fun localPath(uri: Uri, extension: String): String {
        if (uri.scheme == "file") return uri.path!!
        val target = File.createTempFile("scan", ".$extension", activity.cacheDir)
        activity.contentResolver.openInputStream(uri)!!.use { input ->
            target.outputStream().use { input.copyTo(it) }
        }
        return target.absolutePath
    }
}
