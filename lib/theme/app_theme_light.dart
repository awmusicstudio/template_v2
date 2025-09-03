import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Material 3 ThemeData for light mode.
/// Explicit ColorScheme constructed from tokens to preserve brand colors.
ThemeData buildLightTheme() {
  final scheme =
      ColorScheme.fromSeed(
        seedColor: AppColors.kPrimary,
        brightness: Brightness.light,
      ).copyWith(
        // Preserve intended brand accents and text/surfaces
        primary: AppColors.kPrimary,
        onPrimary: AppColors.kOnPrimary,
        secondary: AppColors.kSecondary,
        onSecondary: AppColors.kOnSecondary,
        tertiary: AppColors.kAccent,
        onTertiary: AppColors.kOnAccent,
        surface: AppColors.kLightSurface,
        onSurface: AppColors.kLightTextPrimary,
        // Map deprecated background fields usage to surface where needed
        outline: AppColors.kNeutralBorder,
        surfaceContainerHighest: AppColors.kNeutralBorder,
      );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: AppColors.kLightBackground,
    appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
  );
}
