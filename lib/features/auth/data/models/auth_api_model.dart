import 'package:cineghar/features/auth/domain/entities/auth_entity.dart';

class AuthApiModel {
  final String? id;
  final String name;
  final String email;
  final String? password;
  final String? dateOfBirth;
  final String? role;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AuthApiModel({
    this.id,
    required this.name,
    required this.email,
    this.password,
    this.dateOfBirth,
    this.role,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory AuthApiModel.fromJson(Map<String, dynamic> json) {
    return AuthApiModel(
      id: json['_id']?.toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      dateOfBirth: json['dateOfBirth'],
      role: json['role'],
      imageUrl: json['imageUrl']?.toString(),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'dateOfBirth': dateOfBirth,
      'role': role,
      'imageUrl': imageUrl,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Convert to Entity
  AuthEntity toEntity() {
    return AuthEntity(
      authId: id,
      fullName: name,
      email: email,
      username: email.split('@').first,
      profilePicture: imageUrl,
    );
  }

  // Create from Entity
  factory AuthApiModel.fromEntity(AuthEntity entity) {
    return AuthApiModel(
      id: entity.authId,
      name: entity.fullName,
      email: entity.email,
      password: entity.password,
    );
  }
}
