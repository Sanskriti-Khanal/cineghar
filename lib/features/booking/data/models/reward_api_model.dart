import 'package:cineghar/features/booking/domain/entities/reward_entity.dart';

class RewardApiModel {
  final String id;
  final String title;
  final String? subtitle;
  final String? description;
  final int pointsRequired;

  RewardApiModel({
    required this.id,
    required this.title,
    required this.pointsRequired,
    this.subtitle,
    this.description,
  });

  factory RewardApiModel.fromJson(Map<String, dynamic> json) {
    return RewardApiModel(
      id: json['_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString(),
      description: json['description']?.toString(),
      pointsRequired: (json['pointsRequired'] as num?)?.toInt() ?? 0,
    );
  }

  RewardEntity toEntity() {
    return RewardEntity(
      id: id,
      title: title,
      subtitle: subtitle,
      description: description,
      pointsRequired: pointsRequired,
    );
  }
}
