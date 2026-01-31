import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/features/auth/domain/entities/auth_entity.dart';
import 'package:cineghar/features/auth/domain/repositories/auth_repository.dart';
import 'package:cineghar/features/auth/domain/usecases/register_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late RegisterUsecase usecase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    usecase = RegisterUsecase(authRepository: mockRepository);
  });

  setUpAll(() {
    registerFallbackValue(
      const AuthEntity(
        fullName: 'fallback',
        email: 'fallback@email.com',
        username: 'fallback',
      ),
    );
  });

  const tFullName = 'Test User';
  const tEmail = 'test@example.com';
  const tUsername = 'testuser';
  const tPassword = 'password123';
  const tPhoneNumber = '1234567890';

  group('RegisterUsecase', () {
    test('should return true when registration is successful', () async {
      // Arrange
      when(
        () => mockRepository.register(any()),
      ).thenAnswer((_) async => const Right(true));

      // Act
      final result = await usecase(
        const RegisterUsecaseParams(
          fullName: tFullName,
          email: tEmail,
          username: tUsername,
          password: tPassword,
        ),
      );

      // Assert
      expect(result, const Right(true));
      verify(() => mockRepository.register(any())).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass AuthEntity with correct values to repository', () async {
      // Arrange
      AuthEntity? capturedEntity;
      when(() => mockRepository.register(any())).thenAnswer((invocation) {
        capturedEntity = invocation.positionalArguments[0] as AuthEntity;
        return Future.value(const Right(true));
      });

      // Act
      await usecase(
        const RegisterUsecaseParams(
          fullName: tFullName,
          email: tEmail,
          username: tUsername,
          password: tPassword,
          phoneNumber: tPhoneNumber,
        ),
      );

      // Assert
      expect(capturedEntity?.fullName, tFullName);
      expect(capturedEntity?.email, tEmail);
      expect(capturedEntity?.username, tUsername);
      expect(capturedEntity?.password, tPassword);
      expect(capturedEntity?.phoneNumber, tPhoneNumber);
    });

    test('should handle optional parameters correctly', () async {
      // Arrange
      AuthEntity? capturedEntity;
      when(() => mockRepository.register(any())).thenAnswer((invocation) {
        capturedEntity = invocation.positionalArguments[0] as AuthEntity;
        return Future.value(const Right(true));
      });

      // Act
      await usecase(
        const RegisterUsecaseParams(
          fullName: tFullName,
          email: tEmail,
          username: tUsername,
          password: tPassword,
        ),
      );

      // Assert
      expect(capturedEntity?.phoneNumber, isNull);
    });

    test('should return failure when registration fails', () async {
      // Arrange
      const failure = ApiFailure(message: 'Email already exists');
      when(
        () => mockRepository.register(any()),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        const RegisterUsecaseParams(
          fullName: tFullName,
          email: tEmail,
          username: tUsername,
          password: tPassword,
        ),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.register(any())).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure when there is no internet', () async {
      // Arrange
      const failure = NetworkFailure();
      when(
        () => mockRepository.register(any()),
      ).thenAnswer((_) async => const Left(failure));

      // Act
      final result = await usecase(
        const RegisterUsecaseParams(
          fullName: tFullName,
          email: tEmail,
          username: tUsername,
          password: tPassword,
        ),
      );

      // Assert
      expect(result, const Left(failure));
      verify(() => mockRepository.register(any())).called(1);
    });
  });

  group('RegisterUsecaseParams', () {
    test('should have correct props with all values', () {
      const params = RegisterUsecaseParams(
        fullName: tFullName,
        email: tEmail,
        username: tUsername,
        password: tPassword,
        phoneNumber: tPhoneNumber,
      );
      expect(params.props, [
        tFullName,
        tEmail,
        tPhoneNumber,
        tUsername,
        tPassword,
      ]);
    });

    test('should have correct props with optional values as null', () {
      const params = RegisterUsecaseParams(
        fullName: tFullName,
        email: tEmail,
        username: tUsername,
        password: tPassword,
      );
      expect(params.props, [
        tFullName,
        tEmail,
        null,
        tUsername,
        tPassword,
      ]);
    });

    test('two params with same values should be equal', () {
      const params1 = RegisterUsecaseParams(
        fullName: tFullName,
        email: tEmail,
        username: tUsername,
        password: tPassword,
      );
      const params2 = RegisterUsecaseParams(
        fullName: tFullName,
        email: tEmail,
        username: tUsername,
        password: tPassword,
      );
      expect(params1, params2);
    });
  });
}
