import 'dart:io';

class ApiEndpoints {
  ApiEndpoints._();

  // Base URL - automatically detects platform
  // For Android Emulator: 'http://10.0.2.2:5050/api'
  // For iOS Simulator: 'http://localhost:5050/api'
  // For Physical Device: Use your computer's IP: 'http://192.168.x.x:5050/api'
  static String get baseUrl {
    if (Platform.isIOS) {
      // iOS Simulator can access localhost directly
      return 'http://localhost:5050/api';
    } else if (Platform.isAndroid) {
      // Android Emulator uses special IP to access host machine
      return 'http://10.0.2.2:5050/api';
    } else {
      // Default for other platforms (web, desktop, etc.)
      return 'http://localhost:5050/api';
    }
  }

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // ============ Auth Endpoints ============
  static const String auth = '/auth';
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String whoami = '/auth/whoami';
  static const String updateProfile = '/auth/update-profile';
  static String userById(String id) => '/auth/$id';
  static const String users = '/auth';

  /// Base URL without /api for serving uploads (e.g. profile images). Used to build full image URLs.
  static String get hostBaseUrl {
    if (Platform.isIOS) {
      return 'http://localhost:5050';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:5050';
    } else {
      return 'http://localhost:5050';
    }
  }
}
