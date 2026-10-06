import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../data/app_database.dart';
import '../data/repositories/appointment_repository.dart';
import '../data/repositories/medication_repository.dart';
import '../data/repositories/symptom_repository.dart';
import '../data/repositories/vaccination_repository.dart';
import '../data/symptom_description.dart';
import '../l10n/l10n.dart';
import '../widgets/symptom_report_card.dart' show observationLabel;

/// Was in die Zusammenfassung soll.
class VisitSummaryOptions {
  const VisitSummaryOptions({
    this.appointmentId,
    this.symptomIds,
    this.medicationIds,
    this.includeDiagnoses = true,
    this.includeVaccinations = true,
    this.questions = '',
    this.patientName,
  });

  /// Bezugstermin: bestimmt Arzt und Zeitraum der Symptom-Verläufe.
  final String? appointmentId;

  /// `null` = alle offenen Symptome bzw. aktuellen Medikamente.
  final Set<String>? symptomIds;
  final Set<String>? medicationIds;
  final bool includeDiagnoses;
  final bool includeVaccinations;
  final String questions;
  final String? patientName;
}

class SymptomTrend {
  const SymptomTrend(this.symptom, this.observations);

  final Symptom symptom;
  final List<SymptomObservation> observations;

  List<double> get scale => [
    for (final o in observations)
      if (o.kind == ObservationKind.scale_1_10 && o.valueNumber != null)
        o.valueNumber!,
  ];

  double? get average =>
      scale.isEmpty ? null : scale.reduce((a, b) => a + b) / scale.length;
}

class VisitSummaryData {
  const VisitSummaryData({
    required this.generatedAt,
    required this.from,
    required this.to,
    required this.questions,
    required this.diagnoses,
    required this.symptoms,
    required this.medications,
    required this.vaccinations,
    required this.dueVaccinations,
    this.appointment,
    this.patientName,
  });

  final DateTime generatedAt;
  final DateTime from;
  final DateTime to;
  final AppointmentSummary? appointment;
  final String? patientName;
  final List<String> questions;
  final List<Diagnose> diagnoses;
  final List<SymptomTrend> symptoms;
  final List<MedicationDetails> medications;
  final List<Vaccination> vaccinations;
  final List<Vaccination> dueVaccinations;
}

/// Stellt die Daten für den Arztbesuch zusammen.
class VisitSummaryBuilder {
  VisitSummaryBuilder(this._db);

  final AppDatabase _db;

  Future<VisitSummaryData> build(
    VisitSummaryOptions options, {
    DateTime? now,
  }) async {
    final current = now ?? DateTime.now();
    final appointments = AppointmentRepository(_db);
    final appointment = options.appointmentId == null
        ? null
        : await appointments.summaryFor(options.appointmentId!);

    DateTime from;
    DateTime to;
    if (appointment != null) {
      (from, to) = await appointments.reportWindow(
        appointment.appointment,
        now: current,
      );
    } else {
      from = current.subtract(const Duration(days: 30));
      to = current.add(const Duration(seconds: 1));
    }

    // Fragen: Freitext (eine pro Zeile) + Notizen zum Termin.
    final questions = [
      for (final line in options.questions.split('\n'))
        if (line.trim().isNotEmpty) line.trim(),
      if (appointment != null)
        for (final n in await (_db.selectActive(_db.notes)
              ..where(
                (t) => t.relatedAppointmentId.equals(appointment.appointment.id),
              ))
            .get())
          n.body.trim(),
    ];

    final symptomRepo = SymptomRepository(_db);
    final allSymptoms = await symptomRepo.watchAll().first;
    final chosenSymptoms = options.symptomIds == null
        ? allSymptoms.where((s) => s.healedAt == null)
        : allSymptoms.where((s) => options.symptomIds!.contains(s.id));
    final symptoms = [
      for (final s in chosenSymptoms)
        SymptomTrend(s, await symptomRepo.observationsBetween(s.id, from, to)),
    ];

    final medications = (await MedicationRepository(_db).all()).where(
      (m) => options.medicationIds == null
          ? m.isActiveOn(current)
          : options.medicationIds!.contains(m.medication.id),
    );

    final vaccinationRepo = VaccinationRepository(_db);
    return VisitSummaryData(
      generatedAt: current,
      from: from,
      to: to,
      appointment: appointment,
      patientName: options.patientName?.trim().isEmpty == true
          ? null
          : options.patientName?.trim(),
      questions: questions,
      diagnoses: options.includeDiagnoses
          ? await (_db.selectActive(_db.diagnoses)
                  ..where((t) => t.status.equalsValue(DiagnosisStatus.active))
                  ..orderBy([(t) => OrderingTerm.asc(t.title)]))
                .get()
          : const [],
      symptoms: symptoms,
      medications: medications.toList(),
      vaccinations: options.includeVaccinations
          ? await vaccinationRepo.all()
          : const [],
      dueVaccinations: options.includeVaccinations
          ? await vaccinationRepo.due(now: current)
          : const [],
    );
  }
}

/// Rendert die Zusammenfassung als A4-PDF.
abstract final class VisitSummaryPdf {
  static String fileName(VisitSummaryData data) =>
      AppLocale.strings.svcSummaryPdfFileName(
        DateFormat('yyyy-MM-dd').format(
          data.appointment?.appointment.scheduledAt ?? data.generatedAt,
        ),
      );

  static Future<Uint8List> render(VisitSummaryData data) {
    final l10n = AppLocale.strings;
    final date = DateFormat(l10n.svcSummaryPdfDatePattern);
    final dateTime = DateFormat(l10n.svcSummaryPdfDateTimePattern);
    final decimalSeparator = NumberFormat().symbols.DECIMAL_SEP;
    final doc = pw.Document(
      title: l10n.svcSummaryPdfTitle,
      creator: 'Mai Doctor Hub',
    );
    final a = data.appointment;
    final heading = pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold);
    final muted = const pw.TextStyle(fontSize: 9, color: PdfColors.grey700);

    pw.Widget section(String title, List<pw.Widget> children) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 14),
        pw.Text(title, style: heading),
        pw.Divider(thickness: 0.5),
        ...children,
      ],
    );

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(36),
        footer: (context) => pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              l10n.svcSummaryPdfFooter(date.format(data.generatedAt)),
              style: muted,
            ),
            pw.Text('${context.pageNumber}/${context.pagesCount}', style: muted),
          ],
        ),
        build: (context) => [
          pw.Text(
            l10n.svcSummaryPdfTitle,
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            [
              ?data.patientName,
              if (a != null)
                l10n.svcSummaryPdfAppointment(
                  date.format(a.appointment.scheduledAt),
                  a.doctorName,
                ),
              l10n.svcSummaryPdfPeriod(
                date.format(data.from),
                date.format(data.to),
              ),
            ].join(' · '),
          ),
          if (data.questions.isNotEmpty)
            section(l10n.svcSummaryPdfQuestions, [
              for (final q in data.questions) pw.Bullet(text: q),
            ]),
          if (data.diagnoses.isNotEmpty)
            section(l10n.svcSummaryPdfDiagnoses, [
              for (final d in data.diagnoses)
                pw.Bullet(
                  text: [
                    d.title,
                    if (d.startedAt != null)
                      l10n.svcSince(date.format(d.startedAt!)),
                  ].join(' · '),
                ),
            ]),
          if (data.symptoms.isNotEmpty)
            section(l10n.entitySymptoms, [
              for (final t in data.symptoms) ...[
                pw.SizedBox(height: 6),
                pw.Text(
                  [
                    t.symptom.label,
                    // Standard-Beschreibung inkl. Ort, z. B. „Schmerz
                    // (brennend) · Hinterkopf (links)“.
                    if (!SymptomDescription.fromSymptom(t.symptom).isEmpty)
                      SymptomDescription.fromSymptom(t.symptom).describe(l10n),
                    t.symptom.healedAt == null
                        ? l10n.svcSummaryPdfActive
                        : l10n.svcSummaryPdfResolved,
                  ].join(' · '),
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                pw.Text(
                  t.observations.isEmpty
                      ? l10n.svcSummaryPdfNoCheckIns
                      : [
                          l10n.svcCheckInCount(t.observations.length),
                          if (t.average != null)
                            l10n.svcSummaryPdfStats(
                              t.average!
                                  .toStringAsFixed(1)
                                  .replaceAll('.', decimalSeparator),
                              t.scale
                                  .reduce((a, b) => a < b ? a : b)
                                  .toStringAsFixed(0),
                              t.scale
                                  .reduce((a, b) => a > b ? a : b)
                                  .toStringAsFixed(0),
                              t.scale.last.toStringAsFixed(0),
                            ),
                        ].join(' · '),
                  style: muted,
                ),
                if (t.observations.isNotEmpty)
                  pw.TableHelper.fromTextArray(
                    headers: [
                      l10n.svcSummaryPdfDate,
                      l10n.svcSummaryPdfValue,
                      l10n.entityNote,
                    ],
                    cellStyle: const pw.TextStyle(fontSize: 9),
                    headerStyle: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                    ),
                    data: [
                      for (final o in t.observations.reversed.take(14))
                        [
                          dateTime.format(o.recordedAt),
                          observationLabel(o),
                          o.note ?? '',
                        ],
                    ],
                  ),
              ],
            ]),
          if (data.medications.isNotEmpty)
            section(l10n.svcCurrentMedications, [
              pw.TableHelper.fromTextArray(
                headers: [
                  l10n.entityMedication,
                  l10n.svcSummaryPdfDose,
                  l10n.svcSummaryPdfIntake,
                  l10n.svcSummaryPdfSinceUntil,
                ],
                cellStyle: const pw.TextStyle(fontSize: 9),
                headerStyle: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
                data: [
                  for (final m in data.medications)
                    [
                      [
                        m.medication.name,
                        ?m.medication.dosage,
                        if (m.medication.form != null)
                          medicationFormLabel(m.medication.form!),
                      ].join(' '),
                      m.doseFor(null) ?? '',
                      [
                        ?m.medication.scheduleText,
                        ?m.medication.instructions,
                      ].join(' · '),
                      [
                        if (m.medication.startedAt != null)
                          date.format(m.medication.startedAt!),
                        if (m.medication.endedAt != null)
                          date.format(m.medication.endedAt!),
                      ].join(' – '),
                    ],
                ],
              ),
            ]),
          if (data.vaccinations.isNotEmpty)
            section(l10n.entityVaccinations, [
              pw.TableHelper.fromTextArray(
                headers: [
                  l10n.svcSummaryPdfDate,
                  l10n.entityVaccination,
                  l10n.svcSummaryPdfProductBatch,
                  l10n.svcSummaryPdfNextDue,
                ],
                cellStyle: const pw.TextStyle(fontSize: 9),
                headerStyle: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
                data: [
                  for (final v in data.vaccinations)
                    [
                      date.format(v.administeredAt),
                      [
                        v.vaccine,
                        if (v.doseNumber != null) '(${v.doseNumber}.)',
                      ].join(' '),
                      [?v.product, ?v.batch].join(' / '),
                      v.nextDueAt == null ? '' : date.format(v.nextDueAt!),
                    ],
                ],
              ),
              if (data.dueVaccinations.isNotEmpty) ...[
                pw.SizedBox(height: 4),
                pw.Text(
                  l10n.svcSummaryPdfDue(
                    data.dueVaccinations.map((v) => v.vaccine).join(', '),
                  ),
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ],
            ]),
        ],
      ),
    );
    return doc.save();
  }
}

/// Für die Auswahl im Formular: alle Symptome/Medikamente.
Future<(List<Symptom>, List<MedicationDetails>, List<AppointmentSummary>)>
loadSummaryChoices(AppDatabase db, {DateTime? now}) async {
  final current = now ?? DateTime.now();
  final appointments =
      await (db.selectActive(db.appointments)
            ..where(
              (t) => t.status.equalsValue(AppointmentStatus.cancelled).not(),
            )
            ..orderBy([(t) => OrderingTerm.desc(t.scheduledAt)])
            ..limit(20))
          .get();
  return (
    await SymptomRepository(db).watchAll().first,
    (await MedicationRepository(db).all())
        .where((m) => m.isActiveOn(current) || m.medication.endedAt == null)
        .toList(),
    await AppointmentRepository(db).summariesFor(appointments),
  );
}

/// Fürs Teilen ohne Dateiendung-Verwirrung.
const visitSummaryMime = 'application/pdf';

