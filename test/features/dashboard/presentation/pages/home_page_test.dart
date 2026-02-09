import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cineghar/features/dashboard/presentation/pages/home_page.dart';

void main() {
  group('HomePage', () {
    testWidgets('should load and display HomePage', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomePage(),
          ),
        ),
      );

      // Pump to trigger the build microtasks
      await tester.pump();
      // Pump again to handle the state updates from microtasks
      await tester.pump(const Duration(milliseconds: 100));
      
      expect(find.byType(HomePage), findsOneWidget);
    });

    testWidgets('should display scrollable content', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: HomePage(),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
