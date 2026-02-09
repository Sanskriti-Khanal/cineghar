import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/core/usecases/app_usecase.dart';
import 'package:cineghar/features/movies/data/repositories/movies_repository.dart';
import 'package:cineghar/features/movies/domain/entities/movie_entity.dart';
import 'package:cineghar/features/movies/domain/repositories/movies_repository.dart';

class GetMovieDetailParams extends Equatable {
  final String id;

  const GetMovieDetailParams({required this.id});

  @override
  List<Object?> get props => [id];
}



class GetMovieDetailUsecase
    implements UsecaseWithParams<MovieEntity, GetMovieDetailParams> {
  final IMoviesRepository _repository;

  GetMovieDetailUsecase({required IMoviesRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, MovieEntity>> call(
    GetMovieDetailParams params,
  ) {
    return _repository.getMovieById(params.id);
  }
}
