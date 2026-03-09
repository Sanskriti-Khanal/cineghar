import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cineghar/features/orders/domain/usecases/order_usecases.dart';
import 'package:cineghar/features/orders/presentation/providers/order_history_state.dart';
import 'package:cineghar/features/orders/presentation/providers/orders_providers.dart';

class OrderHistoryViewModel extends Notifier<OrderHistoryState> {
  late final GetMyOrdersUseCase _getMyOrdersUseCase;

  @override
  OrderHistoryState build() {
    _getMyOrdersUseCase = ref.read(getMyOrdersUseCaseProvider);
    return OrderHistoryState.initial();
  }

  Future<void> fetchMyOrders() async {
    state = state.copyWith(status: OrderHistoryStatus.loading);

    final result = await _getMyOrdersUseCase();

    result.fold(
      (failure) {
        state = state.copyWith(
          status: OrderHistoryStatus.error,
          errorMessage: failure.message,
        );
      },
      (orders) {
        final sortedOrders = List.of(orders)
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
          
        state = state.copyWith(
          status: OrderHistoryStatus.success,
          orders: sortedOrders,
        );
      },
    );
  }
}
