class EntryAccessControl {
  int areaId;
  String areaName;
  DateTime createdAt;
  String createdBy;
  String dni;
  int idAccessControl;
  List<Image> images;
  String namesVisit;
  String observationsEntry;
  String observationsOut;
  String reasonVisit;
  int staffChargeId;
  String staffChargeName;
  String status;
  DateTime updatedAt;
  String updatedBy;

  EntryAccessControl({
    required this.areaId,
    required this.areaName,
    required this.createdAt,
    required this.createdBy,
    required this.dni,
    required this.idAccessControl,
    required this.images,
    required this.namesVisit,
    required this.observationsEntry,
    required this.observationsOut,
    required this.reasonVisit,
    required this.staffChargeId,
    required this.staffChargeName,
    required this.status,
    required this.updatedAt,
    required this.updatedBy,
  });

  factory EntryAccessControl.fromJson(Map<String, dynamic> json) =>
      EntryAccessControl(
        areaId: json["area_id"],
        areaName: json["area_name"],
        createdAt: DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
        dni: json["dni"],
        idAccessControl: json["id_access_control"],
        images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
        namesVisit: json["names_visit"],
        observationsEntry: json["observations_entry"],
        observationsOut: json["observations_out"],
        reasonVisit: json["reason_visit"],
        staffChargeId: json["staff_charge_id"],
        staffChargeName: json["staff_charge_name"],
        status: json["status"],
        updatedAt: DateTime.parse(json["updated_at"]),
        updatedBy: json["updated_by"],
      );

  Map<String, dynamic> toJson() => {
    "area_id": areaId,
    "area_name": areaName,
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "dni": dni,
    "id_access_control": idAccessControl,
    "images": List<dynamic>.from(images.map((x) => x.toJson())),
    "names_visit": namesVisit,
    "observations_entry": observationsEntry,
    "observations_out": observationsOut,
    "reason_visit": reasonVisit,
    "staff_charge_id": staffChargeId,
    "staff_charge_name": staffChargeName,
    "status": status,
    "updated_at": updatedAt.toIso8601String(),
    "updated_by": updatedBy,
  };
}

class Image {
  String imagePath;
  String typeProcess;

  Image({required this.imagePath, required this.typeProcess});

  factory Image.fromJson(Map<String, dynamic> json) =>
      Image(imagePath: json["image_path"], typeProcess: json["type_process"]);

  Map<String, dynamic> toJson() => {
    "image_path": imagePath,
    "type_process": typeProcess,
  };
}
