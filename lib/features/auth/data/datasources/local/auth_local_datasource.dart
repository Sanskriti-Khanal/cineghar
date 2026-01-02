import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cineghar/core/services/hive/hive_service.dart';
import 'package:cineghar/features/auth/data/datasources/auth_datasource.dart';
import 'package:cineghar/features/auth/data/models/auth_hive_model.dart';

// Provider
final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return AuthLocalDatasource(hiveService: hiveService);
});

class AuthLocalDatasource implements IAuthDatasource {
  final HiveService _hiveService;

  AuthLocalDatasource({required HiveService hiveService})
      : _hiveService = hiveService;

  @override
  Future<AuthHiveModel?> getCurrentUser() async {
    // TODO: Implement getCurrentUser with session management
    return null;
  }

  @override
  Future<AuthHiveModel?> login(String email, String password) async {
    try {
      final user = await _hiveService.loginUser(email, password);
      return user;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await _hiveService.logoutUser();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> register(AuthHiveModel model) async {
    try {
      // Check if email already exists
      if (_hiveService.isEmailExists(model.email)) {
        return false;
      }
      await _hiveService.registerUser(model);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> isEmailExists(String email) async {
    try {
      final exists = _hiveService.isEmailExists(email);
      return exists;
    } catch (e) {
      return false;
    }
  }
}

