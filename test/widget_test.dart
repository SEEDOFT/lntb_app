import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('unread badge shows the notification count', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Badge.count(
            count: 3,
            child: const Icon(Icons.notifications_outlined),
          ),
        ),
      ),
    );

    expect(find.text('3'), findsOneWidget);
    expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
  });

  testWidgets('unread badge label can be hidden when the count is zero', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Badge.count(
            count: 0,
            isLabelVisible: false,
            child: const Icon(Icons.notifications_outlined),
          ),
        ),
      ),
    );

    expect(find.text('0'), findsNothing);
    expect(find.byIcon(Icons.notifications_outlined), findsOneWidget);
  });
}
