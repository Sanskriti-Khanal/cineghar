import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/services/connectivity/network_info.dart';
import '../../../../core/services/hive/hive_service.dart';
import '../../../../core/services/storage/user_session_service.dart';
import '../../data/datasources/auth_datasource.dart';
import '../../data/datasources/local/auth_local_datasource.dart';
import '../../data/datasources/remote/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_usecase.dart';
import '../../domain/usecases/get_profile_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/upload_profile_image_usecase.dart';
import '../viewmodel/auth_viewmodel.dart';
import 'auth_state.dart';

final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  final hiveService = ref.watch(hiveServiceProvider);
  return AuthLocalDatasource(hiveService: hiveService);
});

final authRemoteDataSourceProvider = Provider<IAuthRemoteDataSource>((ref) {
  return AuthRemoteDatasource(
    apiClient: ref.read(apiClientProvider),
    userSessionService: ref.read(userSessionServiceProvider),
  );
});

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final authDatasource = ref.read(authLocalDatasourceProvider);
  final authRemoteDatasource = ref.read(authRemoteDataSourceProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return AuthRepository(
    authDatasource: authDatasource,
    authRemoteDataSource: authRemoteDatasource,
    networkInfo: networkInfo,
  );
});

final registerUsecaseProvider = Provider<RegisterUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return RegisterUsecase(authRepository: authRepository);
});

final loginUsecaseProvider = Provider<LoginUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return LoginUsecase(authRepository: authRepository);
});

final logoutUsecaseProvider = Provider<LogoutUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return LogoutUsecase(authRepository: authRepository);
});

final getCurrentUsecaseProvider = Provider<GetCurrentUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return GetCurrentUsecase(authRepository: authRepository);
});

final getProfileUsecaseProvider = Provider<GetProfileUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return GetProfileUsecase(authRepository: authRepository);
});

final uploadProfileImageUsecaseProvider = Provider<UploadProfileImageUsecase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return UploadProfileImageUsecase(authRepository: authRepository);
});

final authViewModelProvider = NotifierProvider<AuthViewmodel, AuthState>(() {
  return AuthViewmodel();
});
