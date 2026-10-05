import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

/// Web: Speicher des Browsers, keine Verschlüsselung.
DatabaseConnection openAppDatabase() => driftDatabase(name: 'mai_doctor_hub');
