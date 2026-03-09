import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/offer_entity.dart';
import '../../domain/repositories/sales_repository.dart';
import '../datasources/sales_remote_datasource.dart';

class SalesRepositoryImpl implements ISalesRepository {
  final ISalesRemoteDataSource remoteDataSource;

  SalesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<SalesOfferEntity>>> getActiveOffers() async {
    try {
      final offers = await remoteDataSource.getActiveOffers();
      return Right(offers);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}