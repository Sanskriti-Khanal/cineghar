import 'package:cineghar/features/auth/domain/entities/auth_entity.dart';
import 'package:cineghar/features/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

AuthEntity get testAuthEntity => const AuthEntity(
      authId: '1',
      fullName: 'Test User',
      email: 'test@example.com',
      username: 'testuser',
    );

Failure get testFailure => const LocalDatabaseFailure(message: 'Test failure');
