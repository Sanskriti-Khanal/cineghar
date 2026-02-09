import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/features/loyalty/domain/entities/loyalty_entity.dart';
import 'package:cineghar/features/loyalty/domain/entities/reward_entity.dart';
import 'package:cineghar/features/loyalty/domain/usecases/get_my_loyalty_usecase.dart';
import 'package:cineghar/features/loyalty/domain/usecases/get_rewards_usecase.dart';
import 'package:cineghar/features/loyalty/presentation/state/loyalty_state.dart';
import 'package:cineghar/features/loyalty/presentation/providers/loyalty_providers.dart';

class LoyaltyViewModel extends Notifier<LoyaltyState> {
  late final GetMyLoyaltyUsecase _getMyLoyaltyUsecase;
  late final GetLoyaltyRewardsUsecase _getRewardsUsecase;

  @override
  LoyaltyState build() {
    _getMyLoyaltyUsecase = ref.read(getMyLoyaltyUsecaseProvider);
    _getRewardsUsecase = ref.read(getLoyaltyRewardsUsecaseProvider);
    Future.microtask(() => load());
    return const LoyaltyState();
  }

  Future<void> load() async {
    try {
      state = state.copyWith(status: LoyaltyStatus.loading);
      
      final results = await Future.wait([
        _getMyLoyaltyUsecase(),
        _getRewardsUsecase(),
      ]);

      final loyaltyResult = results[0] as Either<Failure, LoyaltyInfoEntity>;
      final rewardsResult = results[1] as Either<Failure, List<LoyaltyRewardEntity>>;

      loyaltyResult.fold(
        (failure) {
          state = state.copyWith(
            status: LoyaltyStatus.error,
            errorMessage: failure.message,
          );
        },
        (info) {
          rewardsResult.fold(
            (failure) {
              state = state.copyWith(
                status: LoyaltyStatus.loaded,
                loyaltyInfo: info,
                rewards: [],
              );
            },
            (rewards) {
              state = state.copyWith(
                status: LoyaltyStatus.loaded,
                loyaltyInfo: info,
                rewards: rewards,
              );
            },
          );
        },
      );
    } catch (e) {
      state = state.copyWith(
        status: LoyaltyStatus.error,
        errorMessage: 'An unexpected error occurred: $e',
      );
    }
  }
}
