// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get assistantHistoryHeading => 'EARLIER CONVERSATION';

  @override
  String assistantHistoryTurn(String question, String answer) {
    return 'User: $question\nAssistant: $answer';
  }

  @override
  String get assistantPromptReminder =>
      'Answer briefly in Markdown. Last line: FOLLOW-UPS: … | … | …';

  @override
  String get assistantFollowUpUnderstandTooltip => 'Understand';

  @override
  String get assistantFollowUpActTooltip => 'Act';

  @override
  String get assistantFollowUpRelated => 'What could be related?';

  @override
  String get assistantFollowUpDevelopment => 'How has this developed?';

  @override
  String get assistantFollowUpObserve => 'What should I keep an eye on?';

  @override
  String get assistantFollowUpAskDoctor => 'What should I ask my doctor?';

  @override
  String get assistantFollowUpWhenDoctor => 'When should I see a doctor?';

  @override
  String assistantFollowUpSymptomCourse(String symptom) {
    return 'Course of $symptom';
  }

  @override
  String assistantFollowUpSymptomRelated(String symptom) {
    return 'What could be related to $symptom?';
  }

  @override
  String assistantFollowUpSymptomDoctor(String symptom) {
    return 'Questions for my doctor about $symptom';
  }

  @override
  String get assistantOpenLinkTitle => 'Open link?';

  @override
  String assistantOpenLinkBody(String url) {
    return 'This address will be opened outside the app:\n$url';
  }

  @override
  String get assistantOpenLink => 'Open';

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
  String get cycleTitle => 'Cycle';

  @override
  String get cycleSettingsTitle => 'Cycle & reproductive health';

  @override
  String get cycleSettingsIntro =>
      'All optional. Only turn on what fits you — you can change it any time.';

  @override
  String get cycleTabToday => 'Today';

  @override
  String get cycleTabCalendar => 'Calendar';

  @override
  String get cycleTabInsights => 'Insights';

  @override
  String get cycleOnboardingTitle => 'Cycle & reproductive health';

  @override
  String get cycleOnboardingText =>
      'Would you like to track your cycle, menopause or a pregnancy? Choose what fits — or skip this step.';

  @override
  String get cycleModeCycle => 'Track period/cycle';

  @override
  String get cycleModeCycleSubtitle =>
      'Bleeding, pain, symptoms; estimated next period';

  @override
  String get cycleModeMenopause => 'Menopause';

  @override
  String get cycleModeMenopauseSubtitle =>
      'Hot flushes, sleep, monthly questionnaire (MRS)';

  @override
  String get cycleModePregnancy => 'Pregnancy';

  @override
  String get cycleModePregnancySubtitle =>
      'Weeks, prenatal check-up plan, weight and blood pressure; pauses period estimates';

  @override
  String get cycleModeNone => 'Not for me';

  @override
  String get cycleModeNoneSubtitle => 'Skip — available later in Settings';

  @override
  String get cycleCreateGynecologist => 'Add a gynecologist to your doctors';

  @override
  String get cycleCreateGynecologistSubtitle =>
      'Placeholder you can edit later — e.g. for appointments and the doctor PDF';

  @override
  String get cycleGynecologistPlaceholder => 'My gynecologist';

  @override
  String get cyclePrivacyNote =>
      'Cycle and pregnancy data are especially sensitive. They stay encrypted on this device. Tip: turn on the app lock under Settings → Security.';

  @override
  String get cycleShowFertile => 'Show fertile window';

  @override
  String get cycleShowFertileSubtitle =>
      'Only a rough estimate — not a method of contraception';

  @override
  String get cycleOpen => 'Open cycle';

  @override
  String get cycleDeleteAllTitle => 'Delete all cycle data';

  @override
  String get cycleDeleteAllSubtitle => 'Diary, questionnaires and pregnancy';

  @override
  String get cycleDeleteAllText =>
      'All cycle, menopause and pregnancy entries will be permanently deleted and the sections turned off. Your doctors are kept.';

  @override
  String get cycleDeleteAllDone => 'Cycle data deleted';

  @override
  String get cycleRecordsSubtitle => 'Calendar, history and insights';

  @override
  String get cycleToday => 'today';

  @override
  String get cycleFlowTitle => 'Bleeding';

  @override
  String get cycleFlowNone => 'None';

  @override
  String get cycleFlowSpotting => 'Spotting';

  @override
  String get cycleFlowLight => 'Light';

  @override
  String get cycleFlowMedium => 'Medium';

  @override
  String get cycleFlowHeavy => 'Heavy';

  @override
  String get cycleFlowVeryHeavy => 'Very heavy';

  @override
  String get cyclePainTitle => 'Pain';

  @override
  String get cyclePainNotLogged => 'Not logged — move the slider';

  @override
  String get cyclePainClear => 'Remove';

  @override
  String cyclePainValue(int value) {
    return 'Pain $value/10';
  }

  @override
  String get cyclePainLocations => 'Where?';

  @override
  String get cyclePainkiller => 'Took a painkiller';

  @override
  String get cyclePainkillerName => 'Which one? (optional)';

  @override
  String get cyclePainkillerHelped => 'Did it help?';

  @override
  String get cycleNoAnswer => 'No answer';

  @override
  String get cycleOtherSymptoms => 'Other';

  @override
  String get cycleOtherHint => 'Add your own symptom';

  @override
  String get cycleOtherAdd => 'Add';

  @override
  String get cycleDischargeTitle => 'Discharge';

  @override
  String get cycleMenopauseTitle => 'Menopause';

  @override
  String get cycleHotFlashes => 'Hot flushes today';

  @override
  String get cycleHotFlashIntensity => 'How strong?';

  @override
  String get cycleNightSweats => 'Night sweats';

  @override
  String cycleHotFlashesToday(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hot flushes today',
      one: '1 hot flush today',
    );
    return '$_temp0';
  }

  @override
  String get cyclePregnancyTitle => 'Pregnancy';

  @override
  String get cycleFetalMovement => 'Baby\'s movements';

  @override
  String get cycleFetalNotYet => 'Not felt yet';

  @override
  String get cycleFetalNormal => 'As usual';

  @override
  String get cycleFetalLess => 'Less than usual';

  @override
  String get cycleWeight => 'Weight';

  @override
  String get cycleBpSystolic => 'Blood pressure (systolic)';

  @override
  String get cycleBpDiastolic => 'diastolic';

  @override
  String get cycleNoteHint => 'Anything that matters today';

  @override
  String get cycleDayTitlePattern => 'EEE, MMM d, yyyy';

  @override
  String get cycleDayPattern => 'EEEE, MMMM d';

  @override
  String get cycleDatePattern => 'MMM d, yyyy';

  @override
  String get cycleShortDatePattern => 'M/d';

  @override
  String get cycleMonthPattern => 'MMMM yyyy';

  @override
  String get cycleDayDeleteTitle => 'Delete entry?';

  @override
  String get cycleDayDeleteText => 'All details for this day will be deleted.';

  @override
  String get cyclePbacTitle => 'Count blood loss (PBAC, optional)';

  @override
  String get cyclePbacSubtitle => 'For a clearer picture if periods are heavy';

  @override
  String get cyclePbacExplain =>
      'PBAC (Higham 1990): count pads/tampons by how soaked they are, clots and flooding. More than 100 points per cycle suggest heavy menstrual bleeding — worth having checked.';

  @override
  String cyclePbacScore(int score) {
    return '$score PBAC points today';
  }

  @override
  String cyclePbacPoints(int points) {
    return '$points points each';
  }

  @override
  String get cyclePbacPadsLight => 'Pad, lightly soaked';

  @override
  String get cyclePbacPadsMedium => 'Pad, moderately soaked';

  @override
  String get cyclePbacPadsFull => 'Pad, fully soaked';

  @override
  String get cyclePbacTamponsLight => 'Tampon, lightly soaked';

  @override
  String get cyclePbacTamponsMedium => 'Tampon, moderately soaked';

  @override
  String get cyclePbacTamponsFull => 'Tampon, fully soaked';

  @override
  String get cyclePbacClotsSmall => 'Clot, small (about a 1p/1-cent coin)';

  @override
  String get cyclePbacClotsLarge =>
      'Clot, large (about a 50p/2-euro coin or larger)';

  @override
  String get cyclePbacFlooding => 'Flooding episode';

  @override
  String get cycleLess => 'Less';

  @override
  String get cycleMore => 'More';

  @override
  String get cyclePhaseMenstruation => 'Period';

  @override
  String get cyclePhaseFollicular => 'Follicular';

  @override
  String get cyclePhaseOvulation => 'Ovulation (approx.)';

  @override
  String get cyclePhaseLuteal => 'Luteal';

  @override
  String get cycleStatusNoData => 'No period logged yet — log the first day.';

  @override
  String cycleStatusCycleDay(int day) {
    return 'Cycle day $day';
  }

  @override
  String cycleStatusPeriodDay(int day) {
    return 'Period, day $day';
  }

  @override
  String cycleStatusNextIn(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'next period in ~$days days (estimated)',
      one: 'next period in ~1 day (estimated)',
    );
    return '$_temp0';
  }

  @override
  String get cycleStatusExpectedNow => 'Period expected about now (estimated)';

  @override
  String get cycleStatusLate => 'Period later than estimated';

  @override
  String get cycleEstimateDisclaimer =>
      'Estimate based on your past cycles — not a method of contraception or a pregnancy test.';

  @override
  String cyclePredictionRange(String from, String to) {
    return 'Next period around $from – $to (estimated)';
  }

  @override
  String cycleFertileRange(String from, String to) {
    return 'Fertile window, rough estimate: $from – $to';
  }

  @override
  String get cycleQuickLogTitle => 'Log today';

  @override
  String get cycleQuickLogMore => 'Log more (symptoms, discharge, note …)';

  @override
  String cycleQuickLogSymptoms(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count symptoms logged',
      one: '1 symptom logged',
    );
    return '$_temp0';
  }

  @override
  String get cyclePrevMonth => 'Previous month';

  @override
  String get cycleNextMonth => 'Next month';

  @override
  String get cycleCalendarHint => 'Tap a day to log or change it.';

  @override
  String get cycleLegendPeriod => 'Bleeding';

  @override
  String get cycleLegendPredicted => 'expected (estimated)';

  @override
  String get cycleLegendFertile => 'fertile (rough)';

  @override
  String get cycleLegendLogged => 'logged';

  @override
  String get cycleInsightsOverview => 'Overview';

  @override
  String get cycleInsightsNotEnough =>
      'Averages and estimates need at least two logged periods.';

  @override
  String cycleInsightsAverage(String average, int median, int min, int max) {
    return 'Cycle length avg. $average days (median $median, $min–$max)';
  }

  @override
  String cycleInsightsPeriod(String average, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Period avg. $average days · $count cycles analysed',
      one: 'Period avg. $average days · 1 cycle analysed',
    );
    return '$_temp0';
  }

  @override
  String get cycleInsightsEmpty =>
      'Nothing to show yet — log a few days and charts will appear here.';

  @override
  String get cycleChartLengthTitle => 'Cycle lengths';

  @override
  String get cycleChartLengthHelp =>
      'Bars = cycle length, darker part = period. Shaded: 21–35 days; dashed: your average.';

  @override
  String cycleChartLengthSemantics(int count, String values) {
    return 'Lengths of the last $count cycles: $values days';
  }

  @override
  String get cycleChartPainTitle => 'Pain by cycle day';

  @override
  String get cycleChartPainHelp =>
      'Each row is a cycle, each column a cycle day. This shows patterns such as pain just before or at the start of a period.';

  @override
  String cycleChartPainSemantics(int count, String days) {
    return 'Pain across $count cycles; strong pain on cycle day $days';
  }

  @override
  String get cyclePainStripLegend => 'Colour = pain 0–10 · red line = period';

  @override
  String get cycleChartPhaseTitle => 'Symptoms by cycle phase';

  @override
  String get cycleChartPhaseHelp =>
      'Share of logged days in each phase with the symptom. Phases are estimated from your cycles.';

  @override
  String get cycleChartPbacTitle => 'PBAC per cycle';

  @override
  String cycleChartPbacSemantics(String values) {
    return 'PBAC points per cycle: $values; threshold 100';
  }

  @override
  String get cycleChartHotFlashTitle => 'Hot flushes per week';

  @override
  String cycleChartHotFlashSemantics(String values) {
    return 'Hot flushes per week, last 12 weeks: $values';
  }

  @override
  String get cycleChartMrsTitle => 'Menopause Rating Scale trend';

  @override
  String cycleChartMrsSemantics(String values) {
    return 'MRS totals: $values (out of 44)';
  }

  @override
  String get cycleChartWeightTitle => 'Weight';

  @override
  String cycleChartWeightSemantics(int count, String latest) {
    return 'Weight, $count readings, latest $latest kg';
  }

  @override
  String get cycleChartBpTitle => 'Blood pressure';

  @override
  String get cycleChartBpHelp =>
      'In pregnancy, please discuss readings of 140/90 mmHg or higher with your doctor promptly.';

  @override
  String cycleChartBpSemantics(int count) {
    return 'Blood pressure, $count readings';
  }

  @override
  String get cycleHintsTitle => 'Worth discussing with your gynecologist';

  @override
  String get cycleHintsUrgentTitle => 'Please get this checked soon';

  @override
  String get cycleHintsFooter =>
      'This is not a diagnosis — just a pointer from your entries.';

  @override
  String cycleHintShortCycles(int days) {
    return 'Your cycles were repeatedly shorter than 21 days (median $days days).';
  }

  @override
  String cycleHintLongCycles(int days) {
    return 'Your cycles were repeatedly longer than 35 days (median $days days).';
  }

  @override
  String cycleHintIrregular(int days) {
    return 'Your cycle lengths vary by $days days (shortest to longest).';
  }

  @override
  String cycleHintLongPeriod(int days) {
    return 'A period lasted $days days (longer than 7 days).';
  }

  @override
  String cycleHintHeavyBleeding(int score) {
    return 'PBAC of $score points in one cycle (over 100 suggests heavy bleeding).';
  }

  @override
  String cycleHintStrongPain(int days) {
    return 'Strong pain (7/10 or more) on $days days in one cycle.';
  }

  @override
  String get cycleHintPainkiller => 'Painkillers didn\'t help enough.';

  @override
  String cycleHintIntermenstrual(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Spotting on $days days between periods (last 90 days).',
      one: 'Spotting on 1 day between periods (last 90 days).',
    );
    return '$_temp0';
  }

  @override
  String get cycleHintPostmenopausal =>
      'Bleeding after more than 12 months without a period — please get it checked.';

  @override
  String get cycleHintPregnancyBleeding =>
      'Please get bleeding in pregnancy checked soon — often harmless, but important to know.';

  @override
  String get cycleHintFetalMovement =>
      'If you feel your baby moving less than usual, please contact your practice or maternity unit soon.';

  @override
  String get cycleMrsTitle => 'Menopause Rating Scale (MRS)';

  @override
  String get cycleMrsIntro =>
      'Which of the following complaints do you currently have — and how strongly? Please answer each one. Once a month is enough.';

  @override
  String get cycleMrsExplain =>
      'A short, validated questionnaire (11 questions) — once a month it shows how your symptoms change.';

  @override
  String get cycleMrsFill => 'Fill in questionnaire';

  @override
  String cycleMrsSave(int answered, int total) {
    return 'Save ($answered/$total)';
  }

  @override
  String cycleMrsSaved(String summary) {
    return 'Saved: $summary';
  }

  @override
  String get cycleMrsSource =>
      'Menopause Rating Scale after Heinemann et al. (Health Qual Life Outcomes 2003; 2004). Total 0–44: 0–4 none/little, 5–8 mild, 9–16 moderate, 17+ severe.';

  @override
  String get cycleMrsBands =>
      'Total 0–44: 0–4 none/little, 5–8 mild, 9–16 moderate, 17+ severe.';

  @override
  String get cycleMrsLevel0 => 'none';

  @override
  String get cycleMrsLevel1 => 'mild';

  @override
  String get cycleMrsLevel2 => 'moderate';

  @override
  String get cycleMrsLevel3 => 'severe';

  @override
  String get cycleMrsLevel4 => 'very severe';

  @override
  String get cycleMrsItem1 => 'Hot flushes, sweating (episodes of sweating)';

  @override
  String get cycleMrsItem2 =>
      'Heart discomfort (unusual awareness of heartbeat, heart skipping, racing, tightness)';

  @override
  String get cycleMrsItem3 =>
      'Sleep problems (difficulty falling asleep, sleeping through, waking up early)';

  @override
  String get cycleMrsItem4 =>
      'Depressive mood (feeling down, sad, on the verge of tears, lack of drive, mood swings)';

  @override
  String get cycleMrsItem5 =>
      'Irritability (feeling nervous, inner tension, feeling aggressive)';

  @override
  String get cycleMrsItem6 => 'Anxiety (inner restlessness, feeling panicky)';

  @override
  String get cycleMrsItem7 =>
      'Physical and mental exhaustion (decrease in performance, impaired memory, poor concentration, forgetfulness)';

  @override
  String get cycleMrsItem8 =>
      'Sexual problems (change in sexual desire, activity and satisfaction)';

  @override
  String get cycleMrsItem9 =>
      'Bladder problems (difficulty urinating, increased need to urinate, bladder incontinence)';

  @override
  String get cycleMrsItem10 =>
      'Dryness of vagina (sensation of dryness or burning, difficulty with sexual intercourse)';

  @override
  String get cycleMrsItem11 =>
      'Joint and muscular discomfort (pain in the joints, rheumatoid complaints)';

  @override
  String get cycleMrsSomatic => 'somatic';

  @override
  String get cycleMrsPsychological => 'psychological';

  @override
  String get cycleMrsUrogenital => 'urogenital';

  @override
  String get cycleMrsTotalLabel => 'Total';

  @override
  String cycleMrsTotal(int total, String severity) {
    return 'MRS $total ($severity)';
  }

  @override
  String get cycleMrsSeverityNone => 'none/little';

  @override
  String get cycleMrsSeverityMild => 'mild';

  @override
  String get cycleMrsSeverityModerate => 'moderate';

  @override
  String get cycleMrsSeveritySevere => 'severe';

  @override
  String get cycleMrsNotYet => 'Menopause: MRS questionnaire not filled in yet';

  @override
  String cycleMrsLatest(int total, String severity, String date) {
    return 'Menopause: MRS $total ($severity) on $date';
  }

  @override
  String get cyclePregnancyNoDates =>
      'Pregnancy: enter your last period or the due date.';

  @override
  String cyclePregnancyWeek(String week) {
    return 'Week $week';
  }

  @override
  String cyclePregnancyTrimester(int trimester) {
    return 'Trimester $trimester';
  }

  @override
  String cyclePregnancyDaysToDue(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days to due date',
      one: '1 day to due date',
      zero: 'due today',
    );
    return '$_temp0';
  }

  @override
  String cyclePregnancyDue(String date) {
    return 'Due date $date';
  }

  @override
  String get cyclePregnancyDueNote =>
      'The due date is a guide — few babies arrive exactly on that day.';

  @override
  String get cyclePregnancyEditDates => 'Due date & last period';

  @override
  String get cyclePregnancyLmp => 'First day of last period';

  @override
  String cyclePregnancyNaegele(String date) {
    return 'Calculated (Naegele, + 280 days): $date';
  }

  @override
  String get cyclePregnancyDueOverride =>
      'Due date from doctor/ultrasound (takes priority)';

  @override
  String get cyclePregnancyTimeline => 'Prenatal check-up plan (suggestions)';

  @override
  String get cyclePregnancyTimelineSource =>
      'Based on the German maternity guidelines: check-ups every 4 weeks, every 2 weeks from week 32; three routine ultrasounds. Your practice plans individually.';

  @override
  String cyclePregnancyShowAll(int count) {
    return 'Show all $count';
  }

  @override
  String get cyclePregnancyShowLess => 'Show less';

  @override
  String cycleMilestoneCheckup(String weeks) {
    return 'Check-up (week $weeks)';
  }

  @override
  String cycleMilestoneUltrasound(String weeks) {
    return 'Routine ultrasound (weeks $weeks)';
  }

  @override
  String cycleMilestoneAround(String date) {
    return 'from $date';
  }

  @override
  String get cycleMilestoneCreate => 'Add as appointment';

  @override
  String get cycleMilestoneCreated => 'Appointment added';

  @override
  String get cyclePregnancyEnd => 'End pregnancy';

  @override
  String get cyclePregnancyEndText =>
      'The pregnancy will be closed and the section hidden. Your entries are kept. You can optionally say how it ended.';

  @override
  String get cyclePregnancyOutcomeBirth => 'Birth';

  @override
  String get cyclePregnancyOutcomeLoss => 'Miscarriage or loss';

  @override
  String get cyclePregnancyOutcomeNone => 'Prefer not to say';

  @override
  String get cyclePregnancyEndConfirm => 'End';

  @override
  String get cyclePregnancyEnded => 'Saved';

  @override
  String get cycleTopic => 'Cycle & reproductive health';

  @override
  String get cycleTopicDescription =>
      'Expected period, monthly questionnaire, check-up suggestions — discreet by default';

  @override
  String get cycleDiscreetTitle => 'Reminder';

  @override
  String get cycleReminderSoonTitle =>
      'Period expected in about 2 days (estimated)';

  @override
  String get cycleReminderTodayTitle =>
      'Period expected about today (estimated)';

  @override
  String get cycleReminderBody => 'Log it in your cycle diary when it starts.';

  @override
  String get cycleReminderMrsTitle =>
      'Time for your monthly menopause questionnaire';

  @override
  String cycleReminderMrsBody(int total) {
    return 'Last score: MRS $total';
  }

  @override
  String get cycleReminderMilestoneBody =>
      'Suggestion from your check-up plan — booked yet?';

  @override
  String get cycleSummarySubtitle =>
      'Recent cycles, averages, PBAC, pain days, symptoms, pointers; pregnancy and MRS if active';

  @override
  String cycleReportWeight(String kg, String date) {
    return 'Latest weight $kg kg ($date)';
  }

  @override
  String cycleReportBp(int sys, int dia, String date) {
    return 'Latest blood pressure $sys/$dia mmHg ($date)';
  }

  @override
  String cycleReportStats(
    String average,
    int median,
    int min,
    int max,
    int count,
  ) {
    return 'Cycle length avg. $average days, median $median ($min–$max), $count cycles';
  }

  @override
  String cycleReportPeriodLength(String average) {
    return 'Period length avg. $average days';
  }

  @override
  String cycleReportPainDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days with pain (last 6 months)',
      one: '1 day with pain (last 6 months)',
    );
    return '$_temp0';
  }

  @override
  String cycleReportTopSymptoms(String symptoms) {
    return 'Most frequent symptoms (days): $symptoms';
  }

  @override
  String cycleReportRecentStarts(String dates) {
    return 'Recent period starts: $dates';
  }

  @override
  String get cycleReportStart => 'Start';

  @override
  String get cycleReportLength => 'Cycle (days)';

  @override
  String get cycleReportPeriod => 'Period (days)';

  @override
  String get cycleReportStrongPain => 'Days pain ≥ 7';

  @override
  String get cycleReportRunning => 'ongoing';

  @override
  String get cycleReportFooter =>
      'Self-recorded in Mai Doctor Hub. Estimates and pointers are not a diagnosis.';

  @override
  String measureHistoryEarlier(String measure) {
    return 'Previously recorded: $measure';
  }

  @override
  String measureHistoryRange(String from, String to, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count check-ins',
      one: '1 check-in',
    );
    return '$from – $to · $_temp0';
  }

  @override
  String get heatmapMixedNote =>
      'Days with values recorded under an earlier measure are colored by that measure.';

  @override
  String get measureChangeTitle => 'Change measure?';

  @override
  String measureChangeBody(String measures, String next) {
    return 'Existing check-ins ($measures) stay unchanged and are shown separately in the history. New check-ins will be recorded as “$next”.';
  }

  @override
  String get measureChangeKeep => 'Change';

  @override
  String get measureChangeConvert => 'Change and convert';

  @override
  String get searchJournalEntry => 'Journal entry';

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
  String get measureIntensity => 'Intensity 0–10';

  @override
  String get measureTemperature => 'Temperature';

  @override
  String get measureCount => 'Count';

  @override
  String get measureDuration => 'Duration';

  @override
  String get measurePulse => 'Pulse';

  @override
  String get measureBloodPressure => 'Blood pressure';

  @override
  String get measureSpo2 => 'Oxygen saturation (SpO₂)';

  @override
  String get measureGlucose => 'Blood glucose';

  @override
  String get measureWeight => 'Weight';

  @override
  String get measureMood => 'Mood −5 to +5';

  @override
  String get measureMoodShort => 'Mood';

  @override
  String get measureUnitPulse => 'bpm';

  @override
  String get measureTempNormal => 'normal';

  @override
  String get measureTempElevated => 'raised';

  @override
  String get measureTempFever => 'fever';

  @override
  String get measureTempHighFever => 'high fever';

  @override
  String get measureBpOptimal => 'optimal';

  @override
  String get measureBpNormal => 'normal';

  @override
  String get measureBpHighNormal => 'high-normal';

  @override
  String get measureBpGrade1 => 'grade 1 hypertension';

  @override
  String get measureBpGrade2 => 'grade 2 hypertension';

  @override
  String get measureBpGrade3 => 'grade 3 hypertension';

  @override
  String get measureSpo2Normal => 'normal';

  @override
  String get measureSpo2Low => 'slightly low';

  @override
  String get measureSpo2Check => 'get it checked';

  @override
  String get measureSpo2Urgent => 'seek medical advice promptly';

  @override
  String get measureSpo2HintCheck =>
      'Below 92%: please get this checked by a doctor, especially if you are short of breath.';

  @override
  String get measureSpo2HintUrgent =>
      'Below 90%: please seek medical advice promptly. Call emergency services if you are very short of breath, confused or your lips turn blue.';

  @override
  String get measureGlucoseVeryLow => 'very low';

  @override
  String get measureGlucoseLow => 'low';

  @override
  String get measureGlucoseInRange => 'in range';

  @override
  String get measureGlucoseHigh => 'high';

  @override
  String get measureGlucoseVeryHigh => 'very high';

  @override
  String get measurePulseLow => 'low';

  @override
  String get measurePulseNormal => 'normal (at rest)';

  @override
  String get measurePulseHigh => 'raised';

  @override
  String get moodM5 => 'severely depressed';

  @override
  String get moodM4 => 'very low';

  @override
  String get moodM3 => 'clearly low';

  @override
  String get moodM2 => 'low';

  @override
  String get moodM1 => 'slightly low';

  @override
  String get mood0 => 'balanced';

  @override
  String get moodP1 => 'slightly elevated';

  @override
  String get moodP2 => 'elevated';

  @override
  String get moodP3 => 'clearly elevated';

  @override
  String get moodP4 => 'very elevated';

  @override
  String get moodP5 => 'manic';

  @override
  String get moodAnchor0 => 'Neither low nor high';

  @override
  String get moodAnchorMild => 'Noticeable, but daily life goes fine';

  @override
  String get moodAnchorModerate =>
      'Daily life (work, family) only with clear effort';

  @override
  String get moodAnchorSevere => 'Daily life hardly possible';

  @override
  String get moodScaleLow => '−5 severely depressed';

  @override
  String get moodScaleHigh => '+5 manic';

  @override
  String get moodExtras => 'Energy, sleep, anxiety';

  @override
  String get moodEnergy => 'Energy';

  @override
  String get moodSleep => 'Sleep (hours)';

  @override
  String get moodAnxiety => 'Anxiety/tension';

  @override
  String moodEnergyValue(String value) {
    return 'Energy $value/10';
  }

  @override
  String moodSleepValue(String value) {
    return 'Sleep $value h';
  }

  @override
  String moodAnxietyValue(String value) {
    return 'Anxiety $value/10';
  }

  @override
  String get measureHowTitle => 'How to measure?';

  @override
  String get measureHowHint => 'Suggested from the name – tap to change.';

  @override
  String get measureSecondary => 'Also record';

  @override
  String get measureSecondaryNone => 'nothing else';

  @override
  String get symptomBlocksHint =>
      'Tap building blocks to compose the name. You can still edit it freely.';

  @override
  String get symptomTitleRegenerate => 'Regenerate from building blocks';

  @override
  String get checkInDetails => 'Change details';

  @override
  String get checkInHintMeasure =>
      'Record the current value. Description and location come from the symptom – “Change details” adjusts them for this check-in.';

  @override
  String get measureCountHint => 'How many times since the last check-in?';

  @override
  String get measureDurationHint => 'How long in total?';

  @override
  String get measureBpSystolic => 'Systolic';

  @override
  String get measureBpDiastolic => 'Diastolic';

  @override
  String measureAdd(String measure) {
    return 'Add $measure';
  }

  @override
  String get measureRemove => 'Remove';

  @override
  String get measureDecrease => 'Less';

  @override
  String get measureIncrease => 'More';

  @override
  String measureFeverLine(String value) {
    return 'Fever from $value';
  }

  @override
  String measureReferenceLine(String value) {
    return 'Limit $value';
  }

  @override
  String measureChartSemantics(String measure, int count, String latest) {
    return '$measure: $count values, latest $latest';
  }

  @override
  String measureStats(String average, String min, String max, String last) {
    return 'avg $average · min $min · max $max · latest $last';
  }

  @override
  String measureStatsCount(int count, String stats) {
    return '$count check-in(s) · $stats';
  }

  @override
  String get measureTotalPerDay => 'Total per day';

  @override
  String heatmapCellMeasure(String date, String value) {
    return '$date: $value';
  }

  @override
  String heatmapSemanticsMeasure(String measure, int days) {
    return 'Calendar ($measure): $days days with check-ins';
  }

  @override
  String get severityNone => 'unremarkable';

  @override
  String get severityMild => 'mild';

  @override
  String get severityModerate => 'moderate';

  @override
  String get severitySevere => 'marked';

  @override
  String get severityMax => 'very marked';

  @override
  String heatmapMapTemperature(
    String elevated,
    String fever,
    String high,
    String max,
  ) {
    return 'Colour by temperature: raised from $elevated, fever from $fever, high fever from $high, darkest from $max.';
  }

  @override
  String heatmapMapRelative(String max) {
    return 'Colour relative to the highest daily value ($max).';
  }

  @override
  String get heatmapMapBloodPressure =>
      'Colour by ESC/ESH category: high-normal, grade 1, 2, 3 hypertension.';

  @override
  String get heatmapMapSpo2 =>
      'Colour by saturation: below 95%, 92%, 90%, 85% (lowest value of the day).';

  @override
  String heatmapMapGlucose(String low, String high) {
    return 'Colour: outside the target range $low–$high; very low is darkest.';
  }

  @override
  String get heatmapMapPulse =>
      'Colour: distance from the resting pulse range 60–100 bpm.';

  @override
  String get heatmapMapMood =>
      'Colour: distance from “balanced” (0) – the mood chart shows the direction.';

  @override
  String get heatmapMapWeight => 'Colour: days with a measurement.';

  @override
  String get journalTitle => 'Journal';

  @override
  String get journalAdd => 'Journal entry';

  @override
  String get journalHint => 'What is on your mind? (optional)';

  @override
  String get journalPromptHelped => 'What helped today?';

  @override
  String get journalPromptBurden => 'What weighed on me?';

  @override
  String get journalPromptGrateful => 'What am I grateful for?';

  @override
  String get journalPrivacy =>
      'Stays on your device. Included in the doctor PDF only if you switch it on there.';

  @override
  String get journalEmpty => 'No journal entries yet.';

  @override
  String get journalChartHint =>
      'Dots above the chart = journal entry. Tap to read.';

  @override
  String journalContext(String date, String text) {
    return 'Journal $date: $text';
  }

  @override
  String get summaryIncludeJournal => 'Include journal entries';

  @override
  String get summaryIncludeJournalSubtitle =>
      'Off by default – personal notes stay private.';

  @override
  String get unitsTitle => 'Units';

  @override
  String get unitsIntro =>
      'Values are always stored the same way – only the display is converted. Default by device region.';

  @override
  String get unitsTemperature => 'Temperature';

  @override
  String get unitsGlucose => 'Blood glucose';

  @override
  String get unitsWeight => 'Weight';

  @override
  String cycleReportWeightValue(String value, String date) {
    return 'Latest weight $value ($date)';
  }

  @override
  String cycleChartWeightSemanticsValue(int count, String latest) {
    return 'Weight, $count readings, latest $latest';
  }

  @override
  String get mediaSectionTitle => 'Evidence';

  @override
  String get mediaSectionHint =>
      'Photos, videos or voice notes show your doctor what you describe — e.g. a rash, swelling, a sound when breathing or a seizure. Everything stays encrypted on this device.';

  @override
  String get mediaTakePhoto => 'Photo';

  @override
  String get mediaRecordVideo => 'Video';

  @override
  String get mediaRecordAudio => 'Voice note';

  @override
  String get mediaFromGallery => 'From gallery';

  @override
  String get mediaGalleryPhoto => 'Photo from gallery';

  @override
  String get mediaGalleryVideo => 'Video from gallery';

  @override
  String get mediaPhoto => 'Photo';

  @override
  String get mediaVideo => 'Video';

  @override
  String get mediaAudio => 'Voice note';

  @override
  String get mediaEmpty => 'No evidence yet.';

  @override
  String get mediaSaving => 'Saving evidence encrypted…';

  @override
  String get mediaSaved => 'Evidence saved.';

  @override
  String mediaFailed(String error) {
    return 'Couldn\'t save evidence: $error';
  }

  @override
  String get mediaDeleteTitle => 'Delete evidence?';

  @override
  String get mediaDeleteText =>
      'The file will be permanently removed from this device.';

  @override
  String get mediaNoteLabel => 'Note on this evidence (optional)';

  @override
  String get mediaRecordingTitle => 'Record voice note';

  @override
  String get mediaRecordingHint =>
      'Take your time to describe what you feel — or record a sound (cough, breathing, palpitations).';

  @override
  String get mediaRecordingStop => 'Stop & save';

  @override
  String get mediaMicDenied =>
      'A voice note needs microphone permission. You can allow it in the app\'s Android settings.';

  @override
  String get mediaUnavailable => 'File not available.';

  @override
  String mediaCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
    );
    return '$_temp0';
  }

  @override
  String get mediaDatePattern => 'MMM d, yyyy, h:mm a';

  @override
  String svcSummaryPdfEvidence(int photos, int videos, int audio) {
    return 'Evidence: $photos photos, $videos videos, $audio voice notes (in the app)';
  }

  @override
  String get psychTitle => 'Mental health';

  @override
  String get psychIntro =>
      'Short, well-established questionnaires show how you have been over the weeks. The result is not a diagnosis – talk to your doctor about it.';

  @override
  String get psychSettingsSubtitle =>
      'Mood, anxiety and journal – with PHQ-9 and GAD-7 as a monthly questionnaire.';

  @override
  String get psychQuestionnairesToggle =>
      'Monthly questionnaires (PHQ-9, GAD-7)';

  @override
  String get psychQuestionnairesSubtitle =>
      'Reminder 30 days after the last one; trend on the “Mental health” page.';

  @override
  String get psychOpen => 'Open mental health';

  @override
  String get psychAreaLink => 'Mental health: questionnaires & trend';

  @override
  String get psychPhq9Title => 'PHQ-9 (depression)';

  @override
  String get psychGad7Title => 'GAD-7 (anxiety)';

  @override
  String get psychQuestion =>
      'Over the last 2 weeks, how often have you been bothered by any of the following problems?';

  @override
  String get psychPhq1 => 'Little interest or pleasure in doing things';

  @override
  String get psychPhq2 => 'Feeling down, depressed, or hopeless';

  @override
  String get psychPhq3 =>
      'Trouble falling or staying asleep, or sleeping too much';

  @override
  String get psychPhq4 => 'Feeling tired or having little energy';

  @override
  String get psychPhq5 => 'Poor appetite or overeating';

  @override
  String get psychPhq6 =>
      'Feeling bad about yourself — or that you are a failure or have let yourself or your family down';

  @override
  String get psychPhq7 =>
      'Trouble concentrating on things, such as reading the newspaper or watching television';

  @override
  String get psychPhq8 =>
      'Moving or speaking so slowly that other people could have noticed? Or the opposite — being so fidgety or restless that you have been moving around a lot more than usual';

  @override
  String get psychPhq9 =>
      'Thoughts that you would be better off dead or of hurting yourself in some way';

  @override
  String get psychGad1 => 'Feeling nervous, anxious or on edge';

  @override
  String get psychGad2 => 'Not being able to stop or control worrying';

  @override
  String get psychGad3 => 'Worrying too much about different things';

  @override
  String get psychGad4 => 'Trouble relaxing';

  @override
  String get psychGad5 => 'Being so restless that it is hard to sit still';

  @override
  String get psychGad6 => 'Becoming easily annoyed or irritable';

  @override
  String get psychGad7 => 'Feeling afraid as if something awful might happen';

  @override
  String get psychAnswer0 => 'Not at all';

  @override
  String get psychAnswer1 => 'Several days';

  @override
  String get psychAnswer2 => 'More than half the days';

  @override
  String get psychAnswer3 => 'Nearly every day';

  @override
  String get psychSeverityMinimal => 'minimal';

  @override
  String get psychSeverityMild => 'mild';

  @override
  String get psychSeverityModerate => 'moderate';

  @override
  String get psychSeverityModeratelySevere => 'moderately severe';

  @override
  String get psychSeveritySevere => 'severe';

  @override
  String psychResultSummary(
    String instrument,
    int total,
    int max,
    String severity,
  ) {
    return '$instrument: $total of $max – $severity';
  }

  @override
  String psychSave(int answered, int count) {
    return 'Save ($answered/$count)';
  }

  @override
  String psychSaved(String summary) {
    return 'Saved: $summary';
  }

  @override
  String psychFill(String instrument) {
    return 'Fill in $instrument';
  }

  @override
  String get psychTrend => 'Trend';

  @override
  String get psychNoResults => 'No questionnaires filled in yet.';

  @override
  String get psychBands =>
      'PHQ-9: 0–4 minimal · 5–9 mild · 10–14 moderate · 15–19 moderately severe · 20–27 severe. GAD-7: 0–4 minimal · 5–9 mild · 10–14 moderate · 15–21 severe.';

  @override
  String get psychSource =>
      'PHQ-9 (Kroenke et al. 2001) and GAD-7 (Spitzer et al. 2006). Free to use; not a substitute for a medical diagnosis.';

  @override
  String get psychSupportTitle => 'You don’t have to carry this alone';

  @override
  String get psychSupportText =>
      'If you are thinking about hurting yourself, please talk to someone. These services are there for you around the clock:';

  @override
  String get psychSupportGeneric =>
      'Please contact a crisis line in your country or your local emergency services. Doctors and people you trust can help, too.';

  @override
  String psychSupportEmergency(String number) {
    return 'In immediate danger: call $number';
  }

  @override
  String get psychSupportPrivacy =>
      'This note only appears on your device. Nothing is sent.';

  @override
  String psychSupportCall(String name, String number) {
    return '$name: $number';
  }

  @override
  String get psychTopic => 'Mood & mental health';

  @override
  String get psychTopicDescription =>
      'Check-ins for mental health symptoms and monthly questionnaires';

  @override
  String get psychDiscreetTitle => 'A moment for you';

  @override
  String get psychReminderTitle => 'Mental health questionnaire';

  @override
  String get psychReminderBody =>
      'A month has passed – two minutes for PHQ-9 and GAD-7?';

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
  String get settingsNotificationsTitle => 'Notifications';

  @override
  String get settingsNotificationsSubtitle =>
      'Topics, importance and lock screen';

  @override
  String get settingsNotificationsIntro =>
      'Each topic has its own channel. Decide what should reach you loudly, what can be quiet and what you don\'t need at all.';

  @override
  String get settingsNotificationLevelImportant => 'Important';

  @override
  String get settingsNotificationLevelNormal => 'Normal';

  @override
  String get settingsNotificationLevelSilent => 'Quiet';

  @override
  String get settingsNotificationLevelImportantHint =>
      'Sound and a banner at the top of the screen';

  @override
  String get settingsNotificationLevelNormalHint =>
      'Sound, only in the notification shade';

  @override
  String get settingsNotificationLevelSilentHint =>
      'No sound, only in the notification shade';

  @override
  String get settingsNotificationDiscreet => 'Discreet';

  @override
  String get settingsNotificationDiscreetSubtitle =>
      'Without names of medications, doctors, vaccinations or symptoms — useful when others can see your screen.';

  @override
  String get settingsNotificationOff => 'Off';

  @override
  String get settingsNotificationSystemHint =>
      'You can fine-tune details like the sound or Do Not Disturb per channel in the app\'s Android settings.';

  @override
  String get settingsLockReasonDisable => 'Turn off app lock';

  @override
  String get settingsKeyUnavailableTitle => 'Data can\'t be read right now';

  @override
  String get settingsKeyUnavailableText =>
      'The key for your records isn\'t available at the moment. Your data is unchanged — please try again shortly or restart the device.';

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
    return 'Also finds entries that don\'t contain the words of your question (e.g. “thyroid” → TSH level). Downloads $model ($size); search then works offline.\n\nGoogle only releases the model once you accept the Gemma license. For that you need a free Hugging Face token once:';
  }

  @override
  String get svcSemanticTokenLabel => 'Hugging Face token (hf_…)';

  @override
  String get svcSemanticStep1 =>
      'Create a free Hugging Face account or sign in.';

  @override
  String get svcSemanticStep1Link => 'Open Hugging Face';

  @override
  String get svcSemanticStep2 =>
      'Open the model page and tap “Agree and access repository” (Google\'s Gemma license). If there is no button, accept the license once on Google\'s original page.';

  @override
  String get svcSemanticStep2Link => 'Open model page';

  @override
  String get svcSemanticStep2Google => 'Google\'s original page';

  @override
  String get svcSemanticStep3 =>
      'On the token page tap “Create new token”, choose type “Read”, give it a name and copy the token (starts with hf_).';

  @override
  String get svcSemanticStep3Link => 'Open token page';

  @override
  String get svcSemanticStep4 =>
      'Paste the token here and tap “Enable semantic search”. It is only used for the download and is not stored; afterwards you can delete it on the token page.';

  @override
  String get svcSemanticLicenseHint =>
      'If the download fails, the license (step 2) usually hasn\'t been accepted yet.';

  @override
  String svcLinkCopied(String url) {
    return 'Couldn\'t open the link, so it was copied: $url';
  }

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
      'You are the assistant of the app “Mai Doctor Hub”. You help the user calmly and factually to understand their own health record. Answer in English in Markdown, at most about 180 words.\nRules:\n- Rely on the RECORD section. If something is not in it, say honestly that it is not noted in the record.\n- Copy dates, times, dosages and values exactly.\n- Do not make diagnoses and do not give therapy or dosage recommendations. Name possibilities (“could”, “often this is due to …”), never certainties.\n- If there are warning signs of an emergency: advise calling the local emergency number (112 in Europe, 911 in the US) immediately.\nFor complaints or symptoms always answer in two directions at once, 2–4 short points each:\n**Possible connections**\n- What in the record could fit: (new) medications around that time, cycle phase, sleep and mood, other symptoms, recent appointments or reports.\n- Common general causes, worded neutrally.\n**What you can do**\n- What to observe or log in the app.\n- Questions for the doctor.\n- Simple self-care.\n- When to get medical advice soon and when to call the emergency number right away.\nFor other questions (appointments, medications, reports) answer directly and concisely.\nLast line of every answer: FOLLOW-UPS: question 1 | question 2 | question 3\nShort questions from the user\'s point of view — at least one to understand, one to act.';

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

  @override
  String get svcTopicMedication => 'Medication intake';

  @override
  String get svcTopicAppointmentSoon => 'Upcoming appointment';

  @override
  String get svcTopicAppointmentSoonDescription =>
      'Reminders shortly before a doctor\'s appointment (less than a day)';

  @override
  String get svcTopicAppointmentAhead => 'Appointment preview';

  @override
  String get svcTopicAppointmentAheadDescription =>
      'Heads-ups about appointments a day or more ahead';

  @override
  String get svcTopicVaccination => 'Vaccinations';

  @override
  String get svcTopicVaccinationDescription => 'Boosters that are due';

  @override
  String get svcDiscreetMedicationTitle => 'Time for your medication';

  @override
  String get svcDiscreetAppointmentTitle => 'Appointment reminder';

  @override
  String get svcDiscreetVaccinationTitle => 'A vaccination is due soon';

  @override
  String get svcDiscreetCheckInTitle => 'Time for your check-in';

  @override
  String get svcDiscreetBody => 'Details in Doctor Hub';

  @override
  String svcReminderVaccinationSoon(String vaccine) {
    return '$vaccine: due in one week';
  }

  @override
  String svcReminderVaccinationToday(String vaccine) {
    return '$vaccine: due today';
  }

  @override
  String get svcReminderVaccinationBody =>
      'Book an appointment for the booster';

  @override
  String get svcModelIntegrityFailed =>
      'The download was incomplete or didn\'t match the verified version and was discarded. Please try again.';

  @override
  String get symptomCheckInHint =>
      'Describe what you feel: type, character, location and intensity (0–10). Tap a part to change it.';

  @override
  String get symptomSensation => 'Sensation';

  @override
  String get symptomQuality => 'Character';

  @override
  String get symptomLocation => 'Location';

  @override
  String get symptomSide => 'Side';

  @override
  String get symptomPattern => 'Pattern';

  @override
  String get symptomIntensity => 'Intensity';

  @override
  String get symptomSideLeft => 'left';

  @override
  String get symptomSideRight => 'right';

  @override
  String get symptomSideBoth => 'both sides';

  @override
  String get symptomSideCenter => 'central';

  @override
  String get symptomSideNone => 'not specified';

  @override
  String symptomLocationSide(String location, String side) {
    return '$location ($side)';
  }

  @override
  String symptomIntensityValue(String value, String band) {
    return '$value/10 $band';
  }

  @override
  String get symptomBandNone => 'none';

  @override
  String get symptomBandMild => 'mild';

  @override
  String get symptomBandModerate => 'moderate';

  @override
  String get symptomBandSevere => 'severe';

  @override
  String get symptomBandUnbearable => 'unbearable';

  @override
  String get symptomAnchor0 => 'Not present';

  @override
  String get symptomAnchor1 => 'Barely noticeable';

  @override
  String get symptomAnchor2 => 'Noticeable, not bothersome';

  @override
  String get symptomAnchor3 => 'Bothers occasionally, easy to ignore';

  @override
  String get symptomAnchor4 => 'Distracting, but daily life is normal';

  @override
  String get symptomAnchor5 => 'Clearly bothersome, hard to ignore';

  @override
  String get symptomAnchor6 => 'Hard to concentrate';

  @override
  String get symptomAnchor7 => 'Limits daily life (work, sleep)';

  @override
  String get symptomAnchor8 => 'Hardly able to do anything else';

  @override
  String get symptomAnchor9 => 'Barely bearable';

  @override
  String get symptomAnchor10 => 'Worst imaginable';

  @override
  String get symptomPickerSearchHint => 'Search or type your own';

  @override
  String symptomPickerUseCustom(String value) {
    return 'Use “$value”';
  }

  @override
  String get symptomPickerReflect => 'To reflect: what fits best?';

  @override
  String get symptomPickerMultiHint => 'Select several';

  @override
  String get symptomPickerApply => 'Apply';

  @override
  String get symptomPickerClear => 'Clear';

  @override
  String get symptomDefaultsTitle => 'Typical description';

  @override
  String get symptomDefaultsHint =>
      'Prefilled at every check-in and can be adjusted there.';

  @override
  String get symptomLatestDescription => 'Latest description';

  @override
  String get symptomHeatmapTitle => 'Calendar';

  @override
  String get symptomHeatmapHint =>
      'Color = highest intensity of the day. Tap a day for details.';

  @override
  String symptomHeatmapCell(String date, String value) {
    return '$date: $value/10';
  }

  @override
  String symptomHeatmapCellEmpty(String date) {
    return '$date: no check-in';
  }

  @override
  String get symptomHeatmapLegendEmpty => 'no entry';

  @override
  String get symptomHeatmapNoDay => 'No check-in on this day.';

  @override
  String get symptomHeatmapDayPattern => 'EEEE, MMMM d, y';

  @override
  String get symptomHeatmapCellPattern => 'MMM d, y';

  @override
  String get symptomHeatmapMonthPattern => 'MMM';

  @override
  String symptomHeatmapSemantics(int days) {
    return 'Intensity calendar: $days days with check-ins';
  }

  @override
  String get symptomPickerRecent => 'Recently used';
}
