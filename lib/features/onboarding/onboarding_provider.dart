import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'join_code_service.dart';

/// Exposes the JoinCodeService. Defaults to local implementation for tests/dev.
final joinCodeServiceProvider = Provider<JoinCodeService>((ref) {
  return LocalJoinCodeService();
});

enum OnboardingRole { admin, client }

/// Stores whether onboarding is completed. Seeded at app boot via ProviderScope overrides.
final onboardingCompletedProvider = StateProvider<bool>((ref) => false);

/// Selected role for onboarding.
final onboardingRoleProvider = StateProvider<OnboardingRole>((ref) {
  return OnboardingRole.admin;
});

/// Persisted user role after onboarding (null until set).
final userRoleProvider = StateProvider<OnboardingRole?>((ref) => null);

class OnboardingController {
  OnboardingController(this.ref);

  final Ref ref;

  JoinCodeService get _service => ref.read(joinCodeServiceProvider);

  Future<String> createStudio(String studioName) async {
    return _service.createStudio(studioName);
  }

  Future<String?> verifyJoinCode(String code) async {
    return _service.verifyJoinCode(code);
  }

  /// Marks onboarding as complete and persists flag locally.
  Future<void> completeOnboarding() async {
    // Ensure role is set first to avoid flicker on redirect
    try {
      final sp = await SharedPreferences.getInstance();
      final role = ref.read(onboardingRoleProvider);
      await sp.setString('user_role', role.name);
      ref.read(userRoleProvider.notifier).state = role;

      ref.read(onboardingCompletedProvider.notifier).state = true;
      await sp.setBool('onboarding_completed', true);
    } catch (_) {}
  }
}

final onboardingProvider = Provider<OnboardingController>((ref) {
  return OnboardingController(ref);
});
