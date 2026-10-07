import 'dart:io';
import 'dart:isolate';

import 'package:drift/drift.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../data/app_database.dart';
import '../data/repositories/appointment_repository.dart';
import '../data/repositories/cycle_repository.dart';
import '../data/repositories/medication_repository.dart';
import '../data/repositories/symptom_media_repository.dart';
import '../data/repositories/symptom_repository.dart';
import '../data/repositories/vaccination_repository.dart';
import '../data/symptom_description.dart';
import '../data/symptom_measure.dart';
import '../l10n/l10n.dart';
import 'cycle/cycle_report.dart';
import 'cycle/cycle_text.dart' show hintText;
import 'file_vault.dart';
import '../widgets/measure_chart.dart' show MeasureStats;
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
    this.includeCycle = false,
    this.includeJournal = false,
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

  /// v14: Abschnitt „Zyklus & Frauengesundheit“ (nur auf Wunsch).
  final bool includeCycle;

  /// v15: Tagebuch-Einträge der Check-ins — persönlich, deshalb nur auf
  /// ausdrücklichen Wunsch (Standard aus).
  final bool includeJournal;
}

/// Foto-Beleg für das PDF (verkleinert).
class SummaryPhoto {
  const SummaryPhoto(this.recordedAt, this.jpeg, this.note);

  final DateTime recordedAt;
  final Uint8List jpeg;
  final String? note;
}

class SymptomTrend {
  const SymptomTrend(
    this.symptom,
    this.observations, {
    this.photos = const [],
    this.videoCount = 0,
    this.audioCount = 0,
  });

  final Symptom symptom;
  final List<SymptomObservation> observations;

  /// Fotos aus dem Zeitraum (neueste zuerst, höchstens [maxPhotos]).
  final List<SummaryPhoto> photos;
  final int videoCount;
  final int audioCount;

  static const maxPhotos = 6;

  List<double> get scale => [
    for (final o in observations)
      if (o.kind == ObservationKind.scale_1_10 && o.valueNumber != null)
        o.valueNumber!,
  ];

  double? get average =>
      scale.isEmpty ? null : scale.reduce((a, b) => a + b) / scale.length;

  /// v15: Messgröße des Symptoms und Kennzahlen dazu (kanonische Einheit).
  SymptomMeasure get measure => symptomMeasures(symptom).primary;
  MeasureStats? get stats => MeasureStats.of(observations, measure);

  /// v16: Werte früherer Messgrößen (vor einem Wechsel) im Zeitraum — eigene
  /// Zeile je Größe, damit alte Check-ins nicht verschwinden.
  List<MeasureSection> get earlierSections => [
    for (final section in measureSections(
      symptomMeasures(symptom),
      observations,
    ))
      if (!section.current && section.count > 0) section,
  ];

  /// „Früher erfasst: Stärke 0–10 (1. Sep. – 3. Okt.): Ø 5,2/10 · …“.
  String earlierLine(
    MeasureSection section,
    AppLocalizations l10n,
    DateFormat date,
  ) {
    final stats = MeasureStats.of(observations, section.measure);
    return [
      '${l10n.measureHistoryEarlier(measureLabel(section.measure, l10n))} '
          '(${date.format(section.from!)} – ${date.format(section.to!)})',
      if (stats != null) stats.describe(section.measure, l10n),
    ].join(': ');
  }
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
    this.cycle,
    this.includeJournal = false,
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

  /// Nur, wenn gewünscht und ein Bereich aktiv ist.
  final CycleReport? cycle;

  /// v15: Tagebuch-Spalte im PDF.
  final bool includeJournal;
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
    final mediaRepo = SymptomMediaRepository(_db);
    final symptoms = <SymptomTrend>[];
    for (final s in chosenSymptoms) {
      final media = [
        for (final m in await mediaRepo.forSymptom(s.id))
          if (!m.recordedAt.isBefore(from) && !m.recordedAt.isAfter(to)) m,
      ];
      final photos = <SummaryPhoto>[];
      for (final m in media.where((m) => m.kind == MediaKind.photo)) {
        if (photos.length >= SymptomTrend.maxPhotos) break;
        final jpeg = await _thumbnail(m.localPath);
        if (jpeg != null) photos.add(SummaryPhoto(m.recordedAt, jpeg, m.note));
      }
      symptoms.add(
        SymptomTrend(
          s,
          await symptomRepo.observationsBetween(s.id, from, to),
          photos: photos,
          videoCount: media.where((m) => m.kind == MediaKind.video).length,
          audioCount: media.where((m) => m.kind == MediaKind.audio).length,
        ),
      );
    }

    final medications = (await MedicationRepository(_db).all()).where(
      (m) => options.medicationIds == null
          ? m.isActiveOn(current)
          : options.medicationIds!.contains(m.medication.id),
    );

    final vaccinationRepo = VaccinationRepository(_db);
    CycleReport? cycle;
    if (options.includeCycle) {
      final overview = await CycleRepository(_db).overview(now: current);
      if (overview.enabled) cycle = CycleReport.from(overview);
    }
    return VisitSummaryData(
      cycle: cycle,
      includeJournal: options.includeJournal,
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
/// Entschlüsselt ein Foto und verkleinert es (lange Kante 900 px) fürs PDF.
Future<Uint8List?> _thumbnail(String path) async {
  try {
    if (!File(path).existsSync()) return null;
    final bytes = await FileVault.current.readBytes(path);
    return await Isolate.run(() {
      final decoded = img.decodeImage(bytes);
      if (decoded == null) return null;
      final oriented = img.bakeOrientation(decoded);
      final resized = oriented.width >= oriented.height
          ? img.copyResize(oriented, width: oriented.width.clamp(1, 900))
          : img.copyResize(oriented, height: oriented.height.clamp(1, 900));
      return Uint8List.fromList(img.encodeJpg(resized, quality: 80));
    });
  } catch (_) {
    return null;
  }
}

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
                          // v15: andere Messgrößen mit Einheit.
                          if (t.measure != SymptomMeasure.intensity &&
                              t.stats != null)
                            _latin(t.stats!.describe(t.measure, l10n)),
                          if (t.measure == SymptomMeasure.intensity &&
                              t.average != null)
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
                for (final section in t.earlierSections)
                  pw.Text(
                    _latin(t.earlierLine(section, l10n, date)),
                    style: muted,
                  ),
                if (t.photos.isNotEmpty || t.videoCount + t.audioCount > 0)
                  pw.Text(
                    l10n.svcSummaryPdfEvidence(
                      t.photos.length,
                      t.videoCount,
                      t.audioCount,
                    ),
                    style: muted,
                  ),
                if (t.photos.isNotEmpty)
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 4),
                    child: pw.Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final photo in t.photos)
                          pw.SizedBox(
                            width: 120,
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Image(
                                  pw.MemoryImage(photo.jpeg),
                                  height: 90,
                                  fit: pw.BoxFit.contain,
                                ),
                                pw.Text(
                                  [
                                    date.format(photo.recordedAt),
                                    if (photo.note?.isNotEmpty == true)
                                      photo.note!,
                                  ].join(' · '),
                                  style: const pw.TextStyle(fontSize: 7),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                if (t.observations.isNotEmpty)
                  pw.TableHelper.fromTextArray(
                    headers: [
                      l10n.svcSummaryPdfDate,
                      l10n.svcSummaryPdfValue,
                      l10n.entityNote,
                      if (data.includeJournal) l10n.journalTitle,
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
                          _latin(observationLabel(o)),
                          o.note ?? '',
                          if (data.includeJournal) _latin(o.journal ?? ''),
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
          if (data.cycle case final cycle? when !cycle.isEmpty)
            section(l10n.cycleSettingsTitle, [
              for (final line in cycle.summaryLines(l10n))
                pw.Bullet(text: _latin(line)),
              if (cycle.cycles.isNotEmpty) ...[
                pw.SizedBox(height: 4),
                pw.TableHelper.fromTextArray(
                  headers: [
                    l10n.cycleReportStart,
                    l10n.cycleReportLength,
                    l10n.cycleReportPeriod,
                    'PBAC',
                    _latin(l10n.cycleReportStrongPain),
                  ],
                  cellStyle: const pw.TextStyle(fontSize: 9),
                  headerStyle: pw.TextStyle(
                    fontSize: 9,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  data: [
                    for (final row in cycle.cycleTable(l10n))
                      [for (final cell in row) _latin(cell)],
                  ],
                ),
              ],
              if (cycle.hints.isNotEmpty) ...[
                pw.SizedBox(height: 6),
                pw.Text(
                  l10n.cycleHintsTitle,
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
                for (final h in cycle.hints)
                  pw.Bullet(text: _latin(hintText(h, l10n))),
              ],
              pw.SizedBox(height: 4),
              pw.Text(_latin(l10n.cycleReportFooter), style: muted),
            ]),
        ],
      ),
    );
    return doc.save();
  }
}

/// Die Standardschrift des PDFs (Helvetica) kennt nur Latin-1: Striche und
/// „≥“ für den Zyklus-Abschnitt ersetzen, statt sie wegfallen zu lassen.
String _latin(String text) => text
    .replaceAll('≥', '>=')
    .replaceAll('–', '-')
    .replaceAll('—', '-')
    .replaceAll('…', '...')
    // v15: Messwerte (Stimmung „−2“, „SpO₂“) und Zitate aus dem Tagebuch.
    .replaceAll('−', '-')
    .replaceAll('₂', '2')
    .replaceAll(RegExp('[„“”]'), '"')
    .replaceAll(RegExp('[‚‘’]'), "'");

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

