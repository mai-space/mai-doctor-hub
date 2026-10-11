package space.mai.mai_doctor_hub.wear.complications

import android.app.PendingIntent
import android.content.Intent
import android.graphics.drawable.Icon
import androidx.wear.watchface.complications.data.ComplicationData
import androidx.wear.watchface.complications.data.ComplicationText
import androidx.wear.watchface.complications.data.ComplicationType
import androidx.wear.watchface.complications.data.LongTextComplicationData
import androidx.wear.watchface.complications.data.MonochromaticImage
import androidx.wear.watchface.complications.data.NoDataComplicationData
import androidx.wear.watchface.complications.data.PlainComplicationText
import androidx.wear.watchface.complications.data.ShortTextComplicationData
import androidx.wear.watchface.complications.datasource.ComplicationRequest
import androidx.wear.watchface.complications.datasource.SuspendingComplicationDataSourceService
import space.mai.mai_doctor_hub.wear.OverviewActivity
import space.mai.mai_doctor_hub.wear.WatchData
import space.mai.mai_doctor_hub.wear.WatchStore

/**
 * Gemeinsame Grundlage der Komplikationen: Stand aus [WatchStore], Tipp
 * öffnet die Übersicht auf der Uhr. Im diskreten Modus enthält der Stand
 * keine Namen — auf dem Zifferblatt erscheinen dann nur Zeiten und Zahlen.
 */
abstract class BaseComplication : SuspendingComplicationDataSourceService() {
    /** Symbol (einfarbig) der Komplikation. */
    protected abstract val iconRes: Int

    /** Abschnitt der Übersicht, den ein Tipp öffnet. */
    protected abstract val section: String

    /** Inhalt für [type]; `null` = nichts anzuzeigen. */
    protected abstract fun build(type: ComplicationType, data: WatchData, now: Long): ComplicationData?

    /** Beispielinhalt für die Auswahl am Zifferblatt. */
    protected abstract fun preview(type: ComplicationType): ComplicationData?

    override suspend fun onComplicationRequest(request: ComplicationRequest): ComplicationData? {
        val data = WatchStore(this).load() ?: return NoDataComplicationData()
        return build(request.complicationType, data, System.currentTimeMillis())
            ?: NoDataComplicationData()
    }

    override fun getPreviewData(type: ComplicationType): ComplicationData? = preview(type)

    protected fun plain(text: CharSequence): ComplicationText =
        PlainComplicationText.Builder(text).build()

    protected fun icon(): MonochromaticImage =
        MonochromaticImage.Builder(Icon.createWithResource(this, iconRes)).build()

    protected fun tap(): PendingIntent = PendingIntent.getActivity(
        this,
        section.hashCode(),
        Intent(this, OverviewActivity::class.java)
            .putExtra(OverviewActivity.EXTRA_SECTION, section)
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP),
        PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
    )

    /** Kurz- oder Langtext mit Symbol und Tipp. */
    protected fun textData(
        type: ComplicationType,
        text: String,
        title: String?,
        description: String,
    ): ComplicationData? = when (type) {
        ComplicationType.SHORT_TEXT -> ShortTextComplicationData.Builder(plain(text), plain(description))
            .setTitle(title?.let { plain(it) })
            .setMonochromaticImage(icon())
            .setTapAction(tap())
            .build()
        ComplicationType.LONG_TEXT -> LongTextComplicationData.Builder(plain(text), plain(description))
            .setTitle(title?.let { plain(it) })
            .setMonochromaticImage(icon())
            .setTapAction(tap())
            .build()
        else -> null
    }
}
