import 'package:dio/dio.dart';
import 'package:cineghar/core/api/api_client.dart';
import 'package:cineghar/core/api/api_endpoints.dart';
import 'package:cineghar/features/booking/data/models/hall_api_model.dart';
import 'package:cineghar/features/booking/data/models/loyalty_api_model.dart';
import 'package:cineghar/features/booking/data/models/offer_api_model.dart';
import 'package:cineghar/features/booking/data/models/reward_api_model.dart';
import 'package:cineghar/features/booking/data/models/seat_model.dart';
import 'package:cineghar/features/booking/data/models/snack_api_model.dart';
import 'package:cineghar/features/booking/domain/entities/booking_entity.dart';
import 'package:cineghar/features/booking/domain/entities/seat_entity.dart';
import 'package:cineghar/features/booking/domain/entities/showtime_entity.dart';

abstract interface class IBookingRemoteDatasource {
  Future<List<String>> getCities();
  Future<List<HallApiModel>> getHalls(String city);
  Future<List<ShowtimeEntity>> getShowtimes({
    required String movieId,
    required String hallId,
    required String dateKey,
  });
  Future<List<List<SeatModel>>> getSeats({
    required String hallId,
    required String dateKey,
    required String showtimeId,
  });
  Future<List<OfferApiModel>> getActiveOffers();
  Future<List<RewardApiModel>> getRewards();
  Future<LoyaltyMeApiModel> getMyLoyalty();
  Future<List<SnackItemApiModel>> getSnackItems();
  Future<List<SnackComboApiModel>> getSnackCombos();
  Future<Map<String, dynamic>> initiateKhaltiPayment({
    required BookingSummaryEntity booking,
    String? offerCode,
    int? loyaltyPointsToRedeem,
  });
  Future<void> holdSeats({
    required String showtimeId,
    required List<String> seats,
  });
}

class BookingRemoteDatasource implements IBookingRemoteDatasource {
  final ApiClient _apiClient;

  BookingRemoteDatasource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<List<OfferApiModel>> getActiveOffers() async {
    final response = await _apiClient.get(ApiEndpoints.offers);
    final data = response.data as Map<String, dynamic>;
    final list = data['data'] as List<dynamic>? ?? const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(OfferApiModel.fromJson)
        .toList();
  }

  @override
  Future<List<RewardApiModel>> getRewards() async {
    final response = await _apiClient.get(ApiEndpoints.rewards);
    final data = response.data as Map<String, dynamic>;
    final list = data['data'] as List<dynamic>? ?? const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(RewardApiModel.fromJson)
        .toList();
  }

  @override
  Future<LoyaltyMeApiModel> getMyLoyalty() async {
    final response = await _apiClient.get(ApiEndpoints.loyaltyMe);
    final data = response.data as Map<String, dynamic>;
    final inner = data['data'] as Map<String, dynamic>? ?? const {};
    return LoyaltyMeApiModel.fromJson(inner);
  }

  @override
  Future<Map<String, dynamic>> initiateKhaltiPayment({
    required BookingSummaryEntity booking,
    String? offerCode,
    int? loyaltyPointsToRedeem,
  }) async {
    final metadata = <String, dynamic>{
      'city': booking.city,
      'hallId': booking.hallId,
      'hallName': booking.hallName,
      'movieId': booking.movieId,
      'movieTitle': booking.movieTitle,
      'dateKey': booking.dateKey,
      'showtime': booking.showtime,
      'showtimeId': booking.showtimeId,
      'seats': booking.seats.map((e) => e.id).toList(),
      'ticketSubtotal': booking.ticketSubtotal,
      'snacksSubtotal': booking.snacksSubtotal,
      'total': booking.totalBeforeDiscount,
    };

    final purchaseOrderId = 'BOOK-${booking.movieId}-${DateTime.now().millisecondsSinceEpoch}';

    final payload = <String, dynamic>{
      'amount': booking.totalBeforeDiscount,
      'purchaseOrderId': purchaseOrderId,
      'purchaseOrderName': 'Tickets for ${booking.movieTitle}',
      'metadata': metadata,
      'source': 'mobile',
      if (offerCode != null && offerCode.isNotEmpty) 'offerCode': offerCode,
      if (loyaltyPointsToRedeem != null && loyaltyPointsToRedeem > 0)
        'loyaltyPointsToRedeem': loyaltyPointsToRedeem,
    };

    final response = await _apiClient.post(
      ApiEndpoints.khaltiInitiate,
      data: payload,
    );

    final data = response.data as Map<String, dynamic>;
    if (data['success'] == true &&
        data['data'] is Map<String, dynamic> &&
        (data['data'] as Map<String, dynamic>)['payment_url'] != null) {
      final khaltiData = data['data'] as Map<String, dynamic>;
      return {
        'payment_url': khaltiData['payment_url'],
        'pidx': khaltiData['pidx'],
        'purchaseOrderId': purchaseOrderId,
      };
    }
    throw DioException(
      requestOptions: response.requestOptions,
      error: data['message'] ?? 'Failed to start payment with Khalti',
    );
  }

  @override
  Future<List<String>> getCities() async {
    final response = await _apiClient.get(ApiEndpoints.cities);
    final data = response.data as Map<String, dynamic>;
    final list = data['data'] as List<dynamic>? ?? const [];
    return list.whereType<String>().toList();
  }

  @override
  Future<List<HallApiModel>> getHalls(String city) async {
    final response = await _apiClient.get('${ApiEndpoints.halls}?city=$city');
    final data = response.data as Map<String, dynamic>;
    final list = data['data'] as List<dynamic>? ?? const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(HallApiModel.fromJson)
        .toList();
  }

  @override
  Future<List<ShowtimeEntity>> getShowtimes({
    required String movieId,
    required String hallId,
    required String dateKey,
  }) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.showtimes}?hallId=$hallId&movieId=$movieId',
    );
    final data = response.data as Map<String, dynamic>;
    final list = data['data'] as List<dynamic>? ?? const [];
    
    return list.map((json) => ShowtimeEntity.fromJson(json as Map<String, dynamic>)).toList();
  }

  @override
  Future<List<List<SeatModel>>> getSeats({
    required String hallId,
    required String dateKey,
    required String showtimeId,
  }) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.seats}/$showtimeId/seats',
    );
    final data = response.data as Map<String, dynamic>;
    final seatData = data['data'] as Map<String, dynamic>;
    
    final rows = seatData['rows'] as List<dynamic>? ?? [];
    final columns = seatData['columns'] as int? ?? 10;
    final bookedSeats = (seatData['bookedSeats'] as List<dynamic>? ?? []).cast<String>();
    final heldSeats = (seatData['heldSeats'] as List<dynamic>? ?? []);
    
    // Create seat layout based on backend data
    final seatLayout = <List<SeatModel>>[];
    for (int i = 0; i < rows.length; i++) {
      final rowSeats = <SeatModel>[];
      final rowLetter = rows[i] as String;
      
      for (int col = 1; col <= columns; col++) {
        final seatId = '$rowLetter$col';
        SeatStatus status = SeatStatus.available;
        
        DateTime? holdExpiresAt;
        if (bookedSeats.contains(seatId)) {
          status = SeatStatus.booked;
        } else {
          // Check if seat is held
          final isHeldMap = heldSeats.cast<Map<String, dynamic>>().cast<Map<String, dynamic>?>()
              .firstWhere((hold) => hold != null && hold['seatId'] == seatId, orElse: () => null);
          if (isHeldMap != null) {
            status = SeatStatus.hold;
            if (isHeldMap['expiresAt'] != null) {
              holdExpiresAt = DateTime.tryParse(isHeldMap['expiresAt'].toString())?.toLocal();
            }
          }
        }
        
        rowSeats.add(SeatModel(
          id: seatId,
          status: status,
          holdExpiresAt: holdExpiresAt,
        ));
      }
      seatLayout.add(rowSeats);
    }
    
    return seatLayout;
  }

  @override
  Future<List<SnackItemApiModel>> getSnackItems() async {
    final response = await _apiClient.get(ApiEndpoints.snackItems);
    final data = response.data as Map<String, dynamic>;
    final list = data['data'] as List<dynamic>? ?? const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(SnackItemApiModel.fromJson)
        .toList();
  }

  @override
  Future<List<SnackComboApiModel>> getSnackCombos() async {
    final response = await _apiClient.get(ApiEndpoints.snackCombos);
    final data = response.data as Map<String, dynamic>;
    final list = data['data'] as List<dynamic>? ?? const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(SnackComboApiModel.fromJson)
        .toList();
  }

  @override
  Future<void> holdSeats({
    required String showtimeId,
    required List<String> seats,
  }) async {
    final payload = {
      'showtimeId': showtimeId,
      'seats': seats,
    };
    await _apiClient.post(
      ApiEndpoints.holds,
      data: payload,
    );
  }
}