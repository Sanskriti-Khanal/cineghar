import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/features/auth/domain/entities/auth_entity.dart';
import 'package:cineghar/features/auth/domain/repositories/auth_repository.dart';
import 'package:cineghar/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_auth_repository.dart';

void main() {
  late GetProfileUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = GetProfileUsecase(authRepository: mockRepository);
  });

  test('should return AuthEntity when getProfile succeeds', () async {
    when(() => mockRepository.getProfile())
        .thenAnswer((_) async => Right(testAuthEntity));

    final result = await usecase.call();

    expect(result, Right(testAuthEntity));
    verify(() => mockRepository.getProfile()).called(1);
  });

  test('should return Failure when getProfile fails', () async {
    when(() => mockRepository.getProfile()).thenAnswer((_) async =>
        const Left(LocalDatabaseFailure(message: 'Profile not found')));

    final result = await usecase.call();

    expect(result.isLeft(), true);
    verify(() => mockRepository.getProfile()).called(1);
  });
}
