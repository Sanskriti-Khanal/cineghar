import 'package:equatable/equatable.dart';
import '../../domain/entities/offer_entity.dart';
import '../../domain/entities/reward_entity.dart';
import '../../domain/entities/seat_entity.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/entities/hall_entity.dart';
import '../../domain/entities/snack_entity.dart';
import '../../domain/entities/showtime_entity.dart';

enum BookingStep { city, hall, dateTime, seats, snacks, checkout }

enum BookingStatus { idle, loading, readyToPay, redirecting, error }

class BookingState extends Equatable {
  final BookingStep step;
  final String? city;
  final String? movieId;
  final String? hallId;
  final String? hallName;
  final String? dateKey;
  final ShowtimeEntity? showtime;
  final Set<String> selectedSeats;
  final Map<String, int> snackCart;
  final String? errorMessage;
  final String? pidx;
  final String? purchaseOrderId;
  final String? discountType;
  final String? selectedOfferCode;
  final String? selectedRewardId;
  final List<OfferEntity> offers;
  final List<RewardEntity> rewards;
  final List<SnackItemEntity> snackItems;
  final List<SnackComboEntity> snackCombos;
  final int loyaltyPoints;
  final int ticketSubtotal;
  final int snacksSubtotal;
  final int discountAmount;
  final int totalAfterDiscount;
  final BookingStatus status;
  final List<String> cities;
  final List<HallEntity> halls;
  final List<ShowtimeEntity> showtimes;
  final List<List<SeatEntity>> seats;

  const BookingState({
    this.step = BookingStep.city,
    this.city,
    this.movieId,
    this.hallId,
    this.hallName,
    this.dateKey,
    this.showtime,
    this.selectedSeats = const {},
    this.snackCart = const {},
    this.errorMessage,
    this.pidx,
    this.purchaseOrderId,
    this.discountType = 'none',
    this.selectedOfferCode,
    this.selectedRewardId,
    this.offers = const [],
    this.rewards = const [],
    this.snackItems = const [],
    this.snackCombos = const [],
    this.loyaltyPoints = 0,
    this.ticketSubtotal = 0,
    this.snacksSubtotal = 0,
    this.discountAmount = 0,
    this.totalAfterDiscount = 0,
    this.status = BookingStatus.idle,
    this.cities = const [],
    this.halls = const [],
    this.showtimes = const [],
    this.seats = const [],
  });

  BookingState copyWith({
    BookingStep? step,
    String? city,
    String? movieId,
    String? hallId,
    String? hallName,
    String? dateKey,
    ShowtimeEntity? showtime,
    Set<String>? selectedSeats,
    Map<String, int>? snackCart,
    String? errorMessage,
    String? pidx,
    String? purchaseOrderId,
    String? discountType,
    String? selectedOfferCode,
    String? selectedRewardId,
    List<OfferEntity>? offers,
    List<RewardEntity>? rewards,
    List<SnackItemEntity>? snackItems,
    List<SnackComboEntity>? snackCombos,
    int? loyaltyPoints,
    int? ticketSubtotal,
    int? snacksSubtotal,
    int? discountAmount,
    int? totalAfterDiscount,
    BookingStatus? status,
    List<String>? cities,
    List<HallEntity>? halls,
    List<ShowtimeEntity>? showtimes,
    List<List<SeatEntity>>? seats,
    bool? resetError,
  }) {
    return BookingState(
      step: step ?? this.step,
      city: city ?? this.city,
      movieId: movieId ?? this.movieId,
      hallId: hallId ?? this.hallId,
      hallName: hallName ?? this.hallName,
      dateKey: dateKey ?? this.dateKey,
      showtime: showtime ?? this.showtime,
      selectedSeats: selectedSeats ?? this.selectedSeats,
      snackCart: snackCart ?? this.snackCart,
      errorMessage: resetError == true
          ? null
          : (errorMessage ?? this.errorMessage),
      pidx: pidx ?? this.pidx,
      purchaseOrderId: purchaseOrderId ?? this.purchaseOrderId,
      discountType: discountType ?? this.discountType,
      selectedOfferCode: selectedOfferCode ?? this.selectedOfferCode,
      selectedRewardId: selectedRewardId ?? this.selectedRewardId,
      offers: offers ?? this.offers,
      rewards: rewards ?? this.rewards,
      snackItems: snackItems ?? this.snackItems,
      snackCombos: snackCombos ?? this.snackCombos,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      ticketSubtotal: ticketSubtotal ?? this.ticketSubtotal,
      snacksSubtotal: snacksSubtotal ?? this.snacksSubtotal,
      discountAmount: discountAmount ?? this.discountAmount,
      totalAfterDiscount: totalAfterDiscount ?? this.totalAfterDiscount,
      status: status ?? this.status,
      cities: cities ?? this.cities,
      halls: halls ?? this.halls,
      showtimes: showtimes ?? this.showtimes,
      seats: seats ?? this.seats,
    );
  }

  int get totalBeforeDiscount => ticketSubtotal + snacksSubtotal;

  // Add this method to convert state to booking summary
  BookingSummaryEntity toBookingSummary({
    required String movieId,
    required String movieTitle,
  }) {
    return BookingSummaryEntity(
      movieId: movieId,
      movieTitle: movieTitle,
      city: city ?? '',
      hallId: hallId ?? '',
      hallName: hallName ?? '',
      dateKey: dateKey ?? '',
      showtime: showtime?.time ?? '',
      showtimeId: showtime?.id ?? '',
      seats: selectedSeats.map((seatId) => BookingSeat(seatId)).toList(),
      ticketSubtotal: ticketSubtotal,
      snacksSubtotal: snacksSubtotal,
      totalBeforeDiscount: totalBeforeDiscount,
    );
  }

  @override
  List<Object?> get props => [
    step,
    city,
    movieId,
    hallId,
    hallName,
    dateKey,
    showtime,
    selectedSeats,
    snackCart,
    errorMessage,
    pidx,
    purchaseOrderId,
    discountType,
    selectedOfferCode,
    selectedRewardId,
    offers,
    rewards,
    snackItems,
    snackCombos,
    loyaltyPoints,
    ticketSubtotal,
    snacksSubtotal,
    discountAmount,
    totalAfterDiscount,
    status,
    cities,
    halls,
    showtimes,
    seats,
  ];
}
