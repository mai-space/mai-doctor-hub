package space.mai.mai_doctor_hub.wear

import android.app.Activity
import android.content.Intent
import android.content.SharedPreferences
import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.os.Bundle
import android.util.TypedValue
import android.view.Gravity
import android.view.View
import android.view.ViewGroup
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.TextView

/**
 * Kurze Übersicht auf der Uhr: nächste Termine, Einnahmen von heute (zum
 * Abhaken) und Check-in (Stärke 0–10). Öffnet sich aus Kacheln und
 * Komplikationen beim passenden Abschnitt.
 */
class OverviewActivity : Activity(), SharedPreferences.OnSharedPreferenceChangeListener {
    private lateinit var store: WatchStore
    private lateinit var scroll: ScrollView
    private lateinit var content: LinearLayout
    private var section: String? = null
    private val anchors = mutableMapOf<String, View>()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        store = WatchStore(this)
        section = intent.getStringExtra(EXTRA_SECTION)
        content = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER_HORIZONTAL
        }
        scroll = ScrollView(this).apply {
            isFillViewport = true
            // Runde Displays: oben/unten und seitlich Abstand zum Rand.
            val side = (resources.displayMetrics.widthPixels * 0.12f).toInt()
            val top = (resources.displayMetrics.heightPixels * 0.14f).toInt()
            setPadding(side, top, side, top)
            clipToPadding = false
            addView(content)
        }
        setContentView(scroll)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        section = intent.getStringExtra(EXTRA_SECTION)
        render()
    }

    override fun onResume() {
        super.onResume()
        store.prefs.registerOnSharedPreferenceChangeListener(this)
        render()
        PhoneLink.sync(this)
    }

    override fun onPause() {
        store.prefs.unregisterOnSharedPreferenceChangeListener(this)
        super.onPause()
    }

    override fun onSharedPreferenceChanged(prefs: SharedPreferences?, key: String?) {
        runOnUiThread { render() }
    }

    private fun render() {
        val y = scroll.scrollY
        content.removeAllViews()
        anchors.clear()
        val now = System.currentTimeMillis()
        val data = store.load()
        if (data == null) {
            content.addView(text(getString(R.string.watch_open_phone), 15f, MUTED))
            return
        }
        appointments(data, now)
        medications(data, now)
        checkIn(data, now)
        if (store.outbox().isNotEmpty()) {
            content.addView(gap(12))
            content.addView(text(getString(R.string.watch_queued), 12f, MUTED))
        }
        val target = section?.let { anchors[it] }
        if (target != null) {
            // Nur einmal hinspringen, danach Scrollposition behalten.
            section = null
            scroll.post { scroll.scrollTo(0, target.top) }
        } else {
            scroll.post { scroll.scrollTo(0, y) }
        }
    }

    private fun appointments(data: WatchData, now: Long) {
        header(SECTION_APPOINTMENTS, R.string.tile_appointment_name)
        val upcoming = data.upcoming(now).take(3)
        if (upcoming.isEmpty()) {
            content.addView(text(getString(R.string.watch_no_appointments), 14f, MUTED))
            return
        }
        for (a in upcoming) {
            val who = a.doctor ?: a.title ?: getString(R.string.watch_appointment_generic)
            content.addView(text(WatchFormat.dayTime(this, a.at, now), 16f, TEXT, bold = true))
            content.addView(text(who, 14f, MUTED))
            WatchFormat.countdown(this, a, now)?.let { content.addView(text(it, 12f, ACCENT)) }
            content.addView(gap(6))
        }
    }

    private fun medications(data: WatchData, now: Long) {
        content.addView(gap(12))
        header(SECTION_MEDICATIONS, R.string.tile_meds_name)
        val today = data.dosesToday(now)
        when {
            today == null -> content.addView(text(getString(R.string.watch_meds_stale), 14f, MUTED))
            today.isEmpty() -> content.addView(text(getString(R.string.watch_meds_none), 14f, MUTED))
            else -> {
                val taken = today.count { it.done }
                content.addView(text(getString(R.string.watch_meds_taken_of, taken, today.size), 13f, MUTED))
                content.addView(gap(4))
                today.forEach { content.addView(doseRow(it)) }
            }
        }
    }

    private fun doseRow(dose: WatchDose): View {
        val what = dose.name ?: getString(R.string.watch_dose_generic)
        val time = WatchFormat.time(this, dose.at)
        val status = getString(
            when (dose.status) {
                null -> R.string.watch_dose_open
                "skipped" -> R.string.watch_dose_skipped
                else -> R.string.watch_dose_taken
            },
        )
        val mark = when (dose.status) {
            null -> "○"
            "skipped" -> "–"
            else -> "✓"
        }
        val detail = listOfNotNull(time, dose.dose ?: status).joinToString(" · ")
        return LinearLayout(this).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
            minimumHeight = dp(48)
            setPadding(dp(10), dp(4), dp(10), dp(4))
            background = rounded(if (dose.done) SURFACE else SURFACE_OPEN)
            layoutParams = LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT)
                .apply { bottomMargin = dp(4) }
            addView(
                TextView(this@OverviewActivity).apply {
                    text = mark
                    setTextSize(TypedValue.COMPLEX_UNIT_SP, 20f)
                    setTextColor(if (dose.done) ACCENT else TEXT)
                    setPadding(0, 0, dp(8), 0)
                },
            )
            addView(
                LinearLayout(this@OverviewActivity).apply {
                    orientation = LinearLayout.VERTICAL
                    addView(text(what, 14f, TEXT, bold = true, center = false))
                    addView(text(detail, 12f, MUTED, center = false))
                },
            )
            if (dose.done) {
                contentDescription = "$what $time, $status"
            } else {
                contentDescription = getString(R.string.watch_dose_mark, "$what $time")
                isClickable = true
                setOnClickListener {
                    store.enqueueIntake(dose.medicationId, dose.at)
                    WatchRefresh.all(this@OverviewActivity)
                    PhoneLink.sync(this@OverviewActivity)
                }
            }
        }
    }

    private fun checkIn(data: WatchData, now: Long) {
        content.addView(gap(12))
        header(SECTION_CHECK_IN, R.string.tile_checkin_name)
        val checkIn = data.checkIn
        if (checkIn == null) {
            content.addView(text(getString(R.string.watch_checkin_none), 14f, MUTED))
            return
        }
        checkIn.label?.let { content.addView(text(it, 14f, TEXT, bold = true)) }
        val done = data.checkInDoneToday(now)
        val todayValue = if (done) checkIn.lastValue else null
        content.addView(
            text(
                when {
                    todayValue != null -> getString(R.string.watch_checkin_today_value, todayValue)
                    done -> getString(R.string.watch_checkin_today_done)
                    else -> getString(R.string.watch_checkin_question)
                },
                14f,
                MUTED,
            ),
        )
        if (!checkIn.quick) {
            content.addView(text(getString(R.string.watch_checkin_on_phone), 12f, MUTED))
            return
        }
        content.addView(gap(6))
        // 0–10 in drei Reihen (4 · 4 · 3), groß genug zum Tippen.
        for (row in listOf(0..3, 4..7, 8..10)) {
            content.addView(
                LinearLayout(this).apply {
                    orientation = LinearLayout.HORIZONTAL
                    gravity = Gravity.CENTER
                    for (value in row) addView(scaleButton(checkIn.symptomId, value, value == todayValue))
                },
            )
        }
        content.addView(text(getString(R.string.watch_checkin_hint), 11f, MUTED))
    }

    private fun scaleButton(symptomId: String, value: Int, selected: Boolean): View =
        TextView(this).apply {
            text = value.toString()
            gravity = Gravity.CENTER
            setTextSize(TypedValue.COMPLEX_UNIT_SP, 15f)
            setTypeface(typeface, Typeface.BOLD)
            setTextColor(if (selected) ON_ACCENT else TEXT)
            background = rounded(if (selected) BUTTON else SURFACE_OPEN, dp(20).toFloat())
            layoutParams = LinearLayout.LayoutParams(dp(40), dp(40)).apply { setMargins(dp(2), dp(2), dp(2), dp(2)) }
            contentDescription = getString(R.string.watch_checkin_rate, value)
            setOnClickListener {
                store.enqueueCheckIn(symptomId, value)
                WatchRefresh.all(this@OverviewActivity)
                PhoneLink.sync(this@OverviewActivity)
            }
        }

    private fun header(key: String, title: Int) {
        val view = text(getString(title), 13f, ACCENT, bold = true)
        anchors[key] = view
        content.addView(view)
        content.addView(gap(4))
    }

    private fun text(
        value: String,
        size: Float,
        color: Int,
        bold: Boolean = false,
        center: Boolean = true,
    ): TextView = TextView(this).apply {
        text = value
        setTextSize(TypedValue.COMPLEX_UNIT_SP, size)
        setTextColor(color)
        if (bold) setTypeface(typeface, Typeface.BOLD)
        if (center) {
            gravity = Gravity.CENTER_HORIZONTAL
            layoutParams = LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT)
        }
    }

    private fun gap(height: Int): View = View(this).apply {
        layoutParams = LinearLayout.LayoutParams(1, dp(height))
    }

    private fun rounded(color: Int, radius: Float = dp(16).toFloat()) = GradientDrawable().apply {
        setColor(color)
        cornerRadius = radius
    }

    private fun dp(value: Int): Int = (value * resources.displayMetrics.density).toInt()

    companion object {
        const val EXTRA_SECTION = "section"
        const val SECTION_APPOINTMENTS = "appointments"
        const val SECTION_MEDICATIONS = "medications"
        const val SECTION_CHECK_IN = "checkin"

        private const val ACCENT = 0xFF7FD6C8.toInt()
        private const val TEXT = 0xFFFFFFFF.toInt()
        private const val MUTED = 0xFFB0BEC5.toInt()
        private const val ON_ACCENT = 0xFF00201B.toInt()
        private const val BUTTON = 0xFF7FD6C8.toInt()
        private const val SURFACE = 0xFF1C2523.toInt()
        private const val SURFACE_OPEN = 0xFF263331.toInt()
    }
}
