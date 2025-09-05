import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../services/supabase_service.dart';

/// Abstraction for onboarding join codes.
abstract class JoinCodeService {
  /// Creates a studio with the given [studioName] and returns the generated join code.
  Future<String> createStudio(String studioName);

  /// Verifies a [code] and returns the studio name if valid, otherwise null.
  Future<String?> verifyJoinCode(String code);
}

/// Local implementation backed by SharedPreferences.
///
/// Stores entries under keys like `join_code:<lowercased_code>` with value of studio name.
class LocalJoinCodeService implements JoinCodeService {
  static const String _prefsKeyPrefix = 'join_code:';
  static const String _alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  static const int _codeLength = 6;

  final Random _random;

  LocalJoinCodeService({Random? random}) : _random = random ?? Random.secure();

  @override
  Future<String> createStudio(String studioName) async {
    final prefs = await SharedPreferences.getInstance();
    // Generate a unique code (case-insensitive uniqueness)
    for (int attempt = 0; attempt < 1000; attempt++) {
      final code = _generateCode();
      final key = _prefsKeyPrefix + code.toLowerCase();
      if (!prefs.containsKey(key)) {
        final ok = await prefs.setString(key, studioName);
        if (!ok) {
          throw StateError('Failed to persist join code locally');
        }
        return code; // return as generated (upper-case human-friendly)
      }
    }
    throw StateError('Exhausted attempts generating a unique join code');
  }

  @override
  Future<String?> verifyJoinCode(String code) async {
    if (code.trim().isEmpty) return null;
    final prefs = await SharedPreferences.getInstance();
    final key = _prefsKeyPrefix + code.trim().toLowerCase();
    return prefs.getString(key);
  }

  String _generateCode() {
    final buffer = StringBuffer();
    for (int i = 0; i < _codeLength; i++) {
      final idx = _random.nextInt(_alphabet.length);
      buffer.write(_alphabet[idx]);
    }
    return buffer.toString();
  }
}

/// Supabase-backed implementation using `public.studios` table.
///
/// Schema (see docs/SUPABASE_MIGRATION_STUDIOS.sql):
/// - id uuid primary key default gen_random_uuid()
/// - name text not null
/// - join_code text not null (unique index on lower(join_code))
/// - created_at timestamptz default now()
class SupabaseJoinCodeService implements JoinCodeService {
  static const String _alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  static const int _codeLength = 6;

  final Random _random;

  SupabaseJoinCodeService({Random? random})
    : _random = random ?? Random.secure();

  @override
  Future<String> createStudio(String studioName) async {
    if (!SupabaseService().isInitialized) {
      throw StateError('Supabase not initialized');
    }
    final client = SupabaseService().client;

    for (int attempt = 0; attempt < 1000; attempt++) {
      final code = _generateCode();
      try {
        // Attempt insert; rely on unique index on lower(join_code) for conflicts.
        await client.from('studios').insert({
          'name': studioName,
          'join_code': code,
        });
        return code;
      } on PostgrestException catch (e) {
        // Unique violation: try again with another code. Other errors: rethrow.
        final msg = e.message.toLowerCase();
        if (msg.contains('duplicate') ||
            msg.contains('unique') ||
            msg.contains('conflict')) {
          continue; // retry with a new code
        }
        throw StateError('Failed to create studio: ${e.message}');
      } catch (e) {
        throw StateError('Failed to create studio: $e');
      }
    }
    throw StateError('Exhausted attempts generating a unique join code');
  }

  @override
  Future<String?> verifyJoinCode(String code) async {
    if (!SupabaseService().isInitialized) {
      // Be defensive: verification without Supabase should just return null
      return null;
    }
    if (code.trim().isEmpty) return null;
    final client = SupabaseService().client;
    try {
      final normalized = code.trim();
      final res = await client
          .from('studios')
          .select('name')
          .ilike('join_code', normalized)
          .limit(1)
          .maybeSingle();
      if (res == null) return null;
      final name = res['name'] as String?;
      return name;
    } catch (_) {
      return null;
    }
  }

  String _generateCode() {
    final buffer = StringBuffer();
    for (int i = 0; i < _codeLength; i++) {
      final idx = _random.nextInt(_alphabet.length);
      buffer.write(_alphabet[idx]);
    }
    return buffer.toString();
  }
}

/// Provider wiring is placed in `onboarding_provider.dart` to avoid circular deps.
