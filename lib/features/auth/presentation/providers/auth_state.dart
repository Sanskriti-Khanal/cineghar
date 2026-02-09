import 'package:equatable/equatable.dart';
import 'package:cineghar/features/auth/domain/entities/auth_entity.dart';

enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  loading,
  registered,
  error,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final String? errorMessage;
  final AuthEntity? user;

  const AuthState({
    this.status = AuthStatus.initial,
    this.errorMessage,
    this.user,
  });

  factory AuthState.initial() => const AuthState(
        status: AuthStatus.initial,
      );

  // copyWith
  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    AuthEntity? user,
  }) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage, user];
}
