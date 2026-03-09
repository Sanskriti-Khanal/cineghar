import 'package:dartz/dartz.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/core/usecases/app_usecase.dart';
import 'package:cineghar/features/booking/data/repositories/booking_repository.dart';
import 'package:cineghar/features/booking/domain/entities/loyalty_entity.dart';
import 'package:cineghar/features/booking/domain/repositories/booking_repository.dart';



class GetMyLoyaltyUsecase
    implements UsecaseWithoutParams<LoyaltyInfoEntity> {
  final IBookingRepository _repository;

  GetMyLoyaltyUsecase({required IBookingRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, LoyaltyInfoEntity>> call() {
    return _repository.getMyLoyalty();
  }
}
