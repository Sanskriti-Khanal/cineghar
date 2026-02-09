import 'package:equatable/equatable.dart';

class ProximityReadingEntity extends Equatable {
  final bool isNear;
  final int rawValue;

  const ProximityReadingEntity({
    required this.isNear,
    required this.rawValue,
  });

  @override
  List<Object?> get props => [isNear, rawValue];
}
