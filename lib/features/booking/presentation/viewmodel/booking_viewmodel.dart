import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/features/booking/domain/entities/offer_entity.dart';
import 'package:cineghar/features/booking/domain/entities/reward_entity.dart';
import 'package:cineghar/features/booking/domain/entities/hall_entity.dart';
import 'package:cineghar/features/booking/domain/entities/snack_entity.dart';
import 'package:cineghar/features/booking/domain/entities/showtime_entity.dart';
import 'package:cineghar/features/booking/domain/usecases/get_active_offers_usecase.dart';
import 'package:cineghar/features/booking/domain/usecases/get_my_loyalty_usecase.dart';
import 'package:cineghar/features/booking/domain/usecases/get_rewards_usecase.dart';
import 'package:cineghar/features/booking/domain/usecases/initiate_khalti_payment_usecase.dart';
import 'package:cineghar/features/booking/domain/usecases/get_halls_usecase.dart';
import 'package:cineghar/features/booking/domain/usecases/get_showtimes_usecase.dart';
import 'package:cineghar/features/booking/domain/usecases/get_seats_usecase.dart';
import 'package:cineghar/features/booking/domain/usecases/get_snacks_usecase.dart';
import 'package:cineghar/features/booking/domain/usecases/hold_seats_usecase.dart';
import 'package:cineghar/features/orders/domain/entities/order_entity.dart';
import 'package:cineghar/features/orders/domain/usecases/order_usecases.dart';
import 'package:cineghar/features/booking/presentation/state/booking_state.dart';
import 'package:cineghar/features/booking/presentation/providers/seat_selection_provider.dart';
import 'package:cineghar/features/booking/presentation/providers/booking_providers.dart';
import 'package:cineghar/features/orders/presentation/providers/orders_providers.dart';

const int kSeatPrice = 350;

class BookingViewModel extends Notifier<BookingState> {
  late final GetActiveOffersUsecase _getActiveOffersUsecase;
  late final GetRewardsUsecase _getRewardsUsecase;
  late final GetMyLoyaltyUsecase _getMyLoyaltyUsecase;
  late final InitiateKhaltiPaymentUsecase _initiatePaymentUsecase;
  late final GetHallsUsecase _getHallsUsecase;
  late final GetShowtimesUsecase _getShowtimesUsecase;
  late final GetSeatsUsecase _getSeatsUsecase;
  late final GetSnackItemsUsecase _getSnackItemsUsecase;
  late final GetSnackCombosUsecase _getSnackCombosUsecase;
  late final ConfirmPaymentUseCase _confirmPaymentUseCase;
  late final HoldSeatsUsecase _holdSeatsUsecase;

  @override
  BookingState build() {
    _getActiveOffersUsecase = ref.read(getActiveOffersUsecaseProvider);
    _getRewardsUsecase = ref.read(getRewardsUsecaseProvider);
    _getMyLoyaltyUsecase = ref.read(getMyLoyaltyUsecaseProvider);
    _initiatePaymentUsecase = ref.read(initiateKhaltiPaymentUsecaseProvider);
    _getHallsUsecase = ref.read(getHallsUsecaseProvider);
    _getShowtimesUsecase = ref.read(getShowtimesUsecaseProvider);
    _getSeatsUsecase = ref.read(getSeatsUsecaseProvider);
    _getSnackItemsUsecase = ref.read(getSnackItemsUsecaseProvider);
    _getSnackCombosUsecase = ref.read(getSnackCombosUsecaseProvider);
    _confirmPaymentUseCase = ref.read(confirmPaymentUseCaseProvider);
    _holdSeatsUsecase = ref.read(holdSeatsUsecaseProvider);

    const staticCities = ['Kathmandu', 'Biratnagar', 'Chitwan'];
    return BookingState(cities: staticCities);
  }

  void resetBookingSteps({bool keepOffer = true}) {
    state = state.copyWith(
      step: BookingStep.city,
      city: null,
      movieId: null,
      hallId: null,
      hallName: null,
      dateKey: null,
      showtime: null,
      selectedSeats: {},
      snackCart: {},
      ticketSubtotal: 0,
      snacksSubtotal: 0,
      discountAmount: 0,
      totalAfterDiscount: 0,
      selectedOfferCode: keepOffer ? state.selectedOfferCode : null,
      discountType: keepOffer ? state.discountType : 'none',
      status: BookingStatus.idle,
      resetError: true,
    );
    ref.read(selectedSeatsProvider.notifier).clearSeats();
  }

  void setMovieId(String movieId) {
    state = state.copyWith(movieId: movieId);
  }

  void selectCity(String city) {
    ref.read(selectedSeatsProvider.notifier).clearSeats();
    state = state.copyWith(
      city: city,
      step: BookingStep.hall,
      resetError: true,
      halls: [],
    );
    _loadHalls(city);
  }

  Future<void> _loadHalls(String city) async {
    final result = await _getHallsUsecase(city);
    result.fold(
      (Failure failure) {
        state = state.copyWith(
          errorMessage: 'Failed to load halls: ${failure.message}',
        );
      },
      (halls) {
        state = state.copyWith(halls: halls, resetError: true);
      },
    );
  }

  void selectHall({required String hallId, required String hallName}) {
    ref.read(selectedSeatsProvider.notifier).clearSeats();
    state = state.copyWith(
      hallId: hallId,
      hallName: hallName,
      step: BookingStep.dateTime,
      resetError: true,
    );
  }

  void selectDateKey(String key) {
    ref.read(selectedSeatsProvider.notifier).clearSeats();
    state = state.copyWith(
      dateKey: key, 
      resetError: true,
      showtimes: [],
    );
    if (state.hallId != null) {
      _loadShowtimes(state.hallId!, key);
    }
  }

  Future<void> _loadShowtimes(String hallId, String dateKey) async {
    final result = await _getShowtimesUsecase((movieId: state.movieId ?? '', hallId: hallId, dateKey: dateKey));
    result.fold(
      (Failure failure) {
        state = state.copyWith(
          errorMessage: 'Failed to load showtimes: ${failure.message}',
        );
      },
      (showtimes) {
        state = state.copyWith(showtimes: showtimes, resetError: true);
      },
    );
  }

  void selectShowtime(ShowtimeEntity time) {
    state = state.copyWith(
      showtime: time,
      step: BookingStep.seats,
      resetError: true,
    );
  }

  void toggleSeat(String seatId) {
    ref.read(selectedSeatsProvider.notifier).toggleSeat(seatId);
    final selectedSeats = ref.read(selectedSeatsProvider);
    state = state.copyWith(
      selectedSeats: selectedSeats,
      ticketSubtotal: selectedSeats.length * kSeatPrice,
    );
  }

  Future<void> goToSnacks() async {
    final selectedSeats = ref.read(selectedSeatsProvider);
    if (selectedSeats.isEmpty) {
      state = state.copyWith(
        status: BookingStatus.error,
        errorMessage: 'Please select at least one seat to continue',
      );
      return;
    }
    
    state = state.copyWith(
      status: BookingStatus.loading,
      selectedSeats: selectedSeats,
      ticketSubtotal: selectedSeats.length * kSeatPrice,
      resetError: true,
    );

    // Hold seats in backend
    if (state.showtime?.id != null) {
      await _holdSeatsUsecase(HoldSeatsParams(
        showtimeId: state.showtime!.id,
        seats: selectedSeats.toList(),
      ));
    }

    _loadSnacksData();
  }

  Future<void> _loadSnacksData() async {
    final snackItemsResult = await _getSnackItemsUsecase();
    final snackCombosResult = await _getSnackCombosUsecase();

    bool hasError = false;
    String? errorMessage;

    snackItemsResult.fold(
      (Failure failure) {
        hasError = true;
        errorMessage = failure.message;
      },
      (snackItems) {
        state = state.copyWith(snackItems: snackItems);
      },
    );

    snackCombosResult.fold(
      (Failure failure) {
        hasError = true;
        errorMessage = failure.message;
      },
      (snackCombos) {
        state = state.copyWith(snackCombos: snackCombos);
      },
    );

    state = state.copyWith(
      step: BookingStep.snacks,
      status: hasError ? BookingStatus.error : BookingStatus.readyToPay,
      errorMessage: hasError ? errorMessage : null,
    );
  }

  void goToCheckout() {
    _loadDiscountDataForCheckout();
  }

  Future<void> _loadDiscountDataForCheckout() async {
    final offersResult = await _getActiveOffersUsecase();
    final rewardsResult = await _getRewardsUsecase();
    final loyaltyResult = await _getMyLoyaltyUsecase();

    offersResult.fold(
      (Failure failure) {
        state = state.copyWith(
          status: BookingStatus.error,
          errorMessage: failure.message,
        );
      },
      (offers) {
        state = state.copyWith(offers: offers, resetError: true);
      },
    );

    rewardsResult.fold(
      (Failure failure) {
        state = state.copyWith(
          status: BookingStatus.error,
          errorMessage: failure.message,
        );
      },
      (rewards) {
        state = state.copyWith(rewards: rewards, resetError: true);
      },
    );

    loyaltyResult.fold(
      (Failure failure) {
        state = state.copyWith(
          status: BookingStatus.error,
          errorMessage: failure.message,
        );
      },
      (loyalty) {
        state = state.copyWith(
          loyaltyPoints: loyalty.loyaltyPoints,
          resetError: true,
        );
      },
    );

    _recalculateDiscount();
    _calculateTotals();
    
    state = state.copyWith(
      step: BookingStep.checkout,
      status: BookingStatus.readyToPay,
    );
  }

  void updateSnackQuantity(String id, int quantity, int price) {
    final cart = Map<String, int>.from(state.snackCart);
    if (quantity <= 0) {
      cart.remove(id);
    } else {
      cart[id] = quantity;
    }
    final snacksSubtotal = cart.values.fold<int>(
      0,
      (prev, qty) => prev + qty * price,
    );
    state = state.copyWith(snackCart: cart, snacksSubtotal: snacksSubtotal);
  }

  void selectDiscountType(String type) {
    state = state.copyWith(
      discountType: type,
      selectedOfferCode: type == 'offer' ? state.selectedOfferCode : null,
      selectedRewardId: type == 'loyalty' ? state.selectedRewardId : null,
      discountAmount: 0,
    );
    _recalculateDiscount();
    _calculateTotals();
  }

  void applyOfferCode(String code) {
    state = state.copyWith(
      selectedOfferCode: code,
      discountType: 'offer',
      resetError: true,
    );
    if (state.offers.isNotEmpty) {
      _recalculateDiscount();
      _calculateTotals();
    }
  }

  void selectOffer(String? code) {
    state = state.copyWith(selectedOfferCode: code, discountType: 'offer');
    _recalculateDiscount();
    _calculateTotals();
  }

  void selectReward(String? rewardId) {
    if (rewardId == null) {
      state = state.copyWith(selectedRewardId: null, discountType: 'none');
      _recalculateDiscount();
      return;
    }
    
    final reward = state.rewards.firstWhere(
      (r) => r.id == rewardId,
      orElse: () => RewardEntity(id: '', title: '', pointsRequired: 0),
    );
    
    if (reward.pointsRequired > state.loyaltyPoints) {
      return;
    }
    
    state = state.copyWith(selectedRewardId: rewardId, discountType: 'loyalty');
    _recalculateDiscount();
    _calculateTotals();
  }

  void _recalculateDiscount() {
    final total = state.totalBeforeDiscount;
    int discount = 0;

    if (state.discountType == 'offer' && state.selectedOfferCode != null) {
      final offer = state.offers.firstWhere(
        (o) => o.code == state.selectedOfferCode,
        orElse: () => OfferEntity(
          id: '',
          name: '',
          code: '',
          type: 'percentage_discount',
        ),
      );
      if (offer.id.isNotEmpty) {
        if (offer.type == 'percentage_discount' &&
            offer.discountPercent != null) {
          discount = ((total * offer.discountPercent!) / 100).floor();
        } else if (offer.type == 'fixed_discount' &&
            offer.discountAmount != null) {
          discount = offer.discountAmount!.floor();
        }
      }
    } else if (state.discountType == 'loyalty' &&
        state.selectedRewardId != null) {
      final reward = state.rewards.firstWhere(
        (r) => r.id == state.selectedRewardId,
        orElse: () => RewardEntity(id: '', title: '', pointsRequired: 0),
      );
      if (reward.id.isNotEmpty) {
        discount = reward.pointsRequired;
        if (discount > total) {
          discount = total;
        }
      }
    }

    if (discount > total) discount = total;
    state = state.copyWith(discountAmount: discount);
  }

  bool canProceedWithPayment() {
    if (state.discountType == 'loyalty' && state.selectedRewardId != null) {
      final reward = state.rewards.firstWhere(
        (r) => r.id == state.selectedRewardId,
        orElse: () => RewardEntity(id: '', title: '', pointsRequired: 0),
      );
      return reward.pointsRequired <= state.loyaltyPoints;
    }
    return true;
  }

  Future<String?> startPayment({
    required String movieId,
    required String movieTitle,
  }) async {
    final bookingSummary = state.toBookingSummary(
      movieId: movieId,
      movieTitle: movieTitle,
    );

    state = state.copyWith(status: BookingStatus.redirecting, resetError: true);

    final result = await _initiatePaymentUsecase(
      InitiateKhaltiPaymentParams(
        booking: bookingSummary,
        offerCode: state.discountType == 'offer'
            ? state.selectedOfferCode
            : null,
        loyaltyPointsToRedeem: state.discountType == 'loyalty'
            ? state.rewards
                  .firstWhere(
                    (r) => r.id == state.selectedRewardId,
                    orElse: () =>
                        RewardEntity(id: '', title: '', pointsRequired: 0),
                  )
                  .pointsRequired
            : null,
      ),
    );

    return result.fold(
      (Failure failure) {
        state = state.copyWith(
          status: BookingStatus.error,
          errorMessage: failure.message,
        );
        return null;
      },
      (data) {
        state = state.copyWith(
          status: BookingStatus.redirecting,
          pidx: data['pidx'],
          purchaseOrderId: data['purchaseOrderId'],
        );
        return data['payment_url'] as String?;
      },
    );
  }
  
  void _calculateTotals() {
    final total = state.ticketSubtotal + state.snacksSubtotal;
    final discountAmount = state.discountAmount;
    state = state.copyWith(
      totalAfterDiscount: total - discountAmount,
    );
  }

  Future<OrderEntity?> confirmPayment() async {
    if (state.pidx == null || state.purchaseOrderId == null) return null;

    state = state.copyWith(status: BookingStatus.loading, resetError: true);

    final result = await _confirmPaymentUseCase(
      pidx: state.pidx!,
      purchaseOrderId: state.purchaseOrderId!,
    );

    return result.fold(
      (Failure failure) {
        state = state.copyWith(
          status: BookingStatus.error,
          errorMessage: failure.message,
        );
        return null;
      },
      (order) {
        state = state.copyWith(status: BookingStatus.idle);
        return order;
      },
    );
  }
}
