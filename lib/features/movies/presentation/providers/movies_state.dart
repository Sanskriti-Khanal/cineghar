import 'package:equatable/equatable.dart';
import 'package:cineghar/features/movies/domain/entities/movie_entity.dart';

enum MoviesStatus { initial, loading, loaded, error }

class MoviesState extends Equatable {
  final MoviesStatus status;
  final List<MovieEntity> movies;
  final MovieEntity? selectedMovie;
  final String? errorMessage;
  final int page;
  final int limit;
  final String searchQuery;

  const MoviesState({
    this.status = MoviesStatus.initial,
    this.movies = const [],
    this.selectedMovie,
    this.errorMessage,
    this.page = 1,
    this.limit = 20,
    this.searchQuery = '',
  });

  MoviesState copyWith({
    MoviesStatus? status,
    List<MovieEntity>? movies,
    MovieEntity? selectedMovie,
    String? errorMessage,
    bool resetError = false,
    int? page,
    int? limit,
    String? searchQuery,
  }) {
    return MoviesState(
      status: status ?? this.status,
      movies: movies ?? this.movies,
      selectedMovie: selectedMovie ?? this.selectedMovie,
      errorMessage:
          resetError ? null : (errorMessage ?? this.errorMessage),
      page: page ?? this.page,
      limit: limit ?? this.limit,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        status,
        movies,
        selectedMovie,
        errorMessage,
        page,
        limit,
        searchQuery,
      ];
}
