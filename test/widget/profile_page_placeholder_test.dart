import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/features/auth/domain/entities/auth_entity.dart';
import 'package:cineghar/features/auth/domain/repositories/auth_repository.dart';
import 'package:cineghar/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:cineghar/features/auth/domain/usecases/upload_profile_image_usecase.dart';
import 'package:cineghar/features/dashboard/presentation/pages/profile_page.dart';

void main() {
  testWidgets('ProfilePage shows placeholder when no profile image', (tester) async {
    final fakeRepo = _FakeAuthRepository()
      ..getProfileResult = const Right(AuthEntity(
        fullName: 'User',
        email: 'user@test.com',
        username: 'user',
        profilePicture: null,
      ));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          getProfileUsecaseProvider.overrideWith(
            (ref) => GetProfileUsecase(authRepository: fakeRepo),
          ),
          uploadProfileImageUsecaseProvider.overrideWith(
            (ref) => UploadProfileImageUsecase(authRepository: fakeRepo),
          ),
        ],
        child: MaterialApp(
          home: const ProfilePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.person), findsOneWidget);
  });
}

class _FakeAuthRepository implements IAuthRepository {
  Either<Failure, AuthEntity>? getProfileResult;

  @override
  Future<Either<Failure, AuthEntity>> getProfile() async {
    return getProfileResult ?? const Left(ApiFailure(message: 'fail'));
  }

  @override
  Future<Either<Failure, bool>> register(entity) async => const Right(true);

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
