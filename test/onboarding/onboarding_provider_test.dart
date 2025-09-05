import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:template_v2/features/onboarding/onboarding_provider.dart';
import 'package:template_v2/features/onboarding/join_code_service.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  test('onboardingProvider uses LocalJoinCodeService and works', () async {
    final container = ProviderContainer(
      overrides: [
        joinCodeServiceProvider.overrideWithValue(LocalJoinCodeService()),
      ],
    );
    addTearDown(container.dispose);

    final onboarding = container.read(onboardingProvider);
    final code = await onboarding.createStudio('Studio A');
    expect(code.length, 6);

    final name = await onboarding.verifyJoinCode(code);
    expect(name, 'Studio A');
  });
}
