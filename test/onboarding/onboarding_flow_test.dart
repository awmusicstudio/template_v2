import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:template_v2/features/onboarding/onboarding_provider.dart';
import 'package:template_v2/features/onboarding/join_code_service.dart';
import 'package:template_v2/screens/onboarding_screen.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Onboarding admin flow creates studio and shows join code', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          joinCodeServiceProvider.overrideWithValue(LocalJoinCodeService()),
          onboardingCompletedProvider.overrideWith((ref) => false),
          onboardingRoleProvider.overrideWith((ref) => OnboardingRole.admin),
        ],
        child: const MaterialApp(home: OnboardingScreen()),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Onboarding'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Studio Z');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Create & Continue'));

    await tester.pump();
    // SnackBar should appear with join code text prefix
    expect(find.textContaining('Created. Join code:'), findsOneWidget);
  });
}
