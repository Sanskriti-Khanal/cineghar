import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/services/connectivity/network_info.dart';
import '../../data/datasources/booking_mock_datasource.dart';
import '../../data/datasources/booking_remote_datasource.dart';
import '../../data/repositories/booking_repository.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../domain/usecases/get_active_offers_usecase.dart';
import '../../domain/usecases/get_my_loyalty_usecase.dart';
import '../../domain/usecases/get_rewards_usecase.dart';
import '../../domain/usecases/initiate_khalti_payment_usecase.dart';
import '../../domain/usecases/get_halls_usecase.dart';
import '../../domain/usecases/get_showtimes_usecase.dart';
import '../../domain/usecases/get_seats_usecase.dart';
import '../../domain/usecases/get_snacks_usecase.dart';
import '../../domain/usecases/hold_seats_usecase.dart';
import '../../domain/entities/seat_entity.dart';
import '../../domain/entities/showtime_entity.dart';
import '../../domain/entities/hall_entity.dart';
import '../../../orders/presentation/providers/orders_providers.dart';
import '../viewmodel/booking_viewmodel.dart';
import '../state/booking_state.dart';

final bookingRemoteDatasourceProvider = Provider<IBookingRemoteDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return BookingRemoteDatasource(apiClient: apiClient);
});

final bookingMockDatasourceProvider = Provider<IBookingRemoteDatasource>((ref) {
  return BookingMockDatasource();
});

final bookingRepositoryProvider = Provider<IBookingRepository>((ref) {
  if (AppConfig.useMockData) {
    final mockRemote = ref.read(bookingMockDatasourceProvider);
    final networkInfo = ref.read(networkInfoProvider);
    return BookingRepository(remoteDatasource: mockRemote, networkInfo: networkInfo);
  } else {
    final remote = ref.read(bookingRemoteDatasourceProvider);
    final networkInfo = ref.read(networkInfoProvider);
    return BookingRepository(remoteDatasource: remote, networkInfo: networkInfo);
  }
});

final getActiveOffersUsecaseProvider = Provider<GetActiveOffersUsecase>((ref) {
  final repository = ref.read(bookingRepositoryProvider);
  return GetActiveOffersUsecase(repository: repository);
});

final getRewardsUsecaseProvider = Provider<GetRewardsUsecase>((ref) {
  final repository = ref.read(bookingRepositoryProvider);
  return GetRewardsUsecase(repository: repository);
});

final getMyLoyaltyUsecaseProvider = Provider<GetMyLoyaltyUsecase>((ref) {
  final repository = ref.read(bookingRepositoryProvider);
  return GetMyLoyaltyUsecase(repository: repository);
});

final initiateKhaltiPaymentUsecaseProvider = Provider<InitiateKhaltiPaymentUsecase>((ref) {
  final repository = ref.read(bookingRepositoryProvider);
  return InitiateKhaltiPaymentUsecase(repository: repository);
});

final getHallsUsecaseProvider = Provider<GetHallsUsecase>((ref) {
  final repository = ref.read(bookingRepositoryProvider);
  return GetHallsUsecase(repository);
});

final getShowtimesUsecaseProvider = Provider<GetShowtimesUsecase>((ref) {
  final repository = ref.read(bookingRepositoryProvider);
  return GetShowtimesUsecase(repository);
});

final getSeatsUsecaseProvider = Provider<GetSeatsUsecase>((ref) {
  final repository = ref.read(bookingRepositoryProvider);
  return GetSeatsUsecase(repository);
});

final getSnackItemsUsecaseProvider = Provider<GetSnackItemsUsecase>((ref) {
  final repository = ref.read(bookingRepositoryProvider);
  return GetSnackItemsUsecase(repository: repository);
});

final getSnackCombosUsecaseProvider = Provider<GetSnackCombosUsecase>((ref) {
  final repository = ref.read(bookingRepositoryProvider);
  return GetSnackCombosUsecase(repository: repository);
});

final holdSeatsUsecaseProvider = Provider<HoldSeatsUsecase>((ref) {
  final repository = ref.read(bookingRepositoryProvider);
  return HoldSeatsUsecase(repository: repository);
});

// UI helper Providers
final seatsProvider = FutureProvider.family<List<List<SeatEntity>>, 
    ({String hallId, String dateKey, String showtimeId})>((ref, params) async {
  final usecase = ref.read(getSeatsUsecaseProvider);
  final result = await usecase(params);
  return result.fold(
    (failure) => throw failure.message,
    (seats) => seats,
  );
});

final hallsProvider = FutureProvider.family<List<HallEntity>, String>((ref, city) async {
  final usecase = ref.read(getHallsUsecaseProvider);
  final result = await usecase(city);
  return result.fold(
    (failure) => throw failure.message,
    (halls) => halls,
  );
});

final showtimesProvider = FutureProvider.family<List<ShowtimeEntity>, ({String movieId, String hallId, String dateKey})>((ref, params) async {
  final usecase = ref.read(getShowtimesUsecaseProvider);
  final result = await usecase(params);
  return result.fold(
    (failure) => throw failure.message,
    (times) => times,
  );
});

final bookingViewModelProvider =
    NotifierProvider<BookingViewModel, BookingState>(() {
  return BookingViewModel();
});
