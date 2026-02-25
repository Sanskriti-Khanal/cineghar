import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cineghar/features/splash/presentation/pages/splash_page.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cineghar/core/providers/shared_prefs_provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('SplashPage', () {
    testWidgets('should load and display SplashPage', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(MockSharedPreferences()),
          ],
          child: const MaterialApp(
            home: SplashPage(),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 4));

      expect(find.byType(SplashPage), findsOneWidget);
    });

    testWidgets('should display Scaffold structure', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(MockSharedPreferences()),
          ],
          child: const MaterialApp(
            home: SplashPage(),
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 4));
      expect(find.byType(Scaffold), findsWidgets);
    });
  });
}
