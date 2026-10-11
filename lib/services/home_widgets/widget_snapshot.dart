import 'package:drift/drift.dart';

import '../../data/app_database.dart';
import '../../data/repositories/appointment_repository.dart';
import '../../data/repositories/medication_repository.dart';
import '../../data/symptom_measure.dart';

/// Version des Snapshot-Formats (`WidgetSnapshot.kt` liest sie mit).
/// Nur erweitern: neue Felder sind optional, alte behalten ihre Bedeutung.
const widgetSnapshotVersion = 1;

/// Wie viele Tage Einnahmen der Snapshot vorausträgt — so stimmt „Heute“
/// auch dann, wenn die App ein paar Tage nicht geöffnet wurde.
const widgetDoseDays = 7;

/// Diskret, wenn so eingestellt; automatisch (`null`), solange die
/// App-Sperre an ist.
bool widgetsDiscreet(AppSetting settings) =>
    settings.widgetDiscreet ?? settings.appLockEnabled;

/// Baut den Inhalt der Startbildschirm-Widgets.
///
/// Der Snapshot liegt **unverschlüsselt** in den App-Einstellungen von
/// Android (außerhalb der verschlüsselten Datenbank), damit das Widget ohne
/// Entsperren gezeichnet werden kann. Deshalb steht darin nur das Nötigste,
/// und im diskreten Modus gar kein Klartext: keine Arzt-, Medikamenten- oder
/// Symptomnamen, keine Titel — nur IDs, Zeiten und Zahlen.
Future<Map<String, Object?>> buildWidgetSnapshot(
  AppDatabase db, {
  DateTime? now,
}) async {
  final clock = now ?? DateTime.now();
  final settings = await (db.select(
    db.appSettings,
  )..where((t) => t.id.equals(1))).getSingleOrNull();
  final discreet = settings == null ? true : widgetsDiscreet(settings);
  return {
    'v': widgetSnapshotVersion,
    'discreet': discreet,
    'generatedAt': clock.millisecondsSinceEpoch,
    'appointments': await _appointments(db, clock, discreet),
    'doses': await _doses(db, clock, discreet),
    'dosesUntil': DateTime(
      clock.year,
      clock.month,
      clock.day + widgetDoseDays,
    ).millisecondsSinceEpoch,
    'checkIn': await _checkIn(db, clock, discreet),
  };
}

/// Nächste geplante Termine (laufende eingeschlossen).
Future<List<Map<String, Object?>>> _appointments(
  AppDatabase db,
  DateTime now,
  bool discreet,
) async {
  final rows =
      await (db.selectActive(db.appointments)
            ..where(
              (t) => t.scheduledAt.isBiggerOrEqualValue(
                now.subtract(const Duration(hours: 12)),
              ),
            )
            ..where((t) => t.status.equalsValue(AppointmentStatus.planned))
            ..orderBy([(t) => OrderingTerm.asc(t.scheduledAt)])
            ..limit(8))
          .get();
  final summaries = await AppointmentRepository(db).summariesFor(rows);
  final result = <Map<String, Object?>>[];
  for (final s in summaries) {
    final a = s.appointment;
    final end = a.scheduledAt.add(Duration(minutes: a.durationMin ?? 60));
    if (!end.isAfter(now)) continue;
    result.add({
      'id': a.id,
      'at': a.scheduledAt.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
      if (!discreet) 'doctor': s.doctorName,
      if (!discreet && (a.title?.trim().isNotEmpty ?? false))
        'title': a.title!.trim(),
    });
    if (result.length >= 4) break;
  }
  return result;
}

/// Geplante Einnahmen von heute bis [widgetDoseDays] Tage voraus.
Future<List<Map<String, Object?>>> _doses(
  AppDatabase db,
  DateTime now,
  bool discreet,
) async {
  final repo = MedicationRepository(db);
  final result = <Map<String, Object?>>[];
  for (var i = 0; i < widgetDoseDays; i++) {
    final day = DateTime(now.year, now.month, now.day + i);
    for (final dose in await repo.dosesOn(day)) {
      result.add({
        'med': dose.details.medication.id,
        'at': dose.at.millisecondsSinceEpoch,
        if (dose.intake != null) 'status': dose.intake!.status.name,
        if (!discreet) 'name': dose.details.medication.name,
        if (!discreet && dose.details.doseFor(dose.schedule) != null)
          'dose': dose.details.doseFor(dose.schedule),
      });
    }
  }
  return result;
}

/// Symptom für den Schnell-Check-in: das zuletzt erfasste offene Symptom,
/// sonst das zuletzt angelegte.
Future<Map<String, Object?>?> _checkIn(
  AppDatabase db,
  DateTime now,
  bool discreet,
) async {
  final open =
      await (db.selectActive(db.symptoms)
            ..where((t) => t.healedAt.isNull())
            ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
          .get();
  if (open.isEmpty) return null;
  final latest = <String, SymptomObservation>{};
  for (final s in open) {
    final o =
        await (db.select(db.symptomObservations)
              ..where((t) => t.symptomId.equals(s.id))
              ..orderBy([(t) => OrderingTerm.desc(t.recordedAt)])
              ..limit(1))
            .getSingleOrNull();
    if (o != null) latest[s.id] = o;
  }
  final ranked = [...open]
    ..sort((a, b) {
      final la = latest[a.id]?.recordedAt;
      final lb = latest[b.id]?.recordedAt;
      if (la == null && lb == null) return 0;
      if (la == null) return 1;
      if (lb == null) return -1;
      return lb.compareTo(la);
    });
  final symptom = ranked.first;
  final last = latest[symptom.id];
  final measures = symptomMeasures(symptom);
  // Schnell-Check-in nur für die Stärke 0–10. Andere Messgrößen und
  // psychische Symptome (Hilfsangebot, Tagebuch) öffnen den Check-in.
  final quick =
      measures.primary == SymptomMeasure.intensity && !isPsychSymptom(symptom);
  return {
    'symptom': symptom.id,
    'quick': quick,
    'open': open.length,
    if (!discreet) 'label': symptom.label,
    if (last != null) 'lastAt': last.recordedAt.millisecondsSinceEpoch,
    if (last != null &&
        observationMeasure(last) == SymptomMeasure.intensity &&
        last.valueNumber != null)
      'lastValue': last.valueNumber!.round(),
  };
}
