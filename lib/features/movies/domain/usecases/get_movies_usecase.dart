import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/core/usecases/app_usecase.dart';
import 'package:cineghar/features/movies/data/repositories/movies_repository.dart';
import 'package:cineghar/features/movies/domain/entities/movie_entity.dart';
import 'package:cineghar/features/movies/domain/repositories/movies_repository.dart';

class GetMoviesParams extends Equatable {
  final int page;
  final int limit;
  final String? search;

  const GetMoviesParams({
    this.page = 1,
    this.limit = 20,
    this.search,
  });

  @override
  List<Object?> get props => [page, limit, search];
}


class GetMoviesUsecase
    implements UsecaseWithParams<List<MovieEntity>, GetMoviesParams> {
  final IMoviesRepository _repository;

  GetMoviesUsecase({required IMoviesRepository repository})
      : _repository = repository;

  @override
  Future<Either<Failure, List<MovieEntity>>> call(
    GetMoviesParams params,
  ) {
    return _repository.getMovies(
      page: params.page,
      limit: params.limit,
      search: params.search,
    );
  }
}