import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/features/auth/domain/entities/auth_entity.dart';
import 'package:cineghar/features/auth/domain/repositories/auth_repository.dart';
import 'package:cineghar/features/auth/domain/usecases/upload_profile_image_usecase.dart';

void main() {
  late UploadProfileImageUsecase useCase;
  late FakeUploadAuthRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeUploadAuthRepository();
    useCase = UploadProfileImageUsecase(authRepository: fakeRepository);
  });

  test('should return AuthEntity when uploadProfileImage succeeds', () async {
    const entity = AuthEntity(
      authId: '1',
      fullName: 'Test User',
      email: 'test@test.com',
      username: 'test',
      profilePicture: '/uploads/new-photo.jpg',
    );
    fakeRepository.uploadResult = Right(entity);

    final result = await useCase('fake_file');

    expect(result, Right(entity));
  });

  test('should return Failure when uploadProfileImage fails', () async {
    fakeRepository.uploadResult =
        const Left(ApiFailure(message: 'Failed to upload image'));

    final result = await useCase('fake_file');

    expect(result.isLeft(), true);
    result.fold(
      (f) => expect(f.message, 'Failed to upload image'),
      (_) => fail('expected Left'),
    );
  });
}

class FakeUploadAuthRepository implements IAuthRepository {
  Either<Failure, AuthEntity>? uploadResult;

  @override
  Future<Either<Failure, AuthEntity>> uploadProfileImage(file) async {
    return uploadResult ?? const Left(ApiFailure(message: 'not set'));
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
  Future<Either<Failure, AuthEntity>> getProfile() async =>
      const Left(ApiFailure(message: 'not set'));

  @override
  Future<Either<Failure, bool>> logout() async => const Right(true);
}
