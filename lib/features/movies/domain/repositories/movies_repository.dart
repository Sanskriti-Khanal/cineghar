import 'package:dartz/dartz.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/features/movies/domain/entities/movie_entity.dart';

abstract interface class IMoviesRepository {
  Future<Either<Failure, List<MovieEntity>>> getMovies({
    int page,
    int limit,
    String? search,
  });

  Future<Either<Failure, MovieEntity>> getMovieById(String id);
}
