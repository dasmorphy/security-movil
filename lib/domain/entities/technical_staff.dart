class TechnicalStaff {
  int idStaff;
  DateTime createdAt;
  String createdBy;
  String name;
  DateTime updatedAt;
  String updatedBy;

  TechnicalStaff({
    required this.idStaff,
    required this.createdAt,
    required this.createdBy,
    required this.name,
    required this.updatedAt,
    required this.updatedBy,
  });

  factory TechnicalStaff.fromJson(Map<String, dynamic> json) => TechnicalStaff(
    idStaff: json["id_staff"],
    createdAt: DateTime.parse(json["created_at"]),
    createdBy: json["created_by"],
    name: json["name"],
    updatedAt: DateTime.parse(json["updated_at"]),
    updatedBy: json["updated_by"],
  );

  Map<String, dynamic> toJson() => {
    "id_staff": idStaff,
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "name": name,
    "updated_at": updatedAt.toIso8601String(),
    "updated_by": updatedBy,
  };
}
