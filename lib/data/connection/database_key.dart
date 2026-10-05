import 'dart:io';

import 'package:flutter/services.dart';

/// Liefert den Schlüssel der App-Datenbank.
abstract interface class DatabaseKeyStore {
  /// Hex-Schlüssel; `null` = Plattform ohne Verschlüsselung.
  /// Wirft [DatabaseKeyLost], wenn ein gespeicherter Schlüssel nicht mehr
  /// entpackt werden kann.
  Future<String?> getOrCreate();

  /// Verwirft den gespeicherten Schlüssel (nur bei unlesbarer Datenbank).
  Future<void> reset();
}

class DatabaseKeyLost implements Exception {
  const DatabaseKeyLost(this.cause);

  final Object cause;

  @override
  String toString() => 'DatabaseKeyLost: $cause';
}

/// Android: Schlüssel im Keystore verpackt, nie im Backup (siehe
/// `DatabaseKeyChannel.kt`). Andere Plattformen: unverschlüsselt.
class PlatformDatabaseKeyStore implements DatabaseKeyStore {
  const PlatformDatabaseKeyStore();

  static const _channel = MethodChannel('mai/db_key');

  @override
  Future<String?> getOrCreate() async {
    if (!Platform.isAndroid) return null;
    try {
      return await _channel.invokeMethod<String>('getOrCreate');
    } on PlatformException catch (e) {
      throw DatabaseKeyLost(e);
    }
  }

  @override
  Future<void> reset() async {
    if (Platform.isAndroid) await _channel.invokeMethod<void>('reset');
  }
}
