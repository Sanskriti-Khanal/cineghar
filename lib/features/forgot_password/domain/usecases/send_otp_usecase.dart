import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/forgot_password_repository.dart';

class SendOtpUseCase {
  final IForgotPasswordRepository repository;

  SendOtpUseCase(this.repository);

  Future<Either<Failure, bool>> call(String email) {
    return repository.sendOtp(email);
  }
}
