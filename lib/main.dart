// lib/main.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_v2/app/router.dart';
import 'package:template_v2/app/app_theme.dart';
import 'package:template_v2/app/theme_mode.dart';
import 'package:template_v2/services/supabase_service.dart';
import 'package:template_v2/features/onboarding/onboarding_provider.dart';
import 'package:template_v2/features/onboarding/join_code_service.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // First: try local file (desktop/dev)
    final file = File('env/dev.json');
    if (await file.exists()) {
      final raw = await file.readAsString();
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final url = (map['SUPABASE_URL'] as String?) ?? '';
      final anon = (map['SUPABASE_ANON_KEY'] as String?) ?? '';
      if (url.isNotEmpty && anon.isNotEmpty) {
        await SupabaseService().init(url: url, anonKey: anon);
      }
    }

    // Fallback: load from bundled asset (mobile)
    if (!SupabaseService().isInitialized) {
      try {
        final raw = await rootBundle.loadString('env/dev.json');
        final map = jsonDecode(raw) as Map<String, dynamic>;
        final url = (map['SUPABASE_URL'] as String?) ?? '';
        final anon = (map['SUPABASE_ANON_KEY'] as String?) ?? '';
        if (url.isNotEmpty && anon.isNotEmpty) {
          await SupabaseService().init(url: url, anonKey: anon);
        }
      } catch (_) {
        // ignore missing asset/parse errors
      }
    }
  } catch (_) {
    // ignore errors
  }

  // Seed onboarding completion flag from local storage
  bool onboardingCompleted = false;
  OnboardingRole? userRole;
  try {
    final sp = await SharedPreferences.getInstance();
    onboardingCompleted = sp.getBool('onboarding_completed') ?? false;
    final roleStr = sp.getString('user_role');
    if (roleStr == 'admin') userRole = OnboardingRole.admin;
    if (roleStr == 'client') userRole = OnboardingRole.client;
  } catch (_) {}

  final overrides = [
    joinCodeServiceProvider.overrideWithValue(
      SupabaseService().isInitialized
          ? SupabaseJoinCodeService()
          : LocalJoinCodeService(),
    ),
    onboardingCompletedProvider.overrideWith((ref) => onboardingCompleted),
    userRoleProvider.overrideWith((ref) => userRole),
  ];

  runApp(ProviderScope(overrides: overrides, child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'template_v2',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}
