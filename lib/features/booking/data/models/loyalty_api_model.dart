import 'package:cineghar/features/booking/domain/entities/loyalty_entity.dart';

class LoyaltyTransactionApiModel {
  final String id;
  final int change;
  final String reason;
  final String createdAt;

  LoyaltyTransactionApiModel({
    required this.id,
    required this.change,
    required this.reason,
    required this.createdAt,
  });

  factory LoyaltyTransactionApiModel.fromJson(Map<String, dynamic> json) {
    return LoyaltyTransactionApiModel(
      id: json['_id']?.toString() ?? '',
      change: (json['change'] as num?)?.toInt() ?? 0,
      reason: json['reason']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
    );
  }

  LoyaltyTransactionEntity toEntity() {
    return LoyaltyTransactionEntity(
      id: id,
      change: change,
      reason: reason,
      createdAt: createdAt,
    );
  }
}

class LoyaltyMeApiModel {
  final int loyaltyPoints;
  final List<LoyaltyTransactionApiModel> recentTransactions;

  LoyaltyMeApiModel({
    required this.loyaltyPoints,
    required this.recentTransactions,
  });

  factory LoyaltyMeApiModel.fromJson(Map<String, dynamic> json) {
    final txList = (json['recentTransactions'] as List<dynamic>?) ?? const [];
    return LoyaltyMeApiModel(
      loyaltyPoints: (json['loyaltyPoints'] as num?)?.toInt() ?? 0,
      recentTransactions: txList
          .whereType<Map<String, dynamic>>()
          .map(LoyaltyTransactionApiModel.fromJson)
          .toList(),
    );
  }

  LoyaltyInfoEntity toEntity() {
    return LoyaltyInfoEntity(
      loyaltyPoints: loyaltyPoints,
      recentTransactions:
          recentTransactions.map((e) => e.toEntity()).toList(),
    );
  }
}
