import 'package:cineghar/features/booking/domain/entities/hall_entity.dart';

class HallApiModel {
  final String id;
  final String name;

  HallApiModel({required this.id, required this.name});

  factory HallApiModel.fromJson(Map<String, dynamic> json) {
    return HallApiModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  HallEntity toEntity() {
    return HallEntity(id: id, name: name);
  }
}