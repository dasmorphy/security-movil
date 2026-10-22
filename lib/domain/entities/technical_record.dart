class TechnicalRecord {
  String clientName;
  int clientId;
  DateTime createdAt;
  String createdBy;
  int idRecord;
  int locationId;
  String locationName;
  String? nameResponsible;
  List<Material>? materials;
  String resume;
  String status;
  String taskCode;
  int taskId;
  List<TechnicalStaffRecord>? technicalStaff;
  DateTime updatedAt;
  String updatedBy;
  List<String> images;
  dynamic vehicle;

  TechnicalRecord({
    required this.clientName,
    required this.clientId,
    required this.createdAt,
    required this.createdBy,
    required this.idRecord,
    required this.locationId,
    required this.locationName,
    this.nameResponsible,
    this.materials,
    required this.resume,
    required this.status,
    required this.taskCode,
    required this.taskId,
    this.technicalStaff,
    required this.updatedAt,
    required this.updatedBy,
    required this.vehicle,
    required this.images,
  });

  factory TechnicalRecord.fromJson(Map<String, dynamic> json) =>
    TechnicalRecord(
      images: List<String>.from(json["images"].map((x) => x)),
      clientName: json["client_name"],
      clientId: json["client_id"],
      createdAt: DateTime.parse(json["created_at"]),
      createdBy: json["created_by"],
      idRecord: json["id_record"],
      locationId: json["location_id"],
      locationName: json["location_name"],
      nameResponsible: json["name_responsible"],
      materials: json["materials"] == null
          ? []
          : List<Material>.from(
              json["materials"]!.map((x) => Material.fromJson(x)),
            ),
      resume: json["resume"],
      status: json["status"],
      taskCode: json["task_code"],
      taskId: json["task_id"],
      technicalStaff: json["technical_staff"] == null
          ? []
          : List<TechnicalStaffRecord>.from(
              json["technical_staff"]!.map((x) => TechnicalStaffRecord.fromJson(x)),
            ),
      updatedAt: DateTime.parse(json["updated_at"]),
      updatedBy: json["updated_by"],
      vehicle: json["vehicle"],
    );

  Map<String, dynamic> toJson() => {
    "images": List<dynamic>.from(images.map((x) => x)),
    "client_name": clientName,
    "client_id": clientId,
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "id_record": idRecord,
    "location_id": locationId,
    "location_name": locationName,
    "name_responsible": nameResponsible,
    "materials": materials == null
        ? []
        : List<dynamic>.from(materials!.map((x) => x.toJson())),
    "resume": resume,
    "status": status,
    "task_code": taskCode,
    "task_id": taskId,
    "technical_staff": technicalStaff == null
        ? []
        : List<dynamic>.from(technicalStaff!.map((x) => x.toJson())),
    "updated_at": updatedAt.toIso8601String(),
    "updated_by": updatedBy,
    "vehicle": vehicle,
  };
}

class Material {
  int? idMaterialRecord;
  int? idEquipment;
  String? material;
  int? quantity;

  Material({this.idEquipment, this.material, this.quantity, this.idMaterialRecord});

  factory Material.fromJson(Map<String, dynamic> json) => Material(
    idMaterialRecord: json["id_material_record"],
    idEquipment: json["id_equipment"],
    material: json["material"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "id_material_record": idMaterialRecord,
    "id_equipment": idEquipment,
    "material": material,
    "quantity": quantity,
  };
}

class TechnicalStaffRecord {
  String? name;
  String? userTechId;
  String? user;

  TechnicalStaffRecord({this.name, this.userTechId, this.user});

  factory TechnicalStaffRecord.fromJson(Map<String, dynamic> json) =>
    TechnicalStaffRecord(
      name: json["name"],
      userTechId: json["user_tech_id"],
      user: json["user"],
    );

  Map<String, dynamic> toJson() => {
    "name": name,
    "user_tech_id": userTechId,
    "user": user,
  };
}
