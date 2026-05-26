// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_type_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VehicleTypeModelAdapter extends TypeAdapter<VehicleTypeModel> {
  @override
  final int typeId = 6;

  @override
  VehicleTypeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return VehicleTypeModel(
      idVehicleType: fields[0] as int,
      name: fields[1] as String,
      createdAt: fields[2] as String,
      updatedAt: fields[3] as String,
      createdBy: fields[4] as String,
      updatedBy: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, VehicleTypeModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.idVehicleType)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.updatedAt)
      ..writeByte(4)
      ..write(obj.createdBy)
      ..writeByte(5)
      ..write(obj.updatedBy);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VehicleTypeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
