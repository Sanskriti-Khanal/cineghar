import 'package:dartz/dartz.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/core/usecases/app_usecase.dart';
import 'package:cineghar/features/booking/data/repositories/booking_repository.dart';
import 'package:cineghar/features/booking/domain/entities/offer_entity.dart';
import 'package:cineghar/features/booking/domain/repositories/booking_repository.dart';



class GetActiveOffersUsecase
    implements UsecaseWithoutParams<List<OfferEntity>> {
  final IBookingRepository _repository;

  GetActiveOffersUsecase({required IBookingRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, List<OfferEntity>>> call() {
    return _repository.getActiveOffers();
  }
}
