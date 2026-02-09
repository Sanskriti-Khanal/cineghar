import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/loyalty_entity.dart';
import '../entities/reward_entity.dart';

abstract interface class ILoyaltyRepository {
  Future<Either<Failure, LoyaltyInfoEntity>> getMyLoyalty();
  Future<Either<Failure, List<LoyaltyRewardEntity>>> getRewards();
}