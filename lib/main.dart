import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'data/app_database.dart';
import 'data/database_provider.dart';
import 'data/repositories/settings_repository.dart';
import 'features/check_in/check_in_sheet.dart';
import 'services/notification_service.dart';
import 'shell/app_shell.dart';
import 'theme/app_theme.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

  try {
    final settings = await SettingsRepository(database).get();
    await NotificationService.instance.syncFromSettings(settings);
  } catch (_) {
    // Settings-Zeile fehlt ggf. in Tests mit leerer DB — ignorieren.
  }

  runApp(MaiDoctorHubApp(database: database));
}

class MaiDoctorHubApp extends StatelessWidget {
  const MaiDoctorHubApp({super.key, required this.database});

  final AppDatabase database;

  @override
  Widget build(BuildContext context) {
    return DatabaseScope(
      database: database,
      child: MaterialApp(
        navigatorKey: appNavigatorKey,
        title: 'Mai Doctor Hub',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const AppShell(),
      ),
    );
  }
}
