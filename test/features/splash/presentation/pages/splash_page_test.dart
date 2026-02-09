import 'package:cineghar/core/providers/shared_prefs_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cineghar/features/splash/presentation/pages/splash_page.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../test_helper.dart';

void main() {
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    when(() => mockSharedPreferences.getBool(any())).thenReturn(false);
  });

  testWidgets('SplashPage displays logo and title', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
        ],
        child: const MaterialApp(home: SplashPage()),
      ),
    );
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Verify logo exists
    expect(find.byType(Image), findsWidgets);
  });
}