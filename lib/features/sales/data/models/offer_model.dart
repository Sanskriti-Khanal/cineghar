import '../../domain/entities/offer_entity.dart';

class SalesOfferModel extends SalesOfferEntity {
  const SalesOfferModel({
    required super.id,
    required super.name,
    required super.code,
    required super.type,
    super.description,
    super.discountPercent,
    super.discountAmount,
    super.minSpend,
  });

  factory SalesOfferModel.fromJson(Map<String, dynamic> json) {
    return SalesOfferModel(
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

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'code': code,
      'description': description,
      'type': type,
      'discountPercent': discountPercent,
      'discountAmount': discountAmount,
      'minSpend': minSpend,
    };
  }
}