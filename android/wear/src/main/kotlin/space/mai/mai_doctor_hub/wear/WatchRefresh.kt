package space.mai.mai_doctor_hub.wear

import android.content.ComponentName
import android.content.Context
import androidx.wear.tiles.TileService
import androidx.wear.watchface.complications.datasource.ComplicationDataSourceUpdateRequester
import space.mai.mai_doctor_hub.wear.complications.AppointmentComplication
import space.mai.mai_doctor_hub.wear.complications.CheckInComplication
import space.mai.mai_doctor_hub.wear.complications.MedicationsComplication
import space.mai.mai_doctor_hub.wear.tiles.AppointmentTile
import space.mai.mai_doctor_hub.wear.tiles.CheckInTile
import space.mai.mai_doctor_hub.wear.tiles.MedicationsTile

/** Alle Kacheln und Komplikationen neu anfordern (neuer Stand). */
object WatchRefresh {
    fun all(context: Context) {
        val updater = TileService.getUpdater(context)
        listOf(AppointmentTile::class.java, MedicationsTile::class.java, CheckInTile::class.java)
            .forEach { updater.requestUpdate(it) }
        listOf(
            AppointmentComplication::class.java,
            MedicationsComplication::class.java,
            CheckInComplication::class.java,
        ).forEach {
            ComplicationDataSourceUpdateRequester
                .create(context, ComponentName(context, it))
                .requestUpdateAll()
        }
    }
}
