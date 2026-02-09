import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/forgot_password_repository.dart';

class VerifyOtpUseCase {
  final IForgotPasswordRepository repository;

  VerifyOtpUseCase(this.repository);

  Future<Either<Failure, bool>> call(String email, String otp) {
    return repository.verifyOtp(email, otp);
  }
}
