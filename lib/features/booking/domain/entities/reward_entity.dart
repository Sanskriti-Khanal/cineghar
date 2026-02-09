import 'package:equatable/equatable.dart';

class RewardEntity extends Equatable {
  final String id;
  final String title;
  final String? subtitle;
  final String? description;
  final int pointsRequired;

  const RewardEntity({
    required this.id,
    required this.title,
    required this.pointsRequired,
    this.subtitle,
    this.description,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        description,
        pointsRequired,
      ];
}
