import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Material 3 ThemeData for dark mode (contrast-checked against tokens).
ThemeData buildDarkTheme() {
  final scheme =
      ColorScheme.fromSeed(
        seedColor: AppColors.kPrimary,
        brightness: Brightness.dark,
      ).copyWith(
        primary: AppColors.kPrimary,
        onPrimary: AppColors.kOnPrimary,
        secondary: AppColors.kSecondary,
        onSecondary: AppColors.kOnSecondary,
        tertiary: AppColors.kAccent,
        onTertiary: AppColors.kOnAccent,
        surface: AppColors.kDarkSurface,
        onSurface: AppColors.kDarkTextPrimary,
        outline: AppColors.kNeutralMuted,
        surfaceContainerHighest: AppColors.kNeutralMuted,
      );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.kDarkBackground,
    appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: scheme.primary,
      unselectedItemColor: scheme.onSurfaceVariant,
      backgroundColor: scheme.surface,
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: scheme.surface,
      indicatorColor: scheme.primary.withOpacity(0.15),
      selectedIconTheme: const IconThemeData().copyWith(color: scheme.primary),
      unselectedIconTheme: const IconThemeData().copyWith(
        color: scheme.onSurfaceVariant,
      ),
      selectedLabelTextStyle: TextStyle(color: scheme.primary),
      unselectedLabelTextStyle: TextStyle(color: scheme.onSurfaceVariant),
    ),
  );
}
