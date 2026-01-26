import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/core/usecases/app_usecase.dart';
import 'package:cineghar/features/auth/data/repositories/auth_repository.dart';
import 'package:cineghar/features/auth/domain/entities/auth_entity.dart';
import 'package:cineghar/features/auth/domain/repositories/auth_repository.dart';

final uploadProfileImageUsecaseProvider = Provider<UploadProfileImageUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return UploadProfileImageUsecase(authRepository: authRepository);
});

class UploadProfileImageUsecase implements UsecaseWithParams<AuthEntity, dynamic> {
  final IAuthRepository _authRepository;

  UploadProfileImageUsecase({required IAuthRepository authRepository})
      : _authRepository = authRepository;

  @override
  Future<Either<Failure, AuthEntity>> call(dynamic file) {
    return _authRepository.uploadProfileImage(file);
  }
}
