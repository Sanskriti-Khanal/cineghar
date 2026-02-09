import 'package:dartz/dartz.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/core/usecases/app_usecase.dart';
import 'package:cineghar/features/booking/domain/entities/hall_entity.dart';
import 'package:cineghar/features/booking/domain/repositories/booking_repository.dart';

class GetHallsUsecase implements UsecaseWithParams<List<HallEntity>, String> {
  final IBookingRepository _repository;

  GetHallsUsecase(this._repository);

  @override
  Future<Either<Failure, List<HallEntity>>> call(String params) {
    return _repository.getHalls(params);
  }
}