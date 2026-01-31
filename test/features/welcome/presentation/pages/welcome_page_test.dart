import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cineghar/features/welcome/presentation/pages/welcome_page.dart';

void main() {
  group('WelcomePage', () {
    testWidgets('should load and display WelcomePage', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: WelcomePage(),
        ),
      );

      expect(find.byType(WelcomePage), findsOneWidget);
    });

    testWidgets('should display CineGhar title', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: WelcomePage(),
        ),
      );

      expect(find.text('CineGhar'), findsOneWidget);
    });
  });
}
