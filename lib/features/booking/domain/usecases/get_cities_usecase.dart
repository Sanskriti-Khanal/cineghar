import 'package:dartz/dartz.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/core/usecases/app_usecase.dart';
import 'package:cineghar/features/booking/data/repositories/booking_repository.dart';
import 'package:cineghar/features/booking/domain/repositories/booking_repository.dart';


class GetCitiesUsecase implements UsecaseWithoutParams<List<String>> {
  final IBookingRepository _repository;

  GetCitiesUsecase(this._repository);

  Future<Either<Failure, List<String>>> call() {
    return _repository.getCities();
  }
}