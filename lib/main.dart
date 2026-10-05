import 'package:flutter/material.dart';

import 'data/app_database.dart';
import 'data/database_provider.dart';
import 'shell/app_shell.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
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
        title: 'Mai Doctor Hub',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const AppShell(),
      ),
    );
  }
}
