package space.mai.mai_doctor_hub.widgets

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.os.Build
import android.os.Bundle
import android.util.SizeF
import android.widget.RemoteViews
import space.mai.mai_doctor_hub.R
import space.mai.mai_doctor_hub.watch.WatchSync

/**
 * Gemeinsame Grundlage der Widgets: responsive Layouts je Größe.
 *
 * Ab Android 12 bekommt der Launcher alle Varianten ([sizes]) auf einmal und
 * wählt beim Vergrößern/Verkleinern selbst die passende. Darunter rechnen
 * wir die Größe aus den Widget-Optionen und liefern genau eine Variante.
 */
abstract class BaseWidgetProvider : AppWidgetProvider() {
    /** Mindestgrößen (dp) der Varianten — die kleinste zuerst. */
    protected abstract val sizes: List<SizeF>

    /** Ansicht für ein Widget der Größe [width] × [height] (dp). */
    protected abstract fun build(
        context: Context,
        data: WidgetData?,
        width: Float,
        height: Float,
    ): RemoteViews

    override fun onUpdate(context: Context, manager: AppWidgetManager, ids: IntArray) {
        val data = WidgetStore(context).load()
        ids.forEach { render(context, manager, it, data) }
    }

    override fun onAppWidgetOptionsChanged(
        context: Context,
        manager: AppWidgetManager,
        id: Int,
        options: Bundle,
    ) {
        render(context, manager, id, WidgetStore(context).load())
    }

    fun renderAll(context: Context, manager: AppWidgetManager, data: WidgetData?) {
        manager.getAppWidgetIds(ComponentName(context, javaClass))
            .forEach { render(context, manager, it, data) }
    }

    private fun render(context: Context, manager: AppWidgetManager, id: Int, data: WidgetData?) {
        val views = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            RemoteViews(sizes.associateWith { build(context, data, it.width, it.height) })
        } else {
            val options = manager.getAppWidgetOptions(id)
            // Hochformat: Breite = kleinste, Höhe = größte gemeldete Angabe.
            val width = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MIN_WIDTH, 0)
            val height = options.getInt(AppWidgetManager.OPTION_APPWIDGET_MAX_HEIGHT, 0)
            val fallback = sizes.first()
            build(
                context,
                data,
                if (width > 0) width.toFloat() else fallback.width,
                if (height > 0) height.toFloat() else fallback.height,
            )
        }
        manager.updateAppWidget(id, views)
    }

    /** Hinweis statt Inhalt (z. B. noch keine Daten). */
    protected fun message(
        context: Context,
        icon: Int,
        text: Int,
        click: PendingIntent,
    ): RemoteViews = RemoteViews(context.packageName, R.layout.widget_message).apply {
        setImageViewResource(R.id.widget_icon, icon)
        setTextViewText(R.id.widget_text, context.getString(text))
        setOnClickPendingIntent(android.R.id.background, click)
    }
}

/** Zeichnet alle Widgets neu (nach neuem Snapshot oder Eingabe) und
 *  schickt den Stand an die Uhr-App, falls eine verbunden ist. */
object WidgetUpdater {
    fun updateAll(context: Context) {
        val manager = AppWidgetManager.getInstance(context)
        val data = WidgetStore(context).load()
        listOf(AppointmentWidget(), CheckInWidget(), MedicationsWidget())
            .forEach { it.renderAll(context, manager, data) }
        WatchSync.push(context)
    }
}
