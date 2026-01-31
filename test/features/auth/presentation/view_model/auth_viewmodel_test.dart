import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/features/auth/domain/entities/auth_entity.dart';
import 'package:cineghar/features/auth/domain/usecases/login_usecase.dart';
import 'package:cineghar/features/auth/domain/usecases/register_usecase.dart';
import 'package:cineghar/features/auth/presentation/state/auth_state.dart';
import 'package:cineghar/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

void main() {
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLoginUsecase mockLoginUsecase;
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

    container = ProviderContainer(
      overrides: [
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
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
        // Act
        final state = container.read(authViewmodelProvider);

        // Assert
        expect(state.status, AuthStatus.initial);
        expect(state.authEntity, isNull);
        expect(state.errorMessage, isNull);
      });
    });

    group('register', () {
      test(
        'should emit registered state when registration is successful',
        () async {
          // Arrange
          when(
            () => mockRegisterUsecase(any()),
          ).thenAnswer((_) async => const Right(true));

          final viewModel = container.read(authViewmodelProvider.notifier);

          // Act
          await viewModel.register(
            fullName: 'Test User',
            email: 'test@example.com',
            username: 'testuser',
            password: 'password123',
          );

          // Assert
          final state = container.read(authViewmodelProvider);
          expect(state.status, AuthStatus.registered);
          verify(() => mockRegisterUsecase(any())).called(1);
        },
      );

      test('should emit error state when registration fails', () async {
        // Arrange
        const failure = ApiFailure(message: 'Email already exists');
        when(
          () => mockRegisterUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(authViewmodelProvider.notifier);

        // Act
        await viewModel.register(
          fullName: 'Test User',
          email: 'test@example.com',
          username: 'testuser',
          password: 'password123',
        );

        // Assert
        final state = container.read(authViewmodelProvider);
        expect(state.status, AuthStatus.error);
        expect(state.errorMessage, 'Email already exists');
        verify(() => mockRegisterUsecase(any())).called(1);
      });

      test('should pass optional parameters correctly', () async {
        // Arrange
        RegisterUsecaseParams? capturedParams;
        when(() => mockRegisterUsecase(any())).thenAnswer((invocation) {
          capturedParams =
              invocation.positionalArguments[0] as RegisterUsecaseParams;
          return Future.value(const Right(true));
        });

        final viewModel = container.read(authViewmodelProvider.notifier);

        // Act
        await viewModel.register(
          fullName: 'Test User',
          email: 'test@example.com',
          username: 'testuser',
          password: 'password123',
          phoneNumber: '1234567890',
        );

        // Assert
        expect(capturedParams?.phoneNumber, '1234567890');
      });
    });

    group('login', () {
      test(
        'should emit authenticated state with user when login is successful',
        () async {
          // Arrange
          when(
            () => mockLoginUsecase(any()),
          ).thenAnswer((_) async => const Right(tUser));

          final viewModel = container.read(authViewmodelProvider.notifier);

          // Act
          await viewModel.login(
            email: 'test@example.com',
            password: 'password',
          );

          // Assert
          final state = container.read(authViewmodelProvider);
          expect(state.status, AuthStatus.authenticated);
          expect(state.authEntity, tUser);
          verify(() => mockLoginUsecase(any())).called(1);
        },
      );

      test('should emit error state when login fails', () async {
        // Arrange
        const failure = ApiFailure(message: 'Invalid credentials');
        when(
          () => mockLoginUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(authViewmodelProvider.notifier);

        // Act
        await viewModel.login(email: 'test@example.com', password: 'password');

        // Assert
        final state = container.read(authViewmodelProvider);
        expect(state.status, AuthStatus.error);
        expect(state.errorMessage, 'Invalid credentials');
        verify(() => mockLoginUsecase(any())).called(1);
      });

      test('should pass correct credentials to usecase', () async {
        // Arrange
        LoginUsecaseParams? capturedParams;
        when(() => mockLoginUsecase(any())).thenAnswer((invocation) {
          capturedParams =
              invocation.positionalArguments[0] as LoginUsecaseParams;
          return Future.value(const Right(tUser));
        });

        final viewModel = container.read(authViewmodelProvider.notifier);

        // Act
        await viewModel.login(
          email: 'test@example.com',
          password: 'password123',
        );

        // Assert
        expect(capturedParams?.email, 'test@example.com');
        expect(capturedParams?.password, 'password123');
      });
    });
  });

  group('AuthState', () {
    test('should have correct initial values', () {
      const state = AuthState();
      expect(state.status, AuthStatus.initial);
      expect(state.authEntity, isNull);
      expect(state.errorMessage, isNull);
    });

    test('copyWith should update specified fields', () {
      const state = AuthState();
      final newState = state.copyWith(
        status: AuthStatus.authenticated,
        authEntity: tUser,
      );
      expect(newState.status, AuthStatus.authenticated);
      expect(newState.authEntity, tUser);
      expect(newState.errorMessage, isNull);
    });

    test('copyWith should preserve existing values when not specified', () {
      const state = AuthState(
        status: AuthStatus.authenticated,
        authEntity: tUser,
        errorMessage: 'error',
      );
      final newState = state.copyWith(status: AuthStatus.loading);
      expect(newState.status, AuthStatus.loading);
      expect(newState.authEntity, tUser);
      expect(newState.errorMessage, 'error');
    });

    test('props should contain all fields', () {
      const state = AuthState(
        status: AuthStatus.authenticated,
        authEntity: tUser,
        errorMessage: 'error',
      );
      expect(state.props, [AuthStatus.authenticated, 'error', tUser]);
    });

    test('two states with same values should be equal', () {
      const state1 = AuthState(status: AuthStatus.authenticated, authEntity: tUser);
      const state2 = AuthState(status: AuthStatus.authenticated, authEntity: tUser);
      expect(state1, state2);
    });
  });
}
