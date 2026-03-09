import 'package:dartz/dartz.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/core/usecases/app_usecase.dart';
import 'package:cineghar/features/auth/data/repositories/auth_repository.dart';
import 'package:cineghar/features/auth/domain/repositories/auth_repository.dart';

// Provider

class LogoutUsecase implements UsecaseWithoutParams<bool> {
  final IAuthRepository _authRepository;

  LogoutUsecase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, bool>> call() {
    return _authRepository.logout();
  }
}