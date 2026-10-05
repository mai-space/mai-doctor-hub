import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pdfrx/pdfrx.dart';

import 'data/app_database.dart';
import 'data/database_provider.dart';
import 'data/repositories/settings_repository.dart';
import 'features/check_in/check_in_sheet.dart';
import 'features/home/appointment_detail_page.dart';
import 'features/medications/intake_widgets.dart';
import 'features/onboarding/onboarding_page.dart';
import 'services/app_lock.dart';
import 'services/calendar/calendar_gateway.dart';
import 'services/calendar/calendar_sync_service.dart';
import 'services/notification_service.dart';
import 'services/notifications/appointment_reminders.dart';
import 'services/notifications/medication_reminders.dart';
import 'services/notifications/reminder_service.dart';
import 'services/time_change_observer.dart';
import 'shell/app_shell.dart';
import 'theme/app_theme.dart';
import 'widgets/app_lock_gate.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  pdfrxFlutterInitialize();
  await initializeDateFormatting('de');

  final database = AppDatabase();
  final notifications = NotificationService.instance;
  await notifications.initialize();
  notifications.onNotificationTap = _openFromNotification;
  // Keine Berechtigungsabfrage beim Start — das passiert im Onboarding.

  // Erinnerungen sind eigene Einträge; Änderungen planen automatisch neu.
  final reminders = ReminderService(database, notifications)..start();
  final appointmentReminders = AppointmentReminderService(
    database,
    notifications,
  )..start();
  final medicationReminders = MedicationReminderService(
    database,
    notifications,
  )..start();

  var lockEnabled = false;
  try {
    final settings = await SettingsRepository(database).get();
    lockEnabled = settings.appLockEnabled;
  } catch (_) {
    // Settings-Zeile fehlt ggf. in Tests mit leerer DB — ignorieren.
  }

  // Sperre steht vor dem ersten Frame fest → kein Aufblitzen von Daten.
  final appLock = AppLockController(
    authenticator: DeviceLockAuthenticator(),
    enabled: lockEnabled,
  )..attach();
  if (lockEnabled) await SecureWindow.setSecure(true);

  // Einseitiger Kalender-Export: gleicht bei Änderungen automatisch ab.
  final calendar = AndroidCalendarGateway();
  final calendarSync = calendar.isSupported
      ? (CalendarAutoSync(database, CalendarSyncService(database, calendar))
          ..start())
      : null;

  // Zurück im Vordergrund: Zeitzone geändert? → Erinnerungen neu planen,
  // Kalender abgleichen (Events tragen die Gerätezone).
  TimeChangeObserver(() async {
    if (await notifications.refreshTimeZone()) await reminders.sync();
    // Vergangene Vorlaufzeiten fallen weg, neue Tage kommen dazu.
    await appointmentReminders.sync();
    await medicationReminders.sync();
    calendarSync?.trigger();
  }).attach();

  runApp(MaiDoctorHubApp(database: database, appLock: appLock));

  final launch = await notifications.launchPayload();
  if (launch != null) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _openFromNotification(launch),
    );
  }
}

void _openFromNotification(String? payload) {
  final context = appNavigatorKey.currentContext;
  if (context == null) return;
  final symptomIds = CheckInPayload.decode(payload);
  if (symptomIds != null) showCheckInSheet(context, symptomIds: symptomIds);
  if (MedicationPayload.decode(payload) case (final id, final at)?) {
    showIntakeConfirmDialog(context, id, at);
  }
  final appointmentId = AppointmentPayload.decode(payload);
  if (appointmentId != null) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AppointmentDetailPage(appointmentId: appointmentId),
      ),
    );
  }
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
          home: const _Home(),
        ),
      ),
    );
  }
}

/// Onboarding beim ersten Start, danach die App.
class _Home extends StatelessWidget {
  const _Home();

  @override
  Widget build(BuildContext context) {
    final db = DatabaseScope.of(context);
    return StreamBuilder<bool>(
      stream: SettingsRepository(
        db,
      ).watch().map((s) => s.onboardingCompleted).distinct(),
      builder: (context, snapshot) => switch (snapshot.data) {
        null => const Scaffold(body: SizedBox.shrink()),
        false => const OnboardingPage(),
        true => const AppShell(),
      },
    );
  }
}
