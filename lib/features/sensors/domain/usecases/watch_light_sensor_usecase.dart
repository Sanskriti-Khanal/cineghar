import 'package:cineghar/features/sensors/data/repositories/sensors_repository.dart';
import 'package:cineghar/features/sensors/domain/entities/light_reading_entity.dart';
import 'package:cineghar/features/sensors/domain/repositories/sensors_repository.dart';



class WatchLightSensorUsecase {
  final ISensorsRepository _repository;

  WatchLightSensorUsecase({required ISensorsRepository repository})
      : _repository = repository;

  Stream<LightReadingEntity> call() {
    return _repository.watchLight();
  }
}
