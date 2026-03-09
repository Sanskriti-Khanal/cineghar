import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_datasource.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<OrderEntity>>> getMyOrders() async {
    try {
      final orders = await remoteDataSource.getMyOrders();
      return Right(orders);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> getOrderDetails(String orderId) async {
    try {
      final order = await remoteDataSource.getOrderDetails(orderId);
      return Right(order);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, OrderEntity>> confirmPayment({
    required String pidx,
    required String purchaseOrderId,
  }) async {
    try {
      final order = await remoteDataSource.confirmPayment(pidx, purchaseOrderId);
      return Right(order);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}