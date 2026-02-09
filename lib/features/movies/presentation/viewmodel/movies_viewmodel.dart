import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cineghar/features/movies/domain/usecases/get_movie_detail_usecase.dart';
import 'package:cineghar/features/movies/domain/usecases/get_movies_usecase.dart';
import 'package:cineghar/features/movies/presentation/providers/movies_state.dart';
import 'package:cineghar/features/movies/presentation/providers/movies_providers.dart';

class MoviesViewModel extends Notifier<MoviesState> {
  late final GetMoviesUsecase _getMoviesUsecase;
  late final GetMovieDetailUsecase _getMovieDetailUsecase;

  @override
  MoviesState build() {
    _getMoviesUsecase = ref.read(getMoviesUsecaseProvider);
    _getMovieDetailUsecase = ref.read(getMovieDetailUsecaseProvider);
    return const MoviesState();
  }

  Future<void> loadInitialMovies() async {
    await fetchMovies();
  }

  Future<void> fetchMovies({bool isRefresh = false}) async {
    if (state.status == MoviesStatus.loading && !isRefresh) return;
    if (isRefresh) {
      state = state.copyWith(page: 1, movies: [], status: MoviesStatus.loading);
    } else {
      state = state.copyWith(status: MoviesStatus.loading);
    }

    final result = await _getMoviesUsecase(GetMoviesParams(
      page: state.page,
      limit: state.limit,
      search: state.searchQuery.isEmpty ? null : state.searchQuery,
    ));

    result.fold(
      (failure) => state = state.copyWith(
        status: MoviesStatus.error,
        errorMessage: failure.message,
      ),
      (movies) => state = state.copyWith(
        status: MoviesStatus.loaded,
        movies: isRefresh ? movies : [...state.movies, ...movies],
        page: state.page + 1,
      ),
    );
  }

  Future<void> fetchMovieDetail(String id) async {
    final result = await _getMovieDetailUsecase(GetMovieDetailParams(id: id));
    result.fold(
      (failure) => state = state.copyWith(
        errorMessage: failure.message,
      ),
      (movie) => state = state.copyWith(
        selectedMovie: movie,
      ),
    );
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    fetchMovies(isRefresh: true);
  }
}
