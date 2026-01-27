import 'package:flutter_test/flutter_test.dart';
import 'package:cineghar/features/auth/domain/entities/auth_entity.dart';

void main() {
  group('AuthEntity', () {
    test('props include profilePicture', () {
      const entity = AuthEntity(
        fullName: 'Test',
        email: 'test@test.com',
        username: 'test',
        profilePicture: '/uploads/img.jpg',
      );
      expect(entity.props, contains('/uploads/img.jpg'));
    });

    test('equality uses profilePicture', () {
      const a = AuthEntity(
        fullName: 'A',
        email: 'a@a.com',
        username: 'a',
        profilePicture: '/uploads/1.jpg',
      );
      const b = AuthEntity(
        fullName: 'A',
        email: 'a@a.com',
        username: 'a',
        profilePicture: '/uploads/2.jpg',
      );
      expect(a, isNot(equals(b)));
    });
  });
}
