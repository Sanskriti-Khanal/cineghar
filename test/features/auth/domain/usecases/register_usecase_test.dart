import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/features/auth/domain/entities/auth_entity.dart';
import 'package:cineghar/features/auth/domain/repositories/auth_repository.dart';
import 'package:cineghar/features/auth/domain/usecases/register_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_auth_repository.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(testAuthEntity);
  });

  late RegisterUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = RegisterUsecase(authRepository: mockRepository);
  });

  const tParams = RegisterUsecaseParams(
    fullName: 'Test User',
    email: 'test@example.com',
    username: 'testuser',
    password: 'password123',
  );

  test('should return true when register succeeds', () async {
    when(() => mockRepository.register(any())).thenAnswer((_) async => const Right(true));

    final result = await usecase.call(tParams);

    expect(result, const Right(true));
    verify(() => mockRepository.register(any())).called(1);
  });

  test('should return Failure when register fails', () async {
    when(() => mockRepository.register(any())).thenAnswer((_) async =>
        const Left(LocalDatabaseFailure(message: 'Email already exists')));

    final result = await usecase.call(tParams);

    expect(result.isLeft(), true);
    verify(() => mockRepository.register(any())).called(1);
  });
}
