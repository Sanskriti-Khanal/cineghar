import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';

enum OrderHistoryStatus { initial, loading, success, error }

class OrderHistoryState extends Equatable {
  final OrderHistoryStatus status;
  final List<OrderEntity> orders;
  final String? errorMessage;

  const OrderHistoryState({
    required this.status,
    required this.orders,
    this.errorMessage,
  });

  factory OrderHistoryState.initial() => const OrderHistoryState(
        status: OrderHistoryStatus.initial,
        orders: [],
      );

  OrderHistoryState copyWith({
    OrderHistoryStatus? status,
    List<OrderEntity>? orders,
    String? errorMessage,
  }) {
    return OrderHistoryState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, orders, errorMessage];
}
