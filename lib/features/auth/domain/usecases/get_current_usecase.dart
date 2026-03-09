import 'package:dartz/dartz.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/core/usecases/app_usecase.dart';
import 'package:cineghar/features/auth/data/repositories/auth_repository.dart';
import 'package:cineghar/features/auth/domain/entities/auth_entity.dart';
import 'package:cineghar/features/auth/domain/repositories/auth_repository.dart';

// Provider

class GetCurrentUsecase implements UsecaseWithoutParams<AuthEntity> {
  final IAuthRepository _authRepository;

  GetCurrentUsecase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, AuthEntity>> call() {
    return _authRepository.getCurrentUser();
  }
}