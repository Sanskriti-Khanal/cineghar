import 'package:cineghar/features/sensors/domain/entities/light_reading_entity.dart';
import 'package:cineghar/features/sensors/domain/entities/proximity_reading_entity.dart';
import 'package:cineghar/features/sensors/domain/entities/gyroscope_reading_entity.dart';

abstract interface class ISensorsRepository {
  Stream<LightReadingEntity> watchLight();

  Stream<ProximityReadingEntity> watchProximity();

  Stream<GyroscopeReadingEntity> watchGyroscope();
}
