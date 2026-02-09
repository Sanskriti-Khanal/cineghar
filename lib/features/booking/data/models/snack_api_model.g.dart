// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'snack_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SnackItemApiModel _$SnackItemApiModelFromJson(Map<String, dynamic> json) =>
    SnackItemApiModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: (json['price'] as num).toDouble(),
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      sortOrder: json['sortOrder'] as int? ?? 0,
    );

Map<String, dynamic> _$SnackItemApiModelToJson(SnackItemApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'category': instance.category,
      'imageUrl': instance.imageUrl,
      'isActive': instance.isActive,
      'sortOrder': instance.sortOrder,
    };

SnackComboApiModel _$SnackComboApiModelFromJson(Map<String, dynamic> json) =>
    SnackComboApiModel(
      id: json['_id'] as String,
      name: json['name'] as String,
      itemsPreview: json['itemsPreview'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: json['originalPrice'] as double?,
      discountLabel: json['discountLabel'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      sortOrder: json['sortOrder'] as int? ?? 0,
    );

Map<String, dynamic> _$SnackComboApiModelToJson(SnackComboApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'itemsPreview': instance.itemsPreview,
      'price': instance.price,
      'originalPrice': instance.originalPrice,
      'discountLabel': instance.discountLabel,
      'imageUrl': instance.imageUrl,
      'isActive': instance.isActive,
      'sortOrder': instance.sortOrder,
    };