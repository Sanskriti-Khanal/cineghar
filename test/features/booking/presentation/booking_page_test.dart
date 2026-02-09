import 'package:cineghar/features/booking/presentation/pages/booking_page.dart';
import 'package:cineghar/features/booking/presentation/providers/booking_providers.dart';
import 'package:cineghar/features/booking/presentation/state/booking_state.dart';
import 'package:cineghar/features/booking/presentation/viewmodel/booking_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('BookingPage shows city step initially',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bookingViewModelProvider.overrideWith(
            () => _FakeBookingViewModel(const BookingState()),
          ),
        ],
        child: const MaterialApp(
          home: BookingPage(
            movieId: 'm1',
            movieTitle: 'Test Movie',
          ),
        ),
      ),
    );

    expect(find.text('Choose Your City'), findsOneWidget);
  });
}

class _FakeBookingViewModel extends BookingViewModel {
  final BookingState _state;

  _FakeBookingViewModel(this._state);

  @override
  BookingState build() => _state;
}

