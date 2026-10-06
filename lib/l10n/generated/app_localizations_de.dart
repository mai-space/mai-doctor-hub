// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get catalogReminderMorningTitle => 'Morgen-Check-in';

  @override
  String get catalogReminderMorningBody =>
      'Wie geht es dir heute? Symptome kurz protokollieren.';

  @override
  String get catalogReminderEveningTitle => 'Abend-Check-in';

  @override
  String get catalogReminderEveningBody =>
      'Abendliche Symptom-Notizen — dauert nur einen Moment.';

  @override
  String get appTitle => 'Mai Doctor Hub';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonSave => 'Speichern';

  @override
  String get commonDelete => 'Löschen';

  @override
  String get commonEdit => 'Bearbeiten';

  @override
  String get commonClose => 'Schließen';

  @override
  String get commonAdd => 'Hinzufügen';

  @override
  String get commonBack => 'Zurück';

  @override
  String get commonNext => 'Weiter';

  @override
  String get commonDone => 'Fertig';

  @override
  String get commonYes => 'Ja';

  @override
  String get commonNo => 'Nein';

  @override
  String get commonOk => 'OK';

  @override
  String get commonUnderstood => 'Verstanden';

  @override
  String get commonRetry => 'Erneut versuchen';

  @override
  String get commonSearch => 'Suchen';

  @override
  String get commonNotes => 'Notizen';

  @override
  String get commonNote => 'Notiz';

  @override
  String get commonUndo => 'Rückgängig';

  @override
  String get commonRestore => 'Wiederherstellen';

  @override
  String get commonOptional => 'optional';

  @override
  String get commonNone => 'Keine Angabe';

  @override
  String get commonToday => 'Heute';

  @override
  String get commonTomorrow => 'Morgen';

  @override
  String get commonYesterday => 'Gestern';

  @override
  String get entityDoctor => 'Arzt';

  @override
  String get entityDoctors => 'Ärzte';

  @override
  String get entityDiagnosis => 'Diagnose';

  @override
  String get entityDiagnoses => 'Diagnosen';

  @override
  String get entitySymptom => 'Symptom';

  @override
  String get entitySymptoms => 'Symptome';

  @override
  String get entityAppointment => 'Termin';

  @override
  String get entityAppointments => 'Termine';

  @override
  String get entityReport => 'Bericht';

  @override
  String get entityReports => 'Berichte';

  @override
  String get entityMedication => 'Medikament';

  @override
  String get entityMedications => 'Medikamente';

  @override
  String get entityNote => 'Notiz';

  @override
  String get entityNotes => 'Notizen';

  @override
  String get entityPharmacy => 'Apotheke';

  @override
  String get entityPharmacies => 'Apotheken';

  @override
  String get entityVaccination => 'Impfung';

  @override
  String get entityVaccinations => 'Impfungen';

  @override
  String get entityEntry => 'Eintrag';

  @override
  String get homeAppointmentSaved => 'Termin gespeichert';

  @override
  String get homeWordmarkSubtitle => 'Deine Termine — lokal auf diesem Gerät';

  @override
  String get homeAddAppointment => 'Termin hinzufügen';

  @override
  String get homeCheckIn => 'Check-in';

  @override
  String get homeNow => 'Jetzt';

  @override
  String get homeEmptyTitle => 'Noch keine Termine';

  @override
  String get homeEmptyMessage =>
      'Lege deinen ersten Termin an — danach erscheinen hier nächste Termine nach unten und vergangene nach oben.';

  @override
  String get homeEmptyAction => 'Ersten Termin anlegen';

  @override
  String get homeCardDateTimePattern => 'EEE d. MMM · HH:mm';

  @override
  String get homeReportMissing => 'Bericht fehlt';

  @override
  String get homeDoctorNameMissing => 'Arztname fehlt';

  @override
  String get homePleaseChooseDoctor => 'Bitte einen Arzt wählen';

  @override
  String get homeSheetDateTimePattern => 'EEE, d. MMM yyyy · HH:mm';

  @override
  String get homeEditAppointment => 'Termin bearbeiten';

  @override
  String get homeDateAndTime => 'Datum & Uhrzeit';

  @override
  String get homeDuration => 'Dauer';

  @override
  String homeDurationMinutes(int minutes) {
    return '$minutes Min.';
  }

  @override
  String get homeTitleOptional => 'Titel (optional)';

  @override
  String get homeDoctorExisting => 'Vorhanden';

  @override
  String get homeDoctorCreateNew => 'Neu anlegen';

  @override
  String get homeDoctorName => 'Name';

  @override
  String get homeSpecialtyOptional => 'Fachrichtung (optional)';

  @override
  String get homeNoDoctorsYet => 'Noch keine Ärzte — wechsle zu „Neu anlegen“.';

  @override
  String get homeChooseDoctor => 'Arzt wählen';

  @override
  String get homeDiagnosesOptional => 'Diagnosen (optional)';

  @override
  String get homeNoDiagnoses => 'Keine Diagnosen — in der Akte anlegbar.';

  @override
  String get homeSymptomsOptional => 'Symptome (optional)';

  @override
  String get homeNoOpenSymptoms =>
      'Keine offenen Symptome — in der Akte anlegbar.';

  @override
  String get homeSaving => 'Speichern…';

  @override
  String get homeSaveChanges => 'Änderungen speichern';

  @override
  String get homeSaveAppointment => 'Termin speichern';

  @override
  String get homeIcsSaveDialogTitle => 'Kalenderdatei speichern';

  @override
  String get homeIcsSaved =>
      'Kalenderdatei gespeichert — mit Kalender-App öffnen.';

  @override
  String get homeAppointmentNotFound => 'Termin nicht gefunden';

  @override
  String get homeMarkDone => 'Als erledigt markieren';

  @override
  String get homeCancelAppointment => 'Absagen';

  @override
  String get homeReopen => 'Wieder planen';

  @override
  String get homeDoctorSummaryPdf => 'Zusammenfassung für Arzt (PDF)';

  @override
  String get homeExportIcs => 'Als Kalenderdatei (.ics)';

  @override
  String get homeDetailDateTimePattern => 'EEEE, d. MMMM yyyy · HH:mm';

  @override
  String get homeSymptomsAndCheckIns => 'Symptome & gemeldete Check-ins';

  @override
  String get homeNoReportYet => 'Noch kein Bericht — nach dem Termin ablegen.';

  @override
  String get homeReportScan => 'Scan';

  @override
  String get homeReportTextSearchable => 'Text durchsuchbar';

  @override
  String get homeReportNoText => 'Kein Text erkannt';

  @override
  String get homeAddReport => 'Bericht hinzufügen';

  @override
  String get homeNotesTip =>
      'Tipp: Fragen für den Termin vorab als Notiz festhalten.';

  @override
  String get homeCalendarTitle => 'Kalender';

  @override
  String get homeCalendarForward => 'Vor';

  @override
  String get homeCalendarDay => 'Tag';

  @override
  String get homeCalendarWeek => 'Woche';

  @override
  String get homeCalendarMonth => 'Monat';

  @override
  String get homeCalendarYear => 'Jahr';

  @override
  String get homeCalendarDayTitlePattern => 'EEEE, d. MMMM';

  @override
  String get homeCalendarNoAppointmentsOnDay => 'Keine Termine an diesem Tag';

  @override
  String homeCalendarWeekFrom(String date) {
    return 'Woche ab $date';
  }

  @override
  String get homeCalendarWeekStartPattern => 'd. MMM';

  @override
  String homeCalendarAppointmentCount(int count) {
    return '$count Termine';
  }

  @override
  String get homeCheckInEmptyTitle => 'Keine offenen Symptome';

  @override
  String get homeCheckInEmptyMessage =>
      'Alle Symptome sind geheilt oder noch keines angelegt.';

  @override
  String get homeCheckInHint => 'Skala 1–10 oder als geheilt markieren.';

  @override
  String get homeCheckInHealed => 'Geheilt';

  @override
  String get homeCheckInWillBeHealed => 'Wird als geheilt gespeichert';

  @override
  String get homeCheckInSaved => 'Check-in gespeichert';

  @override
  String get homeMedsTodayTitle => 'Medikamente heute';

  @override
  String get homeMedsTodayNone => 'Heute ist keine Einnahme geplant.';

  @override
  String get homeMedsTodayAllDone => 'Alles erledigt.';

  @override
  String homeMedsTodayOpen(int open, int total) {
    return '$open von $total offen';
  }

  @override
  String get homeTimePattern => 'HH:mm';

  @override
  String get homeIntakeSkipped => 'Ausgelassen';

  @override
  String get homeIntakeTaken => 'Eingenommen';

  @override
  String get homeIntakeTakenShort => 'Genommen';

  @override
  String homeIntakePlannedAt(String time) {
    return 'Geplant $time';
  }

  @override
  String get homeMedFormTablet => 'Tablette';

  @override
  String get homeMedFormCapsule => 'Kapsel';

  @override
  String get homeMedFormDrops => 'Tropfen';

  @override
  String get homeMedFormLiquid => 'Saft / Lösung';

  @override
  String get homeMedFormSpray => 'Spray';

  @override
  String get homeMedFormInhaler => 'Inhalator';

  @override
  String get homeMedFormOintment => 'Salbe / Creme';

  @override
  String get homeMedFormInjection => 'Spritze';

  @override
  String get homeMedFormPatch => 'Pflaster';

  @override
  String get homeMedFormSuppository => 'Zäpfchen';

  @override
  String get homeMedFormPowder => 'Pulver / Granulat';

  @override
  String get homeMedFormOther => 'Sonstiges';

  @override
  String get homeUnitPiece => 'Stück';

  @override
  String get homeUnitDrops => 'Tropfen';

  @override
  String get homeUnitSpray => 'Sprühstoß';

  @override
  String get homeUnitPuff => 'Hub';

  @override
  String get homeUnitApplication => 'Anwendung';

  @override
  String get homeUnitUnit => 'Einheit';

  @override
  String get homeUnitSachet => 'Beutel';

  @override
  String get homeUnitMeasuringSpoon => 'Messlöffel';

  @override
  String get homeUnitIu => 'IE';

  @override
  String get homeWeekdaysDaily => 'täglich';

  @override
  String get homeWeekdaysWorkdays => 'werktags';

  @override
  String get homeWeekdaysWeekend => 'am Wochenende';

  @override
  String get homeMedNameMissing => 'Name fehlt';

  @override
  String get homeMedCreate => 'Medikament anlegen';

  @override
  String get homeMedEdit => 'Medikament bearbeiten';

  @override
  String get homeMedStrength => 'Wirkstärke (z. B. 400 mg)';

  @override
  String get homeMedForm => 'Darreichungsform';

  @override
  String get homeMedDosePerIntake => 'Dosis je Einnahme';

  @override
  String get homeMedUnit => 'Einheit';

  @override
  String get homeMedInstructions => 'Hinweis (z. B. nach dem Essen)';

  @override
  String get homeMedIntakeTimes => 'Einnahmezeiten';

  @override
  String get homeMedAmount => 'Menge';

  @override
  String get homeMedAmountSameAsAbove => 'wie oben';

  @override
  String get homeMedRemoveIntakeTime => 'Einnahmezeit entfernen';

  @override
  String get homeMedAddIntakeTime => 'Einnahmezeit hinzufügen';

  @override
  String get homeMedRemind => 'An Einnahme erinnern';

  @override
  String get homeMedPeriod => 'Zeitraum';

  @override
  String get homeMedStart => 'Beginn';

  @override
  String get homeMedOngoing => 'Dauerhaft';

  @override
  String get homeMedUntilDate => 'Bis Datum';

  @override
  String get homeMedDays => 'Tage';

  @override
  String get homeMedEnd => 'Ende';

  @override
  String get homeMedNumberOfDays => 'Anzahl Tage';

  @override
  String homeMedLastIntakeOn(String date) {
    return 'Letzte Einnahme am $date';
  }

  @override
  String get homeMedAssignment => 'Zuordnung';

  @override
  String get homeMedPrescribedBy => 'Verschrieben von';

  @override
  String get homeMedAddPharmacy => 'Apotheke anlegen';

  @override
  String get homePharmacyEdit => 'Apotheke bearbeiten';

  @override
  String get homePharmacyAddress => 'Adresse';

  @override
  String get homePharmacyPhone => 'Telefon';

  @override
  String get homeVaccinationAdd => 'Impfung eintragen';

  @override
  String get homeVaccinationEdit => 'Impfung bearbeiten';

  @override
  String get homeVaccinationAgainst => 'Impfung gegen';

  @override
  String get homeVaccinationProduct => 'Impfstoff (Handelsname)';

  @override
  String get homeVaccinationDate => 'Geimpft am';

  @override
  String get homeVaccinationDoseNumber => 'Dosis-Nr.';

  @override
  String get homeVaccinationBatch => 'Charge';

  @override
  String get homeVaccinationBy => 'Geimpft von';

  @override
  String get homeVaccinationNextDue => 'Nächste Impfung fällig';

  @override
  String homeVaccinationPlusYears(int years) {
    return '+$years J.';
  }

  @override
  String get homeReportTextRecognized => 'Text erkannt und durchsuchbar';

  @override
  String get homeReportRecognizedText => 'Erkannter Text';

  @override
  String get homeReportNoTextDot => 'Kein Text erkannt.';

  @override
  String get homeReportNotFound => 'Bericht nicht gefunden';

  @override
  String get homeReportRename => 'Umbenennen';

  @override
  String get homeReportShowText => 'Erkannten Text zeigen';

  @override
  String get homeReportReindex => 'Text neu erkennen';

  @override
  String get homeReportDatePattern => 'd. MMM yyyy';

  @override
  String get homeReportFileUnavailable => 'Datei nicht verfügbar';

  @override
  String homeReportFileUnavailableHint(String date) {
    return 'Abgelegt am $date. Im Web werden Dateien nicht gespeichert; auf dem Gerät wurde die Datei evtl. entfernt.';
  }

  @override
  String get homeStatusPlanned => 'Geplant';

  @override
  String get homeStatusDone => 'Erledigt';

  @override
  String get homeStatusCancelled => 'Abgesagt';

  @override
  String get homeUnknownDoctor => 'Unbekannter Arzt';

  @override
  String get homeArchiveBlockedDoctor =>
      'Arzt hat noch Termine — erst Termine archivieren oder umhängen.';

  @override
  String get homeArchivePurgeBlockedDoctor =>
      'Arzt hat noch (archivierte) Termine — diese zuerst endgültig löschen.';

  @override
  String get homeArchiveDatePattern => 'd.M.yyyy';

  @override
  String get homeDiagnosisStatusActive => 'aktiv';

  @override
  String get homeDiagnosisStatusResolved => 'abgeschlossen';

  @override
  String get homeSymptomHealed => 'geheilt';

  @override
  String get homeRecordsDatePattern => 'dd.MM.yyyy';

  @override
  String homeVaccinationDoseLabel(int number) {
    return '$number. Dosis';
  }

  @override
  String get recordsTitle => 'Meine Akte';

  @override
  String get recordsAssistantTooltip => 'Assistent — Fragen an deine Akte';

  @override
  String get recordsVisitSummaryTooltip => 'Zusammenfassung für den Arztbesuch';

  @override
  String get recordsSortTooltip => 'Sortierung';

  @override
  String get recordsSortDate => 'Datum';

  @override
  String get recordsSortName => 'Name';

  @override
  String get recordsSortUpdated => 'Zuletzt geändert';

  @override
  String get recordsAddEntry => 'Eintrag anlegen';

  @override
  String get recordsSearchHint => 'Suche in Akte & Berichten…';

  @override
  String get recordsLoading => 'Akte wird geladen…';

  @override
  String get recordsEmpty => 'Noch keine Einträge';

  @override
  String recordsNoResults(String query) {
    return 'Keine Treffer für „$query“';
  }

  @override
  String get recordsEmptyHint =>
      'Filter und Suche sind bereit — lege den ersten Eintrag an.';

  @override
  String get recordsFilterAll => 'Alle';

  @override
  String get recordsCreateDoctors => 'Ärzte anlegen';

  @override
  String get recordsCreateDiagnoses => 'Diagnosen anlegen';

  @override
  String get recordsCreateSymptoms => 'Symptome anlegen';

  @override
  String get recordsCreateAppointments => 'Termine anlegen';

  @override
  String get recordsCreateReports => 'Berichte anlegen';

  @override
  String get recordsCreateMedications => 'Medikamente anlegen';

  @override
  String get recordsCreatePharmacies => 'Apotheken anlegen';

  @override
  String get recordsCreateVaccinations => 'Impfungen anlegen';

  @override
  String get recordsCreateNotes => 'Notizen anlegen';

  @override
  String get recordsDatePattern => 'd. MMM yyyy';

  @override
  String get recordsDateTimePattern => 'd. MMM yyyy · HH:mm';

  @override
  String get recordsTimePattern => 'HH:mm';

  @override
  String get recordsDiagnosisNone => 'Keine';

  @override
  String recordsDateClearTooltip(String label) {
    return '$label entfernen';
  }

  @override
  String get recordsDoctorCreateTitle => 'Arzt anlegen';

  @override
  String get recordsDoctorEditTitle => 'Arzt bearbeiten';

  @override
  String get recordsFieldName => 'Name';

  @override
  String get recordsFieldSpecialty => 'Fachrichtung';

  @override
  String get recordsFieldPractice => 'Praxis / Klinik';

  @override
  String get recordsFieldPhone => 'Telefon';

  @override
  String get recordsFieldAddress => 'Adresse';

  @override
  String get recordsDiagnosisCreateTitle => 'Diagnose anlegen';

  @override
  String get recordsDiagnosisEditTitle => 'Diagnose bearbeiten';

  @override
  String get recordsFieldTitle => 'Titel';

  @override
  String get recordsDiagnosisActive => 'Aktiv';

  @override
  String get recordsDiagnosisResolved => 'Abgeschlossen';

  @override
  String get recordsDiagnosisSince => 'Seit';

  @override
  String get recordsDiagnosisUntil => 'Bis';

  @override
  String get recordsSymptomCreateTitle => 'Symptom anlegen';

  @override
  String get recordsSymptomEditTitle => 'Symptom bearbeiten';

  @override
  String get recordsFieldSymptomLabel => 'Bezeichnung';

  @override
  String get recordsFieldBodyRegion => 'Körperregion';

  @override
  String get recordsNoteCreateTitle => 'Notiz anlegen';

  @override
  String get recordsNoteEditTitle => 'Notiz bearbeiten';

  @override
  String get recordsFieldText => 'Text';

  @override
  String get recordsReportRenameTitle => 'Bericht umbenennen';

  @override
  String recordsDeleteConfirmTitle(String what) {
    return '$what löschen?';
  }

  @override
  String get recordsDeleteConfirmBody =>
      'Das kann nicht rückgängig gemacht werden.';

  @override
  String get recordsScanDocument => 'Dokument scannen';

  @override
  String get recordsScanDocumentHint =>
      'Kamera · Text wird erkannt und durchsuchbar';

  @override
  String get recordsPickFiles => 'Dateien wählen';

  @override
  String get recordsPickFilesHint =>
      'PDFs oder Bilder · auch mehrere auf einmal';

  @override
  String get recordsScannerUnavailableTitle => 'Scanner startet nicht';

  @override
  String recordsScannerUnavailableBody(String details) {
    return 'Der Dokumentenscanner von Google startet auf diesem Gerät nicht. Ein Foto mit der Kamera funktioniert immer — der Text wird genauso erkannt.\n\nDetails: $details';
  }

  @override
  String get recordsPickFile => 'Datei wählen';

  @override
  String get recordsScanSaving => 'Scan wird gespeichert, Text wird erkannt…';

  @override
  String recordsScanFileName(String date) {
    return 'Scan $date.pdf';
  }

  @override
  String get recordsScanFileDatePattern => 'dd.MM.yyyy HH-mm';

  @override
  String get recordsScanSavedNoText => 'Scan gespeichert (kein Text erkannt)';

  @override
  String get recordsScanSavedWithText => 'Scan gespeichert — Text durchsuchbar';

  @override
  String recordsReportSaved(String title) {
    return 'Bericht „$title“ gespeichert';
  }

  @override
  String recordsReportsSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Berichte gespeichert',
      one: '1 Bericht gespeichert',
    );
    return '$_temp0';
  }

  @override
  String recordsImportPartial(int saved, int failed, String files) {
    return '$saved gespeichert, $failed fehlgeschlagen: $files';
  }

  @override
  String get recordsDeleteToArchive => 'Löschen (ins Archiv)';

  @override
  String get recordsNotFound => 'Eintrag nicht gefunden';

  @override
  String get recordsPractice => 'Praxis';

  @override
  String get recordsPhoneTapToCall => 'Telefon · tippen zum Anrufen';

  @override
  String get recordsAddressOpenMaps => 'Adresse · in Karten öffnen';

  @override
  String get recordsDoctorNoSymptoms => 'Noch keine Symptome bei diesem Arzt.';

  @override
  String get recordsAssign => 'Zuordnen';

  @override
  String get recordsStatusActive => 'aktiv';

  @override
  String get recordsStatusHealed => 'geheilt';

  @override
  String get recordsLinkedDirect => 'zugeordnet';

  @override
  String get recordsLinkedViaAppointments => 'aus Terminen';

  @override
  String get recordsDoctorNoAppointments => 'Keine Termine bei diesem Arzt.';

  @override
  String recordsAssignSymptomsTitle(String name) {
    return 'Symptome bei $name';
  }

  @override
  String get recordsNoSymptomsYet => 'Noch keine Symptome angelegt.';

  @override
  String recordsSince(String date) {
    return 'seit $date';
  }

  @override
  String recordsUntil(String date) {
    return 'bis $date';
  }

  @override
  String get recordsDiagnosisNoAppointments => 'Noch keinem Termin zugeordnet.';

  @override
  String get recordsNoSymptomsLinked => 'Keine Symptome verknüpft.';

  @override
  String get recordsNoMedicationsLinked => 'Keine Medikamente verknüpft.';

  @override
  String get recordsDiagnosisNoReports => 'Keine Berichte zu den Terminen.';

  @override
  String recordsHealedOn(String date) {
    return 'geheilt am $date';
  }

  @override
  String get recordsMarkHealed => 'Als geheilt markieren';

  @override
  String get recordsReopen => 'Wieder aktiv';

  @override
  String get recordsDiscussedAtAppointments => 'Besprochen bei Terminen';

  @override
  String get recordsHistory => 'Verlauf';

  @override
  String get recordsCheckIns => 'Check-ins';

  @override
  String get recordsNoCheckIns => 'Noch keine Check-ins.';

  @override
  String get recordsDeleteValue => 'Wert löschen';

  @override
  String recordsFrom(String date) {
    return 'ab $date';
  }

  @override
  String get recordsOngoing => 'dauerhaft';

  @override
  String get recordsDosePerIntake => 'Dosis je Einnahme';

  @override
  String get recordsInstructions => 'Hinweis';

  @override
  String get recordsPeriod => 'Zeitraum';

  @override
  String get recordsIntakeTimes => 'Einnahmezeiten';

  @override
  String get recordsNoIntakeTimes => 'Keine festen Einnahmezeiten.';

  @override
  String get recordsIntake => 'Einnahme';

  @override
  String get recordsRemindIntake => 'An Einnahme erinnern';

  @override
  String get recordsPrescribedBy => 'Verschrieben von';

  @override
  String get recordsIntakeLog => 'Einnahme-Protokoll';

  @override
  String get recordsTakenNow => 'Jetzt genommen';

  @override
  String get recordsNoIntakesYet => 'Noch keine Einnahme erfasst.';

  @override
  String recordsAdherence(int percent) {
    return 'Letzte 14 Tage: $percent % der geplanten Einnahmen genommen';
  }

  @override
  String get recordsTaken => 'Genommen';

  @override
  String get recordsSkipped => 'Ausgelassen';

  @override
  String recordsPlannedAt(String time) {
    return 'geplant $time';
  }

  @override
  String get recordsDeleteEntry => 'Eintrag löschen';

  @override
  String get recordsPharmacyNoMedications =>
      'Keine Medikamente von dieser Apotheke.';

  @override
  String recordsDoseNumber(int number) {
    return '$number. Dosis';
  }

  @override
  String get recordsVaccineProduct => 'Impfstoff';

  @override
  String get recordsBatch => 'Charge';

  @override
  String get recordsBoosterOverdue => 'Auffrischung überfällig';

  @override
  String get recordsNextDoseDue => 'Nächste Impfung fällig';

  @override
  String get recordsVaccinatedBy => 'Geimpft von';

  @override
  String recordsLastModified(String date) {
    return 'Zuletzt geändert $date';
  }

  @override
  String get recordsRelatedAppointment => 'Zugehöriger Termin';

  @override
  String get recordsRelatedDiagnosis => 'Zugehörige Diagnose';

  @override
  String get recordsTakePhoto => 'Foto aufnehmen';

  @override
  String get recordsTakePhotoHint =>
      'Kamera-App · Text wird erkannt und durchsuchbar';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsLoading => 'Einstellungen werden geladen…';

  @override
  String get settingsLocalOnlyTitle => 'Alles lokal auf diesem Gerät';

  @override
  String get settingsLocalOnlySubtitle =>
      'Keine Accounts, keine Patientendaten auf Servern.';

  @override
  String get settingsArchiveTitle => 'Archiv';

  @override
  String get settingsArchiveSubtitle =>
      'Gelöschte Einträge wiederherstellen oder endgültig löschen';

  @override
  String get settingsAppSection => 'App';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsLanguageValue => 'Deutsch';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsDateTimePattern => 'd. MMM, HH:mm';

  @override
  String get settingsBackupTaskBackup => 'Sicherung';

  @override
  String get settingsBackupTaskRestore => 'Wiederherstellung';

  @override
  String get settingsBackupTaskExport => 'Export';

  @override
  String get settingsBackupTaskImport => 'Import';

  @override
  String get settingsBackupTaskReindex => 'Indexierung';

  @override
  String settingsBackupFailed(String task) {
    return '$task fehlgeschlagen.';
  }

  @override
  String settingsBackupRunning(String task) {
    return '$task läuft…';
  }

  @override
  String get settingsBackupShareSubject => 'Mai Doctor Hub — Sicherung';

  @override
  String get settingsBackupCreated =>
      'Sicherung erstellt — Passwort gut aufbewahren!';

  @override
  String get settingsBackupPickTitle => 'Sicherung wählen';

  @override
  String get settingsBackupNotABackup =>
      'Keine Mai-Doctor-Hub-Sicherung (.maibackup).';

  @override
  String get settingsBackupRestoreConfirmTitle => 'Sicherung wiederherstellen?';

  @override
  String get settingsBackupRestoreConfirmText =>
      'Alle aktuellen Daten und Berichte auf diesem Gerät werden durch die Sicherung ersetzt. Der Kalender-Export muss danach neu eingerichtet werden.';

  @override
  String get settingsBackupReplace => 'Ersetzen';

  @override
  String get settingsBackupDatePattern => 'd. MMM yyyy';

  @override
  String settingsBackupRestored(String date) {
    return 'Sicherung vom $date wiederhergestellt.';
  }

  @override
  String settingsBackupRestoredMissing(String date, int missing) {
    return 'Sicherung vom $date wiederhergestellt ($missing Dateien fehlten).';
  }

  @override
  String get settingsDocumentsExportConfirmTitle => 'Dokumente exportieren?';

  @override
  String get settingsDocumentsExportConfirmText =>
      'Alle Berichte und Scans werden als ZIP mit lesbaren Dateinamen und einer Übersicht (CSV) geteilt. Das Archiv ist nicht verschlüsselt — nur an vertrauenswürdige Ziele senden.';

  @override
  String get settingsDocumentsExportAction => 'Exportieren';

  @override
  String get settingsDocumentsExportNone => 'Keine Dokumente zum Exportieren.';

  @override
  String settingsDocumentsShareSubject(int count) {
    return 'Mai Doctor Hub — $count Dokumente';
  }

  @override
  String get settingsReindexAllDone =>
      'Alle Berichte sind bereits durchsuchbar.';

  @override
  String settingsReindexCount(int count) {
    return '$count Bericht(e) jetzt durchsuchbar.';
  }

  @override
  String get settingsBackupSection => 'Datensicherung';

  @override
  String get settingsBackupDescription =>
      'Verschlüsselte Datei mit allen Daten und Berichten — z. B. für einen Gerätewechsel. Ohne Passwort nicht lesbar.';

  @override
  String get settingsBackupCreate => 'Sicherung erstellen';

  @override
  String get settingsBackupRestore => 'Sicherung wiederherstellen';

  @override
  String get settingsDocumentsExport => 'Dokumente exportieren';

  @override
  String get settingsDocumentsExportSubtitle =>
      'Alle Berichte & Scans als ZIP mit Übersicht';

  @override
  String get settingsDocumentsImport => 'Dokumente importieren';

  @override
  String get settingsDocumentsImportSubtitle =>
      'Mehrere PDFs oder Bilder auf einmal';

  @override
  String get settingsBackupWebUnavailable => 'Im Web nicht verfügbar';

  @override
  String get settingsReindexTitle => 'Berichte durchsuchbar machen';

  @override
  String get settingsReindexSubtitle =>
      'Text aus älteren PDF-Berichten erkennen';

  @override
  String settingsPassphraseMinLength(int count) {
    return 'Mindestens $count Zeichen.';
  }

  @override
  String get settingsPassphraseMismatch => 'Passwörter stimmen nicht überein.';

  @override
  String get settingsPassphraseSetTitle => 'Passwort festlegen';

  @override
  String get settingsPassphraseEnterTitle => 'Passwort eingeben';

  @override
  String get settingsPassphraseLabel => 'Passwort';

  @override
  String get settingsPassphraseShow => 'Anzeigen';

  @override
  String get settingsPassphraseHide => 'Verbergen';

  @override
  String get settingsPassphraseRepeat => 'Wiederholen';

  @override
  String get settingsPassphraseWarning =>
      'Ohne dieses Passwort lässt sich die Sicherung nicht öffnen — es gibt keine Wiederherstellung.';

  @override
  String get settingsCalendarNoPermission =>
      'Ohne Kalenderzugriff kein Export.';

  @override
  String get settingsCalendarNoWritable =>
      'Kein beschreibbarer Kalender auf dem Gerät.';

  @override
  String get settingsCalendarStopTitle => 'Kalender-Export beenden';

  @override
  String get settingsCalendarStopText =>
      'Sollen die bereits übertragenen Termine aus dem Kalender entfernt werden?';

  @override
  String get settingsCalendarKeep => 'Behalten';

  @override
  String get settingsCalendarRemove => 'Entfernen';

  @override
  String settingsCalendarRemovedCount(int count) {
    return '$count Termin(e) aus dem Kalender entfernt.';
  }

  @override
  String settingsCalendarRemovedResult(String result) {
    return 'Kalender entfernt: $result';
  }

  @override
  String settingsCalendarSyncedCount(int count) {
    return '$count Termin(e) aus dem Kalender abgeglichen.';
  }

  @override
  String settingsCalendarSyncedResult(String result) {
    return 'Kalender abgeglichen: $result';
  }

  @override
  String get settingsCalendarSection => 'Kalender';

  @override
  String get settingsCalendarExportTitle => 'Termine in Kalender übertragen';

  @override
  String get settingsCalendarExportSubtitle =>
      'Nur in eine Richtung, z. B. in deinen Google Kalender. Es wird nur „Arzttermin“, Arzt und Ort übertragen — keine Diagnosen oder Notizen.';

  @override
  String get settingsCalendarAndroidOnly => 'Nur in der Android-App verfügbar.';

  @override
  String get settingsCalendarTarget => 'Zielkalender';

  @override
  String get settingsCalendarAllowAccess => 'Kalenderzugriff erlauben';

  @override
  String get settingsCalendarIncludeTitle => 'Termintitel mit übertragen';

  @override
  String get settingsCalendarIncludeTitleSubtitle =>
      'Aus: „Arzttermin · Dr. …“. An: z. B. „MRT Knie · Dr. …“.';

  @override
  String settingsCalendarLinkedCount(int count) {
    return '$count Termin(e) im Kalender';
  }

  @override
  String settingsCalendarLinkedWithErrors(int count, int errors) {
    return '$count Termin(e) im Kalender · $errors Fehler';
  }

  @override
  String settingsCalendarLastSynced(String date) {
    return 'Zuletzt $date';
  }

  @override
  String get settingsCalendarSyncNow => 'Jetzt';

  @override
  String get settingsRemindersSection => 'Erinnerungen';

  @override
  String get settingsRemindersNew => 'Neu';

  @override
  String get settingsRemindersNotificationsOff => 'Benachrichtigungen sind aus';

  @override
  String get settingsRemindersNotificationsOffText =>
      'Erinnerungen werden geplant, aber nicht angezeigt.';

  @override
  String get settingsRemindersAllow => 'Erlauben';

  @override
  String get settingsRemindersEmpty =>
      'Keine Erinnerungen — mit „Neu“ anlegen.';

  @override
  String get settingsRemindersOpenCheckIn => 'Check-in jetzt öffnen';

  @override
  String get settingsRemindersAllOpenSymptoms => 'alle offenen Symptome';

  @override
  String get settingsRemindersPermissionTitle => 'Benachrichtigungen erlauben?';

  @override
  String get settingsRemindersPermissionText =>
      'Damit Erinnerungen erscheinen, braucht die App die Erlaubnis für Benachrichtigungen. Sie werden lokal geplant — ohne Server.';

  @override
  String get settingsRemindersLater => 'Später';

  @override
  String get settingsReminderNewTitle => 'Neue Erinnerung';

  @override
  String get settingsReminderTitle => 'Erinnerung';

  @override
  String get settingsReminderFieldTitle => 'Titel';

  @override
  String get settingsReminderFieldBody => 'Text (optional)';

  @override
  String get settingsReminderTime => 'Uhrzeit';

  @override
  String get settingsReminderWeekdays => 'Wochentage';

  @override
  String get settingsReminderSymptomsHint =>
      'Nur für Symptome (leer = alle offenen)';

  @override
  String get settingsAppointmentRemindersTitle => 'Termin-Erinnerungen';

  @override
  String get settingsAppointmentRemindersCalendarTip =>
      'Tipp: Termine gehen auch in deinen Kalender — ggf. doppelt erinnert. Eines von beiden abschalten.';

  @override
  String get settingsAppointmentRemindersSubtitle =>
      'Benachrichtigung vor Arztterminen. Wer lieber den Google Kalender nutzt, schaltet das aus.';

  @override
  String get settingsAppointmentRemindersLeadLabel => 'Erinnern vorher';

  @override
  String get settingsSecuritySection => 'Sicherheit';

  @override
  String get settingsLockTitle => 'App-Sperre';

  @override
  String get settingsLockSubtitle =>
      'Beim Öffnen und nach 1 Minute im Hintergrund mit Biometrie oder Geräte-PIN entsperren. Inhalte erscheinen nicht in Screenshots oder der App-Übersicht.';

  @override
  String get settingsLockNoDeviceLock =>
      'Keine Displaysperre eingerichtet — bitte zuerst in den Geräteeinstellungen PIN oder Biometrie aktivieren.';

  @override
  String get settingsLockLockedTitle => 'Mai Doctor Hub ist gesperrt';

  @override
  String get settingsLockLockedText =>
      'Mit Fingerabdruck, Gesicht oder Geräte-PIN entsperren.';

  @override
  String get settingsLockUnlock => 'Entsperren';

  @override
  String get settingsLockReasonSetup => 'App-Sperre einrichten';

  @override
  String get settingsLockReasonUnlock => 'Mai Doctor Hub entsperren';

  @override
  String settingsArchiveSnack(String label) {
    return '$label im Archiv';
  }

  @override
  String get settingsArchivePurgeAction => 'Endgültig löschen';

  @override
  String get settingsArchivePurgeTitle => 'Endgültig löschen?';

  @override
  String settingsArchivePurgeText(String title) {
    return '„$title“ wird unwiderruflich gelöscht (inkl. Dateien).';
  }

  @override
  String get settingsArchivePurgeAllTitle => 'Archiv leeren?';

  @override
  String get settingsArchivePurgeAllText =>
      'Alle archivierten Einträge werden unwiderruflich gelöscht.';

  @override
  String settingsArchivePurgedCount(int count) {
    return '$count Einträge endgültig gelöscht';
  }

  @override
  String get settingsArchiveEmptyAction => 'Leeren';

  @override
  String get settingsArchiveEmpty =>
      'Das Archiv ist leer. Gelöschte Einträge landen hier und lassen sich wiederherstellen.';

  @override
  String get settingsArchiveLoading => 'Wird geladen…';

  @override
  String settingsArchiveItemSubtitle(String type, String date) {
    return '$type · archiviert $date';
  }

  @override
  String get settingsOnboardingSkip => 'Überspringen';

  @override
  String get settingsOnboardingPrivacyTitle => 'Deine Akte bleibt bei dir';

  @override
  String get settingsOnboardingPrivacyText =>
      'Mai Doctor Hub speichert alles nur auf diesem Gerät. Kein Konto, kein Server. Was das Gerät verlässt — Sicherung, Kalender, Assistent — entscheidest du.';

  @override
  String get settingsOnboardingAllInOneTitle => 'Alles an einem Ort';

  @override
  String get settingsOnboardingAllInOneText =>
      'Termine, Ärzte, Diagnosen, Symptome, Medikamente und Arztberichte — durchsuchbar und miteinander verknüpft. Für den nächsten Arztbesuch hast du alles parat.';

  @override
  String get settingsOnboardingRemindersTitle => 'Erinnerungen';

  @override
  String get settingsOnboardingRemindersText =>
      'Damit wir dich an Check-ins, Termine und Medikamente erinnern können, braucht die App die Erlaubnis für Benachrichtigungen. Sie werden lokal auf dem Gerät geplant — ohne Push-Server. Du kannst das später jederzeit ändern.';

  @override
  String get settingsOnboardingAllowNotifications =>
      'Benachrichtigungen erlauben';

  @override
  String get settingsOnboardingAllowed => 'Erlaubt';

  @override
  String get settingsOnboardingDenied =>
      'Nicht erlaubt — in den Einstellungen der App jederzeit nachholbar.';

  @override
  String get settingsOnboardingStart => 'Los geht’s';

  @override
  String get settingsShellTabHome => 'Home';

  @override
  String get settingsShellTabCalendar => 'Kalender';

  @override
  String get settingsShellTabRecords => 'Meine Akte';

  @override
  String get settingsShellTabSettings => 'Einstellungen';

  @override
  String get settingsUnreadableTitle => 'Daten nicht lesbar';

  @override
  String get settingsUnreadableText =>
      'Die gespeicherten Daten konnten auf diesem Gerät nicht entschlüsselt werden. Die App startet deshalb leer.\n\nMit einer .maibackup-Sicherung lässt sich alles wiederherstellen: Einstellungen → Datensicherung → „Sicherung wiederherstellen“.';

  @override
  String get settingsChartEmpty =>
      'Noch keine Skalenwerte — per Check-in erfassen.';

  @override
  String get settingsChartDayPattern => 'd.M.';

  @override
  String get settingsChartDayTimePattern => 'd.M. HH:mm';

  @override
  String settingsChartSemantics(String from, String to, String value) {
    return 'Verlauf von $from bis $to, zuletzt $value von 10';
  }

  @override
  String get settingsSymptomReportNoCheckIns =>
      'Keine Check-ins in diesem Zeitraum.';

  @override
  String settingsSymptomReportCount(int count) {
    return '$count Check-in(s)';
  }

  @override
  String settingsSymptomReportCountStats(int count, String avg, String latest) {
    return '$count Check-in(s) · Ø $avg · zuletzt $latest/10';
  }

  @override
  String settingsObservationScale(String value) {
    return 'Stärke $value/10';
  }

  @override
  String settingsObservationColor(String value) {
    return 'Farbe $value';
  }

  @override
  String get settingsNotificationsTitle => 'Benachrichtigungen';

  @override
  String get settingsNotificationsSubtitle =>
      'Themen, Wichtigkeit und Sperrbildschirm';

  @override
  String get settingsNotificationsIntro =>
      'Jedes Thema hat einen eigenen Kanal. Lege fest, was dich laut erreichen soll, was leise reicht und was du gar nicht brauchst.';

  @override
  String get settingsNotificationLevelImportant => 'Wichtig';

  @override
  String get settingsNotificationLevelNormal => 'Normal';

  @override
  String get settingsNotificationLevelSilent => 'Leise';

  @override
  String get settingsNotificationLevelImportantHint =>
      'Ton und Banner oben auf dem Bildschirm';

  @override
  String get settingsNotificationLevelNormalHint =>
      'Ton, nur in der Benachrichtigungsleiste';

  @override
  String get settingsNotificationLevelSilentHint =>
      'Ohne Ton, nur in der Benachrichtigungsleiste';

  @override
  String get settingsNotificationDiscreet => 'Diskret';

  @override
  String get settingsNotificationDiscreetSubtitle =>
      'Ohne Namen von Medikamenten, Ärzten, Impfungen oder Symptomen – sinnvoll, wenn andere deinen Bildschirm sehen.';

  @override
  String get settingsNotificationOff => 'Aus';

  @override
  String get settingsNotificationSystemHint =>
      'Feinheiten wie Klingelton oder „Nicht stören“ kannst du zusätzlich in den Android-Einstellungen der App je Kanal anpassen.';

  @override
  String get settingsLockReasonDisable => 'App-Sperre ausschalten';

  @override
  String get settingsKeyUnavailableTitle => 'Daten gerade nicht lesbar';

  @override
  String get settingsKeyUnavailableText =>
      'Der Schlüssel deiner Akte ist im Moment nicht verfügbar. Deine Daten sind unverändert – bitte versuche es gleich noch einmal oder starte das Gerät neu.';

  @override
  String get svcAssistantTitle => 'Assistent';

  @override
  String get svcAssistantExample1 => 'Wann ist mein nächster Termin?';

  @override
  String get svcAssistantExample2 => 'Welche Medikamente nehme ich gerade?';

  @override
  String get svcAssistantExample3 =>
      'Wie haben sich meine Symptome entwickelt?';

  @override
  String get svcAssistantExample4 => 'Was stand im letzten Bericht?';

  @override
  String get svcAssistantDeleteModelQuestion => 'Modell löschen?';

  @override
  String svcAssistantDeleteModelBody(String size) {
    return 'Gibt $size Speicher frei. Für den Assistenten musst du es danach neu herunterladen.';
  }

  @override
  String get svcAssistantDeleteModel => 'Modell löschen';

  @override
  String get svcAssistantDeleteSearchModel => 'Suchmodell löschen';

  @override
  String get svcAssistantUnsupportedTitle => 'Auf diesem Gerät nicht verfügbar';

  @override
  String get svcAssistantAskTitle => 'Frag deine Akte';

  @override
  String get svcAssistantIntro =>
      'Antworten entstehen auf diesem Gerät aus deinen Einträgen und Berichten — nichts wird hochgeladen, der Verlauf wird nicht gespeichert.';

  @override
  String get svcAssistantDisclaimer =>
      'Keine ärztliche Beratung — Antworten können Fehler enthalten.';

  @override
  String get svcAssistantInputHint => 'Frage zu deiner Akte…';

  @override
  String get svcAssistantSend => 'Fragen';

  @override
  String svcAssistantNoAnswer(String error) {
    return 'Keine Antwort: $error';
  }

  @override
  String get svcAssistantReading => 'Liest deine Akte…';

  @override
  String get svcAssistantSetupTitle => 'Lokaler Assistent';

  @override
  String svcAssistantSetupBody(String model, String size) {
    return 'Stell Fragen zu Terminen, Medikamenten, Symptomen und Berichten. Das KI-Modell $model läuft vollständig auf diesem Gerät — deine Akte wird nie hochgeladen. Nur das Modell selbst wird einmalig heruntergeladen ($size, am besten im WLAN).';
  }

  @override
  String get svcAssistantLowMemory =>
      'Hinweis: Dieses Gerät hat wenig Arbeitsspeicher. Der Assistent kann langsam sein oder von Android beendet werden.';

  @override
  String svcAssistantDownloading(int percent) {
    return 'Wird geladen… $percent % — läuft auch weiter, wenn du die App verlässt.';
  }

  @override
  String svcAssistantDownloadModel(String size) {
    return 'Modell herunterladen ($size)';
  }

  @override
  String get svcSemanticTitle => 'Semantische Suche (optional)';

  @override
  String get svcSemanticActive =>
      'Aktiv: Antworten nutzen die besten Treffer per Stichwort und per Bedeutung.';

  @override
  String svcSemanticIndexing(int done, int total) {
    return 'Akte wird indexiert… $done/$total';
  }

  @override
  String svcSemanticDownloading(int percent) {
    return 'Suchmodell wird geladen… $percent %';
  }

  @override
  String svcSemanticIntro(String model, String size) {
    return 'Findet auch Einträge, in denen die Wörter deiner Frage nicht vorkommen (z. B. „Schilddrüse“ → TSH-Wert). Lädt $model ($size); die Suche läuft danach offline.\n\nGoogle gibt das Modell nur nach Annahme der Gemma-Lizenz frei. Dafür brauchst du einmalig einen kostenlosen Hugging-Face-Token:';
  }

  @override
  String get svcSemanticTokenLabel => 'Hugging-Face-Token (hf_…)';

  @override
  String get svcSemanticStep1 =>
      'Bei Hugging Face ein kostenloses Konto anlegen oder anmelden.';

  @override
  String get svcSemanticStep1Link => 'Hugging Face öffnen';

  @override
  String get svcSemanticStep2 =>
      'Die Modellseite öffnen und „Agree and access repository“ tippen (Googles Gemma-Lizenz). Erscheint dort kein Button, die Lizenz einmal auf Googles Originalseite akzeptieren.';

  @override
  String get svcSemanticStep2Link => 'Modellseite öffnen';

  @override
  String get svcSemanticStep2Google => 'Googles Originalseite';

  @override
  String get svcSemanticStep3 =>
      'Auf der Token-Seite „Create new token“ tippen, Typ „Read“ wählen, einen Namen vergeben und den Token (beginnt mit hf_) kopieren.';

  @override
  String get svcSemanticStep3Link => 'Token-Seite öffnen';

  @override
  String get svcSemanticStep4 =>
      'Den Token hier einfügen und „Semantische Suche aktivieren“ tippen. Er wird nur für den Download genutzt und nicht gespeichert.';

  @override
  String get svcSemanticLicenseHint =>
      'Schlägt der Download fehl, ist meist die Lizenz (Schritt 2) noch nicht akzeptiert.';

  @override
  String svcLinkCopied(String url) {
    return 'Link konnte nicht geöffnet werden und wurde kopiert: $url';
  }

  @override
  String get svcSemanticEnable => 'Semantische Suche aktivieren';

  @override
  String svcDownloadFailed(String error) {
    return 'Download fehlgeschlagen: $error';
  }

  @override
  String svcSemanticDownloadFailed(String error) {
    return 'Download fehlgeschlagen — Token und Lizenz prüfen. ($error)';
  }

  @override
  String svcIndexNotUpdated(String error) {
    return 'Index nicht aktualisiert: $error';
  }

  @override
  String get svcAssistantModelSize => 'ca. 2,6 GB';

  @override
  String get svcEmbedderModelSize => 'ca. 180 MB';

  @override
  String get svcAssistantAndroidOnly => 'Der Assistent läuft nur auf Android.';

  @override
  String svcAssistantDeviceCheckFailed(String error) {
    return 'Gerät nicht prüfbar: $error';
  }

  @override
  String get svcAssistantNeedsAndroid11 =>
      'Der lokale Assistent braucht mindestens Android 11.';

  @override
  String get svcAssistantNeedsArm64 =>
      'Der lokale Assistent braucht einen 64-Bit-ARM-Prozessor.';

  @override
  String get svcContextSystemPrompt =>
      'Du bist der Assistent der App „Mai Doctor Hub“. Du beantwortest Fragen zur\npersönlichen Gesundheitsakte des Nutzers auf Deutsch, kurz und klar.\nRegeln:\n- Nutze nur die Informationen aus dem Abschnitt AKTE. Steht etwas nicht darin,\n  sag ehrlich, dass es in der Akte nicht vermerkt ist.\n- Übernimm Daten, Uhrzeiten, Dosierungen und Werte exakt.\n- Stelle keine Diagnosen und gib keine Therapie- oder Dosierungsempfehlungen;\n  verweise bei medizinischen Fragen an Arzt, Ärztin oder Apotheke.\n- Bei Warnzeichen für einen Notfall: rate, sofort 112 anzurufen.';

  @override
  String get svcContextRecordHeading => 'AKTE';

  @override
  String get svcContextQuestionHeading => 'FRAGE';

  @override
  String svcContextToday(String date) {
    return 'Heute: $date';
  }

  @override
  String get svcContextActiveDiagnoses => 'Aktive Diagnosen';

  @override
  String svcSince(String date) {
    return 'seit $date';
  }

  @override
  String get svcCurrentMedications => 'Aktuelle Medikamente';

  @override
  String get svcContextOpenSymptoms => 'Offene Symptome (letzte 30 Tage)';

  @override
  String svcContextVaccineOn(String vaccine, String date) {
    return '$vaccine am $date';
  }

  @override
  String svcContextDoseNumber(int number) {
    return '$number. Dosis';
  }

  @override
  String svcContextNextDue(String date) {
    return 'nächste fällig $date';
  }

  @override
  String get svcContextMatchingEntries => 'Passende Einträge zur Frage:';

  @override
  String get svcContextUpcomingAppointments => 'Nächste Termine';

  @override
  String get svcContextPastAppointments => 'Letzte Termine';

  @override
  String get svcContextCancelled => 'abgesagt';

  @override
  String svcContextDiagnosesList(String list) {
    return 'Diagnosen: $list';
  }

  @override
  String svcContextIntake(String times) {
    return 'Einnahme $times';
  }

  @override
  String svcContextFor(String diagnosis) {
    return 'gegen $diagnosis';
  }

  @override
  String svcContextUntil(String date) {
    return 'bis $date';
  }

  @override
  String svcCheckInCount(int count) {
    return '$count Check-ins';
  }

  @override
  String svcContextLatest(String date, String value) {
    return 'zuletzt $date: $value';
  }

  @override
  String get svcContextDayPattern => 'dd.MM.yyyy';

  @override
  String get svcContextDayTimePattern => 'dd.MM.yyyy HH:mm';

  @override
  String get svcSummaryPdfTitle => 'Zusammenfassung für den Arztbesuch';

  @override
  String svcSummaryPdfFileName(String date) {
    return 'Arztbesuch_$date.pdf';
  }

  @override
  String get svcSummaryPdfDatePattern => 'dd.MM.yyyy';

  @override
  String get svcSummaryPdfDateTimePattern => 'dd.MM. HH:mm';

  @override
  String svcSummaryPdfFooter(String date) {
    return 'Erstellt am $date mit Mai Doctor Hub · Angaben des Patienten, keine ärztliche Dokumentation';
  }

  @override
  String svcSummaryPdfAppointment(String date, String doctor) {
    return 'Termin $date bei $doctor';
  }

  @override
  String svcSummaryPdfPeriod(String from, String to) {
    return 'Zeitraum $from – $to';
  }

  @override
  String get svcSummaryPdfQuestions => 'Meine Fragen & Anliegen';

  @override
  String get svcSummaryPdfDiagnoses => 'Bekannte Diagnosen';

  @override
  String get svcSummaryPdfActive => 'aktiv';

  @override
  String get svcSummaryPdfResolved => 'abgeklungen';

  @override
  String get svcSummaryPdfNoCheckIns => 'Keine Check-ins im Zeitraum.';

  @override
  String svcSummaryPdfStats(
    String average,
    String min,
    String max,
    String last,
  ) {
    return 'Ø $average/10, min $min, max $max, zuletzt $last';
  }

  @override
  String get svcSummaryPdfDate => 'Datum';

  @override
  String get svcSummaryPdfValue => 'Wert';

  @override
  String get svcSummaryPdfDose => 'Dosis';

  @override
  String get svcSummaryPdfIntake => 'Einnahme';

  @override
  String get svcSummaryPdfSinceUntil => 'Seit / bis';

  @override
  String get svcSummaryPdfProductBatch => 'Impfstoff / Charge';

  @override
  String get svcSummaryPdfNextDue => 'Nächste';

  @override
  String svcSummaryPdfDue(String list) {
    return 'Fällig: $list';
  }

  @override
  String get svcSummaryTitle => 'Für den Arztbesuch';

  @override
  String get svcSummarySaveDialog => 'Zusammenfassung speichern';

  @override
  String get svcSummarySaved => 'PDF gespeichert';

  @override
  String svcSummaryExportFailed(String error) {
    return 'Export fehlgeschlagen: $error';
  }

  @override
  String get svcSummaryShare => 'PDF teilen';

  @override
  String get svcSummaryIntro =>
      'Fragen, Symptom-Verläufe, Medikamente und Impfungen auf einen Blick — als PDF für die Praxis.';

  @override
  String get svcSummaryAppointmentDatePattern => 'd. MMM yyyy';

  @override
  String get svcSummaryReference => 'Bezug (bestimmt Zeitraum)';

  @override
  String get svcSummaryNoAppointment => 'Ohne — letzte 30 Tage';

  @override
  String get svcSummaryName => 'Name (optional, steht im PDF)';

  @override
  String get svcSummaryQuestions => 'Fragen & Anliegen';

  @override
  String get svcSummaryQuestionsHint =>
      'Eine Frage pro Zeile — Notizen zum Termin kommen automatisch dazu';

  @override
  String get svcSummaryAllSymptoms => 'Alle offenen Symptome';

  @override
  String get svcSummaryAllMedications => 'Alle aktuellen Medikamente';

  @override
  String get svcSummaryMore => 'Weiteres';

  @override
  String get svcReminderLead15Min => '15 Min.';

  @override
  String get svcReminderLead1Hour => '1 Std.';

  @override
  String get svcReminderLead2Hours => '2 Std.';

  @override
  String get svcReminderLead1Day => '1 Tag';

  @override
  String get svcReminderLead2Days => '2 Tage';

  @override
  String get svcReminderLead1Week => '1 Woche';

  @override
  String svcReminderInMinutes(int minutes, String time) {
    return 'In $minutes Minuten ($time)';
  }

  @override
  String svcReminderInHours(int hours, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'In $hours Stunden ($time)',
      one: 'In 1 Stunde ($time)',
    );
    return '$_temp0';
  }

  @override
  String svcReminderTomorrow(String time) {
    return 'Morgen $time';
  }

  @override
  String get svcReminderTimePattern => 'HH:mm';

  @override
  String get svcReminderDayPattern => 'EEE, d.M.';

  @override
  String get svcReminderAppointmentFallback => 'Arzttermin';

  @override
  String svcReminderMedicationTitle(String name) {
    return 'Einnahme: $name';
  }

  @override
  String get svcReminderTakeNow => 'Einnehmen';

  @override
  String get svcReminderCheckInDefault => 'Symptome kurz protokollieren.';

  @override
  String svcReminderCheckInSymptoms(String symptoms) {
    return 'Check-in: $symptoms';
  }

  @override
  String get svcChannelCheckIn => 'Symptom-Check-in';

  @override
  String get svcChannelCheckInDescription => 'Erinnerungen für Check-ins';

  @override
  String get svcChannelAppointmentDescription =>
      'Erinnerungen vor Arztterminen';

  @override
  String get svcChannelMedicationDescription => 'Einnahme-Erinnerungen';

  @override
  String svcCalendarEventTitle(String doctor) {
    return 'Arzttermin · $doctor';
  }

  @override
  String get svcCalendarManagedBy => 'Verwaltet von Mai Doctor Hub';

  @override
  String get svcCalendarNoPermission => 'Kalenderzugriff nicht erlaubt';

  @override
  String get svcCalendarNoEventId => 'Keine Event-ID erhalten';

  @override
  String get svcImportPickFailed => 'Dateiauswahl fehlgeschlagen';

  @override
  String svcImportUnsupportedType(String ext) {
    return 'Dateityp „$ext“ wird nicht unterstützt (PDF oder Bild).';
  }

  @override
  String get svcImportFileNotSaved =>
      'Datei konnte nicht lokal gespeichert werden.';

  @override
  String get svcImportReportNotSaved =>
      'Bericht konnte nicht gespeichert werden.';

  @override
  String svcExportFileName(String date) {
    return 'Mai-Doctor-Hub-Dokumente-$date.zip';
  }

  @override
  String get svcExportOverviewFile => 'Übersicht.csv';

  @override
  String get svcExportCsvHeader =>
      'Datum;Titel;Arzt;Termin;Quelle;Seiten;Datei';

  @override
  String get svcExportSourceImage => 'Bild';

  @override
  String get svcBackupTooNew =>
      'Sicherung stammt aus einer neueren App-Version — bitte App aktualisieren.';

  @override
  String get svcAssistantEmptyAnswer =>
      'Keine Antwort erhalten. Bitte die Frage kürzer oder genauer stellen.';

  @override
  String get svcQueryExpansionSystem =>
      'Du hilfst bei der Suche in einer persönlichen Gesundheitsakte. Antworte nur mit Suchbegriffen, durch Kommas getrennt, ohne weitere Worte.';

  @override
  String svcQueryExpansionPrompt(String question) {
    return 'Nenne bis zu 8 Suchbegriffe, mit denen man in Arztberichten, Notizen und Einträgen Antworten auf diese Frage findet: Synonyme, Fachbegriffe, Laienbegriffe, gängige Abkürzungen, Laborwerte oder Medikamentennamen. Frage: $question';
  }

  @override
  String get svcTopicMedication => 'Medikamenteneinnahme';

  @override
  String get svcTopicAppointmentSoon => 'Termin steht bevor';

  @override
  String get svcTopicAppointmentSoonDescription =>
      'Erinnerungen kurz vor einem Arzttermin (unter einem Tag)';

  @override
  String get svcTopicAppointmentAhead => 'Termin-Vorschau';

  @override
  String get svcTopicAppointmentAheadDescription =>
      'Hinweise auf Arzttermine ab einem Tag vorher';

  @override
  String get svcTopicVaccination => 'Impfungen';

  @override
  String get svcTopicVaccinationDescription => 'Fällige Auffrischungen';

  @override
  String get svcDiscreetMedicationTitle => 'Zeit für deine Einnahme';

  @override
  String get svcDiscreetAppointmentTitle => 'Erinnerung an einen Termin';

  @override
  String get svcDiscreetVaccinationTitle => 'Eine Impfung ist bald fällig';

  @override
  String get svcDiscreetCheckInTitle => 'Zeit für deinen Check-in';

  @override
  String get svcDiscreetBody => 'Details in Doctor Hub';

  @override
  String svcReminderVaccinationSoon(String vaccine) {
    return '$vaccine: in einer Woche fällig';
  }

  @override
  String svcReminderVaccinationToday(String vaccine) {
    return '$vaccine: heute fällig';
  }

  @override
  String get svcReminderVaccinationBody =>
      'Termin für die Auffrischung vereinbaren';
}
