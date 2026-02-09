import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/offer_entity.dart';

abstract interface class ISalesRepository {
  Future<Either<Failure, List<SalesOfferEntity>>> getActiveOffers();
}