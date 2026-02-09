import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/core/usecases/app_usecase.dart';
import 'package:cineghar/features/booking/domain/repositories/booking_repository.dart';

class HoldSeatsParams extends Equatable {
  final String showtimeId;
  final List<String> seats;

  const HoldSeatsParams({
    required this.showtimeId,
    required this.seats,
  });

  @override
  List<Object?> get props => [showtimeId, seats];
}

class HoldSeatsUsecase implements UsecaseWithParams<void, HoldSeatsParams> {
  final IBookingRepository _repository;

  HoldSeatsUsecase({required IBookingRepository repository}) : _repository = repository;

  @override
  Future<Either<Failure, void>> call(HoldSeatsParams params) {
    return _repository.holdSeats(
      showtimeId: params.showtimeId,
      seats: params.seats,
    );
  }
}
