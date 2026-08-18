class TechnicalRecord {
  String clientName;
  DateTime createdAt;
  String createdBy;
  int idRecord;
  String locationName;
  List<Material>? materials;
  String resume;
  String status;
  String taskCode;
  List<TechnicalStaffRecord>? technicalStaff;
  DateTime updatedAt;
  String updatedBy;
  dynamic vehicle;

  TechnicalRecord({
    required this.clientName,
    required this.createdAt,
    required this.createdBy,
    required this.idRecord,
    required this.locationName,
    this.materials,
    required this.resume,
    required this.status,
    required this.taskCode,
    this.technicalStaff,
    required this.updatedAt,
    required this.updatedBy,
    required this.vehicle,
  });

  factory TechnicalRecord.fromJson(Map<String, dynamic> json) =>
    TechnicalRecord(
      clientName: json["client_name"],
      createdAt: DateTime.parse(json["created_at"]),
      createdBy: json["created_by"],
      idRecord: json["id_record"],
      locationName: json["location_name"],
      materials: json["materials"] == null
          ? []
          : List<Material>.from(
              json["materials"]!.map((x) => Material.fromJson(x)),
            ),
      resume: json["resume"],
      status: json["status"],
      taskCode: json["task_code"],
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
    "client_name": clientName,
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "id_record": idRecord,
    "location_name": locationName,
    "materials": materials == null
        ? []
        : List<dynamic>.from(materials!.map((x) => x.toJson())),
    "resume": resume,
    "status": status,
    "task_code": taskCode,
    "technical_staff": technicalStaff == null
        ? []
        : List<dynamic>.from(technicalStaff!.map((x) => x.toJson())),
    "updated_at": updatedAt.toIso8601String(),
    "updated_by": updatedBy,
    "vehicle": vehicle,
  };
}

class Material {
  int? idMaterial;
  String? material;
  int? quantity;

  Material({this.idMaterial, this.material, this.quantity});

  factory Material.fromJson(Map<String, dynamic> json) => Material(
    idMaterial: json["id_material"],
    material: json["material"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "id_material": idMaterial,
    "material": material,
    "quantity": quantity,
  };
}

class TechnicalStaffRecord {
  int? idTechnical;
  String? name;

  TechnicalStaffRecord({this.idTechnical, this.name});

  factory TechnicalStaffRecord.fromJson(Map<String, dynamic> json) =>
    TechnicalStaffRecord(idTechnical: json["id_technical"], name: json["name"]);

  Map<String, dynamic> toJson() => {"id_technical": idTechnical, "name": name};
}
