class VehicleType {
  DateTime createdAt;
  String createdBy;
  int idVehicleType;
  String name;
  DateTime updatedAt;
  String updatedBy;

  VehicleType({
    required this.createdAt,
    required this.createdBy,
    required this.idVehicleType,
    required this.name,
    required this.updatedAt,
    required this.updatedBy,
  });

  factory VehicleType.fromJson(Map<String, dynamic> json) => VehicleType(
    createdAt: DateTime.parse(json["created_at"]),
    createdBy: json["created_by"],
    idVehicleType: json["id_vehicle_type"],
    name: json["name"],
    updatedAt: DateTime.parse(json["updated_at"]),
    updatedBy: json["updated_by"],
  );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "id_vehicle_type": idVehicleType,
    "name": name,
    "updated_at": updatedAt.toIso8601String(),
    "updated_by": updatedBy,
  };
}
