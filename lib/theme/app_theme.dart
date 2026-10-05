import 'package:flutter/material.dart';

/// Design tokens for Mai Doctor Hub — calm clinical clarity, privacy-first.
abstract final class AppColors {
  static const Color seed = Color(0xFF1F6B5C);
  static const Color surface = Color(0xFFF6F8F7);
  static const Color ink = Color(0xFF14201D);
  static const Color muted = Color(0xFF5A6B66);
  static const Color accent = Color(0xFF2A9D8F);
  static const Color danger = Color(0xFFB33A3A);
}

abstract final class AppTheme {
  static ThemeData light() {
    final base = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: Brightness.light,
      surface: AppColors.surface,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: base,
      scaffoldBackgroundColor: AppColors.surface,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.ink,
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: base.primaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        height: 72,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
      textTheme: ThemeData(brightness: Brightness.light).textTheme.apply(
        bodyColor: AppColors.ink,
        displayColor: AppColors.ink,
      ),
    );
  }
}
