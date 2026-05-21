import 'package:hive/hive.dart';

part 'vehicle_type_model.g.dart';

@HiveType(typeId: 5)
class VehicleTypeModel {
  @HiveField(0)
  final int idVehicleType;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String createdAt;

  @HiveField(3)
  final String updatedAt;

  @HiveField(4)
  final String createdBy;

  @HiveField(5)
  final String updatedBy;

  VehicleTypeModel({
    required this.idVehicleType,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
  });

  factory VehicleTypeModel.fromEntity(
    int idVehicleType,
    String name,
    String createdAt,
    String updatedAt,
    String createdBy,
    String updatedBy,
  ) {
    return VehicleTypeModel(
      idVehicleType: idVehicleType,
      name: name,
      createdAt: createdAt,
      updatedAt: updatedAt,
      createdBy: createdBy,
      updatedBy: updatedBy,
    );
  }

  Map<String, dynamic> toJson() => {
    'id_vehicle_type': idVehicleType,
    'name': name,
    'created_at': createdAt,
    'updated_at': updatedAt,
    'created_by': createdBy,
    'updated_by': updatedBy,
  };
}
