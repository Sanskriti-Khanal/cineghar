import '../../domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.user,
    required super.purchaseOrderId,
    super.pidx,
    super.khaltiTransactionId,
    required super.amount,
    required super.seatsCount,
    required super.seats,
    super.movieTitle,
    super.movieId,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['_id'] ?? '',
      user: json['user'] ?? '',
      purchaseOrderId: json['purchaseOrderId'] ?? '',
      pidx: json['pidx'],
      khaltiTransactionId: json['khaltiTransactionId'],
      amount: json['amount'] ?? 0,
      seatsCount: json['seatsCount'] ?? 0,
      seats: List<String>.from(json['seats'] ?? []),
      movieTitle: json['movieTitle'],
      movieId: json['movieId'],
      status: json['status'] ?? 'pending',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user,
      'purchaseOrderId': purchaseOrderId,
      'pidx': pidx,
      'khaltiTransactionId': khaltiTransactionId,
      'amount': amount,
      'seatsCount': seatsCount,
      'seats': seats,
      'movieTitle': movieTitle,
      'movieId': movieId,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}