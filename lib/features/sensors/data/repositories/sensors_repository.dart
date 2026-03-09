import 'package:cineghar/features/sensors/data/datasources/sensors_local_datasource.dart';
import 'package:cineghar/features/sensors/domain/entities/light_reading_entity.dart';
import 'package:cineghar/features/sensors/domain/entities/proximity_reading_entity.dart';
import 'package:cineghar/features/sensors/domain/entities/gyroscope_reading_entity.dart';
import 'package:cineghar/features/sensors/domain/repositories/sensors_repository.dart';


class SensorsRepository implements ISensorsRepository {
  final ISensorsLocalDatasource _local;

  SensorsRepository({required ISensorsLocalDatasource localDatasource})
      : _local = localDatasource;

  @override
  Stream<LightReadingEntity> watchLight() => _local.watchLight();

  @override
  Stream<ProximityReadingEntity> watchProximity() =>
      _local.watchProximity();

  @override // Added this method
  Stream<GyroscopeReadingEntity> watchGyroscope() => _local.watchGyroscope();
}