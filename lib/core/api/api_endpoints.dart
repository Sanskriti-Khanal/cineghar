import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  // Base URL - automatically detects platform
  // For Android Emulator: 'http://10.0.2.2:5050/api'
  // For iOS Simulator: 'http://localhost:5050/api'
  // For Physical Device: Use your computer's IP: 'http://192.168.x.x:5050/api'
  static String get baseUrl {
    // For Physical Device: Use your computer's IP address
    // For Android Emulator: Use '10.0.2.2'
    // For iOS Simulator: Use 'localhost'

    // Check if we are running on an emulator or physical device.
    // In actual production, you might want to use a more robust detection or environment variables.
    const String localIp =
        '192.168.1.69'; // Update this if your physical device IP changes

    if (kIsWeb) {
      return 'http://localhost:5050/api';
    }

    if (Platform.isAndroid) {
      // For physical Android device, we need the local IP.
      // If using an emulator, you can use 'http://10.0.2.2:5050/api'
      return 'http://$localIp:5050/api';
    } else if (Platform.isIOS) {
      return 'http://$localIp:5050/api';
    } else {
      return 'http://$localIp:5050/api';
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
  static const String forgotPassword = '/auth/forgot-password';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resetPassword = '/auth/reset-password';
  static String userById(String id) => '/auth/$id';
  static const String users = '/auth';

  // ============ Public Movies Endpoints ============
  // Matches CineGhar Web API (/api/movies, /api/movies/:id)
  static const String movies = '/movies';
  static String movieById(String id) => '/movies/$id';

  // ============ Booking / Rewards / Offers / Payment ============
  static const String offers = '/offers';
  static const String rewards = '/rewards';
  static const String cities = '/booking/cities';
  static const String halls = '/booking/halls';
  static const String showtimes = '/booking/showtimes';
  static const String seats =
      '/booking/showtimes'; // Seats endpoint uses showtimes base
  static const String holds = '/booking/holds';

  static const String loyaltyMe = '/loyalty/me';

  static const String orders = '/orders';
  static String orderById(String id) => '/orders/$id';

  static const String khaltiInitiate = '/payment/khalti/initiate';
  static const String khaltiLookup = '/payment/khalti/lookup';
  static const String paymentConfirm = '/payment/confirm';

  // Snacks endpoints
  static const String snackItems = '/snacks/items';
  static const String snackCombos = '/snacks/combos';

  /// Base URL without /api for serving uploads (e.g. profile images). Used to build full image URLs.
  static String get hostBaseUrl {
    const String localIp = '192.168.1.69';
    return 'http://$localIp:5050';
  }
}
