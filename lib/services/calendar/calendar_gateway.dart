import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class DeviceCalendar {
  const DeviceCalendar({
    required this.id,
    required this.name,
    required this.accountName,
    required this.accountType,
    this.isPrimary = false,
  });

  final String id;
  final String name;
  final String accountName;
  final String accountType;
  final bool isPrimary;

  /// Wird von Android zu Google synchronisiert.
  bool get isGoogle => accountType == 'com.google';

  String get label => accountName.isEmpty || accountName == name
      ? name
      : '$name ($accountName)';
}

/// Ein zu exportierender Termin — bewusst ohne medizinische Details.
@immutable
class CalendarEventData {
  const CalendarEventData({
    required this.title,
    required this.start,
    required this.end,
    this.location,
    this.description,
  });

  final String title;
  final DateTime start;
  final DateTime end;
  final String? location;
  final String? description;

  Map<String, Object?> toJson() => {
    'title': title,
    'start': start.millisecondsSinceEpoch,
    'end': end.millisecondsSinceEpoch,
    'location': location,
    'description': description,
  };
}

class CalendarException implements Exception {
  const CalendarException(this.message);

  final String message;

  @override
  String toString() => 'CalendarException: $message';
}

/// Schreibzugriff auf einen Kalender — nur eigene Events per ID.
abstract interface class CalendarGateway {
  bool get isSupported;
  Future<bool> hasPermission();
  Future<bool> requestPermission();
  Future<List<DeviceCalendar>> listCalendars();

  /// Legt an oder aktualisiert [eventId]; gibt die (ggf. neue) ID zurück.
  Future<String> upsertEvent(
    String calendarId,
    CalendarEventData event, {
    String? eventId,
  });

  Future<void> deleteEvent(String eventId);
}

/// Android-Kalender über `CalendarContract` (siehe CalendarChannel.kt).
class AndroidCalendarGateway implements CalendarGateway {
  static const _channel = MethodChannel('mai/calendar');

  @override
  bool get isSupported =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  @override
  Future<bool> hasPermission() async =>
      isSupported && (await _channel.invokeMethod<bool>('hasPermission') ?? false);

  @override
  Future<bool> requestPermission() async =>
      isSupported &&
      (await _channel.invokeMethod<bool>('requestPermission') ?? false);

  @override
  Future<List<DeviceCalendar>> listCalendars() async {
    final raw = await _invoke<List<Object?>>('listCalendars') ?? const [];
    return [
      for (final item in raw.cast<Map<Object?, Object?>>())
        DeviceCalendar(
          id: item['id']! as String,
          name: item['name'] as String? ?? '',
          accountName: item['accountName'] as String? ?? '',
          accountType: item['accountType'] as String? ?? '',
          isPrimary: item['isPrimary'] as bool? ?? false,
        ),
    ];
  }

  @override
  Future<String> upsertEvent(
    String calendarId,
    CalendarEventData event, {
    String? eventId,
  }) async {
    final id = await _invoke<String>('upsertEvent', {
      'calendarId': calendarId,
      'eventId': eventId,
      ...event.toJson(),
    });
    if (id == null) throw const CalendarException('Keine Event-ID erhalten');
    return id;
  }

  @override
  Future<void> deleteEvent(String eventId) =>
      _invoke<bool>('deleteEvent', {'eventId': eventId});

  Future<T?> _invoke<T>(String method, [Object? args]) async {
    try {
      return await _channel.invokeMethod<T>(method, args);
    } on PlatformException catch (e) {
      throw CalendarException(e.message ?? e.code);
    }
  }
}
