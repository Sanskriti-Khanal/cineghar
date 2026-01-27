import 'package:flutter_test/flutter_test.dart';
import 'package:cineghar/features/auth/data/models/auth_api_model.dart';

void main() {
  group('AuthApiModel', () {
    test('fromJson parses imageUrl correctly', () {
      final json = {
        '_id': '123',
        'name': 'John',
        'email': 'john@test.com',
        'imageUrl': '/uploads/avatar.jpg',
      };
      final model = AuthApiModel.fromJson(json);
      expect(model.imageUrl, '/uploads/avatar.jpg');
      expect(model.name, 'John');
      expect(model.email, 'john@test.com');
    });

    test('fromJson handles missing imageUrl', () {
      final json = {
        '_id': '123',
        'name': 'Jane',
        'email': 'jane@test.com',
      };
      final model = AuthApiModel.fromJson(json);
      expect(model.imageUrl, isNull);
    });

    test('toEntity maps imageUrl to profilePicture', () {
      final model = AuthApiModel(
        id: '1',
        name: 'User',
        email: 'user@test.com',
        imageUrl: '/uploads/photo.png',
      );
      final entity = model.toEntity();
      expect(entity.profilePicture, '/uploads/photo.png');
      expect(entity.fullName, 'User');
    });
  });
}
