import 'dart:async';
import 'dart:io';
import 'package:light_sensor/light_sensor.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:cineghar/features/sensors/domain/entities/light_reading_entity.dart';
import 'package:cineghar/features/sensors/domain/entities/proximity_reading_entity.dart';
import 'package:cineghar/features/sensors/domain/entities/gyroscope_reading_entity.dart';
import 'package:sensors_plus/sensors_plus.dart';

abstract interface class ISensorsLocalDatasource {
  Stream<LightReadingEntity> watchLight();

  Stream<ProximityReadingEntity> watchProximity();

  Stream<GyroscopeReadingEntity> watchGyroscope();
}

class SensorsLocalDatasource implements ISensorsLocalDatasource {
  const SensorsLocalDatasource();

  @override
  Stream<LightReadingEntity> watchLight() {
    // LightSensor.luxStream() is Android only or throws MissingPluginException on iOS.
    if (!Platform.isIOS) {
      try {
        return LightSensor.luxStream()
            .distinct()
            .map((lux) => LightReadingEntity(lux: lux))
            .handleError((_) => LightReadingEntity(lux: 0));
      } catch (e) {
        return Stream.empty();
      }
    }
    return Stream.empty();
  }

  @override
  Stream<ProximityReadingEntity> watchProximity() {
    // ProximitySensor.events emits raw distance values as ints.
    // Most devices emit 0 for near and 5 or 8 for far. Using < 1 (i.e. 0) is safer for "Near".
    return ProximitySensor.events.distinct().map(
      (value) {
        final isNear = value < 1; 
        return ProximityReadingEntity(
          isNear: isNear,
          rawValue: value,
        );
      },
    );
  }

  @override
  Stream<GyroscopeReadingEntity> watchGyroscope() {
    // sensors_plus: gyroscopeEventStream() emits GyroscopeEvent
    return gyroscopeEventStream().map(
      (event) => GyroscopeReadingEntity(x: event.x, y: event.y, z: event.z),
    );
  }
}
