import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:cineghar/core/config/app_config.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/core/services/connectivity/network_info.dart';
import 'package:cineghar/features/booking/data/datasources/booking_mock_datasource.dart';
import 'package:cineghar/features/booking/data/datasources/booking_remote_datasource.dart';
import 'package:cineghar/features/booking/domain/entities/booking_entity.dart';
import 'package:cineghar/features/booking/domain/entities/hall_entity.dart';
import 'package:cineghar/features/booking/domain/entities/loyalty_entity.dart';
import 'package:cineghar/features/booking/domain/entities/offer_entity.dart';
import 'package:cineghar/features/booking/domain/entities/reward_entity.dart';
import 'package:cineghar/features/booking/domain/entities/seat_entity.dart';
import 'package:cineghar/features/booking/domain/entities/showtime_entity.dart';
import 'package:cineghar/features/booking/domain/entities/snack_entity.dart';
import 'package:cineghar/features/booking/domain/repositories/booking_repository.dart';


class BookingRepository implements IBookingRepository {
  final IBookingRemoteDatasource _remote;
  final INetworkInfo _networkInfo;

  BookingRepository({
    required IBookingRemoteDatasource remoteDatasource,
    required INetworkInfo networkInfo,
  }) : _remote = remoteDatasource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<OfferEntity>>> getActiveOffers() async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        ApiFailure(message: 'No internet. Connect to load offers.'),
      );
    }
    try {
      final models = await _remote.getActiveOffers();
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map && data['message'] != null
          ? data['message'].toString()
          : (data is String ? data : 'Failed to load offers');
      return Left(
        ApiFailure(message: message, statusCode: e.response?.statusCode),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<RewardEntity>>> getRewards() async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        ApiFailure(message: 'No internet. Connect to load rewards.'),
      );
    }
    try {
      final models = await _remote.getRewards();
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map && data['message'] != null
          ? data['message'].toString()
          : (data is String ? data : 'Failed to load rewards');
      return Left(
        ApiFailure(message: message, statusCode: e.response?.statusCode),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, LoyaltyInfoEntity>> getMyLoyalty() async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        ApiFailure(message: 'No internet. Connect to load loyalty info.'),
      );
    }
    try {
      final model = await _remote.getMyLoyalty();
      return Right(model.toEntity());
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map && data['message'] != null
          ? data['message'].toString()
          : (data is String ? data : 'Failed to load loyalty info');
      return Left(
        ApiFailure(message: message, statusCode: e.response?.statusCode),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> initiateKhaltiPayment({
    required BookingSummaryEntity booking,
    String? offerCode,
    int? loyaltyPointsToRedeem,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        ApiFailure(message: 'No internet. Connect to start payment.'),
      );
    }
    try {
      final data = await _remote.initiateKhaltiPayment(
        booking: booking,
        offerCode: offerCode,
        loyaltyPointsToRedeem: loyaltyPointsToRedeem,
      );
      return Right(data);
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map && data['message'] != null
          ? data['message'].toString()
          : (data is String ? data : 'Failed to start payment with Khalti');
      return Left(
        ApiFailure(message: message, statusCode: e.response?.statusCode),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> holdSeats({
    required String showtimeId,
    required List<String> seats,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        ApiFailure(message: 'No internet. Connect to hold seats.'),
      );
    }
    try {
      await _remote.holdSeats(showtimeId: showtimeId, seats: seats);
      return const Right(null);
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map && data['message'] != null
          ? data['message'].toString()
          : (data is String ? data : 'Failed to hold seats');
      return Left(
        ApiFailure(message: message, statusCode: e.response?.statusCode),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCities() async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        ApiFailure(message: 'No internet. Connect to load cities.'),
      );
    }
    try {
      final cities = await _remote.getCities();
      return Right(cities);
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map && data['message'] != null
          ? data['message'].toString()
          : (data is String ? data : 'Failed to load cities');
      return Left(
        ApiFailure(message: message, statusCode: e.response?.statusCode),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HallEntity>>> getHalls(String city) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        ApiFailure(message: 'No internet. Connect to load halls.'),
      );
    }
    try {
      final models = await _remote.getHalls(city);
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map && data['message'] != null
          ? data['message'].toString()
          : (data is String ? data : 'Failed to load halls');
      return Left(
        ApiFailure(message: message, statusCode: e.response?.statusCode),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ShowtimeEntity>>> getShowtimes({
    required String movieId,
    required String hallId,
    required String dateKey,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        ApiFailure(message: 'No internet. Connect to load showtimes.'),
      );
    }
    try {
      final models = await _remote.getShowtimes(
        movieId: movieId,
        hallId: hallId,
        dateKey: dateKey,
      );
      return Right(models.map((m) => m).toList());
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map && data['message'] != null
          ? data['message'].toString()
          : (data is String ? data : 'Failed to load showtimes');
      return Left(
        ApiFailure(message: message, statusCode: e.response?.statusCode),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<List<SeatEntity>>>> getSeats({
    required String hallId,
    required String dateKey,
    required String showtimeId,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        ApiFailure(message: 'No internet. Connect to load seats.'),
      );
    }
    try {
      final seatModels = await _remote.getSeats(
        hallId: hallId,
        dateKey: dateKey,
        showtimeId: showtimeId,
      );
      return Right(
        seatModels.map((row) => row.map((m) => m.toEntity()).toList()).toList(),
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map && data['message'] != null
          ? data['message'].toString()
          : (data is String ? data : 'Failed to load seats');
      return Left(
        ApiFailure(message: message, statusCode: e.response?.statusCode),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SnackItemEntity>>> getSnackItems() async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        ApiFailure(message: 'No internet. Connect to load snack items.'),
      );
    }
    try {
      final models = await _remote.getSnackItems();
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map && data['message'] != null
          ? data['message'].toString()
          : (data is String ? data : 'Failed to load snack items');
      return Left(
        ApiFailure(message: message, statusCode: e.response?.statusCode),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SnackComboEntity>>> getSnackCombos() async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        ApiFailure(message: 'No internet. Connect to load snack combos.'),
      );
    }
    try {
      final models = await _remote.getSnackCombos();
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map && data['message'] != null
          ? data['message'].toString()
          : (data is String ? data : 'Failed to load snack combos');
      return Left(
        ApiFailure(message: message, statusCode: e.response?.statusCode),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}