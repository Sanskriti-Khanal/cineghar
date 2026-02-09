import 'package:dartz/dartz.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/core/usecases/app_usecase.dart';
import 'package:cineghar/features/booking/data/repositories/booking_repository.dart';
import 'package:cineghar/features/booking/domain/entities/snack_entity.dart';
import 'package:cineghar/features/booking/domain/repositories/booking_repository.dart';


class GetSnackItemsUsecase implements UsecaseWithoutParams<List<SnackItemEntity>> {
  final IBookingRepository _repository;

  GetSnackItemsUsecase({required IBookingRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, List<SnackItemEntity>>> call() {
    return _repository.getSnackItems();
  }
}


class GetSnackCombosUsecase implements UsecaseWithoutParams<List<SnackComboEntity>> {
  final IBookingRepository _repository;

  GetSnackCombosUsecase({required IBookingRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, List<SnackComboEntity>>> call() {
    return _repository.getSnackCombos();
  }
}