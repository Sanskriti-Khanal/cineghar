import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../data/datasources/forgot_password_remote_datasource.dart';
import '../../data/repositories/forgot_password_repository_impl.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import '../viewmodel/forgot_password_viewmodel.dart';
import 'forgot_password_state.dart';

final forgotPasswordRemoteDataSourceProvider = Provider<IForgotPasswordRemoteDataSource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return ForgotPasswordRemoteDataSourceImpl(apiClient);
});

final forgotPasswordRepositoryProvider = Provider((ref) {
  final remoteDataSource = ref.read(forgotPasswordRemoteDataSourceProvider);
  return ForgotPasswordRepositoryImpl(remoteDataSource);
});

final sendOtpUseCaseProvider = Provider((ref) {
  final repository = ref.read(forgotPasswordRepositoryProvider);
  return SendOtpUseCase(repository);
});

final verifyOtpUseCaseProvider = Provider((ref) {
  final repository = ref.read(forgotPasswordRepositoryProvider);
  return VerifyOtpUseCase(repository);
});

final resetPasswordUseCaseProvider = Provider((ref) {
  final repository = ref.read(forgotPasswordRepositoryProvider);
  return ResetPasswordUseCase(repository);
});

final forgotPasswordViewModelProvider =
    NotifierProvider<ForgotPasswordViewModel, ForgotPasswordState>(() {
  return ForgotPasswordViewModel();
});
