import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  AuthController() : super(const AuthState.unknown());

  final SupabaseClient _client = Supabase.instance.client;

  /// Check existing session and update state.
  Future<void> checkSession() async {
    final session = _client.auth.currentSession;
    if (session?.user != null) {
      state = AuthState.signedIn(session!.user);
    } else {
      state = const AuthState.signedOut();
    }
  }

  /// Example: anonymous sign-in for local/dev use only.
  /*   Future<void> signInAnonymous() async {
    final res = await _client.auth.signInWithProvider(
      Provider.github,
    ); // placeholder
    // Note: Many Supabase projects may not allow true anonymous sign-in.
    // For now, we attempt a safe call; in a real app you will implement email/magic links or OAuth.
    await checkSession();
  }  */

  Future<void> signOut() async {
    await _client.auth.signOut();
    state = const AuthState.signedOut();
  }
}

// providers
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(),
);
