import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_gemma/flutter_gemma.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mai_doctor_hub/services/assistant/assistant_engine.dart';
import 'package:mai_doctor_hub/services/assistant/model_integrity.dart';
import 'package:mai_doctor_hub/services/assistant/record_embedder.dart';

void main() {
  late Directory dir;
  setUp(() async => dir = await Directory.systemTemp.createTemp('model'));
  tearDown(() => dir.delete(recursive: true));

  PinnedModelFile pin(List<int> bytes) => PinnedModelFile(
    repo: 'r/m',
    revision: 'abc',
    fileName: 'm.bin',
    sha256: sha256.convert(bytes).toString(),
    size: bytes.length,
  );

  test('accepts the pinned file, rejects size or content changes', () async {
    final file = File('${dir.path}/m.bin')..writeAsBytesSync([1, 2, 3, 4]);
    await verifyFile(file.path, pin([1, 2, 3, 4]));

    file.writeAsBytesSync([1, 2, 3, 5]);
    await expectLater(
      verifyFile(file.path, pin([1, 2, 3, 4])),
      throwsA(isA<ModelIntegrityException>()),
    );
    file.writeAsBytesSync([1, 2, 3]);
    await expectLater(
      verifyFile(file.path, pin([1, 2, 3, 4])),
      throwsA(isA<ModelIntegrityException>()),
    );
    await expectLater(
      verifyFile('${dir.path}/fehlt', pin([1])),
      throwsA(isA<ModelIntegrityException>()),
    );
  });

  test('model URLs are pinned to a commit, not a branch', () {
    for (final f in [
      GemmaAssistantEngine.modelFile,
      GemmaRecordEmbedder.modelFile,
      GemmaRecordEmbedder.tokenizerFile,
    ]) {
      expect(f.url, startsWith('https://huggingface.co/'));
      expect(f.url, isNot(contains('/main/')));
      expect(f.revision, matches(RegExp(r'^[0-9a-f]{40}$')));
      expect(f.sha256, matches(RegExp(r'^[0-9a-f]{64}$')));
      expect(f.url, endsWith('/${f.fileName}'));
    }
  });

  test('companion files are found under their namespaced name', () {
    const pin = GemmaRecordEmbedder.tokenizerFile;
    expect(
      installedNameFor(pin, [
        'embeddinggemma-300M_seq512_mixed-precision.tflite',
        'embeddinggemma-300M_seq512_mixed-precision__sentencepiece.model',
      ]),
      'embeddinggemma-300M_seq512_mixed-precision__sentencepiece.model',
    );
    expect(
      installedNameFor(GemmaRecordEmbedder.modelFile, [
        'embeddinggemma-300M_seq512_mixed-precision.tflite',
      ]),
      'embeddinggemma-300M_seq512_mixed-precision.tflite',
    );
    expect(installedNameFor(pin, const []), 'sentencepiece.model');
  });

  test('names match what flutter_gemma actually stores', () {
    final spec = EmbeddingModelSpec(
      name: 'embeddinggemma-300M_seq512_mixed-precision',
      modelSource: ModelSource.network(GemmaRecordEmbedder.modelFile.url),
      tokenizerSource: ModelSource.network(
        GemmaRecordEmbedder.tokenizerFile.url,
      ),
    );
    final names = [for (final f in spec.files) f.filename];
    for (final pin in [
      GemmaRecordEmbedder.modelFile,
      GemmaRecordEmbedder.tokenizerFile,
    ]) {
      expect(names, contains(installedNameFor(pin, names)), reason: '$names');
    }
  });
}
