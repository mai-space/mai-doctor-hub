# Mai Doctor Hub

Lokale Patientenakte — **Privacy first**, auf Deutsch und Englisch. Alle Daten bleiben auf dem Gerät. Kein Account, kein Server mit PHI; Kalender-Export und Assistent sind opt-in.

## Stack

- Flutter (Android + Web)
- Drift / SQLite3 Multiple Ciphers (verschlüsselt, + FTS5 für lokale Suche)
- Lokale Check-in-Notifications (`flutter_local_notifications`)
- Berichte: lokale Ablage unter `Documents/reports/`, PDF-Viewer + Text-Extraktion mit `pdfrx` (PDFium)
- Sicherung: AES-256-GCM / PBKDF2 (`packages/mai_backup_format`)

## Voraussetzungen

- Flutter SDK (getestet: 3.47.x)
- Android SDK für APK-Builds

```bash
flutter --version
flutter pub get
```

## Features

- **Home:** Quick Launch „Termin hinzufügen“, bidirektionale Timeline (Zukunft ↓ / Vergangenheit ↑), Status-Badges, „Bericht fehlt“, Check-in
- **Kalender:** Monat default, Toggle Tag/Woche/Jahr, Termin-Marker, Tagesliste
- **Meine Akte:** Filter, Sortierung, Volltextsuche (inkl. PDF-Text), Detailseiten mit Bearbeiten/Löschen für Ärzte, Diagnosen (mit Hub aller Verknüpfungen), Symptome (mit Verlaufsdiagramm), Medikamente, Notizen, Berichte, Termine
- **Berichte:** PDF/Bild anhängen, In-App-Viewer, Text-Erkennung (PDFium) → Suche
- **Eingaben:** Autovervollständigung aus allem, was schon einmal eingegeben wurde
- **Einstellungen:** Erinnerungen, Kalender-Export, App-Sperre, verschlüsselte Datensicherung
- **Kalender-Export (opt-in):** Termine einseitig in einen Gerätekalender (z. B. Google) — nur „Arzttermin“, Arzt, Ort; `.ics` pro Termin
- **Assistent auf dem Handy (optional):** „Frag deine Akte“ (✨ in Meine Akte) — Gemma 4 E2B läuft per LiteRT-LM komplett auf dem Gerät; Modell (~2,6 GB) wird auf Wunsch geladen und lässt sich wieder löschen. Android 11+, arm64, empfohlen ≥ 6 GB RAM. Optional **semantische Suche**: EmbeddingGemma (~180 MB, einmalig mit Hugging-Face-Token wegen Gemma-Lizenz) — Antworten nutzen dann die besten Treffer per Stichwort (BM25) *und* per Bedeutung; Vektoren liegen in der verschlüsselten App-Datenbank
- **Assistent am Rechner (optional):** [`tools/mai_mcp`](tools/mai_mcp/README.md) macht eine Sicherung read-only per MCP für Gemini oder lokales Gemma abfragbar

Review, Roadmap und Konzepte: [`docs/ROADMAP.md`](docs/ROADMAP.md)

## Entwicklung

```bash
# Web (schnelles UI-Debug; Notifications/PDF-Text eingeschränkt)
flutter run -d chrome

# Android
flutter run -d android

# Analyse & Tests
flutter analyze
flutter test
# PDF-Extraktionstests brauchen PDFium für den Host:
PDFIUM_PATH=/pfad/libpdfium.so flutter test

# Dart-Pakete
(cd packages/mai_backup_format && dart test)
(cd tools/mai_mcp && dart test)
```

Sprachen (Deutsch/Englisch nach Systemsprache, sonst Englisch): Texte liegen pro Bereich in `lib/l10n/parts/<bereich>.de.json` / `.en.json`. Nach Änderungen:

```bash
python3 tool/merge_arb.py && flutter gen-l10n
```

Neue Sprache: `*.<code>.json` je Bereich anlegen, `AppLocale.supported` in `lib/l10n/l10n.dart` und die Sprachliste in `tool/merge_arb.py` ergänzen.

Nach Schema-Änderungen an `lib/data/app_database.dart`:

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Release-APK (lokal)

```bash
flutter build apk --release
# → build/app/outputs/flutter-apk/app-release.apk
```

## CI (GitHub Actions)

Workflow: `.github/workflows/ci.yml` (Trigger: `push` auf alle Branches, `pull_request` auf `main`)

1. `flutter analyze` + `flutter test` (inkl. PDFium-Download für PDF-Tests); `dart analyze` + `dart test` für `packages/` und `tools/`
2. Release-APK → Artifact `app-release.apk` (Retention 14 Tage)
3. `deploy-mock` auf `main`: loggt nur `would deploy` — **kein PHI, kein Datenupload**

## Privacy

- Patientendaten nur in der lokalen SQLite-Datei der App-Sandbox — **verschlüsselt** (SQLite3 Multiple Ciphers); der Schlüssel ist mit einem Android-Keystore-Schlüssel verpackt und verlässt das Gerät nie
- Kein Android-/Google-Backup und kein Gerätetransfer der App-Daten (`allowBackup=false`, `data_extraction_rules.xml`); Umzug nur per verschlüsselter `.maibackup`-Sicherung
- Daten verlassen das Gerät nur durch bewusste Aktionen: verschlüsselte Sicherung, Kalender-Export (minimal, opt-in), MCP-Server auf eigenem Rechner
- Internet-Berechtigung nur für den Download des KI-Modells (Hugging Face); Fragen und Akte-Daten verarbeitet das Modell lokal, der Chatverlauf wird nicht gespeichert
- App-Sperre (Biometrie/Geräte-PIN) blendet Inhalte in Screenshots und „Zuletzt verwendet“ aus
- Berichte (PDF/Scan) unter `Documents/reports/`; extrahierter Text lokal indexiert
- Erinnerungen sind **lokal** (kein FCM/Server-Push)
- CI baut Artefakte; Mock-Deploy lädt **keine** Nutzerdaten hoch
