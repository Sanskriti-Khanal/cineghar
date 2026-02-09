import 'package:cineghar/features/sensors/domain/entities/gyroscope_reading_entity.dart';
import 'package:cineghar/features/sensors/domain/repositories/sensors_repository.dart';

class WatchGyroscopeSensorUsecase {
  final ISensorsRepository _repository;

  WatchGyroscopeSensorUsecase({required ISensorsRepository repository})
      : _repository = repository;

  Stream<GyroscopeReadingEntity> call() {
    return _repository.watchGyroscope();
  }
}
