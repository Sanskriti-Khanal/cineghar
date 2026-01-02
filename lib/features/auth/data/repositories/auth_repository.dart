import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/features/auth/data/datasources/auth_datasource.dart';
import 'package:cineghar/features/auth/data/datasources/local/auth_local_datasource.dart';
import 'package:cineghar/features/auth/data/models/auth_hive_model.dart';
import 'package:cineghar/features/auth/domain/entities/auth_entity.dart';
import 'package:cineghar/features/auth/domain/repositories/auth_repository.dart';

// Provider
final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  return AuthRepository(authDataSource: ref.read(authLocalDatasourceProvider));
});

class AuthRepository implements IAuthRepository {
  final IAuthDatasource _authDataSource;

  AuthRepository({required IAuthDatasource authDataSource})
      : _authDataSource = authDataSource;

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
  Future<Either<Failure, AuthEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final user = await _authDataSource.login(email, password);
      if (user != null) {
        final entity = user.toEntity();
        return Right(entity);
      }
      return const Left(
          LocalDatabaseFailure(message: "Invalid email or password"));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
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
    try {
      final model = AuthHiveModel.fromEntity(entity);
      
      // Check if email already exists
      final emailExists = await _authDataSource.isEmailExists(entity.email);
      if (emailExists) {
        return const Left(
            LocalDatabaseFailure(message: "Email already exists"));
      }

      final result = await _authDataSource.register(model);
      if (result) {
        return const Right(true);
      } else {
        return const Left(LocalDatabaseFailure(message: "Registration failed"));
      }
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}

