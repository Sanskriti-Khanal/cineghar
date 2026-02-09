import 'package:dartz/dartz.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/core/usecases/app_usecase.dart';
import 'package:cineghar/features/booking/data/repositories/booking_repository.dart';
import 'package:cineghar/features/booking/domain/entities/reward_entity.dart';
import 'package:cineghar/features/booking/domain/repositories/booking_repository.dart';


class GetRewardsUsecase
    implements UsecaseWithoutParams<List<RewardEntity>> {
  final IBookingRepository _repository;

  GetRewardsUsecase({required IBookingRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, List<RewardEntity>>> call() {
    return _repository.getRewards();
  }
}