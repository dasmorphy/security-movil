// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unity_weight_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UnityWeightModelAdapter extends TypeAdapter<UnityWeightModel> {
  @override
  final int typeId = 5;

  @override
  UnityWeightModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UnityWeightModel(
      id: fields[0] as int,
      name: fields[1] as String,
      code: fields[2] as String,
      createdAt: fields[3] as String,
      updatedAt: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UnityWeightModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.code)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnityWeightModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
