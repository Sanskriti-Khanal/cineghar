import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../entities/reward_entity.dart';
import '../repositories/loyalty_repository.dart';

class GetLoyaltyRewardsUsecase implements UsecaseWithoutParams<List<LoyaltyRewardEntity>> {
  final ILoyaltyRepository _repository;

  GetLoyaltyRewardsUsecase({required ILoyaltyRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, List<LoyaltyRewardEntity>>> call() {
    return _repository.getRewards();
  }
}