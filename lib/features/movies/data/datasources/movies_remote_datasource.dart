import 'package:dio/dio.dart';
import 'package:cineghar/core/api/api_client.dart';
import 'package:cineghar/core/api/api_endpoints.dart';
import 'package:cineghar/features/movies/data/models/movie_api_model.dart';

abstract interface class IMoviesRemoteDatasource {
  Future<List<MovieApiModel>> getMovies({
    int page,
    int limit,
    String? search,
  });

  Future<MovieApiModel> getMovieById(String id);
}



class MoviesRemoteDatasource implements IMoviesRemoteDatasource {
  final ApiClient _apiClient;

  MoviesRemoteDatasource({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<MovieApiModel>> getMovies({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    try {
      final response = await _apiClient.get(
        ApiEndpoints.movies,
        queryParameters: <String, dynamic>{
          'page': page,
          'limit': limit,
          if (search != null && search.trim().isNotEmpty)
            'search': search.trim(),
        },
      );
      final data = response.data as Map<String, dynamic>;
      final list = data['data'] as List<dynamic>? ?? const [];
      return list
          .whereType<Map<String, dynamic>>()
          .map(MovieApiModel.fromJson)
          .toList();
    } on DioException {
      rethrow;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<MovieApiModel> getMovieById(String id) async {
    try {
      final response =
          await _apiClient.get(ApiEndpoints.movieById(id));
      final data = response.data as Map<String, dynamic>;
      final raw = data['data'] as Map<String, dynamic>;
      return MovieApiModel.fromJson(raw);
    } on DioException {
      rethrow;
    } catch (_) {
      rethrow;
    }
  }
}
