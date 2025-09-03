import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Material 3 ThemeData for light mode.
/// Explicit ColorScheme constructed from tokens to preserve brand colors.
ThemeData buildLightTheme() {
  const scheme = ColorScheme(
    brightness: Brightness.light,
    // Primary/secondary/tertiary map to brand accents
    primary: AppColors.kPrimary,
    onPrimary: AppColors.kOnPrimary,
    secondary: AppColors.kSecondary,
    onSecondary: AppColors.kOnSecondary,
    tertiary: AppColors.kAccent,
    onTertiary: AppColors.kOnAccent,
    // Surface/background and text mappings from light core tokens
    surface: AppColors.kLightSurface,
    onSurface: AppColors.kLightTextPrimary,
    background: AppColors.kLightBackground,
    onBackground: AppColors.kLightTextPrimary,
    // Error uses Material baseline; can be customized later
    error: Colors.red,
    onError: Colors.white,
    // Containers use slightly adjusted roles; keep simple for v0
    primaryContainer: AppColors.kPrimary,
    onPrimaryContainer: AppColors.kOnPrimary,
    secondaryContainer: AppColors.kSecondary,
    onSecondaryContainer: AppColors.kOnSecondary,
    tertiaryContainer: AppColors.kAccent,
    onTertiaryContainer: AppColors.kOnAccent,
    surfaceVariant: AppColors.kNeutralBorder,
    onSurfaceVariant: AppColors.kLightTextSecondary,
    outline: AppColors.kNeutralBorder,
    outlineVariant: AppColors.kNeutralBorder,
    inverseSurface: AppColors.kLightTextPrimary,
    onInverseSurface: AppColors.kLightBackground,
    inversePrimary: AppColors.kPrimary,
    shadow: Colors.black12,
    scrim: Colors.black54,
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: scheme.background,
    appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
  );
}
