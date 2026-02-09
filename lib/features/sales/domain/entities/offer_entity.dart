import 'package:equatable/equatable.dart';

class SalesOfferEntity extends Equatable {
  final String id;
  final String name;
  final String code;
  final String? description;
  final String type; // "percentage_discount" | "fixed_discount"
  final double? discountPercent;
  final double? discountAmount;
  final double? minSpend;

  const SalesOfferEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.type,
    this.description,
    this.discountPercent,
    this.discountAmount,
    this.minSpend,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        code,
        description,
        type,
        discountPercent,
        discountAmount,
        minSpend,
      ];
}