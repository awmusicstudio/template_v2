import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Material 3 ThemeData for dark mode (contrast-checked against tokens).
ThemeData buildDarkTheme() {
  const scheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.kPrimary,
    onPrimary: AppColors.kOnPrimary,
    secondary: AppColors.kSecondary,
    onSecondary: AppColors.kOnSecondary,
    tertiary: AppColors.kAccent,
    onTertiary: AppColors.kOnAccent,
    surface: AppColors.kDarkSurface,
    onSurface: AppColors.kDarkTextPrimary,
    background: AppColors.kDarkBackground,
    onBackground: AppColors.kDarkTextPrimary,
    error: Colors.redAccent,
    onError: Colors.black,
    primaryContainer: AppColors.kPrimary,
    onPrimaryContainer: AppColors.kOnPrimary,
    secondaryContainer: AppColors.kSecondary,
    onSecondaryContainer: AppColors.kOnSecondary,
    tertiaryContainer: AppColors.kAccent,
    onTertiaryContainer: AppColors.kOnAccent,
    surfaceVariant: AppColors.kNeutralMuted,
    onSurfaceVariant: AppColors.kDarkTextSecondary,
    outline: AppColors.kNeutralMuted,
    outlineVariant: AppColors.kNeutralMuted,
    inverseSurface: AppColors.kDarkTextPrimary,
    onInverseSurface: AppColors.kDarkBackground,
    inversePrimary: AppColors.kPrimary,
    shadow: Colors.black,
    scrim: Colors.black87,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.background,
    appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
  );
}
