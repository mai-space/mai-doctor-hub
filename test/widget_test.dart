import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mai_doctor_hub/data/app_database.dart';
import 'package:mai_doctor_hub/main.dart';

void main() {
  late AppDatabase database;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() async {
    await database.close();
  });

  testWidgets('Sticky footer shows four destinations', (tester) async {
    await tester.pumpWidget(MaiDoctorHubApp(database: database));

    expect(find.text('Home'), findsWidgets);
    expect(find.text('Kalender'), findsOneWidget);
    expect(find.text('Meine Akte'), findsOneWidget);
    expect(find.text('Einstellungen'), findsOneWidget);
    expect(find.text('Termin hinzufügen'), findsOneWidget);
  });

  testWidgets('Kalender tab exposes view mode toggle', (tester) async {
    await tester.pumpWidget(MaiDoctorHubApp(database: database));

    await tester.tap(find.text('Kalender'));
    await tester.pumpAndSettle();

    expect(find.text('Tag'), findsOneWidget);
    expect(find.text('Woche'), findsOneWidget);
    expect(find.text('Monat'), findsWidgets);
    expect(find.text('Jahr'), findsOneWidget);
  });
}
