import 'dart:io';

import 'package:args/args.dart';
import 'package:dart_mcp/stdio.dart';
import 'package:mai_mcp/mai_mcp.dart';

/// Startet den MCP-Server über stdio.
///
/// ```
/// MAI_BACKUP_PASSPHRASE=… dart run bin/mai_mcp.dart --backup akte.maibackup
/// ```
Future<void> main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('backup', help: 'Verschlüsselte .maibackup-Datei aus der App')
    ..addOption(
      'passphrase-env',
      defaultsTo: 'MAI_BACKUP_PASSPHRASE',
      help: 'Umgebungsvariable mit dem Sicherungspasswort',
    )
    ..addOption('db', help: 'Unverschlüsselte SQLite-Datei (nur Entwicklung)')
    ..addOption(
      'audit-log',
      help: 'Datei für ein Abfrageprotokoll (nur Tool-Namen, keine Inhalte)',
    )
    ..addFlag('help', abbr: 'h', negatable: false);

  final ArgResults args;
  try {
    args = parser.parse(arguments);
  } on FormatException catch (e) {
    _fail('${e.message}\n\n${parser.usage}');
  }
  if (args.flag('help')) {
    stderr.writeln('mai_mcp — Read-only MCP-Server\n\n${parser.usage}');
    exit(0);
  }

  final MaiSnapshot snapshot;
  try {
    if (args.option('backup') case final backup?) {
      final variable = args.option('passphrase-env')!;
      final passphrase = Platform.environment[variable];
      if (passphrase == null || passphrase.isEmpty) {
        _fail('Passwort fehlt: Umgebungsvariable $variable setzen.');
      }
      snapshot = await MaiSnapshot.openBackup(backup, passphrase);
    } else if (args.option('db') case final db?) {
      snapshot = MaiSnapshot.openSqlite(db);
    } else {
      _fail('--backup oder --db angeben.\n\n${parser.usage}');
    }
  } catch (e) {
    _fail('Akte konnte nicht geöffnet werden: $e');
  }

  final audit = switch (args.option('audit-log')) {
    final path? => File(path).openWrite(mode: FileMode.append),
    null => null,
  };

  // stdout gehört dem MCP-Protokoll; Hinweise nur auf stderr.
  stderr.writeln('mai_mcp bereit (read-only).');
  final server = MaiMcpServer(
    stdioChannel(input: stdin, output: stdout),
    records: MaiRecords(snapshot.db),
    auditLog: audit,
    snapshotCreatedAt: snapshot.createdAt,
  );
  await server.done;
  await audit?.close();
  await snapshot.close();
}

Never _fail(String message) {
  stderr.writeln(message);
  exit(64);
}
