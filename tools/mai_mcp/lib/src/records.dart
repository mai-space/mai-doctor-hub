import 'package:sqlite3/sqlite3.dart';

/// Enum-Indizes wie in der App (drift `intEnum`).
const _appointmentStatus = ['geplant', 'erledigt', 'abgesagt'];
const _diagnosisStatus = ['aktiv', 'abgeschlossen'];
const _observationKind = [
  'skala_1_10',
  'farbe',
  'menge',
  'notiz',
  // v15: Messwert in kanonischer Einheit, Größe in `measure`.
  'messung',
];

/// v15: Messgrößen der App (Code → kanonische Einheit).
const _measureUnits = {
  'intensity': '/10',
  'temperature': '°C',
  'count': '×',
  'duration': 'min',
  'pulse': '/min',
  'bloodPressure': 'mmHg',
  'spo2': '%',
  'glucose': 'mg/dL',
  'weight': 'kg',
  'mood': '-5..+5',
};

const maxLimit = 50;
const defaultReportChars = 8000;
const maxReportChars = 30000;

/// Fachliche, read-only Abfragen für die MCP-Tools.
///
/// Gibt bewusst einfache Maps zurück (→ JSON für das Modell). Zeitpunkte als
/// ISO-8601 in lokaler Zeit; drift speichert Sekunden seit Epoch.
class MaiRecords {
  MaiRecords(this._db);

  final Database _db;

  static String? _iso(Object? seconds) => seconds == null
      ? null
      : DateTime.fromMillisecondsSinceEpoch(
          (seconds as int) * 1000,
        ).toIso8601String();

  static int _seconds(DateTime dt) => dt.millisecondsSinceEpoch ~/ 1000;

  static int _limit(int? value, {int fallback = 20}) =>
      (value ?? fallback).clamp(1, maxLimit);

  static const _entityTables = {
    'doctor': 'doctors',
    'diagnosis': 'diagnoses',
    'symptom': 'symptoms',
    'appointment': 'appointments',
    'report': 'reports',
    'medication': 'medications',
    'note': 'notes',
    'pharmacy': 'pharmacies',
    'vaccination': 'vaccinations',
  };

  /// Volltextsuche (FTS5) über Akte und Berichtstexte.
  List<Map<String, Object?>> searchRecords(
    String query, {
    List<String>? types,
    int? limit,
  }) {
    final tokens = query
        .trim()
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .map((t) => '"${t.replaceAll('"', '')}"*')
        .join(' ');
    if (tokens.isEmpty) return const [];
    final typeFilter = types == null || types.isEmpty
        ? ''
        : 'AND entity_type IN (${List.filled(types.length, '?').join(', ')})';
    final rows = _db.select(
      '''
      SELECT entity_type, entity_id, title,
             snippet(records_fts, 3, '[', ']', ' … ', 16) AS snippet
      FROM records_fts
      WHERE records_fts MATCH ? $typeFilter
      ORDER BY bm25(records_fts)
      LIMIT ?
      ''',
      [tokens, ...?types, _limit(limit)],
    );
    // Archivierte Einträge stehen noch im Index — nur „lebende“ liefern.
    bool exists(String type, String id) {
      final table = _entityTables[type];
      if (table == null) return true;
      return _db.select('SELECT 1 FROM $table WHERE id = ?', [id]).isNotEmpty;
    }

    return [
      for (final r in rows)
        if (exists(r['entity_type'] as String, r['entity_id'] as String))
          {
            'type': r['entity_type'],
            'id': r['entity_id'],
            'title': r['title'],
            'snippet': r['snippet'],
          },
    ];
  }

  List<Map<String, Object?>> listAppointments({
    DateTime? from,
    DateTime? to,
    String? doctor,
    String? status,
    int? limit,
  }) {
    final where = <String>[];
    final args = <Object?>[];
    if (from != null) {
      where.add('a.scheduled_at >= ?');
      args.add(_seconds(from));
    }
    if (to != null) {
      where.add('a.scheduled_at < ?');
      args.add(_seconds(to));
    }
    if (doctor != null && doctor.trim().isNotEmpty) {
      where.add('(d.name LIKE ? OR d.specialty LIKE ?)');
      args
        ..add('%${doctor.trim()}%')
        ..add('%${doctor.trim()}%');
    }
    if (status != null) {
      final index = _appointmentStatus.indexOf(status);
      if (index >= 0) {
        where.add('a.status = ?');
        args.add(index);
      }
    }
    final rows = _db.select(
      '''
      SELECT a.id, a.scheduled_at, a.duration_min, a.title, a.status,
             d.name AS doctor, d.specialty,
             (SELECT COUNT(*) FROM reports r WHERE r.appointment_id = a.id)
               AS report_count,
             (SELECT group_concat(g.title, ', ')
                FROM appointment_diagnoses ad
                JOIN diagnoses g ON g.id = ad.diagnosis_id
               WHERE ad.appointment_id = a.id) AS diagnoses
      FROM appointments a
      LEFT JOIN doctors d ON d.id = a.doctor_id
      ${where.isEmpty ? '' : 'WHERE ${where.join(' AND ')}'}
      ORDER BY a.scheduled_at DESC
      LIMIT ?
      ''',
      [...args, _limit(limit)],
    );
    return [for (final r in rows) _appointmentRow(r)];
  }

  Map<String, Object?> _appointmentRow(Row r) => {
    'id': r['id'],
    'when': _iso(r['scheduled_at']),
    'duration_min': r['duration_min'],
    'title': r['title'],
    'status': _appointmentStatus[r['status'] as int],
    'doctor': r['doctor'],
    'specialty': r['specialty'],
    'diagnoses': r['diagnoses'],
    'report_count': r['report_count'],
  };

  Map<String, Object?>? getAppointment(String id) {
    final rows = _db.select(
      '''
      SELECT a.*, d.name AS doctor, d.specialty, d.practice_name, d.address
      FROM appointments a LEFT JOIN doctors d ON d.id = a.doctor_id
      WHERE a.id = ?
      ''',
      [id],
    );
    if (rows.isEmpty) return null;
    final a = rows.first;
    return {
      'id': a['id'],
      'when': _iso(a['scheduled_at']),
      'duration_min': a['duration_min'],
      'title': a['title'],
      'status': _appointmentStatus[a['status'] as int],
      'notes': a['notes'],
      'doctor': {
        'name': a['doctor'],
        'specialty': a['specialty'],
        'practice': a['practice_name'],
        'address': a['address'],
      },
      'diagnoses': [
        for (final d in _db.select(
          '''
          SELECT g.id, g.title FROM appointment_diagnoses ad
          JOIN diagnoses g ON g.id = ad.diagnosis_id WHERE ad.appointment_id = ?
          ''',
          [id],
        ))
          {'id': d['id'], 'title': d['title']},
      ],
      'symptoms': [
        for (final s in _db.select(
          '''
          SELECT s.id, s.label FROM appointment_symptoms x
          JOIN symptoms s ON s.id = x.symptom_id WHERE x.appointment_id = ?
          ''',
          [id],
        ))
          {'id': s['id'], 'label': s['label']},
      ],
      'reports': [
        for (final r in _db.select(
          '''
          SELECT id, title, mime_type, page_count,
                 extracted_text IS NOT NULL AS has_text
          FROM reports WHERE appointment_id = ? ORDER BY created_at
          ''',
          [id],
        ))
          {
            'id': r['id'],
            'title': r['title'],
            'type': r['mime_type'],
            'pages': r['page_count'],
            'has_text': r['has_text'] == 1,
          },
      ],
      'notes_linked': [
        for (final n in _db.select(
          'SELECT body FROM notes WHERE related_appointment_id = ?',
          [id],
        ))
          n['body'],
      ],
    };
  }

  /// Erkannter Text eines Berichts, gekürzt auf [maxChars].
  Map<String, Object?>? getReportText(String id, {int? maxChars}) {
    final rows = _db.select(
      '''
      SELECT r.id, r.title, r.created_at, r.page_count, r.extracted_text,
             a.scheduled_at
      FROM reports r LEFT JOIN appointments a ON a.id = r.appointment_id
      WHERE r.id = ?
      ''',
      [id],
    );
    if (rows.isEmpty) return null;
    final r = rows.first;
    final limit = (maxChars ?? defaultReportChars).clamp(200, maxReportChars);
    final text = r['extracted_text'] as String?;
    return {
      'id': r['id'],
      'title': r['title'],
      'filed_at': _iso(r['created_at']),
      'appointment_at': _iso(r['scheduled_at']),
      'pages': r['page_count'],
      'text': text == null
          ? null
          : text.length <= limit
          ? text
          : '${text.substring(0, limit)} … [gekürzt, ${text.length} Zeichen]',
      if (text == null) 'hint': 'Kein Text erkannt (Scan ohne Textebene?).',
    };
  }

  /// Check-in-Verlauf eines Symptoms (per ID oder Bezeichnung).
  Map<String, Object?>? symptomTimeline(
    String symptom, {
    DateTime? from,
    DateTime? to,
  }) {
    // App-Schema ≥ 12: strukturierte Beschreibung (ältere Snapshots ohne).
    final described = _hasColumn('symptom_observations', 'sensation');
    // App-Schema ≥ 15: Messgröße je Symptom/Check-in. Das Tagebuch bleibt
    // bewusst draußen (privat).
    final measured = _hasColumn('symptom_observations', 'measure');
    final defaults = [
      if (described) ', sensation, quality, side',
      if (measured) ', measure, measure2',
    ].join();
    final matches = _db.select(
      '''
      SELECT id, label, body_region, healed_at$defaults FROM symptoms
      WHERE id = ? OR label LIKE ? ORDER BY (id = ?) DESC, updated_at DESC
      LIMIT 1
      ''',
      [symptom, '%${symptom.trim()}%', symptom],
    );
    if (matches.isEmpty) return null;
    final s = matches.first;
    final args = <Object?>[s['id']];
    var range = '';
    if (from != null) {
      range += ' AND recorded_at >= ?';
      args.add(_seconds(from));
    }
    if (to != null) {
      range += ' AND recorded_at < ?';
      args.add(_seconds(to));
    }
    final details = [
      if (described) ', sensation, quality, location, side, pattern',
      if (measured)
        ', measure, value_number2, measure2, secondary_value, energy, '
            'sleep_hours, anxiety',
    ].join();
    final observations = _db.select('''
      SELECT recorded_at, kind, value_number, value_text, value_color, unit,
             note$details
      FROM symptom_observations WHERE symptom_id = ?$range
      ORDER BY recorded_at
      ''', args);
    final measure = measured
        ? (s['measure'] as String? ?? 'intensity')
        : 'intensity';
    final units = _units();
    // Statistik der Hauptgröße (Stärke: Skalenwerte wie bisher).
    final scale = [
      for (final o in observations)
        if (_measureOf(o) == measure && o['value_number'] != null)
          (o['value_number'] as num).toDouble(),
    ];
    return {
      'id': s['id'],
      'label': s['label'],
      'body_region': s['body_region'],
      'healed_at': _iso(s['healed_at']),
      if (measured) ...{
        'measure': measure,
        'unit': _measureUnits[measure],
        if (s['measure2'] != null) 'measure2': s['measure2'],
      },
      if (described)
        'default_description': _description(s, location: s['body_region']),
      'stats': scale.isEmpty
          ? null
          : {
              'count': scale.length,
              'min': scale.reduce((a, b) => a < b ? a : b),
              'max': scale.reduce((a, b) => a > b ? a : b),
              'avg': double.parse(
                (scale.reduce((a, b) => a + b) / scale.length).toStringAsFixed(
                  1,
                ),
              ),
              'last': scale.last,
            },
      'observations': [
        for (final o in observations.take(500))
          {
            'at': _iso(o['recorded_at']),
            'kind': _observationKind[o['kind'] as int],
            'value': o['value_number'] ?? o['value_text'] ?? o['value_color'],
            'unit': o['unit'],
            'note': o['note'],
            if (described) 'description': _description(o),
            if (measured) ..._measurement(o, units),
          },
      ],
    };
  }

  /// Messgröße eines Check-ins; alte Skalenwerte = Stärke.
  static String? _measureOf(Row o) {
    final kind = o['kind'] as int;
    if (kind == 0) return 'intensity';
    if (kind == 4 && o.containsKey('measure')) return o['measure'] as String?;
    return null;
  }

  /// Einheiten aus den App-Einstellungen (leer = kanonisch).
  ({String temperature, String glucose, String weight}) _units() {
    if (!_hasColumn('app_settings', 'temperature_unit')) {
      return (temperature: 'celsius', glucose: 'mgdl', weight: 'kg');
    }
    final rows = _db.select(
      'SELECT temperature_unit, glucose_unit, weight_unit FROM app_settings '
      'WHERE id = 1',
    );
    final r = rows.isEmpty ? null : rows.first;
    return (
      temperature: r?['temperature_unit'] as String? ?? 'celsius',
      glucose: r?['glucose_unit'] as String? ?? 'mgdl',
      weight: r?['weight_unit'] as String? ?? 'kg',
    );
  }

  /// Wert lesbar in den Einheiten der Nutzerin/des Nutzers, z. B.
  /// „38.4 °C“, „101.1 °F“, „128/84 mmHg“, „+2“, „7/10“.
  static String? formatMeasure(
    String measure,
    num? value, {
    num? value2,
    ({String temperature, String glucose, String weight}) units = (
      temperature: 'celsius',
      glucose: 'mgdl',
      weight: 'kg',
    ),
  }) {
    if (value == null) return null;
    final v = value.toDouble();
    String fixed(double x, int digits) => x.toStringAsFixed(digits);
    return switch (measure) {
      'intensity' => '${v.round()}/10',
      'temperature' =>
        units.temperature == 'fahrenheit'
            ? '${fixed(v * 9 / 5 + 32, 1)} °F'
            : '${fixed(v, 1)} °C',
      'count' => '${v.round()}×',
      'duration' => '${v.round()} min',
      'pulse' => '${v.round()}/min',
      'bloodPressure' => '${v.round()}/${value2?.round() ?? '-'} mmHg',
      'spo2' => '${v.round()} %',
      'glucose' =>
        units.glucose == 'mmol'
            ? '${fixed(v / 18.016, 1)} mmol/L'
            : '${v.round()} mg/dL',
      'weight' =>
        units.weight == 'lb'
            ? '${fixed(v / 0.45359237, 1)} lb'
            : '${fixed(v, 1)} kg',
      'mood' => v > 0 ? '+${v.round()}' : '${v.round()}',
      _ => '$v',
    };
  }

  /// v15: Messgröße, Einheit, lesbarer Wert, Zusatzwert und
  /// Stimmungs-Extras eines Check-ins (ohne Tagebuch).
  static Map<String, Object?> _measurement(
    Row o,
    ({String temperature, String glucose, String weight}) units,
  ) {
    final measure = _measureOf(o);
    final secondary = o['measure2'] as String?;
    return {
      if (measure != null) ...{
        'measure': measure,
        'canonical_unit': _measureUnits[measure],
        'display': formatMeasure(
          measure,
          o['value_number'] as num?,
          value2: o['value_number2'] as num?,
          units: units,
        ),
      },
      if (o['value_number2'] != null) 'value2': o['value_number2'],
      if (secondary != null && o['secondary_value'] != null)
        'secondary': {
          'measure': secondary,
          'value': o['secondary_value'],
          'canonical_unit': _measureUnits[secondary],
          'display': formatMeasure(
            secondary,
            o['secondary_value'] as num?,
            units: units,
          ),
        },
      if (o['energy'] != null) 'energy_0_10': o['energy'],
      if (o['sleep_hours'] != null) 'sleep_hours': o['sleep_hours'],
      if (o['anxiety'] != null) 'anxiety_0_10': o['anxiety'],
    };
  }

  bool _hasColumn(String table, String column) => _db
      .select('SELECT name FROM pragma_table_info(?)', [table])
      .any((r) => r['name'] == column);

  /// Strukturierte Beschreibung (Empfindung, Qualität, Ort, Seite, Verlauf);
  /// `null`, wenn nichts angegeben ist. Seite als Code: left/right/both/center.
  static Map<String, Object?>? _description(Row r, {Object? location}) {
    final values = {
      'sensation': r['sensation'],
      'quality': r['quality'],
      'location':
          location ?? (r.containsKey('location') ? r['location'] : null),
      'side': r['side'],
      if (r.containsKey('pattern')) 'pattern': r['pattern'],
    }..removeWhere((_, v) => v == null || (v is String && v.trim().isEmpty));
    return values.isEmpty ? null : values;
  }

  static const _forms = [
    'Tablette',
    'Kapsel',
    'Tropfen',
    'Saft/Lösung',
    'Spray',
    'Inhalator',
    'Salbe/Creme',
    'Spritze',
    'Pflaster',
    'Zäpfchen',
    'Pulver/Granulat',
    'Sonstiges',
  ];

  List<Map<String, Object?>> listMedications({bool activeOnly = false}) {
    final now = _seconds(DateTime.now());
    final rows = _db.select(
      '''
      SELECT m.*, g.title AS diagnosis, d.name AS prescriber,
             p.name AS pharmacy
      FROM medications m
      LEFT JOIN diagnoses g ON g.id = m.diagnosis_id
      LEFT JOIN doctors d ON d.id = m.prescriber_id
      LEFT JOIN pharmacies p ON p.id = m.pharmacy_id
      ${activeOnly ? 'WHERE m.ended_at IS NULL OR m.ended_at >= ?' : ''}
      ORDER BY m.name
      ''',
      [if (activeOnly) now],
    );
    return [
      for (final m in rows)
        {
          'id': m['id'],
          'name': m['name'],
          'strength': m['dosage'],
          'form': m['form'] == null ? null : _forms[m['form'] as int],
          'dose': m['dose_amount'] == null
              ? null
              : '${m['dose_amount']} ${m['dose_unit'] ?? ''}'.trim(),
          'instructions': m['instructions'],
          'schedule': m['schedule_text'],
          'since': _iso(m['started_at']),
          'until': _iso(m['ended_at']),
          'diagnosis': m['diagnosis'],
          'prescriber': m['prescriber'],
          'pharmacy': m['pharmacy'],
          'notes': m['notes'],
        },
    ];
  }

  /// Impfungen, neueste zuerst; `due` markiert fällige Auffrischungen.
  List<Map<String, Object?>> listVaccinations() {
    final now = DateTime.now();
    final rows = _db.select('''
      SELECT v.*, d.name AS doctor FROM vaccinations v
      LEFT JOIN doctors d ON d.id = v.doctor_id
      ORDER BY v.administered_at DESC
      ''');
    final seen = <String>{};
    return [
      for (final v in rows)
        {
          'vaccine': v['vaccine'],
          'product': v['product'],
          'date': _iso(v['administered_at']),
          'dose_number': v['dose_number'],
          'batch': v['batch'],
          'doctor': v['doctor'],
          'next_due': _iso(v['next_due_at']),
          // Nur die jüngste Impfung je Impfstoff bestimmt die Fälligkeit.
          'due':
              seen.add((v['vaccine'] as String).toLowerCase()) &&
              v['next_due_at'] != null &&
              (v['next_due_at'] as int) <= _seconds(now),
        },
    ];
  }

  /// Diagnose mit allem, was daran hängt (per ID oder Titel).
  Map<String, Object?>? getDiagnosis(String diagnosis) {
    final rows = _db.select(
      '''
      SELECT * FROM diagnoses WHERE id = ? OR title LIKE ?
      ORDER BY (id = ?) DESC, updated_at DESC LIMIT 1
      ''',
      [diagnosis, '%${diagnosis.trim()}%', diagnosis],
    );
    if (rows.isEmpty) return null;
    final d = rows.first;
    final id = d['id'] as String;
    return {
      'id': id,
      'title': d['title'],
      'status': _diagnosisStatus[d['status'] as int],
      'since': _iso(d['started_at']),
      'until': _iso(d['ended_at']),
      'notes': d['notes'],
      'appointments': [
        for (final a in _db.select(
          '''
          SELECT a.id, a.scheduled_at, a.title, a.status, doc.name AS doctor
          FROM appointment_diagnoses ad
          JOIN appointments a ON a.id = ad.appointment_id
          LEFT JOIN doctors doc ON doc.id = a.doctor_id
          WHERE ad.diagnosis_id = ? ORDER BY a.scheduled_at DESC
          ''',
          [id],
        ))
          {
            'id': a['id'],
            'when': _iso(a['scheduled_at']),
            'title': a['title'],
            'status': _appointmentStatus[a['status'] as int],
            'doctor': a['doctor'],
          },
      ],
      'symptoms': [
        for (final s in _db.select(
          'SELECT id, label, healed_at FROM symptoms WHERE diagnosis_id = ?',
          [id],
        ))
          {
            'id': s['id'],
            'label': s['label'],
            'active': s['healed_at'] == null,
          },
      ],
      'medications': [
        for (final m in _db.select(
          'SELECT name, dosage FROM medications WHERE diagnosis_id = ?',
          [id],
        ))
          {'name': m['name'], 'dosage': m['dosage']},
      ],
      'notes_linked': [
        for (final n in _db.select(
          'SELECT body FROM notes WHERE related_diagnosis_id = ?',
          [id],
        ))
          n['body'],
      ],
    };
  }

  /// Kurzprofil als Einstiegskontext (Resource `mai://summary`).
  Map<String, Object?> summary() {
    final now = _seconds(DateTime.now());
    int count(String table) =>
        _db.select('SELECT COUNT(*) AS c FROM $table').first['c'] as int;
    return {
      'active_diagnoses': [
        for (final d in _db.select(
          'SELECT id, title FROM diagnoses WHERE status = 0 ORDER BY title',
        ))
          {'id': d['id'], 'title': d['title']},
      ],
      'active_symptoms': [
        for (final s in _db.select(
          'SELECT id, label FROM symptoms WHERE healed_at IS NULL ORDER BY label',
        ))
          {'id': s['id'], 'label': s['label']},
      ],
      'current_medications': [
        for (final m in listMedications(activeOnly: true))
          [
            m['name'],
            m['strength'],
            if (m['schedule'] != null) '(${m['schedule']})',
          ].whereType<String>().join(' '),
      ],
      'next_appointments': [
        for (final r in _db.select(
          '''
          SELECT a.id, a.scheduled_at, a.duration_min, a.title, a.status,
                 d.name AS doctor, d.specialty, 0 AS report_count,
                 NULL AS diagnoses
          FROM appointments a LEFT JOIN doctors d ON d.id = a.doctor_id
          WHERE a.scheduled_at >= ? AND a.status = 0
          ORDER BY a.scheduled_at LIMIT 5
          ''',
          [now],
        ))
          _appointmentRow(r),
      ],
      'counts': {
        'appointments': count('appointments'),
        'reports': count('reports'),
        'doctors': count('doctors'),
        'notes': count('notes'),
      },
    };
  }
}
