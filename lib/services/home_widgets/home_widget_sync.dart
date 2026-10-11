import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../data/app_database.dart';
import '../device_platform.dart';
import 'widget_actions.dart';
import 'widget_snapshot.dart';

/// Verbindung zu den nativen Widgets (austauschbar für Tests).
abstract interface class HomeWidgetBridge {
  /// Schreibt den Snapshot, entfernt bestätigte Eingaben aus der
  /// Warteschlange und zeichnet alle Widgets neu.
  Future<void> update(String snapshot, List<String> ack);

  /// Noch nicht übernommene Eingaben am Widget (JSON-Liste) oder `null`.
  Future<String?> pendingActions();

  /// Ziel, mit dem die App per Widget-Tipp gestartet wurde (einmalig).
  Future<String?> takeLaunchLink();

  /// Tipp auf ein Widget, während die App schon läuft.
  set onOpen(void Function(String link)? handler);
}

/// Android: Kanal `mai/home_widgets` (`HomeWidgetChannel.kt`).
class MethodChannelHomeWidgetBridge implements HomeWidgetBridge {
  MethodChannelHomeWidgetBridge() {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'open' && call.arguments is String) {
        _onOpen?.call(call.arguments as String);
      }
    });
  }

  static const _channel = MethodChannel('mai/home_widgets');
  void Function(String link)? _onOpen;

  @override
  set onOpen(void Function(String link)? handler) => _onOpen = handler;

  @override
  Future<void> update(String snapshot, List<String> ack) =>
      _channel.invokeMethod<void>('update', {
        'snapshot': snapshot,
        'ack': ack,
      });

  @override
  Future<String?> pendingActions() =>
      _channel.invokeMethod<String>('pendingActions');

  @override
  Future<String?> takeLaunchLink() =>
      _channel.invokeMethod<String>('takeLaunchLink');
}

/// Hält die Startbildschirm-Widgets aktuell: schreibt bei jeder relevanten
/// Datenänderung einen neuen Snapshot und übernimmt Eingaben vom Widget,
/// sobald die App läuft bzw. in den Vordergrund kommt.
class HomeWidgetSync with WidgetsBindingObserver {
  HomeWidgetSync(
    this._db, {
    HomeWidgetBridge? bridge,
    this.debounce = const Duration(milliseconds: 400),
    DateTime Function()? clock,
  }) : _bridge = bridge ?? MethodChannelHomeWidgetBridge(),
       _clock = clock ?? DateTime.now;

  /// Widgets gibt es (bisher) nur auf Android.
  static bool get isSupported => DevicePlatform.isAndroid;

  final AppDatabase _db;
  final HomeWidgetBridge _bridge;
  final Duration debounce;
  final DateTime Function() _clock;

  StreamSubscription<void>? _changes;
  Timer? _timer;
  Future<void> _queue = Future.value();

  /// Ziel eines Widget-Tipps (Termin, Medikamente, Check-in).
  set onOpen(void Function(WidgetLink link)? handler) {
    _bridge.onOpen = handler == null
        ? null
        : (raw) {
            final link = WidgetLink.parse(raw);
            if (link != null) handler(link);
          };
  }

  void start() {
    _changes = _db
        .watchTables({
          _db.appSettings,
          _db.appointments,
          _db.doctors,
          _db.medications,
          _db.medicationSchedules,
          _db.medicationIntakes,
          _db.symptoms,
          _db.symptomObservations,
        })
        .listen((_) => _schedule(), onError: _log);
    WidgetsBinding.instance.addObserver(this);
    _run(applyPending());
  }

  Future<void> stop() async {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    await _changes?.cancel();
  }

  /// Startziel abholen (App per Widget-Tipp gestartet).
  Future<WidgetLink?> launchLink() async {
    try {
      return WidgetLink.parse(await _bridge.takeLaunchLink());
    } on MissingPluginException {
      return null;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _run(applyPending());
  }

  void _schedule() {
    _timer?.cancel();
    _timer = Timer(debounce, () => _run(refresh()));
  }

  /// Snapshot neu schreiben ([ack]: übernommene Eingaben).
  Future<void> refresh({List<String> ack = const []}) =>
      _serial(() => _write(ack));

  /// Eingaben vom Widget übernehmen, dann Snapshot schreiben und die
  /// Eingaben bestätigen (erst danach verschwinden sie am Widget).
  Future<int> applyPending() => _serial(() async {
    final String? raw;
    try {
      raw = await _bridge.pendingActions();
    } on MissingPluginException {
      return 0;
    }
    final ids = WidgetAction.queueIds(raw);
    final applied = await applyWidgetActions(
      _db,
      WidgetAction.parseQueue(raw),
    );
    await _write(ids);
    return applied;
  });

  Future<void> _write(List<String> ack) async {
    final snapshot = await buildWidgetSnapshot(_db, now: _clock());
    try {
      await _bridge.update(jsonEncode(snapshot), ack);
    } on MissingPluginException {
      // Tests / Plattform ohne Widgets.
    }
  }

  /// Nacheinander statt parallel — sonst könnte ein älterer Snapshot einen
  /// neueren überschreiben.
  Future<T> _serial<T>(Future<T> Function() task) {
    final result = _queue.then((_) => task());
    _queue = result.then<void>((_) {}, onError: (_) {});
    return result;
  }

  static void _log(Object e) => debugPrint('Widgets: $e');

  static void _run(Future<Object?> task) =>
      unawaited(task.then<void>((_) {}, onError: _log));
}
