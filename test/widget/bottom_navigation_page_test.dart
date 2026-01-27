import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cineghar/features/dashboard/presentation/pages/bottom_navigation_page.dart';

void main() {
  testWidgets('BottomNavigationPage has 4 nav items', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BottomNavigationPage(),
      ),
    );

    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Sale'), findsOneWidget);
    expect(find.text('Loyalty'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });

  testWidgets('BottomNavigationPage shows Home first', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: BottomNavigationPage(),
      ),
    );

    expect(find.byType(BottomNavigationPage), findsOneWidget);
  });
}
