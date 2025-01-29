import 'package:cineghar/features/splash/presentation/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SplashPage displays and has content', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SplashPage(),
      ),
    );

    await tester.pump(const Duration(seconds: 4));
    expect(find.byType(Scaffold), findsWidgets);
  });

  testWidgets('SplashPage has Scaffold', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SplashPage(),
      ),
    );

    await tester.pump(const Duration(seconds: 4));
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
