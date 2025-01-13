import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final userSessionServiceProvider = Provider<UserSessionService>((ref) {
  return UserSessionService(prefs: ref.read(sharedPreferencesProvider));
});

class UserSessionService {
  final SharedPreferences _prefs;

  UserSessionService({required SharedPreferences prefs}) : _prefs = prefs;

  //keys for data storage
  static const String _keyIsLoggedIn = "is_logged_in";
  static const String _keyUserId = "user_id";
  static const String _keyUserEmail = "user_email";
  static const String _keyUserName = "user_name";
  static const String _keyUserDateOfBirth = "user_date_of_birth";
  static const String _keyUserRole = "user_role";

  // store user session
  Future<void> saveUserSession({
    required String userId,
    required String email,
    required String name,
    String? dateOfBirth,
    String? role,
  }) async {
    await _prefs.setBool(_keyIsLoggedIn, true);
    await _prefs.setString(_keyUserId, userId);
    await _prefs.setString(_keyUserEmail, email);
    await _prefs.setString(_keyUserName, name);

    if (dateOfBirth != null) {
      await _prefs.setString(_keyUserDateOfBirth, dateOfBirth);
    }
    if (role != null) {
      await _prefs.setString(_keyUserRole, role);
    }
  }

  // clear session
  Future<void> clearSession() async {
    await _prefs.remove(_keyIsLoggedIn);
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyUserEmail);
    await _prefs.remove(_keyUserName);
    await _prefs.remove(_keyUserDateOfBirth);
    await _prefs.remove(_keyUserRole);
  }

  bool isLoggedIn() {
    return _prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  String? getUserId() {
    return _prefs.getString(_keyUserId);
  }

  String? getUserEmail() {
    return _prefs.getString(_keyUserEmail);
  }

  String? getUserName() {
    return _prefs.getString(_keyUserName);
  }

  String? getUserDateOfBirth() {
    return _prefs.getString(_keyUserDateOfBirth);
  }

  String? getUserRole() {
    return _prefs.getString(_keyUserRole);
  }
}
