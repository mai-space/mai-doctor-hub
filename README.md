# Mai Doctor Hub

Lokale Patientenakte (Iteration 1) — **Privacy first**. Alle Daten bleiben auf dem Gerät. Kein Account, kein Sync, kein Server mit PHI.

## Stack

- Flutter (Android + Web)
- Drift / SQLite (+ FTS5 für lokale Suche)
- Lokale Check-in-Notifications (`flutter_local_notifications`)
- Berichte: Dateiauswahl + optionale PDF-Text-Extraktion (`pdf_text`, Android)

## Voraussetzungen

- Flutter SDK (getestet: 3.47.x)
- Android SDK für APK-Builds

```bash
flutter --version
flutter pub get
```

## Features (I1)

- **Home:** Quick Launch „Termin hinzufügen“, bidirektionale Timeline (Zukunft ↓ / Vergangenheit ↑), Check-in
- **Kalender:** Monat default, Toggle Tag/Woche/Jahr, Termin-Marker, Tagesliste
- **Meine Akte:** Entity-Filter, Sortierung, FTS (inkl. PDF-Text), CRUD für Ärzte/Diagnosen/Symptome/Medikamente/Notizen/Berichte/Termine
- **Einstellungen:** Morgen-/Abend-Erinnerungen, Privacy-Hinweis
- **Berichte:** lokal speichern, PDF-Text best-effort → FTS

## Entwicklung

```bash
# Web (schnelles UI-Debug; Notifications/PDF-Text eingeschränkt)
flutter run -d chrome

# Android
flutter run -d android

# Analyse & Tests
flutter analyze
flutter test
```

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

Workflow: `.github/workflows/ci.yml` (Trigger: `push`/`pull_request` auf `main`)

1. `flutter analyze` + `flutter test`
2. Release-APK → Artifact `app-release.apk` (Retention 14 Tage)
3. `deploy-mock` auf `main`: loggt nur `would deploy` — **kein PHI, kein Datenupload**

## Privacy

- Patientendaten nur in der lokalen SQLite-Datei der App-Sandbox
- Berichte (PDF/Scan) unter `Documents/reports/`; extrahierter Text lokal indexiert
- Erinnerungen sind **lokal** (kein FCM/Server-Push)
- CI baut Artefakte; Mock-Deploy lädt **keine** Nutzerdaten hoch
