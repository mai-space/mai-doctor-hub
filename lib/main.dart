import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pdfrx/pdfrx.dart';

import 'data/app_database.dart';
import 'data/database_provider.dart';
import 'data/repositories/settings_repository.dart';
import 'features/check_in/check_in_sheet.dart';
import 'services/app_lock.dart';
import 'services/notification_service.dart';
import 'shell/app_shell.dart';
import 'theme/app_theme.dart';
import 'widgets/app_lock_gate.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  pdfrxFlutterInitialize();
  await initializeDateFormatting('de');

  final database = AppDatabase();
  await NotificationService.instance.initialize();
  NotificationService.instance.onNotificationTap = (payload) {
    if (payload == NotificationService.checkInPayload) {
      final context = appNavigatorKey.currentContext;
      if (context != null) {
        showCheckInSheet(context);
      }
    }
  };

  var lockEnabled = false;
  try {
    final settings = await SettingsRepository(database).get();
    lockEnabled = settings.appLockEnabled;
    await NotificationService.instance.syncFromSettings(settings);
  } catch (_) {
    // Settings-Zeile fehlt ggf. in Tests mit leerer DB — ignorieren.
  }

  // Sperre steht vor dem ersten Frame fest → kein Aufblitzen von Daten.
  final appLock = AppLockController(
    authenticator: DeviceLockAuthenticator(),
    enabled: lockEnabled,
  )..attach();
  if (lockEnabled) await SecureWindow.setSecure(true);

  runApp(MaiDoctorHubApp(database: database, appLock: appLock));
}

class MaiDoctorHubApp extends StatefulWidget {
  const MaiDoctorHubApp({super.key, required this.database, this.appLock});

  final AppDatabase database;

  /// Ohne Angabe: Sperre aus (z. B. in Tests).
  final AppLockController? appLock;

  @override
  State<MaiDoctorHubApp> createState() => _MaiDoctorHubAppState();
}

class _MaiDoctorHubAppState extends State<MaiDoctorHubApp> {
  late final AppLockController _lock =
      widget.appLock ??
      AppLockController(authenticator: DeviceLockAuthenticator());

  @override
  void dispose() {
    if (widget.appLock == null) _lock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DatabaseScope(
      database: widget.database,
      child: AppLockScope(
        controller: _lock,
        child: MaterialApp(
          navigatorKey: appNavigatorKey,
          title: 'Mai Doctor Hub',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          builder: (context, child) => AppLockGate(child: child!),
          home: const AppShell(),
        ),
      ),
    );
  }
}
