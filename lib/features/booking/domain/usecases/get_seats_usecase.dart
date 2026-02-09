import 'package:dartz/dartz.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/core/usecases/app_usecase.dart';
import 'package:cineghar/features/booking/domain/entities/seat_entity.dart';
import 'package:cineghar/features/booking/domain/repositories/booking_repository.dart';

class GetSeatsUsecase
    implements
        UsecaseWithParams<
          List<List<SeatEntity>>,
          ({String hallId, String dateKey, String showtimeId})
        > {
  final IBookingRepository _repository;

  GetSeatsUsecase(this._repository);

  @override
  Future<Either<Failure, List<List<SeatEntity>>>> call(
    ({String hallId, String dateKey, String showtimeId}) params,
  ) {
    return _repository.getSeats(
      hallId: params.hallId,
      dateKey: params.dateKey,
      showtimeId: params.showtimeId,
    );
  }
}