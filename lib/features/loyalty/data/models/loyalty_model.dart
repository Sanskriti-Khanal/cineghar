import '../../domain/entities/loyalty_entity.dart';

class LoyaltyTransactionModel extends LoyaltyTransactionEntity {
  const LoyaltyTransactionModel({
    required super.id,
    required super.change,
    required super.reason,
    required super.createdAt,
  });

  factory LoyaltyTransactionModel.fromJson(Map<String, dynamic> json) {
    return LoyaltyTransactionModel(
      id: json['_id']?.toString() ?? '',
      change: (json['change'] as num?)?.toInt() ?? 0,
      reason: json['reason']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }
}

class LoyaltyInfoModel extends LoyaltyInfoEntity {
  const LoyaltyInfoModel({
    required super.loyaltyPoints,
    required super.recentTransactions,
    super.membershipTier = 'Member',
    super.pointsMultiplier = 1.0,
    super.thisMonthPoints = 0,
    super.ticketsBooked = 0,
    super.rewardsRedeemed = 0,
  });

  factory LoyaltyInfoModel.fromJson(Map<String, dynamic> json) {
    // Handle both potential keys from different backend versions
    final points = (json['points'] ?? json['loyaltyPoints'] ?? 0) as num;
    final txList = (json['recentTransactions'] as List<dynamic>?) ?? const [];
    
    return LoyaltyInfoModel(
      loyaltyPoints: points.toInt(),
      recentTransactions: txList
          .whereType<Map<String, dynamic>>()
          .map(LoyaltyTransactionModel.fromJson)
          .toList(),
      membershipTier: json['membershipTier']?.toString() ?? 'Member',
      pointsMultiplier: (json['pointsMultiplier'] as num?)?.toDouble() ?? 1.5,
      thisMonthPoints: (json['thisMonthPoints'] as num?)?.toInt() ?? points.toInt(),
      ticketsBooked: (json['ticketsBooked'] as num?)?.toInt() ?? 18,
      rewardsRedeemed: (json['rewardsRedeemed'] as num?)?.toInt() ?? 6,
    );
  }
}