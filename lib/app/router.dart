// lib/app/router.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../app/app_shell.dart';
import '../features/auth/auth_controller.dart';
import '../screens/sign_in_screen.dart';
import '../screens/onboarding_screen.dart';
import '../features/onboarding/onboarding_provider.dart';
import '../screens/admin/admin_dashboard_screen.dart';
import '../screens/client/client_dashboard_screen.dart';
import '../screens/admin/admin_settings_screen.dart';
import '../screens/client/client_settings_screen.dart';

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

  // Also refresh when onboarding completion or role changes
  ref.listen<bool>(onboardingCompletedProvider, (_, __) {
    notifier.notify();
  });
  ref.listen<OnboardingRole?>(userRoleProvider, (_, __) {
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
      final goingToOnboarding = state.uri.toString() == '/onboarding';

      if (auth.status == AuthStatus.signedOut && !goingToSignIn) {
        return '/sign-in';
      }

      if (auth.status == AuthStatus.signedIn) {
        final onboarded = ref.read(onboardingCompletedProvider);
        final role = ref.read(userRoleProvider);
        if (!onboarded && !goingToOnboarding) return '/onboarding';
        if (onboarded && goingToOnboarding) {
          if (role == OnboardingRole.admin) return '/admin';
          if (role == OnboardingRole.client) return '/client';
          return '/';
        }
        // ensure users land on their dashboard if hitting '/' directly
        if (onboarded && state.uri.toString() == '/') {
          if (role == OnboardingRole.admin) return '/admin';
          if (role == OnboardingRole.client) return '/client';
        }
        if (goingToSignIn) return '/';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/sign-in',
        name: 'sign_in',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(location: state.uri.toString(), child: child),
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) {
              final role = ref.read(userRoleProvider);
              if (role == OnboardingRole.admin) {
                return const AdminDashboardScreen();
              }
              if (role == OnboardingRole.client) {
                return const ClientDashboardScreen();
              }
              return const Scaffold(body: Center(child: Text('Loading...')));
            },
          ),
          GoRoute(
            path: '/admin',
            name: 'admin',
            builder: (context, state) => const AdminDashboardScreen(),
          ),
          GoRoute(
            path: '/client',
            name: 'client',
            builder: (context, state) => const ClientDashboardScreen(),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            builder: (context, state) {
              final role = ref.read(userRoleProvider);
              if (role == OnboardingRole.admin) {
                return const AdminSettingsScreen();
              }
              if (role == OnboardingRole.client) {
                return const ClientSettingsScreen();
              }
              return const Scaffold(body: Center(child: Text('Settings')));
            },
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page error: ${state.error}'))),
  );
});
