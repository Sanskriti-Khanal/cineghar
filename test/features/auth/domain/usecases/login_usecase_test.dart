import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/features/auth/domain/entities/auth_entity.dart';
import 'package:cineghar/features/auth/domain/repositories/auth_repository.dart';
import 'package:cineghar/features/auth/domain/usecases/login_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_auth_repository.dart';

void main() {
  late LoginUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = LoginUsecase(authRepository: mockRepository);
  });

  const tEmail = 'test@example.com';
  const tPassword = 'password123';
  const tParams = LoginUsecaseParams(email: tEmail, password: tPassword);

  test('should return AuthEntity when login succeeds', () async {
    when(() => mockRepository.login(any(), any()))
        .thenAnswer((_) async => Right(testAuthEntity));

    final result = await usecase.call(tParams);

    expect(result, Right(testAuthEntity));
    verify(() => mockRepository.login(tEmail, tPassword)).called(1);
  });

  test('should return Failure when login fails', () async {
    when(() => mockRepository.login(any(), any()))
        .thenAnswer((_) async => const Left(LocalDatabaseFailure(message: 'Invalid credentials')));

    final result = await usecase.call(tParams);

    expect(result.isLeft(), true);
    verify(() => mockRepository.login(tEmail, tPassword)).called(1);
  });
}
