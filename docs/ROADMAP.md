# Mai Doctor Hub — Review & Roadmap (nach I1)

Stand: 05.10.2026 · Basis: `main` @ `2a48626` + Bugfix „Bericht anhängen“

Leitplanke bleibt **Privacy first**: Daten liegen lokal, jede Funktion, die Daten
das Gerät verlassen lässt (Kalender, KI), ist **opt-in**, minimiert und
jederzeit abschaltbar.

---

## 1. Review: Features & UX (Ist-Stand I1)

### Was gut funktioniert
- Klare 4-Tab-Struktur (Home / Kalender / Akte / Einstellungen), Quick-Action
  „Termin hinzufügen“ prominent.
- Bidirektionale Timeline mit „Jetzt“-Anker ist ein starkes Muster.
- „Bericht fehlt“-Badge an vergangenen Terminen erzeugt den richtigen Nudge.
- Arzt kann direkt im Termin-Sheet neu angelegt werden (kein Kontextwechsel).
- FTS5-Suche über alle Entitäten, lokale Erinnerungen ohne Server.

### Bugs (behoben in diesem Branch)
| # | Problem | Ursache | Fix |
|---|---------|---------|-----|
| B1 | **PDF/Bild an Bericht anhängen schlägt fehl** (Android, ohne Rückmeldung) | `XFile.saveTo()` kopiert nach `Documents/reports/…`, der Ordner wurde nie angelegt → `PathNotFoundException`; Exception unbehandelt im `onPressed` → stiller Fehler | Ordner `recursive` anlegen, Kopie per Pfad mit Byte-Fallback (SAF/`content://`), Fehler als `ReportImportException` → Snackbar, verwaiste Datei bei DB-Fehler löschen. Tests: `test/report_import_test.dart` |

### UX-Verbesserung (umgesetzt in diesem Branch)
- **Autovervollständigung aus eigener Historie**: Körperregion, Fachrichtung,
  Symptom, Diagnose, Medikament, Dosierung, Einnahmeplan und Termintitel
  schlagen alle früher eingegebenen Werte vor — häufigste zuerst, dann zuletzt
  genutzte; Groß-/Kleinschreibung zusammengefasst; Präfix- vor Wort- vor
  Teiltreffern. Leeres Feld fokussieren zeigt die Top 8. Für Körperregion und
  Fachrichtung gibt es Startvorschläge, solange noch nichts erfasst ist.
  (`SuggestionRepository`, `SuggestionTextField`, `test/suggestion_test.dart`)
- Nächster Schritt: Vorschläge einzeln entfernen (Long-Press) und
  Tippfehler-Varianten zusammenführen, sobald Bearbeiten existiert.

### Bugs / Schwächen (offen)
| # | Befund | Prio |
|---|--------|------|
| B2 | Berichte lassen sich **nicht öffnen** (kein Viewer, kein Tap-Handler) — weder in Akte noch im Termin | P0 |
| B3 | PDF-Text-Extraktion ist seit `b2a9b0c` nur ein Stub → Suche findet keinen Berichtsinhalt; README behauptet noch `pdf_text` | P0 |
| B4 | „Bericht fehlt“ auf Home aktualisiert nicht nach Anhängen (Streams beobachten `reports` nicht) | P1 |
| B5 | „Bericht fehlt“ auch bei **abgesagten** Terminen; vergangene Termine bleiben `planned` (kein „erledigt“) | P1 |
| B6 | Termin löschen lässt Berichte/Notizen verwaist zurück (FKs nicht erzwungen, kein Cascade) | P1 |
| B7 | Akte: Suche filtert Entity-Typ **nach** `LIMIT 50`; Treffer haben `sortDate = now` | P2 |
| B8 | Diagnose-Status wird roh angezeigt („Diagnose · active“) | P2 |
| B9 | Home/Kalender erzeugen pro Build neue Streams + pro Karte eine eigene Query (N+1) → Flackern bei vielen Terminen | P2 |
| B10 | Web: Bericht-Bytes werden verworfen (`web-memory://…`) — Bericht existiert nur als Titel | P2 |

### UX-Lücken
1. **Kein Bearbeiten/Löschen** — nur Anlegen. Tap auf Arzt/Diagnose/Symptom/Medikament/Notiz/Bericht in der Akte tut nichts. Termin-Detail hat weder „Bearbeiten“, „Erledigt“, „Absagen“ noch „Löschen“ (Repo-Methoden `updateStatus`/`delete` existieren, sind aber nicht verdrahtet).
2. **Formulare zu dünn**: Arzt ohne Telefon/Adresse/Praxis (Felder existieren im Schema), Medikament ohne Start/Ende/Diagnose-Bezug, Notiz ohne Bezug zu Termin/Diagnose.
3. **Keine Verknüpfungen sichtbar**: Diagnose-Detail mit allen Terminen, Symptomen, Medikamenten, Berichten fehlt — das ist der eigentliche Mehrwert einer Akte.
4. **Symptom-Verlauf** wird beim Check-in erfasst, aber nirgends visualisiert (Chart pro Symptom).
5. **Termin-Vorbereitung**: vor einem Termin „Was will ich fragen?“ + Symptom-Zusammenfassung seit letztem Termin.
6. **Keine Datensicherung**: Deinstallation/Gerätewechsel = Datenverlust. Für eine lokal-only App ist ein (verschlüsselter) Export Pflicht.
7. **Kein App-Lock** (Biometrie/PIN) — bei Gesundheitsdaten erwartet.
8. Leere/Lade-Zustände uneinheitlich („Akte wird geladen…“ vs. Spinner), keine Undo-Snackbars.

---

## 2. Roadmap

### I2 — „Akte wird benutzbar“ (P0/P1, ~2 Sprints)
- **Berichte öffnen + PDF-Text**: `pdfrx` (PDFium via FFI, kein Legacy-Gradle-Plugin) liefert In-App-Viewer **und** Text-Extraktion → `pdf_extractor_io.dart` ersetzen, FTS befüllen, Re-Index-Button für Bestandsberichte. Bilder: `Image.file` + Zoom. (B2, B3)
- **CRUD überall**: generische Detailseite pro Entität mit Bearbeiten/Löschen (+ Undo), Termin: Bearbeiten / Erledigt / Absagen / Löschen (mit Cascade für Berichte inkl. Datei). (B5, B6, UX 1)
- **Reaktive Daten**: Repos liefern `Stream<List<AppointmentSummary>>` via Join statt N+1; `readsFrom` inkl. `reports`. (B4, B9)
- **Schema v2 + Migrationstests** (`drift_dev schema dump/generate`) — Voraussetzung für alles Weitere (Sync-Tabellen, Lock-Settings).
- **Backup/Restore**: verschlüsselter Export (SQLite + `reports/` als ZIP, AES-GCM mit Passphrase) über Share-Sheet; Import mit Versionsprüfung. (UX 6)
- README an Ist-Stand angleichen.

### I3 — „Akte wird klug“ (~2 Sprints)
- Diagnose-Detail als Hub (Termine, Symptome, Medikamente, Berichte, Notizen).
- Symptom-Verlaufsdiagramm, Check-in-Statistik.
- Termin-Vorbereitung (Fragenliste, Symptom-Zusammenfassung, Medikamentenliste als PDF/Share).
- App-Lock (`local_auth`), Bildschirm-Inhalte im Task-Switcher ausblenden (`FLAG_SECURE`).
- **Kalender-Export nach Google** (Abschnitt 3).

### I4 — „Assistent“
- **MCP-Server + Gemini / lokales Gemma** (Abschnitt 4).
- Optional: On-Device-Q&A in der App.

---

## 3. Kalender-Sync → Google Kalender (nur Push, einseitig)

### Anforderung
Termine aus Mai Doctor Hub erscheinen im Google Kalender, werden bei Änderung
aktualisiert und bei Löschen/Absage entfernt. **Nie** werden Google-Termine
in die App gelesen.

### Optionen
| Option | Wie | + | − |
|--------|-----|---|---|
| **A. Android-Kalender-Provider** (`device_calendar_plus` o. ä., `CalendarContract`) | App schreibt Events in einen vom Nutzer gewählten **Google-Konto-Kalender** auf dem Gerät; Android synchronisiert selbst zu Google | Kein OAuth, kein Google-Cloud-Projekt, kein Server, kein Token-Handling; funktioniert offline (Sync später) | Nur Android; kann keinen *neuen* Google-Kalender anlegen (lokale Kalender syncen nicht) → Nutzer wählt bestehenden oder legt „Arzttermine“ einmal in Google an |
| **B. Google Calendar API** (`google_sign_in` + `googleapis`) | OAuth, App legt eigenen Sekundärkalender „Mai Doctor Hub“ an und pflegt Events | Plattformübergreifend (auch Web), sauberer eigener Kalender | Google-Cloud-Projekt + OAuth-Verifizierung (Kalender-Scopes sind „sensitive“), Token-Handling, Netzfehler; Scope auf `calendar.app.created` beschränken |
| **C. ICS-Export / -Abo** | `.ics` pro Termin teilen bzw. alle exportieren | Trivial, universell | Kein Update/Löschen; Abo-URL bräuchte Server → widerspricht Privacy |

**Empfehlung:** A als primärer Weg (passt zu „kein Server, kein Account“),
C als Sofort-Fallback („Zum Kalender hinzufügen“ via Share), B erst wenn Web
ernsthaft genutzt wird.

### Design (gilt für A und B)
- **Neue Tabelle** `calendar_links`:
  `appointment_id PK · target ('device'|'google_api') · calendar_id · external_event_id · payload_hash · synced_at · last_error`
- **Outbox-Prinzip**: `AppointmentRepository.create/update/updateStatus/delete`
  rufen `CalendarSyncService.enqueue(appointmentId)` auf. Der Service
  berechnet den gewünschten Event-Stand, vergleicht `payload_hash` und macht
  `insert` / `update` / `delete` per gespeicherter `external_event_id`.
  Abgesagt/gelöscht → Event löschen. Idempotent, wiederholbar.
- **Einseitigkeit erzwingen**: Es wird ausschließlich über die gespeicherte
  Event-ID geschrieben; keine `list/query`-Aufrufe auf Fremd-Events. Wurde das
  Event in Google gelöscht, legt der nächste Push es neu an (App ist
  Source of Truth); manuelle Änderungen in Google werden überschrieben.
- **Datensparsamkeit (Einstellung „Was landet im Kalender?“)**:
  - Standard: Titel „Arzttermin“ + Arzt/Praxis + Adresse, Dauer, Erinnerung.
  - Optional: Termintitel. **Nie**: Diagnosen, Symptome, Notizen, Berichte.
  - Event-Beschreibung: „Verwaltet von Mai Doctor Hub“ (+ Deep-Link `maidoctorhub://appointment/<id>`).
- **Einstellungen**: Schalter „Termine in Kalender übertragen“, Kalenderwahl,
  Datenumfang, „Jetzt alle synchronisieren“, „Aus Kalender entfernen“
  (löscht alle verlinkten Events und `calendar_links`).
- **Berechtigungen (A)**: `READ_CALENDAR` + `WRITE_CALENDAR` (Read nur für die
  Kalenderliste), Laufzeit-Abfrage mit Erklärung.
- **Fehler**: `last_error` je Termin, Badge im Termin-Detail, Retry beim
  App-Start / nach Netzwechsel.
- **Tests**: `CalendarGateway`-Interface mit Fake → Unit-Tests für
  create/update/cancel/delete, Hash-Diffing, „Event extern gelöscht“.

Aufwand A: ca. 3–4 PT inkl. Settings-UI und Tests.

---

## 4. Daten für Gemini via MCP (optional lokal mit Gemma)

### Ziel
Ein LLM-Assistent kann Fragen wie „Wann war mein letztes MRT und was stand
drin?“ oder „Wie hat sich mein Kopfschmerz seit Mai entwickelt?“ beantworten —
über **lesende** Tools auf die eigene Akte.

### Kernproblem
Die Daten liegen in der App-Sandbox auf dem Handy; MCP-Clients (Gemini CLI,
Desktop-Clients) laufen typischerweise am Rechner. Gleichzeitig ist jeder
Cloud-LLM-Aufruf ein PHI-Abfluss.

### Architektur-Empfehlung
```
Handy (App)                          Rechner
┌──────────────────────┐   Export   ┌──────────────────────────────┐
│ Mai Doctor Hub       │──────────► │ mai-mcp (Dart CLI, read-only) │
│ „Für Assistent       │  verschl.  │  ├ liest Snapshot (SQLite)    │
│  exportieren“        │  Snapshot  │  └ MCP über stdio             │
└──────────────────────┘            └───────────┬──────────────────┘
                                                │
                       ┌────────────────────────┴───────────────────┐
                       │ Client A: Gemini CLI  (Cloud, opt-in)       │
                       │ Client B: MCP-fähiger Client + Ollama/Gemma │
                       │           (100 % lokal, empfohlen)          │
                       └─────────────────────────────────────────────┘
```

1. **Shared Core**: Schema + Queries aus `lib/data` in ein Dart-Paket
   `packages/mai_core` ziehen (ohne Flutter-Abhängigkeit), damit App und
   MCP-Server dieselben Drift-Tabellen nutzen.
2. **Snapshot-Export** in der App: SQLite-Kopie (+ extrahierter Berichtstext;
   Original-PDFs optional), verschlüsselt, Teilen per Share-Sheet / USB /
   Syncthing. Nutzt das Backup aus I2.
3. **`tools/mai_mcp`** — Dart-CLI mit `package:dart_mcp`, öffnet den Snapshot
   **read-only**, stdio-Transport. Tools (bewusst grob, gut beschrieben):
   | Tool | Zweck |
   |------|-------|
   | `search_records(query, types?, limit?)` | FTS über Akte inkl. Berichtstext |
   | `list_appointments(from?, to?, doctor?)` | Termine mit Arzt, Diagnosen, Berichtsstatus |
   | `get_appointment(id)` | Detail inkl. Notizen und Berichts-IDs |
   | `get_report_text(id, max_chars?)` | extrahierter Text eines Berichts |
   | `symptom_timeline(symptom, from?, to?)` | Check-in-Werte als Zeitreihe |
   | `list_medications(active_only?)` | Medikationsplan |
   | `get_diagnosis(id)` | Diagnose-Hub (verknüpfte Entitäten) |
   Resources: `mai://summary` (Kurzprofil: aktive Diagnosen, Medikamente,
   nächste Termine) als Einstiegskontext.
4. **Clients**
   - **Gemini CLI**: Eintrag in `~/.gemini/settings.json`
     ```json
     { "mcpServers": { "mai": {
         "command": "dart", "args": ["run", "tools/mai_mcp/bin/mai_mcp.dart",
                                     "--snapshot", "~/mai/snapshot.db"],
         "trust": false } } }
     ```
     Achtung: Tool-Ergebnisse (= Gesundheitsdaten) gehen an Google. Nur mit
     bewusstem Opt-in; Hinweis im Export-Dialog.
   - **Lokal mit Gemma**: Gemma (aktuelle Generation, Größe passend zur
     Hardware, z. B. 4B–12B) über **Ollama** oder **LM Studio**, angebunden
     über einen MCP-fähigen Client (LM Studio hat MCP-Support; alternativ
     Ollama + MCP-Bridge/Client wie `ollmcp` oder Open WebUI). Gleicher
     `mai_mcp`-Server, kein Byte verlässt den Rechner. **Empfohlener
     Standard.** Tool-Calling kleiner Modelle ist weniger zuverlässig → wenige,
     klar beschriebene Tools und `mai://summary` als Kontext helfen.
5. **Sicherheitsregeln für den Server**: nur lesend, kein Netzwerk-Transport
   per Default (stdio), Ergebnisgrößen begrenzen, Audit-Log der Tool-Aufrufe
   lokal, keine Original-PDFs ohne Flag.

### Spätere Ausbaustufen
- **MCP direkt in der App** (Streamable HTTP auf `127.0.0.1` / LAN mit
  Pairing-Token): kein Export nötig, aber Android-Hintergrundlimits und
  Angriffsfläche → erst nach App-Lock und Sicherheitsreview.
- **On-Device-Gemma in der App** (z. B. `flutter_gemma` / Google AI Edge
  LLM Inference) mit denselben Tool-Definitionen als In-App-Funktionsaufrufe:
  „Frag deine Akte“ komplett offline. Modellgröße (~1–3 GB) als optionaler
  Download.

Aufwand: Core-Extraktion 2 PT · Snapshot-Export 1–2 PT (auf Backup aufbauend) ·
MCP-Server + Tools + Tests 3 PT · Doku/Setup Gemini & Ollama 0,5 PT.

---

## 5. Future Enhancements

### Home-Bildschirm-Widgets (Android)
- **„Nächster Termin“** (2×1 / 4×1): Datum, Uhrzeit, Arzt, Countdown; Tap
  öffnet Termin-Detail per Deep-Link `maidoctorhub://appointment/<id>`.
- **„Check-in“** (1×1 / 2×1): Schnell-Check-in für das wichtigste offene
  Symptom (Skala 1–10 per Tap), ohne die App zu öffnen.
- **„Medikamente heute“** (4×2): Einnahmeplan des Tages, abhakbar.
- Umsetzung: `home_widget` (Flutter ↔ Glance/`AppWidgetProvider`), Daten
  werden beim Speichern als kleiner, **minimaler** Snapshot in
  `SharedPreferences` geschrieben (keine Diagnosen; Termintitel optional).
- Privacy: Widget-Inhalte sind auf dem Sperrbildschirm/Home sichtbar →
  Einstellung „Diskrete Widgets“ (nur „Arzttermin morgen 09:30“), bei
  aktivem App-Lock standardmäßig diskret.
- Aktualisierung: bei jeder Termin-/Medikationsänderung + täglich via
  `WorkManager`; kein Netzwerk.

### Material Theming
- **Material You / Dynamic Color** (`dynamic_color`): Farbschema aus dem
  Wallpaper (Android 12+), Fallback auf Seed `#1F6B5C`; Schalter
  „Systemfarben verwenden“.
- **Dark Mode**: `AppTheme.dark()` + `ThemeMode.system/light/dark` in den
  Einstellungen; harte Farbkonstanten (`AppColors.ink/muted/danger`) durch
  `ColorScheme`-Rollen bzw. eine `ThemeExtension` ersetzen.
- **Kontrast & Lesbarkeit**: Hochkontrast-Variante
  (`ColorScheme.fromSeed(contrastLevel: …)`), Textskalierung bis 200 %
  testen (Golden-Tests), Mindest-Touch-Targets 48 dp.
- **Typografie & Form**: eigene `TextTheme` (z. B. Inter/Atkinson
  Hyperlegible für Lesbarkeit), konsistente Radien/Abstände als Tokens,
  Material-3-Komponenten (`SearchAnchor`, `NavigationBar`, `Card.filled`).
- **Themed Icon** (Android 13 Monochrome-Launcher-Icon) und angepasster
  Splash (`flutter_native_splash`).

---

## 6. Reihenfolge (Vorschlag)
1. I2: Viewer + PDF-Text (`pdfrx`), CRUD, reaktive Streams, Schema v2, Backup.
2. I3: Diagnose-Hub, Symptom-Charts, App-Lock, **Kalender-Push (Option A)**.
3. I4: `mai_core` + `mai_mcp` (lokal/Gemma zuerst, Gemini opt-in).

Offene Entscheidungen:
- Ist Web ein echtes Ziel oder nur Debug? (bestimmt Kalender Option A vs. B)
- Welche Daten dürfen in den Google Kalender (nur „Arzttermin“ oder Titel)?
- Gemini-Cloud überhaupt anbieten oder nur lokal (Gemma)?
