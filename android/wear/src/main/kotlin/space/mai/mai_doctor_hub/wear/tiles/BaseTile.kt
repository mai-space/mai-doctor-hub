package space.mai.mai_doctor_hub.wear.tiles

import androidx.concurrent.futures.CallbackToFutureAdapter
import androidx.wear.protolayout.LayoutElementBuilders
import androidx.wear.protolayout.ResourceBuilders
import androidx.wear.protolayout.TimelineBuilders
import androidx.wear.tiles.EventBuilders
import androidx.wear.tiles.RequestBuilders
import androidx.wear.tiles.TileBuilders
import androidx.wear.tiles.TileService
import com.google.common.util.concurrent.ListenableFuture
import space.mai.mai_doctor_hub.wear.PhoneLink
import space.mai.mai_doctor_hub.wear.WatchData
import space.mai.mai_doctor_hub.wear.WatchRefresh
import space.mai.mai_doctor_hub.wear.WatchStore

/**
 * Gemeinsame Grundlage der Kacheln: Stand aus [WatchStore], Tipps auf
 * Knöpfe (Kachel wird mit deren ID neu angefordert), Nachladen vom Telefon.
 */
abstract class BaseTile : TileService() {
    /** Inhalt für [data] (`null` = noch kein Snapshot vom Telefon). */
    protected abstract fun layout(data: WatchData?, now: Long): LayoutElementBuilders.LayoutElement

    /** Tipp auf einen Knopf dieser Kachel; `true` = Stand hat sich geändert. */
    protected open fun onClick(store: WatchStore, clickId: String): Boolean = false

    override fun onTileRequest(
        requestParams: RequestBuilders.TileRequest,
    ): ListenableFuture<TileBuilders.Tile> {
        val store = WatchStore(this)
        val clickId = requestParams.currentState.lastClickableId
        if (clickId.isNotEmpty() && onClick(store, clickId)) {
            // Andere Kacheln/Komplikationen mitziehen, Telefon informieren.
            WatchRefresh.all(this)
            PhoneLink.sync(this)
        } else if (System.currentTimeMillis() - store.receivedAt() > STALE_MS) {
            PhoneLink.sync(this)
        }
        val now = System.currentTimeMillis()
        val tile = TileBuilders.Tile.Builder()
            .setResourcesVersion(TileUi.RESOURCES_VERSION)
            .setFreshnessIntervalMillis(FRESHNESS_MS)
            .setTileTimeline(TimelineBuilders.Timeline.fromLayoutElement(layout(store.load(), now)))
            .build()
        return immediate(tile)
    }

    override fun onTileResourcesRequest(
        requestParams: RequestBuilders.ResourcesRequest,
    ): ListenableFuture<ResourceBuilders.Resources> = immediate(TileUi.resources())

    override fun onTileAddEvent(requestParams: EventBuilders.TileAddEvent) {
        PhoneLink.sync(this)
    }

    private fun <T> immediate(value: T): ListenableFuture<T> =
        CallbackToFutureAdapter.getFuture { completer ->
            completer.set(value)
            "mai-tile"
        }

    private companion object {
        /** Neu zeichnen (Countdown, Tageswechsel). */
        const val FRESHNESS_MS = 15 * 60 * 1000L

        /** Älterer Stand → beim Telefon nachfragen. */
        const val STALE_MS = 30 * 60 * 1000L
    }
}
