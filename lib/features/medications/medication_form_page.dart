import 'package:flutter/material.dart';

import '../../data/app_database.dart';
import '../../data/database_provider.dart';
import '../../data/repositories/doctor_repository.dart';
import '../../data/repositories/medication_repository.dart';
import '../../data/repositories/reminder_repository.dart' show Weekdays;
import '../../data/repositories/suggestion_repository.dart';
import '../../l10n/l10n.dart';
import '../../widgets/suggestion_text_field.dart';
import '../records/entity_forms.dart';
import 'pharmacy_form.dart';

enum _Duration { open, until, days }

/// Medikament anlegen/bearbeiten (eigene Seite: viele Felder).
Future<String?> showMedicationFormPage(
  BuildContext context, {
  String? medicationId,
}) async {
  final details = medicationId == null
      ? null
      : await MedicationRepository(DatabaseScope.of(context)).get(medicationId);
  if (!context.mounted) return null;
  return Navigator.of(context).push<String>(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => MedicationFormPage(initial: details),
    ),
  );
}

class MedicationFormPage extends StatefulWidget {
  const MedicationFormPage({super.key, this.initial});

  final MedicationDetails? initial;

  @override
  State<MedicationFormPage> createState() => _MedicationFormPageState();
}

class _ScheduleDraft {
  _ScheduleDraft(this.time, this.weekdays, this.dose);

  TimeOfDay time;
  int weekdays;
  final TextEditingController dose;
}

class _MedicationFormPageState extends State<MedicationFormPage> {
  late final Medication? _m = widget.initial?.medication;
  late final _name = TextEditingController(text: _m?.name);
  late final _strength = TextEditingController(text: _m?.dosage);
  late final _amount = TextEditingController(
    text: _m?.doseAmount == null ? '' : formatAmount(_m!.doseAmount!),
  );
  late final _unit = TextEditingController(text: _m?.doseUnit);
  late final _instructions = TextEditingController(text: _m?.instructions);
  late final _notes = TextEditingController(text: _m?.notes);
  late final _days = TextEditingController(text: '7');

  late MedicationForm? _form = _m?.form;
  late String? _prescriberId = _m?.prescriberId;
  late String? _pharmacyId = _m?.pharmacyId;
  late String? _diagnosisId = _m?.diagnosisId;
  late DateTime? _start = _m?.startedAt ?? (_m == null ? _today() : null);
  late DateTime? _until = _m?.endedAt;
  late _Duration _duration = _m?.endedAt == null ? _Duration.open : _Duration.until;
  late bool _reminders = _m?.remindersEnabled ?? true;
  late final List<_ScheduleDraft> _schedules = [
    for (final s in widget.initial?.schedules ?? const <MedicationSchedule>[])
      _ScheduleDraft(
        TimeOfDay(hour: s.hour, minute: s.minute),
        s.weekdays,
        TextEditingController(
          text: s.doseAmount == null ? '' : formatAmount(s.doseAmount!),
        ),
      ),
  ];

  List<Doctor> _doctors = const [];
  List<Pharmacy> _pharmacies = const [];

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _load();
  }

  Future<void> _load() async {
    final db = DatabaseScope.of(context);
    final doctors = await DoctorRepository(db).watchAll().first;
    final pharmacies = await PharmacyRepository(db).watchAll().first;
    if (mounted) {
      setState(() {
        _doctors = doctors;
        _pharmacies = pharmacies;
      });
    }
  }

  @override
  void dispose() {
    for (final c in [_name, _strength, _amount, _unit, _instructions, _notes, _days]) {
      c.dispose();
    }
    for (final s in _schedules) {
      s.dose.dispose();
    }
    super.dispose();
  }

  static double? _parse(String text) =>
      double.tryParse(text.trim().replaceAll(',', '.'));

  static String? _trim(TextEditingController c) =>
      c.text.trim().isEmpty ? null : c.text.trim();

  DateTime? get _endDate => switch (_duration) {
    _Duration.open => null,
    _Duration.until => _until,
    _Duration.days => (_start ?? _today()).add(
      Duration(days: (int.tryParse(_days.text.trim()) ?? 1).clamp(1, 3650) - 1),
    ),
  };

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.homeMedNameMissing)),
      );
      return;
    }
    final navigator = Navigator.of(context);
    final id = await MedicationRepository(DatabaseScope.of(context)).save(
      id: _m?.id,
      name: _name.text.trim(),
      strength: _trim(_strength),
      form: _form,
      doseAmount: _parse(_amount.text),
      doseUnit: _trim(_unit),
      instructions: _trim(_instructions),
      prescriberId: _prescriberId,
      pharmacyId: _pharmacyId,
      diagnosisId: _diagnosisId,
      startedAt: _start,
      endedAt: _endDate,
      notes: _trim(_notes),
      remindersEnabled: _reminders,
      schedules: [
        for (final s in _schedules)
          ScheduleInput(
            hour: s.time.hour,
            minute: s.time.minute,
            weekdays: s.weekdays,
            doseAmount: _parse(s.dose.text),
          ),
      ],
    );
    navigator.pop(id);
  }

  Future<void> _addSchedule() async {
    final time = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 8, minute: 0),
    );
    if (time == null) return;
    setState(
      () => _schedules
        ..add(_ScheduleDraft(time, Weekdays.all, TextEditingController()))
        ..sort(
          (a, b) => (a.time.hour * 60 + a.time.minute).compareTo(
            b.time.hour * 60 + b.time.minute,
          ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    final weekdayLabels = Weekdays.labels;
    Widget section(String title) => Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 4),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_m == null ? l10n.homeMedCreate : l10n.homeMedEdit),
        actions: [TextButton(onPressed: _save, child: Text(l10n.commonSave))],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
        children: [
          SuggestionTextField(
            controller: _name,
            field: SuggestionField.medicationName,
            autofocus: _m == null,
            decoration: InputDecoration(labelText: l10n.homeDoctorName),
          ),
          SuggestionTextField(
            controller: _strength,
            field: SuggestionField.dosage,
            decoration: InputDecoration(
              labelText: l10n.homeMedStrength,
            ),
          ),
          const SizedBox(height: 12),
          DropdownMenu<MedicationForm?>(
            initialSelection: _form,
            label: Text(l10n.homeMedForm),
            expandedInsets: EdgeInsets.zero,
            dropdownMenuEntries: [
              const DropdownMenuEntry(value: null, label: '—'),
              for (final f in MedicationForm.values)
                DropdownMenuEntry(value: f, label: medicationFormLabel(f)),
            ],
            onSelected: (f) => setState(() {
              _form = f;
              if (f != null && _unit.text.trim().isEmpty) {
                _unit.text = defaultDoseUnit(f);
              }
            }),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amount,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(labelText: l10n.homeMedDosePerIntake),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _unit,
                  decoration: InputDecoration(labelText: l10n.homeMedUnit),
                ),
              ),
            ],
          ),
          Wrap(
            spacing: 6,
            children: [
              for (final u in doseUnitCatalog.take(8))
                ActionChip(
                  label: Text(u),
                  onPressed: () => setState(() => _unit.text = u),
                ),
            ],
          ),
          TextField(
            controller: _instructions,
            decoration: InputDecoration(
              labelText: l10n.homeMedInstructions,
            ),
          ),

          section(l10n.homeMedIntakeTimes),
          for (final s in _schedules)
            Card(
              elevation: 0,
              color: theme.colorScheme.surfaceContainerLow,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.schedule),
                          label: Text(s.time.format(context)),
                          onPressed: () async {
                            final t = await showTimePicker(
                              context: context,
                              initialTime: s.time,
                            );
                            if (t != null) setState(() => s.time = t);
                          },
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: s.dose,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              labelText: l10n.homeMedAmount,
                              hintText: _amount.text.isEmpty
                                  ? l10n.homeMedAmountSameAsAbove
                                  : _amount.text,
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: l10n.homeMedRemoveIntakeTime,
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => setState(() => _schedules.remove(s)),
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 4,
                      children: [
                        for (var d = 1; d <= 7; d++)
                          FilterChip(
                            visualDensity: VisualDensity.compact,
                            label: Text(weekdayLabels[d - 1]),
                            selected: Weekdays.contains(s.weekdays, d),
                            onSelected: (_) => setState(() {
                              final next = Weekdays.toggle(s.weekdays, d);
                              if (next != 0) s.weekdays = next;
                            }),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _addSchedule,
              icon: const Icon(Icons.add_alarm),
              label: Text(l10n.homeMedAddIntakeTime),
            ),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.homeMedRemind),
            value: _reminders,
            onChanged: (v) => setState(() => _reminders = v),
          ),

          section(l10n.homeMedPeriod),
          DateField(
            label: l10n.homeMedStart,
            value: _start,
            onChanged: (v) => setState(() => _start = v),
          ),
          SegmentedButton<_Duration>(
            segments: [
              ButtonSegment(value: _Duration.open, label: Text(l10n.homeMedOngoing)),
              ButtonSegment(value: _Duration.until, label: Text(l10n.homeMedUntilDate)),
              ButtonSegment(value: _Duration.days, label: Text(l10n.homeMedDays)),
            ],
            selected: {_duration},
            onSelectionChanged: (v) => setState(() => _duration = v.first),
          ),
          if (_duration == _Duration.until)
            DateField(
              label: l10n.homeMedEnd,
              value: _until,
              onChanged: (v) => setState(() => _until = v),
            ),
          if (_duration == _Duration.days)
            TextField(
              controller: _days,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: l10n.homeMedNumberOfDays),
              onChanged: (_) => setState(() {}),
            ),
          if (_endDate != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                l10n.homeMedLastIntakeOn(
                  MaterialLocalizations.of(context).formatMediumDate(_endDate!),
                ),
                style: theme.textTheme.bodySmall,
              ),
            ),

          section(l10n.homeMedAssignment),
          DropdownMenu<String?>(
            initialSelection: _prescriberId,
            label: Text(l10n.homeMedPrescribedBy),
            expandedInsets: EdgeInsets.zero,
            dropdownMenuEntries: [
              const DropdownMenuEntry(value: null, label: '—'),
              for (final d in _doctors)
                DropdownMenuEntry(value: d.id, label: d.name),
            ],
            onSelected: (v) => setState(() => _prescriberId = v),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownMenu<String?>(
                  key: ValueKey(_pharmacies.length),
                  initialSelection: _pharmacyId,
                  label: Text(l10n.entityPharmacy),
                  expandedInsets: EdgeInsets.zero,
                  dropdownMenuEntries: [
                    const DropdownMenuEntry(value: null, label: '—'),
                    for (final p in _pharmacies)
                      DropdownMenuEntry(value: p.id, label: p.name),
                  ],
                  onSelected: (v) => setState(() => _pharmacyId = v),
                ),
              ),
              IconButton(
                tooltip: l10n.homeMedAddPharmacy,
                icon: const Icon(Icons.add_business_outlined),
                onPressed: () async {
                  final id = await showPharmacyForm(context);
                  await _load();
                  if (id != null) setState(() => _pharmacyId = id);
                },
              ),
            ],
          ),
          DiagnosisPicker(
            value: _diagnosisId,
            onChanged: (v) => setState(() => _diagnosisId = v),
          ),
          TextField(
            controller: _notes,
            maxLines: 3,
            decoration: InputDecoration(labelText: l10n.commonNotes),
          ),
          const SizedBox(height: 24),
          FilledButton(onPressed: _save, child: Text(l10n.commonSave)),
        ],
      ),
    );
  }
}
