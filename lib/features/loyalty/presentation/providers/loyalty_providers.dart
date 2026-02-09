import 'package:cineghar/features/loyalty/presentation/providers/loyalty_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../data/datasources/loyalty_remote_datasource.dart';
import '../../data/repositories/loyalty_repository_impl.dart';
import '../../domain/repositories/loyalty_repository.dart';
import '../../domain/usecases/get_my_loyalty_usecase.dart';
import '../../domain/usecases/get_rewards_usecase.dart';
import '../viewmodel/loyalty_viewmodel.dart';
import '../state/loyalty_state.dart';

final loyaltyRemoteDataSourceProvider = Provider<ILoyaltyRemoteDataSource>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return LoyaltyRemoteDataSource(apiClient: apiClient);
});

final loyaltyRepositoryProvider = Provider<ILoyaltyRepository>((ref) {
  final remoteDataSource = ref.read(loyaltyRemoteDataSourceProvider);
  return LoyaltyRepositoryImpl(remoteDataSource: remoteDataSource);
});

final getMyLoyaltyUsecaseProvider = Provider<GetMyLoyaltyUsecase>((ref) {
  final repository = ref.read(loyaltyRepositoryProvider);
  return GetMyLoyaltyUsecase(repository: repository);
});

final getLoyaltyRewardsUsecaseProvider = Provider<GetLoyaltyRewardsUsecase>((ref) {
  final repository = ref.read(loyaltyRepositoryProvider);
  return GetLoyaltyRewardsUsecase(repository: repository);
});

final loyaltyViewModelProvider =
    NotifierProvider<LoyaltyViewModel, LoyaltyState>(() {
  return LoyaltyViewModel();
});
