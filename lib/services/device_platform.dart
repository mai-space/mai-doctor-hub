import 'package:flutter/foundation.dart';

/// Plattform der nativen App. Über `defaultTargetPlatform`, damit Tests sie
/// mit `debugDefaultTargetPlatformOverride` umstellen können.
abstract final class DevicePlatform {
  static bool get isAndroid =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  static bool get isIOS =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.iOS;

  /// Android oder iOS — dort gibt es die eigenen nativen Kanäle (`mai/…`).
  static bool get isMobile => isAndroid || isIOS;
}
