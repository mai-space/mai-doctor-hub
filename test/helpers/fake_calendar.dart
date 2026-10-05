import 'package:mai_doctor_hub/services/calendar/calendar_gateway.dart';

/// Kalender im Speicher: calendarId → eventId → Event.
class FakeCalendar implements CalendarGateway {
  final events = <String, Map<String, CalendarEventData>>{};
  final foreign = <String, CalendarEventData>{}; // fremde Events
  bool permission = true;
  int writes = 0;
  int _next = 1;
  Set<String> failOnTitle = {};

  @override
  bool get isSupported => true;

  @override
  Future<bool> hasPermission() async => permission;

  @override
  Future<bool> requestPermission() async => permission = true;

  @override
  Future<List<DeviceCalendar>> listCalendars() async => const [
    DeviceCalendar(
      id: 'local',
      name: 'Telefon',
      accountName: 'Telefon',
      accountType: 'LOCAL',
    ),
    DeviceCalendar(
      id: 'g1',
      name: 'Privat',
      accountName: 'me@gmail.com',
      accountType: 'com.google',
      isPrimary: true,
    ),
  ];

  @override
  Future<String> upsertEvent(
    String calendarId,
    CalendarEventData event, {
    String? eventId,
  }) async {
    if (failOnTitle.any(event.title.contains)) {
      throw const CalendarException('boom');
    }
    writes++;
    final calendar = events.putIfAbsent(calendarId, () => {});
    final id = eventId != null && calendar.containsKey(eventId)
        ? eventId
        : 'e${_next++}';
    calendar[id] = event;
    return id;
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    for (final calendar in events.values) {
      calendar.remove(eventId);
    }
  }

  List<CalendarEventData> all(String calendarId) =>
      events[calendarId]?.values.toList() ?? const [];
}

