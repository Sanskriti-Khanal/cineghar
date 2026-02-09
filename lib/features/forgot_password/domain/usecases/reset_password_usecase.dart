import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/forgot_password_repository.dart';

class ResetPasswordUseCase {
  final IForgotPasswordRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Either<Failure, bool>> call(String email, String newPassword) {
    return repository.resetPassword(email, newPassword);
  }
}
