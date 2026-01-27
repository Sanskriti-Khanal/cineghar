import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/features/auth/domain/entities/auth_entity.dart';
import 'package:cineghar/features/auth/domain/repositories/auth_repository.dart';
import 'package:cineghar/features/auth/domain/usecases/get_profile_usecase.dart';

void main() {
  late GetProfileUsecase useCase;
  late FakeAuthRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeAuthRepository();
    useCase = GetProfileUsecase(authRepository: fakeRepository);
  });

  test('should return AuthEntity when getProfile succeeds', () async {
    const entity = AuthEntity(
      authId: '1',
      fullName: 'Test User',
      email: 'test@test.com',
      username: 'test',
      profilePicture: '/uploads/photo.jpg',
    );
    fakeRepository.getProfileResult = Right(entity);

    final result = await useCase();

    expect(result, Right(entity));
  });

  test('should return Failure when getProfile fails', () async {
    fakeRepository.getProfileResult =
        const Left(ApiFailure(message: 'Failed to load profile'));

    final result = await useCase();

    expect(result.isLeft(), true);
    result.fold(
      (f) => expect(f.message, 'Failed to load profile'),
      (_) => fail('expected Left'),
    );
  });
}

class FakeAuthRepository implements IAuthRepository {
  Either<Failure, AuthEntity>? getProfileResult;

  @override
  Future<Either<Failure, AuthEntity>> getProfile() async {
    return getProfileResult ?? const Left(ApiFailure(message: 'not set'));
  }

  @override
  Future<Either<Failure, bool>> register(entity) async =>
      const Right(true);

  @override
  Future<Either<Failure, AuthEntity>> login(email, password) async =>
      const Right(AuthEntity(fullName: '', email: '', username: ''));

  @override
  Future<Either<Failure, AuthEntity>> getCurrentUser() async =>
      const Left(LocalDatabaseFailure(message: 'none'));

  @override
  Future<Either<Failure, AuthEntity>> uploadProfileImage(file) async =>
      const Left(ApiFailure(message: 'not set'));

  @override
  Future<Either<Failure, bool>> logout() async => const Right(true);
}
