import '../../domain/entities/reward_entity.dart';

class LoyaltyRewardModel extends LoyaltyRewardEntity {
  const LoyaltyRewardModel({
    required super.id,
    required super.title,
    required super.pointsRequired,
    super.subtitle,
    super.description,
  });

  factory LoyaltyRewardModel.fromJson(Map<String, dynamic> json) {
    return LoyaltyRewardModel(
      id: (json['_id'] ?? json['id'])?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString(),
      description: json['description']?.toString(),
      pointsRequired: (json['pointsRequired'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'pointsRequired': pointsRequired,
    };
  }
}