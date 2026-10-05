import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/data/repositories/settings_repository.dart';
import 'package:mai_doctor_hub/services/notification_service.dart';

/// Attrappe für die Benachrichtigungs-Berechtigung.
class FakePermissions implements NotificationPermissions {
  FakePermissions({this.granted = false, this.grantOnRequest = true});

  bool granted;
  bool grantOnRequest;
  int requests = 0;

  @override
  Future<bool> has() async => granted;

  @override
  Future<bool> request() async {
    requests++;
    return granted = grantOnRequest;
  }
}

/// Installiert eine Berechtigungs-Attrappe und gibt sie zurück.
FakePermissions useFakePermissions({bool granted = true}) {
  final fake = FakePermissions(granted: granted);
  NotificationPermissions.current = fake;
  return fake;
}

/// Für Tests, die direkt in der App (nicht im Onboarding) starten.
Future<void> markOnboarded(AppDatabase db) =>
    SettingsRepository(db).completeOnboarding();
