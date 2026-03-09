import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/core/services/connectivity/network_info.dart';
import 'package:cineghar/features/auth/data/datasources/auth_datasource.dart';
import 'package:cineghar/features/auth/data/models/auth_api_model.dart';
import 'package:cineghar/features/auth/data/models/auth_hive_model.dart';
import 'package:cineghar/features/auth/domain/entities/auth_entity.dart';
import 'package:cineghar/features/auth/domain/repositories/auth_repository.dart';

// Provider

class AuthRepository implements IAuthRepository {
  final IAuthDatasource _authDataSource;
  final IAuthRemoteDataSource _authRemoteDataSource;
  final NetworkInfo _networkInfo;

  AuthRepository({
    required IAuthDatasource authDatasource,
    required IAuthRemoteDataSource authRemoteDataSource,
    required NetworkInfo networkInfo,
  }) : _authDataSource = authDatasource,
       _authRemoteDataSource = authRemoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async {
    try {
      final user = await _authDataSource.getCurrentUser();
      if (user != null) {
        final entity = user.toEntity();
        return Right(entity);
      }
      return const Left(LocalDatabaseFailure(message: "No user logged in"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> getProfile() async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        ApiFailure(message: "No internet. Connect to load profile."),
      );
    }
    try {
      final user = await _authRemoteDataSource.getProfile();
      if (user != null) {
        return Right(user.toEntity());
      }
      return const Left(ApiFailure(message: "Failed to load profile"));
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map && data['message'] != null
          ? data['message'].toString()
          : (data is String ? data : "Failed to load profile");
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
  Future<Either<Failure, AuthEntity>> uploadProfileImage(dynamic file) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        ApiFailure(message: "No internet. Connect to upload image."),
      );
    }
    try {
      final user = await _authRemoteDataSource.uploadProfileImage(file);
      if (user != null) {
        return Right(user.toEntity());
      }
      return const Left(ApiFailure(message: "Failed to upload image"));
    } on DioException catch (e) {
      final data = e.response?.data;
      final message = data is Map && data['message'] != null
          ? data['message'].toString()
          : (data is String ? data : "Failed to upload image");
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
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = await _authRemoteDataSource.login(email, password);
        if (apiModel != null) {
          final entity = apiModel.toEntity();
          // Save to local storage for offline access
          final hiveModel = AuthHiveModel.fromEntity(entity);
          await _authDataSource.register(hiveModel);
          return Right(entity);
        }
        return const Left(ApiFailure(message: "Invalid credentials"));
      } on DioException catch (e) {
        final data = e.response?.data;
        final message = data is Map && data['message'] != null
            ? data['message'].toString()
            : (data is String ? data : "Login failed");
        return Left(
          ApiFailure(
            message: message,
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        final user = await _authDataSource.login(email, password);
        if (user != null) {
          final entity = user.toEntity();
          return Right(entity);
        }
        return const Left(LocalDatabaseFailure(message: "Invalid email or password"));
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      // Clear remote session (SecureStorage and SharedPreferences)
      await _authRemoteDataSource.logout();
      // Clear local Hive session
      final result = await _authDataSource.logout();
      if (result) {
        return const Right(true);
      } else {
        return const Left(LocalDatabaseFailure(message: "Logout failed"));
      }
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> register(AuthEntity entity) async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModel = AuthApiModel.fromEntity(entity);
        await _authRemoteDataSource.register(apiModel);
        return const Right(true);
      } on DioException catch (e) {
        final data = e.response?.data;
        final message = data is Map && data['message'] != null
            ? data['message'].toString()
            : (data is String ? data : "Registration failed");
        return Left(
          ApiFailure(
            message: message,
            statusCode: e.response?.statusCode,
          ),
        );
      } catch (e) {
        return Left(ApiFailure(message: e.toString()));
      }
    } else {
      try {
        // Check if email already exists
        final existingUser = await _authDataSource.isEmailExists(entity.email);
        if (existingUser) {
          return const Left(
            LocalDatabaseFailure(message: "Email already registered"),
          );
        }

        final model = AuthHiveModel.fromEntity(entity);
        await _authDataSource.register(model);
        return const Right(true);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }
}