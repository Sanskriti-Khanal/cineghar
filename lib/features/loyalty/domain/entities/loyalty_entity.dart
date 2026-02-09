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
  // User mentions other fields in the prompt:
  // Member member, 1.5x on tickets, This month points, Tickets booked, Rewards redeemed.
  // These aren't in the current LoyaltyMeApiModel, so I'll add them as optional fields for now.
  final String? membershipTier;
  final double? pointsMultiplier;
  final int? thisMonthPoints;
  final int? ticketsBooked;
  final int? rewardsRedeemed;

  const LoyaltyInfoEntity({
    required this.loyaltyPoints,
    required this.recentTransactions,
    this.membershipTier = 'Member',
    this.pointsMultiplier = 1.0,
    this.thisMonthPoints = 0,
    this.ticketsBooked = 0,
    this.rewardsRedeemed = 0,
  });

  @override
  List<Object?> get props => [
        loyaltyPoints,
        recentTransactions,
        membershipTier,
        pointsMultiplier,
        thisMonthPoints,
        ticketsBooked,
        rewardsRedeemed,
      ];
}