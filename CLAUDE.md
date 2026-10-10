# Mai Doctor Hub — Hinweise für Änderungen

Lokale, verschlüsselte Gesundheitsakte (Flutter, Android). UI Deutsch/Englisch
nach Systemsprache.

## Rückwärtskompatibilität (Pflicht — es gibt echte Nutzer)

Jedes Update muss bestehende Installationen, Daten und Sicherungen ohne
Verlust weiterverwenden können.

- **Datenbank (drift, `lib/data/app_database.dart`)**
  - Nur additive Migrationen: neue Tabellen, neue Spalten *nullable oder mit
    Default*. Niemals Spalten/Tabellen löschen, umbenennen oder Typ ändern.
  - Jede Änderung: `schemaVersion` +1 und ein eigener Block
    `if (from < n)` in `onUpgrade` (strikt aufsteigend, alte Blöcke nie ändern).
  - Vor der Änderung das alte Schema als `test/migrations/v<alt>.sql` sichern
    und einen Migrationstest `v<alt> → v<neu>` mit Bestandsdaten ergänzen.
  - Enums (`intEnum`) nur am Ende erweitern — gespeichert wird der Index.
  - Danach: `dart run build_runner build --delete-conflicting-outputs`,
    `UPDATE_SCHEMA=1 flutter test test/schema_contract_test.dart` und
    `supportedSchemaVersion` in `tools/mai_mcp/lib/src/snapshot.dart` anheben.
- **Sicherungen (`packages/mai_backup_format`, `backup_service_io.dart`)**
  - Ältere Sicherungen müssen weiter wiederherstellbar sein (alte
    Schemaversion wird beim Restore migriert). Manifest nur erweitern,
    Felder nicht umdeuten.
- **Verschlüsselte Dateien (`FileVault`, Format „MAIV“ v1)** — Format nicht
  ändern; neue Formate nur mit neuer Versionsnummer und Lesbarkeit der alten.
- **Einstellungen/Benachrichtigungen** — gespeicherte JSON-Werte (z. B.
  `notification_topics`) tolerant lesen; unbekannte Werte ignorieren.
- **Modelle** — gepinnte Hugging-Face-Revisionen/SHA-256 nur gemeinsam ändern.

## Arbeitsweise

- Strings: `lib/l10n/parts/<bereich>.<de|en>.json` (neue Schlüssel anhängen,
  bestehende deutsche Texte nicht ändern — Tests prüfen sie), dann
  `python3 tool/merge_arb.py && flutter gen-l10n`.
- Prüfen vor jedem Commit: `flutter analyze` (sauber) und `flutter test`
  (komplett grün); bei Änderungen an `tools/mai_mcp` bzw.
  `packages/mai_backup_format` dort `dart analyze --fatal-infos && dart test`.
- Kein `dart format` auf ganze bestehende Dateien (erzeugt fremde Diffs).
- Release-Builds laufen mit R8: neue native Bibliotheken ggf. in
  `android/app/proguard-rules.pro` absichern (siehe Dokumentenscanner).
- Kommentare im Code auf Deutsch.
