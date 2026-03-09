import 'package:equatable/equatable.dart';

class LoyaltyTransactionEntity extends Equatable {
  final String id;
  final int change;
  final String reason;
  final String createdAt;

  const LoyaltyTransactionEntity({
    required this.id,
    required this.change,
    required this.reason,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, change, reason, createdAt];
}

class LoyaltyInfoEntity extends Equatable {
  final int loyaltyPoints;
  final List<LoyaltyTransactionEntity> recentTransactions;

  const LoyaltyInfoEntity({
    required this.loyaltyPoints,
    required this.recentTransactions,
  });

  @override
  List<Object?> get props => [loyaltyPoints, recentTransactions];
}
