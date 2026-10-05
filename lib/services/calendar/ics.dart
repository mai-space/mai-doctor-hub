import 'calendar_gateway.dart';

/// Minimaler iCalendar-Export (RFC 5545) für „Zum Kalender hinzufügen“.
abstract final class Ics {
  static String event({
    required String uid,
    required CalendarEventData event,
    DateTime? now,
  }) {
    final lines = [
      'BEGIN:VCALENDAR',
      'VERSION:2.0',
      'PRODID:-//Mai Doctor Hub//DE',
      'CALSCALE:GREGORIAN',
      'METHOD:PUBLISH',
      'BEGIN:VEVENT',
      'UID:$uid@mai-doctor-hub',
      'DTSTAMP:${_utc(now ?? DateTime.now())}',
      'DTSTART:${_utc(event.start)}',
      'DTEND:${_utc(event.end)}',
      'SUMMARY:${_escape(event.title)}',
      if (event.location?.isNotEmpty == true)
        'LOCATION:${_escape(event.location!)}',
      if (event.description?.isNotEmpty == true)
        'DESCRIPTION:${_escape(event.description!)}',
      'END:VEVENT',
      'END:VCALENDAR',
    ];
    return '${lines.map(_fold).join('\r\n')}\r\n';
  }

  static String _utc(DateTime dt) {
    final u = dt.toUtc();
    String two(int v) => v.toString().padLeft(2, '0');
    return '${u.year}${two(u.month)}${two(u.day)}T'
        '${two(u.hour)}${two(u.minute)}${two(u.second)}Z';
  }

  static String _escape(String text) => text
      .replaceAll(r'\', r'\\')
      .replaceAll(';', r'\;')
      .replaceAll(',', r'\,')
      .replaceAll(RegExp(r'\r?\n'), r'\n');

  /// Zeilen > 75 Oktette falten (Fortsetzung beginnt mit Leerzeichen).
  static String _fold(String line) {
    if (line.length <= 75) return line;
    final buffer = StringBuffer(line.substring(0, 75));
    for (var i = 75; i < line.length; i += 74) {
      final end = i + 74 < line.length ? i + 74 : line.length;
      buffer.write('\r\n ${line.substring(i, end)}');
    }
    return buffer.toString();
  }
}
