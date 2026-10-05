# Mai Doctor Hub

Lokale Patientenakte (Iteration 1) — **Privacy first**. Alle Daten bleiben auf dem Gerät. Kein Account, kein Sync, kein Server mit PHI.

## Stack

- Flutter (Android + Web)
- Drift / SQLite (+ FTS5 für lokale Suche)
- Lokale Check-in-Notifications

## Voraussetzungen

- Flutter SDK (getestet: 3.47.x)
- Android SDK für APK-Builds

```bash
flutter --version
flutter pub get
```

## Entwicklung

```bash
# Web (schnelles UI-Debug)
flutter run -d chrome

# Android
flutter run -d android

# Analyse & Tests
flutter analyze
flutter test
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
- Berichte (PDF/Scan) im App-Dateisystem; extrahierter Text lokal indexiert
- CI baut Artefakte; Mock-Deploy lädt **keine** Nutzerdaten hoch
