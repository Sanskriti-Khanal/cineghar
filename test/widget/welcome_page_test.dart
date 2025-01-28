import 'package:cineghar/features/welcome/presentation/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('WelcomePage displays CineGhar title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: WelcomePage(),
      ),
    );

    expect(find.text('CineGhar'), findsOneWidget);
  });

  testWidgets('WelcomePage has SIGN IN and SIGN UP buttons', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: WelcomePage(),
      ),
    );

    expect(find.text('SIGN IN'), findsOneWidget);
    expect(find.text('SIGN UP'), findsOneWidget);
  });
}
