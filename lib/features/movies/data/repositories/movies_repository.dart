import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/core/services/connectivity/network_info.dart';
import 'package:cineghar/features/movies/data/datasources/movies_remote_datasource.dart';
import 'package:cineghar/features/movies/domain/entities/movie_entity.dart';
import 'package:cineghar/features/movies/domain/repositories/movies_repository.dart';


class MoviesRepository implements IMoviesRepository {
  final IMoviesRemoteDatasource _remoteDatasource;
  final INetworkInfo _networkInfo;

  MoviesRepository({
    required IMoviesRemoteDatasource remoteDatasource,
    required INetworkInfo networkInfo,
  })  : _remoteDatasource = remoteDatasource,
        _networkInfo = networkInfo;

  @override
  Future<Either<Failure, List<MovieEntity>>> getMovies({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        ApiFailure(message: 'No internet. Connect to load movies.'),
      );
    }
    try {
      final models = await _remoteDatasource.getMovies(
        page: page,
        limit: limit,
        search: search,
      );
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map && data['message'] != null
          ? data['message'].toString()
          : (data is String ? data : 'Failed to load movies');
      return Left(
        ApiFailure(
          message: message,
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, MovieEntity>> getMovieById(String id) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        ApiFailure(message: 'No internet. Connect to load movie detail.'),
      );
    }
    try {
      final model = await _remoteDatasource.getMovieById(id);
      return Right(model.toEntity());
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map && data['message'] != null
          ? data['message'].toString()
          : (data is String ? data : 'Failed to load movie detail');
      return Left(
        ApiFailure(
          message: message,
          statusCode: e.response?.statusCode,
        ),
      );
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}