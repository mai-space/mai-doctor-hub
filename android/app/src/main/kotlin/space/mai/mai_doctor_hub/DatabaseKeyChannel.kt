package space.mai.mai_doctor_hub

import android.content.Context
import android.security.keystore.KeyGenParameterSpec
import android.security.keystore.KeyProperties
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.security.KeyStore
import java.security.SecureRandom
import javax.crypto.Cipher
import javax.crypto.KeyGenerator
import javax.crypto.SecretKey
import javax.crypto.spec.GCMParameterSpec

/**
 * Schlüssel der verschlüsselten Datenbank.
 *
 * Ein zufälliger 256-Bit-Schlüssel wird mit einem AES-Schlüssel aus dem
 * Android Keystore verpackt und in `noBackupFilesDir` abgelegt. Der
 * Keystore-Schlüssel verlässt das Gerät nie — auch nicht über Google-Backups
 * oder Gerätewechsel. Ohne ihn ist die Datenbank nicht lesbar.
 */
class DatabaseKeyChannel(private val context: Context) : MethodChannel.MethodCallHandler {
    companion object {
        const val NAME = "mai/db_key"
        private const val ALIAS = "mai_doctor_hub_db_wrap"
        private const val FILE = "db.key"
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "getOrCreate" -> try {
                result.success(getOrCreate())
            } catch (e: Exception) {
                result.error("KEY_UNAVAILABLE", e.message, null)
            }
            // Nur wenn die Datenbank ohnehin unlesbar ist (Keystore verloren).
            "reset" -> {
                File(context.noBackupFilesDir, FILE).delete()
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

    @Synchronized
    private fun getOrCreate(): String {
        val file = File(context.noBackupFilesDir, FILE)
        if (file.exists()) {
            val stored = file.readBytes()
            val cipher = Cipher.getInstance("AES/GCM/NoPadding")
            cipher.init(
                Cipher.DECRYPT_MODE,
                wrappingKey(create = false),
                GCMParameterSpec(128, stored, 0, 12),
            )
            return cipher.doFinal(stored, 12, stored.size - 12).toHex()
        }
        val key = ByteArray(32).also { SecureRandom().nextBytes(it) }
        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        cipher.init(Cipher.ENCRYPT_MODE, wrappingKey(create = true))
        val sealed = cipher.iv + cipher.doFinal(key)
        val tmp = File(context.noBackupFilesDir, "$FILE.tmp")
        tmp.writeBytes(sealed)
        if (!tmp.renameTo(file)) throw IllegalStateException("Schlüssel nicht gespeichert")
        return key.toHex()
    }

    private fun wrappingKey(create: Boolean): SecretKey {
        val store = KeyStore.getInstance("AndroidKeyStore").apply { load(null) }
        (store.getKey(ALIAS, null) as? SecretKey)?.let { return it }
        if (!create) throw IllegalStateException("Keystore-Schlüssel fehlt")
        val generator = KeyGenerator.getInstance(KeyProperties.KEY_ALGORITHM_AES, "AndroidKeyStore")
        generator.init(
            KeyGenParameterSpec.Builder(
                ALIAS,
                KeyProperties.PURPOSE_ENCRYPT or KeyProperties.PURPOSE_DECRYPT,
            )
                .setBlockModes(KeyProperties.BLOCK_MODE_GCM)
                .setEncryptionPaddings(KeyProperties.ENCRYPTION_PADDING_NONE)
                .setKeySize(256)
                .build(),
        )
        return generator.generateKey()
    }

    private fun ByteArray.toHex() = joinToString("") { "%02x".format(it) }
}
