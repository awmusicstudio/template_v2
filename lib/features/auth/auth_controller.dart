// lib/features/auth/auth_controller.dart
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:template_v2/services/supabase_service.dart';

/// High-level auth status used by routing and UI
enum AuthStatus { unknown, signedOut, signedIn }

/// Minimal auth state for the app
class AuthState {
  final AuthStatus status;

  const AuthState({required this.status});

  const AuthState.unknown() : status = AuthStatus.unknown;

  AuthState copyWith({AuthStatus? status}) =>
      AuthState(status: status ?? this.status);
}

class AuthController extends StateNotifier<AuthState> {
  StreamSubscription<dynamic>? _authSub;

  AuthController() : super(const AuthState.unknown()) {
    _initialize();
  }

  Future<void> _initialize() async {
    // If Supabase isn't initialized (e.g., local dev without env), we default to signed-out
    final supabase = SupabaseService();
    if (!supabase.isInitialized) {
      state = const AuthState(status: AuthStatus.signedOut);
      return;
    }

    final client = supabase.client;
    state = _hasActiveSession(client)
        ? const AuthState(status: AuthStatus.signedIn)
        : const AuthState(status: AuthStatus.signedOut);

    // Listen for auth state changes and keep our state in sync
    try {
      _authSub = client.auth.onAuthStateChange.listen((event) {
        // event is (AuthChangeEvent, Session?) in recent SDKs; stay flexible
        final next = _hasActiveSession(client)
            ? const AuthState(status: AuthStatus.signedIn)
            : const AuthState(status: AuthStatus.signedOut);
        if (state.status != next.status) {
          state = next;
        }
      });
    } catch (_) {
      // Best-effort; if the SDK shape differs, we still operate via explicit methods
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  Future<bool> signInWithEmail(String email, String password) async {
    final supabase = SupabaseService();
    if (!supabase.isInitialized) return false;
    final client = supabase.client;
    final dynamic auth = client.auth;

    try {
      try {
        // Preferred modern API
        await auth.signInWithPassword(email: email, password: password);
      } catch (_) {
        // Fallback for older SDKs
        await auth.signIn(email: email, password: password);
      }

      final success = _hasActiveSession(client);
      state = success
          ? const AuthState(status: AuthStatus.signedIn)
          : const AuthState(status: AuthStatus.signedOut);
      return success;
    } catch (_) {
      state = const AuthState(status: AuthStatus.signedOut);
      return false;
    }
  }

  Future<bool> signUpWithEmail(String email, String password) async {
    final supabase = SupabaseService();
    if (!supabase.isInitialized) return false;
    final client = supabase.client;
    final dynamic auth = client.auth;

    try {
      try {
        // Common sign-up API
        await auth.signUp(email: email, password: password);
      } catch (_) {
        // Some SDKs may require a different call shape; if it fails, we'll rely on sign-in attempt
      }

      // Attempt immediate sign-in to create a session and route to home
      final signedIn = await signInWithEmail(email, password);
      if (!signedIn) {
        state = const AuthState(status: AuthStatus.signedOut);
      }
      return signedIn;
    } catch (_) {
      state = const AuthState(status: AuthStatus.signedOut);
      return false;
    }
  }

  Future<void> signOut() async {
    final supabase = SupabaseService();
    if (!supabase.isInitialized) {
      state = const AuthState(status: AuthStatus.signedOut);
      return;
    }
    try {
      await supabase.client.auth.signOut();
    } catch (_) {
      // ignore sign-out errors and still consider the user signed out
    }
    state = const AuthState(status: AuthStatus.signedOut);
  }

  bool _hasActiveSession(SupabaseClient client) {
    try {
      final user = client.auth.currentUser;
      if (user != null) return true;
    } catch (_) {
      // ignore
    }
    try {
      final sessionUser = client.auth.currentSession?.user;
      return sessionUser != null;
    } catch (_) {
      return false;
    }
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    return AuthController();
  },
);
