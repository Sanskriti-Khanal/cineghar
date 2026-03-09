import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/features/movies/domain/entities/movie_entity.dart';
import 'package:cineghar/features/movies/domain/repositories/movies_repository.dart';
import 'package:cineghar/features/movies/domain/usecases/get_movies_usecase.dart';

class _MockMoviesRepository extends Mock implements IMoviesRepository {}

void main() {
  late _MockMoviesRepository repository;
  late GetMoviesUsecase usecase;

  setUp(() {
    repository = _MockMoviesRepository();
    usecase = GetMoviesUsecase(repository: repository);
  });

  const tMovie = MovieEntity(
    id: '1',
    title: 'Test Movie',
    description: 'Description',
    genre: ['Drama'],
    duration: 120,
    rating: 4.5,
  );

  test('returns movies list on success', () async {
    when(() => repository.getMovies(
          page: any(named: 'page'),
          limit: any(named: 'limit'),
          search: any(named: 'search'),
        )).thenAnswer((_) async => const Right([tMovie]));

    final result = await usecase(const GetMoviesParams(page: 1, limit: 20));

    expect(result, const Right<Failure, List<MovieEntity>>([tMovie]));
    verify(() => repository.getMovies(page: 1, limit: 20, search: null))
        .called(1);
  });

  test('returns failure on error', () async {
    const failure = ApiFailure(message: 'error');
    when(() => repository.getMovies(
          page: any(named: 'page'),
          limit: any(named: 'limit'),
          search: any(named: 'search'),
        )).thenAnswer((_) async => const Left(failure));

    final result = await usecase(const GetMoviesParams(page: 1, limit: 20));

    expect(result, const Left<Failure, List<MovieEntity>>(failure));
  });
}

