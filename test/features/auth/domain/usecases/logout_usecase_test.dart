import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/features/auth/domain/repositories/auth_repository.dart';
import 'package:cineghar/features/auth/domain/usecases/logout_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/mock_auth_repository.dart';

void main() {
  late LogoutUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = LogoutUsecase(authRepository: mockRepository);
  });

  test('should return true when logout succeeds', () async {
    when(() => mockRepository.logout()).thenAnswer((_) async => const Right(true));

    final result = await usecase.call();

    expect(result, const Right(true));
    verify(() => mockRepository.logout()).called(1);
  });

  test('should return Failure when logout fails', () async {
    when(() => mockRepository.logout()).thenAnswer((_) async =>
        const Left(LocalDatabaseFailure(message: 'Logout failed')));

    final result = await usecase.call();

    expect(result.isLeft(), true);
    verify(() => mockRepository.logout()).called(1);
  });
}
