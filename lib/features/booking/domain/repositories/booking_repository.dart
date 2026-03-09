import 'package:dartz/dartz.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/features/booking/domain/entities/booking_entity.dart';
import 'package:cineghar/features/booking/domain/entities/hall_entity.dart';
import 'package:cineghar/features/booking/domain/entities/loyalty_entity.dart';
import 'package:cineghar/features/booking/domain/entities/offer_entity.dart';
import 'package:cineghar/features/booking/domain/entities/reward_entity.dart';
import 'package:cineghar/features/booking/domain/entities/seat_entity.dart';
import 'package:cineghar/features/booking/domain/entities/showtime_entity.dart';
import 'package:cineghar/features/booking/domain/entities/snack_entity.dart';

abstract interface class IBookingRepository {
  Future<Either<Failure, List<String>>> getCities();

  Future<Either<Failure, List<HallEntity>>> getHalls(String city);

  Future<Either<Failure, List<ShowtimeEntity>>> getShowtimes({
    required String movieId,
    required String hallId,
    required String dateKey,
  });

  Future<Either<Failure, List<List<SeatEntity>>>> getSeats({
    required String hallId,
    required String dateKey,
    required String showtimeId,
  });

  Future<Either<Failure, List<OfferEntity>>> getActiveOffers();

  Future<Either<Failure, List<RewardEntity>>> getRewards();

  Future<Either<Failure, LoyaltyInfoEntity>> getMyLoyalty();

  Future<Either<Failure, List<SnackItemEntity>>> getSnackItems();

  Future<Either<Failure, List<SnackComboEntity>>> getSnackCombos();

  /// Initiates Khalti payment for a booking and returns the hosted
  /// payment URL that should be opened in a browser / webview.
  Future<Either<Failure, Map<String, dynamic>>> initiateKhaltiPayment({
    required BookingSummaryEntity booking,
    String? offerCode,
    int? loyaltyPointsToRedeem,
  });

  Future<Either<Failure, void>> holdSeats({
    required String showtimeId,
    required List<String> seats,
  });
}