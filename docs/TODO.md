# TODO — Iteration 5 (Android-App)

Vom Product Owner definiert (05.10.2026). Web bleibt außen vor. Jeder Punkt
wird einzeln umgesetzt, getestet und als eigener Commit gepusht.

Status: ☐ offen · ◐ in Arbeit · ☑ erledigt

## 1. ☐ Erinnerungen als eigene Einträge
- `SCHEDULE_EXACT_ALARM` aus dem Manifest entfernen (wird nicht genutzt,
  Play-Policy).
- Erinnerungen werden eine eigene Entität: beliebig viele, je mit Uhrzeit,
  Wochentagen, Titel/Text, an/aus.
- Standard wie bisher: 2 Erinnerungen (morgens 08:00, abends 20:00);
  bestehende Einstellungen werden übernommen.
- Optional einem oder mehreren Symptomen zugeordnet → individueller
  Check-in-Rhythmus pro Symptom.

## 2. ☐ Onboarding + Benachrichtigungs-Berechtigung
- Keine Berechtigungsabfrage mehr beim ersten App-Start.
- Kurzes Onboarding (wenige Seiten): Privacy-Versprechen, Funktionen,
  Erinnerungen — dort wird die Benachrichtigungs-Berechtigung mit
  Erklärung angefragt.
- Später erneut erreichbar, wenn Erinnerungen eingeschaltet werden.

## 3. ☐ Termin-Erinnerungen (umschaltbar)
- Lokale Erinnerungen vor Arztterminen (z. B. „Morgen 09:00 · Dr. …“).
- Ein-/ausschaltbar — wer den Google-Kalender bevorzugt, lässt sie aus.
- Vorlaufzeiten wählbar (z. B. 1 Tag und 1 Stunde vorher).
- Abgesagte/gelöschte Termine → Erinnerung entfernt; Änderungen →
  neu geplant.

## 4. ☐ Symptome ↔ Termine/Ärzte (n:m) mit gemeldeten Werten
- Symptome lassen sich Terminen **und** Ärzten zuordnen (n:m).
- Im Termin sieht man die zugeordneten Symptome mit den gemeldeten
  Check-ins (Datum + Wert), z. B. seit dem letzten Termin.
- Beim Arzt: alle ihm zugeordneten Symptome.

## 5. ☐ Medikamente als vollwertige Entität
- Neue Entität **Apotheke**; Medikament zugeordnet zu verschreibendem
  Arzt und Apotheke.
- Darreichungsform (Tablette, Kapsel, Tropfen, Spray, Salbe, Injektion …),
  Dosis (Menge + Einheit), Einnahmezeiten, Zeitraum (von/bis bzw. Dauer).
- Einnahme-Erinnerungen und Einnahme-Protokoll (genommen/ausgelassen).

## 6. ☐ Impfungen + Zusammenfassung für den Arztbesuch
- Neue Entität **Impfung** (Impfstoff, Datum, Dosis-Nr., Charge, Arzt,
  nächste Fälligkeit).
- Teilbares Dokument (PDF) für den Arztbesuch: Fragen/Notizen,
  Symptom-Verläufe, aktuelle Medikamente, Impfungen — Auswahl „alle“
  oder einzelne Symptome/Medikamente.

## 7. ☐ Kamera-Scan + Texterkennung (OCR)
- Berichte per Kamera scannen (Quelle `scan`).
- On-Device-Texterkennung für Fotos/Scans und für PDFs ohne Textebene →
  durchsuchbar. Keine Cloud.

## 8. ☐ Papierkorb / Archiv (Soft Delete + Rückgängig)
- Löschen verschiebt ins Archiv (Soft Delete) mit „Rückgängig“-Snackbar.
- Archiv-Ansicht: wiederherstellen oder endgültig löschen.
- Archivierte Einträge erscheinen nirgends sonst (Listen, Suche,
  Kalender-Export, Erinnerungen, MCP).

## 9. ☐ Sicherung als Stream + Import/Export von Dokumenten
- Sicherung wird gestreamt geschrieben/gelesen (kein Komplett-Laden in den
  Speicher), auch mit vielen großen PDFs.
- Export aller Berichte/Scans (PDFs, Bilder) als Archiv mit lesbaren
  Dateinamen.
- Import: mehrere PDFs/Bilder auf einmal übernehmen.
