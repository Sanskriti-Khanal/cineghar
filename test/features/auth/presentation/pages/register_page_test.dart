import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cineghar/features/auth/domain/usecases/login_usecase.dart';
import 'package:cineghar/features/auth/domain/usecases/register_usecase.dart';
import 'package:cineghar/features/auth/presentation/pages/register_page.dart';
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
      child: const MaterialApp(home: RegisterPage()),
    );
  }

  group('RegisterPage UI Elements', () {
    testWidgets('should display register title', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Register'), findsAtLeastNWidgets(1));
    });

    testWidgets('should display create account subtitle', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Create an account to continue!'), findsOneWidget);
    });

    testWidgets('should display first name and last name fields', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Last Name'), findsOneWidget);
    });

    testWidgets('should display email and password labels', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('should display register button', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Register'), findsAtLeastNWidgets(1));
    });

    testWidgets('should display login link text', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Already have an account? '), findsOneWidget);
      expect(find.text('Log in'), findsOneWidget);
    });

    testWidgets('should display multiple text form fields', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.byType(TextFormField), findsWidgets);
    });
  });

  group('RegisterPage Form Validation', () {
    testWidgets('should show error for empty first name', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.enterText(find.byType(TextFormField).at(0), '');
      await tester.enterText(find.byType(TextFormField).at(1), 'Becket');
      await tester.enterText(find.byType(TextFormField).at(2), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(4), 'password123');
      await tester.ensureVisible(find.text('Register').at(1));
      await tester.tap(find.text('Register').at(1));
      await tester.pump();
      expect(find.text('Please enter First Name'), findsOneWidget);
    });

    testWidgets('should show error for invalid email', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.enterText(find.byType(TextFormField).at(0), 'Lois');
      await tester.enterText(find.byType(TextFormField).at(1), 'Becket');
      await tester.enterText(find.byType(TextFormField).at(2), 'invalidemail');
      await tester.enterText(find.byType(TextFormField).at(4), 'password123');
      await tester.ensureVisible(find.text('Register').at(1));
      await tester.tap(find.text('Register').at(1));
      await tester.pump();
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });

    testWidgets('should show error for short password', (tester) async {
      await tester.pumpWidget(createTestWidget());
      await tester.enterText(find.byType(TextFormField).at(0), 'Lois');
      await tester.enterText(find.byType(TextFormField).at(1), 'Becket');
      await tester.enterText(find.byType(TextFormField).at(2), 'test@example.com');
      await tester.enterText(find.byType(TextFormField).at(4), '12345');
      await tester.ensureVisible(find.text('Register').at(1));
      await tester.tap(find.text('Register').at(1));
      await tester.pump();
      expect(
        find.text('Password must be at least 6 characters'),
        findsOneWidget,
      );
    });
  });

  group('RegisterPage loads', () {
    testWidgets('RegisterPage widget is displayed', (tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.byType(RegisterPage), findsOneWidget);
    });
  });
}
