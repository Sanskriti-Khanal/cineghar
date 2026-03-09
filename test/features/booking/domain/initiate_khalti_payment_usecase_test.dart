import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/features/booking/domain/entities/booking_entity.dart';
import 'package:cineghar/features/booking/domain/repositories/booking_repository.dart';
import 'package:cineghar/features/booking/domain/usecases/initiate_khalti_payment_usecase.dart';

class _MockBookingRepository extends Mock implements IBookingRepository {}

void main() {
  late _MockBookingRepository repository;
  late InitiateKhaltiPaymentUsecase usecase;

  setUpAll(() {
    registerFallbackValue(const BookingSummaryEntity(
      movieId: 'm1',
      movieTitle: 'Test Movie',
      city: 'Kathmandu',
      hallId: 'ktm-royal',
      hallName: 'CineGhar Royal',
      dateKey: 'today',
      showtime: '10:00 AM',
      showtimeId: 'st1',
      seats: [BookingSeat('A1')],
      ticketSubtotal: 350,
      snacksSubtotal: 0,
      totalBeforeDiscount: 350,
    ));
  });

  setUp(() {
    repository = _MockBookingRepository();
    usecase = InitiateKhaltiPaymentUsecase(repository: repository);
  });

  const summary = BookingSummaryEntity(
    movieId: 'm1',
    movieTitle: 'Test Movie',
    city: 'Kathmandu',
    hallId: 'ktm-royal',
    hallName: 'CineGhar Royal',
    dateKey: 'today',
    showtime: '10:00 AM',
    showtimeId: 'st1',
    seats: [BookingSeat('A1')],
    ticketSubtotal: 350,
    snacksSubtotal: 0,
    totalBeforeDiscount: 350,
  );

  test('returns payment url on success', () async {
    when(
      () => repository.initiateKhaltiPayment(
        booking: any(named: 'booking'),
        offerCode: any(named: 'offerCode'),
        loyaltyPointsToRedeem: any(named: 'loyaltyPointsToRedeem'),
      ),
    ).thenAnswer((_) async => const Right<Failure, Map<String, dynamic>>({
          'payment_url': 'https://payment.test',
          'pidx': 'test_pidx',
          'purchaseOrderId': 'test_id'
        }));

    final result = await usecase(
      const InitiateKhaltiPaymentParams(booking: summary),
    );

    expect(
        result,
        const Right<Failure, Map<String, dynamic>>({
          'payment_url': 'https://payment.test',
          'pidx': 'test_pidx',
          'purchaseOrderId': 'test_id'
        }));
  });

  test('returns failure on error', () async {
    const failure = ApiFailure(message: 'error');
    when(
      () => repository.initiateKhaltiPayment(
        booking: any(named: 'booking'),
        offerCode: any(named: 'offerCode'),
        loyaltyPointsToRedeem: any(named: 'loyaltyPointsToRedeem'),
      ),
    ).thenAnswer((_) async => const Left(failure));

    final result = await usecase(
      const InitiateKhaltiPaymentParams(booking: summary),
    );

    expect(result, const Left(failure));
  });
}

