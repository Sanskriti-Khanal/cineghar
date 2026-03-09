import 'package:cineghar/features/sales/domain/entities/offer_entity.dart';
import 'package:cineghar/features/sales/presentation/pages/sales_page.dart';
import 'package:cineghar/features/sales/presentation/providers/sales_providers.dart';
import 'package:cineghar/features/sales/presentation/state/sales_state.dart';
import 'package:cineghar/features/sales/presentation/viewmodel/sales_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('SalesPage shows offers list',
      (WidgetTester tester) async {
    const offer = SalesOfferEntity(
      id: '1',
      name: 'Mid-Week Ticket Madness',
      code: 'MIDWEEK',
      type: 'percentage_discount',
      discountPercent: 30,
    );

    const state = SalesState(
      status: SalesStatus.loaded,
      offers: [offer],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          salesViewModelProvider.overrideWith(
            () => _FakeSalesViewModel(state),
          ),
        ],
        child: const MaterialApp(home: SalesPage()),
      ),
    );

    // Give CustomScrollView time to layout and render
    await tester.pumpAndSettle();

    expect(find.text('How to Avail Offers'), findsOneWidget);
    expect(find.text('MIDWEEK', skipOffstage: false), findsOneWidget);
  });
}



class _FakeSalesViewModel extends SalesViewModel {
  final SalesState _state;

  _FakeSalesViewModel(this._state);

  @override
  SalesState build() => _state;
}

