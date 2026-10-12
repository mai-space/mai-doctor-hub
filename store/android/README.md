# Play-Store-Material: Ärzte

Alles, was die Play Console für den Store-Eintrag braucht. Dateien einfach
herauskopieren bzw. hochladen.

| Datei | Play Console → Feld | Vorgabe |
|---|---|---|
| `de-DE/title.txt` / `en-US/title.txt` | Hauptinfos → App-Name | max. 30 Zeichen (29) |
| `de-DE/short_description.txt` / `en-US/…` | Hauptinfos → Kurzbeschreibung | max. 80 Zeichen (76 / 73) |
| `de-DE/full_description.txt` / `en-US/…` | Hauptinfos → Vollständige Beschreibung | max. 4000 Zeichen (≈ 3250 / 3050) |
| `icon-512.png` | Grafiken → App-Symbol | 512 × 512, 32-Bit-PNG |
| `de-DE/feature-graphic.png` / `en-US/…` | Grafiken → Vorstellungsgrafik | 1024 × 500, PNG ohne Transparenz |
| `de-DE/phone/*.png` / `en-US/phone/*.png` | Grafiken → Screenshots für Smartphones | 8 Stück, 1080 × 1920 (9:16), 24-Bit-PNG |

Deutsch ist die Standardsprache (`de-DE`), Englisch (`en-US`) als
Übersetzung hinzufügen. Die Ordnernamen folgen dem fastlane-Schema, die
Texte lassen sich also später auch automatisch hochladen.

Screenshots in dieser Reihenfolge hochladen (Dateiname = Reihenfolge):
Home · Symptom-Verlauf · Erfassen · Für den Arztbesuch · Meine Akte ·
Kalender · Diagnose · Einstellungen (Kalender-Export und App-Sperre).

## Weitere Angaben in der Play Console

- **Kategorie:** Medizin (alternativ Gesundheit & Fitness)
- **E-Mail-Adresse:** joel@maispace.de
- **Entwickler:** maispace (Joël Maximilian Mai)
- **Datenschutzerklärung:** liegt unter `docs/datenschutz/` (GitHub Pages);
  bei aktivierten Pages ist die URL
  `https://mai-space.github.io/mai-doctor-hub/datenschutz/`.
- **Datensicherheit (Vorschlag, bitte selbst prüfen):** Es werden keine Daten
  erhoben oder an Dritte weitergegeben – alles bleibt auf dem Gerät. Daten
  verlassen das Gerät nur durch bewusste Aktionen der Nutzerin bzw. des
  Nutzers (Sicherung teilen, PDF teilen, Kalender-Export). Das optionale
  KI-Modell wird von Hugging Face geladen; dabei werden keine Akte-Daten
  übertragen.
- **Gesundheits-Apps-Erklärung:** Die App dokumentiert, sie diagnostiziert
  nicht und gibt keine Behandlungsempfehlungen (steht auch am Ende der
  Beschreibung).

## Wie die Bilder entstanden sind

- **Screenshots:** gerendert aus den echten Bildschirmen der App in einem
  Flutter-Test, mit einer frei erfundenen Beispielakte (Dr. Lena Sommer,
  Dr. Jonas Wagner, Dr. Mia Klein, Rückenschmerzen usw.). Keine echten
  Personen, keine Nutzerdaten. Datum ist der Tag der Erzeugung.
  Neu erzeugen (z. B. nach UI-Änderungen):

  ```bash
  flutter test tool/store_screenshots/store_screenshots_test.dart
  ```

- **Icon und Vorstellungsgrafik:** aus `assets/branding/logo.svg` abgeleitet,
  Quellen unter `tool/store_graphics/`. Neu rendern (braucht Node mit
  Playwright):

  ```bash
  node tool/store_graphics/render.cjs "$(dirname "$(which flutter)")/cache/artifacts/material_fonts"
  ```

- **Wear OS:** keine Screenshots – die Kacheln sind nativ und brauchen
  einen Emulator oder eine Uhr. Für eine Wear-OS-Veröffentlichung später
  ergänzen (mind. 384 × 384, quadratisch).
