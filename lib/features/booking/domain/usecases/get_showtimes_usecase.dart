import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/booking_repository.dart';
import '../entities/showtime_entity.dart';

class GetShowtimesUsecase {
  final IBookingRepository repository;

  GetShowtimesUsecase(this.repository);

  Future<Either<Failure, List<ShowtimeEntity>>> call(({String movieId, String hallId, String dateKey}) params) {
    return repository.getShowtimes(
      movieId: params.movieId,
      hallId: params.hallId,
      dateKey: params.dateKey,
    );
  }
}