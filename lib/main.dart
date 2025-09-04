// lib/main.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_v2/app/router.dart';
import 'package:template_v2/app/app_theme.dart';
import 'package:template_v2/services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Dev-only: try to read env/dev.json to initialize Supabase locally if present.
  try {
    final file = File('env/dev.json');
    if (await file.exists()) {
      final raw = await file.readAsString();
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final url = (map['SUPABASE_URL'] as String?) ?? '';
      final anon = (map['SUPABASE_ANON_KEY'] as String?) ?? '';
      if (url.isNotEmpty && anon.isNotEmpty) {
        await SupabaseService().init(url: url, anonKey: anon);
        // don't error if init fails — the app will run without Supabase for local dev
      }
    }
  } catch (_) {
    // ignore any errors reading / parsing dev env file
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'template_v2',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: router,
    );
  }
}
