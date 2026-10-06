import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
  ];

  /// No description provided for @catalogReminderMorningTitle.
  ///
  /// In de, this message translates to:
  /// **'Morgen-Check-in'**
  String get catalogReminderMorningTitle;

  /// No description provided for @catalogReminderMorningBody.
  ///
  /// In de, this message translates to:
  /// **'Wie geht es dir heute? Symptome kurz protokollieren.'**
  String get catalogReminderMorningBody;

  /// No description provided for @catalogReminderEveningTitle.
  ///
  /// In de, this message translates to:
  /// **'Abend-Check-in'**
  String get catalogReminderEveningTitle;

  /// No description provided for @catalogReminderEveningBody.
  ///
  /// In de, this message translates to:
  /// **'Abendliche Symptom-Notizen — dauert nur einen Moment.'**
  String get catalogReminderEveningBody;

  /// No description provided for @appTitle.
  ///
  /// In de, this message translates to:
  /// **'Mai Doctor Hub'**
  String get appTitle;

  /// No description provided for @commonCancel.
  ///
  /// In de, this message translates to:
  /// **'Abbrechen'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In de, this message translates to:
  /// **'Speichern'**
  String get commonSave;

  /// No description provided for @commonDelete.
  ///
  /// In de, this message translates to:
  /// **'Löschen'**
  String get commonDelete;

  /// No description provided for @commonEdit.
  ///
  /// In de, this message translates to:
  /// **'Bearbeiten'**
  String get commonEdit;

  /// No description provided for @commonClose.
  ///
  /// In de, this message translates to:
  /// **'Schließen'**
  String get commonClose;

  /// No description provided for @commonAdd.
  ///
  /// In de, this message translates to:
  /// **'Hinzufügen'**
  String get commonAdd;

  /// No description provided for @commonBack.
  ///
  /// In de, this message translates to:
  /// **'Zurück'**
  String get commonBack;

  /// No description provided for @commonNext.
  ///
  /// In de, this message translates to:
  /// **'Weiter'**
  String get commonNext;

  /// No description provided for @commonDone.
  ///
  /// In de, this message translates to:
  /// **'Fertig'**
  String get commonDone;

  /// No description provided for @commonYes.
  ///
  /// In de, this message translates to:
  /// **'Ja'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In de, this message translates to:
  /// **'Nein'**
  String get commonNo;

  /// No description provided for @commonOk.
  ///
  /// In de, this message translates to:
  /// **'OK'**
  String get commonOk;

  /// No description provided for @commonUnderstood.
  ///
  /// In de, this message translates to:
  /// **'Verstanden'**
  String get commonUnderstood;

  /// No description provided for @commonRetry.
  ///
  /// In de, this message translates to:
  /// **'Erneut versuchen'**
  String get commonRetry;

  /// No description provided for @commonSearch.
  ///
  /// In de, this message translates to:
  /// **'Suchen'**
  String get commonSearch;

  /// No description provided for @commonNotes.
  ///
  /// In de, this message translates to:
  /// **'Notizen'**
  String get commonNotes;

  /// No description provided for @commonNote.
  ///
  /// In de, this message translates to:
  /// **'Notiz'**
  String get commonNote;

  /// No description provided for @commonUndo.
  ///
  /// In de, this message translates to:
  /// **'Rückgängig'**
  String get commonUndo;

  /// No description provided for @commonRestore.
  ///
  /// In de, this message translates to:
  /// **'Wiederherstellen'**
  String get commonRestore;

  /// No description provided for @commonOptional.
  ///
  /// In de, this message translates to:
  /// **'optional'**
  String get commonOptional;

  /// No description provided for @commonNone.
  ///
  /// In de, this message translates to:
  /// **'Keine Angabe'**
  String get commonNone;

  /// No description provided for @commonToday.
  ///
  /// In de, this message translates to:
  /// **'Heute'**
  String get commonToday;

  /// No description provided for @commonTomorrow.
  ///
  /// In de, this message translates to:
  /// **'Morgen'**
  String get commonTomorrow;

  /// No description provided for @commonYesterday.
  ///
  /// In de, this message translates to:
  /// **'Gestern'**
  String get commonYesterday;

  /// No description provided for @entityDoctor.
  ///
  /// In de, this message translates to:
  /// **'Arzt'**
  String get entityDoctor;

  /// No description provided for @entityDoctors.
  ///
  /// In de, this message translates to:
  /// **'Ärzte'**
  String get entityDoctors;

  /// No description provided for @entityDiagnosis.
  ///
  /// In de, this message translates to:
  /// **'Diagnose'**
  String get entityDiagnosis;

  /// No description provided for @entityDiagnoses.
  ///
  /// In de, this message translates to:
  /// **'Diagnosen'**
  String get entityDiagnoses;

  /// No description provided for @entitySymptom.
  ///
  /// In de, this message translates to:
  /// **'Symptom'**
  String get entitySymptom;

  /// No description provided for @entitySymptoms.
  ///
  /// In de, this message translates to:
  /// **'Symptome'**
  String get entitySymptoms;

  /// No description provided for @entityAppointment.
  ///
  /// In de, this message translates to:
  /// **'Termin'**
  String get entityAppointment;

  /// No description provided for @entityAppointments.
  ///
  /// In de, this message translates to:
  /// **'Termine'**
  String get entityAppointments;

  /// No description provided for @entityReport.
  ///
  /// In de, this message translates to:
  /// **'Bericht'**
  String get entityReport;

  /// No description provided for @entityReports.
  ///
  /// In de, this message translates to:
  /// **'Berichte'**
  String get entityReports;

  /// No description provided for @entityMedication.
  ///
  /// In de, this message translates to:
  /// **'Medikament'**
  String get entityMedication;

  /// No description provided for @entityMedications.
  ///
  /// In de, this message translates to:
  /// **'Medikamente'**
  String get entityMedications;

  /// No description provided for @entityNote.
  ///
  /// In de, this message translates to:
  /// **'Notiz'**
  String get entityNote;

  /// No description provided for @entityNotes.
  ///
  /// In de, this message translates to:
  /// **'Notizen'**
  String get entityNotes;

  /// No description provided for @entityPharmacy.
  ///
  /// In de, this message translates to:
  /// **'Apotheke'**
  String get entityPharmacy;

  /// No description provided for @entityPharmacies.
  ///
  /// In de, this message translates to:
  /// **'Apotheken'**
  String get entityPharmacies;

  /// No description provided for @entityVaccination.
  ///
  /// In de, this message translates to:
  /// **'Impfung'**
  String get entityVaccination;

  /// No description provided for @entityVaccinations.
  ///
  /// In de, this message translates to:
  /// **'Impfungen'**
  String get entityVaccinations;

  /// No description provided for @entityEntry.
  ///
  /// In de, this message translates to:
  /// **'Eintrag'**
  String get entityEntry;

  /// No description provided for @homeAppointmentSaved.
  ///
  /// In de, this message translates to:
  /// **'Termin gespeichert'**
  String get homeAppointmentSaved;

  /// No description provided for @homeWordmarkSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Deine Termine — lokal auf diesem Gerät'**
  String get homeWordmarkSubtitle;

  /// No description provided for @homeAddAppointment.
  ///
  /// In de, this message translates to:
  /// **'Termin hinzufügen'**
  String get homeAddAppointment;

  /// No description provided for @homeCheckIn.
  ///
  /// In de, this message translates to:
  /// **'Check-in'**
  String get homeCheckIn;

  /// No description provided for @homeNow.
  ///
  /// In de, this message translates to:
  /// **'Jetzt'**
  String get homeNow;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Termine'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptyMessage.
  ///
  /// In de, this message translates to:
  /// **'Lege deinen ersten Termin an — danach erscheinen hier nächste Termine nach unten und vergangene nach oben.'**
  String get homeEmptyMessage;

  /// No description provided for @homeEmptyAction.
  ///
  /// In de, this message translates to:
  /// **'Ersten Termin anlegen'**
  String get homeEmptyAction;

  /// No description provided for @homeCardDateTimePattern.
  ///
  /// In de, this message translates to:
  /// **'EEE d. MMM · HH:mm'**
  String get homeCardDateTimePattern;

  /// No description provided for @homeReportMissing.
  ///
  /// In de, this message translates to:
  /// **'Bericht fehlt'**
  String get homeReportMissing;

  /// No description provided for @homeDoctorNameMissing.
  ///
  /// In de, this message translates to:
  /// **'Arztname fehlt'**
  String get homeDoctorNameMissing;

  /// No description provided for @homePleaseChooseDoctor.
  ///
  /// In de, this message translates to:
  /// **'Bitte einen Arzt wählen'**
  String get homePleaseChooseDoctor;

  /// No description provided for @homeSheetDateTimePattern.
  ///
  /// In de, this message translates to:
  /// **'EEE, d. MMM yyyy · HH:mm'**
  String get homeSheetDateTimePattern;

  /// No description provided for @homeEditAppointment.
  ///
  /// In de, this message translates to:
  /// **'Termin bearbeiten'**
  String get homeEditAppointment;

  /// No description provided for @homeDateAndTime.
  ///
  /// In de, this message translates to:
  /// **'Datum & Uhrzeit'**
  String get homeDateAndTime;

  /// No description provided for @homeDuration.
  ///
  /// In de, this message translates to:
  /// **'Dauer'**
  String get homeDuration;

  /// No description provided for @homeDurationMinutes.
  ///
  /// In de, this message translates to:
  /// **'{minutes} Min.'**
  String homeDurationMinutes(int minutes);

  /// No description provided for @homeTitleOptional.
  ///
  /// In de, this message translates to:
  /// **'Titel (optional)'**
  String get homeTitleOptional;

  /// No description provided for @homeDoctorExisting.
  ///
  /// In de, this message translates to:
  /// **'Vorhanden'**
  String get homeDoctorExisting;

  /// No description provided for @homeDoctorCreateNew.
  ///
  /// In de, this message translates to:
  /// **'Neu anlegen'**
  String get homeDoctorCreateNew;

  /// No description provided for @homeDoctorName.
  ///
  /// In de, this message translates to:
  /// **'Name'**
  String get homeDoctorName;

  /// No description provided for @homeSpecialtyOptional.
  ///
  /// In de, this message translates to:
  /// **'Fachrichtung (optional)'**
  String get homeSpecialtyOptional;

  /// No description provided for @homeNoDoctorsYet.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Ärzte — wechsle zu „Neu anlegen“.'**
  String get homeNoDoctorsYet;

  /// No description provided for @homeChooseDoctor.
  ///
  /// In de, this message translates to:
  /// **'Arzt wählen'**
  String get homeChooseDoctor;

  /// No description provided for @homeDiagnosesOptional.
  ///
  /// In de, this message translates to:
  /// **'Diagnosen (optional)'**
  String get homeDiagnosesOptional;

  /// No description provided for @homeNoDiagnoses.
  ///
  /// In de, this message translates to:
  /// **'Keine Diagnosen — in der Akte anlegbar.'**
  String get homeNoDiagnoses;

  /// No description provided for @homeSymptomsOptional.
  ///
  /// In de, this message translates to:
  /// **'Symptome (optional)'**
  String get homeSymptomsOptional;

  /// No description provided for @homeNoOpenSymptoms.
  ///
  /// In de, this message translates to:
  /// **'Keine offenen Symptome — in der Akte anlegbar.'**
  String get homeNoOpenSymptoms;

  /// No description provided for @homeSaving.
  ///
  /// In de, this message translates to:
  /// **'Speichern…'**
  String get homeSaving;

  /// No description provided for @homeSaveChanges.
  ///
  /// In de, this message translates to:
  /// **'Änderungen speichern'**
  String get homeSaveChanges;

  /// No description provided for @homeSaveAppointment.
  ///
  /// In de, this message translates to:
  /// **'Termin speichern'**
  String get homeSaveAppointment;

  /// No description provided for @homeIcsSaveDialogTitle.
  ///
  /// In de, this message translates to:
  /// **'Kalenderdatei speichern'**
  String get homeIcsSaveDialogTitle;

  /// No description provided for @homeIcsSaved.
  ///
  /// In de, this message translates to:
  /// **'Kalenderdatei gespeichert — mit Kalender-App öffnen.'**
  String get homeIcsSaved;

  /// No description provided for @homeAppointmentNotFound.
  ///
  /// In de, this message translates to:
  /// **'Termin nicht gefunden'**
  String get homeAppointmentNotFound;

  /// No description provided for @homeMarkDone.
  ///
  /// In de, this message translates to:
  /// **'Als erledigt markieren'**
  String get homeMarkDone;

  /// No description provided for @homeCancelAppointment.
  ///
  /// In de, this message translates to:
  /// **'Absagen'**
  String get homeCancelAppointment;

  /// No description provided for @homeReopen.
  ///
  /// In de, this message translates to:
  /// **'Wieder planen'**
  String get homeReopen;

  /// No description provided for @homeDoctorSummaryPdf.
  ///
  /// In de, this message translates to:
  /// **'Zusammenfassung für Arzt (PDF)'**
  String get homeDoctorSummaryPdf;

  /// No description provided for @homeExportIcs.
  ///
  /// In de, this message translates to:
  /// **'Als Kalenderdatei (.ics)'**
  String get homeExportIcs;

  /// No description provided for @homeDetailDateTimePattern.
  ///
  /// In de, this message translates to:
  /// **'EEEE, d. MMMM yyyy · HH:mm'**
  String get homeDetailDateTimePattern;

  /// No description provided for @homeSymptomsAndCheckIns.
  ///
  /// In de, this message translates to:
  /// **'Symptome & gemeldete Check-ins'**
  String get homeSymptomsAndCheckIns;

  /// No description provided for @homeNoReportYet.
  ///
  /// In de, this message translates to:
  /// **'Noch kein Bericht — nach dem Termin ablegen.'**
  String get homeNoReportYet;

  /// No description provided for @homeReportScan.
  ///
  /// In de, this message translates to:
  /// **'Scan'**
  String get homeReportScan;

  /// No description provided for @homeReportTextSearchable.
  ///
  /// In de, this message translates to:
  /// **'Text durchsuchbar'**
  String get homeReportTextSearchable;

  /// No description provided for @homeReportNoText.
  ///
  /// In de, this message translates to:
  /// **'Kein Text erkannt'**
  String get homeReportNoText;

  /// No description provided for @homeAddReport.
  ///
  /// In de, this message translates to:
  /// **'Bericht hinzufügen'**
  String get homeAddReport;

  /// No description provided for @homeNotesTip.
  ///
  /// In de, this message translates to:
  /// **'Tipp: Fragen für den Termin vorab als Notiz festhalten.'**
  String get homeNotesTip;

  /// No description provided for @homeCalendarTitle.
  ///
  /// In de, this message translates to:
  /// **'Kalender'**
  String get homeCalendarTitle;

  /// No description provided for @homeCalendarForward.
  ///
  /// In de, this message translates to:
  /// **'Vor'**
  String get homeCalendarForward;

  /// No description provided for @homeCalendarDay.
  ///
  /// In de, this message translates to:
  /// **'Tag'**
  String get homeCalendarDay;

  /// No description provided for @homeCalendarWeek.
  ///
  /// In de, this message translates to:
  /// **'Woche'**
  String get homeCalendarWeek;

  /// No description provided for @homeCalendarMonth.
  ///
  /// In de, this message translates to:
  /// **'Monat'**
  String get homeCalendarMonth;

  /// No description provided for @homeCalendarYear.
  ///
  /// In de, this message translates to:
  /// **'Jahr'**
  String get homeCalendarYear;

  /// No description provided for @homeCalendarDayTitlePattern.
  ///
  /// In de, this message translates to:
  /// **'EEEE, d. MMMM'**
  String get homeCalendarDayTitlePattern;

  /// No description provided for @homeCalendarNoAppointmentsOnDay.
  ///
  /// In de, this message translates to:
  /// **'Keine Termine an diesem Tag'**
  String get homeCalendarNoAppointmentsOnDay;

  /// No description provided for @homeCalendarWeekFrom.
  ///
  /// In de, this message translates to:
  /// **'Woche ab {date}'**
  String homeCalendarWeekFrom(String date);

  /// No description provided for @homeCalendarWeekStartPattern.
  ///
  /// In de, this message translates to:
  /// **'d. MMM'**
  String get homeCalendarWeekStartPattern;

  /// No description provided for @homeCalendarAppointmentCount.
  ///
  /// In de, this message translates to:
  /// **'{count} Termine'**
  String homeCalendarAppointmentCount(int count);

  /// No description provided for @homeCheckInEmptyTitle.
  ///
  /// In de, this message translates to:
  /// **'Keine offenen Symptome'**
  String get homeCheckInEmptyTitle;

  /// No description provided for @homeCheckInEmptyMessage.
  ///
  /// In de, this message translates to:
  /// **'Alle Symptome sind geheilt oder noch keines angelegt.'**
  String get homeCheckInEmptyMessage;

  /// No description provided for @homeCheckInHint.
  ///
  /// In de, this message translates to:
  /// **'Skala 1–10 oder als geheilt markieren.'**
  String get homeCheckInHint;

  /// No description provided for @homeCheckInHealed.
  ///
  /// In de, this message translates to:
  /// **'Geheilt'**
  String get homeCheckInHealed;

  /// No description provided for @homeCheckInWillBeHealed.
  ///
  /// In de, this message translates to:
  /// **'Wird als geheilt gespeichert'**
  String get homeCheckInWillBeHealed;

  /// No description provided for @homeCheckInSaved.
  ///
  /// In de, this message translates to:
  /// **'Check-in gespeichert'**
  String get homeCheckInSaved;

  /// No description provided for @homeMedsTodayTitle.
  ///
  /// In de, this message translates to:
  /// **'Medikamente heute'**
  String get homeMedsTodayTitle;

  /// No description provided for @homeMedsTodayNone.
  ///
  /// In de, this message translates to:
  /// **'Heute ist keine Einnahme geplant.'**
  String get homeMedsTodayNone;

  /// No description provided for @homeMedsTodayAllDone.
  ///
  /// In de, this message translates to:
  /// **'Alles erledigt.'**
  String get homeMedsTodayAllDone;

  /// No description provided for @homeMedsTodayOpen.
  ///
  /// In de, this message translates to:
  /// **'{open} von {total} offen'**
  String homeMedsTodayOpen(int open, int total);

  /// No description provided for @homeTimePattern.
  ///
  /// In de, this message translates to:
  /// **'HH:mm'**
  String get homeTimePattern;

  /// No description provided for @homeIntakeSkipped.
  ///
  /// In de, this message translates to:
  /// **'Ausgelassen'**
  String get homeIntakeSkipped;

  /// No description provided for @homeIntakeTaken.
  ///
  /// In de, this message translates to:
  /// **'Eingenommen'**
  String get homeIntakeTaken;

  /// No description provided for @homeIntakeTakenShort.
  ///
  /// In de, this message translates to:
  /// **'Genommen'**
  String get homeIntakeTakenShort;

  /// No description provided for @homeIntakePlannedAt.
  ///
  /// In de, this message translates to:
  /// **'Geplant {time}'**
  String homeIntakePlannedAt(String time);

  /// No description provided for @homeMedFormTablet.
  ///
  /// In de, this message translates to:
  /// **'Tablette'**
  String get homeMedFormTablet;

  /// No description provided for @homeMedFormCapsule.
  ///
  /// In de, this message translates to:
  /// **'Kapsel'**
  String get homeMedFormCapsule;

  /// No description provided for @homeMedFormDrops.
  ///
  /// In de, this message translates to:
  /// **'Tropfen'**
  String get homeMedFormDrops;

  /// No description provided for @homeMedFormLiquid.
  ///
  /// In de, this message translates to:
  /// **'Saft / Lösung'**
  String get homeMedFormLiquid;

  /// No description provided for @homeMedFormSpray.
  ///
  /// In de, this message translates to:
  /// **'Spray'**
  String get homeMedFormSpray;

  /// No description provided for @homeMedFormInhaler.
  ///
  /// In de, this message translates to:
  /// **'Inhalator'**
  String get homeMedFormInhaler;

  /// No description provided for @homeMedFormOintment.
  ///
  /// In de, this message translates to:
  /// **'Salbe / Creme'**
  String get homeMedFormOintment;

  /// No description provided for @homeMedFormInjection.
  ///
  /// In de, this message translates to:
  /// **'Spritze'**
  String get homeMedFormInjection;

  /// No description provided for @homeMedFormPatch.
  ///
  /// In de, this message translates to:
  /// **'Pflaster'**
  String get homeMedFormPatch;

  /// No description provided for @homeMedFormSuppository.
  ///
  /// In de, this message translates to:
  /// **'Zäpfchen'**
  String get homeMedFormSuppository;

  /// No description provided for @homeMedFormPowder.
  ///
  /// In de, this message translates to:
  /// **'Pulver / Granulat'**
  String get homeMedFormPowder;

  /// No description provided for @homeMedFormOther.
  ///
  /// In de, this message translates to:
  /// **'Sonstiges'**
  String get homeMedFormOther;

  /// No description provided for @homeUnitPiece.
  ///
  /// In de, this message translates to:
  /// **'Stück'**
  String get homeUnitPiece;

  /// No description provided for @homeUnitDrops.
  ///
  /// In de, this message translates to:
  /// **'Tropfen'**
  String get homeUnitDrops;

  /// No description provided for @homeUnitSpray.
  ///
  /// In de, this message translates to:
  /// **'Sprühstoß'**
  String get homeUnitSpray;

  /// No description provided for @homeUnitPuff.
  ///
  /// In de, this message translates to:
  /// **'Hub'**
  String get homeUnitPuff;

  /// No description provided for @homeUnitApplication.
  ///
  /// In de, this message translates to:
  /// **'Anwendung'**
  String get homeUnitApplication;

  /// No description provided for @homeUnitUnit.
  ///
  /// In de, this message translates to:
  /// **'Einheit'**
  String get homeUnitUnit;

  /// No description provided for @homeUnitSachet.
  ///
  /// In de, this message translates to:
  /// **'Beutel'**
  String get homeUnitSachet;

  /// No description provided for @homeUnitMeasuringSpoon.
  ///
  /// In de, this message translates to:
  /// **'Messlöffel'**
  String get homeUnitMeasuringSpoon;

  /// No description provided for @homeUnitIu.
  ///
  /// In de, this message translates to:
  /// **'IE'**
  String get homeUnitIu;

  /// No description provided for @homeWeekdaysDaily.
  ///
  /// In de, this message translates to:
  /// **'täglich'**
  String get homeWeekdaysDaily;

  /// No description provided for @homeWeekdaysWorkdays.
  ///
  /// In de, this message translates to:
  /// **'werktags'**
  String get homeWeekdaysWorkdays;

  /// No description provided for @homeWeekdaysWeekend.
  ///
  /// In de, this message translates to:
  /// **'am Wochenende'**
  String get homeWeekdaysWeekend;

  /// No description provided for @homeMedNameMissing.
  ///
  /// In de, this message translates to:
  /// **'Name fehlt'**
  String get homeMedNameMissing;

  /// No description provided for @homeMedCreate.
  ///
  /// In de, this message translates to:
  /// **'Medikament anlegen'**
  String get homeMedCreate;

  /// No description provided for @homeMedEdit.
  ///
  /// In de, this message translates to:
  /// **'Medikament bearbeiten'**
  String get homeMedEdit;

  /// No description provided for @homeMedStrength.
  ///
  /// In de, this message translates to:
  /// **'Wirkstärke (z. B. 400 mg)'**
  String get homeMedStrength;

  /// No description provided for @homeMedForm.
  ///
  /// In de, this message translates to:
  /// **'Darreichungsform'**
  String get homeMedForm;

  /// No description provided for @homeMedDosePerIntake.
  ///
  /// In de, this message translates to:
  /// **'Dosis je Einnahme'**
  String get homeMedDosePerIntake;

  /// No description provided for @homeMedUnit.
  ///
  /// In de, this message translates to:
  /// **'Einheit'**
  String get homeMedUnit;

  /// No description provided for @homeMedInstructions.
  ///
  /// In de, this message translates to:
  /// **'Hinweis (z. B. nach dem Essen)'**
  String get homeMedInstructions;

  /// No description provided for @homeMedIntakeTimes.
  ///
  /// In de, this message translates to:
  /// **'Einnahmezeiten'**
  String get homeMedIntakeTimes;

  /// No description provided for @homeMedAmount.
  ///
  /// In de, this message translates to:
  /// **'Menge'**
  String get homeMedAmount;

  /// No description provided for @homeMedAmountSameAsAbove.
  ///
  /// In de, this message translates to:
  /// **'wie oben'**
  String get homeMedAmountSameAsAbove;

  /// No description provided for @homeMedRemoveIntakeTime.
  ///
  /// In de, this message translates to:
  /// **'Einnahmezeit entfernen'**
  String get homeMedRemoveIntakeTime;

  /// No description provided for @homeMedAddIntakeTime.
  ///
  /// In de, this message translates to:
  /// **'Einnahmezeit hinzufügen'**
  String get homeMedAddIntakeTime;

  /// No description provided for @homeMedRemind.
  ///
  /// In de, this message translates to:
  /// **'An Einnahme erinnern'**
  String get homeMedRemind;

  /// No description provided for @homeMedPeriod.
  ///
  /// In de, this message translates to:
  /// **'Zeitraum'**
  String get homeMedPeriod;

  /// No description provided for @homeMedStart.
  ///
  /// In de, this message translates to:
  /// **'Beginn'**
  String get homeMedStart;

  /// No description provided for @homeMedOngoing.
  ///
  /// In de, this message translates to:
  /// **'Dauerhaft'**
  String get homeMedOngoing;

  /// No description provided for @homeMedUntilDate.
  ///
  /// In de, this message translates to:
  /// **'Bis Datum'**
  String get homeMedUntilDate;

  /// No description provided for @homeMedDays.
  ///
  /// In de, this message translates to:
  /// **'Tage'**
  String get homeMedDays;

  /// No description provided for @homeMedEnd.
  ///
  /// In de, this message translates to:
  /// **'Ende'**
  String get homeMedEnd;

  /// No description provided for @homeMedNumberOfDays.
  ///
  /// In de, this message translates to:
  /// **'Anzahl Tage'**
  String get homeMedNumberOfDays;

  /// No description provided for @homeMedLastIntakeOn.
  ///
  /// In de, this message translates to:
  /// **'Letzte Einnahme am {date}'**
  String homeMedLastIntakeOn(String date);

  /// No description provided for @homeMedAssignment.
  ///
  /// In de, this message translates to:
  /// **'Zuordnung'**
  String get homeMedAssignment;

  /// No description provided for @homeMedPrescribedBy.
  ///
  /// In de, this message translates to:
  /// **'Verschrieben von'**
  String get homeMedPrescribedBy;

  /// No description provided for @homeMedAddPharmacy.
  ///
  /// In de, this message translates to:
  /// **'Apotheke anlegen'**
  String get homeMedAddPharmacy;

  /// No description provided for @homePharmacyEdit.
  ///
  /// In de, this message translates to:
  /// **'Apotheke bearbeiten'**
  String get homePharmacyEdit;

  /// No description provided for @homePharmacyAddress.
  ///
  /// In de, this message translates to:
  /// **'Adresse'**
  String get homePharmacyAddress;

  /// No description provided for @homePharmacyPhone.
  ///
  /// In de, this message translates to:
  /// **'Telefon'**
  String get homePharmacyPhone;

  /// No description provided for @homeVaccinationAdd.
  ///
  /// In de, this message translates to:
  /// **'Impfung eintragen'**
  String get homeVaccinationAdd;

  /// No description provided for @homeVaccinationEdit.
  ///
  /// In de, this message translates to:
  /// **'Impfung bearbeiten'**
  String get homeVaccinationEdit;

  /// No description provided for @homeVaccinationAgainst.
  ///
  /// In de, this message translates to:
  /// **'Impfung gegen'**
  String get homeVaccinationAgainst;

  /// No description provided for @homeVaccinationProduct.
  ///
  /// In de, this message translates to:
  /// **'Impfstoff (Handelsname)'**
  String get homeVaccinationProduct;

  /// No description provided for @homeVaccinationDate.
  ///
  /// In de, this message translates to:
  /// **'Geimpft am'**
  String get homeVaccinationDate;

  /// No description provided for @homeVaccinationDoseNumber.
  ///
  /// In de, this message translates to:
  /// **'Dosis-Nr.'**
  String get homeVaccinationDoseNumber;

  /// No description provided for @homeVaccinationBatch.
  ///
  /// In de, this message translates to:
  /// **'Charge'**
  String get homeVaccinationBatch;

  /// No description provided for @homeVaccinationBy.
  ///
  /// In de, this message translates to:
  /// **'Geimpft von'**
  String get homeVaccinationBy;

  /// No description provided for @homeVaccinationNextDue.
  ///
  /// In de, this message translates to:
  /// **'Nächste Impfung fällig'**
  String get homeVaccinationNextDue;

  /// No description provided for @homeVaccinationPlusYears.
  ///
  /// In de, this message translates to:
  /// **'+{years} J.'**
  String homeVaccinationPlusYears(int years);

  /// No description provided for @homeReportTextRecognized.
  ///
  /// In de, this message translates to:
  /// **'Text erkannt und durchsuchbar'**
  String get homeReportTextRecognized;

  /// No description provided for @homeReportRecognizedText.
  ///
  /// In de, this message translates to:
  /// **'Erkannter Text'**
  String get homeReportRecognizedText;

  /// No description provided for @homeReportNoTextDot.
  ///
  /// In de, this message translates to:
  /// **'Kein Text erkannt.'**
  String get homeReportNoTextDot;

  /// No description provided for @homeReportNotFound.
  ///
  /// In de, this message translates to:
  /// **'Bericht nicht gefunden'**
  String get homeReportNotFound;

  /// No description provided for @homeReportRename.
  ///
  /// In de, this message translates to:
  /// **'Umbenennen'**
  String get homeReportRename;

  /// No description provided for @homeReportShowText.
  ///
  /// In de, this message translates to:
  /// **'Erkannten Text zeigen'**
  String get homeReportShowText;

  /// No description provided for @homeReportReindex.
  ///
  /// In de, this message translates to:
  /// **'Text neu erkennen'**
  String get homeReportReindex;

  /// No description provided for @homeReportDatePattern.
  ///
  /// In de, this message translates to:
  /// **'d. MMM yyyy'**
  String get homeReportDatePattern;

  /// No description provided for @homeReportFileUnavailable.
  ///
  /// In de, this message translates to:
  /// **'Datei nicht verfügbar'**
  String get homeReportFileUnavailable;

  /// No description provided for @homeReportFileUnavailableHint.
  ///
  /// In de, this message translates to:
  /// **'Abgelegt am {date}. Im Web werden Dateien nicht gespeichert; auf dem Gerät wurde die Datei evtl. entfernt.'**
  String homeReportFileUnavailableHint(String date);

  /// No description provided for @homeStatusPlanned.
  ///
  /// In de, this message translates to:
  /// **'Geplant'**
  String get homeStatusPlanned;

  /// No description provided for @homeStatusDone.
  ///
  /// In de, this message translates to:
  /// **'Erledigt'**
  String get homeStatusDone;

  /// No description provided for @homeStatusCancelled.
  ///
  /// In de, this message translates to:
  /// **'Abgesagt'**
  String get homeStatusCancelled;

  /// No description provided for @homeUnknownDoctor.
  ///
  /// In de, this message translates to:
  /// **'Unbekannter Arzt'**
  String get homeUnknownDoctor;

  /// No description provided for @homeArchiveBlockedDoctor.
  ///
  /// In de, this message translates to:
  /// **'Arzt hat noch Termine — erst Termine archivieren oder umhängen.'**
  String get homeArchiveBlockedDoctor;

  /// No description provided for @homeArchivePurgeBlockedDoctor.
  ///
  /// In de, this message translates to:
  /// **'Arzt hat noch (archivierte) Termine — diese zuerst endgültig löschen.'**
  String get homeArchivePurgeBlockedDoctor;

  /// No description provided for @homeArchiveDatePattern.
  ///
  /// In de, this message translates to:
  /// **'d.M.yyyy'**
  String get homeArchiveDatePattern;

  /// No description provided for @homeDiagnosisStatusActive.
  ///
  /// In de, this message translates to:
  /// **'aktiv'**
  String get homeDiagnosisStatusActive;

  /// No description provided for @homeDiagnosisStatusResolved.
  ///
  /// In de, this message translates to:
  /// **'abgeschlossen'**
  String get homeDiagnosisStatusResolved;

  /// No description provided for @homeSymptomHealed.
  ///
  /// In de, this message translates to:
  /// **'geheilt'**
  String get homeSymptomHealed;

  /// No description provided for @homeRecordsDatePattern.
  ///
  /// In de, this message translates to:
  /// **'dd.MM.yyyy'**
  String get homeRecordsDatePattern;

  /// No description provided for @homeVaccinationDoseLabel.
  ///
  /// In de, this message translates to:
  /// **'{number}. Dosis'**
  String homeVaccinationDoseLabel(int number);

  /// No description provided for @recordsTitle.
  ///
  /// In de, this message translates to:
  /// **'Meine Akte'**
  String get recordsTitle;

  /// No description provided for @recordsAssistantTooltip.
  ///
  /// In de, this message translates to:
  /// **'Assistent — Fragen an deine Akte'**
  String get recordsAssistantTooltip;

  /// No description provided for @recordsVisitSummaryTooltip.
  ///
  /// In de, this message translates to:
  /// **'Zusammenfassung für den Arztbesuch'**
  String get recordsVisitSummaryTooltip;

  /// No description provided for @recordsSortTooltip.
  ///
  /// In de, this message translates to:
  /// **'Sortierung'**
  String get recordsSortTooltip;

  /// No description provided for @recordsSortDate.
  ///
  /// In de, this message translates to:
  /// **'Datum'**
  String get recordsSortDate;

  /// No description provided for @recordsSortName.
  ///
  /// In de, this message translates to:
  /// **'Name'**
  String get recordsSortName;

  /// No description provided for @recordsSortUpdated.
  ///
  /// In de, this message translates to:
  /// **'Zuletzt geändert'**
  String get recordsSortUpdated;

  /// No description provided for @recordsAddEntry.
  ///
  /// In de, this message translates to:
  /// **'Eintrag anlegen'**
  String get recordsAddEntry;

  /// No description provided for @recordsSearchHint.
  ///
  /// In de, this message translates to:
  /// **'Suche in Akte & Berichten…'**
  String get recordsSearchHint;

  /// No description provided for @recordsLoading.
  ///
  /// In de, this message translates to:
  /// **'Akte wird geladen…'**
  String get recordsLoading;

  /// No description provided for @recordsEmpty.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Einträge'**
  String get recordsEmpty;

  /// No description provided for @recordsNoResults.
  ///
  /// In de, this message translates to:
  /// **'Keine Treffer für „{query}“'**
  String recordsNoResults(String query);

  /// No description provided for @recordsEmptyHint.
  ///
  /// In de, this message translates to:
  /// **'Filter und Suche sind bereit — lege den ersten Eintrag an.'**
  String get recordsEmptyHint;

  /// No description provided for @recordsFilterAll.
  ///
  /// In de, this message translates to:
  /// **'Alle'**
  String get recordsFilterAll;

  /// No description provided for @recordsCreateDoctors.
  ///
  /// In de, this message translates to:
  /// **'Ärzte anlegen'**
  String get recordsCreateDoctors;

  /// No description provided for @recordsCreateDiagnoses.
  ///
  /// In de, this message translates to:
  /// **'Diagnosen anlegen'**
  String get recordsCreateDiagnoses;

  /// No description provided for @recordsCreateSymptoms.
  ///
  /// In de, this message translates to:
  /// **'Symptome anlegen'**
  String get recordsCreateSymptoms;

  /// No description provided for @recordsCreateAppointments.
  ///
  /// In de, this message translates to:
  /// **'Termine anlegen'**
  String get recordsCreateAppointments;

  /// No description provided for @recordsCreateReports.
  ///
  /// In de, this message translates to:
  /// **'Berichte anlegen'**
  String get recordsCreateReports;

  /// No description provided for @recordsCreateMedications.
  ///
  /// In de, this message translates to:
  /// **'Medikamente anlegen'**
  String get recordsCreateMedications;

  /// No description provided for @recordsCreatePharmacies.
  ///
  /// In de, this message translates to:
  /// **'Apotheken anlegen'**
  String get recordsCreatePharmacies;

  /// No description provided for @recordsCreateVaccinations.
  ///
  /// In de, this message translates to:
  /// **'Impfungen anlegen'**
  String get recordsCreateVaccinations;

  /// No description provided for @recordsCreateNotes.
  ///
  /// In de, this message translates to:
  /// **'Notizen anlegen'**
  String get recordsCreateNotes;

  /// No description provided for @recordsDatePattern.
  ///
  /// In de, this message translates to:
  /// **'d. MMM yyyy'**
  String get recordsDatePattern;

  /// No description provided for @recordsDateTimePattern.
  ///
  /// In de, this message translates to:
  /// **'d. MMM yyyy · HH:mm'**
  String get recordsDateTimePattern;

  /// No description provided for @recordsTimePattern.
  ///
  /// In de, this message translates to:
  /// **'HH:mm'**
  String get recordsTimePattern;

  /// No description provided for @recordsDiagnosisNone.
  ///
  /// In de, this message translates to:
  /// **'Keine'**
  String get recordsDiagnosisNone;

  /// No description provided for @recordsDateClearTooltip.
  ///
  /// In de, this message translates to:
  /// **'{label} entfernen'**
  String recordsDateClearTooltip(String label);

  /// No description provided for @recordsDoctorCreateTitle.
  ///
  /// In de, this message translates to:
  /// **'Arzt anlegen'**
  String get recordsDoctorCreateTitle;

  /// No description provided for @recordsDoctorEditTitle.
  ///
  /// In de, this message translates to:
  /// **'Arzt bearbeiten'**
  String get recordsDoctorEditTitle;

  /// No description provided for @recordsFieldName.
  ///
  /// In de, this message translates to:
  /// **'Name'**
  String get recordsFieldName;

  /// No description provided for @recordsFieldSpecialty.
  ///
  /// In de, this message translates to:
  /// **'Fachrichtung'**
  String get recordsFieldSpecialty;

  /// No description provided for @recordsFieldPractice.
  ///
  /// In de, this message translates to:
  /// **'Praxis / Klinik'**
  String get recordsFieldPractice;

  /// No description provided for @recordsFieldPhone.
  ///
  /// In de, this message translates to:
  /// **'Telefon'**
  String get recordsFieldPhone;

  /// No description provided for @recordsFieldAddress.
  ///
  /// In de, this message translates to:
  /// **'Adresse'**
  String get recordsFieldAddress;

  /// No description provided for @recordsDiagnosisCreateTitle.
  ///
  /// In de, this message translates to:
  /// **'Diagnose anlegen'**
  String get recordsDiagnosisCreateTitle;

  /// No description provided for @recordsDiagnosisEditTitle.
  ///
  /// In de, this message translates to:
  /// **'Diagnose bearbeiten'**
  String get recordsDiagnosisEditTitle;

  /// No description provided for @recordsFieldTitle.
  ///
  /// In de, this message translates to:
  /// **'Titel'**
  String get recordsFieldTitle;

  /// No description provided for @recordsDiagnosisActive.
  ///
  /// In de, this message translates to:
  /// **'Aktiv'**
  String get recordsDiagnosisActive;

  /// No description provided for @recordsDiagnosisResolved.
  ///
  /// In de, this message translates to:
  /// **'Abgeschlossen'**
  String get recordsDiagnosisResolved;

  /// No description provided for @recordsDiagnosisSince.
  ///
  /// In de, this message translates to:
  /// **'Seit'**
  String get recordsDiagnosisSince;

  /// No description provided for @recordsDiagnosisUntil.
  ///
  /// In de, this message translates to:
  /// **'Bis'**
  String get recordsDiagnosisUntil;

  /// No description provided for @recordsSymptomCreateTitle.
  ///
  /// In de, this message translates to:
  /// **'Symptom anlegen'**
  String get recordsSymptomCreateTitle;

  /// No description provided for @recordsSymptomEditTitle.
  ///
  /// In de, this message translates to:
  /// **'Symptom bearbeiten'**
  String get recordsSymptomEditTitle;

  /// No description provided for @recordsFieldSymptomLabel.
  ///
  /// In de, this message translates to:
  /// **'Bezeichnung'**
  String get recordsFieldSymptomLabel;

  /// No description provided for @recordsFieldBodyRegion.
  ///
  /// In de, this message translates to:
  /// **'Körperregion'**
  String get recordsFieldBodyRegion;

  /// No description provided for @recordsNoteCreateTitle.
  ///
  /// In de, this message translates to:
  /// **'Notiz anlegen'**
  String get recordsNoteCreateTitle;

  /// No description provided for @recordsNoteEditTitle.
  ///
  /// In de, this message translates to:
  /// **'Notiz bearbeiten'**
  String get recordsNoteEditTitle;

  /// No description provided for @recordsFieldText.
  ///
  /// In de, this message translates to:
  /// **'Text'**
  String get recordsFieldText;

  /// No description provided for @recordsReportRenameTitle.
  ///
  /// In de, this message translates to:
  /// **'Bericht umbenennen'**
  String get recordsReportRenameTitle;

  /// No description provided for @recordsDeleteConfirmTitle.
  ///
  /// In de, this message translates to:
  /// **'{what} löschen?'**
  String recordsDeleteConfirmTitle(String what);

  /// No description provided for @recordsDeleteConfirmBody.
  ///
  /// In de, this message translates to:
  /// **'Das kann nicht rückgängig gemacht werden.'**
  String get recordsDeleteConfirmBody;

  /// No description provided for @recordsScanDocument.
  ///
  /// In de, this message translates to:
  /// **'Dokument scannen'**
  String get recordsScanDocument;

  /// No description provided for @recordsScanDocumentHint.
  ///
  /// In de, this message translates to:
  /// **'Kamera · Text wird erkannt und durchsuchbar'**
  String get recordsScanDocumentHint;

  /// No description provided for @recordsPickFiles.
  ///
  /// In de, this message translates to:
  /// **'Dateien wählen'**
  String get recordsPickFiles;

  /// No description provided for @recordsPickFilesHint.
  ///
  /// In de, this message translates to:
  /// **'PDFs oder Bilder · auch mehrere auf einmal'**
  String get recordsPickFilesHint;

  /// No description provided for @recordsScannerUnavailableTitle.
  ///
  /// In de, this message translates to:
  /// **'Scanner startet nicht'**
  String get recordsScannerUnavailableTitle;

  /// No description provided for @recordsScannerUnavailableBody.
  ///
  /// In de, this message translates to:
  /// **'Der Dokumentenscanner von Google startet auf diesem Gerät nicht. Ein Foto mit der Kamera funktioniert immer — der Text wird genauso erkannt.\n\nDetails: {details}'**
  String recordsScannerUnavailableBody(String details);

  /// No description provided for @recordsPickFile.
  ///
  /// In de, this message translates to:
  /// **'Datei wählen'**
  String get recordsPickFile;

  /// No description provided for @recordsScanSaving.
  ///
  /// In de, this message translates to:
  /// **'Scan wird gespeichert, Text wird erkannt…'**
  String get recordsScanSaving;

  /// No description provided for @recordsScanFileName.
  ///
  /// In de, this message translates to:
  /// **'Scan {date}.pdf'**
  String recordsScanFileName(String date);

  /// No description provided for @recordsScanFileDatePattern.
  ///
  /// In de, this message translates to:
  /// **'dd.MM.yyyy HH-mm'**
  String get recordsScanFileDatePattern;

  /// No description provided for @recordsScanSavedNoText.
  ///
  /// In de, this message translates to:
  /// **'Scan gespeichert (kein Text erkannt)'**
  String get recordsScanSavedNoText;

  /// No description provided for @recordsScanSavedWithText.
  ///
  /// In de, this message translates to:
  /// **'Scan gespeichert — Text durchsuchbar'**
  String get recordsScanSavedWithText;

  /// No description provided for @recordsReportSaved.
  ///
  /// In de, this message translates to:
  /// **'Bericht „{title}“ gespeichert'**
  String recordsReportSaved(String title);

  /// No description provided for @recordsReportsSaved.
  ///
  /// In de, this message translates to:
  /// **'{count, plural, =1{1 Bericht gespeichert} other{{count} Berichte gespeichert}}'**
  String recordsReportsSaved(int count);

  /// No description provided for @recordsImportPartial.
  ///
  /// In de, this message translates to:
  /// **'{saved} gespeichert, {failed} fehlgeschlagen: {files}'**
  String recordsImportPartial(int saved, int failed, String files);

  /// No description provided for @recordsDeleteToArchive.
  ///
  /// In de, this message translates to:
  /// **'Löschen (ins Archiv)'**
  String get recordsDeleteToArchive;

  /// No description provided for @recordsNotFound.
  ///
  /// In de, this message translates to:
  /// **'Eintrag nicht gefunden'**
  String get recordsNotFound;

  /// No description provided for @recordsPractice.
  ///
  /// In de, this message translates to:
  /// **'Praxis'**
  String get recordsPractice;

  /// No description provided for @recordsPhoneTapToCall.
  ///
  /// In de, this message translates to:
  /// **'Telefon · tippen zum Anrufen'**
  String get recordsPhoneTapToCall;

  /// No description provided for @recordsAddressOpenMaps.
  ///
  /// In de, this message translates to:
  /// **'Adresse · in Karten öffnen'**
  String get recordsAddressOpenMaps;

  /// No description provided for @recordsDoctorNoSymptoms.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Symptome bei diesem Arzt.'**
  String get recordsDoctorNoSymptoms;

  /// No description provided for @recordsAssign.
  ///
  /// In de, this message translates to:
  /// **'Zuordnen'**
  String get recordsAssign;

  /// No description provided for @recordsStatusActive.
  ///
  /// In de, this message translates to:
  /// **'aktiv'**
  String get recordsStatusActive;

  /// No description provided for @recordsStatusHealed.
  ///
  /// In de, this message translates to:
  /// **'geheilt'**
  String get recordsStatusHealed;

  /// No description provided for @recordsLinkedDirect.
  ///
  /// In de, this message translates to:
  /// **'zugeordnet'**
  String get recordsLinkedDirect;

  /// No description provided for @recordsLinkedViaAppointments.
  ///
  /// In de, this message translates to:
  /// **'aus Terminen'**
  String get recordsLinkedViaAppointments;

  /// No description provided for @recordsDoctorNoAppointments.
  ///
  /// In de, this message translates to:
  /// **'Keine Termine bei diesem Arzt.'**
  String get recordsDoctorNoAppointments;

  /// No description provided for @recordsAssignSymptomsTitle.
  ///
  /// In de, this message translates to:
  /// **'Symptome bei {name}'**
  String recordsAssignSymptomsTitle(String name);

  /// No description provided for @recordsNoSymptomsYet.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Symptome angelegt.'**
  String get recordsNoSymptomsYet;

  /// No description provided for @recordsSince.
  ///
  /// In de, this message translates to:
  /// **'seit {date}'**
  String recordsSince(String date);

  /// No description provided for @recordsUntil.
  ///
  /// In de, this message translates to:
  /// **'bis {date}'**
  String recordsUntil(String date);

  /// No description provided for @recordsDiagnosisNoAppointments.
  ///
  /// In de, this message translates to:
  /// **'Noch keinem Termin zugeordnet.'**
  String get recordsDiagnosisNoAppointments;

  /// No description provided for @recordsNoSymptomsLinked.
  ///
  /// In de, this message translates to:
  /// **'Keine Symptome verknüpft.'**
  String get recordsNoSymptomsLinked;

  /// No description provided for @recordsNoMedicationsLinked.
  ///
  /// In de, this message translates to:
  /// **'Keine Medikamente verknüpft.'**
  String get recordsNoMedicationsLinked;

  /// No description provided for @recordsDiagnosisNoReports.
  ///
  /// In de, this message translates to:
  /// **'Keine Berichte zu den Terminen.'**
  String get recordsDiagnosisNoReports;

  /// No description provided for @recordsHealedOn.
  ///
  /// In de, this message translates to:
  /// **'geheilt am {date}'**
  String recordsHealedOn(String date);

  /// No description provided for @recordsMarkHealed.
  ///
  /// In de, this message translates to:
  /// **'Als geheilt markieren'**
  String get recordsMarkHealed;

  /// No description provided for @recordsReopen.
  ///
  /// In de, this message translates to:
  /// **'Wieder aktiv'**
  String get recordsReopen;

  /// No description provided for @recordsDiscussedAtAppointments.
  ///
  /// In de, this message translates to:
  /// **'Besprochen bei Terminen'**
  String get recordsDiscussedAtAppointments;

  /// No description provided for @recordsHistory.
  ///
  /// In de, this message translates to:
  /// **'Verlauf'**
  String get recordsHistory;

  /// No description provided for @recordsCheckIns.
  ///
  /// In de, this message translates to:
  /// **'Check-ins'**
  String get recordsCheckIns;

  /// No description provided for @recordsNoCheckIns.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Check-ins.'**
  String get recordsNoCheckIns;

  /// No description provided for @recordsDeleteValue.
  ///
  /// In de, this message translates to:
  /// **'Wert löschen'**
  String get recordsDeleteValue;

  /// No description provided for @recordsFrom.
  ///
  /// In de, this message translates to:
  /// **'ab {date}'**
  String recordsFrom(String date);

  /// No description provided for @recordsOngoing.
  ///
  /// In de, this message translates to:
  /// **'dauerhaft'**
  String get recordsOngoing;

  /// No description provided for @recordsDosePerIntake.
  ///
  /// In de, this message translates to:
  /// **'Dosis je Einnahme'**
  String get recordsDosePerIntake;

  /// No description provided for @recordsInstructions.
  ///
  /// In de, this message translates to:
  /// **'Hinweis'**
  String get recordsInstructions;

  /// No description provided for @recordsPeriod.
  ///
  /// In de, this message translates to:
  /// **'Zeitraum'**
  String get recordsPeriod;

  /// No description provided for @recordsIntakeTimes.
  ///
  /// In de, this message translates to:
  /// **'Einnahmezeiten'**
  String get recordsIntakeTimes;

  /// No description provided for @recordsNoIntakeTimes.
  ///
  /// In de, this message translates to:
  /// **'Keine festen Einnahmezeiten.'**
  String get recordsNoIntakeTimes;

  /// No description provided for @recordsIntake.
  ///
  /// In de, this message translates to:
  /// **'Einnahme'**
  String get recordsIntake;

  /// No description provided for @recordsRemindIntake.
  ///
  /// In de, this message translates to:
  /// **'An Einnahme erinnern'**
  String get recordsRemindIntake;

  /// No description provided for @recordsPrescribedBy.
  ///
  /// In de, this message translates to:
  /// **'Verschrieben von'**
  String get recordsPrescribedBy;

  /// No description provided for @recordsIntakeLog.
  ///
  /// In de, this message translates to:
  /// **'Einnahme-Protokoll'**
  String get recordsIntakeLog;

  /// No description provided for @recordsTakenNow.
  ///
  /// In de, this message translates to:
  /// **'Jetzt genommen'**
  String get recordsTakenNow;

  /// No description provided for @recordsNoIntakesYet.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Einnahme erfasst.'**
  String get recordsNoIntakesYet;

  /// No description provided for @recordsAdherence.
  ///
  /// In de, this message translates to:
  /// **'Letzte 14 Tage: {percent} % der geplanten Einnahmen genommen'**
  String recordsAdherence(int percent);

  /// No description provided for @recordsTaken.
  ///
  /// In de, this message translates to:
  /// **'Genommen'**
  String get recordsTaken;

  /// No description provided for @recordsSkipped.
  ///
  /// In de, this message translates to:
  /// **'Ausgelassen'**
  String get recordsSkipped;

  /// No description provided for @recordsPlannedAt.
  ///
  /// In de, this message translates to:
  /// **'geplant {time}'**
  String recordsPlannedAt(String time);

  /// No description provided for @recordsDeleteEntry.
  ///
  /// In de, this message translates to:
  /// **'Eintrag löschen'**
  String get recordsDeleteEntry;

  /// No description provided for @recordsPharmacyNoMedications.
  ///
  /// In de, this message translates to:
  /// **'Keine Medikamente von dieser Apotheke.'**
  String get recordsPharmacyNoMedications;

  /// No description provided for @recordsDoseNumber.
  ///
  /// In de, this message translates to:
  /// **'{number}. Dosis'**
  String recordsDoseNumber(int number);

  /// No description provided for @recordsVaccineProduct.
  ///
  /// In de, this message translates to:
  /// **'Impfstoff'**
  String get recordsVaccineProduct;

  /// No description provided for @recordsBatch.
  ///
  /// In de, this message translates to:
  /// **'Charge'**
  String get recordsBatch;

  /// No description provided for @recordsBoosterOverdue.
  ///
  /// In de, this message translates to:
  /// **'Auffrischung überfällig'**
  String get recordsBoosterOverdue;

  /// No description provided for @recordsNextDoseDue.
  ///
  /// In de, this message translates to:
  /// **'Nächste Impfung fällig'**
  String get recordsNextDoseDue;

  /// No description provided for @recordsVaccinatedBy.
  ///
  /// In de, this message translates to:
  /// **'Geimpft von'**
  String get recordsVaccinatedBy;

  /// No description provided for @recordsLastModified.
  ///
  /// In de, this message translates to:
  /// **'Zuletzt geändert {date}'**
  String recordsLastModified(String date);

  /// No description provided for @recordsRelatedAppointment.
  ///
  /// In de, this message translates to:
  /// **'Zugehöriger Termin'**
  String get recordsRelatedAppointment;

  /// No description provided for @recordsRelatedDiagnosis.
  ///
  /// In de, this message translates to:
  /// **'Zugehörige Diagnose'**
  String get recordsRelatedDiagnosis;

  /// No description provided for @recordsTakePhoto.
  ///
  /// In de, this message translates to:
  /// **'Foto aufnehmen'**
  String get recordsTakePhoto;

  /// No description provided for @recordsTakePhotoHint.
  ///
  /// In de, this message translates to:
  /// **'Kamera-App · Text wird erkannt und durchsuchbar'**
  String get recordsTakePhotoHint;

  /// No description provided for @settingsTitle.
  ///
  /// In de, this message translates to:
  /// **'Einstellungen'**
  String get settingsTitle;

  /// No description provided for @settingsLoading.
  ///
  /// In de, this message translates to:
  /// **'Einstellungen werden geladen…'**
  String get settingsLoading;

  /// No description provided for @settingsLocalOnlyTitle.
  ///
  /// In de, this message translates to:
  /// **'Alles lokal auf diesem Gerät'**
  String get settingsLocalOnlyTitle;

  /// No description provided for @settingsLocalOnlySubtitle.
  ///
  /// In de, this message translates to:
  /// **'Keine Accounts, keine Patientendaten auf Servern.'**
  String get settingsLocalOnlySubtitle;

  /// No description provided for @settingsArchiveTitle.
  ///
  /// In de, this message translates to:
  /// **'Archiv'**
  String get settingsArchiveTitle;

  /// No description provided for @settingsArchiveSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Gelöschte Einträge wiederherstellen oder endgültig löschen'**
  String get settingsArchiveSubtitle;

  /// No description provided for @settingsAppSection.
  ///
  /// In de, this message translates to:
  /// **'App'**
  String get settingsAppSection;

  /// No description provided for @settingsLanguage.
  ///
  /// In de, this message translates to:
  /// **'Sprache'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageValue.
  ///
  /// In de, this message translates to:
  /// **'Deutsch'**
  String get settingsLanguageValue;

  /// No description provided for @settingsVersion.
  ///
  /// In de, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @settingsDateTimePattern.
  ///
  /// In de, this message translates to:
  /// **'d. MMM, HH:mm'**
  String get settingsDateTimePattern;

  /// No description provided for @settingsBackupTaskBackup.
  ///
  /// In de, this message translates to:
  /// **'Sicherung'**
  String get settingsBackupTaskBackup;

  /// No description provided for @settingsBackupTaskRestore.
  ///
  /// In de, this message translates to:
  /// **'Wiederherstellung'**
  String get settingsBackupTaskRestore;

  /// No description provided for @settingsBackupTaskExport.
  ///
  /// In de, this message translates to:
  /// **'Export'**
  String get settingsBackupTaskExport;

  /// No description provided for @settingsBackupTaskImport.
  ///
  /// In de, this message translates to:
  /// **'Import'**
  String get settingsBackupTaskImport;

  /// No description provided for @settingsBackupTaskReindex.
  ///
  /// In de, this message translates to:
  /// **'Indexierung'**
  String get settingsBackupTaskReindex;

  /// No description provided for @settingsBackupFailed.
  ///
  /// In de, this message translates to:
  /// **'{task} fehlgeschlagen.'**
  String settingsBackupFailed(String task);

  /// No description provided for @settingsBackupRunning.
  ///
  /// In de, this message translates to:
  /// **'{task} läuft…'**
  String settingsBackupRunning(String task);

  /// No description provided for @settingsBackupShareSubject.
  ///
  /// In de, this message translates to:
  /// **'Mai Doctor Hub — Sicherung'**
  String get settingsBackupShareSubject;

  /// No description provided for @settingsBackupCreated.
  ///
  /// In de, this message translates to:
  /// **'Sicherung erstellt — Passwort gut aufbewahren!'**
  String get settingsBackupCreated;

  /// No description provided for @settingsBackupPickTitle.
  ///
  /// In de, this message translates to:
  /// **'Sicherung wählen'**
  String get settingsBackupPickTitle;

  /// No description provided for @settingsBackupNotABackup.
  ///
  /// In de, this message translates to:
  /// **'Keine Mai-Doctor-Hub-Sicherung (.maibackup).'**
  String get settingsBackupNotABackup;

  /// No description provided for @settingsBackupRestoreConfirmTitle.
  ///
  /// In de, this message translates to:
  /// **'Sicherung wiederherstellen?'**
  String get settingsBackupRestoreConfirmTitle;

  /// No description provided for @settingsBackupRestoreConfirmText.
  ///
  /// In de, this message translates to:
  /// **'Alle aktuellen Daten und Berichte auf diesem Gerät werden durch die Sicherung ersetzt. Der Kalender-Export muss danach neu eingerichtet werden.'**
  String get settingsBackupRestoreConfirmText;

  /// No description provided for @settingsBackupReplace.
  ///
  /// In de, this message translates to:
  /// **'Ersetzen'**
  String get settingsBackupReplace;

  /// No description provided for @settingsBackupDatePattern.
  ///
  /// In de, this message translates to:
  /// **'d. MMM yyyy'**
  String get settingsBackupDatePattern;

  /// No description provided for @settingsBackupRestored.
  ///
  /// In de, this message translates to:
  /// **'Sicherung vom {date} wiederhergestellt.'**
  String settingsBackupRestored(String date);

  /// No description provided for @settingsBackupRestoredMissing.
  ///
  /// In de, this message translates to:
  /// **'Sicherung vom {date} wiederhergestellt ({missing} Dateien fehlten).'**
  String settingsBackupRestoredMissing(String date, int missing);

  /// No description provided for @settingsDocumentsExportConfirmTitle.
  ///
  /// In de, this message translates to:
  /// **'Dokumente exportieren?'**
  String get settingsDocumentsExportConfirmTitle;

  /// No description provided for @settingsDocumentsExportConfirmText.
  ///
  /// In de, this message translates to:
  /// **'Alle Berichte und Scans werden als ZIP mit lesbaren Dateinamen und einer Übersicht (CSV) geteilt. Das Archiv ist nicht verschlüsselt — nur an vertrauenswürdige Ziele senden.'**
  String get settingsDocumentsExportConfirmText;

  /// No description provided for @settingsDocumentsExportAction.
  ///
  /// In de, this message translates to:
  /// **'Exportieren'**
  String get settingsDocumentsExportAction;

  /// No description provided for @settingsDocumentsExportNone.
  ///
  /// In de, this message translates to:
  /// **'Keine Dokumente zum Exportieren.'**
  String get settingsDocumentsExportNone;

  /// No description provided for @settingsDocumentsShareSubject.
  ///
  /// In de, this message translates to:
  /// **'Mai Doctor Hub — {count} Dokumente'**
  String settingsDocumentsShareSubject(int count);

  /// No description provided for @settingsReindexAllDone.
  ///
  /// In de, this message translates to:
  /// **'Alle Berichte sind bereits durchsuchbar.'**
  String get settingsReindexAllDone;

  /// No description provided for @settingsReindexCount.
  ///
  /// In de, this message translates to:
  /// **'{count} Bericht(e) jetzt durchsuchbar.'**
  String settingsReindexCount(int count);

  /// No description provided for @settingsBackupSection.
  ///
  /// In de, this message translates to:
  /// **'Datensicherung'**
  String get settingsBackupSection;

  /// No description provided for @settingsBackupDescription.
  ///
  /// In de, this message translates to:
  /// **'Verschlüsselte Datei mit allen Daten und Berichten — z. B. für einen Gerätewechsel. Ohne Passwort nicht lesbar.'**
  String get settingsBackupDescription;

  /// No description provided for @settingsBackupCreate.
  ///
  /// In de, this message translates to:
  /// **'Sicherung erstellen'**
  String get settingsBackupCreate;

  /// No description provided for @settingsBackupRestore.
  ///
  /// In de, this message translates to:
  /// **'Sicherung wiederherstellen'**
  String get settingsBackupRestore;

  /// No description provided for @settingsDocumentsExport.
  ///
  /// In de, this message translates to:
  /// **'Dokumente exportieren'**
  String get settingsDocumentsExport;

  /// No description provided for @settingsDocumentsExportSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Alle Berichte & Scans als ZIP mit Übersicht'**
  String get settingsDocumentsExportSubtitle;

  /// No description provided for @settingsDocumentsImport.
  ///
  /// In de, this message translates to:
  /// **'Dokumente importieren'**
  String get settingsDocumentsImport;

  /// No description provided for @settingsDocumentsImportSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Mehrere PDFs oder Bilder auf einmal'**
  String get settingsDocumentsImportSubtitle;

  /// No description provided for @settingsBackupWebUnavailable.
  ///
  /// In de, this message translates to:
  /// **'Im Web nicht verfügbar'**
  String get settingsBackupWebUnavailable;

  /// No description provided for @settingsReindexTitle.
  ///
  /// In de, this message translates to:
  /// **'Berichte durchsuchbar machen'**
  String get settingsReindexTitle;

  /// No description provided for @settingsReindexSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Text aus älteren PDF-Berichten erkennen'**
  String get settingsReindexSubtitle;

  /// No description provided for @settingsPassphraseMinLength.
  ///
  /// In de, this message translates to:
  /// **'Mindestens {count} Zeichen.'**
  String settingsPassphraseMinLength(int count);

  /// No description provided for @settingsPassphraseMismatch.
  ///
  /// In de, this message translates to:
  /// **'Passwörter stimmen nicht überein.'**
  String get settingsPassphraseMismatch;

  /// No description provided for @settingsPassphraseSetTitle.
  ///
  /// In de, this message translates to:
  /// **'Passwort festlegen'**
  String get settingsPassphraseSetTitle;

  /// No description provided for @settingsPassphraseEnterTitle.
  ///
  /// In de, this message translates to:
  /// **'Passwort eingeben'**
  String get settingsPassphraseEnterTitle;

  /// No description provided for @settingsPassphraseLabel.
  ///
  /// In de, this message translates to:
  /// **'Passwort'**
  String get settingsPassphraseLabel;

  /// No description provided for @settingsPassphraseShow.
  ///
  /// In de, this message translates to:
  /// **'Anzeigen'**
  String get settingsPassphraseShow;

  /// No description provided for @settingsPassphraseHide.
  ///
  /// In de, this message translates to:
  /// **'Verbergen'**
  String get settingsPassphraseHide;

  /// No description provided for @settingsPassphraseRepeat.
  ///
  /// In de, this message translates to:
  /// **'Wiederholen'**
  String get settingsPassphraseRepeat;

  /// No description provided for @settingsPassphraseWarning.
  ///
  /// In de, this message translates to:
  /// **'Ohne dieses Passwort lässt sich die Sicherung nicht öffnen — es gibt keine Wiederherstellung.'**
  String get settingsPassphraseWarning;

  /// No description provided for @settingsCalendarNoPermission.
  ///
  /// In de, this message translates to:
  /// **'Ohne Kalenderzugriff kein Export.'**
  String get settingsCalendarNoPermission;

  /// No description provided for @settingsCalendarNoWritable.
  ///
  /// In de, this message translates to:
  /// **'Kein beschreibbarer Kalender auf dem Gerät.'**
  String get settingsCalendarNoWritable;

  /// No description provided for @settingsCalendarStopTitle.
  ///
  /// In de, this message translates to:
  /// **'Kalender-Export beenden'**
  String get settingsCalendarStopTitle;

  /// No description provided for @settingsCalendarStopText.
  ///
  /// In de, this message translates to:
  /// **'Sollen die bereits übertragenen Termine aus dem Kalender entfernt werden?'**
  String get settingsCalendarStopText;

  /// No description provided for @settingsCalendarKeep.
  ///
  /// In de, this message translates to:
  /// **'Behalten'**
  String get settingsCalendarKeep;

  /// No description provided for @settingsCalendarRemove.
  ///
  /// In de, this message translates to:
  /// **'Entfernen'**
  String get settingsCalendarRemove;

  /// No description provided for @settingsCalendarRemovedCount.
  ///
  /// In de, this message translates to:
  /// **'{count} Termin(e) aus dem Kalender entfernt.'**
  String settingsCalendarRemovedCount(int count);

  /// No description provided for @settingsCalendarRemovedResult.
  ///
  /// In de, this message translates to:
  /// **'Kalender entfernt: {result}'**
  String settingsCalendarRemovedResult(String result);

  /// No description provided for @settingsCalendarSyncedCount.
  ///
  /// In de, this message translates to:
  /// **'{count} Termin(e) aus dem Kalender abgeglichen.'**
  String settingsCalendarSyncedCount(int count);

  /// No description provided for @settingsCalendarSyncedResult.
  ///
  /// In de, this message translates to:
  /// **'Kalender abgeglichen: {result}'**
  String settingsCalendarSyncedResult(String result);

  /// No description provided for @settingsCalendarSection.
  ///
  /// In de, this message translates to:
  /// **'Kalender'**
  String get settingsCalendarSection;

  /// No description provided for @settingsCalendarExportTitle.
  ///
  /// In de, this message translates to:
  /// **'Termine in Kalender übertragen'**
  String get settingsCalendarExportTitle;

  /// No description provided for @settingsCalendarExportSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Nur in eine Richtung, z. B. in deinen Google Kalender. Es wird nur „Arzttermin“, Arzt und Ort übertragen — keine Diagnosen oder Notizen.'**
  String get settingsCalendarExportSubtitle;

  /// No description provided for @settingsCalendarAndroidOnly.
  ///
  /// In de, this message translates to:
  /// **'Nur in der Android-App verfügbar.'**
  String get settingsCalendarAndroidOnly;

  /// No description provided for @settingsCalendarTarget.
  ///
  /// In de, this message translates to:
  /// **'Zielkalender'**
  String get settingsCalendarTarget;

  /// No description provided for @settingsCalendarAllowAccess.
  ///
  /// In de, this message translates to:
  /// **'Kalenderzugriff erlauben'**
  String get settingsCalendarAllowAccess;

  /// No description provided for @settingsCalendarIncludeTitle.
  ///
  /// In de, this message translates to:
  /// **'Termintitel mit übertragen'**
  String get settingsCalendarIncludeTitle;

  /// No description provided for @settingsCalendarIncludeTitleSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Aus: „Arzttermin · Dr. …“. An: z. B. „MRT Knie · Dr. …“.'**
  String get settingsCalendarIncludeTitleSubtitle;

  /// No description provided for @settingsCalendarLinkedCount.
  ///
  /// In de, this message translates to:
  /// **'{count} Termin(e) im Kalender'**
  String settingsCalendarLinkedCount(int count);

  /// No description provided for @settingsCalendarLinkedWithErrors.
  ///
  /// In de, this message translates to:
  /// **'{count} Termin(e) im Kalender · {errors} Fehler'**
  String settingsCalendarLinkedWithErrors(int count, int errors);

  /// No description provided for @settingsCalendarLastSynced.
  ///
  /// In de, this message translates to:
  /// **'Zuletzt {date}'**
  String settingsCalendarLastSynced(String date);

  /// No description provided for @settingsCalendarSyncNow.
  ///
  /// In de, this message translates to:
  /// **'Jetzt'**
  String get settingsCalendarSyncNow;

  /// No description provided for @settingsRemindersSection.
  ///
  /// In de, this message translates to:
  /// **'Erinnerungen'**
  String get settingsRemindersSection;

  /// No description provided for @settingsRemindersNew.
  ///
  /// In de, this message translates to:
  /// **'Neu'**
  String get settingsRemindersNew;

  /// No description provided for @settingsRemindersNotificationsOff.
  ///
  /// In de, this message translates to:
  /// **'Benachrichtigungen sind aus'**
  String get settingsRemindersNotificationsOff;

  /// No description provided for @settingsRemindersNotificationsOffText.
  ///
  /// In de, this message translates to:
  /// **'Erinnerungen werden geplant, aber nicht angezeigt.'**
  String get settingsRemindersNotificationsOffText;

  /// No description provided for @settingsRemindersAllow.
  ///
  /// In de, this message translates to:
  /// **'Erlauben'**
  String get settingsRemindersAllow;

  /// No description provided for @settingsRemindersEmpty.
  ///
  /// In de, this message translates to:
  /// **'Keine Erinnerungen — mit „Neu“ anlegen.'**
  String get settingsRemindersEmpty;

  /// No description provided for @settingsRemindersOpenCheckIn.
  ///
  /// In de, this message translates to:
  /// **'Check-in jetzt öffnen'**
  String get settingsRemindersOpenCheckIn;

  /// No description provided for @settingsRemindersAllOpenSymptoms.
  ///
  /// In de, this message translates to:
  /// **'alle offenen Symptome'**
  String get settingsRemindersAllOpenSymptoms;

  /// No description provided for @settingsRemindersPermissionTitle.
  ///
  /// In de, this message translates to:
  /// **'Benachrichtigungen erlauben?'**
  String get settingsRemindersPermissionTitle;

  /// No description provided for @settingsRemindersPermissionText.
  ///
  /// In de, this message translates to:
  /// **'Damit Erinnerungen erscheinen, braucht die App die Erlaubnis für Benachrichtigungen. Sie werden lokal geplant — ohne Server.'**
  String get settingsRemindersPermissionText;

  /// No description provided for @settingsRemindersLater.
  ///
  /// In de, this message translates to:
  /// **'Später'**
  String get settingsRemindersLater;

  /// No description provided for @settingsReminderNewTitle.
  ///
  /// In de, this message translates to:
  /// **'Neue Erinnerung'**
  String get settingsReminderNewTitle;

  /// No description provided for @settingsReminderTitle.
  ///
  /// In de, this message translates to:
  /// **'Erinnerung'**
  String get settingsReminderTitle;

  /// No description provided for @settingsReminderFieldTitle.
  ///
  /// In de, this message translates to:
  /// **'Titel'**
  String get settingsReminderFieldTitle;

  /// No description provided for @settingsReminderFieldBody.
  ///
  /// In de, this message translates to:
  /// **'Text (optional)'**
  String get settingsReminderFieldBody;

  /// No description provided for @settingsReminderTime.
  ///
  /// In de, this message translates to:
  /// **'Uhrzeit'**
  String get settingsReminderTime;

  /// No description provided for @settingsReminderWeekdays.
  ///
  /// In de, this message translates to:
  /// **'Wochentage'**
  String get settingsReminderWeekdays;

  /// No description provided for @settingsReminderSymptomsHint.
  ///
  /// In de, this message translates to:
  /// **'Nur für Symptome (leer = alle offenen)'**
  String get settingsReminderSymptomsHint;

  /// No description provided for @settingsAppointmentRemindersTitle.
  ///
  /// In de, this message translates to:
  /// **'Termin-Erinnerungen'**
  String get settingsAppointmentRemindersTitle;

  /// No description provided for @settingsAppointmentRemindersCalendarTip.
  ///
  /// In de, this message translates to:
  /// **'Tipp: Termine gehen auch in deinen Kalender — ggf. doppelt erinnert. Eines von beiden abschalten.'**
  String get settingsAppointmentRemindersCalendarTip;

  /// No description provided for @settingsAppointmentRemindersSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Benachrichtigung vor Arztterminen. Wer lieber den Google Kalender nutzt, schaltet das aus.'**
  String get settingsAppointmentRemindersSubtitle;

  /// No description provided for @settingsAppointmentRemindersLeadLabel.
  ///
  /// In de, this message translates to:
  /// **'Erinnern vorher'**
  String get settingsAppointmentRemindersLeadLabel;

  /// No description provided for @settingsSecuritySection.
  ///
  /// In de, this message translates to:
  /// **'Sicherheit'**
  String get settingsSecuritySection;

  /// No description provided for @settingsLockTitle.
  ///
  /// In de, this message translates to:
  /// **'App-Sperre'**
  String get settingsLockTitle;

  /// No description provided for @settingsLockSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Beim Öffnen und nach 1 Minute im Hintergrund mit Biometrie oder Geräte-PIN entsperren. Inhalte erscheinen nicht in Screenshots oder der App-Übersicht.'**
  String get settingsLockSubtitle;

  /// No description provided for @settingsLockNoDeviceLock.
  ///
  /// In de, this message translates to:
  /// **'Keine Displaysperre eingerichtet — bitte zuerst in den Geräteeinstellungen PIN oder Biometrie aktivieren.'**
  String get settingsLockNoDeviceLock;

  /// No description provided for @settingsLockLockedTitle.
  ///
  /// In de, this message translates to:
  /// **'Mai Doctor Hub ist gesperrt'**
  String get settingsLockLockedTitle;

  /// No description provided for @settingsLockLockedText.
  ///
  /// In de, this message translates to:
  /// **'Mit Fingerabdruck, Gesicht oder Geräte-PIN entsperren.'**
  String get settingsLockLockedText;

  /// No description provided for @settingsLockUnlock.
  ///
  /// In de, this message translates to:
  /// **'Entsperren'**
  String get settingsLockUnlock;

  /// No description provided for @settingsLockReasonSetup.
  ///
  /// In de, this message translates to:
  /// **'App-Sperre einrichten'**
  String get settingsLockReasonSetup;

  /// No description provided for @settingsLockReasonUnlock.
  ///
  /// In de, this message translates to:
  /// **'Mai Doctor Hub entsperren'**
  String get settingsLockReasonUnlock;

  /// No description provided for @settingsArchiveSnack.
  ///
  /// In de, this message translates to:
  /// **'{label} im Archiv'**
  String settingsArchiveSnack(String label);

  /// No description provided for @settingsArchivePurgeAction.
  ///
  /// In de, this message translates to:
  /// **'Endgültig löschen'**
  String get settingsArchivePurgeAction;

  /// No description provided for @settingsArchivePurgeTitle.
  ///
  /// In de, this message translates to:
  /// **'Endgültig löschen?'**
  String get settingsArchivePurgeTitle;

  /// No description provided for @settingsArchivePurgeText.
  ///
  /// In de, this message translates to:
  /// **'„{title}“ wird unwiderruflich gelöscht (inkl. Dateien).'**
  String settingsArchivePurgeText(String title);

  /// No description provided for @settingsArchivePurgeAllTitle.
  ///
  /// In de, this message translates to:
  /// **'Archiv leeren?'**
  String get settingsArchivePurgeAllTitle;

  /// No description provided for @settingsArchivePurgeAllText.
  ///
  /// In de, this message translates to:
  /// **'Alle archivierten Einträge werden unwiderruflich gelöscht.'**
  String get settingsArchivePurgeAllText;

  /// No description provided for @settingsArchivePurgedCount.
  ///
  /// In de, this message translates to:
  /// **'{count} Einträge endgültig gelöscht'**
  String settingsArchivePurgedCount(int count);

  /// No description provided for @settingsArchiveEmptyAction.
  ///
  /// In de, this message translates to:
  /// **'Leeren'**
  String get settingsArchiveEmptyAction;

  /// No description provided for @settingsArchiveEmpty.
  ///
  /// In de, this message translates to:
  /// **'Das Archiv ist leer. Gelöschte Einträge landen hier und lassen sich wiederherstellen.'**
  String get settingsArchiveEmpty;

  /// No description provided for @settingsArchiveLoading.
  ///
  /// In de, this message translates to:
  /// **'Wird geladen…'**
  String get settingsArchiveLoading;

  /// No description provided for @settingsArchiveItemSubtitle.
  ///
  /// In de, this message translates to:
  /// **'{type} · archiviert {date}'**
  String settingsArchiveItemSubtitle(String type, String date);

  /// No description provided for @settingsOnboardingSkip.
  ///
  /// In de, this message translates to:
  /// **'Überspringen'**
  String get settingsOnboardingSkip;

  /// No description provided for @settingsOnboardingPrivacyTitle.
  ///
  /// In de, this message translates to:
  /// **'Deine Akte bleibt bei dir'**
  String get settingsOnboardingPrivacyTitle;

  /// No description provided for @settingsOnboardingPrivacyText.
  ///
  /// In de, this message translates to:
  /// **'Mai Doctor Hub speichert alles nur auf diesem Gerät. Kein Konto, kein Server. Was das Gerät verlässt — Sicherung, Kalender, Assistent — entscheidest du.'**
  String get settingsOnboardingPrivacyText;

  /// No description provided for @settingsOnboardingAllInOneTitle.
  ///
  /// In de, this message translates to:
  /// **'Alles an einem Ort'**
  String get settingsOnboardingAllInOneTitle;

  /// No description provided for @settingsOnboardingAllInOneText.
  ///
  /// In de, this message translates to:
  /// **'Termine, Ärzte, Diagnosen, Symptome, Medikamente und Arztberichte — durchsuchbar und miteinander verknüpft. Für den nächsten Arztbesuch hast du alles parat.'**
  String get settingsOnboardingAllInOneText;

  /// No description provided for @settingsOnboardingRemindersTitle.
  ///
  /// In de, this message translates to:
  /// **'Erinnerungen'**
  String get settingsOnboardingRemindersTitle;

  /// No description provided for @settingsOnboardingRemindersText.
  ///
  /// In de, this message translates to:
  /// **'Damit wir dich an Check-ins, Termine und Medikamente erinnern können, braucht die App die Erlaubnis für Benachrichtigungen. Sie werden lokal auf dem Gerät geplant — ohne Push-Server. Du kannst das später jederzeit ändern.'**
  String get settingsOnboardingRemindersText;

  /// No description provided for @settingsOnboardingAllowNotifications.
  ///
  /// In de, this message translates to:
  /// **'Benachrichtigungen erlauben'**
  String get settingsOnboardingAllowNotifications;

  /// No description provided for @settingsOnboardingAllowed.
  ///
  /// In de, this message translates to:
  /// **'Erlaubt'**
  String get settingsOnboardingAllowed;

  /// No description provided for @settingsOnboardingDenied.
  ///
  /// In de, this message translates to:
  /// **'Nicht erlaubt — in den Einstellungen der App jederzeit nachholbar.'**
  String get settingsOnboardingDenied;

  /// No description provided for @settingsOnboardingStart.
  ///
  /// In de, this message translates to:
  /// **'Los geht’s'**
  String get settingsOnboardingStart;

  /// No description provided for @settingsShellTabHome.
  ///
  /// In de, this message translates to:
  /// **'Home'**
  String get settingsShellTabHome;

  /// No description provided for @settingsShellTabCalendar.
  ///
  /// In de, this message translates to:
  /// **'Kalender'**
  String get settingsShellTabCalendar;

  /// No description provided for @settingsShellTabRecords.
  ///
  /// In de, this message translates to:
  /// **'Meine Akte'**
  String get settingsShellTabRecords;

  /// No description provided for @settingsShellTabSettings.
  ///
  /// In de, this message translates to:
  /// **'Einstellungen'**
  String get settingsShellTabSettings;

  /// No description provided for @settingsUnreadableTitle.
  ///
  /// In de, this message translates to:
  /// **'Daten nicht lesbar'**
  String get settingsUnreadableTitle;

  /// No description provided for @settingsUnreadableText.
  ///
  /// In de, this message translates to:
  /// **'Die gespeicherten Daten konnten auf diesem Gerät nicht entschlüsselt werden. Die App startet deshalb leer.\n\nMit einer .maibackup-Sicherung lässt sich alles wiederherstellen: Einstellungen → Datensicherung → „Sicherung wiederherstellen“.'**
  String get settingsUnreadableText;

  /// No description provided for @settingsChartEmpty.
  ///
  /// In de, this message translates to:
  /// **'Noch keine Skalenwerte — per Check-in erfassen.'**
  String get settingsChartEmpty;

  /// No description provided for @settingsChartDayPattern.
  ///
  /// In de, this message translates to:
  /// **'d.M.'**
  String get settingsChartDayPattern;

  /// No description provided for @settingsChartDayTimePattern.
  ///
  /// In de, this message translates to:
  /// **'d.M. HH:mm'**
  String get settingsChartDayTimePattern;

  /// No description provided for @settingsChartSemantics.
  ///
  /// In de, this message translates to:
  /// **'Verlauf von {from} bis {to}, zuletzt {value} von 10'**
  String settingsChartSemantics(String from, String to, String value);

  /// No description provided for @settingsSymptomReportNoCheckIns.
  ///
  /// In de, this message translates to:
  /// **'Keine Check-ins in diesem Zeitraum.'**
  String get settingsSymptomReportNoCheckIns;

  /// No description provided for @settingsSymptomReportCount.
  ///
  /// In de, this message translates to:
  /// **'{count} Check-in(s)'**
  String settingsSymptomReportCount(int count);

  /// No description provided for @settingsSymptomReportCountStats.
  ///
  /// In de, this message translates to:
  /// **'{count} Check-in(s) · Ø {avg} · zuletzt {latest}/10'**
  String settingsSymptomReportCountStats(int count, String avg, String latest);

  /// No description provided for @settingsObservationScale.
  ///
  /// In de, this message translates to:
  /// **'Stärke {value}/10'**
  String settingsObservationScale(String value);

  /// No description provided for @settingsObservationColor.
  ///
  /// In de, this message translates to:
  /// **'Farbe {value}'**
  String settingsObservationColor(String value);

  /// No description provided for @settingsNotificationsTitle.
  ///
  /// In de, this message translates to:
  /// **'Benachrichtigungen'**
  String get settingsNotificationsTitle;

  /// No description provided for @settingsNotificationsSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Themen, Wichtigkeit und Sperrbildschirm'**
  String get settingsNotificationsSubtitle;

  /// No description provided for @settingsNotificationsIntro.
  ///
  /// In de, this message translates to:
  /// **'Jedes Thema hat einen eigenen Kanal. Lege fest, was dich laut erreichen soll, was leise reicht und was du gar nicht brauchst.'**
  String get settingsNotificationsIntro;

  /// No description provided for @settingsNotificationLevelImportant.
  ///
  /// In de, this message translates to:
  /// **'Wichtig'**
  String get settingsNotificationLevelImportant;

  /// No description provided for @settingsNotificationLevelNormal.
  ///
  /// In de, this message translates to:
  /// **'Normal'**
  String get settingsNotificationLevelNormal;

  /// No description provided for @settingsNotificationLevelSilent.
  ///
  /// In de, this message translates to:
  /// **'Leise'**
  String get settingsNotificationLevelSilent;

  /// No description provided for @settingsNotificationLevelImportantHint.
  ///
  /// In de, this message translates to:
  /// **'Ton und Banner oben auf dem Bildschirm'**
  String get settingsNotificationLevelImportantHint;

  /// No description provided for @settingsNotificationLevelNormalHint.
  ///
  /// In de, this message translates to:
  /// **'Ton, nur in der Benachrichtigungsleiste'**
  String get settingsNotificationLevelNormalHint;

  /// No description provided for @settingsNotificationLevelSilentHint.
  ///
  /// In de, this message translates to:
  /// **'Ohne Ton, nur in der Benachrichtigungsleiste'**
  String get settingsNotificationLevelSilentHint;

  /// No description provided for @settingsNotificationDiscreet.
  ///
  /// In de, this message translates to:
  /// **'Diskret'**
  String get settingsNotificationDiscreet;

  /// No description provided for @settingsNotificationDiscreetSubtitle.
  ///
  /// In de, this message translates to:
  /// **'Ohne Namen von Medikamenten, Ärzten, Impfungen oder Symptomen – sinnvoll, wenn andere deinen Bildschirm sehen.'**
  String get settingsNotificationDiscreetSubtitle;

  /// No description provided for @settingsNotificationOff.
  ///
  /// In de, this message translates to:
  /// **'Aus'**
  String get settingsNotificationOff;

  /// No description provided for @settingsNotificationSystemHint.
  ///
  /// In de, this message translates to:
  /// **'Feinheiten wie Klingelton oder „Nicht stören“ kannst du zusätzlich in den Android-Einstellungen der App je Kanal anpassen.'**
  String get settingsNotificationSystemHint;

  /// No description provided for @settingsLockReasonDisable.
  ///
  /// In de, this message translates to:
  /// **'App-Sperre ausschalten'**
  String get settingsLockReasonDisable;

  /// No description provided for @settingsKeyUnavailableTitle.
  ///
  /// In de, this message translates to:
  /// **'Daten gerade nicht lesbar'**
  String get settingsKeyUnavailableTitle;

  /// No description provided for @settingsKeyUnavailableText.
  ///
  /// In de, this message translates to:
  /// **'Der Schlüssel deiner Akte ist im Moment nicht verfügbar. Deine Daten sind unverändert – bitte versuche es gleich noch einmal oder starte das Gerät neu.'**
  String get settingsKeyUnavailableText;

  /// No description provided for @svcAssistantTitle.
  ///
  /// In de, this message translates to:
  /// **'Assistent'**
  String get svcAssistantTitle;

  /// No description provided for @svcAssistantExample1.
  ///
  /// In de, this message translates to:
  /// **'Wann ist mein nächster Termin?'**
  String get svcAssistantExample1;

  /// No description provided for @svcAssistantExample2.
  ///
  /// In de, this message translates to:
  /// **'Welche Medikamente nehme ich gerade?'**
  String get svcAssistantExample2;

  /// No description provided for @svcAssistantExample3.
  ///
  /// In de, this message translates to:
  /// **'Wie haben sich meine Symptome entwickelt?'**
  String get svcAssistantExample3;

  /// No description provided for @svcAssistantExample4.
  ///
  /// In de, this message translates to:
  /// **'Was stand im letzten Bericht?'**
  String get svcAssistantExample4;

  /// No description provided for @svcAssistantDeleteModelQuestion.
  ///
  /// In de, this message translates to:
  /// **'Modell löschen?'**
  String get svcAssistantDeleteModelQuestion;

  /// No description provided for @svcAssistantDeleteModelBody.
  ///
  /// In de, this message translates to:
  /// **'Gibt {size} Speicher frei. Für den Assistenten musst du es danach neu herunterladen.'**
  String svcAssistantDeleteModelBody(String size);

  /// No description provided for @svcAssistantDeleteModel.
  ///
  /// In de, this message translates to:
  /// **'Modell löschen'**
  String get svcAssistantDeleteModel;

  /// No description provided for @svcAssistantDeleteSearchModel.
  ///
  /// In de, this message translates to:
  /// **'Suchmodell löschen'**
  String get svcAssistantDeleteSearchModel;

  /// No description provided for @svcAssistantUnsupportedTitle.
  ///
  /// In de, this message translates to:
  /// **'Auf diesem Gerät nicht verfügbar'**
  String get svcAssistantUnsupportedTitle;

  /// No description provided for @svcAssistantAskTitle.
  ///
  /// In de, this message translates to:
  /// **'Frag deine Akte'**
  String get svcAssistantAskTitle;

  /// No description provided for @svcAssistantIntro.
  ///
  /// In de, this message translates to:
  /// **'Antworten entstehen auf diesem Gerät aus deinen Einträgen und Berichten — nichts wird hochgeladen, der Verlauf wird nicht gespeichert.'**
  String get svcAssistantIntro;

  /// No description provided for @svcAssistantDisclaimer.
  ///
  /// In de, this message translates to:
  /// **'Keine ärztliche Beratung — Antworten können Fehler enthalten.'**
  String get svcAssistantDisclaimer;

  /// No description provided for @svcAssistantInputHint.
  ///
  /// In de, this message translates to:
  /// **'Frage zu deiner Akte…'**
  String get svcAssistantInputHint;

  /// No description provided for @svcAssistantSend.
  ///
  /// In de, this message translates to:
  /// **'Fragen'**
  String get svcAssistantSend;

  /// No description provided for @svcAssistantNoAnswer.
  ///
  /// In de, this message translates to:
  /// **'Keine Antwort: {error}'**
  String svcAssistantNoAnswer(String error);

  /// No description provided for @svcAssistantReading.
  ///
  /// In de, this message translates to:
  /// **'Liest deine Akte…'**
  String get svcAssistantReading;

  /// No description provided for @svcAssistantSetupTitle.
  ///
  /// In de, this message translates to:
  /// **'Lokaler Assistent'**
  String get svcAssistantSetupTitle;

  /// No description provided for @svcAssistantSetupBody.
  ///
  /// In de, this message translates to:
  /// **'Stell Fragen zu Terminen, Medikamenten, Symptomen und Berichten. Das KI-Modell {model} läuft vollständig auf diesem Gerät — deine Akte wird nie hochgeladen. Nur das Modell selbst wird einmalig heruntergeladen ({size}, am besten im WLAN).'**
  String svcAssistantSetupBody(String model, String size);

  /// No description provided for @svcAssistantLowMemory.
  ///
  /// In de, this message translates to:
  /// **'Hinweis: Dieses Gerät hat wenig Arbeitsspeicher. Der Assistent kann langsam sein oder von Android beendet werden.'**
  String get svcAssistantLowMemory;

  /// No description provided for @svcAssistantDownloading.
  ///
  /// In de, this message translates to:
  /// **'Wird geladen… {percent} % — läuft auch weiter, wenn du die App verlässt.'**
  String svcAssistantDownloading(int percent);

  /// No description provided for @svcAssistantDownloadModel.
  ///
  /// In de, this message translates to:
  /// **'Modell herunterladen ({size})'**
  String svcAssistantDownloadModel(String size);

  /// No description provided for @svcSemanticTitle.
  ///
  /// In de, this message translates to:
  /// **'Semantische Suche (optional)'**
  String get svcSemanticTitle;

  /// No description provided for @svcSemanticActive.
  ///
  /// In de, this message translates to:
  /// **'Aktiv: Antworten nutzen die besten Treffer per Stichwort und per Bedeutung.'**
  String get svcSemanticActive;

  /// No description provided for @svcSemanticIndexing.
  ///
  /// In de, this message translates to:
  /// **'Akte wird indexiert… {done}/{total}'**
  String svcSemanticIndexing(int done, int total);

  /// No description provided for @svcSemanticDownloading.
  ///
  /// In de, this message translates to:
  /// **'Suchmodell wird geladen… {percent} %'**
  String svcSemanticDownloading(int percent);

  /// No description provided for @svcSemanticIntro.
  ///
  /// In de, this message translates to:
  /// **'Findet auch Einträge, in denen die Wörter deiner Frage nicht vorkommen (z. B. „Schilddrüse“ → TSH-Wert). Lädt {model} ({size}); die Suche läuft danach offline.\n\nGoogle gibt das Modell nur nach Annahme der Gemma-Lizenz frei. Dafür brauchst du einmalig einen kostenlosen Hugging-Face-Token:'**
  String svcSemanticIntro(String model, String size);

  /// No description provided for @svcSemanticTokenLabel.
  ///
  /// In de, this message translates to:
  /// **'Hugging-Face-Token (hf_…)'**
  String get svcSemanticTokenLabel;

  /// No description provided for @svcSemanticStep1.
  ///
  /// In de, this message translates to:
  /// **'Bei Hugging Face ein kostenloses Konto anlegen oder anmelden.'**
  String get svcSemanticStep1;

  /// No description provided for @svcSemanticStep1Link.
  ///
  /// In de, this message translates to:
  /// **'Hugging Face öffnen'**
  String get svcSemanticStep1Link;

  /// No description provided for @svcSemanticStep2.
  ///
  /// In de, this message translates to:
  /// **'Die Modellseite öffnen und „Agree and access repository“ tippen (Googles Gemma-Lizenz). Erscheint dort kein Button, die Lizenz einmal auf Googles Originalseite akzeptieren.'**
  String get svcSemanticStep2;

  /// No description provided for @svcSemanticStep2Link.
  ///
  /// In de, this message translates to:
  /// **'Modellseite öffnen'**
  String get svcSemanticStep2Link;

  /// No description provided for @svcSemanticStep2Google.
  ///
  /// In de, this message translates to:
  /// **'Googles Originalseite'**
  String get svcSemanticStep2Google;

  /// No description provided for @svcSemanticStep3.
  ///
  /// In de, this message translates to:
  /// **'Auf der Token-Seite „Create new token“ tippen, Typ „Read“ wählen, einen Namen vergeben und den Token (beginnt mit hf_) kopieren.'**
  String get svcSemanticStep3;

  /// No description provided for @svcSemanticStep3Link.
  ///
  /// In de, this message translates to:
  /// **'Token-Seite öffnen'**
  String get svcSemanticStep3Link;

  /// No description provided for @svcSemanticStep4.
  ///
  /// In de, this message translates to:
  /// **'Den Token hier einfügen und „Semantische Suche aktivieren“ tippen. Er wird nur für den Download genutzt und nicht gespeichert; danach kannst du ihn auf der Token-Seite wieder löschen.'**
  String get svcSemanticStep4;

  /// No description provided for @svcSemanticLicenseHint.
  ///
  /// In de, this message translates to:
  /// **'Schlägt der Download fehl, ist meist die Lizenz (Schritt 2) noch nicht akzeptiert.'**
  String get svcSemanticLicenseHint;

  /// No description provided for @svcLinkCopied.
  ///
  /// In de, this message translates to:
  /// **'Link konnte nicht geöffnet werden und wurde kopiert: {url}'**
  String svcLinkCopied(String url);

  /// No description provided for @svcSemanticEnable.
  ///
  /// In de, this message translates to:
  /// **'Semantische Suche aktivieren'**
  String get svcSemanticEnable;

  /// No description provided for @svcDownloadFailed.
  ///
  /// In de, this message translates to:
  /// **'Download fehlgeschlagen: {error}'**
  String svcDownloadFailed(String error);

  /// No description provided for @svcSemanticDownloadFailed.
  ///
  /// In de, this message translates to:
  /// **'Download fehlgeschlagen — Token und Lizenz prüfen. ({error})'**
  String svcSemanticDownloadFailed(String error);

  /// No description provided for @svcIndexNotUpdated.
  ///
  /// In de, this message translates to:
  /// **'Index nicht aktualisiert: {error}'**
  String svcIndexNotUpdated(String error);

  /// No description provided for @svcAssistantModelSize.
  ///
  /// In de, this message translates to:
  /// **'ca. 2,6 GB'**
  String get svcAssistantModelSize;

  /// No description provided for @svcEmbedderModelSize.
  ///
  /// In de, this message translates to:
  /// **'ca. 180 MB'**
  String get svcEmbedderModelSize;

  /// No description provided for @svcAssistantAndroidOnly.
  ///
  /// In de, this message translates to:
  /// **'Der Assistent läuft nur auf Android.'**
  String get svcAssistantAndroidOnly;

  /// No description provided for @svcAssistantDeviceCheckFailed.
  ///
  /// In de, this message translates to:
  /// **'Gerät nicht prüfbar: {error}'**
  String svcAssistantDeviceCheckFailed(String error);

  /// No description provided for @svcAssistantNeedsAndroid11.
  ///
  /// In de, this message translates to:
  /// **'Der lokale Assistent braucht mindestens Android 11.'**
  String get svcAssistantNeedsAndroid11;

  /// No description provided for @svcAssistantNeedsArm64.
  ///
  /// In de, this message translates to:
  /// **'Der lokale Assistent braucht einen 64-Bit-ARM-Prozessor.'**
  String get svcAssistantNeedsArm64;

  /// No description provided for @svcContextSystemPrompt.
  ///
  /// In de, this message translates to:
  /// **'Du bist der Assistent der App „Mai Doctor Hub“. Du beantwortest Fragen zur\npersönlichen Gesundheitsakte des Nutzers auf Deutsch, kurz und klar.\nRegeln:\n- Nutze nur die Informationen aus dem Abschnitt AKTE. Steht etwas nicht darin,\n  sag ehrlich, dass es in der Akte nicht vermerkt ist.\n- Übernimm Daten, Uhrzeiten, Dosierungen und Werte exakt.\n- Stelle keine Diagnosen und gib keine Therapie- oder Dosierungsempfehlungen;\n  verweise bei medizinischen Fragen an Arzt, Ärztin oder Apotheke.\n- Bei Warnzeichen für einen Notfall: rate, sofort 112 anzurufen.'**
  String get svcContextSystemPrompt;

  /// No description provided for @svcContextRecordHeading.
  ///
  /// In de, this message translates to:
  /// **'AKTE'**
  String get svcContextRecordHeading;

  /// No description provided for @svcContextQuestionHeading.
  ///
  /// In de, this message translates to:
  /// **'FRAGE'**
  String get svcContextQuestionHeading;

  /// No description provided for @svcContextToday.
  ///
  /// In de, this message translates to:
  /// **'Heute: {date}'**
  String svcContextToday(String date);

  /// No description provided for @svcContextActiveDiagnoses.
  ///
  /// In de, this message translates to:
  /// **'Aktive Diagnosen'**
  String get svcContextActiveDiagnoses;

  /// No description provided for @svcSince.
  ///
  /// In de, this message translates to:
  /// **'seit {date}'**
  String svcSince(String date);

  /// No description provided for @svcCurrentMedications.
  ///
  /// In de, this message translates to:
  /// **'Aktuelle Medikamente'**
  String get svcCurrentMedications;

  /// No description provided for @svcContextOpenSymptoms.
  ///
  /// In de, this message translates to:
  /// **'Offene Symptome (letzte 30 Tage)'**
  String get svcContextOpenSymptoms;

  /// No description provided for @svcContextVaccineOn.
  ///
  /// In de, this message translates to:
  /// **'{vaccine} am {date}'**
  String svcContextVaccineOn(String vaccine, String date);

  /// No description provided for @svcContextDoseNumber.
  ///
  /// In de, this message translates to:
  /// **'{number}. Dosis'**
  String svcContextDoseNumber(int number);

  /// No description provided for @svcContextNextDue.
  ///
  /// In de, this message translates to:
  /// **'nächste fällig {date}'**
  String svcContextNextDue(String date);

  /// No description provided for @svcContextMatchingEntries.
  ///
  /// In de, this message translates to:
  /// **'Passende Einträge zur Frage:'**
  String get svcContextMatchingEntries;

  /// No description provided for @svcContextUpcomingAppointments.
  ///
  /// In de, this message translates to:
  /// **'Nächste Termine'**
  String get svcContextUpcomingAppointments;

  /// No description provided for @svcContextPastAppointments.
  ///
  /// In de, this message translates to:
  /// **'Letzte Termine'**
  String get svcContextPastAppointments;

  /// No description provided for @svcContextCancelled.
  ///
  /// In de, this message translates to:
  /// **'abgesagt'**
  String get svcContextCancelled;

  /// No description provided for @svcContextDiagnosesList.
  ///
  /// In de, this message translates to:
  /// **'Diagnosen: {list}'**
  String svcContextDiagnosesList(String list);

  /// No description provided for @svcContextIntake.
  ///
  /// In de, this message translates to:
  /// **'Einnahme {times}'**
  String svcContextIntake(String times);

  /// No description provided for @svcContextFor.
  ///
  /// In de, this message translates to:
  /// **'gegen {diagnosis}'**
  String svcContextFor(String diagnosis);

  /// No description provided for @svcContextUntil.
  ///
  /// In de, this message translates to:
  /// **'bis {date}'**
  String svcContextUntil(String date);

  /// No description provided for @svcCheckInCount.
  ///
  /// In de, this message translates to:
  /// **'{count} Check-ins'**
  String svcCheckInCount(int count);

  /// No description provided for @svcContextLatest.
  ///
  /// In de, this message translates to:
  /// **'zuletzt {date}: {value}'**
  String svcContextLatest(String date, String value);

  /// No description provided for @svcContextDayPattern.
  ///
  /// In de, this message translates to:
  /// **'dd.MM.yyyy'**
  String get svcContextDayPattern;

  /// No description provided for @svcContextDayTimePattern.
  ///
  /// In de, this message translates to:
  /// **'dd.MM.yyyy HH:mm'**
  String get svcContextDayTimePattern;

  /// No description provided for @svcSummaryPdfTitle.
  ///
  /// In de, this message translates to:
  /// **'Zusammenfassung für den Arztbesuch'**
  String get svcSummaryPdfTitle;

  /// No description provided for @svcSummaryPdfFileName.
  ///
  /// In de, this message translates to:
  /// **'Arztbesuch_{date}.pdf'**
  String svcSummaryPdfFileName(String date);

  /// No description provided for @svcSummaryPdfDatePattern.
  ///
  /// In de, this message translates to:
  /// **'dd.MM.yyyy'**
  String get svcSummaryPdfDatePattern;

  /// No description provided for @svcSummaryPdfDateTimePattern.
  ///
  /// In de, this message translates to:
  /// **'dd.MM. HH:mm'**
  String get svcSummaryPdfDateTimePattern;

  /// No description provided for @svcSummaryPdfFooter.
  ///
  /// In de, this message translates to:
  /// **'Erstellt am {date} mit Mai Doctor Hub · Angaben des Patienten, keine ärztliche Dokumentation'**
  String svcSummaryPdfFooter(String date);

  /// No description provided for @svcSummaryPdfAppointment.
  ///
  /// In de, this message translates to:
  /// **'Termin {date} bei {doctor}'**
  String svcSummaryPdfAppointment(String date, String doctor);

  /// No description provided for @svcSummaryPdfPeriod.
  ///
  /// In de, this message translates to:
  /// **'Zeitraum {from} – {to}'**
  String svcSummaryPdfPeriod(String from, String to);

  /// No description provided for @svcSummaryPdfQuestions.
  ///
  /// In de, this message translates to:
  /// **'Meine Fragen & Anliegen'**
  String get svcSummaryPdfQuestions;

  /// No description provided for @svcSummaryPdfDiagnoses.
  ///
  /// In de, this message translates to:
  /// **'Bekannte Diagnosen'**
  String get svcSummaryPdfDiagnoses;

  /// No description provided for @svcSummaryPdfActive.
  ///
  /// In de, this message translates to:
  /// **'aktiv'**
  String get svcSummaryPdfActive;

  /// No description provided for @svcSummaryPdfResolved.
  ///
  /// In de, this message translates to:
  /// **'abgeklungen'**
  String get svcSummaryPdfResolved;

  /// No description provided for @svcSummaryPdfNoCheckIns.
  ///
  /// In de, this message translates to:
  /// **'Keine Check-ins im Zeitraum.'**
  String get svcSummaryPdfNoCheckIns;

  /// No description provided for @svcSummaryPdfStats.
  ///
  /// In de, this message translates to:
  /// **'Ø {average}/10, min {min}, max {max}, zuletzt {last}'**
  String svcSummaryPdfStats(
    String average,
    String min,
    String max,
    String last,
  );

  /// No description provided for @svcSummaryPdfDate.
  ///
  /// In de, this message translates to:
  /// **'Datum'**
  String get svcSummaryPdfDate;

  /// No description provided for @svcSummaryPdfValue.
  ///
  /// In de, this message translates to:
  /// **'Wert'**
  String get svcSummaryPdfValue;

  /// No description provided for @svcSummaryPdfDose.
  ///
  /// In de, this message translates to:
  /// **'Dosis'**
  String get svcSummaryPdfDose;

  /// No description provided for @svcSummaryPdfIntake.
  ///
  /// In de, this message translates to:
  /// **'Einnahme'**
  String get svcSummaryPdfIntake;

  /// No description provided for @svcSummaryPdfSinceUntil.
  ///
  /// In de, this message translates to:
  /// **'Seit / bis'**
  String get svcSummaryPdfSinceUntil;

  /// No description provided for @svcSummaryPdfProductBatch.
  ///
  /// In de, this message translates to:
  /// **'Impfstoff / Charge'**
  String get svcSummaryPdfProductBatch;

  /// No description provided for @svcSummaryPdfNextDue.
  ///
  /// In de, this message translates to:
  /// **'Nächste'**
  String get svcSummaryPdfNextDue;

  /// No description provided for @svcSummaryPdfDue.
  ///
  /// In de, this message translates to:
  /// **'Fällig: {list}'**
  String svcSummaryPdfDue(String list);

  /// No description provided for @svcSummaryTitle.
  ///
  /// In de, this message translates to:
  /// **'Für den Arztbesuch'**
  String get svcSummaryTitle;

  /// No description provided for @svcSummarySaveDialog.
  ///
  /// In de, this message translates to:
  /// **'Zusammenfassung speichern'**
  String get svcSummarySaveDialog;

  /// No description provided for @svcSummarySaved.
  ///
  /// In de, this message translates to:
  /// **'PDF gespeichert'**
  String get svcSummarySaved;

  /// No description provided for @svcSummaryExportFailed.
  ///
  /// In de, this message translates to:
  /// **'Export fehlgeschlagen: {error}'**
  String svcSummaryExportFailed(String error);

  /// No description provided for @svcSummaryShare.
  ///
  /// In de, this message translates to:
  /// **'PDF teilen'**
  String get svcSummaryShare;

  /// No description provided for @svcSummaryIntro.
  ///
  /// In de, this message translates to:
  /// **'Fragen, Symptom-Verläufe, Medikamente und Impfungen auf einen Blick — als PDF für die Praxis.'**
  String get svcSummaryIntro;

  /// No description provided for @svcSummaryAppointmentDatePattern.
  ///
  /// In de, this message translates to:
  /// **'d. MMM yyyy'**
  String get svcSummaryAppointmentDatePattern;

  /// No description provided for @svcSummaryReference.
  ///
  /// In de, this message translates to:
  /// **'Bezug (bestimmt Zeitraum)'**
  String get svcSummaryReference;

  /// No description provided for @svcSummaryNoAppointment.
  ///
  /// In de, this message translates to:
  /// **'Ohne — letzte 30 Tage'**
  String get svcSummaryNoAppointment;

  /// No description provided for @svcSummaryName.
  ///
  /// In de, this message translates to:
  /// **'Name (optional, steht im PDF)'**
  String get svcSummaryName;

  /// No description provided for @svcSummaryQuestions.
  ///
  /// In de, this message translates to:
  /// **'Fragen & Anliegen'**
  String get svcSummaryQuestions;

  /// No description provided for @svcSummaryQuestionsHint.
  ///
  /// In de, this message translates to:
  /// **'Eine Frage pro Zeile — Notizen zum Termin kommen automatisch dazu'**
  String get svcSummaryQuestionsHint;

  /// No description provided for @svcSummaryAllSymptoms.
  ///
  /// In de, this message translates to:
  /// **'Alle offenen Symptome'**
  String get svcSummaryAllSymptoms;

  /// No description provided for @svcSummaryAllMedications.
  ///
  /// In de, this message translates to:
  /// **'Alle aktuellen Medikamente'**
  String get svcSummaryAllMedications;

  /// No description provided for @svcSummaryMore.
  ///
  /// In de, this message translates to:
  /// **'Weiteres'**
  String get svcSummaryMore;

  /// No description provided for @svcReminderLead15Min.
  ///
  /// In de, this message translates to:
  /// **'15 Min.'**
  String get svcReminderLead15Min;

  /// No description provided for @svcReminderLead1Hour.
  ///
  /// In de, this message translates to:
  /// **'1 Std.'**
  String get svcReminderLead1Hour;

  /// No description provided for @svcReminderLead2Hours.
  ///
  /// In de, this message translates to:
  /// **'2 Std.'**
  String get svcReminderLead2Hours;

  /// No description provided for @svcReminderLead1Day.
  ///
  /// In de, this message translates to:
  /// **'1 Tag'**
  String get svcReminderLead1Day;

  /// No description provided for @svcReminderLead2Days.
  ///
  /// In de, this message translates to:
  /// **'2 Tage'**
  String get svcReminderLead2Days;

  /// No description provided for @svcReminderLead1Week.
  ///
  /// In de, this message translates to:
  /// **'1 Woche'**
  String get svcReminderLead1Week;

  /// No description provided for @svcReminderInMinutes.
  ///
  /// In de, this message translates to:
  /// **'In {minutes} Minuten ({time})'**
  String svcReminderInMinutes(int minutes, String time);

  /// No description provided for @svcReminderInHours.
  ///
  /// In de, this message translates to:
  /// **'{hours, plural, =1{In 1 Stunde ({time})} other{In {hours} Stunden ({time})}}'**
  String svcReminderInHours(int hours, String time);

  /// No description provided for @svcReminderTomorrow.
  ///
  /// In de, this message translates to:
  /// **'Morgen {time}'**
  String svcReminderTomorrow(String time);

  /// No description provided for @svcReminderTimePattern.
  ///
  /// In de, this message translates to:
  /// **'HH:mm'**
  String get svcReminderTimePattern;

  /// No description provided for @svcReminderDayPattern.
  ///
  /// In de, this message translates to:
  /// **'EEE, d.M.'**
  String get svcReminderDayPattern;

  /// No description provided for @svcReminderAppointmentFallback.
  ///
  /// In de, this message translates to:
  /// **'Arzttermin'**
  String get svcReminderAppointmentFallback;

  /// No description provided for @svcReminderMedicationTitle.
  ///
  /// In de, this message translates to:
  /// **'Einnahme: {name}'**
  String svcReminderMedicationTitle(String name);

  /// No description provided for @svcReminderTakeNow.
  ///
  /// In de, this message translates to:
  /// **'Einnehmen'**
  String get svcReminderTakeNow;

  /// No description provided for @svcReminderCheckInDefault.
  ///
  /// In de, this message translates to:
  /// **'Symptome kurz protokollieren.'**
  String get svcReminderCheckInDefault;

  /// No description provided for @svcReminderCheckInSymptoms.
  ///
  /// In de, this message translates to:
  /// **'Check-in: {symptoms}'**
  String svcReminderCheckInSymptoms(String symptoms);

  /// No description provided for @svcChannelCheckIn.
  ///
  /// In de, this message translates to:
  /// **'Symptom-Check-in'**
  String get svcChannelCheckIn;

  /// No description provided for @svcChannelCheckInDescription.
  ///
  /// In de, this message translates to:
  /// **'Erinnerungen für Check-ins'**
  String get svcChannelCheckInDescription;

  /// No description provided for @svcChannelAppointmentDescription.
  ///
  /// In de, this message translates to:
  /// **'Erinnerungen vor Arztterminen'**
  String get svcChannelAppointmentDescription;

  /// No description provided for @svcChannelMedicationDescription.
  ///
  /// In de, this message translates to:
  /// **'Einnahme-Erinnerungen'**
  String get svcChannelMedicationDescription;

  /// No description provided for @svcCalendarEventTitle.
  ///
  /// In de, this message translates to:
  /// **'Arzttermin · {doctor}'**
  String svcCalendarEventTitle(String doctor);

  /// No description provided for @svcCalendarManagedBy.
  ///
  /// In de, this message translates to:
  /// **'Verwaltet von Mai Doctor Hub'**
  String get svcCalendarManagedBy;

  /// No description provided for @svcCalendarNoPermission.
  ///
  /// In de, this message translates to:
  /// **'Kalenderzugriff nicht erlaubt'**
  String get svcCalendarNoPermission;

  /// No description provided for @svcCalendarNoEventId.
  ///
  /// In de, this message translates to:
  /// **'Keine Event-ID erhalten'**
  String get svcCalendarNoEventId;

  /// No description provided for @svcImportPickFailed.
  ///
  /// In de, this message translates to:
  /// **'Dateiauswahl fehlgeschlagen'**
  String get svcImportPickFailed;

  /// No description provided for @svcImportUnsupportedType.
  ///
  /// In de, this message translates to:
  /// **'Dateityp „{ext}“ wird nicht unterstützt (PDF oder Bild).'**
  String svcImportUnsupportedType(String ext);

  /// No description provided for @svcImportFileNotSaved.
  ///
  /// In de, this message translates to:
  /// **'Datei konnte nicht lokal gespeichert werden.'**
  String get svcImportFileNotSaved;

  /// No description provided for @svcImportReportNotSaved.
  ///
  /// In de, this message translates to:
  /// **'Bericht konnte nicht gespeichert werden.'**
  String get svcImportReportNotSaved;

  /// No description provided for @svcExportFileName.
  ///
  /// In de, this message translates to:
  /// **'Mai-Doctor-Hub-Dokumente-{date}.zip'**
  String svcExportFileName(String date);

  /// No description provided for @svcExportOverviewFile.
  ///
  /// In de, this message translates to:
  /// **'Übersicht.csv'**
  String get svcExportOverviewFile;

  /// No description provided for @svcExportCsvHeader.
  ///
  /// In de, this message translates to:
  /// **'Datum;Titel;Arzt;Termin;Quelle;Seiten;Datei'**
  String get svcExportCsvHeader;

  /// No description provided for @svcExportSourceImage.
  ///
  /// In de, this message translates to:
  /// **'Bild'**
  String get svcExportSourceImage;

  /// No description provided for @svcBackupTooNew.
  ///
  /// In de, this message translates to:
  /// **'Sicherung stammt aus einer neueren App-Version — bitte App aktualisieren.'**
  String get svcBackupTooNew;

  /// No description provided for @svcAssistantEmptyAnswer.
  ///
  /// In de, this message translates to:
  /// **'Keine Antwort erhalten. Bitte die Frage kürzer oder genauer stellen.'**
  String get svcAssistantEmptyAnswer;

  /// No description provided for @svcQueryExpansionSystem.
  ///
  /// In de, this message translates to:
  /// **'Du hilfst bei der Suche in einer persönlichen Gesundheitsakte. Antworte nur mit Suchbegriffen, durch Kommas getrennt, ohne weitere Worte.'**
  String get svcQueryExpansionSystem;

  /// No description provided for @svcQueryExpansionPrompt.
  ///
  /// In de, this message translates to:
  /// **'Nenne bis zu 8 Suchbegriffe, mit denen man in Arztberichten, Notizen und Einträgen Antworten auf diese Frage findet: Synonyme, Fachbegriffe, Laienbegriffe, gängige Abkürzungen, Laborwerte oder Medikamentennamen. Frage: {question}'**
  String svcQueryExpansionPrompt(String question);

  /// No description provided for @svcTopicMedication.
  ///
  /// In de, this message translates to:
  /// **'Medikamenteneinnahme'**
  String get svcTopicMedication;

  /// No description provided for @svcTopicAppointmentSoon.
  ///
  /// In de, this message translates to:
  /// **'Termin steht bevor'**
  String get svcTopicAppointmentSoon;

  /// No description provided for @svcTopicAppointmentSoonDescription.
  ///
  /// In de, this message translates to:
  /// **'Erinnerungen kurz vor einem Arzttermin (unter einem Tag)'**
  String get svcTopicAppointmentSoonDescription;

  /// No description provided for @svcTopicAppointmentAhead.
  ///
  /// In de, this message translates to:
  /// **'Termin-Vorschau'**
  String get svcTopicAppointmentAhead;

  /// No description provided for @svcTopicAppointmentAheadDescription.
  ///
  /// In de, this message translates to:
  /// **'Hinweise auf Arzttermine ab einem Tag vorher'**
  String get svcTopicAppointmentAheadDescription;

  /// No description provided for @svcTopicVaccination.
  ///
  /// In de, this message translates to:
  /// **'Impfungen'**
  String get svcTopicVaccination;

  /// No description provided for @svcTopicVaccinationDescription.
  ///
  /// In de, this message translates to:
  /// **'Fällige Auffrischungen'**
  String get svcTopicVaccinationDescription;

  /// No description provided for @svcDiscreetMedicationTitle.
  ///
  /// In de, this message translates to:
  /// **'Zeit für deine Einnahme'**
  String get svcDiscreetMedicationTitle;

  /// No description provided for @svcDiscreetAppointmentTitle.
  ///
  /// In de, this message translates to:
  /// **'Erinnerung an einen Termin'**
  String get svcDiscreetAppointmentTitle;

  /// No description provided for @svcDiscreetVaccinationTitle.
  ///
  /// In de, this message translates to:
  /// **'Eine Impfung ist bald fällig'**
  String get svcDiscreetVaccinationTitle;

  /// No description provided for @svcDiscreetCheckInTitle.
  ///
  /// In de, this message translates to:
  /// **'Zeit für deinen Check-in'**
  String get svcDiscreetCheckInTitle;

  /// No description provided for @svcDiscreetBody.
  ///
  /// In de, this message translates to:
  /// **'Details in Doctor Hub'**
  String get svcDiscreetBody;

  /// No description provided for @svcReminderVaccinationSoon.
  ///
  /// In de, this message translates to:
  /// **'{vaccine}: in einer Woche fällig'**
  String svcReminderVaccinationSoon(String vaccine);

  /// No description provided for @svcReminderVaccinationToday.
  ///
  /// In de, this message translates to:
  /// **'{vaccine}: heute fällig'**
  String svcReminderVaccinationToday(String vaccine);

  /// No description provided for @svcReminderVaccinationBody.
  ///
  /// In de, this message translates to:
  /// **'Termin für die Auffrischung vereinbaren'**
  String get svcReminderVaccinationBody;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
