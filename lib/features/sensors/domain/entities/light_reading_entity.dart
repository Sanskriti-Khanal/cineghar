import 'package:equatable/equatable.dart';

class LightReadingEntity extends Equatable {
  final int lux;

  const LightReadingEntity({required this.lux});

  @override
  List<Object?> get props => [lux];
}
