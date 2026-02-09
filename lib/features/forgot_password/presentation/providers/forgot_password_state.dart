import 'package:equatable/equatable.dart';

enum ForgotPasswordStatus { initial, loading, otpSent, otpVerified, success, error }

class ForgotPasswordState extends Equatable {
  final ForgotPasswordStatus status;
  final String? email;
  final String? errorMessage;
  final bool isOtpVerified;

  const ForgotPasswordState({
    this.status = ForgotPasswordStatus.initial,
    this.email,
    this.errorMessage,
    this.isOtpVerified = false,
  });

  ForgotPasswordState copyWith({
    ForgotPasswordStatus? status,
    String? email,
    String? errorMessage,
    bool? isOtpVerified,
  }) {
    return ForgotPasswordState(
      status: status ?? this.status,
      email: email ?? this.email,
      errorMessage: errorMessage ?? this.errorMessage,
      isOtpVerified: isOtpVerified ?? this.isOtpVerified,
    );
  }

  @override
  List<Object?> get props => [status, email, errorMessage, isOtpVerified];
}
