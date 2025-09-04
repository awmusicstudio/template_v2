// lib/services/supabase_service.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._();
  SupabaseService._();

  factory SupabaseService() => _instance;

  bool _initialized = false;

  bool get isInitialized => _initialized;

  Future<void> init({required String url, required String anonKey}) async {
    if (_initialized) return;
    await Supabase.initialize(url: url, anonKey: anonKey);
    _initialized = true;
  }

  SupabaseClient get client {
    if (!_initialized) {
      throw StateError(
        'Supabase not initialized. Call SupabaseService.init(...) first.',
      );
    }
    return Supabase.instance.client;
  }
}
