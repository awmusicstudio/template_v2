// lib/app/router.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../app/app_shell.dart';
import '../features/auth/auth_controller.dart';
import '../screens/home_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/sign_in_screen.dart';

/// A ChangeNotifier that exposes a safe public `notify()` method to trigger
/// GoRouter refreshes. This keeps `notifyListeners()` encapsulated.
class RouterRefresh extends ChangeNotifier {
  /// Public trigger used by provider listeners.
  void notify() => notifyListeners();
}

final routerRefreshProvider = Provider<RouterRefresh>((ref) {
  final notifier = RouterRefresh();

  // When auth state changes, call the notifier's public API to refresh the router.
  ref.listen<AuthState>(authControllerProvider, (_, __) {
    notifier.notify();
  });

  ref.onDispose(() => notifier.dispose());
  return notifier;
});

final routerProvider = Provider<GoRouter>((ref) {
  final refreshListenable = ref.watch(routerRefreshProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      // while auth is initializing, don't redirect
      if (auth.status == AuthStatus.unknown) return null;

      final goingToSignIn = state.uri.toString() == '/sign-in';

      if (auth.status == AuthStatus.signedOut && !goingToSignIn) {
        return '/sign-in';
      }

      if (auth.status == AuthStatus.signedIn && goingToSignIn) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/sign-in',
        name: 'sign_in',
        builder: (context, state) => const SignInScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(location: state.uri.toString(), child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page error: ${state.error}'))),
  );
});
