// lib/features/auth/auth_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:template_v2/services/supabase_service.dart';

enum AuthStatus { unknown, signedOut, signedIn }

class AuthState {
  final AuthStatus status;
  final User? user;
  const AuthState._(this.status, this.user);
  const AuthState.unknown() : this._(AuthStatus.unknown, null);
  const AuthState.signedOut() : this._(AuthStatus.signedOut, null);
  AuthState.signedIn(User user) : this._(AuthStatus.signedIn, user);
}

class AuthController extends StateNotifier<AuthState> {
  AuthController() : super(const AuthState.unknown()) {
    _init();
  }

  // Optional: broadcast changes for external listeners (not strictly required)
  Future<void> _init() async {
    // If Supabase isn't initialized (dev), treat as signed out
    if (!SupabaseService().isInitialized) {
      state = const AuthState.signedOut();
      return;
    }

    // If Supabase initialized, check session
    await checkSession();
  }

  Future<void> checkSession() async {
    try {
      final client = SupabaseService().isInitialized
          ? Supabase.instance.client
          : null;
      if (client == null) {
        state = const AuthState.signedOut();
        return;
      }
      final session = client.auth.currentSession;
      if (session?.user != null) {
        state = AuthState.signedIn(session!.user);
      } else {
        state = const AuthState.signedOut();
      }
    } catch (e) {
      // defensive: if anything goes wrong, treat as signed out
      state = const AuthState.signedOut();
    }
  }

  /// Placeholder sign-in flow — keep minimal. Replace in next ticket.
  Future<void> signInPlaceholder() async {
    // This is intentionally conservative; do not call signIn if Supabase not initialized.
    if (!SupabaseService().isInitialized) {
      state = const AuthState.signedOut();
      return;
    }

    // In future: implement email/magic link/OAuth. For now just refresh session state.
    await checkSession();
  }

  Future<void> signOut() async {
    try {
      if (SupabaseService().isInitialized) {
        await Supabase.instance.client.auth.signOut();
      }
    } catch (_) {}
    state = const AuthState.signedOut();
  }
}

// providers
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(),
);
