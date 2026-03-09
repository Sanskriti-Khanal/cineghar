import 'package:cineghar/features/booking/domain/entities/offer_entity.dart';

class OfferApiModel {
  final String id;
  final String name;
  final String code;
  final String? description;
  final String type;
  final double? discountPercent;
  final double? discountAmount;
  final double? minSpend;

  OfferApiModel({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    this.description,
    this.discountPercent,
    this.discountAmount,
    this.minSpend,
  });

  factory OfferApiModel.fromJson(Map<String, dynamic> json) {
    return OfferApiModel(
      id: json['_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      description: json['description']?.toString(),
      type: json['type']?.toString() ?? 'percentage_discount',
      discountPercent: (json['discountPercent'] as num?)?.toDouble(),
      discountAmount: (json['discountAmount'] as num?)?.toDouble(),
      minSpend: (json['minSpend'] as num?)?.toDouble(),
    );
  }

  OfferEntity toEntity() {
    return OfferEntity(
      id: id,
      name: name,
      code: code,
      description: description,
      type: type,
      discountPercent: discountPercent,
      discountAmount: discountAmount,
      minSpend: minSpend,
    );
  }
}
