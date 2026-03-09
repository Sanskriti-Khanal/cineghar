import 'package:json_annotation/json_annotation.dart';
import 'package:cineghar/features/booking/domain/entities/snack_entity.dart';

part 'snack_api_model.g.dart';

@JsonSerializable()
class SnackItemApiModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String? description;
  final double price;
  final String category;
  final String? imageUrl;
  final bool isActive;
  final int sortOrder;

  SnackItemApiModel({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.category,
    this.imageUrl,
    required this.isActive,
    required this.sortOrder,
  });

  factory SnackItemApiModel.fromJson(Map<String, dynamic> json) {
    final priceValue = json['price'];
    double price;
    
    if (priceValue is int) {
      price = priceValue.toDouble();
    } else if (priceValue is double) {
      price = priceValue;
    } else {
      price = 0.0; // Default value if price is null or invalid
    }
    
    return SnackItemApiModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      price: price,
      category: json['category'] as String? ?? 'veg',
      imageUrl: json['imageUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      sortOrder: json['sortOrder'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => _$SnackItemApiModelToJson(this);

  SnackItemEntity toEntity() {
    return SnackItemEntity(
      id: id,
      name: name,
      description: description,
      price: price,
      category: _categoryFromString(category),
      imageUrl: imageUrl,
      isActive: isActive,
      sortOrder: sortOrder,
    );
  }

  SnackCategory _categoryFromString(String category) {
    switch (category.toLowerCase()) {
      case 'veg':
        return SnackCategory.veg;
      case 'nonveg':
        return SnackCategory.nonveg;
      case 'beverage':
        return SnackCategory.beverage;
      default:
        return SnackCategory.veg;
    }
  }
}

@JsonSerializable()
class SnackComboApiModel {
  @JsonKey(name: '_id')
  final String id;
  final String name;
  final String itemsPreview;
  final double price;
  final double? originalPrice;
  final String? discountLabel;
  final String? imageUrl;
  final bool isActive;
  final int sortOrder;

  SnackComboApiModel({
    required this.id,
    required this.name,
    required this.itemsPreview,
    required this.price,
    this.originalPrice,
    this.discountLabel,
    this.imageUrl,
    required this.isActive,
    required this.sortOrder,
  });

  factory SnackComboApiModel.fromJson(Map<String, dynamic> json) {
    final priceValue = json['price'];
    double price;
    
    if (priceValue is int) {
      price = priceValue.toDouble();
    } else if (priceValue is double) {
      price = priceValue;
    } else {
      price = 0.0; // Default value if price is null or invalid
    }
    
    final originalPriceValue = json['originalPrice'];
    double? originalPrice;
    
    if (originalPriceValue is int) {
      originalPrice = originalPriceValue.toDouble();
    } else if (originalPriceValue is double) {
      originalPrice = originalPriceValue;
    } else {
      originalPrice = null; // Keep null if originalPrice is not provided
    }
    
    return SnackComboApiModel(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      itemsPreview: json['itemsPreview'] as String? ?? '',
      price: price,
      originalPrice: originalPrice,
      discountLabel: json['discountLabel'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      sortOrder: json['sortOrder'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => _$SnackComboApiModelToJson(this);

  SnackComboEntity toEntity() {
    return SnackComboEntity(
      id: id,
      name: name,
      itemsPreview: itemsPreview,
      price: price,
      originalPrice: originalPrice,
      discountLabel: discountLabel,
      imageUrl: imageUrl,
      isActive: isActive,
      sortOrder: sortOrder,
    );
  }
}