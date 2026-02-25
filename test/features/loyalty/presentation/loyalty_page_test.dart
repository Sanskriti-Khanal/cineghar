
import 'package:cineghar/core/providers/shared_prefs_provider.dart';
import 'package:cineghar/features/loyalty/presentation/pages/loyalty_page.dart';
import 'package:cineghar/features/loyalty/presentation/providers/loyalty_providers.dart';
import 'package:cineghar/features/loyalty/presentation/state/loyalty_state.dart';
import 'package:cineghar/features/loyalty/domain/entities/loyalty_entity.dart';
import 'package:cineghar/features/loyalty/presentation/viewmodel/loyalty_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
  });

  testWidgets('LoyaltyPage shows current balance',
      (WidgetTester tester) async {
    const state = LoyaltyState(
      status: LoyaltyStatus.loaded,
      loyaltyInfo: LoyaltyInfoEntity(
        loyaltyPoints: 2450,
        recentTransactions: [],
        membershipTier: 'Gold',
        thisMonthPoints: 620,
        ticketsBooked: 18,
        rewardsRedeemed: 6,
      ),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
          loyaltyViewModelProvider.overrideWith(
            () => _FakeLoyaltyViewModel(state),
          ),
        ],
        child: const MaterialApp(home: LoyaltyPage()),
      ),
    );

    expect(find.text('2450 pts'), findsOneWidget);
    expect(find.text('Gold member'), findsOneWidget);
  });
}

class _FakeLoyaltyViewModel extends LoyaltyViewModel {
  final LoyaltyState _state;

  _FakeLoyaltyViewModel(this._state);

  @override
  LoyaltyState build() => _state;
}
