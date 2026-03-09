import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/services/storage/user_session_service.dart';
import '../../data/datasources/order_remote_datasource.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../domain/repositories/order_repository.dart';
import '../../domain/usecases/order_usecases.dart';
import '../viewmodel/order_history_viewmodel.dart';
import 'order_history_state.dart';

final orderRemoteDataSourceProvider = Provider<OrderRemoteDataSource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  final userSessionService = ref.read(userSessionServiceProvider);
  return OrderRemoteDataSourceImpl(apiClient, userSessionService);
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final remoteDataSource = ref.read(orderRemoteDataSourceProvider);
  return OrderRepositoryImpl(remoteDataSource);
});

final getMyOrdersUseCaseProvider = Provider((ref) {
  final repository = ref.read(orderRepositoryProvider);
  return GetMyOrdersUseCase(repository);
});

final confirmPaymentUseCaseProvider = Provider((ref) {
  final repository = ref.read(orderRepositoryProvider);
  return ConfirmPaymentUseCase(repository);
});

final orderHistoryViewModelProvider =
    NotifierProvider.autoDispose<OrderHistoryViewModel, OrderHistoryState>(() {
  return OrderHistoryViewModel();
});
