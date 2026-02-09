import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/order_entity.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<OrderEntity>>> getMyOrders();
  Future<Either<Failure, OrderEntity>> getOrderDetails(String orderId);
  Future<Either<Failure, OrderEntity>> confirmPayment({
    required String pidx,
    required String purchaseOrderId,
  });
}