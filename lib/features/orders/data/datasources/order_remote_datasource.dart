import '../../../../core/api/api_client.dart';
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/services/storage/user_session_service.dart';
import '../models/order_model.dart';
import 'package:dio/dio.dart';

abstract class OrderRemoteDataSource {
  Future<List<OrderModel>> getMyOrders();
  Future<OrderModel> getOrderDetails(String orderId);
  Future<OrderModel> confirmPayment(String pidx, String purchaseOrderId);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final ApiClient apiClient;
  final UserSessionService _userSessionService;

  OrderRemoteDataSourceImpl(this.apiClient, this._userSessionService);

  @override
  Future<List<OrderModel>> getMyOrders() async {
    try {
      final userId = _userSessionService.getUserId();
      final response = await apiClient.get(
        ApiEndpoints.orders,
        queryParameters: userId != null ? {'user': userId} : null,
      );
      
      if (response.data['success'] == true) {
        // Handle possible nested data structures (e.g., data or orders key)
        final dynamic rawData = response.data['data'] ?? response.data['orders'];
        final List<dynamic> ordersJson = (rawData is List) ? rawData : [];
        return ordersJson.map((json) => OrderModel.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch orders');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message ?? 'Network error');
    }
  }

  @override
  Future<OrderModel> getOrderDetails(String orderId) async {
    try {
      final response = await apiClient.get(ApiEndpoints.orderById(orderId));
      
      if (response.data['success'] == true) {
        return OrderModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to fetch order details');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message ?? 'Network error');
    }
  }

  @override
  Future<OrderModel> confirmPayment(String pidx, String purchaseOrderId) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.paymentConfirm,
        data: {
          'pidx': pidx,
          'purchaseOrderId': purchaseOrderId,
        },
      );
      
      if (response.data['success'] == true) {
        return OrderModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to confirm payment');
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? e.message ?? 'Network error');
    }
  }
}