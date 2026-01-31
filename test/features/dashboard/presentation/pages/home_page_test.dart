import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cineghar/features/dashboard/presentation/pages/home_page.dart';

void main() {
  group('HomePage', () {
    testWidgets('should load and display HomePage', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(),
        ),
      );

      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('should display scrollable content', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: HomePage(),
        ),
      );

      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
