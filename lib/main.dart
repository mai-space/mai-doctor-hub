import 'package:drift/drift.dart' show DriftWrappedException;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:pdfrx/pdfrx.dart';

import 'data/app_database.dart';
import 'data/database_provider.dart';
import 'data/repositories/records_repository.dart' show reportsDirectory;
import 'data/repositories/settings_repository.dart';
import 'features/check_in/check_in_sheet.dart';
import 'features/home/appointment_detail_page.dart';
import 'features/medications/intake_widgets.dart';
import 'features/onboarding/onboarding_page.dart';
import 'features/records/detail_pages.dart';
import 'services/app_lock.dart';
import 'services/calendar/calendar_gateway.dart';
import 'services/calendar/calendar_sync_service.dart';
import 'services/notification_service.dart';
import 'services/notifications/appointment_reminders.dart';
import 'services/notifications/medication_reminders.dart';
import 'services/notifications/notification_plan.dart';
import 'services/notifications/reminder_service.dart';
import 'services/notifications/vaccination_reminders.dart';
import 'services/file_vault.dart';
import 'services/temp_files.dart';
import 'services/time_change_observer.dart';
import 'data/connection/connection.dart';
import 'data/connection/database_key.dart';
import 'l10n/l10n.dart';
import 'shell/app_shell.dart';
import 'theme/app_theme.dart';
import 'widgets/app_lock_gate.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  pdfrxFlutterInitialize();
  await initializeDateFormatting();
  AppLocale.update(
    AppLocale.resolve(WidgetsBinding.instance.platformDispatcher.locales),
  );
  await _start();
}

Future<void> _start() async {
  final database = AppDatabase();
  // Schlüssel vorübergehend nicht lesbar (Keystore hakt): nichts verwerfen,
  // sondern erneut versuchen lassen.
  try {
    await database.customSelect('SELECT 1').get();
  } catch (e) {
    if (!_isKeyUnavailable(e)) rethrow;
    await database.close().catchError((Object _) {});
    runApp(_KeyUnavailableApp(onRetry: _start));
    return;
  }
  // Berichte/Medien verschlüsselt; Altdateien im Hintergrund nachziehen.
  FileVault.current = await FileVault.open();
  reportsDirectory()
      .then(FileVault.current.migrate)
      .then((n) {
        if (n > 0) debugPrint('$n Dateien verschlüsselt');
      })
      .catchError((Object e) => debugPrint('Verschlüsselung: $e'));

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
  final medicationReminders = MedicationReminderService(database, notifications)
    ..start();
  final vaccinationReminders = VaccinationReminderService(
    database,
    notifications,
  )..start();

  // Ein Android-Kanal je Thema in der gewählten Wichtigkeit.
  final topicSettings = SettingsRepository(
    database,
  ).watch().map((s) => s.notificationTopics).distinct();
  topicSettings.listen((raw) {
    notifications
        .applyChannels(NotificationPreferences.parse(raw))
        .catchError((Object e) => debugPrint('Kanäle: $e'));
  }, onError: (Object e) => debugPrint('Kanäle: $e'));

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
    await vaccinationReminders.sync();
    calendarSync?.trigger();
  }).attach();

  // Sprache im System gewechselt: Texte in Benachrichtigungen und
  // Kalendereinträgen neu erzeugen.
  AppLocale.changes.addListener(() async {
    final settings = await SettingsRepository(database).get();
    await notifications.applyChannels(
      NotificationPreferences.parse(settings.notificationTopics),
    );
    await reminders.sync();
    await appointmentReminders.sync();
    await medicationReminders.sync();
    await vaccinationReminders.sync();
    calendarSync?.trigger();
  });

  runApp(MaiDoctorHubApp(database: database, appLock: appLock));

  // Klartext-Reste früherer Scans, Auswahlen und Freigaben entfernen.
  TempFiles.purge().ignore();

  if (databaseOpenStatus.value?.unreadableCopy != null) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _showUnreadableData());
  }

  final launch = await notifications.launchPayload();
  if (launch != null) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _openFromNotification(launch),
    );
  }
}

bool _isKeyUnavailable(Object e) =>
    e is DatabaseKeyUnavailable ||
    (e is DriftWrappedException && e.cause is DatabaseKeyUnavailable);

class _KeyUnavailableApp extends StatelessWidget {
  const _KeyUnavailableApp({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: AppLocale.supported,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: AppTheme.light(),
      home: Builder(
        builder: (context) => Scaffold(
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.lock_clock_outlined, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    context.l10n.settingsKeyUnavailableTitle,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    context.l10n.settingsKeyUnavailableText,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: onRetry,
                    child: Text(context.l10n.commonRetry),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Die gespeicherte Datenbank ließ sich nicht entschlüsseln (z. B. Schlüssel
/// nach Zurücksetzen des Keystores verloren) und wurde beiseitegelegt.
void _showUnreadableData() {
  final context = appNavigatorKey.currentContext;
  if (context == null) return;
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(Icons.lock_reset),
      title: Text(context.l10n.settingsUnreadableTitle),
      content: Text(context.l10n.settingsUnreadableText),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.commonUnderstood),
        ),
      ],
    ),
  );
}

void _openFromNotification(String? payload) {
  final context = appNavigatorKey.currentContext;
  if (context == null) return;
  final symptomIds = CheckInPayload.decode(payload);
  if (symptomIds != null) showCheckInSheet(context, symptomIds: symptomIds);
  if (MedicationPayload.decode(payload) case (final id, final at)?) {
    showIntakeConfirmDialog(context, id, at);
  }
  final vaccinationId = VaccinationPayload.decode(payload);
  if (vaccinationId != null) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => VaccinationDetailPage(vaccinationId: vaccinationId),
      ),
    );
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
          onGenerateTitle: (context) => context.l10n.appTitle,
          debugShowCheckedModeBanner: false,
          supportedLocales: AppLocale.supported,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeListResolutionCallback: (locales, _) {
            final locale = AppLocale.resolve(locales ?? const []);
            AppLocale.update(locale);
            return locale;
          },
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
      stream: SettingsRepository(db)
          .watch()
          .map((s) => s.onboardingCompleted)
          .distinct(),
      builder: (context, snapshot) => switch (snapshot.data) {
        null => const Scaffold(body: SizedBox.shrink()),
        false => const OnboardingPage(),
        true => const AppShell(),
      },
    );
  }
}
