import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../data/datasources/sales_remote_datasource.dart';
import '../../data/repositories/sales_repository_impl.dart';
import '../../domain/usecases/get_active_offers_usecase.dart';
import '../viewmodel/sales_viewmodel.dart';
import '../state/sales_state.dart';

final salesRemoteDataSourceProvider = Provider<ISalesRemoteDataSource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return SalesRemoteDataSource(apiClient: apiClient);
});

final salesRepositoryProvider = Provider((ref) {
  final remoteDataSource = ref.read(salesRemoteDataSourceProvider);
  return SalesRepositoryImpl(remoteDataSource: remoteDataSource);
});

final getActiveOffersUsecaseProvider = Provider((ref) {
  final repository = ref.read(salesRepositoryProvider);
  return GetSalesOffersUsecase(repository: repository);
});

final salesViewModelProvider =
    NotifierProvider<SalesViewModel, SalesState>(() {
  return SalesViewModel();
});
