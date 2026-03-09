import 'package:cineghar/features/booking/data/datasources/booking_local_datasource.dart';
import 'package:cineghar/features/booking/data/datasources/booking_remote_datasource.dart';
import 'package:cineghar/features/booking/data/models/hall_api_model.dart';
import 'package:cineghar/features/booking/data/models/loyalty_api_model.dart';
import 'package:cineghar/features/booking/data/models/offer_api_model.dart';
import 'package:cineghar/features/booking/data/models/reward_api_model.dart';
import 'package:cineghar/features/booking/data/models/seat_model.dart';
import 'package:cineghar/features/booking/data/models/snack_api_model.dart';
import 'package:cineghar/features/booking/domain/entities/booking_entity.dart';
import 'package:cineghar/features/booking/domain/entities/showtime_entity.dart';
import 'package:dio/dio.dart';


class BookingMockDatasource implements IBookingRemoteDatasource {
  final BookingLocalDatasource _localDatasource = BookingLocalDatasource();

  @override
  Future<List<String>> getCities() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _localDatasource.getCities();
  }

  @override
  Future<List<HallApiModel>> getHalls(String city) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    return _localDatasource.getHalls(city);
  }

  @override
  Future<List<ShowtimeEntity>> getShowtimes({
    required String movieId,
    required String hallId,
    required String dateKey,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 600));
    return _localDatasource.getShowtimes(movieId: movieId, hallId: hallId, dateKey: dateKey);
  }

  @override
  Future<List<List<SeatModel>>> getSeats({
    required String hallId,
    required String dateKey,
    required String showtimeId,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 1000));
    return _localDatasource.getSeats(
      hallId: hallId,
      dateKey: dateKey,
      showtimeId: showtimeId,
    );
  }

  @override
  Future<List<OfferApiModel>> getActiveOffers() async {
    // Mock offers data
    await Future.delayed(const Duration(milliseconds: 700));
    return [
      OfferApiModel(
        id: 'offer1',
        name: 'Weekend Special',
        code: 'WEEKEND20',
        type: 'percentage_discount',
        description: 'Get 20% off on weekend shows',
        discountPercent: 20.0,
      ),
      OfferApiModel(
        id: 'offer2',
        name: 'Student Discount',
        code: 'STUDENT15',
        type: 'percentage_discount',
        description: 'Special discount for students',
        discountPercent: 15.0,
      ),
    ];
  }

  @override
  Future<List<RewardApiModel>> getRewards() async {
    // Mock rewards data
    await Future.delayed(const Duration(milliseconds: 600));
    return [
      RewardApiModel(
        id: 'reward1',
        title: 'Free Popcorn',
        description: 'Get a free popcorn with your next movie',
        pointsRequired: 100,
      ),
      RewardApiModel(
        id: 'reward2',
        title: '50% Off Ticket',
        description: 'Get 50% off on your next ticket',
        pointsRequired: 200,
      ),
    ];
  }

  @override
  Future<LoyaltyMeApiModel> getMyLoyalty() async {
    // Mock loyalty data
    await Future.delayed(const Duration(milliseconds: 500));
    return LoyaltyMeApiModel(
      loyaltyPoints: 150,
      recentTransactions: [],
    );
  }

  @override
  Future<Map<String, dynamic>> initiateKhaltiPayment({
    required BookingSummaryEntity booking,
    String? offerCode,
    int? loyaltyPointsToRedeem,
  }) async {
    // Mock payment initiation - return actual Khalti payment URL for testing
    await Future.delayed(const Duration(milliseconds: 1500));
    return {
      'payment_url': 'https://dev.khalti.com/api/v2/epay/initiate/',
      'pidx': 'mock_pidx',
      'purchaseOrderId': 'mock_order_id',
    };
  }

  @override
  Future<List<SnackItemApiModel>> getSnackItems() async {
    // Mock snack items
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      SnackItemApiModel(
        id: '1',
        name: 'Popcorn',
        description: 'Fresh buttery popcorn',
        price: 150.0,
        category: 'veg',
        imageUrl: null,
        isActive: true,
        sortOrder: 1,
      ),
      SnackItemApiModel(
        id: '2',
        name: 'Soda',
        description: 'Cold refreshing soda',
        price: 80.0,
        category: 'beverage',
        imageUrl: null,
        isActive: true,
        sortOrder: 2,
      ),
      SnackItemApiModel(
        id: '3',
        name: 'Nachos',
        description: 'Crispy nachos with cheese',
        price: 200.0,
        category: 'veg',
        imageUrl: null,
        isActive: true,
        sortOrder: 3,
      ),
    ];
  }

  @override
  Future<List<SnackComboApiModel>> getSnackCombos() async {
    // Mock snack combos
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      SnackComboApiModel(
        id: '1',
        name: 'Movie Combo',
        itemsPreview: 'Popcorn + Soda',
        price: 200.0,
        originalPrice: 230.0,
        discountLabel: 'Save 30',
        imageUrl: null,
        isActive: true,
        sortOrder: 1,
      ),
      SnackComboApiModel(
        id: '2',
        name: 'Family Combo',
        itemsPreview: '2x Popcorn + 2x Soda + Nachos',
        price: 550.0,
        originalPrice: 650.0,
        discountLabel: 'Save 100',
        imageUrl: null,
        isActive: true,
        sortOrder: 2,
      ),
    ];
  }

  @override
  Future<void> holdSeats({
    required String showtimeId,
    required List<String> seats,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    // No-op for mock
  }
}