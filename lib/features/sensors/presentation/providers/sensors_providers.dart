import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/sensors_local_datasource.dart';
import '../../data/repositories/sensors_repository.dart';
import '../../domain/repositories/sensors_repository.dart';
import '../../domain/usecases/watch_light_sensor_usecase.dart';
import '../../domain/usecases/watch_proximity_sensor_usecase.dart';
import '../../domain/usecases/watch_gyroscope_sensor_usecase.dart';
import '../viewmodel/sensors_viewmodel.dart';
import 'sensors_state.dart';

final sensorsLocalDatasourceProvider = Provider<ISensorsLocalDatasource>((ref) {
  return const SensorsLocalDatasource();
});

final sensorsRepositoryProvider = Provider<ISensorsRepository>((ref) {
  final localDatasource = ref.read(sensorsLocalDatasourceProvider);
  return SensorsRepository(localDatasource: localDatasource);
});

final watchLightSensorUsecaseProvider = Provider((ref) {
  final repository = ref.read(sensorsRepositoryProvider);
  return WatchLightSensorUsecase(repository: repository);
});

final watchProximitySensorUsecaseProvider = Provider((ref) {
  final repository = ref.read(sensorsRepositoryProvider);
  return WatchProximitySensorUsecase(repository: repository);
});

final watchGyroscopeSensorUsecaseProvider = Provider((ref) {
  final repository = ref.read(sensorsRepositoryProvider);
  return WatchGyroscopeSensorUsecase(repository: repository);
});

final sensorsViewModelProvider =
    NotifierProvider<SensorsViewModel, SensorsState>(() {
  return SensorsViewModel();
});
