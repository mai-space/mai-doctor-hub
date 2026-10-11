package space.mai.mai_doctor_hub.wear.tiles

import android.content.Context
import androidx.wear.protolayout.ActionBuilders
import androidx.wear.protolayout.ColorBuilders.argb
import androidx.wear.protolayout.DimensionBuilders.dp
import androidx.wear.protolayout.DimensionBuilders.expand
import androidx.wear.protolayout.DimensionBuilders.sp
import androidx.wear.protolayout.DimensionBuilders.wrap
import androidx.wear.protolayout.LayoutElementBuilders
import androidx.wear.protolayout.ModifiersBuilders
import androidx.wear.protolayout.ResourceBuilders
import space.mai.mai_doctor_hub.wear.OverviewActivity
import space.mai.mai_doctor_hub.wear.R

/** Bausteine der Kacheln: Symbol, Titel, große Zeile, Zusatz, Knopf. */
object TileUi {
    const val RESOURCES_VERSION = "1"
    const val ICON_CALENDAR = "calendar"
    const val ICON_MEDICATION = "medication"
    const val ICON_CHECKIN = "checkin"

    // Farben wie die App (Akzent Petrol), auf schwarzem Uhr-Hintergrund.
    private const val ACCENT = 0xFF2A9D8F.toInt()
    private const val TEXT = 0xFFFFFFFF.toInt()
    private const val MUTED = 0xFFB0BEC5.toInt()
    private const val ON_ACCENT = 0xFF00201B.toInt()
    private const val BUTTON = 0xFF7FD6C8.toInt()

    fun resources(): ResourceBuilders.Resources = ResourceBuilders.Resources.Builder()
        .setVersion(RESOURCES_VERSION)
        .addIdToImageMapping(ICON_CALENDAR, image(R.drawable.ic_calendar))
        .addIdToImageMapping(ICON_MEDICATION, image(R.drawable.ic_medication))
        .addIdToImageMapping(ICON_CHECKIN, image(R.drawable.ic_checkin))
        .build()

    private fun image(res: Int): ResourceBuilders.ImageResource =
        ResourceBuilders.ImageResource.Builder()
            .setAndroidResourceByResId(
                ResourceBuilders.AndroidImageResourceByResId.Builder().setResourceId(res).build(),
            )
            .build()

    /**
     * Ganze Kachel: Inhalt mittig, Tipp auf den Hintergrund öffnet die
     * Übersicht auf der Uhr (Abschnitt [section]).
     */
    fun root(
        context: Context,
        section: String,
        vararg content: LayoutElementBuilders.LayoutElement,
    ): LayoutElementBuilders.LayoutElement {
        val column = LayoutElementBuilders.Column.Builder()
            .setWidth(expand())
            .setHorizontalAlignment(LayoutElementBuilders.HORIZONTAL_ALIGN_CENTER)
        content.forEach { column.addContent(it) }
        return LayoutElementBuilders.Box.Builder()
            .setWidth(expand())
            .setHeight(expand())
            .setHorizontalAlignment(LayoutElementBuilders.HORIZONTAL_ALIGN_CENTER)
            .setVerticalAlignment(LayoutElementBuilders.VERTICAL_ALIGN_CENTER)
            .setModifiers(
                ModifiersBuilders.Modifiers.Builder()
                    .setClickable(openOverview(context, section))
                    .setPadding(
                        ModifiersBuilders.Padding.Builder()
                            .setStart(dp(20f))
                            .setEnd(dp(20f))
                            .build(),
                    )
                    .build(),
            )
            .addContent(column.build())
            .build()
    }

    fun icon(id: String): LayoutElementBuilders.LayoutElement =
        LayoutElementBuilders.Image.Builder()
            .setResourceId(id)
            .setWidth(dp(24f))
            .setHeight(dp(24f))
            .setColorFilter(
                LayoutElementBuilders.ColorFilter.Builder().setTint(argb(ACCENT)).build(),
            )
            .build()

    fun title(text: String) = text(text, 14f, MUTED, bold = false, lines = 1)

    fun headline(text: String) = text(text, 24f, TEXT, bold = true, lines = 1)

    fun body(text: String, lines: Int = 2) = text(text, 16f, TEXT, bold = false, lines = lines)

    fun hint(text: String, lines: Int = 2) = text(text, 13f, MUTED, bold = false, lines = lines)

    fun gap(height: Float = 6f): LayoutElementBuilders.LayoutElement =
        LayoutElementBuilders.Spacer.Builder().setHeight(dp(height)).build()

    /** Knopf, der die Kachel mit [clickId] neu anfordert (Aktion an der Uhr). */
    fun button(label: String, clickId: String, description: String): LayoutElementBuilders.LayoutElement =
        LayoutElementBuilders.Box.Builder()
            .setWidth(wrap())
            .setHeight(dp(40f))
            .setVerticalAlignment(LayoutElementBuilders.VERTICAL_ALIGN_CENTER)
            .setModifiers(
                ModifiersBuilders.Modifiers.Builder()
                    .setBackground(
                        ModifiersBuilders.Background.Builder()
                            .setColor(argb(BUTTON))
                            .setCorner(ModifiersBuilders.Corner.Builder().setRadius(dp(20f)).build())
                            .build(),
                    )
                    .setPadding(
                        ModifiersBuilders.Padding.Builder()
                            .setStart(dp(16f))
                            .setEnd(dp(16f))
                            .build(),
                    )
                    .setClickable(
                        ModifiersBuilders.Clickable.Builder()
                            .setId(clickId)
                            .setOnClick(ActionBuilders.LoadAction.Builder().build())
                            .build(),
                    )
                    .setSemantics(
                        ModifiersBuilders.Semantics.Builder().setContentDescription(description).build(),
                    )
                    .build(),
            )
            .addContent(text(label, 15f, ON_ACCENT, bold = true, lines = 1))
            .build()

    private fun text(
        value: String,
        size: Float,
        color: Int,
        bold: Boolean,
        lines: Int,
    ): LayoutElementBuilders.LayoutElement = LayoutElementBuilders.Text.Builder()
        .setText(value)
        .setMaxLines(lines)
        .setMultilineAlignment(LayoutElementBuilders.TEXT_ALIGN_CENTER)
        .setOverflow(LayoutElementBuilders.TEXT_OVERFLOW_ELLIPSIZE_END)
        .setFontStyle(
            LayoutElementBuilders.FontStyle.Builder()
                .setSize(sp(size))
                .setColor(argb(color))
                .setWeight(
                    if (bold) {
                        LayoutElementBuilders.FONT_WEIGHT_BOLD
                    } else {
                        LayoutElementBuilders.FONT_WEIGHT_NORMAL
                    },
                )
                .build(),
        )
        .build()

    private fun openOverview(context: Context, section: String): ModifiersBuilders.Clickable =
        ModifiersBuilders.Clickable.Builder()
            .setId("open:$section")
            .setOnClick(
                ActionBuilders.LaunchAction.Builder()
                    .setAndroidActivity(
                        ActionBuilders.AndroidActivity.Builder()
                            .setPackageName(context.packageName)
                            .setClassName(OverviewActivity::class.java.name)
                            .addKeyToExtraMapping(
                                OverviewActivity.EXTRA_SECTION,
                                ActionBuilders.AndroidStringExtra.Builder().setValue(section).build(),
                            )
                            .build(),
                    )
                    .build(),
            )
            .build()
}
