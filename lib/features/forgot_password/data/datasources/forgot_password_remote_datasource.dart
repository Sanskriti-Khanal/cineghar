import 'package:cineghar/core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';

abstract class IForgotPasswordRemoteDataSource {
  Future<bool> sendOtp(String email);
  Future<bool> verifyOtp(String email, String otp);
  Future<bool> resetPassword(String email, String newPassword);
}

class ForgotPasswordRemoteDataSourceImpl implements IForgotPasswordRemoteDataSource {
  final ApiClient apiClient;

  ForgotPasswordRemoteDataSourceImpl(this.apiClient);

  @override
  Future<bool> sendOtp(String email) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.forgotPassword,
        data: {'email': email},
      );
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> verifyOtp(String email, String otp) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.verifyOtp,
        data: {'email': email, 'otp': otp},
      );
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> resetPassword(String email, String newPassword) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.resetPassword,
        data: {'email': email, 'newPassword': newPassword},
      );
      return response.statusCode == 200;
    } catch (e) {
      rethrow;
    }
  }
}
