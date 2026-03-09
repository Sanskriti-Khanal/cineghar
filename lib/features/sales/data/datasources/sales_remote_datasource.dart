import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../models/offer_model.dart';

abstract interface class ISalesRemoteDataSource {
  Future<List<SalesOfferModel>> getActiveOffers();
}

class SalesRemoteDataSource implements ISalesRemoteDataSource {
  final ApiClient _apiClient;

  SalesRemoteDataSource({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<List<SalesOfferModel>> getActiveOffers() async {
    final response = await _apiClient.get(ApiEndpoints.offers);
    final data = response.data as Map<String, dynamic>;
    final list = data['data'] as List<dynamic>? ?? const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(SalesOfferModel.fromJson)
        .toList();
  }
}