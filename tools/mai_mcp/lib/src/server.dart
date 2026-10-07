import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_mcp/server.dart';

import 'records.dart';

const _instructions = '''
Du hast lesenden Zugriff auf die persönliche Gesundheitsakte des Nutzers
(Mai Doctor Hub): Termine, Ärzte, Diagnosen, Symptome mit Check-in-Verlauf,
Medikamente, Impfungen, Notizen und den erkannten Text von Arztberichten.

- Lies zuerst die Resource `mai://summary` für einen Überblick.
- Nutze `search_records` für Freitext, dann die Detail-Tools per ID.
- Zitiere Berichte mit Titel und Datum. Erfinde keine Befunde.
- Du gibst keine Diagnosen oder Therapieempfehlungen; verweise bei
  medizinischen Fragen auf die behandelnden Ärzte.
- Alle Daten sind sensibel: nur für die Anfrage des Nutzers verwenden.
''';

/// Read-only MCP-Server über einen Akten-Snapshot.
base class MaiMcpServer extends MCPServer with ToolsSupport, ResourcesSupport {
  MaiMcpServer(
    super.channel, {
    required MaiRecords records,
    IOSink? auditLog,
    DateTime? snapshotCreatedAt,
  }) : _records = records,
       _audit = auditLog,
       _snapshotCreatedAt = snapshotCreatedAt,
       super.fromStreamChannel(
         implementation: Implementation(name: 'mai-doctor-hub', version: '0.1.0'),
         instructions: _instructions,
       ) {
    _registerTools();
    addResource(
      Resource(
        uri: 'mai://summary',
        name: 'Kurzprofil der Akte',
        description:
            'Aktive Diagnosen, offene Symptome, aktuelle Medikamente, '
            'nächste Termine.',
        mimeType: 'application/json',
      ),
      (request) {
        _log('resource:summary');
        return ReadResourceResult(
          contents: [
            TextResourceContents(
              uri: request.uri,
              mimeType: 'application/json',
              text: _json({
                'snapshot_created_at': _snapshotCreatedAt?.toIso8601String(),
                ..._records.summary(),
              }),
            ),
          ],
        );
      },
    );
  }

  final MaiRecords _records;
  final IOSink? _audit;
  final DateTime? _snapshotCreatedAt;

  static final _readOnly = ToolAnnotations(
    readOnlyHint: true,
    openWorldHint: false,
  );

  void _registerTools() {
    registerTool(
      Tool(
        name: 'search_records',
        description:
            'Volltextsuche in der Akte inkl. Text von Arztberichten. '
            'Liefert Typ, ID, Titel und Textausschnitt.',
        annotations: _readOnly,
        inputSchema: Schema.object(
          properties: {
            'query': Schema.string(description: 'Suchbegriffe (Präfixsuche)'),
            'types': Schema.list(
              description:
                  'Optional: doctor, diagnosis, symptom, appointment, '
                  'report, medication, note',
              items: Schema.string(),
            ),
            'limit': Schema.int(description: 'Max. Treffer (1–50, Std. 20)'),
          },
          required: ['query'],
        ),
      ),
      (request) => _call(request, (args) {
        return _records.searchRecords(
          args['query'] as String,
          types: (args['types'] as List?)?.cast<String>(),
          limit: args['limit'] as int?,
        );
      }),
    );

    registerTool(
      Tool(
        name: 'list_appointments',
        description:
            'Termine (neueste zuerst) mit Arzt, Status, Diagnosen und Anzahl '
            'Berichte. Filter nach Zeitraum, Arzt/Fachrichtung, Status.',
        annotations: _readOnly,
        inputSchema: Schema.object(
          properties: {
            'from': Schema.string(description: 'ISO-Datum, inklusive'),
            'to': Schema.string(description: 'ISO-Datum, exklusive'),
            'doctor': Schema.string(description: 'Teil von Name/Fachrichtung'),
            'status': Schema.string(description: 'geplant|erledigt|abgesagt'),
            'limit': Schema.int(description: '1–50, Std. 20'),
          },
        ),
      ),
      (request) => _call(request, (args) {
        return _records.listAppointments(
          from: _date(args['from']),
          to: _date(args['to']),
          doctor: args['doctor'] as String?,
          status: args['status'] as String?,
          limit: args['limit'] as int?,
        );
      }),
    );

    registerTool(
      Tool(
        name: 'get_appointment',
        description:
            'Details eines Termins: Notizen, Arzt, Diagnosen, Symptome, '
            'Berichte (IDs für get_report_text).',
        annotations: _readOnly,
        inputSchema: Schema.object(
          properties: {'id': Schema.string()},
          required: ['id'],
        ),
      ),
      (request) => _call(
        request,
        (args) => _records.getAppointment(args['id'] as String),
      ),
    );

    registerTool(
      Tool(
        name: 'get_report_text',
        description:
            'Erkannter Text eines Arztberichts (PDF). Lange Texte werden '
            'gekürzt.',
        annotations: _readOnly,
        inputSchema: Schema.object(
          properties: {
            'id': Schema.string(),
            'max_chars': Schema.int(description: '200–30000, Std. 8000'),
          },
          required: ['id'],
        ),
      ),
      (request) => _call(
        request,
        (args) => _records.getReportText(
          args['id'] as String,
          maxChars: args['max_chars'] as int?,
        ),
      ),
    );

    registerTool(
      Tool(
        name: 'symptom_timeline',
        description:
            'Check-in-Verlauf eines Symptoms (ID oder Bezeichnung) mit '
            'Statistik der Hauptmessgröße (Stärke 0–10, Temperatur, Anzahl, '
            'Blutdruck, Stimmung −5…+5 …) samt Einheit und Beschreibung je '
            'Check-in (Empfindung, Qualität, Ort, Seite, Verlauf). '
            'Tagebuch-Einträge sind nicht enthalten.',
        annotations: _readOnly,
        inputSchema: Schema.object(
          properties: {
            'symptom': Schema.string(description: 'ID oder Bezeichnung'),
            'from': Schema.string(description: 'ISO-Datum'),
            'to': Schema.string(description: 'ISO-Datum'),
          },
          required: ['symptom'],
        ),
      ),
      (request) => _call(
        request,
        (args) => _records.symptomTimeline(
          args['symptom'] as String,
          from: _date(args['from']),
          to: _date(args['to']),
        ),
      ),
    );

    registerTool(
      Tool(
        name: 'list_medications',
        description: 'Medikationsplan (Name, Dosierung, Einnahme, Zeitraum).',
        annotations: _readOnly,
        inputSchema: Schema.object(
          properties: {
            'active_only': Schema.bool(description: 'Nur aktuelle (Std. ja)'),
          },
        ),
      ),
      (request) => _call(
        request,
        (args) => _records.listMedications(
          activeOnly: args['active_only'] as bool? ?? true,
        ),
      ),
    );

    registerTool(
      Tool(
        name: 'list_vaccinations',
        description:
            'Impfungen (neueste zuerst) mit Charge, Arzt und nächster '
            'Fälligkeit; due=true bei überfälliger Auffrischung.',
        annotations: _readOnly,
        inputSchema: Schema.object(properties: {}),
      ),
      (request) => _call(request, (_) => _records.listVaccinations()),
    );

    registerTool(
      Tool(
        name: 'get_diagnosis',
        description:
            'Diagnose (ID oder Titel) mit verknüpften Terminen, Symptomen, '
            'Medikamenten und Notizen.',
        annotations: _readOnly,
        inputSchema: Schema.object(
          properties: {
            'diagnosis': Schema.string(description: 'ID oder Titel'),
          },
          required: ['diagnosis'],
        ),
      ),
      (request) => _call(
        request,
        (args) => _records.getDiagnosis(args['diagnosis'] as String),
      ),
    );
  }

  FutureOr<CallToolResult> _call(
    CallToolRequest request,
    Object? Function(Map<String, Object?> args) body,
  ) {
    final args = (request.arguments ?? const {}).cast<String, Object?>();
    _log('tool:${request.name}');
    try {
      final result = body(args);
      if (result == null) {
        return CallToolResult(
          isError: true,
          content: [TextContent(text: 'Nicht gefunden.')],
        );
      }
      return CallToolResult(content: [TextContent(text: _json(result))]);
    } on FormatException catch (e) {
      return CallToolResult(
        isError: true,
        content: [TextContent(text: 'Ungültige Eingabe: ${e.message}')],
      );
    }
  }

  /// Protokolliert nur *dass* etwas abgefragt wurde — nie Inhalte/Argumente.
  void _log(String event) =>
      _audit?.writeln('${DateTime.now().toIso8601String()} $event');

  static DateTime? _date(Object? value) {
    if (value == null) return null;
    final parsed = DateTime.tryParse(value as String);
    if (parsed == null) throw FormatException('Kein ISO-Datum: $value');
    return parsed;
  }

  static String _json(Object? value) =>
      const JsonEncoder.withIndent(' ').convert(value);
}
