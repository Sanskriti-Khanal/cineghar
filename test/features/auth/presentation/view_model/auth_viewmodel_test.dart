import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/features/auth/domain/entities/auth_entity.dart';
import 'package:cineghar/features/auth/domain/usecases/login_usecase.dart';
import 'package:cineghar/features/auth/domain/usecases/register_usecase.dart';
import 'package:cineghar/features/auth/presentation/state/auth_state.dart';
import 'package:cineghar/features/auth/presentation/view_model/auth_viewmodel.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_auth_repository.dart';
import '../../../../helpers/mock_usecases.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(const LoginUsecaseParams(email: '', password: ''));
    registerFallbackValue(const RegisterUsecaseParams(
      fullName: '',
      email: '',
      username: '',
      password: '',
    ));
  });

  late MockLoginUsecase mockLoginUsecase;
  late MockRegisterUsecase mockRegisterUsecase;
  late ProviderContainer container;

  setUp(() {
    mockLoginUsecase = MockLoginUsecase();
    mockRegisterUsecase = MockRegisterUsecase();
    container = ProviderContainer(
      overrides: [
        loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('AuthViewmodel - login', () {
    test('sets authenticated state when login succeeds', () async {
      when(() => mockLoginUsecase.call(any()))
          .thenAnswer((_) async => Right(testAuthEntity));

      final notifier = container.read(authViewmodelProvider.notifier);
      await notifier.login(email: 'test@example.com', password: 'password123');

      final state = container.read(authViewmodelProvider);
      expect(state.status, AuthStatus.authenticated);
      expect(state.authEntity, testAuthEntity);
    });

    test('sets error state when login fails', () async {
      when(() => mockLoginUsecase.call(any())).thenAnswer((_) async =>
          const Left(LocalDatabaseFailure(message: 'Invalid credentials')));

      final notifier = container.read(authViewmodelProvider.notifier);
      await notifier.login(email: 'test@example.com', password: 'wrong');

      final state = container.read(authViewmodelProvider);
      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, 'Invalid credentials');
    });
  });

  group('AuthViewmodel - register', () {
    test('sets registered state when register succeeds', () async {
      when(() => mockRegisterUsecase.call(any()))
          .thenAnswer((_) async => const Right(true));

      final notifier = container.read(authViewmodelProvider.notifier);
      await notifier.register(
        fullName: 'Test User',
        email: 'test@example.com',
        username: 'testuser',
        password: 'password123',
      );

      final state = container.read(authViewmodelProvider);
      expect(state.status, AuthStatus.registered);
    });

    test('sets error state when register fails', () async {
      when(() => mockRegisterUsecase.call(any())).thenAnswer((_) async =>
          const Left(LocalDatabaseFailure(message: 'Email already exists')));

      final notifier = container.read(authViewmodelProvider.notifier);
      await notifier.register(
        fullName: 'Test User',
        email: 'test@example.com',
        username: 'testuser',
        password: 'password123',
      );

      final state = container.read(authViewmodelProvider);
      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, 'Email already exists');
    });
  });
}
