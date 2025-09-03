import 'package:flutter/material.dart';
import 'package:template_v2/theme/app_theme_dark.dart';
import 'package:template_v2/theme/app_theme_light.dart';

class AppTheme {
  /// Example usage:
  /// MaterialApp(theme: AppTheme.light(), darkTheme: AppTheme.dark(), ...)
  static ThemeData light() => buildLightTheme();

  static ThemeData dark() => buildDarkTheme();
}
