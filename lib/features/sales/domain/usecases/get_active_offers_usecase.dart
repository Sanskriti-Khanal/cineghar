import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/app_usecase.dart';
import '../entities/offer_entity.dart';
import '../repositories/sales_repository.dart';

class GetSalesOffersUsecase implements UsecaseWithoutParams<List<SalesOfferEntity>> {
  final ISalesRepository _repository;

  GetSalesOffersUsecase({required ISalesRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, List<SalesOfferEntity>>> call() {
    return _repository.getActiveOffers();
  }
}