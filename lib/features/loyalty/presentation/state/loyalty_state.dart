import 'package:equatable/equatable.dart';
import '../../domain/entities/loyalty_entity.dart';
import '../../domain/entities/reward_entity.dart';

enum LoyaltyStatus { loading, loaded, error }

class LoyaltyState extends Equatable {
  final LoyaltyStatus status;
  final LoyaltyInfoEntity? loyaltyInfo;
  final List<LoyaltyRewardEntity> rewards;
  final String? errorMessage;

  const LoyaltyState({
    this.status = LoyaltyStatus.loading,
    this.loyaltyInfo,
    this.rewards = const [],
    this.errorMessage,
  });

  LoyaltyState copyWith({
    LoyaltyStatus? status,
    LoyaltyInfoEntity? loyaltyInfo,
    List<LoyaltyRewardEntity>? rewards,
    String? errorMessage,
  }) {
    return LoyaltyState(
      status: status ?? this.status,
      loyaltyInfo: loyaltyInfo ?? this.loyaltyInfo,
      rewards: rewards ?? this.rewards,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        loyaltyInfo,
        rewards,
        errorMessage,
      ];
}
