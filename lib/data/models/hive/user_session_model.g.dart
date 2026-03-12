// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_session_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserSessionModelAdapter extends TypeAdapter<UserSessionModel> {
  @override
  final int typeId = 1;

  @override
  UserSessionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSessionModel(
      userId: fields[0] as String,
      email: fields[1] as String,
      token: fields[2] as String,
      role: fields[3] as String,
      attributes: (fields[4] as Map).cast<String, dynamic>(),
      user: fields[5] as String,
      isActive: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, UserSessionModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.token)
      ..writeByte(3)
      ..write(obj.role)
      ..writeByte(4)
      ..write(obj.attributes)
      ..writeByte(5)
      ..write(obj.user)
      ..writeByte(6)
      ..write(obj.isActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSessionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
