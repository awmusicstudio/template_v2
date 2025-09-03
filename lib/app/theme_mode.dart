import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds current ThemeMode for the app. Defaults to system.
final themeModeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.system);
