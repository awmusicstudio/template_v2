import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:template_v2/main.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('App boots and shows Home screen (body)', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    await tester.pumpAndSettle();

    // There are two "Home" texts (AppBar title + body). Target the one inside the body:
    final bodyFinder = find.descendant(
      of: find.byType(Center),
      matching: find.text('Home'),
    );

    expect(bodyFinder, findsOneWidget);
  });
}
