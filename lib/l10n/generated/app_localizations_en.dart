// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get catalogReminderMorningTitle => 'Morning check-in';

  @override
  String get catalogReminderMorningBody =>
      'How are you feeling today? Quickly log your symptoms.';

  @override
  String get catalogReminderEveningTitle => 'Evening check-in';

  @override
  String get catalogReminderEveningBody =>
      'Evening symptom notes — takes just a moment.';

  @override
  String get appTitle => 'Mai Doctor Hub';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonDelete => 'Delete';

  @override
  String get commonEdit => 'Edit';

  @override
  String get commonClose => 'Close';

  @override
  String get commonAdd => 'Add';

  @override
  String get commonBack => 'Back';

  @override
  String get commonNext => 'Next';

  @override
  String get commonDone => 'Done';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonOk => 'OK';

  @override
  String get commonUnderstood => 'Got it';

  @override
  String get commonRetry => 'Try again';

  @override
  String get commonSearch => 'Search';

  @override
  String get commonNotes => 'Notes';

  @override
  String get commonNote => 'Note';

  @override
  String get commonUndo => 'Undo';

  @override
  String get commonRestore => 'Restore';

  @override
  String get commonOptional => 'optional';

  @override
  String get commonNone => 'Not specified';

  @override
  String get commonToday => 'Today';

  @override
  String get commonTomorrow => 'Tomorrow';

  @override
  String get commonYesterday => 'Yesterday';

  @override
  String get entityDoctor => 'Doctor';

  @override
  String get entityDoctors => 'Doctors';

  @override
  String get entityDiagnosis => 'Diagnosis';

  @override
  String get entityDiagnoses => 'Diagnoses';

  @override
  String get entitySymptom => 'Symptom';

  @override
  String get entitySymptoms => 'Symptoms';

  @override
  String get entityAppointment => 'Appointment';

  @override
  String get entityAppointments => 'Appointments';

  @override
  String get entityReport => 'Report';

  @override
  String get entityReports => 'Reports';

  @override
  String get entityMedication => 'Medication';

  @override
  String get entityMedications => 'Medications';

  @override
  String get entityNote => 'Note';

  @override
  String get entityNotes => 'Notes';

  @override
  String get entityPharmacy => 'Pharmacy';

  @override
  String get entityPharmacies => 'Pharmacies';

  @override
  String get entityVaccination => 'Vaccination';

  @override
  String get entityVaccinations => 'Vaccinations';

  @override
  String get entityEntry => 'Entry';

  @override
  String get homeAppointmentSaved => 'Appointment saved';

  @override
  String get homeWordmarkSubtitle =>
      'Your appointments — stored only on this device';

  @override
  String get homeAddAppointment => 'Add appointment';

  @override
  String get homeCheckIn => 'Check-in';

  @override
  String get homeNow => 'Now';

  @override
  String get homeEmptyTitle => 'No appointments yet';

  @override
  String get homeEmptyMessage =>
      'Add your first appointment — upcoming ones will then appear below and past ones above.';

  @override
  String get homeEmptyAction => 'Add first appointment';

  @override
  String get homeCardDateTimePattern => 'EEE, MMM d · h:mm a';

  @override
  String get homeReportMissing => 'Report missing';

  @override
  String get homeDoctorNameMissing => 'Doctor name missing';

  @override
  String get homePleaseChooseDoctor => 'Please choose a doctor';

  @override
  String get homeSheetDateTimePattern => 'EEE, MMM d, yyyy · h:mm a';

  @override
  String get homeEditAppointment => 'Edit appointment';

  @override
  String get homeDateAndTime => 'Date & time';

  @override
  String get homeDuration => 'Duration';

  @override
  String homeDurationMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get homeTitleOptional => 'Title (optional)';

  @override
  String get homeDoctorExisting => 'Existing';

  @override
  String get homeDoctorCreateNew => 'Create new';

  @override
  String get homeDoctorName => 'Name';

  @override
  String get homeSpecialtyOptional => 'Specialty (optional)';

  @override
  String get homeNoDoctorsYet => 'No doctors yet — switch to “Create new”.';

  @override
  String get homeChooseDoctor => 'Choose doctor';

  @override
  String get homeDiagnosesOptional => 'Diagnoses (optional)';

  @override
  String get homeNoDiagnoses => 'No diagnoses — add them in My records.';

  @override
  String get homeSymptomsOptional => 'Symptoms (optional)';

  @override
  String get homeNoOpenSymptoms => 'No open symptoms — add them in My records.';

  @override
  String get homeSaving => 'Saving…';

  @override
  String get homeSaveChanges => 'Save changes';

  @override
  String get homeSaveAppointment => 'Save appointment';

  @override
  String get homeIcsSaveDialogTitle => 'Save calendar file';

  @override
  String get homeIcsSaved =>
      'Calendar file saved — open it with your calendar app.';

  @override
  String get homeAppointmentNotFound => 'Appointment not found';

  @override
  String get homeMarkDone => 'Mark as done';

  @override
  String get homeCancelAppointment => 'Cancel appointment';

  @override
  String get homeReopen => 'Reschedule';

  @override
  String get homeDoctorSummaryPdf => 'Summary for doctor (PDF)';

  @override
  String get homeExportIcs => 'As calendar file (.ics)';

  @override
  String get homeDetailDateTimePattern => 'EEEE, MMMM d, yyyy · h:mm a';

  @override
  String get homeSymptomsAndCheckIns => 'Symptoms & reported check-ins';

  @override
  String get homeNoReportYet =>
      'No report yet — add one after the appointment.';

  @override
  String get homeReportScan => 'Scan';

  @override
  String get homeReportTextSearchable => 'Text searchable';

  @override
  String get homeReportNoText => 'No text recognized';

  @override
  String get homeAddReport => 'Add report';

  @override
  String get homeNotesTip =>
      'Tip: jot down questions for the appointment as a note beforehand.';

  @override
  String get homeCalendarTitle => 'Calendar';

  @override
  String get homeCalendarForward => 'Next';

  @override
  String get homeCalendarDay => 'Day';

  @override
  String get homeCalendarWeek => 'Week';

  @override
  String get homeCalendarMonth => 'Month';

  @override
  String get homeCalendarYear => 'Year';

  @override
  String get homeCalendarDayTitlePattern => 'EEEE, MMMM d';

  @override
  String get homeCalendarNoAppointmentsOnDay => 'No appointments on this day';

  @override
  String homeCalendarWeekFrom(String date) {
    return 'Week of $date';
  }

  @override
  String get homeCalendarWeekStartPattern => 'MMM d';

  @override
  String homeCalendarAppointmentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count appointments',
      one: '1 appointment',
    );
    return '$_temp0';
  }

  @override
  String get homeCheckInEmptyTitle => 'No open symptoms';

  @override
  String get homeCheckInEmptyMessage =>
      'All symptoms are healed, or none have been added yet.';

  @override
  String get homeCheckInHint => 'Rate 1–10 or mark as healed.';

  @override
  String get homeCheckInHealed => 'Healed';

  @override
  String get homeCheckInWillBeHealed => 'Will be saved as healed';

  @override
  String get homeCheckInSaved => 'Check-in saved';

  @override
  String get homeMedsTodayTitle => 'Today\'s medications';

  @override
  String get homeMedsTodayNone => 'No doses scheduled for today.';

  @override
  String get homeMedsTodayAllDone => 'All done.';

  @override
  String homeMedsTodayOpen(int open, int total) {
    return '$open of $total open';
  }

  @override
  String get homeTimePattern => 'h:mm a';

  @override
  String get homeIntakeSkipped => 'Skipped';

  @override
  String get homeIntakeTaken => 'Taken';

  @override
  String get homeIntakeTakenShort => 'Taken';

  @override
  String homeIntakePlannedAt(String time) {
    return 'Scheduled $time';
  }

  @override
  String get homeMedFormTablet => 'Tablet';

  @override
  String get homeMedFormCapsule => 'Capsule';

  @override
  String get homeMedFormDrops => 'Drops';

  @override
  String get homeMedFormLiquid => 'Syrup / solution';

  @override
  String get homeMedFormSpray => 'Spray';

  @override
  String get homeMedFormInhaler => 'Inhaler';

  @override
  String get homeMedFormOintment => 'Ointment / cream';

  @override
  String get homeMedFormInjection => 'Injection';

  @override
  String get homeMedFormPatch => 'Patch';

  @override
  String get homeMedFormSuppository => 'Suppository';

  @override
  String get homeMedFormPowder => 'Powder / granules';

  @override
  String get homeMedFormOther => 'Other';

  @override
  String get homeUnitPiece => 'pc';

  @override
  String get homeUnitDrops => 'drops';

  @override
  String get homeUnitSpray => 'spray';

  @override
  String get homeUnitPuff => 'puff';

  @override
  String get homeUnitApplication => 'application';

  @override
  String get homeUnitUnit => 'unit';

  @override
  String get homeUnitSachet => 'sachet';

  @override
  String get homeUnitMeasuringSpoon => 'scoop';

  @override
  String get homeUnitIu => 'IU';

  @override
  String get homeWeekdaysDaily => 'daily';

  @override
  String get homeWeekdaysWorkdays => 'weekdays';

  @override
  String get homeWeekdaysWeekend => 'weekends';

  @override
  String get homeMedNameMissing => 'Name missing';

  @override
  String get homeMedCreate => 'Add medication';

  @override
  String get homeMedEdit => 'Edit medication';

  @override
  String get homeMedStrength => 'Strength (e.g. 400 mg)';

  @override
  String get homeMedForm => 'Form';

  @override
  String get homeMedDosePerIntake => 'Dose per intake';

  @override
  String get homeMedUnit => 'Unit';

  @override
  String get homeMedInstructions => 'Instructions (e.g. after meals)';

  @override
  String get homeMedIntakeTimes => 'Dose times';

  @override
  String get homeMedAmount => 'Amount';

  @override
  String get homeMedAmountSameAsAbove => 'same as above';

  @override
  String get homeMedRemoveIntakeTime => 'Remove dose time';

  @override
  String get homeMedAddIntakeTime => 'Add dose time';

  @override
  String get homeMedRemind => 'Remind me to take it';

  @override
  String get homeMedPeriod => 'Period';

  @override
  String get homeMedStart => 'Start';

  @override
  String get homeMedOngoing => 'Ongoing';

  @override
  String get homeMedUntilDate => 'Until date';

  @override
  String get homeMedDays => 'Days';

  @override
  String get homeMedEnd => 'End';

  @override
  String get homeMedNumberOfDays => 'Number of days';

  @override
  String homeMedLastIntakeOn(String date) {
    return 'Last dose on $date';
  }

  @override
  String get homeMedAssignment => 'Links';

  @override
  String get homeMedPrescribedBy => 'Prescribed by';

  @override
  String get homeMedAddPharmacy => 'Add pharmacy';

  @override
  String get homePharmacyEdit => 'Edit pharmacy';

  @override
  String get homePharmacyAddress => 'Address';

  @override
  String get homePharmacyPhone => 'Phone';

  @override
  String get homeVaccinationAdd => 'Add vaccination';

  @override
  String get homeVaccinationEdit => 'Edit vaccination';

  @override
  String get homeVaccinationAgainst => 'Vaccinated against';

  @override
  String get homeVaccinationProduct => 'Vaccine (brand name)';

  @override
  String get homeVaccinationDate => 'Date given';

  @override
  String get homeVaccinationDoseNumber => 'Dose no.';

  @override
  String get homeVaccinationBatch => 'Lot';

  @override
  String get homeVaccinationBy => 'Given by';

  @override
  String get homeVaccinationNextDue => 'Next dose due';

  @override
  String homeVaccinationPlusYears(int years) {
    return '+$years yr';
  }

  @override
  String get homeReportTextRecognized => 'Text recognized and searchable';

  @override
  String get homeReportRecognizedText => 'Recognized text';

  @override
  String get homeReportNoTextDot => 'No text recognized.';

  @override
  String get homeReportNotFound => 'Report not found';

  @override
  String get homeReportRename => 'Rename';

  @override
  String get homeReportShowText => 'Show recognized text';

  @override
  String get homeReportReindex => 'Recognize text again';

  @override
  String get homeReportDatePattern => 'MMM d, yyyy';

  @override
  String get homeReportFileUnavailable => 'File not available';

  @override
  String homeReportFileUnavailableHint(String date) {
    return 'Added on $date. Files aren\'t stored on the web; on this device the file may have been removed.';
  }

  @override
  String get homeStatusPlanned => 'Planned';

  @override
  String get homeStatusDone => 'Done';

  @override
  String get homeStatusCancelled => 'Canceled';

  @override
  String get homeUnknownDoctor => 'Unknown doctor';

  @override
  String get homeArchiveBlockedDoctor =>
      'This doctor still has appointments — archive or reassign them first.';

  @override
  String get homeArchivePurgeBlockedDoctor =>
      'This doctor still has (archived) appointments — delete those permanently first.';

  @override
  String get homeArchiveDatePattern => 'M/d/yyyy';

  @override
  String get homeDiagnosisStatusActive => 'active';

  @override
  String get homeDiagnosisStatusResolved => 'resolved';

  @override
  String get homeSymptomHealed => 'healed';

  @override
  String get homeRecordsDatePattern => 'MM/dd/yyyy';

  @override
  String homeVaccinationDoseLabel(int number) {
    return 'Dose $number';
  }

  @override
  String get recordsTitle => 'My records';

  @override
  String get recordsAssistantTooltip => 'Assistant — ask about your records';

  @override
  String get recordsVisitSummaryTooltip => 'Summary for your doctor visit';

  @override
  String get recordsSortTooltip => 'Sort';

  @override
  String get recordsSortDate => 'Date';

  @override
  String get recordsSortName => 'Name';

  @override
  String get recordsSortUpdated => 'Last modified';

  @override
  String get recordsAddEntry => 'Add entry';

  @override
  String get recordsSearchHint => 'Search records & reports…';

  @override
  String get recordsLoading => 'Loading records…';

  @override
  String get recordsEmpty => 'No entries yet';

  @override
  String recordsNoResults(String query) {
    return 'No results for “$query”';
  }

  @override
  String get recordsEmptyHint =>
      'Filters and search are ready — add your first entry.';

  @override
  String get recordsFilterAll => 'All';

  @override
  String get recordsCreateDoctors => 'Add doctor';

  @override
  String get recordsCreateDiagnoses => 'Add diagnosis';

  @override
  String get recordsCreateSymptoms => 'Add symptom';

  @override
  String get recordsCreateAppointments => 'Add appointment';

  @override
  String get recordsCreateReports => 'Add report';

  @override
  String get recordsCreateMedications => 'Add medication';

  @override
  String get recordsCreatePharmacies => 'Add pharmacy';

  @override
  String get recordsCreateVaccinations => 'Add vaccination';

  @override
  String get recordsCreateNotes => 'Add note';

  @override
  String get recordsDatePattern => 'MMM d, yyyy';

  @override
  String get recordsDateTimePattern => 'MMM d, yyyy · h:mm a';

  @override
  String get recordsTimePattern => 'h:mm a';

  @override
  String get recordsDiagnosisNone => 'None';

  @override
  String recordsDateClearTooltip(String label) {
    return 'Clear $label';
  }

  @override
  String get recordsDoctorCreateTitle => 'Add doctor';

  @override
  String get recordsDoctorEditTitle => 'Edit doctor';

  @override
  String get recordsFieldName => 'Name';

  @override
  String get recordsFieldSpecialty => 'Specialty';

  @override
  String get recordsFieldPractice => 'Practice / clinic';

  @override
  String get recordsFieldPhone => 'Phone';

  @override
  String get recordsFieldAddress => 'Address';

  @override
  String get recordsDiagnosisCreateTitle => 'Add diagnosis';

  @override
  String get recordsDiagnosisEditTitle => 'Edit diagnosis';

  @override
  String get recordsFieldTitle => 'Title';

  @override
  String get recordsDiagnosisActive => 'Active';

  @override
  String get recordsDiagnosisResolved => 'Resolved';

  @override
  String get recordsDiagnosisSince => 'Since';

  @override
  String get recordsDiagnosisUntil => 'Until';

  @override
  String get recordsSymptomCreateTitle => 'Add symptom';

  @override
  String get recordsSymptomEditTitle => 'Edit symptom';

  @override
  String get recordsFieldSymptomLabel => 'Name';

  @override
  String get recordsFieldBodyRegion => 'Body region';

  @override
  String get recordsNoteCreateTitle => 'Add note';

  @override
  String get recordsNoteEditTitle => 'Edit note';

  @override
  String get recordsFieldText => 'Text';

  @override
  String get recordsReportRenameTitle => 'Rename report';

  @override
  String recordsDeleteConfirmTitle(String what) {
    return 'Delete $what?';
  }

  @override
  String get recordsDeleteConfirmBody => 'This can\'t be undone.';

  @override
  String get recordsScanDocument => 'Scan document';

  @override
  String get recordsScanDocumentHint =>
      'Camera · text is recognized and searchable';

  @override
  String get recordsPickFiles => 'Choose files';

  @override
  String get recordsPickFilesHint => 'PDFs or images · several at once';

  @override
  String get recordsScannerUnavailableTitle => 'Scanner won\'t start';

  @override
  String recordsScannerUnavailableBody(String details) {
    return 'Google\'s document scanner won\'t start on this device. Taking a photo with the camera always works — the text is recognized just the same.\n\nDetails: $details';
  }

  @override
  String get recordsPickFile => 'Choose file';

  @override
  String get recordsScanSaving => 'Saving scan, recognizing text…';

  @override
  String recordsScanFileName(String date) {
    return 'Scan $date.pdf';
  }

  @override
  String get recordsScanFileDatePattern => 'yyyy-MM-dd HH-mm';

  @override
  String get recordsScanSavedNoText => 'Scan saved (no text recognized)';

  @override
  String get recordsScanSavedWithText => 'Scan saved — text searchable';

  @override
  String recordsReportSaved(String title) {
    return 'Report “$title” saved';
  }

  @override
  String recordsReportsSaved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reports saved',
      one: '1 report saved',
    );
    return '$_temp0';
  }

  @override
  String recordsImportPartial(int saved, int failed, String files) {
    return '$saved saved, $failed failed: $files';
  }

  @override
  String get recordsDeleteToArchive => 'Delete (move to archive)';

  @override
  String get recordsNotFound => 'Entry not found';

  @override
  String get recordsPractice => 'Practice';

  @override
  String get recordsPhoneTapToCall => 'Phone · tap to call';

  @override
  String get recordsAddressOpenMaps => 'Address · open in Maps';

  @override
  String get recordsDoctorNoSymptoms => 'No symptoms with this doctor yet.';

  @override
  String get recordsAssign => 'Assign';

  @override
  String get recordsStatusActive => 'active';

  @override
  String get recordsStatusHealed => 'healed';

  @override
  String get recordsLinkedDirect => 'assigned';

  @override
  String get recordsLinkedViaAppointments => 'from appointments';

  @override
  String get recordsDoctorNoAppointments => 'No appointments with this doctor.';

  @override
  String recordsAssignSymptomsTitle(String name) {
    return 'Symptoms with $name';
  }

  @override
  String get recordsNoSymptomsYet => 'No symptoms added yet.';

  @override
  String recordsSince(String date) {
    return 'since $date';
  }

  @override
  String recordsUntil(String date) {
    return 'until $date';
  }

  @override
  String get recordsDiagnosisNoAppointments =>
      'Not linked to an appointment yet.';

  @override
  String get recordsNoSymptomsLinked => 'No linked symptoms.';

  @override
  String get recordsNoMedicationsLinked => 'No linked medications.';

  @override
  String get recordsDiagnosisNoReports => 'No reports for these appointments.';

  @override
  String recordsHealedOn(String date) {
    return 'healed on $date';
  }

  @override
  String get recordsMarkHealed => 'Mark as healed';

  @override
  String get recordsReopen => 'Active again';

  @override
  String get recordsDiscussedAtAppointments => 'Discussed at appointments';

  @override
  String get recordsHistory => 'History';

  @override
  String get recordsCheckIns => 'Check-ins';

  @override
  String get recordsNoCheckIns => 'No check-ins yet.';

  @override
  String get recordsDeleteValue => 'Delete value';

  @override
  String recordsFrom(String date) {
    return 'from $date';
  }

  @override
  String get recordsOngoing => 'ongoing';

  @override
  String get recordsDosePerIntake => 'Dose per intake';

  @override
  String get recordsInstructions => 'Instructions';

  @override
  String get recordsPeriod => 'Period';

  @override
  String get recordsIntakeTimes => 'Dose times';

  @override
  String get recordsNoIntakeTimes => 'No fixed dose times.';

  @override
  String get recordsIntake => 'Dose';

  @override
  String get recordsRemindIntake => 'Remind me to take it';

  @override
  String get recordsPrescribedBy => 'Prescribed by';

  @override
  String get recordsIntakeLog => 'Dose log';

  @override
  String get recordsTakenNow => 'Taken now';

  @override
  String get recordsNoIntakesYet => 'No doses logged yet.';

  @override
  String recordsAdherence(int percent) {
    return 'Last 14 days: $percent% of planned doses taken';
  }

  @override
  String get recordsTaken => 'Taken';

  @override
  String get recordsSkipped => 'Skipped';

  @override
  String recordsPlannedAt(String time) {
    return 'scheduled $time';
  }

  @override
  String get recordsDeleteEntry => 'Delete entry';

  @override
  String get recordsPharmacyNoMedications =>
      'No medications from this pharmacy.';

  @override
  String recordsDoseNumber(int number) {
    return 'Dose $number';
  }

  @override
  String get recordsVaccineProduct => 'Vaccine';

  @override
  String get recordsBatch => 'Lot';

  @override
  String get recordsBoosterOverdue => 'Booster overdue';

  @override
  String get recordsNextDoseDue => 'Next dose due';

  @override
  String get recordsVaccinatedBy => 'Vaccinated by';

  @override
  String recordsLastModified(String date) {
    return 'Last modified $date';
  }

  @override
  String get recordsRelatedAppointment => 'Related appointment';

  @override
  String get recordsRelatedDiagnosis => 'Related diagnosis';

  @override
  String get recordsTakePhoto => 'Take photo';

  @override
  String get recordsTakePhotoHint =>
      'Camera app · text is recognized and searchable';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLoading => 'Loading settings…';

  @override
  String get settingsLocalOnlyTitle => 'Everything stays on this device';

  @override
  String get settingsLocalOnlySubtitle =>
      'No accounts, no patient data on servers.';

  @override
  String get settingsArchiveTitle => 'Archive';

  @override
  String get settingsArchiveSubtitle =>
      'Restore deleted entries or delete them permanently';

  @override
  String get settingsAppSection => 'App';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsLanguageValue => 'English';

  @override
  String get settingsVersion => 'Version';

  @override
  String get settingsDateTimePattern => 'MMM d, h:mm a';

  @override
  String get settingsBackupTaskBackup => 'Backup';

  @override
  String get settingsBackupTaskRestore => 'Restore';

  @override
  String get settingsBackupTaskExport => 'Export';

  @override
  String get settingsBackupTaskImport => 'Import';

  @override
  String get settingsBackupTaskReindex => 'Indexing';

  @override
  String settingsBackupFailed(String task) {
    return '$task failed.';
  }

  @override
  String settingsBackupRunning(String task) {
    return '$task in progress…';
  }

  @override
  String get settingsBackupShareSubject => 'Mai Doctor Hub — Backup';

  @override
  String get settingsBackupCreated =>
      'Backup created — keep your password safe!';

  @override
  String get settingsBackupPickTitle => 'Choose backup';

  @override
  String get settingsBackupNotABackup =>
      'Not a Mai Doctor Hub backup (.maibackup).';

  @override
  String get settingsBackupRestoreConfirmTitle => 'Restore backup?';

  @override
  String get settingsBackupRestoreConfirmText =>
      'All current data and reports on this device will be replaced by the backup. You\'ll need to set up calendar export again afterwards.';

  @override
  String get settingsBackupReplace => 'Replace';

  @override
  String get settingsBackupDatePattern => 'MMM d, yyyy';

  @override
  String settingsBackupRestored(String date) {
    return 'Backup from $date restored.';
  }

  @override
  String settingsBackupRestoredMissing(String date, int missing) {
    String _temp0 = intl.Intl.pluralLogic(
      missing,
      locale: localeName,
      other: '$missing files were',
      one: '1 file was',
    );
    return 'Backup from $date restored ($_temp0 missing).';
  }

  @override
  String get settingsDocumentsExportConfirmTitle => 'Export documents?';

  @override
  String get settingsDocumentsExportConfirmText =>
      'All reports and scans will be shared as a ZIP with readable file names and an overview (CSV). The archive is not encrypted — only send it to destinations you trust.';

  @override
  String get settingsDocumentsExportAction => 'Export';

  @override
  String get settingsDocumentsExportNone => 'No documents to export.';

  @override
  String settingsDocumentsShareSubject(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count documents',
      one: '1 document',
    );
    return 'Mai Doctor Hub — $_temp0';
  }

  @override
  String get settingsReindexAllDone => 'All reports are already searchable.';

  @override
  String settingsReindexCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reports are now searchable.',
      one: '1 report is now searchable.',
    );
    return '$_temp0';
  }

  @override
  String get settingsBackupSection => 'Backup';

  @override
  String get settingsBackupDescription =>
      'Encrypted file with all your data and reports — e.g. for switching devices. Can\'t be read without the password.';

  @override
  String get settingsBackupCreate => 'Create backup';

  @override
  String get settingsBackupRestore => 'Restore backup';

  @override
  String get settingsDocumentsExport => 'Export documents';

  @override
  String get settingsDocumentsExportSubtitle =>
      'All reports & scans as a ZIP with an overview';

  @override
  String get settingsDocumentsImport => 'Import documents';

  @override
  String get settingsDocumentsImportSubtitle =>
      'Several PDFs or images at once';

  @override
  String get settingsBackupWebUnavailable => 'Not available on the web';

  @override
  String get settingsReindexTitle => 'Make reports searchable';

  @override
  String get settingsReindexSubtitle => 'Recognize text in older PDF reports';

  @override
  String settingsPassphraseMinLength(int count) {
    return 'At least $count characters.';
  }

  @override
  String get settingsPassphraseMismatch => 'Passwords don\'t match.';

  @override
  String get settingsPassphraseSetTitle => 'Set password';

  @override
  String get settingsPassphraseEnterTitle => 'Enter password';

  @override
  String get settingsPassphraseLabel => 'Password';

  @override
  String get settingsPassphraseShow => 'Show';

  @override
  String get settingsPassphraseHide => 'Hide';

  @override
  String get settingsPassphraseRepeat => 'Repeat';

  @override
  String get settingsPassphraseWarning =>
      'Without this password the backup can\'t be opened — there is no way to recover it.';

  @override
  String get settingsCalendarNoPermission =>
      'Calendar access is required for export.';

  @override
  String get settingsCalendarNoWritable =>
      'No writable calendar on this device.';

  @override
  String get settingsCalendarStopTitle => 'Stop calendar export';

  @override
  String get settingsCalendarStopText =>
      'Remove the appointments already added to your calendar?';

  @override
  String get settingsCalendarKeep => 'Keep';

  @override
  String get settingsCalendarRemove => 'Remove';

  @override
  String settingsCalendarRemovedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count appointments removed from calendar.',
      one: '1 appointment removed from calendar.',
    );
    return '$_temp0';
  }

  @override
  String settingsCalendarRemovedResult(String result) {
    return 'Calendar cleared: $result';
  }

  @override
  String settingsCalendarSyncedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count appointments synced with calendar.',
      one: '1 appointment synced with calendar.',
    );
    return '$_temp0';
  }

  @override
  String settingsCalendarSyncedResult(String result) {
    return 'Calendar synced: $result';
  }

  @override
  String get settingsCalendarSection => 'Calendar';

  @override
  String get settingsCalendarExportTitle => 'Add appointments to calendar';

  @override
  String get settingsCalendarExportSubtitle =>
      'One way only, e.g. to your Google Calendar. Only “Doctor appointment”, the doctor and the location are shared — no diagnoses or notes.';

  @override
  String get settingsCalendarAndroidOnly =>
      'Only available in the Android app.';

  @override
  String get settingsCalendarTarget => 'Calendar';

  @override
  String get settingsCalendarAllowAccess => 'Allow calendar access';

  @override
  String get settingsCalendarIncludeTitle => 'Include appointment title';

  @override
  String get settingsCalendarIncludeTitleSubtitle =>
      'Off: “Doctor appointment · Dr. …”. On: e.g. “Knee MRI · Dr. …”.';

  @override
  String settingsCalendarLinkedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count appointments in calendar',
      one: '1 appointment in calendar',
    );
    return '$_temp0';
  }

  @override
  String settingsCalendarLinkedWithErrors(int count, int errors) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count appointments in calendar',
      one: '1 appointment in calendar',
    );
    String _temp1 = intl.Intl.pluralLogic(
      errors,
      locale: localeName,
      other: '$errors errors',
      one: '1 error',
    );
    return '$_temp0 · $_temp1';
  }

  @override
  String settingsCalendarLastSynced(String date) {
    return 'Last synced $date';
  }

  @override
  String get settingsCalendarSyncNow => 'Sync';

  @override
  String get settingsRemindersSection => 'Reminders';

  @override
  String get settingsRemindersNew => 'New';

  @override
  String get settingsRemindersNotificationsOff => 'Notifications are off';

  @override
  String get settingsRemindersNotificationsOffText =>
      'Reminders are scheduled but won\'t be shown.';

  @override
  String get settingsRemindersAllow => 'Allow';

  @override
  String get settingsRemindersEmpty => 'No reminders — tap “New” to add one.';

  @override
  String get settingsRemindersOpenCheckIn => 'Open check-in now';

  @override
  String get settingsRemindersAllOpenSymptoms => 'all open symptoms';

  @override
  String get settingsRemindersPermissionTitle => 'Allow notifications?';

  @override
  String get settingsRemindersPermissionText =>
      'To show reminders, the app needs permission to send notifications. They\'re scheduled locally — no server involved.';

  @override
  String get settingsRemindersLater => 'Later';

  @override
  String get settingsReminderNewTitle => 'New reminder';

  @override
  String get settingsReminderTitle => 'Reminder';

  @override
  String get settingsReminderFieldTitle => 'Title';

  @override
  String get settingsReminderFieldBody => 'Text (optional)';

  @override
  String get settingsReminderTime => 'Time';

  @override
  String get settingsReminderWeekdays => 'Days';

  @override
  String get settingsReminderSymptomsHint =>
      'Only for these symptoms (none = all open)';

  @override
  String get settingsAppointmentRemindersTitle => 'Appointment reminders';

  @override
  String get settingsAppointmentRemindersCalendarTip =>
      'Tip: appointments also go to your calendar — you may get reminded twice. Turn one of them off.';

  @override
  String get settingsAppointmentRemindersSubtitle =>
      'Notification before doctor appointments. Prefer Google Calendar? Turn this off.';

  @override
  String get settingsAppointmentRemindersLeadLabel => 'Remind me before';

  @override
  String get settingsSecuritySection => 'Security';

  @override
  String get settingsLockTitle => 'App lock';

  @override
  String get settingsLockSubtitle =>
      'Unlock with biometrics or device PIN when opening and after 1 minute in the background. Content won\'t appear in screenshots or the app switcher.';

  @override
  String get settingsLockNoDeviceLock =>
      'No screen lock set up — please enable a PIN or biometrics in your device settings first.';

  @override
  String get settingsLockLockedTitle => 'Mai Doctor Hub is locked';

  @override
  String get settingsLockLockedText =>
      'Unlock with fingerprint, face or device PIN.';

  @override
  String get settingsLockUnlock => 'Unlock';

  @override
  String get settingsLockReasonSetup => 'Set up app lock';

  @override
  String get settingsLockReasonUnlock => 'Unlock Mai Doctor Hub';

  @override
  String settingsArchiveSnack(String label) {
    return '$label archived';
  }

  @override
  String get settingsArchivePurgeAction => 'Delete permanently';

  @override
  String get settingsArchivePurgeTitle => 'Delete permanently?';

  @override
  String settingsArchivePurgeText(String title) {
    return '“$title” will be permanently deleted (including files).';
  }

  @override
  String get settingsArchivePurgeAllTitle => 'Empty archive?';

  @override
  String get settingsArchivePurgeAllText =>
      'All archived entries will be permanently deleted.';

  @override
  String settingsArchivePurgedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count entries permanently deleted',
      one: '1 entry permanently deleted',
    );
    return '$_temp0';
  }

  @override
  String get settingsArchiveEmptyAction => 'Empty';

  @override
  String get settingsArchiveEmpty =>
      'The archive is empty. Deleted entries end up here and can be restored.';

  @override
  String get settingsArchiveLoading => 'Loading…';

  @override
  String settingsArchiveItemSubtitle(String type, String date) {
    return '$type · archived $date';
  }

  @override
  String get settingsOnboardingSkip => 'Skip';

  @override
  String get settingsOnboardingPrivacyTitle => 'Your records stay with you';

  @override
  String get settingsOnboardingPrivacyText =>
      'Mai Doctor Hub stores everything on this device only. No account, no server. You decide what leaves the device — backup, calendar, assistant.';

  @override
  String get settingsOnboardingAllInOneTitle => 'Everything in one place';

  @override
  String get settingsOnboardingAllInOneText =>
      'Appointments, doctors, diagnoses, symptoms, medications and reports — searchable and linked together. Everything\'s ready for your next doctor\'s visit.';

  @override
  String get settingsOnboardingRemindersTitle => 'Reminders';

  @override
  String get settingsOnboardingRemindersText =>
      'To remind you about check-ins, appointments and medications, the app needs permission to send notifications. They\'re scheduled locally on your device — no push server. You can change this anytime.';

  @override
  String get settingsOnboardingAllowNotifications => 'Allow notifications';

  @override
  String get settingsOnboardingAllowed => 'Allowed';

  @override
  String get settingsOnboardingDenied =>
      'Not allowed — you can turn this on anytime in the app settings.';

  @override
  String get settingsOnboardingStart => 'Get started';

  @override
  String get settingsShellTabHome => 'Home';

  @override
  String get settingsShellTabCalendar => 'Calendar';

  @override
  String get settingsShellTabRecords => 'My records';

  @override
  String get settingsShellTabSettings => 'Settings';

  @override
  String get settingsUnreadableTitle => 'Data can\'t be read';

  @override
  String get settingsUnreadableText =>
      'The stored data couldn\'t be decrypted on this device, so the app is starting empty.\n\nYou can restore everything from a .maibackup backup: Settings → Backup → “Restore backup”.';

  @override
  String get settingsChartEmpty =>
      'No scale values yet — record them with a check-in.';

  @override
  String get settingsChartDayPattern => 'M/d';

  @override
  String get settingsChartDayTimePattern => 'M/d h:mm a';

  @override
  String settingsChartSemantics(String from, String to, String value) {
    return 'Trend from $from to $to, latest $value out of 10';
  }

  @override
  String get settingsSymptomReportNoCheckIns => 'No check-ins in this period.';

  @override
  String settingsSymptomReportCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count check-ins',
      one: '1 check-in',
    );
    return '$_temp0';
  }

  @override
  String settingsSymptomReportCountStats(int count, String avg, String latest) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count check-ins',
      one: '1 check-in',
    );
    return '$_temp0 · avg $avg · latest $latest/10';
  }

  @override
  String settingsObservationScale(String value) {
    return 'Intensity $value/10';
  }

  @override
  String settingsObservationColor(String value) {
    return 'Color $value';
  }

  @override
  String get svcAssistantTitle => 'Assistant';

  @override
  String get svcAssistantExample1 => 'When is my next appointment?';

  @override
  String get svcAssistantExample2 => 'Which medications am I taking right now?';

  @override
  String get svcAssistantExample3 => 'How have my symptoms changed?';

  @override
  String get svcAssistantExample4 => 'What did my last report say?';

  @override
  String get svcAssistantDeleteModelQuestion => 'Delete model?';

  @override
  String svcAssistantDeleteModelBody(String size) {
    return 'Frees up $size of storage. You\'ll need to download it again to use the assistant.';
  }

  @override
  String get svcAssistantDeleteModel => 'Delete model';

  @override
  String get svcAssistantDeleteSearchModel => 'Delete search model';

  @override
  String get svcAssistantUnsupportedTitle => 'Not available on this device';

  @override
  String get svcAssistantAskTitle => 'Ask your records';

  @override
  String get svcAssistantIntro =>
      'Answers are created on this device from your entries and reports — nothing is uploaded and the conversation isn\'t saved.';

  @override
  String get svcAssistantDisclaimer =>
      'Not medical advice — answers may contain mistakes.';

  @override
  String get svcAssistantInputHint => 'Ask about your records…';

  @override
  String get svcAssistantSend => 'Ask';

  @override
  String svcAssistantNoAnswer(String error) {
    return 'No answer: $error';
  }

  @override
  String get svcAssistantReading => 'Reading your records…';

  @override
  String get svcAssistantSetupTitle => 'On-device assistant';

  @override
  String svcAssistantSetupBody(String model, String size) {
    return 'Ask about appointments, medications, symptoms and reports. The AI model $model runs entirely on this device — your records are never uploaded. Only the model itself is downloaded once ($size, ideally over Wi-Fi).';
  }

  @override
  String get svcAssistantLowMemory =>
      'Note: This device has little memory. The assistant may be slow or get closed by Android.';

  @override
  String svcAssistantDownloading(int percent) {
    return 'Downloading… $percent% — keeps going even if you leave the app.';
  }

  @override
  String svcAssistantDownloadModel(String size) {
    return 'Download model ($size)';
  }

  @override
  String get svcSemanticTitle => 'Semantic search (optional)';

  @override
  String get svcSemanticActive =>
      'Active: answers use the best matches by keyword and by meaning.';

  @override
  String svcSemanticIndexing(int done, int total) {
    return 'Indexing your records… $done/$total';
  }

  @override
  String svcSemanticDownloading(int percent) {
    return 'Downloading search model… $percent%';
  }

  @override
  String svcSemanticIntro(String model, String size) {
    return 'Also finds entries that don\'t contain the words of your question (e.g. “thyroid” → TSH level). Downloads $model ($size); search then works offline.\n\nGoogle only provides the model once you accept the Gemma license: create a free Hugging Face account, accept the license on the model page, create a read token and paste it here. The token is only used for the download and is not stored.';
  }

  @override
  String get svcSemanticTokenLabel => 'Hugging Face token (hf_…)';

  @override
  String get svcSemanticEnable => 'Enable semantic search';

  @override
  String svcDownloadFailed(String error) {
    return 'Download failed: $error';
  }

  @override
  String svcSemanticDownloadFailed(String error) {
    return 'Download failed — check your token and license. ($error)';
  }

  @override
  String svcIndexNotUpdated(String error) {
    return 'Index not updated: $error';
  }

  @override
  String get svcAssistantModelSize => 'about 2.6 GB';

  @override
  String get svcEmbedderModelSize => 'about 180 MB';

  @override
  String get svcAssistantAndroidOnly => 'The assistant only runs on Android.';

  @override
  String svcAssistantDeviceCheckFailed(String error) {
    return 'Couldn\'t check this device: $error';
  }

  @override
  String get svcAssistantNeedsAndroid11 =>
      'The on-device assistant requires Android 11 or later.';

  @override
  String get svcAssistantNeedsArm64 =>
      'The on-device assistant requires a 64-bit ARM processor.';

  @override
  String get svcContextSystemPrompt =>
      'You are the assistant of the app “Mai Doctor Hub”. You answer questions about\nthe user\'s personal health record in English, briefly and clearly.\nRules:\n- Use only the information in the RECORD section. If something is not in it,\n  say honestly that it is not noted in the record.\n- Copy dates, times, dosages and values exactly.\n- Do not make diagnoses and do not give therapy or dosage recommendations;\n  for medical questions, refer the user to a doctor or pharmacist.\n- If there are warning signs of an emergency: advise calling the local\n  emergency number (112 in Europe, 911 in the US) immediately.';

  @override
  String get svcContextRecordHeading => 'RECORD';

  @override
  String get svcContextQuestionHeading => 'QUESTION';

  @override
  String svcContextToday(String date) {
    return 'Today: $date';
  }

  @override
  String get svcContextActiveDiagnoses => 'Active diagnoses';

  @override
  String svcSince(String date) {
    return 'since $date';
  }

  @override
  String get svcCurrentMedications => 'Current medications';

  @override
  String get svcContextOpenSymptoms => 'Open symptoms (last 30 days)';

  @override
  String svcContextVaccineOn(String vaccine, String date) {
    return '$vaccine on $date';
  }

  @override
  String svcContextDoseNumber(int number) {
    return 'dose $number';
  }

  @override
  String svcContextNextDue(String date) {
    return 'next due $date';
  }

  @override
  String get svcContextMatchingEntries => 'Entries matching the question:';

  @override
  String get svcContextUpcomingAppointments => 'Upcoming appointments';

  @override
  String get svcContextPastAppointments => 'Recent appointments';

  @override
  String get svcContextCancelled => 'cancelled';

  @override
  String svcContextDiagnosesList(String list) {
    return 'Diagnoses: $list';
  }

  @override
  String svcContextIntake(String times) {
    return 'taken at $times';
  }

  @override
  String svcContextFor(String diagnosis) {
    return 'for $diagnosis';
  }

  @override
  String svcContextUntil(String date) {
    return 'until $date';
  }

  @override
  String svcCheckInCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count check-ins',
      one: '1 check-in',
    );
    return '$_temp0';
  }

  @override
  String svcContextLatest(String date, String value) {
    return 'latest $date: $value';
  }

  @override
  String get svcContextDayPattern => 'MMM d, yyyy';

  @override
  String get svcContextDayTimePattern => 'MMM d, yyyy h:mm a';

  @override
  String get svcSummaryPdfTitle => 'Summary for the doctor\'s visit';

  @override
  String svcSummaryPdfFileName(String date) {
    return 'Doctor-visit_$date.pdf';
  }

  @override
  String get svcSummaryPdfDatePattern => 'MM/dd/yyyy';

  @override
  String get svcSummaryPdfDateTimePattern => 'MM/dd h:mm a';

  @override
  String svcSummaryPdfFooter(String date) {
    return 'Created on $date with Mai Doctor Hub · Patient-reported, not medical documentation';
  }

  @override
  String svcSummaryPdfAppointment(String date, String doctor) {
    return 'Appointment $date with $doctor';
  }

  @override
  String svcSummaryPdfPeriod(String from, String to) {
    return 'Period $from – $to';
  }

  @override
  String get svcSummaryPdfQuestions => 'My questions & concerns';

  @override
  String get svcSummaryPdfDiagnoses => 'Known diagnoses';

  @override
  String get svcSummaryPdfActive => 'active';

  @override
  String get svcSummaryPdfResolved => 'resolved';

  @override
  String get svcSummaryPdfNoCheckIns => 'No check-ins in this period.';

  @override
  String svcSummaryPdfStats(
    String average,
    String min,
    String max,
    String last,
  ) {
    return 'avg $average/10, min $min, max $max, latest $last';
  }

  @override
  String get svcSummaryPdfDate => 'Date';

  @override
  String get svcSummaryPdfValue => 'Value';

  @override
  String get svcSummaryPdfDose => 'Dose';

  @override
  String get svcSummaryPdfIntake => 'Schedule';

  @override
  String get svcSummaryPdfSinceUntil => 'From / to';

  @override
  String get svcSummaryPdfProductBatch => 'Vaccine / batch';

  @override
  String get svcSummaryPdfNextDue => 'Next due';

  @override
  String svcSummaryPdfDue(String list) {
    return 'Due: $list';
  }

  @override
  String get svcSummaryTitle => 'For your doctor visit';

  @override
  String get svcSummarySaveDialog => 'Save summary';

  @override
  String get svcSummarySaved => 'PDF saved';

  @override
  String svcSummaryExportFailed(String error) {
    return 'Export failed: $error';
  }

  @override
  String get svcSummaryShare => 'Share PDF';

  @override
  String get svcSummaryIntro =>
      'Questions, symptom history, medications and vaccinations at a glance — as a PDF for your doctor\'s office.';

  @override
  String get svcSummaryAppointmentDatePattern => 'MMM d, yyyy';

  @override
  String get svcSummaryReference => 'Related appointment (sets the period)';

  @override
  String get svcSummaryNoAppointment => 'None — last 30 days';

  @override
  String get svcSummaryName => 'Name (optional, shown in the PDF)';

  @override
  String get svcSummaryQuestions => 'Questions & concerns';

  @override
  String get svcSummaryQuestionsHint =>
      'One question per line — notes for the appointment are added automatically';

  @override
  String get svcSummaryAllSymptoms => 'All open symptoms';

  @override
  String get svcSummaryAllMedications => 'All current medications';

  @override
  String get svcSummaryMore => 'More';

  @override
  String get svcReminderLead15Min => '15 min';

  @override
  String get svcReminderLead1Hour => '1 hr';

  @override
  String get svcReminderLead2Hours => '2 hrs';

  @override
  String get svcReminderLead1Day => '1 day';

  @override
  String get svcReminderLead2Days => '2 days';

  @override
  String get svcReminderLead1Week => '1 week';

  @override
  String svcReminderInMinutes(int minutes, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      minutes,
      locale: localeName,
      other: '$minutes minutes',
      one: '1 minute',
    );
    return 'In $_temp0 ($time)';
  }

  @override
  String svcReminderInHours(int hours, String time) {
    String _temp0 = intl.Intl.pluralLogic(
      hours,
      locale: localeName,
      other: 'In $hours hours ($time)',
      one: 'In 1 hour ($time)',
    );
    return '$_temp0';
  }

  @override
  String svcReminderTomorrow(String time) {
    return 'Tomorrow $time';
  }

  @override
  String get svcReminderTimePattern => 'h:mm a';

  @override
  String get svcReminderDayPattern => 'EEE, M/d';

  @override
  String get svcReminderAppointmentFallback => 'Doctor\'s appointment';

  @override
  String svcReminderMedicationTitle(String name) {
    return 'Take: $name';
  }

  @override
  String get svcReminderTakeNow => 'Take now';

  @override
  String get svcReminderCheckInDefault => 'Take a moment to log your symptoms.';

  @override
  String svcReminderCheckInSymptoms(String symptoms) {
    return 'Check-in: $symptoms';
  }

  @override
  String get svcChannelCheckIn => 'Symptom check-in';

  @override
  String get svcChannelCheckInDescription => 'Reminders for check-ins';

  @override
  String get svcChannelAppointmentDescription =>
      'Reminders before doctor appointments';

  @override
  String get svcChannelMedicationDescription => 'Reminders to take medications';

  @override
  String svcCalendarEventTitle(String doctor) {
    return 'Doctor\'s appointment · $doctor';
  }

  @override
  String get svcCalendarManagedBy => 'Managed by Mai Doctor Hub';

  @override
  String get svcCalendarNoPermission => 'Calendar access not allowed';

  @override
  String get svcCalendarNoEventId => 'No event ID received';

  @override
  String get svcImportPickFailed => 'Couldn\'t open the file picker';

  @override
  String svcImportUnsupportedType(String ext) {
    return 'File type “$ext” isn\'t supported (PDF or image).';
  }

  @override
  String get svcImportFileNotSaved => 'Couldn\'t save the file on this device.';

  @override
  String get svcImportReportNotSaved => 'Couldn\'t save the report.';

  @override
  String svcExportFileName(String date) {
    return 'Mai-Doctor-Hub-Documents-$date.zip';
  }

  @override
  String get svcExportOverviewFile => 'Overview.csv';

  @override
  String get svcExportCsvHeader =>
      'Date;Title;Doctor;Appointment;Source;Pages;File';

  @override
  String get svcExportSourceImage => 'Image';

  @override
  String get svcBackupTooNew =>
      'This backup is from a newer app version — please update the app.';

  @override
  String get svcAssistantEmptyAnswer =>
      'No answer received. Please ask a shorter or more specific question.';

  @override
  String get svcQueryExpansionSystem =>
      'You help search a personal health record. Reply only with search terms separated by commas, nothing else.';

  @override
  String svcQueryExpansionPrompt(String question) {
    return 'List up to 8 search terms that would find answers to this question in doctor reports, notes and entries: synonyms, medical terms, lay terms, common abbreviations, lab values or medication names. Question: $question';
  }
}
