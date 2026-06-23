class BlacklistDriver {
  DateTime createdAt;
  String createdBy;
  String dni;
  String fullNames;
  int idBlacklist;
  dynamic imagePath;
  String observations;
  String reasonRestriction;
  DateTime updatedAt;
  String updatedBy;

  BlacklistDriver({
    required this.createdAt,
    required this.createdBy,
    required this.dni,
    required this.fullNames,
    required this.idBlacklist,
    required this.imagePath,
    required this.observations,
    required this.reasonRestriction,
    required this.updatedAt,
    required this.updatedBy,
  });

  factory BlacklistDriver.fromJson(Map<String, dynamic> json) =>
      BlacklistDriver(
        createdAt: DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
        dni: json["dni"],
        fullNames: json["full_names"],
        idBlacklist: json["id_blacklist"],
        imagePath: json["image_path"],
        observations: json["observations"],
        reasonRestriction: json["reason_restriction"],
        updatedAt: DateTime.parse(json["updated_at"]),
        updatedBy: json["updated_by"],
      );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "dni": dni,
    "full_names": fullNames,
    "id_blacklist": idBlacklist,
    "image_path": imagePath,
    "observations": observations,
    "reason_restriction": reasonRestriction,
    "updated_at": updatedAt.toIso8601String(),
    "updated_by": updatedBy,
  };
}
