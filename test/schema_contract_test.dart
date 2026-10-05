import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mai_doctor_hub/data/app_database.dart';

/// Der MCP-Server (tools/mai_mcp) liest App-Snapshots per SQL. Diese Datei
/// hält das aktuelle Schema fest; ändert es sich, schlägt der Test fehl, bis
/// Fixture und Server angepasst sind:
/// `UPDATE_SCHEMA=1 flutter test test/schema_contract_test.dart`
const _fixture = 'tools/mai_mcp/test/fixtures/schema.sql';

Future<String> currentSchema() async {
  final db = AppDatabase(NativeDatabase.memory());
  final rows = await db
      .customSelect(
        "SELECT sql FROM sqlite_master WHERE sql IS NOT NULL "
        "AND name NOT LIKE 'records_fts_%' ORDER BY name",
      )
      .get();
  await db.close();
  return [
    '-- schemaVersion ${db.schemaVersion}',
    for (final r in rows) '${r.read<String>('sql').trim()};',
  ].join('\n---\n');
}

void main() {
  test('MCP fixture matches the app schema', () async {
    final schema = await currentSchema();
    if (Platform.environment['UPDATE_SCHEMA'] == '1') {
      File(_fixture).writeAsStringSync('$schema\n');
    }
    expect(File(_fixture).readAsStringSync().trim(), schema.trim());
  });
}
