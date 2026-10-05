# mai_mcp — Deine Akte für Gemini & Gemma (MCP)

Read-only [MCP](https://modelcontextprotocol.io)-Server, der eine
**verschlüsselte Sicherung** aus Mai Doctor Hub für KI-Assistenten abfragbar
macht. Läuft lokal auf deinem Rechner über stdio und öffnet keine Ports.

```
Handy: Einstellungen → Datensicherung → „Sicherung erstellen“ (.maibackup)
        │  (USB, Syncthing, …; Datei bleibt verschlüsselt)
        ▼
Rechner: mai_mcp --backup akte.maibackup   ← Passwort aus Umgebungsvariable
        │  stdio (MCP)
        ├─► Gemini CLI                  (Cloud: Daten gehen an Google)
        └─► LM Studio / Ollama + Gemma  (100 % lokal, empfohlen)
```

## Datenschutz

- **Nur lesend.** Die Datenbank wird schreibgeschützt geöffnet; alle Tools
  tragen `readOnlyHint`.
- **Klartext nur kurzzeitig.** Die Sicherung wird gestreamt in einen
  temporären Ordner (`chmod 700`) entschlüsselt; nur der SQLite-Snapshot wird
  entpackt (keine Berichtsdateien) und beim Beenden gelöscht.
- **Audit-Log optional** (`--audit-log`): protokolliert nur *welches* Tool
  wann aufgerufen wurde, nie Argumente oder Inhalte.
- **Cloud-Modelle sehen die Antworten.** Mit Gemini (Cloud) werden die von
  den Tools gelieferten Gesundheitsdaten an Google übertragen. Wenn das nicht
  gewollt ist: Gemma lokal verwenden (siehe unten).
- Berichtsdateien (PDF/Bilder) werden nicht ausgeliefert, nur der in der App
  erkannte Text.

## Installation

Voraussetzung: Dart SDK ≥ 3.10 (oder Flutter 3.47).

```bash
cd tools/mai_mcp
dart pub get
dart compile exe bin/mai_mcp.dart -o ~/.local/bin/mai_mcp   # optional
```

Test ohne Client:

```bash
export MAI_BACKUP_PASSPHRASE='dein-sicherungspasswort'
mai_mcp --backup ~/Akte/mai-doctor-hub-2026-10-05.maibackup
# → „mai_mcp bereit (read-only).“ auf stderr; Strg+C beendet
```

> Tipp: Passwort nicht in Shell-History/Configs speichern, sondern z. B. aus
> dem Passwortmanager in die Umgebung laden (`export MAI_BACKUP_PASSPHRASE=$(pass mai)`).

## Tools

| Tool | Zweck |
|------|-------|
| `search_records(query, types?, limit?)` | Volltext über Akte inkl. Berichtstext, mit Textausschnitt |
| `list_appointments(from?, to?, doctor?, status?, limit?)` | Termine mit Arzt, Status, Diagnosen, Anzahl Berichte |
| `get_appointment(id)` | Termindetails, Notizen, Symptome, Berichts-IDs |
| `get_report_text(id, max_chars?)` | Erkannter Berichtstext (gekürzt, Std. 8000 Zeichen) |
| `symptom_timeline(symptom, from?, to?)` | Check-in-Verlauf + Statistik (min/max/Ø/letzter Wert) |
| `list_medications(active_only?)` | Medikationsplan (Form, Dosis, Einnahme, Arzt, Apotheke) |
| `list_vaccinations()` | Impfungen mit Charge und Fälligkeit |
| `get_diagnosis(diagnosis)` | Diagnose (ID oder Titel) mit allem Verknüpften |

Resource `mai://summary`: aktive Diagnosen, offene Symptome, aktuelle
Medikamente, nächste Termine — guter Einstiegskontext.

## Gemini CLI

`~/.gemini/settings.json`:

```json
{
  "mcpServers": {
    "mai": {
      "command": "mai_mcp",
      "args": ["--backup", "/home/ich/Akte/akte.maibackup"],
      "env": { "MAI_BACKUP_PASSPHRASE": "$MAI_BACKUP_PASSPHRASE" },
      "trust": false
    }
  }
}
```

Dann z. B.: *„Wann war mein letzter HNO-Termin und was stand im Bericht?“*
`trust: false` lässt Gemini vor jedem Tool-Aufruf nachfragen.

## Lokal mit Gemma (empfohlen)

Gemma läuft vollständig auf dem eigenen Rechner — kein Byte verlässt ihn.
Modellgröße nach Hardware wählen (z. B. 4B auf Laptops, 12B+ mit ≥ 16 GB
VRAM/Unified Memory). Kleinere Modelle rufen Tools weniger zuverlässig auf;
die wenigen, klar beschriebenen Tools und `mai://summary` helfen.

### LM Studio

1. Gemma-Modell mit Tool-Support laden.
2. *Program → Install → Edit `mcp.json`*:

   ```json
   {
     "mcpServers": {
       "mai": {
         "command": "mai_mcp",
         "args": ["--backup", "/home/ich/Akte/akte.maibackup"],
         "env": { "MAI_BACKUP_PASSPHRASE": "…" }
       }
     }
   }
   ```

### Ollama

Ollama selbst spricht kein MCP; ein MCP-fähiger Client verbindet beides,
z. B. [`ollmcp`](https://github.com/jonigl/mcp-client-for-ollama) oder
Open WebUI (MCP über `mcpo`):

```bash
ollama pull gemma3:12b   # bzw. aktuelle Gemma-Version
ollmcp --model gemma3:12b --servers-json ~/.config/mai/servers.json
```

`servers.json` hat dasselbe Format wie oben (`mcpServers`).

## Entwicklung

```bash
dart test                     # Abfragen, Snapshot, MCP-Protokoll, stdio-Prozess
dart run bin/mai_mcp.dart --db akte.sqlite   # unverschlüsselt, nur lokal
```

Das SQL-Schema ist an die App gekoppelt: `test/fixtures/schema.sql` wird vom
App-Test `test/schema_contract_test.dart` geprüft. Ändert sich das
App-Schema, dort mit `UPDATE_SCHEMA=1 flutter test test/schema_contract_test.dart`
aktualisieren und `supportedSchemaVersion` in `lib/src/snapshot.dart` anheben.
