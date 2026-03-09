import 'package:cineghar/features/movies/presentation/providers/movies_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/services/connectivity/network_info.dart';
import '../../data/datasources/movies_remote_datasource.dart';
import '../../data/repositories/movies_repository.dart';
import '../../domain/repositories/movies_repository.dart';
import '../../domain/usecases/get_movie_detail_usecase.dart';
import '../../domain/usecases/get_movies_usecase.dart';
import '../viewmodel/movies_viewmodel.dart';
import 'movies_state.dart';

final moviesRemoteDatasourceProvider = Provider<IMoviesRemoteDatasource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return MoviesRemoteDatasource(apiClient: apiClient);
});

final moviesRepositoryProvider = Provider<IMoviesRepository>((ref) {
  final remote = ref.read(moviesRemoteDatasourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return MoviesRepository(remoteDatasource: remote, networkInfo: networkInfo);
});

final getMoviesUsecaseProvider = Provider((ref) {
  final repo = ref.read(moviesRepositoryProvider);
  return GetMoviesUsecase(repository: repo);
});

final getMovieDetailUsecaseProvider = Provider((ref) {
  final repo = ref.read(moviesRepositoryProvider);
  return GetMovieDetailUsecase(repository: repo);
});

final moviesViewModelProvider =
    NotifierProvider<MoviesViewModel, MoviesState>(() {
  return MoviesViewModel();
});
