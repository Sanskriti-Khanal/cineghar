import 'package:equatable/equatable.dart';

enum SnackCategory { veg, nonveg, beverage }

class SnackItemEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final double price;
  final SnackCategory category;
  final String? imageUrl;
  final bool isActive;
  final int sortOrder;

  const SnackItemEntity({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.category,
    this.imageUrl,
    required this.isActive,
    required this.sortOrder,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        category,
        imageUrl,
        isActive,
        sortOrder,
      ];
}

class SnackComboEntity extends Equatable {
  final String id;
  final String name;
  final String itemsPreview;
  final double price;
  final double? originalPrice;
  final String? discountLabel;
  final String? imageUrl;
  final bool isActive;
  final int sortOrder;

  const SnackComboEntity({
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

  @override
  List<Object?> get props => [
        id,
        name,
        itemsPreview,
        price,
        originalPrice,
        discountLabel,
        imageUrl,
        isActive,
        sortOrder,
      ];
}

class SnackCartItem extends Equatable {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String? imageUrl;

  const SnackCartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.imageUrl,
  });

  SnackCartItem copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
    String? imageUrl,
  }) {
    return SnackCartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  @override
  List<Object?> get props => [id, name, price, quantity, imageUrl];
}