import 'package:cineghar/features/sensors/data/repositories/sensors_repository.dart';
import 'package:cineghar/features/sensors/domain/entities/proximity_reading_entity.dart';
import 'package:cineghar/features/sensors/domain/repositories/sensors_repository.dart';



class WatchProximitySensorUsecase {
  final ISensorsRepository _repository;

  WatchProximitySensorUsecase({required ISensorsRepository repository})
      : _repository = repository;

  Stream<ProximityReadingEntity> call() {
    return _repository.watchProximity();
  }
}
