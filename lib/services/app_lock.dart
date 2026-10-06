import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:local_auth/local_auth.dart';

import '../l10n/l10n.dart';

/// Entsperren per Biometrie oder Geräte-PIN — austauschbar für Tests.
abstract interface class LockAuthenticator {
  /// Hat das Gerät eine Displaysperre/Biometrie, die wir nutzen können?
  Future<bool> isAvailable();

  Future<bool> authenticate(String reason);
}

class DeviceLockAuthenticator implements LockAuthenticator {
  DeviceLockAuthenticator([LocalAuthentication? auth])
    : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  @override
  Future<bool> isAvailable() async {
    if (kIsWeb) return false;
    try {
      return await _auth.isDeviceSupported();
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> authenticate(String reason) async {
    try {
      // biometricOnly: false → Fallback auf Geräte-PIN/Muster.
      return await _auth.authenticate(localizedReason: reason);
    } on LocalAuthException catch (e) {
      debugPrint('Entsperren fehlgeschlagen: ${e.code.name}');
      return false;
    } on PlatformException catch (e) {
      debugPrint('Entsperren fehlgeschlagen: ${e.code}');
      return false;
    }
  }
}

/// Setzt `FLAG_SECURE` (Android): keine Inhalte in Screenshots/„Zuletzt“.
abstract final class SecureWindow {
  static const _channel = MethodChannel('mai/secure_window');

  static Future<void> setSecure(bool secure) async {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) return;
    try {
      await _channel.invokeMethod<void>('setSecure', secure);
    } on MissingPluginException {
      // Tests / andere Plattformen.
    }
  }
}

/// Sperrt die App beim Start und nach [relockAfter] im Hintergrund.
class AppLockController extends ChangeNotifier with WidgetsBindingObserver {
  AppLockController({
    required this.authenticator,
    bool enabled = false,
    this.relockAfter = const Duration(seconds: 60),
    DateTime Function()? clock,
  }) : _enabled = enabled,
       _locked = enabled,
       _clock = clock ?? DateTime.now;

  final LockAuthenticator authenticator;
  final Duration relockAfter;
  final DateTime Function() _clock;

  bool _enabled;
  bool _locked;
  bool _authenticating = false;
  DateTime? _backgroundedAt;

  bool get enabled => _enabled;
  bool get locked => _enabled && _locked;
  bool get authenticating => _authenticating;

  void attach() => WidgetsBinding.instance.addObserver(this);

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Übernimmt den gespeicherten Zustand (ohne sofort zu sperren).
  void setEnabled(bool value) {
    if (_enabled == value) return;
    _enabled = value;
    if (!value) _locked = false;
    SecureWindow.setSecure(value);
    notifyListeners();
  }

  /// Erst nach erfolgreicher Authentifizierung einschalten — so sperrt sich
  /// niemand aus, dessen Gerät keine Sperre hat.
  Future<bool> enableWithConfirmation() async {
    if (!await authenticator.isAvailable()) return false;
    final ok = await _authenticate(AppLocale.strings.settingsLockReasonSetup);
    if (ok) setEnabled(true);
    return ok;
  }

  /// Ausschalten nur nach Authentifizierung — sonst könnte jeder mit dem
  /// entsperrten Gerät in der Hand den Schutz still abschalten.
  Future<bool> disableWithConfirmation() async {
    if (!_enabled) return true;
    final ok = await _authenticate(
      AppLocale.strings.settingsLockReasonDisable,
    );
    if (ok) setEnabled(false);
    return ok;
  }

  Future<bool> unlock() async {
    if (!locked) return true;
    final ok = await _authenticate(
      AppLocale.strings.settingsLockReasonUnlock,
    );
    if (ok) {
      _locked = false;
      notifyListeners();
    }
    return ok;
  }

  Future<bool> _authenticate(String reason) async {
    if (_authenticating) return false;
    _authenticating = true;
    notifyListeners();
    try {
      return await authenticator.authenticate(reason);
    } finally {
      _authenticating = false;
      notifyListeners();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Der System-Dialog fürs Entsperren pausiert die App ebenfalls.
    if (_authenticating) return;
    switch (state) {
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        _backgroundedAt ??= _clock();
      case AppLifecycleState.resumed:
        final since = _backgroundedAt;
        _backgroundedAt = null;
        if (_enabled &&
            since != null &&
            _clock().difference(since) >= relockAfter) {
          _locked = true;
          notifyListeners();
        }
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }
}

class AppLockScope extends InheritedNotifier<AppLockController> {
  const AppLockScope({
    super.key,
    required AppLockController controller,
    required super.child,
  }) : super(notifier: controller);

  static AppLockController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppLockScope>();
    assert(scope != null, 'AppLockScope fehlt im Widget-Baum');
    return scope!.notifier!;
  }
}
