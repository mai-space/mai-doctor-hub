import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dart_mcp/client.dart';
import 'package:dart_mcp/stdio.dart';
import 'package:mai_mcp/mai_mcp.dart';
import 'package:stream_channel/stream_channel.dart';
import 'package:test/test.dart';

import 'fixture.dart';

Future<ServerConnection> connect(StreamChannel<String> channel) async {
  final client = MCPClient(Implementation(name: 'test', version: '0'));
  final server = client.connectServer(channel);
  final init = await server.initialize(
    InitializeRequest(
      protocolVersion: ProtocolVersion.latestSupported,
      capabilities: client.capabilities,
      clientInfo: client.implementation,
    ),
  );
  expect(init.capabilities.tools, isNotNull);
  expect(init.capabilities.resources, isNotNull);
  server.notifyInitialized();
  return server;
}

String textOf(CallToolResult result) =>
    (result.content.single as TextContent).text;

void main() {
  late Directory dir;

  setUp(() => dir = Directory.systemTemp.createTempSync('mai_server'));
  tearDown(() => dir.deleteSync(recursive: true));

  test('in-process: tools are read-only and answer over MCP', () async {
    final snapshot = MaiSnapshot.openSqlite(buildFixtureDb(dir));
    addTearDown(snapshot.close);
    final audit = StringBuffer();
    final sink = IOSink(StreamController<List<int>>()
      ..stream.listen((b) => audit.write(utf8.decode(b))));
    final pipe = StreamChannelController<String>();
    MaiMcpServer(pipe.foreign, records: MaiRecords(snapshot.db), auditLog: sink);
    final server = await connect(pipe.local);

    final tools = (await server.listTools(ListToolsRequest())).tools;
    expect(tools.map((t) => t.name), unorderedEquals([
      'search_records',
      'list_appointments',
      'get_appointment',
      'get_report_text',
      'symptom_timeline',
      'list_medications',
      'get_diagnosis',
      'list_vaccinations',
    ]));
    expect(tools.every((t) => t.toolAnnotations?.readOnlyHint == true), isTrue);

    final search = await server.callTool(
      CallToolRequest(name: 'search_records', arguments: {'query': 'Schleim'}),
    );
    expect(search.isError, isNot(true));
    expect(jsonDecode(textOf(search)), [
      containsPair('id', 'rep1'),
    ]);

    final missing = await server.callTool(
      CallToolRequest(name: 'get_appointment', arguments: {'id': 'x'}),
    );
    expect(missing.isError, isTrue);

    final badDate = await server.callTool(
      CallToolRequest(name: 'list_appointments', arguments: {'from': 'gestern'}),
    );
    expect(badDate.isError, isTrue);

    final summary = await server.readResource(
      ReadResourceRequest(uri: 'mai://summary'),
    );
    final json = jsonDecode(
      (summary.contents.single as TextResourceContents).text,
    ) as Map<String, dynamic>;
    expect(json['active_diagnoses'], isNotEmpty);

    await server.shutdown();
    await sink.close();
    expect(audit.toString(), contains('tool:search_records'));
    expect(audit.toString(), isNot(contains('Schleim')),
        reason: 'Audit-Log enthält keine Inhalte/Argumente');
  });

  test('stdio process with encrypted backup', () async {
    final backup = File('${dir.path}/akte.maibackup')
      ..writeAsBytesSync(
        await buildFixtureBackup(buildFixtureDb(dir), 'geheim-genug'),
      );
    final process = await Process.start(
      Platform.resolvedExecutable,
      ['run', 'bin/mai_mcp.dart', '--backup', backup.path],
      environment: {'MAI_BACKUP_PASSPHRASE': 'geheim-genug'},
    );
    addTearDown(process.kill);
    final server = await connect(
      stdioChannel(input: process.stdout, output: process.stdin),
    );
    final result = await server.callTool(
      CallToolRequest(
        name: 'symptom_timeline',
        arguments: {'symptom': 'Kopfschmerz'},
      ),
    );
    expect(jsonDecode(textOf(result))['stats']['last'], 3.0);
    await server.shutdown();
  }, timeout: const Timeout(Duration(minutes: 3)));

  test('stdio process without passphrase exits with usage error', () async {
    final result = await Process.run(
      Platform.resolvedExecutable,
      ['run', 'bin/mai_mcp.dart', '--backup', 'x.maibackup'],
      environment: {'MAI_BACKUP_PASSPHRASE': ''},
    );
    expect(result.exitCode, 64);
    expect(result.stderr, contains('MAI_BACKUP_PASSPHRASE'));
  }, timeout: const Timeout(Duration(minutes: 3)));
}
