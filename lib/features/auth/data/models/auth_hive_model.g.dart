// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_hive_model.dart';

// **************************************************************************
// HiveObjectGenerator
// **************************************************************************

// **************************************************************************
// HiveGenerator
// **************************************************************************

class AuthHiveModelAdapter extends TypeAdapter<AuthHiveModel> {
  @override
  final int typeId = HiveTableConstant.authTypeId;

  @override
  AuthHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthHiveModel(
      authId: fields[0] as String?,
      fullName: fields[1] as String,
      email: fields[2] as String,
      phoneNumber: fields[3] as String?,
      username: fields[4] as String,
      password: fields[5] as String?,
      profilePicture: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AuthHiveModel obj) {
    writer.writeByte(7);
    writer.writeByte(0);
    writer.write(obj.authId);
    writer.writeByte(1);
    writer.write(obj.fullName);
    writer.writeByte(2);
    writer.write(obj.email);
    writer.writeByte(3);
    writer.write(obj.phoneNumber);
    writer.writeByte(4);
    writer.write(obj.username);
    writer.writeByte(5);
    writer.write(obj.password);
    writer.writeByte(6);
    writer.write(obj.profilePicture);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthHiveModelAdapter &&
      runtimeType == other.runtimeType &&
      typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthHiveModel _$AuthHiveModelFromJson(Map<String, dynamic> json) => AuthHiveModel(
      authId: json['authId'] as String?,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      username: json['username'] as String,
      password: json['password'] as String?,
      profilePicture: json['profilePicture'] as String?,
    );

Map<String, dynamic> _$AuthHiveModelToJson(AuthHiveModel instance) =>
    <String, dynamic>{
      'authId': instance.authId,
      'fullName': instance.fullName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'username': instance.username,
      'password': instance.password,
      'profilePicture': instance.profilePicture,
    };