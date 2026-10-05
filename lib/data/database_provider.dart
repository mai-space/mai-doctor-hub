import 'package:flutter/widgets.dart';

import 'app_database.dart';

/// Stellt die lokale [AppDatabase] im Widget-Baum bereit.
class DatabaseScope extends InheritedWidget {
  const DatabaseScope({
    super.key,
    required this.database,
    required super.child,
  });

  final AppDatabase database;

  static AppDatabase of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<DatabaseScope>();
    assert(scope != null, 'DatabaseScope fehlt im Widget-Baum');
    return scope!.database;
  }

  @override
  bool updateShouldNotify(DatabaseScope oldWidget) =>
      database != oldWidget.database;
}
