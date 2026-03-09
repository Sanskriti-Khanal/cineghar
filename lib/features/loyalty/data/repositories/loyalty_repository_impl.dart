import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/loyalty_entity.dart';
import '../../domain/entities/reward_entity.dart';
import '../../domain/repositories/loyalty_repository.dart';
import '../datasources/loyalty_remote_datasource.dart';

class LoyaltyRepositoryImpl implements ILoyaltyRepository {
  final ILoyaltyRemoteDataSource remoteDataSource;

  LoyaltyRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, LoyaltyInfoEntity>> getMyLoyalty() async {
    try {
      final info = await remoteDataSource.getMyLoyalty();
      return Right(info);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LoyaltyRewardEntity>>> getRewards() async {
    try {
      final rewards = await remoteDataSource.getRewards();
      return Right(rewards);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}