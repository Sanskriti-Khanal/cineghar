import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cineghar/features/splash/presentation/pages/splash_page.dart';

void main() {
  group('SplashPage', () {
    testWidgets('should load and display SplashPage', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashPage(),
        ),
      );
      await tester.pump(const Duration(seconds: 4));

      expect(find.byType(SplashPage), findsOneWidget);
    });

    testWidgets('should display Scaffold', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashPage(),
        ),
      );

      await tester.pump(const Duration(seconds: 4));
      expect(find.byType(Scaffold), findsWidgets);
    });
  });
}
