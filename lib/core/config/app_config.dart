class AppConfig {
  AppConfig._();

  // Set this to true to use mock data, false to use real API
  static const bool useMockData = false;
  
  // API configuration
  // IMPORTANT: For physical device testing, REPLACE 'localhost' with your computer's local IP address
  // (e.g., 'http://192.168.1.XX:5050/api'). Both devices MUST be on the same Wi-Fi.
  static const String apiBaseUrl = 'http://192.168.1.69:5050/api';
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // App configuration
  static const String appName = 'CineGhar';
  static const String appVersion = '1.0.0';
}
