import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../entities/loyalty_entity.dart';
import '../repositories/loyalty_repository.dart';

class GetMyLoyaltyUsecase implements UsecaseWithoutParams<LoyaltyInfoEntity> {
  final ILoyaltyRepository _repository;

  GetMyLoyaltyUsecase({required ILoyaltyRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, LoyaltyInfoEntity>> call() {
    return _repository.getMyLoyalty();
  }
}