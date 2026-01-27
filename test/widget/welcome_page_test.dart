import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cineghar/features/welcome/presentation/pages/welcome_page.dart';

void main() {
  testWidgets('WelcomePage shows CineGhar title', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: WelcomePage(),
      ),
    );

    expect(find.text('CineGhar'), findsOneWidget);
  });

  testWidgets('WelcomePage shows SIGN IN and SIGN UP buttons', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: WelcomePage(),
      ),
    );

    expect(find.text('SIGN IN'), findsOneWidget);
    expect(find.text('SIGN UP'), findsOneWidget);
  });
}
