import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class GetMyOrdersUseCase {
  final OrderRepository repository;

  GetMyOrdersUseCase(this.repository);

  Future<Either<Failure, List<OrderEntity>>> call() async {
    return await repository.getMyOrders();
  }
}

class ConfirmPaymentUseCase {
  final OrderRepository repository;

  ConfirmPaymentUseCase(this.repository);

  Future<Either<Failure, OrderEntity>> call({
    required String pidx,
    required String purchaseOrderId,
  }) async {
    return await repository.confirmPayment(
      pidx: pidx,
      purchaseOrderId: purchaseOrderId,
    );
  }
}