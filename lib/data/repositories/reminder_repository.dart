import 'package:drift/drift.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:uuid/uuid.dart';

import '../../l10n/l10n.dart';
import '../app_database.dart';

const _uuid = Uuid();

/// Wochentage als Bitmaske: Mo=1 … So=64.
abstract final class Weekdays {
  static const all = 127;
  static const workdays = 31;

  /// Kurznamen Mo … So in der App-Sprache („Mo“, „Di“ … / „Mon“, „Tue“ …).
  static List<String> get labels {
    // Intl liefert Sonntag zuerst.
    final names = DateFormat().dateSymbols.STANDALONESHORTWEEKDAYS;
    return [...names.skip(1), names.first];
  }

  /// [weekday] wie `DateTime.weekday` (1 = Montag).
  static bool contains(int mask, int weekday) =>
      mask & (1 << (weekday - 1)) != 0;

  static int toggle(int mask, int weekday) => mask ^ (1 << (weekday - 1));

  static List<int> days(int mask) => [
    for (var d = 1; d <= 7; d++)
      if (contains(mask, d)) d,
  ];

  static String describe(int mask) {
    final t = AppLocale.strings;
    if (mask & all == all) return t.homeWeekdaysDaily;
    if (mask == workdays) return t.homeWeekdaysWorkdays;
    if (mask == 96) return t.homeWeekdaysWeekend;
    final names = labels;
    return [for (final d in days(mask)) names[d - 1]].join(', ');
  }
}

class ReminderWithSymptoms {
  const ReminderWithSymptoms(this.reminder, this.symptoms);

  final Reminder reminder;

  /// Leer = gilt für alle offenen Symptome.
  final List<Symptom> symptoms;
}

class ReminderRepository {
  ReminderRepository(this._db);

  final AppDatabase _db;

  Stream<List<ReminderWithSymptoms>> watchAll() =>
      _db.watchWith({_db.reminders, _db.reminderSymptoms, _db.symptoms}, all);

  Future<List<ReminderWithSymptoms>> all() async {
    final reminders =
        await (_db.select(_db.reminders)..orderBy([
              (t) => OrderingTerm.asc(t.hour),
              (t) => OrderingTerm.asc(t.minute),
            ]))
            .get();
    final links =
        await (_db.select(_db.reminderSymptoms).join([
          innerJoin(
            _db.symptoms,
            _db.symptoms.id.equalsExp(_db.reminderSymptoms.symptomId),
          ),
        ])..where(_db.symptoms.archivedAt.isNull())).get();
    final byReminder = <String, List<Symptom>>{};
    for (final row in links) {
      byReminder
          .putIfAbsent(row.readTable(_db.reminderSymptoms).reminderId, () => [])
          .add(row.readTable(_db.symptoms));
    }
    return [
      for (final r in reminders) ReminderWithSymptoms(r, byReminder[r.id] ?? []),
    ];
  }

  Future<String> create({
    required String title,
    String? body,
    required int hour,
    required int minute,
    int weekdays = Weekdays.all,
    List<String> symptomIds = const [],
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    await _db.transaction(() async {
      final maxSlot = _db.reminders.slot.max();
      final row = await (_db.selectOnly(
        _db.reminders,
      )..addColumns([maxSlot])).getSingle();
      await _db
          .into(_db.reminders)
          .insert(
            RemindersCompanion.insert(
              id: id,
              slot: (row.read(maxSlot) ?? 0) + 1,
              title: title,
              body: Value(body),
              hour: hour,
              minute: minute,
              weekdays: Value(weekdays == 0 ? Weekdays.all : weekdays),
              createdAt: now,
              updatedAt: now,
            ),
          );
      await _replaceSymptoms(id, symptomIds);
    });
    return id;
  }

  Future<void> update({
    required String id,
    required String title,
    String? body,
    required int hour,
    required int minute,
    required int weekdays,
    required List<String> symptomIds,
  }) async {
    await _db.transaction(() async {
      await (_db.update(_db.reminders)..where((t) => t.id.equals(id))).write(
        RemindersCompanion(
          title: Value(title),
          body: Value(body),
          hour: Value(hour),
          minute: Value(minute),
          weekdays: Value(weekdays == 0 ? Weekdays.all : weekdays),
          updatedAt: Value(DateTime.now()),
        ),
      );
      await _replaceSymptoms(id, symptomIds);
    });
  }

  Future<void> setEnabled(String id, bool enabled) =>
      (_db.update(_db.reminders)..where((t) => t.id.equals(id))).write(
        RemindersCompanion(
          enabled: Value(enabled),
          updatedAt: Value(DateTime.now()),
        ),
      );

  Future<void> delete(String id) => _db.transaction(() async {
    await (_db.delete(
      _db.reminderSymptoms,
    )..where((t) => t.reminderId.equals(id))).go();
    await (_db.delete(_db.reminders)..where((t) => t.id.equals(id))).go();
  });

  Future<void> _replaceSymptoms(String id, List<String> symptomIds) async {
    await (_db.delete(
      _db.reminderSymptoms,
    )..where((t) => t.reminderId.equals(id))).go();
    for (final symptomId in symptomIds.toSet()) {
      await _db
          .into(_db.reminderSymptoms)
          .insert(
            ReminderSymptomsCompanion.insert(
              reminderId: id,
              symptomId: symptomId,
            ),
          );
    }
  }
}
