import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

abstract class IForgotPasswordRepository {
  Future<Either<Failure, bool>> sendOtp(String email);
  Future<Either<Failure, bool>> verifyOtp(String email, String otp);
  Future<Either<Failure, bool>> resetPassword(String email, String newPassword);
}
