import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
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

/// path_provider ohne Plugin: alles unter [root].
class FakePathProvider extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  FakePathProvider(this.root);

  final String root;

  @override
  Future<String?> getApplicationDocumentsPath() async => '$root/docs';

  @override
  Future<String?> getTemporaryPath() async => '$root/tmp';
}

void useFakePathProvider(String root) =>
    PathProviderPlatform.instance = FakePathProvider(root);
