import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    final color = const Color(0xFF0F2536); // primary/nav from STACK.md
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: color),
      appBarTheme: const AppBarTheme(elevation: 0, centerTitle: true),
    );
  }
}
