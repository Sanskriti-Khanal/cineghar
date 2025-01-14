import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cineghar/core/api/api_client.dart';
import 'package:cineghar/core/api/api_endpoints.dart';
import 'package:cineghar/core/services/storage/user_session_service.dart';
import 'package:cineghar/features/auth/data/datasources/auth_datasource.dart';
import 'package:cineghar/features/auth/data/models/auth_api_model.dart';

// provider
final authRemoteDataSourceProvider = Provider<IAuthRemoteDataSource>((ref) {
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
  );
});

class AuthRemoteDatasource implements IAuthRemoteDataSource {
  final ApiClient _apiClient;
  final UserSessionService _userSessionService;
  final _storage = const FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';

  AuthRemoteDatasource({
    required ApiClient apiClient,
    required UserSessionService userSessionService,
  }) : _apiClient = apiClient,
       _userSessionService = userSessionService;

  @override
  Future<AuthApiModel?> getUserById(String authId) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }

  @override
  Future<AuthApiModel?> login(String email, String password) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.login,
        data: {"email": email, "password": password},
      );
      
      if (response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        final user = AuthApiModel.fromJson(data);
        
        // Store token if present
        if (response.data['token'] != null) {
          await _storage.write(key: _tokenKey, value: response.data['token']);
        }

        // Save user session
        await _userSessionService.saveUserSession(
          userId: user.id ?? '',
          email: user.email,
          name: user.name,
          dateOfBirth: user.dateOfBirth,
          role: user.role,
        );
        
        return user;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<AuthApiModel> register(AuthApiModel user) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.register,
        data: {
          'name': user.name,
          'email': user.email,
          'password': user.password ?? '',
          'confirmPassword': user.password ?? '',
          if (user.dateOfBirth != null) 'dateOfBirth': user.dateOfBirth,
        },
      );
      
      if (response.data['success'] == true) {
        final data = response.data['data'] as Map<String, dynamic>;
        final registeredUser = AuthApiModel.fromJson(data);
        return registeredUser;
      }
      return user;
    } catch (e) {
      rethrow;
    }
  }
}
