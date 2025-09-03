import 'package:flutter/material.dart';

/// App color tokens derived from the reference spec (see app_colors.txt).
/// Names are stable and map 1:1 with the documented roles.
class AppColors {
  // --- Brand accents (shared for light & dark) ---
  // Source: primaryTeal / secondaryYellow / accentOrange
  static const Color kPrimary = Color(0xFF69A295);
  static const Color kSecondary = Color(0xFFDAAC50);
  static const Color kAccent = Color(0xFFD86D51);

  // On-color tokens for text/icons placed on accent surfaces
  // Source: onPrimary / onSecondary / onAccent
  static const Color kOnPrimary = Color(0xFFFFFFFF);
  static const Color kOnSecondary = Color(0xFF0A1620);
  static const Color kOnAccent = Color(0xFFFFFFFF);

  // --- Light mode core ---
  // Source: lightBackground / lightSurface / lightTextPrimary / lightTextSecondary
  static const Color kLightBackground = Color(0xFFF3F3F3);
  static const Color kLightSurface = Color(0xFFFFFFFF);
  static const Color kLightTextPrimary = Color(0xFF0A1620);
  static const Color kLightTextSecondary = Color(0xFF506070);

  // --- Dark mode core ---
  // Source: darkBackground / darkSurface / darkTextPrimary / darkTextSecondary
  static const Color kDarkBackground = Color(0xFF242425);
  static const Color kDarkSurface = Color(0xFF3E3E40);
  static const Color kDarkTextPrimary = Color(0xFFF5F5F5);
  static const Color kDarkTextSecondary = Color(0xFF9A9A9B);

  // --- Utility / neutral tokens ---
  // Source: neutralBorder / neutralMuted
  static const Color kNeutralBorder = Color(0xFFD7DCE2);
  static const Color kNeutralMuted = Color(0xFF9AA3AD);
}
