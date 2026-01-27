import 'package:flutter_test/flutter_test.dart';
import 'package:cineghar/core/api/api_endpoints.dart';

void main() {
  group('ApiEndpoints', () {
    test('whoami endpoint is correct', () {
      expect(ApiEndpoints.whoami, '/auth/whoami');
    });

    test('updateProfile endpoint is correct', () {
      expect(ApiEndpoints.updateProfile, '/auth/update-profile');
    });

    test('userById builds path with id', () {
      expect(ApiEndpoints.userById('abc123'), '/auth/abc123');
    });

    test('hostBaseUrl is non-empty', () {
      expect(ApiEndpoints.hostBaseUrl, isNotEmpty);
      expect(ApiEndpoints.hostBaseUrl, contains('5050'));
    });
  });
}
