import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_v2/main.dart';

void main() {
  testWidgets('App boots and redirects unsigned users to Sign in', (
    WidgetTester tester,
  ) async {
    // Pump the real app (uses router + auth redirect).
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    // App now redirects unsigned users to /sign-in by default in dev (no env/dev.json).
    expect(find.text('Sign in'), findsOneWidget);
  });
}
