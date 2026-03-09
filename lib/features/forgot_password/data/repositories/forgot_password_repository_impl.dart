import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/forgot_password_repository.dart';
import '../datasources/forgot_password_remote_datasource.dart';

class ForgotPasswordRepositoryImpl implements IForgotPasswordRepository {
  final IForgotPasswordRemoteDataSource remoteDataSource;

  ForgotPasswordRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, bool>> sendOtp(String email) async {
    try {
      final result = await remoteDataSource.sendOtp(email);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> verifyOtp(String email, String otp) async {
    try {
      final result = await remoteDataSource.verifyOtp(email, otp);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> resetPassword(String email, String newPassword) async {
    try {
      final result = await remoteDataSource.resetPassword(email, newPassword);
      return Right(result);
    } catch (e) {
      return Left(ApiFailure(message: e.toString()));
    }
  }
}
