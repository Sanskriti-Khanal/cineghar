import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cineghar/core/error/failures.dart';
import 'package:cineghar/features/auth/domain/entities/auth_entity.dart';
import 'package:cineghar/features/auth/domain/usecases/login_usecase.dart';
import 'package:cineghar/features/auth/domain/usecases/register_usecase.dart';
import 'package:cineghar/features/auth/presentation/pages/login_page.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterUsecase extends Mock implements RegisterUsecase {}

class MockLoginUsecase extends Mock implements LoginUsecase {}

void main() {
  late MockRegisterUsecase mockRegisterUsecase;
  late MockLoginUsecase mockLoginUsecase;

  setUpAll(() {
    registerFallbackValue(
      const RegisterUsecaseParams(
        fullName: 'fallback',
        email: 'fallback@email.com',
        username: 'fallback',
        password: 'fallback',
      ),
    );
    registerFallbackValue(
      const LoginUsecaseParams(
        email: 'fallback@email.com',
        password: 'fallback',
      ),
    );
  });

  setUp(() {
    mockRegisterUsecase = MockRegisterUsecase();
    mockLoginUsecase = MockLoginUsecase();
  });

  Widget createTestWidget() {
    return ProviderScope(
      overrides: [
        registerUsecaseProvider.overrideWithValue(mockRegisterUsecase),
        loginUsecaseProvider.overrideWithValue(mockLoginUsecase),
      ],
      child: const MaterialApp(home: LoginPage()),
    );
  }

  group('LoginPage UI Elements', () {
    testWidgets('should display login title', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('should display signup link text', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text("Don't have an account? "), findsOneWidget);
      expect(find.text('Sign Up'), findsOneWidget);
    });

    testWidgets('should display email and password labels', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('should display log in button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Log In'), findsOneWidget);
    });

    testWidgets('should display two text form fields', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('should display remember me and forgot password', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Remember me'), findsOneWidget);
      expect(find.text('Forgot Password?'), findsOneWidget);
    });

    testWidgets('should display Or divider', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Or'), findsOneWidget);
    });

    testWidgets('should toggle password visibility', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.byIcon(Icons.visibility), findsOneWidget);
      await tester.tap(find.byIcon(Icons.visibility));
      await tester.pump();
      expect(find.byIcon(Icons.visibility_off), findsOneWidget);
    });
  });

  group('LoginPage Form Validation', () {
    testWidgets('should show error for empty email', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.enterText(find.byType(TextFormField).first, '');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Log In'));
      await tester.pump();
      expect(find.text('Please enter Email'), findsOneWidget);
    });

    testWidgets('should show error for invalid email', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.enterText(find.byType(TextFormField).first, 'invalidemail');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Log In'));
      await tester.pump();
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should show error for empty password', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      await tester.tap(find.text('Log In'));
      await tester.pump();
      expect(find.text('Please enter password'), findsOneWidget);
    });

    testWidgets('should show error for short password', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      await tester.enterText(find.byType(TextFormField).last, '12345');
      await tester.tap(find.text('Log In'));
      await tester.pump();
      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });

    testWidgets('should allow text entry in email field', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      await tester.pump();
      expect(find.text('test@example.com'), findsOneWidget);
    });
  });

  group('LoginPage Form Submission', () {
    testWidgets('should call login usecase when form is valid', (tester) async {
      final completer = Completer<Either<Failure, AuthEntity>>();
      when(() => mockLoginUsecase(any())).thenAnswer((_) => completer.future);

      await tester.pumpWidget(createTestWidget());
      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Log In'));
      await tester.pump();

      verify(() => mockLoginUsecase(any())).called(1);
    });

    testWidgets('should call login with correct email and password',
        (tester) async {
      final completer = Completer<Either<Failure, AuthEntity>>();
      LoginUsecaseParams? capturedParams;
      when(() => mockLoginUsecase(any())).thenAnswer((invocation) {
        capturedParams =
            invocation.positionalArguments[0] as LoginUsecaseParams;
        return completer.future;
      });

      await tester.pumpWidget(createTestWidget());
      await tester.enterText(find.byType(TextFormField).first, 'user@test.com');
      await tester.enterText(find.byType(TextFormField).last, 'mypassword');
      await tester.tap(find.text('Log In'));
      await tester.pump();

      expect(capturedParams?.email, 'user@test.com');
      expect(capturedParams?.password, 'mypassword');
    });

    testWidgets('should not call login usecase when form is invalid',
        (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      await tester.tap(find.text('Log In'));
      await tester.pump();

      verifyNever(() => mockLoginUsecase(any()));
    });

    testWidgets('should show loading indicator while logging in', (tester) async {
      final completer = Completer<Either<Failure, AuthEntity>>();
      when(() => mockLoginUsecase(any())).thenAnswer((_) => completer.future);

      await tester.pumpWidget(createTestWidget());
      await tester.enterText(
        find.byType(TextFormField).first,
        'test@example.com',
      );
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      await tester.tap(find.text('Log In'));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
