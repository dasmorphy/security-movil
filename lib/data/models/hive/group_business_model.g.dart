// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_business_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GroupBusinessModelAdapter extends TypeAdapter<GroupBusinessModel> {
  @override
  final int typeId = 7;

  @override
  GroupBusinessModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GroupBusinessModel(
      idGroupBusiness: fields[0] as int,
      name: fields[1] as String,
      businessId: fields[2] as int,
      sectorId: fields[3] as int,
      createdAt: fields[4] as String,
      updatedAt: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GroupBusinessModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.idGroupBusiness)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.businessId)
      ..writeByte(3)
      ..write(obj.sectorId)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupBusinessModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
