import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/features/forgot_password/domain/usecases/send_otp_usecase.dart';
import 'package:cineghar/features/forgot_password/domain/usecases/verify_otp_usecase.dart';
import 'package:cineghar/features/forgot_password/domain/usecases/reset_password_usecase.dart';
import 'package:cineghar/features/forgot_password/presentation/providers/forgot_password_state.dart';
import 'package:cineghar/features/forgot_password/presentation/providers/forgot_password_providers.dart';

class ForgotPasswordViewModel extends Notifier<ForgotPasswordState> {
  late final SendOtpUseCase _sendOtpUseCase;
  late final VerifyOtpUseCase _verifyOtpUseCase;
  late final ResetPasswordUseCase _resetPasswordUseCase;

  @override
  ForgotPasswordState build() {
    _sendOtpUseCase = ref.read(sendOtpUseCaseProvider);
    _verifyOtpUseCase = ref.read(verifyOtpUseCaseProvider);
    _resetPasswordUseCase = ref.read(resetPasswordUseCaseProvider);
    return const ForgotPasswordState();
  }

  Future<void> sendOtp(String email) async {
    state = state.copyWith(status: ForgotPasswordStatus.loading);
    final result = await _sendOtpUseCase(email);
    result.fold(
      (Failure failure) => state = state.copyWith(
        status: ForgotPasswordStatus.error,
        errorMessage: failure.message,
      ),
      (_) => state = state.copyWith(
        status: ForgotPasswordStatus.otpSent,
        email: email,
      ),
    );
  }

  Future<void> verifyOtp(String otp) async {
    if (state.email == null) return;
    state = state.copyWith(status: ForgotPasswordStatus.loading);
    final result = await _verifyOtpUseCase(state.email!, otp);
    result.fold(
      (Failure failure) => state = state.copyWith(
        status: ForgotPasswordStatus.error,
        errorMessage: failure.message,
      ),
      (_) => state = state.copyWith(
        status: ForgotPasswordStatus.otpVerified,
        isOtpVerified: true,
      ),
    );
  }

  Future<void> resetPassword(String newPassword) async {
    if (state.email == null) return;
    state = state.copyWith(status: ForgotPasswordStatus.loading);
    final result = await _resetPasswordUseCase(state.email!, newPassword);
    result.fold(
      (Failure failure) => state = state.copyWith(
        status: ForgotPasswordStatus.error,
        errorMessage: failure.message,
      ),
      (_) => state = state.copyWith(status: ForgotPasswordStatus.success),
    );
  }
}
