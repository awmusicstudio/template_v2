// lib/main.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_v2/app/router.dart';
import 'package:template_v2/app/app_theme.dart';
import 'package:template_v2/services/supabase_service.dart';
import 'package:flutter/services.dart' show rootBundle;

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
