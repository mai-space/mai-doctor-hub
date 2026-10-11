import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../data/app_database.dart';
import '../../data/repositories/medication_repository.dart';
import '../../data/repositories/symptom_repository.dart';
import '../../data/symptom_description.dart';
import '../../data/symptom_measure.dart';

/// Eine Eingabe direkt am Widget (Einnahme abgehakt, Check-in-Wert getippt).
///
/// Das Widget kann die verschlüsselte Datenbank nicht öffnen. Es merkt sich
/// die Eingabe deshalb in einer Warteschlange (`WidgetStore.kt`), zeigt sie
/// sofort an, und die App trägt sie beim nächsten Start bzw. Wechsel in den
/// Vordergrund nach.
sealed class WidgetAction {
  const WidgetAction(this.id, this.at);

  /// Eindeutige ID (Bestätigung an das Widget).
  final String id;

  /// Zeitpunkt der Eingabe am Widget.
  final DateTime at;

  /// Unbekannte Typen oder kaputte Einträge → `null` (werden verworfen).
  static WidgetAction? fromJson(Object? raw) {
    if (raw is! Map) return null;
    final id = raw['id'];
    final ts = raw['ts'];
    if (id is! String || ts is! int) return null;
    final at = DateTime.fromMillisecondsSinceEpoch(ts);
    switch (raw['type']) {
      case 'intake':
        final med = raw['med'];
        final scheduled = raw['at'];
        if (med is! String || scheduled is! int) return null;
        return IntakeAction(
          id,
          at,
          medicationId: med,
          scheduledFor: DateTime.fromMillisecondsSinceEpoch(scheduled),
        );
      case 'checkin':
        final symptom = raw['symptom'];
        final value = raw['value'];
        if (symptom is! String || value is! num) return null;
        return CheckInAction(
          id,
          at,
          symptomId: symptom,
          value: value.toDouble().clamp(0, 10).toDouble(),
        );
    }
    return null;
  }

  /// Liest die Warteschlange (JSON-Liste); tolerant gegenüber Altlasten.
  static List<WidgetAction> parseQueue(String? raw) {
    if (raw == null || raw.isEmpty) return const [];
    try {
      final list = jsonDecode(raw);
      if (list is! List) return const [];
      return list.map(fromJson).whereType<WidgetAction>().toList();
    } on FormatException {
      return const [];
    }
  }

  /// IDs aller Einträge der Warteschlange — auch unlesbarer, damit sie
  /// bestätigt und damit entfernt werden.
  static List<String> queueIds(String? raw) {
    if (raw == null || raw.isEmpty) return const [];
    try {
      final list = jsonDecode(raw);
      if (list is! List) return const [];
      return [
        for (final e in list)
          if (e is Map && e['id'] is String) e['id'] as String,
      ];
    } on FormatException {
      return const [];
    }
  }
}

/// Geplante Einnahme als genommen markiert.
class IntakeAction extends WidgetAction {
  const IntakeAction(
    super.id,
    super.at, {
    required this.medicationId,
    required this.scheduledFor,
  });

  final String medicationId;
  final DateTime scheduledFor;
}

/// Stärke 0–10 für ein Symptom.
class CheckInAction extends WidgetAction {
  const CheckInAction(
    super.id,
    super.at, {
    required this.symptomId,
    required this.value,
  });

  final String symptomId;
  final double value;
}

/// Trägt [actions] in die Datenbank ein. Gibt die Zahl übernommener
/// Eingaben zurück; bereits erfasste oder verwaiste werden übersprungen.
Future<int> applyWidgetActions(
  AppDatabase db,
  List<WidgetAction> actions,
) async {
  var applied = 0;
  for (final action in actions) {
    try {
      final ok = switch (action) {
        IntakeAction() => await _applyIntake(db, action),
        CheckInAction() => await _applyCheckIn(db, action),
      };
      if (ok) applied++;
    } catch (e) {
      debugPrint('Widget-Eingabe ${action.id}: $e');
    }
  }
  return applied;
}

Future<bool> _applyIntake(AppDatabase db, IntakeAction a) async {
  final med = await (db.select(
    db.medications,
  )..where((t) => t.id.equals(a.medicationId))).getSingleOrNull();
  if (med == null) return false;
  // In der App inzwischen erfasst (genommen oder ausgelassen) → das gilt.
  final existing =
      await (db.select(db.medicationIntakes)
            ..where((t) => t.medicationId.equals(a.medicationId))
            ..where((t) => t.scheduledFor.equals(a.scheduledFor)))
          .get();
  if (existing.isNotEmpty) return false;
  await MedicationRepository(db).recordIntake(
    medicationId: a.medicationId,
    scheduledFor: a.scheduledFor,
    at: a.at,
  );
  return true;
}

Future<bool> _applyCheckIn(AppDatabase db, CheckInAction a) async {
  final repo = SymptomRepository(db);
  final symptom = await repo.getById(a.symptomId);
  if (symptom == null) return false;
  // Doppelt übernommen (z. B. Abbruch vor der Bestätigung)?
  final same =
      await (db.select(db.symptomObservations)
            ..where((t) => t.symptomId.equals(a.symptomId))
            ..where((t) => t.recordedAt.equals(a.at)))
          .get();
  if (same.isNotEmpty) return false;
  // Beschreibung wie im Check-in aus dem Symptom vorbelegen.
  final d = SymptomDescription.fromSymptom(symptom);
  await repo.addMeasurement(
    symptomId: symptom.id,
    measure: SymptomMeasure.intensity,
    value: a.value,
    recordedAt: a.at,
    sensation: d.sensation,
    quality: d.qualityText,
    location: d.location,
    side: d.side,
    pattern: d.patternText,
  );
  return true;
}

/// Ziel beim Tippen auf ein Widget (`WidgetLinks.kt`).
sealed class WidgetLink {
  const WidgetLink();

  static WidgetLink? parse(String? raw) {
    if (raw == null) return null;
    final parts = raw.split('/');
    return switch (parts) {
      ['appointment', final id] when id.isNotEmpty => AppointmentLink(id),
      ['appointments'] => const AppointmentsLink(),
      ['medications'] => const MedicationsLink(),
      ['checkin', final id] when id.isNotEmpty => CheckInLink(id),
      ['checkin'] => const CheckInLink(null),
      _ => null,
    };
  }
}

class AppointmentLink extends WidgetLink {
  const AppointmentLink(this.id);
  final String id;
}

class AppointmentsLink extends WidgetLink {
  const AppointmentsLink();
}

class MedicationsLink extends WidgetLink {
  const MedicationsLink();
}

class CheckInLink extends WidgetLink {
  const CheckInLink(this.symptomId);
  final String? symptomId;
}

