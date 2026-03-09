import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/features/auth/domain/entities/auth_entity.dart';
import 'package:cineghar/features/auth/domain/usecases/login_usecase.dart';
import 'package:cineghar/features/auth/domain/usecases/register_usecase.dart';
import 'package:cineghar/features/auth/domain/usecases/logout_usecase.dart';
import 'package:cineghar/features/auth/domain/usecases/get_current_usecase.dart';
import 'package:cineghar/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:cineghar/features/auth/domain/usecases/upload_profile_image_usecase.dart';
import 'package:cineghar/features/auth/presentation/providers/auth_state.dart';
import 'package:cineghar/features/auth/presentation/viewmodel/auth_viewmodel.dart';
import 'package:cineghar/features/auth/presentation/providers/auth_providers.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterUsecase extends Mock implements RegisterUsecase {}
class MockLoginUsecase extends Mock implements LoginUsecase {}
class MockLogoutUsecase extends Mock implements LogoutUsecase {}
class MockGetCurrentUsecase extends Mock implements GetCurrentUsecase {}
class MockGetProfileUsecase extends Mock implements GetProfileUsecase {}
class MockUploadProfileImageUsecase extends Mock implements UploadProfileImageUsecase {}

void main() {
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLoginUsecase mockLoginUsecase;
  late MockLogoutUsecase mockLogoutUsecase;
  late MockGetCurrentUsecase mockGetCurrentUsecase;
  late MockGetProfileUsecase mockGetProfileUsecase;
  late MockUploadProfileImageUsecase mockUploadProfileImageUsecase;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(
      const RegisterUsecaseParams(
        fullName: 'fallback',
        email: 'fallback@email.com',
        username: 'fallback',
        password: 'fallback',
      ),
    );
    registerFallbackValue(
      const LoginUsecaseParams(email: 'fallback@email.com', password: 'fallback'),
    );
  });

  setUp(() {
    mockRegisterUsecase = MockRegisterUsecase();
    mockLoginUsecase = MockLoginUsecase();
    mockLogoutUsecase = MockLogoutUsecase();
    mockGetCurrentUsecase = MockGetCurrentUsecase();
    mockGetProfileUsecase = MockGetProfileUsecase();
    mockUploadProfileImageUsecase = MockUploadProfileImageUsecase();

    container = ProviderContainer(
      overrides: [
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
        logoutUsecaseProvider.overrideWithValue(mockLogoutUsecase),
        getCurrentUsecaseProvider.overrideWithValue(mockGetCurrentUsecase),
        getProfileUsecaseProvider.overrideWithValue(mockGetProfileUsecase),
        uploadProfileImageUsecaseProvider.overrideWithValue(mockUploadProfileImageUsecase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  const tUser = AuthEntity(
    authId: '1',
    fullName: 'Test User',
    email: 'test@example.com',
    username: 'testuser',
  );

  group('AuthViewmodel', () {
    group('initial state', () {
      test('should have initial state when created', () {
        final state = container.read(authViewModelProvider);
        expect(state.status, AuthStatus.initial);
        expect(state.user, isNull);
        expect(state.errorMessage, isNull);
      });
    });

    group('register', () {
      test('should emit registered state when registration is successful', () async {
        when(() => mockRegisterUsecase(any())).thenAnswer((_) async => const Right(true));
        final viewModel = container.read(authViewModelProvider.notifier);
        await viewModel.register(
          firstName: 'Test',
          lastName: 'User',
          email: 'test@example.com',
          phone: '1234567890',
          password: 'password123',
        );
        final state = container.read(authViewModelProvider);
        expect(state.status, AuthStatus.registered);
        verify(() => mockRegisterUsecase(any())).called(1);
      });
    });

    group('login', () {
      test('should emit authenticated state with user when login is successful', () async {
        when(() => mockLoginUsecase(any())).thenAnswer((_) async => const Right(tUser));
        final viewModel = container.read(authViewModelProvider.notifier);
        await viewModel.login(email: 'test@example.com', password: 'password');
        final state = container.read(authViewModelProvider);
        expect(state.status, AuthStatus.authenticated);
        expect(state.user, tUser);
        verify(() => mockLoginUsecase(any())).called(1);
      });
    });
  });

  group('AuthState', () {
    test('should have correct initial values', () {
      const state = AuthState();
      expect(state.status, AuthStatus.initial);
      expect(state.user, isNull);
      expect(state.errorMessage, isNull);
    });

    test('copyWith should update specified fields', () {
      const state = AuthState();
      final newState = state.copyWith(status: AuthStatus.authenticated, user: tUser);
      expect(newState.status, AuthStatus.authenticated);
      expect(newState.user, tUser);
      expect(newState.errorMessage, isNull);
    });
  });
}
