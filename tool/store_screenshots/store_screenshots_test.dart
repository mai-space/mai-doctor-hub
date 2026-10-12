// Erzeugt die Play-Store-Screenshots aus den echten Bildschirmen der App
// mit frei erfundenen Beispieldaten (keine Nutzerdaten).
//
//   flutter test tool/store_screenshots/store_screenshots_test.dart
//
// Ergebnis: store/android/<de-DE|en-US>/phone/*.png (1080 × 1920).
import 'dart:io';
import 'dart:ui' as ui;

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:intl/date_symbol_data_local.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/repositories/appointment_repository.dart';
import 'package:mai_doctor_hub/data/repositories/doctor_repository.dart';
import 'package:mai_doctor_hub/data/repositories/medication_repository.dart';
import 'package:mai_doctor_hub/data/repositories/records_repository.dart';
import 'package:mai_doctor_hub/data/repositories/settings_repository.dart';
import 'package:mai_doctor_hub/data/repositories/symptom_repository.dart';
import 'package:mai_doctor_hub/data/repositories/vaccination_repository.dart';
import 'package:mai_doctor_hub/data/symptom_measure.dart';
import 'package:mai_doctor_hub/features/home/capture_sheet.dart';
import 'package:mai_doctor_hub/features/records/detail_pages.dart';
import 'package:mai_doctor_hub/features/settings/security_section.dart';
import 'package:mai_doctor_hub/features/summary/visit_summary_page.dart';
import 'package:mai_doctor_hub/l10n/l10n.dart';
import 'package:mai_doctor_hub/main.dart';
import 'package:mai_doctor_hub/services/notification_service.dart';

/// Schriften aus dem Flutter-SDK laden, sonst rendert der Test Platzhalter.
Future<void> _loadFonts() async {
  // flutter_tester liegt unter bin/cache/artifacts/engine/<os>/.
  var dir = File(Platform.resolvedExecutable).parent;
  while (!Directory('${dir.path}/material_fonts').existsSync()) {
    dir = dir.parent;
  }
  final fonts = '${dir.path}/material_fonts';
  Future<void> load(String family, List<String> files) async {
    final loader = FontLoader(family);
    for (final f in files) {
      final bytes = File('$fonts/$f').readAsBytesSync();
      loader.addFont(Future.value(ByteData.sublistView(bytes)));
    }
    await loader.load();
  }

  await load('Roboto', [
    'Roboto-Regular.ttf',
    'Roboto-Medium.ttf',
    'Roboto-Bold.ttf',
    'Roboto-Light.ttf',
    'Roboto-Italic.ttf',
  ]);
  await load('MaterialIcons', ['MaterialIcons-Regular.otf']);
}

class _Permissions implements NotificationPermissions {
  @override
  Future<bool> has() async => true;
  @override
  Future<bool> request() async => true;
}


/// Frei erfundene Beispielakte (keine echten Personen oder Befunde).
class _Sample {
  _Sample(this.de);

  final bool de;
  late String symptomId;
  late String diagnosisId;
  late String appointmentId;

  String t(String german, String english) => de ? german : english;

  Future<void> seed(AppDatabase db) async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final doctors = DoctorRepository(db);
    final appointments = AppointmentRepository(db);
    final records = RecordsRepository(db);
    final symptoms = SymptomRepository(db);
    final meds = MedicationRepository(db);

    await SettingsRepository(db).completeOnboarding();

    final family = await doctors.create(
      name: 'Dr. Lena Sommer',
      specialty: t('Allgemeinmedizin', 'General practice'),
      practiceName: t('Hausarztpraxis am Markt', 'Market Square Practice'),
      address: t('Marktstraße 1, Musterstadt', '1 Market Street, Sampletown'),
    );
    final ortho = await doctors.create(
      name: 'Dr. Jonas Wagner',
      specialty: t('Orthopädie', 'Orthopaedics'),
      practiceName: t('Orthopädie im Park', 'Park Orthopaedics'),
    );
    final derma = await doctors.create(
      name: 'Dr. Mia Klein',
      specialty: t('Dermatologie', 'Dermatology'),
    );

    diagnosisId = await records.createDiagnosis(
      title: t('Rückenschmerzen, unterer Rücken', 'Lower back pain'),
      notes: t('Physiotherapie 2× pro Woche', 'Physiotherapy twice a week'),
    );
    await records.createDiagnosis(
      title: t('Heuschnupfen', 'Hay fever'),
    );

    symptomId = await symptoms.create(
      label: t('Rückenschmerzen', 'Back pain'),
      diagnosisId: diagnosisId,
      bodyRegion: t('Unterer Rücken', 'Lower back'),
      measures: (primary: SymptomMeasure.intensity, secondary: null),
    );
    const levels = [7, 7, 6, 8, 6, 6, 5, 6, 5, 5, 4, 5, 4, 4, 3, 4, 3, 3, 2, 3, 2];
    for (var i = 0; i < levels.length; i++) {
      await symptoms.addMeasurement(
        symptomId: symptomId,
        measure: SymptomMeasure.intensity,
        value: levels[i].toDouble(),
        sleepHours: 6.5 + (i % 4) * 0.5,
        energy: 3 + i ~/ 6,
        recordedAt: today.subtract(Duration(days: levels.length - i, hours: -19)),
      );
    }
    final pressure = await symptoms.create(
      label: t('Blutdruck', 'Blood pressure'),
      measures: (primary: SymptomMeasure.bloodPressure, secondary: null),
      cadence: CheckInCadence.weekly,
    );
    await symptoms.addMeasurement(
      symptomId: pressure,
      measure: SymptomMeasure.bloodPressure,
      value: 124,
      value2: 81,
      recordedAt: today.subtract(const Duration(days: 2, hours: -8)),
    );

    appointmentId = await appointments.create(
      doctorId: ortho,
      scheduledAt: today.add(const Duration(days: 2, hours: 9, minutes: 30)),
      title: t('Kontrolle Rücken', 'Back check-up'),
      diagnosisIds: [diagnosisId],
      symptomIds: [symptomId],
    );
    await appointments.create(
      doctorId: family,
      scheduledAt: today.add(const Duration(days: 9, hours: 8, minutes: 15)),
      title: t('Blutabnahme', 'Blood test'),
    );
    await appointments.create(
      doctorId: derma,
      scheduledAt: today.add(const Duration(days: 23, hours: 14)),
      title: t('Hautkrebs-Vorsorge', 'Skin check'),
    );
    await appointments.create(
      doctorId: ortho,
      scheduledAt: today.subtract(const Duration(days: 19, hours: -10)),
      title: t('Erstuntersuchung', 'First visit'),
      diagnosisIds: [diagnosisId],
    );
    await appointments.create(
      doctorId: family,
      scheduledAt: today.subtract(const Duration(days: 40, hours: -11)),
      title: t('Check-up', 'Check-up'),
    );

    // Abendtablette bleibt offen: „1 von 2 genommen“.
    await meds.save(
      name: 'Cetirizin',
      strength: '10 mg',
      form: MedicationForm.tablet,
      doseAmount: 1,
      doseUnit: t('Stück', 'tablet'),
      prescriberId: family,
      startedAt: today.subtract(const Duration(days: 30)),
      schedules: const [ScheduleInput(hour: 20, minute: 0)],
    );
    final vitamin = await meds.save(
      name: 'Vitamin D3',
      strength: '1000 IE',
      form: MedicationForm.tablet,
      doseAmount: 1,
      doseUnit: t('Stück', 'tablet'),
      startedAt: today.subtract(const Duration(days: 60)),
      schedules: const [ScheduleInput(hour: 8, minute: 0)],
    );
    await meds.save(
      name: 'Ibuprofen',
      strength: '400 mg',
      form: MedicationForm.tablet,
      instructions: t('bei Bedarf, nach dem Essen', 'as needed, after meals'),
      prescriberId: ortho,
      diagnosisId: diagnosisId,
    );
    await meds.recordIntake(
      medicationId: vitamin,
      scheduledFor: today.add(const Duration(hours: 8)),
    );

    await VaccinationRepository(db).save(
      vaccine: t('Tetanus/Diphtherie', 'Tetanus/diphtheria'),
      administeredAt: DateTime(today.year - 3, 5, 12),
      doctorId: family,
      nextDueAt: DateTime(today.year + 7, 5, 12),
    );
    await records.createNote(
      body: t(
        'Physio: Übungen für den unteren Rücken täglich 10 Minuten.',
        'Physio: lower back exercises, 10 minutes daily.',
      ),
      relatedDiagnosisId: diagnosisId,
    );
  }
}

const _languages = {'de-DE': Locale('de', 'DE'), 'en-US': Locale('en', 'US')};

void main() {
  setUpAll(() async {
    await initializeDateFormatting();
    await _loadFonts();
    NotificationPermissions.current = _Permissions();
  });

  for (final MapEntry(key: folder, value: locale) in _languages.entries) {
    final de = locale.languageCode == 'de';

    Future<void> shot(
      String name,
      Future<void> Function(WidgetTester tester, _Sample sample) open,
    ) async {
      testWidgets('$folder $name', (tester) async {
        tester.view.physicalSize = const Size(1080, 1920);
        tester.view.devicePixelRatio = 2.625;
        addTearDown(tester.view.reset);
        tester.platformDispatcher.localesTestValue = [locale];
        tester.platformDispatcher.localeTestValue = locale;
        addTearDown(tester.platformDispatcher.clearAllTestValues);
        AppLocale.update(de ? AppLocale.german : AppLocale.english);
        // Tests zeichnen Schatten sonst als schwarzen Rahmen.
        debugDisableShadows = false;

        final db = AppDatabase(NativeDatabase.memory());
        final sample = _Sample(de);
        await tester.runAsync(() => sample.seed(db));
        await tester.pumpWidget(
          RepaintBoundary(
            key: const ValueKey('shot'),
            child: MaiDoctorHubApp(database: db),
          ),
        );
        await _settle(tester);
        await open(tester, sample);
        await _settle(tester);

        final boundary = tester.renderObject<RenderRepaintBoundary>(
          find.byKey(const ValueKey('shot')),
        );
        await tester.runAsync(() async {
          final image = await boundary.toImage(pixelRatio: 2.625);
          final data = await image.toByteData(format: ui.ImageByteFormat.png);
          final file = File('store/android/$folder/phone/$name.png');
          file.parent.createSync(recursive: true);
          // Play nimmt Screenshots nur ohne Alphakanal (24-Bit-PNG).
          final rgba = img.decodePng(data!.buffer.asUint8List())!;
          file.writeAsBytesSync(img.encodePng(rgba.convert(numChannels: 3)));
        });

        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pump(const Duration(milliseconds: 100));
        await db.close();
        debugDisableShadows = true;
      });
    }

    Future<void> push(WidgetTester tester, Widget page) async {
      appNavigatorKey.currentState!.push(
        MaterialPageRoute<void>(builder: (_) => page),
      );
      await _settle(tester);
    }

    Future<void> tab(WidgetTester tester, IconData icon) async {
      await tester.tap(find.byIcon(icon));
      await _settle(tester);
    }

    shot('01_home', (tester, s) async {});
    shot('02_symptom_verlauf', (tester, s) async {
      await push(tester, SymptomDetailPage(symptomId: s.symptomId));
    });
    shot('05_akte', (tester, s) async {
      await tab(tester, Icons.folder_open_outlined);
    });
    shot('06_kalender', (tester, s) async {
      await tab(tester, Icons.calendar_month_outlined);
    });
    shot('07_diagnose', (tester, s) async {
      await push(tester, DiagnosisDetailPage(diagnosisId: s.diagnosisId));
    });
    shot('04_arztbesuch', (tester, s) async {
      await push(tester, VisitSummaryPage(appointmentId: s.appointmentId));
    });
    shot('03_erfassen', (tester, s) async {
      final context = appNavigatorKey.currentContext!;
      showCaptureSheet(context);
      await _settle(tester);
    });
    shot('08_sicherheit', (tester, s) async {
      await tab(tester, Icons.settings_outlined);
      final section = find.byType(SecuritySection);
      await tester.scrollUntilVisible(
        section,
        300,
        scrollable: find.byType(Scrollable).last,
      );
      await tester.runAsync(
        // Sicherheit unten am Rand: darüber Kalender-Export (opt-in).
        () => Scrollable.ensureVisible(tester.element(section), alignment: 1),
      );
    });
  }
}

/// Datenbank-Abfragen laufen asynchron; Animationen auslaufen lassen.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 8; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 30)),
    );
    await tester.pump(const Duration(milliseconds: 100));
  }
}
