import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:template_v2/app/app_theme.dart';
import 'package:template_v2/theme/app_colors.dart';

void main() {
  test('AppTheme.light has light brightness', () {
    final theme = AppTheme.light();
    expect(theme.brightness, Brightness.light);
  });

  test('AppTheme.dark has dark brightness', () {
    final theme = AppTheme.dark();
    expect(theme.brightness, Brightness.dark);
  });

  test('Optional: primary color token is used in light scheme', () {
    final theme = AppTheme.light();
    expect(theme.colorScheme.primary, AppColors.kPrimary);
  });
}
