import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/appointment_repository.dart';
import '../../data/repositories/medication_repository.dart';
import '../../data/repositories/vaccination_repository.dart';
import '../../l10n/l10n.dart';
import '../check_in/check_in_sheet.dart';
import '../medications/intake_widgets.dart';
import '../records/detail_pages.dart' show VaccinationDetailPage;
import 'appointment_detail_page.dart';

/// Was die Karte „Heute“ braucht (eine Abfrage je Datenänderung).
class TodayData {
  const TodayData({
    this.doses = const [],
    this.openSymptoms = 0,
    this.dueCheckIns = const [],
    this.dueVaccinations = const [],
  });

  final List<PlannedDose> doses;

  /// Anzahl offener Symptome (auch ohne fälligen Check-in).
  final int openSymptoms;

  /// Offene Symptome ohne Check-in im fälligen Zeitraum.
  final List<Symptom> dueCheckIns;
  final List<Vaccination> dueVaccinations;

  int get dosesTaken =>
      doses.where((d) => d.intake?.status == IntakeStatus.taken).length;
  bool get dosesOpen => doses.any((d) => !d.done);

  /// Es gibt überhaupt etwas, das heute verfolgt wird.
  bool get tracksSomething => doses.isNotEmpty || openSymptoms > 0;
}

/// Lädt [TodayData] für [day] — fällige Check-ins: täglich/stündlich/
/// individuell = heute noch keiner, wöchentlich = seit 7 Tagen keiner.
Future<TodayData> loadTodayData(AppDatabase db, DateTime day) async {
  final start = DateTime(day.year, day.month, day.day);
  final weekAgo = start.subtract(const Duration(days: 6));
  final doses = await MedicationRepository(db).dosesOn(start);
  final open =
      await (db.selectActive(db.symptoms)
            ..where((t) => t.healedAt.isNull())
            ..orderBy([(t) => OrderingTerm.asc(t.label)]))
          .get();
  final recent = await (db.select(
    db.symptomObservations,
  )..where((t) => t.recordedAt.isBiggerOrEqualValue(weekAgo))).get();
  final last = <String, DateTime>{};
  for (final o in recent) {
    final prev = last[o.symptomId];
    if (prev == null || o.recordedAt.isAfter(prev)) {
      last[o.symptomId] = o.recordedAt;
    }
  }
  final due = [
    for (final s in open)
      if (switch (s.checkInCadence) {
        CheckInCadence.weekly => last[s.id] == null,
        _ => last[s.id]?.isBefore(start) ?? true,
      })
        s,
  ];
  final vaccinations = await VaccinationRepository(db)
      .due(within: const Duration(days: 30), now: day);
  return TodayData(
    doses: doses,
    openSymptoms: open.length,
    dueCheckIns: due,
    dueVaccinations: vaccinations,
  );
}

/// Startseite: nur, was heute ansteht — höchstens vier Zeilen, jede
/// antippbar. Ist nichts offen: „Alles erledigt für heute ✓“.
class TodayCard extends StatefulWidget {
  const TodayCard({super.key, this.nextAppointment, this.hasTimeline = false});

  /// Nächster geplanter Termin (aus der Timeline der Startseite).
  final AppointmentSummary? nextAppointment;

  /// Es gibt Termine — dann auch „Alles erledigt“ zeigen, wenn sonst
  /// nichts verfolgt wird. Ganz neue Nutzer sehen stattdessen nur den
  /// Leerzustand.
  final bool hasTimeline;

  @override
  State<TodayCard> createState() => _TodayCardState();
}

class _TodayCardState extends State<TodayCard> {
  /// Termine bis eine Woche voraus gelten als „heute relevant“.
  static const _appointmentHorizonDays = 7;

  Stream<TodayData>? _stream;
  DateTime? _day;

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subscribe();
  }

  /// Stream je Kalendertag — nach Mitternacht neu (die Startseite baut
  /// minütlich neu, siehe Timeline-Uhr).
  void _subscribe() {
    final today = _today();
    if (_stream != null && _day == today) return;
    _day = today;
    final db = DatabaseScope.of(context);
    _stream = db.watchWith({
      ...MedicationRepository(db).tables,
      db.symptoms,
      db.symptomObservations,
      db.vaccinations,
    }, () => loadTodayData(db, today));
  }

  @override
  Widget build(BuildContext context) {
    _subscribe();
    return StreamBuilder<TodayData>(
      stream: _stream,
      builder: (context, snapshot) {
        final data = snapshot.data;
        if (data == null) return const SizedBox.shrink();
        final rows = _rows(context, data);
        if (rows.isEmpty && !data.tracksSomething && !widget.hasTimeline) {
          return const SizedBox.shrink();
        }
        final theme = Theme.of(context);
        return Card(
          key: const ValueKey('home-today-card'),
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 2),
                  child: Text(
                    context.l10n.homeTodayTitle,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                if (rows.isEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
                    child: Text(
                      context.l10n.homeTodayAllDone,
                      style: theme.textTheme.bodyLarge,
                    ),
                  )
                else
                  ...rows.take(4),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _rows(BuildContext context, TodayData data) {
    final l10n = context.l10n;
    final rows = <Widget>[];

    // Medikamente mit Fortschritt und schnellem Abhaken der nächsten Dosis.
    if (data.dosesOpen) {
      final next = data.doses.firstWhere((d) => !d.done);
      final time = DateFormat(l10n.homeTimePattern).format(next.at);
      final repo = MedicationRepository(DatabaseScope.of(context));
      rows.add(
        _TodayRow(
          key: const ValueKey('today-meds'),
          icon: Icons.medication_outlined,
          title: l10n.entityMedications,
          subtitle: l10n.homeTodayMedsProgress(
            data.dosesTaken,
            data.doses.length,
          ),
          progress: data.dosesTaken / data.doses.length,
          onTap: () => showTodayMedicationsSheet(context),
          trailing: IconButton.filledTonal(
            key: const ValueKey('today-meds-take'),
            tooltip: l10n.homeTodayMedsQuickTake(
              next.details.medication.name,
              time,
            ),
            icon: const Icon(Icons.check),
            onPressed: () => repo.recordIntake(
              medicationId: next.details.medication.id,
              scheduledFor: next.at,
              doseAmount:
                  next.schedule.doseAmount ??
                  next.details.medication.doseAmount,
            ),
          ),
        ),
      );
    }

    // Offene Check-ins.
    if (data.dueCheckIns.isNotEmpty) {
      final names = data.dueCheckIns.map((s) => s.label).toList();
      final shown = names.take(2).join(', ');
      final more = names.length > 2
          ? ' ${l10n.homeTodayMore(names.length - 2)}'
          : '';
      rows.add(
        _TodayRow(
          key: const ValueKey('today-checkins'),
          icon: Icons.favorite_outline,
          title: l10n.homeTodayCheckInsTitle,
          subtitle: l10n.homeTodayCheckInsOpen('$shown$more'),
          onTap: () => showCheckInSheet(
            context,
            symptomIds: [for (final s in data.dueCheckIns) s.id],
          ),
        ),
      );
    }

    // Nächster Termin (bis eine Woche voraus).
    final next = widget.nextAppointment;
    if (next != null) {
      final at = next.appointment.scheduledAt;
      final days = DateTime(
        at.year,
        at.month,
        at.day,
      ).difference(_day ?? _today()).inDays;
      if (days >= 0 && days <= _appointmentHorizonDays) {
        final when = switch (days) {
          0 => l10n.homeTodayAppointmentToday,
          1 => l10n.homeTodayAppointmentTomorrow,
          _ => l10n.homeTodayAppointmentInDays(days),
        };
        rows.add(
          _TodayRow(
            key: const ValueKey('today-appointment'),
            icon: Icons.event_outlined,
            title: l10n.homeTodayAppointmentTitle,
            subtitle: [
              when,
              next.doctorName,
              DateFormat(l10n.homeTimePattern).format(at),
            ].join(' · '),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) =>
                    AppointmentDetailPage(appointmentId: next.appointment.id),
              ),
            ),
          ),
        );
      }
    }

    // Fällige Impfungen (bis 30 Tage voraus).
    if (data.dueVaccinations.isNotEmpty) {
      final first = data.dueVaccinations.first;
      rows.add(
        _TodayRow(
          key: const ValueKey('today-vaccinations'),
          icon: Icons.vaccines_outlined,
          title: l10n.homeTodayVaccinationsTitle,
          subtitle: data.dueVaccinations.map((v) => v.vaccine).join(', '),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => VaccinationDetailPage(vaccinationId: first.id),
            ),
          ),
        ),
      );
    }
    return rows;
  }
}

class _TodayRow extends StatelessWidget {
  const _TodayRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.trailing,
    this.progress,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Widget? trailing;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: theme.colorScheme.primary),
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
          if (progress != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: LinearProgressIndicator(
                value: progress,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
        ],
      ),
      trailing: trailing ?? const Icon(Icons.chevron_right),
    );
  }
}
