import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_v2/main.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('Sign-in route is reachable and shows Sign in title', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    // navigate to /sign-in via router
    // depending on go_router version: use context.go in app; here we find the route button not present so we push:
    final router = find.byType(MaterialApp);
    // instead of interacting with router, we assert the app has been built and then push route via Navigator
    // fallback: use Navigator to push named route
    Navigator.of(
      tester.element(find.byType(MaterialApp)),
    ).pushNamed('/sign-in');
    await tester.pumpAndSettle();
    expect(find.text('Sign in'), findsOneWidget);
  });
}
