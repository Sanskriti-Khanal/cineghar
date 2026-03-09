import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../models/loyalty_model.dart';
import '../models/reward_model.dart';

abstract interface class ILoyaltyRemoteDataSource {
  Future<LoyaltyInfoModel> getMyLoyalty();
  Future<List<LoyaltyRewardModel>> getRewards();
}

class LoyaltyRemoteDataSource implements ILoyaltyRemoteDataSource {
  final ApiClient _apiClient;

  LoyaltyRemoteDataSource({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<LoyaltyInfoModel> getMyLoyalty() async {
    final response = await _apiClient.get(ApiEndpoints.loyaltyMe);
    final data = response.data as Map<String, dynamic>;
    final inner = data['data'] as Map<String, dynamic>? ?? const {};
    return LoyaltyInfoModel.fromJson(inner);
  }

  @override
  Future<List<LoyaltyRewardModel>> getRewards() async {
    final response = await _apiClient.get(ApiEndpoints.rewards);
    final data = response.data as Map<String, dynamic>;
    final list = data['data'] as List<dynamic>? ?? const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(LoyaltyRewardModel.fromJson)
        .toList();
  }
}