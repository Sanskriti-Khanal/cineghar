import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cineghar/features/auth/domain/usecases/get_current_usecase.dart';
import 'package:cineghar/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:cineghar/features/auth/domain/usecases/login_usecase.dart';
import 'package:cineghar/features/auth/domain/usecases/logout_usecase.dart';
import 'package:cineghar/features/auth/domain/usecases/register_usecase.dart';
import 'package:cineghar/features/auth/domain/usecases/upload_profile_image_usecase.dart';
import 'package:cineghar/features/auth/presentation/providers/auth_state.dart';
import 'package:cineghar/features/auth/presentation/providers/auth_providers.dart';

class AuthViewmodel extends Notifier<AuthState> {
  late final RegisterUsecase _registerUsecase;
  late final LoginUsecase _loginUsecase;
  late final LogoutUsecase _logoutUsecase;
  late final GetCurrentUsecase _getCurrentUsecase;
  late final GetProfileUsecase _getProfileUsecase;
  late final UploadProfileImageUsecase _uploadProfileImageUsecase;

  @override
  AuthState build() {
    _registerUsecase = ref.read(registerUsecaseProvider);
    _loginUsecase = ref.read(loginUsecaseProvider);
    _logoutUsecase = ref.read(logoutUsecaseProvider);
    _getCurrentUsecase = ref.read(getCurrentUsecaseProvider);
    _getProfileUsecase = ref.read(getProfileUsecaseProvider);
    _uploadProfileImageUsecase = ref.read(uploadProfileImageUsecaseProvider);
    return AuthState.initial();
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    final result = await _registerUsecase(RegisterUsecaseParams(
      fullName: '$firstName $lastName',
      email: email,
      phoneNumber: phone,
      username: email, // Use email as username
      password: password,
    ));
    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (success) => state = state.copyWith(status: AuthStatus.registered),
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    final result = await _loginUsecase(LoginUsecaseParams(email: email, password: password));
    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (user) => state = state.copyWith(status: AuthStatus.authenticated, user: user),
    );
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);
    final result = await _logoutUsecase();
    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (token) => state = AuthState.initial(),
    );
  }

  Future<void> getCurrentUser() async {
    final result = await _getCurrentUsecase();
    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.unauthenticated,
      ),
      (user) => state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ),
    );
  }

  Future<void> getProfile() async {
    final result = await _getProfileUsecase();
    result.fold(
      (failure) => state = state.copyWith(
        errorMessage: failure.message,
      ),
      (user) => state = state.copyWith(
        user: user,
      ),
    );
  }

  Future<void> uploadProfileImage(File image) async {
    state = state.copyWith(status: AuthStatus.loading);
    final result = await _uploadProfileImageUsecase(image);
    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (user) => state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ),
    );
  }
}
