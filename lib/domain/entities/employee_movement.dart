class EmployeeMovement {
  dynamic authorizedId;
  DateTime createdAt;
  String createdBy;
  String employeeDni;
  int employeeId;
  String employeeLastname;
  String employeeNames;
  String employeeStatus;
  List<String> images;
  dynamic groupBusinessId;
  dynamic groupName;
  int idMovement;
  String nameUser;
  dynamic observations;
  dynamic otherDestiny;
  dynamic reasonOut;
  String status;
  String typeMovement;
  DateTime updatedAt;
  String updatedBy;

  EmployeeMovement({
    required this.employeeStatus,
    required this.authorizedId,
    required this.createdAt,
    required this.createdBy,
    required this.employeeDni,
    required this.employeeId,
    required this.employeeLastname,
    required this.employeeNames,
    required this.groupBusinessId,
    required this.groupName,
    required this.idMovement,
    required this.nameUser,
    required this.observations,
    required this.otherDestiny,
    required this.reasonOut,
    required this.status,
    required this.typeMovement,
    required this.updatedAt,
    required this.updatedBy,
    required this.images
  });

  factory EmployeeMovement.fromJson(Map<String, dynamic> json) =>
      EmployeeMovement(
        authorizedId: json["authorized_id"],
        createdAt: DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
        employeeDni: json["employee_dni"],
        employeeId: json["employee_id"],
        employeeLastname: json["employee_lastname"],
        employeeNames: json["employee_names"],
        employeeStatus: json["employee_status"],
        groupBusinessId: json["group_business_id"],
        groupName: json["group_name"],
        idMovement: json["id_movement"],
        nameUser: json["name_user"],
        images: List<String>.from(json["images"].map((x) => x)),
        observations: json["observations"],
        otherDestiny: json["other_destiny"],
        reasonOut: json["reason_out"],
        status: json["status"],
        typeMovement: json["type_movement"],
        updatedAt: DateTime.parse(json["updated_at"]),
        updatedBy: json["updated_by"],
      );

  Map<String, dynamic> toJson() => {
    "authorized_id": authorizedId,
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "employee_dni": employeeDni,
    "employee_id": employeeId,
    "employee_lastname": employeeLastname,
    "images": List<dynamic>.from(images.map((x) => x)),
    "employee_names": employeeNames,
    "group_business_id": groupBusinessId,
    "group_name": groupName,
    "id_movement": idMovement,
    "name_user": nameUser,
    "observations": observations,
    "other_destiny": otherDestiny,
    "reason_out": reasonOut,
    "status": status,
    "type_movement": typeMovement,
    "updated_at": updatedAt.toIso8601String(),
    "updated_by": updatedBy,
  };
}
