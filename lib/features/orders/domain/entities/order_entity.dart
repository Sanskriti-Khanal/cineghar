import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final String id;
  final String user;
  final String purchaseOrderId;
  final String? pidx;
  final String? khaltiTransactionId;
  final num amount;
  final int seatsCount;
  final List<String> seats;
  final String? movieTitle;
  final String? movieId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  const OrderEntity({
    required this.id,
    required this.user,
    required this.purchaseOrderId,
    this.pidx,
    this.khaltiTransactionId,
    required this.amount,
    required this.seatsCount,
    required this.seats,
    this.movieTitle,
    this.movieId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        user,
        purchaseOrderId,
        pidx,
        khaltiTransactionId,
        amount,
        seatsCount,
        seats,
        movieTitle,
        movieId,
        status,
        createdAt,
        updatedAt,
      ];
}