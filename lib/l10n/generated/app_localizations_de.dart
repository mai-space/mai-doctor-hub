// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get assistantHistoryHeading => 'BISHERIGES GESPRÄCH';

  @override
  String assistantHistoryTurn(String question, String answer) {
    return 'Nutzer: $question\nAssistent: $answer';
  }

  @override
  String get assistantPromptReminder =>
      'Antworte kurz in Markdown. Letzte Zeile: FOLGEFRAGEN: … | … | …';

  @override
  String get assistantFollowUpUnderstandTooltip => 'Verstehen';

  @override
  String get assistantFollowUpActTooltip => 'Handeln';

  @override
  String get assistantFollowUpRelated => 'Was könnte zusammenhängen?';

  @override
  String get assistantFollowUpDevelopment => 'Wie hat sich das entwickelt?';

  @override
  String get assistantFollowUpObserve => 'Was soll ich beobachten?';

  @override
  String get assistantFollowUpAskDoctor => 'Was frage ich die Ärztin?';

  @override
  String get assistantFollowUpWhenDoctor => 'Wann sollte ich zum Arzt?';

  @override
  String assistantFollowUpSymptomCourse(String symptom) {
    return 'Verlauf von $symptom';
  }

  @override
  String assistantFollowUpSymptomRelated(String symptom) {
    return 'Was könnte bei $symptom zusammenhängen?';
  }

  @override
  String assistantFollowUpSymptomDoctor(String symptom) {
    return 'Fragen an die Ärztin zu $symptom';
  }

  @override
  String get assistantOpenLinkTitle => 'Link öffnen?';

  @override
  String assistantOpenLinkBody(String url) {
    return 'Diese Adresse wird außerhalb der App geöffnet:\n$url';
  }

  @override
  String get assistantOpenLink => 'Öffnen';

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
  String get cycleTitle => 'Zyklus';

  @override
  String get cycleSettingsTitle => 'Zyklus & Frauengesundheit';

  @override
  String get cycleSettingsIntro =>
      'Alles optional. Schalte nur ein, was für dich passt — du kannst es jederzeit ändern.';

  @override
  String get cycleTabToday => 'Heute';

  @override
  String get cycleTabCalendar => 'Kalender';

  @override
  String get cycleTabInsights => 'Auswertung';

  @override
  String get cycleOnboardingTitle => 'Zyklus & Frauengesundheit';

  @override
  String get cycleOnboardingText =>
      'Möchtest du deinen Zyklus, die Wechseljahre oder eine Schwangerschaft festhalten? Wähle, was passt — oder überspring den Schritt.';

  @override
  String get cycleModeCycle => 'Periode/Zyklus tracken';

  @override
  String get cycleModeCycleSubtitle =>
      'Blutung, Schmerzen, Symptome; geschätzte nächste Periode';

  @override
  String get cycleModeMenopause => 'Wechseljahre';

  @override
  String get cycleModeMenopauseSubtitle =>
      'Hitzewallungen, Schlaf, monatlicher Fragebogen (MRS)';

  @override
  String get cycleModePregnancy => 'Schwangerschaft';

  @override
  String get cycleModePregnancySubtitle =>
      'SSW, Vorsorge-Zeitplan, Gewicht und Blutdruck; pausiert die Perioden-Schätzung';

  @override
  String get cycleModeNone => 'Nicht für mich';

  @override
  String get cycleModeNoneSubtitle =>
      'Überspringen — später in den Einstellungen möglich';

  @override
  String get cycleCreateGynecologist => 'Gynäkologie als Ärztin/Arzt anlegen';

  @override
  String get cycleCreateGynecologistSubtitle =>
      'Platzhalter, später änderbar — z. B. für Termine und das Arzt-PDF';

  @override
  String get cycleGynecologistPlaceholder =>
      'Meine Gynäkologin/mein Gynäkologe';

  @override
  String get cyclePrivacyNote =>
      'Zyklus- und Schwangerschaftsdaten sind besonders sensibel. Sie bleiben verschlüsselt auf diesem Gerät. Tipp: Schalte unter Einstellungen → Sicherheit die App-Sperre ein.';

  @override
  String get cycleShowFertile => 'Fruchtbares Fenster anzeigen';

  @override
  String get cycleShowFertileSubtitle =>
      'Nur eine grobe Schätzung — keine Verhütungsmethode';

  @override
  String get cycleOpen => 'Zyklus öffnen';

  @override
  String get cycleDeleteAllTitle => 'Alle Zyklusdaten löschen';

  @override
  String get cycleDeleteAllSubtitle =>
      'Tagebuch, Fragebögen und Schwangerschaft';

  @override
  String get cycleDeleteAllText =>
      'Alle Einträge zu Zyklus, Wechseljahren und Schwangerschaft werden endgültig gelöscht und die Bereiche ausgeschaltet. Deine Ärztinnen und Ärzte bleiben erhalten.';

  @override
  String get cycleDeleteAllDone => 'Zyklusdaten gelöscht';

  @override
  String get cycleRecordsSubtitle => 'Kalender, Verlauf und Auswertung';

  @override
  String get cycleToday => 'heute';

  @override
  String get cycleFlowTitle => 'Blutung';

  @override
  String get cycleFlowNone => 'Keine';

  @override
  String get cycleFlowSpotting => 'Schmierblutung';

  @override
  String get cycleFlowLight => 'Leicht';

  @override
  String get cycleFlowMedium => 'Mittel';

  @override
  String get cycleFlowHeavy => 'Stark';

  @override
  String get cycleFlowVeryHeavy => 'Sehr stark';

  @override
  String get cyclePainTitle => 'Schmerz';

  @override
  String get cyclePainNotLogged => 'Nicht erfasst — Regler bewegen';

  @override
  String get cyclePainClear => 'Entfernen';

  @override
  String cyclePainValue(int value) {
    return 'Schmerz $value/10';
  }

  @override
  String get cyclePainLocations => 'Wo?';

  @override
  String get cyclePainkiller => 'Schmerzmittel genommen';

  @override
  String get cyclePainkillerName => 'Welches? (optional)';

  @override
  String get cyclePainkillerHelped => 'Hat es geholfen?';

  @override
  String get cycleNoAnswer => 'Keine Angabe';

  @override
  String get cycleOtherSymptoms => 'Andere';

  @override
  String get cycleOtherHint => 'Eigenes Symptom hinzufügen';

  @override
  String get cycleOtherAdd => 'Hinzufügen';

  @override
  String get cycleDischargeTitle => 'Ausfluss';

  @override
  String get cycleMenopauseTitle => 'Wechseljahre';

  @override
  String get cycleHotFlashes => 'Hitzewallungen heute';

  @override
  String get cycleHotFlashIntensity => 'Wie stark?';

  @override
  String get cycleNightSweats => 'Nachtschweiß';

  @override
  String cycleHotFlashesToday(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Hitzewallungen heute',
      one: '1 Hitzewallung heute',
    );
    return '$_temp0';
  }

  @override
  String get cyclePregnancyTitle => 'Schwangerschaft';

  @override
  String get cycleFetalMovement => 'Kindsbewegungen';

  @override
  String get cycleFetalNotYet => 'Noch nicht spürbar';

  @override
  String get cycleFetalNormal => 'Wie gewohnt';

  @override
  String get cycleFetalLess => 'Weniger als sonst';

  @override
  String get cycleWeight => 'Gewicht';

  @override
  String get cycleBpSystolic => 'Blutdruck oben';

  @override
  String get cycleBpDiastolic => 'unten';

  @override
  String get cycleNoteHint => 'Was dir heute wichtig ist';

  @override
  String get cycleDayTitlePattern => 'EEE, d. MMM yyyy';

  @override
  String get cycleDayPattern => 'EEEE, d. MMMM';

  @override
  String get cycleDatePattern => 'dd.MM.yyyy';

  @override
  String get cycleShortDatePattern => 'd.M.';

  @override
  String get cycleMonthPattern => 'MMMM yyyy';

  @override
  String get cycleDayDeleteTitle => 'Eintrag löschen?';

  @override
  String get cycleDayDeleteText =>
      'Alle Angaben zu diesem Tag werden gelöscht.';

  @override
  String get cyclePbacTitle => 'Blutverlust zählen (PBAC, optional)';

  @override
  String get cyclePbacSubtitle => 'Für ein genaueres Bild bei starker Periode';

  @override
  String get cyclePbacExplain =>
      'PBAC (Higham 1990): Zähle Binden/Tampons nach Füllung, Blutklumpen und Durchbluten. Punkte je Zyklus über 100 sprechen für eine verstärkte Regelblutung — das lohnt sich ärztlich anzuschauen.';

  @override
  String cyclePbacScore(int score) {
    return '$score PBAC-Punkte heute';
  }

  @override
  String cyclePbacPoints(int points) {
    return '$points Punkte je Stück';
  }

  @override
  String get cyclePbacPadsLight => 'Binde, leicht gefüllt';

  @override
  String get cyclePbacPadsMedium => 'Binde, mittel gefüllt';

  @override
  String get cyclePbacPadsFull => 'Binde, voll';

  @override
  String get cyclePbacTamponsLight => 'Tampon, leicht gefüllt';

  @override
  String get cyclePbacTamponsMedium => 'Tampon, mittel gefüllt';

  @override
  String get cyclePbacTamponsFull => 'Tampon, voll';

  @override
  String get cyclePbacClotsSmall => 'Blutklumpen, klein (etwa 1-Cent-Münze)';

  @override
  String get cyclePbacClotsLarge =>
      'Blutklumpen, groß (etwa 2-Euro-Münze oder größer)';

  @override
  String get cyclePbacFlooding => 'Durchgeblutet (Flooding)';

  @override
  String get cycleLess => 'Weniger';

  @override
  String get cycleMore => 'Mehr';

  @override
  String get cyclePhaseMenstruation => 'Periode';

  @override
  String get cyclePhaseFollicular => 'Follikelphase';

  @override
  String get cyclePhaseOvulation => 'Eisprung (ca.)';

  @override
  String get cyclePhaseLuteal => 'Lutealphase';

  @override
  String get cycleStatusNoData =>
      'Noch keine Periode erfasst — trag den ersten Tag ein.';

  @override
  String cycleStatusCycleDay(int day) {
    return 'Zyklustag $day';
  }

  @override
  String cycleStatusPeriodDay(int day) {
    return 'Periode, Tag $day';
  }

  @override
  String cycleStatusNextIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'nächste Periode in ~$days Tagen (geschätzt)',
      one: 'nächste Periode in ~1 Tag (geschätzt)',
    );
    return '$_temp0';
  }

  @override
  String get cycleStatusExpectedNow =>
      'Periode etwa jetzt erwartet (geschätzt)';

  @override
  String get cycleStatusLate => 'Periode später als geschätzt';

  @override
  String get cycleEstimateDisclaimer =>
      'Schätzung aus deinen bisherigen Zyklen — keine Verhütungsmethode und kein Schwangerschaftstest.';

  @override
  String cyclePredictionRange(String from, String to) {
    return 'Nächste Periode etwa $from – $to (geschätzt)';
  }

  @override
  String cycleFertileRange(String from, String to) {
    return 'Fruchtbares Fenster grob geschätzt: $from – $to';
  }

  @override
  String get cycleQuickLogTitle => 'Heute erfassen';

  @override
  String get cycleQuickLogMore => 'Mehr erfassen (Symptome, Ausfluss, Notiz …)';

  @override
  String cycleQuickLogSymptoms(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Symptome erfasst',
      one: '1 Symptom erfasst',
    );
    return '$_temp0';
  }

  @override
  String get cyclePrevMonth => 'Vorheriger Monat';

  @override
  String get cycleNextMonth => 'Nächster Monat';

  @override
  String get cycleCalendarHint =>
      'Tippe auf einen Tag, um ihn zu erfassen oder zu ändern.';

  @override
  String get cycleLegendPeriod => 'Blutung';

  @override
  String get cycleLegendPredicted => 'erwartet (geschätzt)';

  @override
  String get cycleLegendFertile => 'fruchtbar (grob)';

  @override
  String get cycleLegendLogged => 'erfasst';

  @override
  String get cycleInsightsOverview => 'Überblick';

  @override
  String get cycleInsightsNotEnough =>
      'Für Durchschnitt und Schätzung braucht es mindestens zwei erfasste Perioden.';

  @override
  String cycleInsightsAverage(String average, int median, int min, int max) {
    return 'Zykluslänge Ø $average Tage (Median $median, $min–$max)';
  }

  @override
  String cycleInsightsPeriod(String average, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Periode Ø $average Tage · $count Zyklen ausgewertet',
      one: 'Periode Ø $average Tage · 1 Zyklus ausgewertet',
    );
    return '$_temp0';
  }

  @override
  String get cycleInsightsEmpty =>
      'Noch keine Auswertung — erfasse ein paar Tage, dann erscheinen hier Diagramme.';

  @override
  String get cycleChartLengthTitle => 'Zykluslängen';

  @override
  String get cycleChartLengthHelp =>
      'Balken = Zykluslänge, dunkler Anteil = Periode. Grün hinterlegt: 21–35 Tage; gestrichelt: dein Durchschnitt.';

  @override
  String cycleChartLengthSemantics(int count, String values) {
    return 'Zykluslängen der letzten $count Zyklen: $values Tage';
  }

  @override
  String get cycleChartPainTitle => 'Schmerz nach Zyklustag';

  @override
  String get cycleChartPainHelp =>
      'Jede Zeile ein Zyklus, jede Spalte ein Zyklustag. So werden Muster sichtbar, etwa Schmerz kurz vor oder zu Beginn der Periode.';

  @override
  String cycleChartPainSemantics(int count, String days) {
    return 'Schmerz in $count Zyklen; starke Schmerzen an Zyklustag $days';
  }

  @override
  String get cyclePainStripLegend =>
      'Farbe = Schmerz 0–10 · roter Strich = Periode';

  @override
  String get cycleChartPhaseTitle => 'Symptome nach Zyklusphase';

  @override
  String get cycleChartPhaseHelp =>
      'Anteil der erfassten Tage je Phase, an denen das Symptom auftrat. Phasen sind aus deinen Zyklen geschätzt.';

  @override
  String get cycleChartPbacTitle => 'PBAC je Zyklus';

  @override
  String cycleChartPbacSemantics(String values) {
    return 'PBAC-Punkte je Zyklus: $values; Grenze 100';
  }

  @override
  String get cycleChartHotFlashTitle => 'Hitzewallungen je Woche';

  @override
  String cycleChartHotFlashSemantics(String values) {
    return 'Hitzewallungen je Woche, letzte 12 Wochen: $values';
  }

  @override
  String get cycleChartMrsTitle => 'Verlauf Menopause Rating Scale';

  @override
  String cycleChartMrsSemantics(String values) {
    return 'MRS-Gesamtwerte: $values (von 44)';
  }

  @override
  String get cycleChartWeightTitle => 'Gewicht';

  @override
  String cycleChartWeightSemantics(int count, String latest) {
    return 'Gewicht, $count Messungen, zuletzt $latest kg';
  }

  @override
  String get cycleChartBpTitle => 'Blutdruck';

  @override
  String get cycleChartBpHelp =>
      'Werte ab 140/90 mmHg in der Schwangerschaft bitte zeitnah ärztlich besprechen.';

  @override
  String cycleChartBpSemantics(int count) {
    return 'Blutdruck, $count Messungen';
  }

  @override
  String get cycleHintsTitle =>
      'Lohnt sich, mit deiner Gynäkologin/deinem Gynäkologen zu besprechen';

  @override
  String get cycleHintsUrgentTitle => 'Bitte zeitnah ärztlich abklären lassen';

  @override
  String get cycleHintsFooter =>
      'Das ist keine Diagnose — nur ein Hinweis aus deinen Einträgen.';

  @override
  String cycleHintShortCycles(int days) {
    return 'Deine Zyklen waren wiederholt kürzer als 21 Tage (Median $days Tage).';
  }

  @override
  String cycleHintLongCycles(int days) {
    return 'Deine Zyklen waren wiederholt länger als 35 Tage (Median $days Tage).';
  }

  @override
  String cycleHintIrregular(int days) {
    return 'Deine Zykluslängen schwanken um $days Tage (kürzester bis längster).';
  }

  @override
  String cycleHintLongPeriod(int days) {
    return 'Eine Periode dauerte $days Tage (länger als 7 Tage).';
  }

  @override
  String cycleHintHeavyBleeding(int score) {
    return 'PBAC von $score Punkten in einem Zyklus (über 100 spricht für eine verstärkte Blutung).';
  }

  @override
  String cycleHintStrongPain(int days) {
    return 'Starke Schmerzen (7/10 oder mehr) an $days Tagen eines Zyklus.';
  }

  @override
  String get cycleHintPainkiller =>
      'Schmerzmittel haben nicht ausreichend geholfen.';

  @override
  String cycleHintIntermenstrual(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other:
          'Schmierblutung an $days Tagen zwischen den Perioden (letzte 90 Tage).',
      one: 'Schmierblutung an 1 Tag zwischen den Perioden (letzte 90 Tage).',
    );
    return '$_temp0';
  }

  @override
  String get cycleHintPostmenopausal =>
      'Blutung nach mehr als 12 Monaten ohne Periode — bitte ärztlich abklären lassen.';

  @override
  String get cycleHintPregnancyBleeding =>
      'Blutungen in der Schwangerschaft bitte zeitnah ärztlich abklären lassen — oft harmlos, aber wichtig zu wissen.';

  @override
  String get cycleHintFetalMovement =>
      'Spürst du dein Kind weniger als sonst, melde dich bitte zeitnah in deiner Praxis oder im Kreißsaal.';

  @override
  String get cycleMrsTitle => 'Menopause Rating Scale (MRS)';

  @override
  String get cycleMrsIntro =>
      'Welche der folgenden Beschwerden hast du derzeit — und wie stark? Kreuze bitte zu jeder Beschwerde an. Einmal im Monat genügt.';

  @override
  String get cycleMrsExplain =>
      'Ein kurzer, wissenschaftlich geprüfter Fragebogen (11 Fragen) — einmal im Monat zeigt er den Verlauf deiner Beschwerden.';

  @override
  String get cycleMrsFill => 'Fragebogen ausfüllen';

  @override
  String cycleMrsSave(int answered, int total) {
    return 'Speichern ($answered/$total)';
  }

  @override
  String cycleMrsSaved(String summary) {
    return 'Gespeichert: $summary';
  }

  @override
  String get cycleMrsSource =>
      'Menopause Rating Scale nach Heinemann et al. (Health Qual Life Outcomes 2003; 2004). Summe 0–44: 0–4 keine/kaum, 5–8 leicht, 9–16 mittel, ab 17 stark.';

  @override
  String get cycleMrsBands =>
      'Summe 0–44: 0–4 keine/kaum, 5–8 leicht, 9–16 mittel, ab 17 stark.';

  @override
  String get cycleMrsLevel0 => 'keine';

  @override
  String get cycleMrsLevel1 => 'leicht';

  @override
  String get cycleMrsLevel2 => 'mittel';

  @override
  String get cycleMrsLevel3 => 'stark';

  @override
  String get cycleMrsLevel4 => 'sehr stark';

  @override
  String get cycleMrsItem1 =>
      'Wallungen, Schwitzen (aufsteigende Hitze, Schweißausbrüche)';

  @override
  String get cycleMrsItem2 =>
      'Herzbeschwerden (Herzklopfen, Herzrasen, Herzstolpern, Herzbeklemmungen)';

  @override
  String get cycleMrsItem3 =>
      'Schlafstörungen (Einschlafstörungen, Durchschlafstörungen, zu frühes Aufwachen)';

  @override
  String get cycleMrsItem4 =>
      'Depressive Verstimmung (Mutlosigkeit, Traurigkeit, Weinerlichkeit, Antriebslosigkeit, Stimmungsschwankungen)';

  @override
  String get cycleMrsItem5 =>
      'Reizbarkeit (Nervosität, innere Anspannung, Aggressivität)';

  @override
  String get cycleMrsItem6 => 'Ängstlichkeit (innere Unruhe, Panik)';

  @override
  String get cycleMrsItem7 =>
      'Körperliche und geistige Erschöpfung (Leistungsminderung, Gedächtnisminderung, Konzentrationsschwäche, Vergesslichkeit)';

  @override
  String get cycleMrsItem8 =>
      'Sexualprobleme (Veränderung des sexuellen Verlangens, der sexuellen Betätigung und Befriedigung)';

  @override
  String get cycleMrsItem9 =>
      'Harnwegsbeschwerden (Beschwerden beim Wasserlassen, häufiger Harndrang, unwillkürlicher Harnabgang)';

  @override
  String get cycleMrsItem10 =>
      'Trockenheit der Scheide (Trockenheitsgefühl oder Brennen der Scheide, Beschwerden beim Geschlechtsverkehr)';

  @override
  String get cycleMrsItem11 =>
      'Gelenk- und Muskelbeschwerden (Schmerzen im Bereich der Gelenke, rheumaähnliche Beschwerden)';

  @override
  String get cycleMrsSomatic => 'körperlich';

  @override
  String get cycleMrsPsychological => 'psychisch';

  @override
  String get cycleMrsUrogenital => 'urogenital';

  @override
  String get cycleMrsTotalLabel => 'Gesamt';

  @override
  String cycleMrsTotal(int total, String severity) {
    return 'MRS $total ($severity)';
  }

  @override
  String get cycleMrsSeverityNone => 'keine/kaum';

  @override
  String get cycleMrsSeverityMild => 'leicht';

  @override
  String get cycleMrsSeverityModerate => 'mittel';

  @override
  String get cycleMrsSeveritySevere => 'stark';

  @override
  String get cycleMrsNotYet =>
      'Wechseljahre: MRS-Fragebogen noch nicht ausgefüllt';

  @override
  String cycleMrsLatest(int total, String severity, String date) {
    return 'Wechseljahre: MRS $total ($severity) am $date';
  }

  @override
  String get cyclePregnancyNoDates =>
      'Schwangerschaft: trag die letzte Periode oder den errechneten Termin ein.';

  @override
  String cyclePregnancyWeek(String week) {
    return 'SSW $week';
  }

  @override
  String cyclePregnancyTrimester(int trimester) {
    return '$trimester. Trimester';
  }

  @override
  String cyclePregnancyDaysToDue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'noch $days Tage bis zum Termin',
      one: 'noch 1 Tag bis zum Termin',
      zero: 'Termin heute',
    );
    return '$_temp0';
  }

  @override
  String cyclePregnancyDue(String date) {
    return 'Errechneter Termin $date';
  }

  @override
  String get cyclePregnancyDueNote =>
      'Der errechnete Termin ist ein Richtwert — nur wenige Kinder kommen genau an diesem Tag.';

  @override
  String get cyclePregnancyEditDates => 'Termin & letzte Periode';

  @override
  String get cyclePregnancyLmp => 'Erster Tag der letzten Periode';

  @override
  String cyclePregnancyNaegele(String date) {
    return 'Errechnet (Naegele, + 280 Tage): $date';
  }

  @override
  String get cyclePregnancyDueOverride =>
      'Termin laut Ärztin/Arzt/Ultraschall (hat Vorrang)';

  @override
  String get cyclePregnancyTimeline => 'Vorsorge-Zeitplan (Vorschläge)';

  @override
  String get cyclePregnancyTimelineSource =>
      'Nach den Mutterschafts-Richtlinien: Vorsorge alle 4 Wochen, ab SSW 32 alle 2 Wochen; drei Basis-Ultraschalle. Deine Praxis plant individuell.';

  @override
  String cyclePregnancyShowAll(int count) {
    return 'Alle $count anzeigen';
  }

  @override
  String get cyclePregnancyShowLess => 'Weniger anzeigen';

  @override
  String cycleMilestoneCheckup(String weeks) {
    return 'Vorsorge (SSW $weeks)';
  }

  @override
  String cycleMilestoneUltrasound(String weeks) {
    return 'Basis-Ultraschall (SSW $weeks)';
  }

  @override
  String cycleMilestoneAround(String date) {
    return 'ab $date';
  }

  @override
  String get cycleMilestoneCreate => 'Als Termin anlegen';

  @override
  String get cycleMilestoneCreated => 'Termin angelegt';

  @override
  String get cyclePregnancyEnd => 'Schwangerschaft beenden';

  @override
  String get cyclePregnancyEndText =>
      'Die Schwangerschaft wird abgeschlossen und der Bereich ausgeblendet. Deine Einträge bleiben erhalten. Du kannst optional angeben, wie sie geendet hat.';

  @override
  String get cyclePregnancyOutcomeBirth => 'Geburt';

  @override
  String get cyclePregnancyOutcomeLoss => 'Fehlgeburt oder Verlust';

  @override
  String get cyclePregnancyOutcomeNone => 'Möchte ich nicht angeben';

  @override
  String get cyclePregnancyEndConfirm => 'Beenden';

  @override
  String get cyclePregnancyEnded => 'Gespeichert';

  @override
  String get cycleTopic => 'Zyklus & Frauengesundheit';

  @override
  String get cycleTopicDescription =>
      'Erwartete Periode, monatlicher Fragebogen, Vorsorge-Vorschläge — standardmäßig diskret';

  @override
  String get cycleDiscreetTitle => 'Erinnerung';

  @override
  String get cycleReminderSoonTitle =>
      'Periode in etwa 2 Tagen erwartet (geschätzt)';

  @override
  String get cycleReminderTodayTitle =>
      'Periode etwa heute erwartet (geschätzt)';

  @override
  String get cycleReminderBody =>
      'Trag sie im Zyklus-Tagebuch ein, wenn sie beginnt.';

  @override
  String get cycleReminderMrsTitle =>
      'Zeit für deinen monatlichen Wechseljahre-Fragebogen';

  @override
  String cycleReminderMrsBody(int total) {
    return 'Letzter Wert: MRS $total';
  }

  @override
  String get cycleReminderMilestoneBody =>
      'Vorschlag aus dem Vorsorge-Zeitplan — schon einen Termin?';

  @override
  String get cycleSummarySubtitle =>
      'Letzte Zyklen, Durchschnitte, PBAC, Schmerztage, Symptome, Hinweise; ggf. Schwangerschaft und MRS';

  @override
  String cycleReportWeight(String kg, String date) {
    return 'Gewicht zuletzt $kg kg ($date)';
  }

  @override
  String cycleReportBp(int sys, int dia, String date) {
    return 'Blutdruck zuletzt $sys/$dia mmHg ($date)';
  }

  @override
  String cycleReportStats(
    String average,
    int median,
    int min,
    int max,
    int count,
  ) {
    return 'Zykluslänge Ø $average Tage, Median $median ($min–$max), $count Zyklen';
  }

  @override
  String cycleReportPeriodLength(String average) {
    return 'Periodendauer Ø $average Tage';
  }

  @override
  String cycleReportPainDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage mit Schmerzen (letzte 6 Monate)',
      one: '1 Tag mit Schmerzen (letzte 6 Monate)',
    );
    return '$_temp0';
  }

  @override
  String cycleReportTopSymptoms(String symptoms) {
    return 'Häufigste Symptome (Tage): $symptoms';
  }

  @override
  String cycleReportRecentStarts(String dates) {
    return 'Letzte Periodenbeginne: $dates';
  }

  @override
  String get cycleReportStart => 'Beginn';

  @override
  String get cycleReportLength => 'Zyklus (Tage)';

  @override
  String get cycleReportPeriod => 'Periode (Tage)';

  @override
  String get cycleReportStrongPain => 'Tage Schmerz ≥ 7';

  @override
  String get cycleReportRunning => 'läuft';

  @override
  String get cycleReportFooter =>
      'Selbst erfasst in Mai Doctor Hub. Schätzungen und Hinweise sind keine Diagnose.';

  @override
  String get cycleStartTitle => 'Zyklus-Start';

  @override
  String get cycleStartIntro =>
      'Ein paar Angaben, damit die Schätzung deiner nächsten Periode gleich beginnen kann. Alles optional.';

  @override
  String get cycleStartLastQuestion =>
      'Wann hat deine letzte Periode begonnen?';

  @override
  String cycleStartWeeksAgo(int weeks) {
    String _temp0 = intl.Intl.pluralLogic(
      weeks,
      locale: localeName,
      other: 'vor ~$weeks Wochen',
      one: 'vor ~1 Woche',
    );
    return '$_temp0';
  }

  @override
  String get cycleStartPickDate => 'Genaues Datum wählen';

  @override
  String cycleStartChosenDate(String date) {
    return 'Beginn: $date';
  }

  @override
  String get cycleStartDurationQuestion =>
      'Wie lange hat sie ungefähr gedauert?';

  @override
  String cycleStartDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage',
      one: '1 Tag',
    );
    return '$_temp0';
  }

  @override
  String get cycleStartPickEnd => 'Oder: bis wann ging sie?';

  @override
  String cycleStartEndDate(String date) {
    return 'Ende: $date';
  }

  @override
  String get cycleStartDontKnow => 'Weiß ich nicht';

  @override
  String get cycleStartLengthQuestion =>
      'Wie lang ist dein Zyklus normalerweise?';

  @override
  String get cycleStartLengthHelp =>
      'Vom ersten Tag einer Periode bis zum ersten Tag der nächsten.';

  @override
  String get cycleStartIrregular => 'Weiß ich nicht / unregelmäßig';

  @override
  String get cycleStartDecrease => 'Weniger';

  @override
  String get cycleStartIncrease => 'Mehr';

  @override
  String get cycleStartLater => 'Später';

  @override
  String get cycleStartSave => 'Speichern';

  @override
  String get cycleStartCardTitle => 'Wann war deine letzte Periode?';

  @override
  String get cycleStartCardText =>
      'Mit zwei, drei Angaben beginnt die Schätzung deiner nächsten Periode sofort.';

  @override
  String get cycleStartCardAction => 'Angaben machen';

  @override
  String get cycleStartAddLast => 'Letzte Periode nachtragen';

  @override
  String get cycleStartSaved => 'Gespeichert — die Schätzung beginnt jetzt.';

  @override
  String get cycleEstimateFromAnswers =>
      'Geschätzt anhand deiner Angaben, bis genug eigene Zyklen erfasst sind — keine Verhütungsmethode und kein Schwangerschaftstest.';

  @override
  String get cycleEstimateDefaultLength =>
      'Geschätzt mit einem durchschnittlichen 28-Tage-Zyklus (Standardwert), bis eigene Zyklen erfasst sind — keine Verhütungsmethode und kein Schwangerschaftstest.';

  @override
  String measureHistoryEarlier(String measure) {
    return 'Früher erfasst: $measure';
  }

  @override
  String measureHistoryRange(String from, String to, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Check-ins',
      one: '1 Check-in',
    );
    return '$from – $to · $_temp0';
  }

  @override
  String get heatmapMixedNote =>
      'Tage mit früher erfassten Werten sind nach deren eigener Messgröße eingefärbt.';

  @override
  String get measureChangeTitle => 'Messgröße ändern?';

  @override
  String measureChangeBody(String measures, String next) {
    return 'Bisherige Check-ins ($measures) bleiben unverändert erhalten und werden im Verlauf getrennt angezeigt. Neue Check-ins werden als „$next“ erfasst.';
  }

  @override
  String get measureChangeKeep => 'Ändern';

  @override
  String get measureChangeConvert => 'Ändern und umrechnen';

  @override
  String get searchJournalEntry => 'Tagebuch-Eintrag';

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
  String get measureIntensity => 'Stärke 0–10';

  @override
  String get measureTemperature => 'Temperatur';

  @override
  String get measureCount => 'Anzahl';

  @override
  String get measureDuration => 'Dauer';

  @override
  String get measurePulse => 'Puls';

  @override
  String get measureBloodPressure => 'Blutdruck';

  @override
  String get measureSpo2 => 'Sauerstoffsättigung (SpO₂)';

  @override
  String get measureGlucose => 'Blutzucker';

  @override
  String get measureWeight => 'Gewicht';

  @override
  String get measureMood => 'Stimmung −5 bis +5';

  @override
  String get measureMoodShort => 'Stimmung';

  @override
  String get measureUnitPulse => '/min';

  @override
  String get measureTempNormal => 'normal';

  @override
  String get measureTempElevated => 'erhöht';

  @override
  String get measureTempFever => 'Fieber';

  @override
  String get measureTempHighFever => 'hohes Fieber';

  @override
  String get measureBpOptimal => 'optimal';

  @override
  String get measureBpNormal => 'normal';

  @override
  String get measureBpHighNormal => 'hoch-normal';

  @override
  String get measureBpGrade1 => 'Hypertonie Grad 1';

  @override
  String get measureBpGrade2 => 'Hypertonie Grad 2';

  @override
  String get measureBpGrade3 => 'Hypertonie Grad 3';

  @override
  String get measureSpo2Normal => 'normal';

  @override
  String get measureSpo2Low => 'leicht erniedrigt';

  @override
  String get measureSpo2Check => 'ärztlich abklären';

  @override
  String get measureSpo2Urgent => 'zeitnah ärztlich abklären';

  @override
  String get measureSpo2HintCheck =>
      'Unter 92 %: bitte ärztlich abklären lassen, besonders bei Atemnot.';

  @override
  String get measureSpo2HintUrgent =>
      'Unter 90 %: bitte zeitnah ärztlich abklären. Bei starker Atemnot, Verwirrtheit oder blauen Lippen den Notruf wählen.';

  @override
  String get measureGlucoseVeryLow => 'sehr niedrig';

  @override
  String get measureGlucoseLow => 'niedrig';

  @override
  String get measureGlucoseInRange => 'im Zielbereich';

  @override
  String get measureGlucoseHigh => 'erhöht';

  @override
  String get measureGlucoseVeryHigh => 'sehr hoch';

  @override
  String get measurePulseLow => 'niedrig';

  @override
  String get measurePulseNormal => 'normal (Ruhe)';

  @override
  String get measurePulseHigh => 'erhöht';

  @override
  String get moodM5 => 'schwer depressiv';

  @override
  String get moodM4 => 'stark gedrückt';

  @override
  String get moodM3 => 'deutlich gedrückt';

  @override
  String get moodM2 => 'gedrückt';

  @override
  String get moodM1 => 'leicht gedrückt';

  @override
  String get mood0 => 'ausgeglichen';

  @override
  String get moodP1 => 'leicht gehoben';

  @override
  String get moodP2 => 'gehoben';

  @override
  String get moodP3 => 'deutlich gehoben';

  @override
  String get moodP4 => 'stark gehoben';

  @override
  String get moodP5 => 'manisch';

  @override
  String get moodAnchor0 => 'Weder gedrückt noch aufgedreht';

  @override
  String get moodAnchorMild => 'Spürbar, Alltag aber gut machbar';

  @override
  String get moodAnchorModerate =>
      'Alltag (Arbeit, Familie) nur mit deutlicher Mühe';

  @override
  String get moodAnchorSevere => 'Alltag kaum noch möglich';

  @override
  String get moodScaleLow => '−5 schwer depressiv';

  @override
  String get moodScaleHigh => '+5 manisch';

  @override
  String get moodExtras => 'Energie, Schlaf, Angst';

  @override
  String get moodEnergy => 'Energie';

  @override
  String get moodSleep => 'Schlaf (Stunden)';

  @override
  String get moodAnxiety => 'Angst/Anspannung';

  @override
  String moodEnergyValue(String value) {
    return 'Energie $value/10';
  }

  @override
  String moodSleepValue(String value) {
    return 'Schlaf $value h';
  }

  @override
  String moodAnxietyValue(String value) {
    return 'Angst $value/10';
  }

  @override
  String get measureHowTitle => 'Wie messen?';

  @override
  String get measureHowHint =>
      'Vorschlag aus dem Namen – tippe, um es zu ändern.';

  @override
  String get measureSecondary => 'Zusätzlich erfassen';

  @override
  String get measureSecondaryNone => 'nichts weiter';

  @override
  String get symptomBlocksHint =>
      'Tippe Bausteine an – daraus entsteht der Name. Du kannst ihn danach frei ändern.';

  @override
  String get symptomTitleRegenerate => 'Aus Bausteinen neu erzeugen';

  @override
  String get checkInDetails => 'Details ändern';

  @override
  String get checkInHintMeasure =>
      'Erfasse den aktuellen Wert. Beschreibung und Ort kommen aus dem Symptom – „Details ändern“ passt sie für diesen Check-in an.';

  @override
  String get measureCountHint => 'Wie oft seit dem letzten Check-in?';

  @override
  String get measureDurationHint => 'Wie lange insgesamt?';

  @override
  String get measureBpSystolic => 'Systolisch';

  @override
  String get measureBpDiastolic => 'Diastolisch';

  @override
  String measureAdd(String measure) {
    return '$measure ergänzen';
  }

  @override
  String get measureRemove => 'Entfernen';

  @override
  String get measureDecrease => 'Weniger';

  @override
  String get measureIncrease => 'Mehr';

  @override
  String measureFeverLine(String value) {
    return 'Fieber ab $value';
  }

  @override
  String measureReferenceLine(String value) {
    return 'Grenze $value';
  }

  @override
  String measureChartSemantics(String measure, int count, String latest) {
    return '$measure: $count Werte, zuletzt $latest';
  }

  @override
  String measureStats(String average, String min, String max, String last) {
    return 'Ø $average · min $min · max $max · zuletzt $last';
  }

  @override
  String measureStatsCount(int count, String stats) {
    return '$count Check-in(s) · $stats';
  }

  @override
  String get measureTotalPerDay => 'Summe pro Tag';

  @override
  String heatmapCellMeasure(String date, String value) {
    return '$date: $value';
  }

  @override
  String heatmapSemanticsMeasure(String measure, int days) {
    return 'Kalender ($measure): $days Tage mit Check-in';
  }

  @override
  String get severityNone => 'unauffällig';

  @override
  String get severityMild => 'leicht';

  @override
  String get severityModerate => 'mittel';

  @override
  String get severitySevere => 'deutlich';

  @override
  String get severityMax => 'sehr deutlich';

  @override
  String heatmapMapTemperature(
    String elevated,
    String fever,
    String high,
    String max,
  ) {
    return 'Farbe nach Temperatur: erhöht ab $elevated, Fieber ab $fever, hohes Fieber ab $high, dunkelste Stufe ab $max.';
  }

  @override
  String heatmapMapRelative(String max) {
    return 'Farbe relativ zum höchsten Tageswert ($max).';
  }

  @override
  String get heatmapMapBloodPressure =>
      'Farbe nach ESC/ESH-Stufe: hoch-normal, Hypertonie Grad 1, 2, 3.';

  @override
  String get heatmapMapSpo2 =>
      'Farbe nach Sättigung: unter 95 %, 92 %, 90 %, 85 % (niedrigster Wert des Tages).';

  @override
  String heatmapMapGlucose(String low, String high) {
    return 'Farbe: außerhalb des Zielbereichs $low–$high; sehr niedrig am dunkelsten.';
  }

  @override
  String get heatmapMapPulse => 'Farbe: Abstand vom Ruhepuls 60–100/min.';

  @override
  String get heatmapMapMood =>
      'Farbe: Abstand von „ausgeglichen“ (0) – die Richtung zeigt das Stimmungsdiagramm.';

  @override
  String get heatmapMapWeight => 'Farbe: Tage mit Messung.';

  @override
  String get journalTitle => 'Tagebuch';

  @override
  String get journalAdd => 'Tagebuch-Eintrag';

  @override
  String get journalHint => 'Was beschäftigt dich? (optional)';

  @override
  String get journalPromptHelped => 'Was hat heute geholfen?';

  @override
  String get journalPromptBurden => 'Was hat mich belastet?';

  @override
  String get journalPromptGrateful => 'Wofür bin ich dankbar?';

  @override
  String get journalPrivacy =>
      'Bleibt auf dem Gerät. Ins Arzt-PDF nur, wenn du es dort einschaltest.';

  @override
  String get journalEmpty => 'Noch keine Tagebuch-Einträge.';

  @override
  String get journalChartHint =>
      'Punkte über dem Diagramm = Tagebuch-Eintrag. Antippen zum Lesen.';

  @override
  String journalContext(String date, String text) {
    return 'Tagebuch $date: $text';
  }

  @override
  String get summaryIncludeJournal => 'Tagebuch-Einträge einschließen';

  @override
  String get summaryIncludeJournalSubtitle =>
      'Standardmäßig aus – persönliche Notizen bleiben privat.';

  @override
  String get unitsTitle => 'Einheiten';

  @override
  String get unitsIntro =>
      'Gespeichert wird immer gleich – umgerechnet wird nur die Anzeige. Standard nach Region des Geräts.';

  @override
  String get unitsTemperature => 'Temperatur';

  @override
  String get unitsGlucose => 'Blutzucker';

  @override
  String get unitsWeight => 'Gewicht';

  @override
  String cycleReportWeightValue(String value, String date) {
    return 'Gewicht zuletzt $value ($date)';
  }

  @override
  String cycleChartWeightSemanticsValue(int count, String latest) {
    return 'Gewicht, $count Messungen, zuletzt $latest';
  }

  @override
  String get mediaSectionTitle => 'Belege';

  @override
  String get mediaSectionHint =>
      'Fotos, Videos oder Sprachnotizen zeigen der Ärztin oder dem Arzt, was du beschreibst – z. B. einen Ausschlag, eine Schwellung, ein Geräusch beim Atmen oder einen Anfall. Alles bleibt verschlüsselt auf diesem Gerät.';

  @override
  String get mediaTakePhoto => 'Foto';

  @override
  String get mediaRecordVideo => 'Video';

  @override
  String get mediaRecordAudio => 'Sprachnotiz';

  @override
  String get mediaFromGallery => 'Aus Galerie';

  @override
  String get mediaGalleryPhoto => 'Foto aus Galerie';

  @override
  String get mediaGalleryVideo => 'Video aus Galerie';

  @override
  String get mediaPhoto => 'Foto';

  @override
  String get mediaVideo => 'Video';

  @override
  String get mediaAudio => 'Sprachnotiz';

  @override
  String get mediaEmpty => 'Noch keine Belege.';

  @override
  String get mediaSaving => 'Beleg wird verschlüsselt gespeichert…';

  @override
  String get mediaSaved => 'Beleg gespeichert.';

  @override
  String mediaFailed(String error) {
    return 'Beleg konnte nicht gespeichert werden: $error';
  }

  @override
  String get mediaDeleteTitle => 'Beleg löschen?';

  @override
  String get mediaDeleteText =>
      'Die Datei wird endgültig von diesem Gerät entfernt.';

  @override
  String get mediaNoteLabel => 'Notiz zum Beleg (optional)';

  @override
  String get mediaRecordingTitle => 'Sprachnotiz aufnehmen';

  @override
  String get mediaRecordingHint =>
      'Beschreibe in Ruhe, was du spürst – oder nimm ein Geräusch auf (Husten, Atmen, Herzklopfen).';

  @override
  String get mediaRecordingStop => 'Stopp & speichern';

  @override
  String get mediaMicDenied =>
      'Ohne Mikrofon-Berechtigung keine Sprachnotiz. Du kannst sie in den Android-Einstellungen der App erlauben.';

  @override
  String get mediaUnavailable => 'Datei nicht verfügbar.';

  @override
  String mediaCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Belege',
      one: '1 Beleg',
    );
    return '$_temp0';
  }

  @override
  String get mediaDatePattern => 'd. MMM yyyy, HH:mm';

  @override
  String svcSummaryPdfEvidence(int photos, int videos, int audio) {
    return 'Belege: $photos Fotos, $videos Videos, $audio Sprachnotizen (in der App)';
  }

  @override
  String get psychTitle => 'Psyche';

  @override
  String get psychIntro =>
      'Kurze, anerkannte Fragebögen zeigen, wie es dir über die Wochen geht. Das Ergebnis ist keine Diagnose – sprich mit deiner Ärztin oder deinem Arzt darüber.';

  @override
  String get psychSettingsSubtitle =>
      'Stimmung, Angst und Tagebuch – mit PHQ-9 und GAD-7 als monatlichem Fragebogen.';

  @override
  String get psychQuestionnairesToggle =>
      'Monatliche Fragebögen (PHQ-9, GAD-7)';

  @override
  String get psychQuestionnairesSubtitle =>
      'Erinnerung 30 Tage nach dem letzten Bogen; Verlauf auf der Seite „Psyche“.';

  @override
  String get psychOpen => 'Psyche öffnen';

  @override
  String get psychAreaLink => 'Psyche: Fragebögen & Verlauf';

  @override
  String get psychPhq9Title => 'PHQ-9 (Depression)';

  @override
  String get psychGad7Title => 'GAD-7 (Angst)';

  @override
  String get psychQuestion =>
      'Wie oft fühlten Sie sich im Verlauf der letzten 2 Wochen durch die folgenden Beschwerden beeinträchtigt?';

  @override
  String get psychPhq1 => 'Wenig Interesse oder Freude an Ihren Tätigkeiten';

  @override
  String get psychPhq2 =>
      'Niedergeschlagenheit, Schwermut oder Hoffnungslosigkeit';

  @override
  String get psychPhq3 =>
      'Schwierigkeiten ein- oder durchzuschlafen oder vermehrter Schlaf';

  @override
  String get psychPhq4 => 'Müdigkeit oder Gefühl, keine Energie zu haben';

  @override
  String get psychPhq5 =>
      'Verminderter Appetit oder übermäßiges Bedürfnis zu essen';

  @override
  String get psychPhq6 =>
      'Schlechte Meinung von sich selbst; Gefühl, ein Versager zu sein oder die Familie enttäuscht zu haben';

  @override
  String get psychPhq7 =>
      'Schwierigkeiten, sich auf etwas zu konzentrieren, z. B. beim Zeitunglesen oder Fernsehen';

  @override
  String get psychPhq8 =>
      'Waren Ihre Bewegungen oder Ihre Sprache so verlangsamt, dass es auch anderen auffallen würde? Oder waren Sie im Gegenteil „zappelig“ oder ruhelos und hatten dadurch einen stärkeren Bewegungsdrang als sonst?';

  @override
  String get psychPhq9 =>
      'Gedanken, dass Sie lieber tot wären oder sich Leid zufügen möchten';

  @override
  String get psychGad1 => 'Nervosität, Ängstlichkeit oder Anspannung';

  @override
  String get psychGad2 =>
      'Nicht in der Lage sein, Sorgen zu stoppen oder zu kontrollieren';

  @override
  String get psychGad3 =>
      'Übermäßige Sorgen bezüglich verschiedener Angelegenheiten';

  @override
  String get psychGad4 => 'Schwierigkeiten zu entspannen';

  @override
  String get psychGad5 => 'Rastlosigkeit, so dass Stillsitzen schwer fällt';

  @override
  String get psychGad6 => 'Schnelle Verärgerung oder Gereiztheit';

  @override
  String get psychGad7 =>
      'Gefühl der Angst, so als würde etwas Schlimmes passieren';

  @override
  String get psychAnswer0 => 'Überhaupt nicht';

  @override
  String get psychAnswer1 => 'An einzelnen Tagen';

  @override
  String get psychAnswer2 => 'An mehr als der Hälfte der Tage';

  @override
  String get psychAnswer3 => 'Beinahe jeden Tag';

  @override
  String get psychSeverityMinimal => 'minimal';

  @override
  String get psychSeverityMild => 'leicht';

  @override
  String get psychSeverityModerate => 'mittelgradig';

  @override
  String get psychSeverityModeratelySevere => 'ausgeprägt';

  @override
  String get psychSeveritySevere => 'schwer';

  @override
  String psychResultSummary(
    String instrument,
    int total,
    int max,
    String severity,
  ) {
    return '$instrument: $total von $max – $severity';
  }

  @override
  String psychSave(int answered, int count) {
    return 'Speichern ($answered/$count)';
  }

  @override
  String psychSaved(String summary) {
    return 'Gespeichert: $summary';
  }

  @override
  String psychFill(String instrument) {
    return '$instrument ausfüllen';
  }

  @override
  String get psychTrend => 'Verlauf';

  @override
  String get psychNoResults => 'Noch keine Fragebögen ausgefüllt.';

  @override
  String get psychBands =>
      'PHQ-9: 0–4 minimal · 5–9 leicht · 10–14 mittelgradig · 15–19 ausgeprägt · 20–27 schwer. GAD-7: 0–4 minimal · 5–9 leicht · 10–14 mittelgradig · 15–21 schwer.';

  @override
  String get psychSource =>
      'PHQ-9 (Kroenke et al. 2001) und GAD-7 (Spitzer et al. 2006), deutsche Fassung PHQ-D (Löwe et al.). Frei verwendbar; kein Ersatz für eine ärztliche Diagnose.';

  @override
  String get psychSupportTitle => 'Du musst das nicht allein tragen';

  @override
  String get psychSupportText =>
      'Wenn du gerade daran denkst, dir etwas anzutun, sprich mit jemandem. Diese Stellen sind rund um die Uhr für dich da – anonym und kostenlos:';

  @override
  String get psychSupportGeneric =>
      'Wende dich an eine Krisen-Hotline in deinem Land oder an den örtlichen Notruf. Auch Ärztinnen, Ärzte und Menschen, denen du vertraust, helfen.';

  @override
  String psychSupportEmergency(String number) {
    return 'Bei akuter Gefahr: Notruf $number';
  }

  @override
  String get psychSupportPrivacy =>
      'Dieser Hinweis erscheint nur auf deinem Gerät. Es wird nichts gesendet.';

  @override
  String psychSupportCall(String name, String number) {
    return '$name: $number';
  }

  @override
  String get psychTopic => 'Stimmung & Psyche';

  @override
  String get psychTopicDescription =>
      'Check-ins zu psychischen Symptomen und monatliche Fragebögen';

  @override
  String get psychDiscreetTitle => 'Kurz innehalten';

  @override
  String get psychReminderTitle => 'Fragebogen zur Psyche';

  @override
  String get psychReminderBody =>
      'Ein Monat ist um – zwei Minuten für PHQ-9 und GAD-7?';

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
      'Den Token hier einfügen und „Semantische Suche aktivieren“ tippen. Er wird nur für den Download genutzt und nicht gespeichert; danach kannst du ihn auf der Token-Seite wieder löschen.';

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
      'Du bist der Assistent der App „Mai Doctor Hub“. Du hilfst ruhig und sachlich, die eigene Gesundheitsakte zu verstehen. Antworte auf Deutsch in Markdown, höchstens etwa 180 Wörter.\nRegeln:\n- Stütze dich auf den Abschnitt AKTE. Steht etwas nicht darin, sag ehrlich, dass es in der Akte nicht vermerkt ist.\n- Übernimm Daten, Uhrzeiten, Dosierungen und Werte exakt.\n- Stelle keine Diagnosen und gib keine Therapie- oder Dosierungsempfehlungen. Nenne Möglichkeiten („könnte“, „häufig steckt … dahinter“), nie Gewissheiten.\n- Bei Warnzeichen für einen Notfall: rate, sofort 112 anzurufen.\nBei Beschwerden oder Symptomen antworte immer in zwei Richtungen zugleich, je 2–4 kurze Punkte:\n**Mögliche Zusammenhänge**\n- Was in der Akte dazu passen könnte: zeitlich passende (neue) Medikamente, Zyklusphase, Schlaf und Stimmung, andere Symptome, letzte Termine oder Befunde.\n- Häufige allgemeine Ursachen, neutral formuliert.\n**Was du tun kannst**\n- Was du in der App beobachten oder notieren kannst.\n- Fragen an die Ärztin oder den Arzt.\n- Einfache Selbstfürsorge.\n- Wann du zeitnah ärztlichen Rat brauchst und wann sofort 112.\nBei anderen Fragen (Termine, Medikamente, Befunde) antworte direkt und knapp.\nLetzte Zeile jeder Antwort: FOLGEFRAGEN: Frage 1 | Frage 2 | Frage 3\nKurze Fragen aus Sicht des Nutzers — mindestens eine zum Verstehen, eine zum Handeln.';

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

  @override
  String get svcModelIntegrityFailed =>
      'Der Download war unvollständig oder entsprach nicht der geprüften Version und wurde verworfen. Bitte erneut versuchen.';

  @override
  String get symptomCheckInHint =>
      'Beschreibe, was du spürst: Art, Charakter, Ort und Stärke (0–10). Tippe auf einen Baustein, um ihn zu ändern.';

  @override
  String get symptomSensation => 'Empfindung';

  @override
  String get symptomQuality => 'Charakter';

  @override
  String get symptomLocation => 'Ort';

  @override
  String get symptomSide => 'Seite';

  @override
  String get symptomPattern => 'Verlauf';

  @override
  String get symptomIntensity => 'Stärke';

  @override
  String get symptomSideLeft => 'links';

  @override
  String get symptomSideRight => 'rechts';

  @override
  String get symptomSideBoth => 'beidseits';

  @override
  String get symptomSideCenter => 'mittig';

  @override
  String get symptomSideNone => 'keine Angabe';

  @override
  String symptomLocationSide(String location, String side) {
    return '$location ($side)';
  }

  @override
  String symptomIntensityValue(String value, String band) {
    return '$value/10 $band';
  }

  @override
  String get symptomBandNone => 'keine';

  @override
  String get symptomBandMild => 'leicht';

  @override
  String get symptomBandModerate => 'mittel';

  @override
  String get symptomBandSevere => 'stark';

  @override
  String get symptomBandUnbearable => 'unerträglich';

  @override
  String get symptomAnchor0 => 'Nicht vorhanden';

  @override
  String get symptomAnchor1 => 'Kaum bemerkbar';

  @override
  String get symptomAnchor2 => 'Bemerkbar, stört nicht';

  @override
  String get symptomAnchor3 => 'Stört gelegentlich, leicht zu ignorieren';

  @override
  String get symptomAnchor4 => 'Lenkt ab, Alltag aber normal möglich';

  @override
  String get symptomAnchor5 => 'Deutlich störend, schwer zu ignorieren';

  @override
  String get symptomAnchor6 => 'Konzentration fällt schwer';

  @override
  String get symptomAnchor7 => 'Schränkt den Alltag ein (Arbeit, Schlaf)';

  @override
  String get symptomAnchor8 => 'Kaum etwas anderes möglich';

  @override
  String get symptomAnchor9 => 'Kaum auszuhalten';

  @override
  String get symptomAnchor10 => 'Schlimmste vorstellbare Stärke';

  @override
  String get symptomPickerSearchHint => 'Suchen oder eigenen Begriff eingeben';

  @override
  String symptomPickerUseCustom(String value) {
    return '„$value“ übernehmen';
  }

  @override
  String get symptomPickerReflect =>
      'Zum Reflektieren: Was trifft es am besten?';

  @override
  String get symptomPickerMultiHint => 'Mehrere möglich';

  @override
  String get symptomPickerApply => 'Übernehmen';

  @override
  String get symptomPickerClear => 'Entfernen';

  @override
  String get symptomDefaultsTitle => 'Typische Beschreibung';

  @override
  String get symptomDefaultsHint =>
      'Wird bei jedem Check-in vorbelegt und kann dort angepasst werden.';

  @override
  String get symptomLatestDescription => 'Zuletzt beschrieben';

  @override
  String get symptomHeatmapTitle => 'Kalender';

  @override
  String get symptomHeatmapHint =>
      'Farbe = höchste Stärke des Tages. Tippe auf einen Tag für Details.';

  @override
  String symptomHeatmapCell(String date, String value) {
    return '$date: $value/10';
  }

  @override
  String symptomHeatmapCellEmpty(String date) {
    return '$date: kein Check-in';
  }

  @override
  String get symptomHeatmapLegendEmpty => 'kein Eintrag';

  @override
  String get symptomHeatmapNoDay => 'Kein Check-in an diesem Tag.';

  @override
  String get symptomHeatmapDayPattern => 'EEEE, d. MMMM y';

  @override
  String get symptomHeatmapCellPattern => 'd. MMM y';

  @override
  String get symptomHeatmapMonthPattern => 'MMM';

  @override
  String symptomHeatmapSemantics(int days) {
    return 'Kalender der Stärke: $days Tage mit Check-in';
  }

  @override
  String get symptomPickerRecent => 'Zuletzt verwendet';
}
