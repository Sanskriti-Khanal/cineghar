import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/features/auth/domain/entities/auth_entity.dart';
import 'package:cineghar/features/auth/domain/repositories/auth_repository.dart';
import 'package:cineghar/features/auth/domain/usecases/get_current_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_auth_repository.dart';

void main() {
  late GetCurrentUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = GetCurrentUsecase(authRepository: mockRepository);
  });

  test('should return AuthEntity when getCurrentUser succeeds', () async {
    when(() => mockRepository.getCurrentUser())
        .thenAnswer((_) async => Right(testAuthEntity));

    final result = await usecase.call();

    expect(result, Right(testAuthEntity));
    verify(() => mockRepository.getCurrentUser()).called(1);
  });

  test('should return Failure when no user is logged in', () async {
    when(() => mockRepository.getCurrentUser()).thenAnswer((_) async =>
        const Left(LocalDatabaseFailure(message: 'No user logged in')));

    final result = await usecase.call();

    expect(result.isLeft(), true);
    verify(() => mockRepository.getCurrentUser()).called(1);
  });
}
