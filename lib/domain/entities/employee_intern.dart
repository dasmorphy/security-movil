class EmployeeIntern {
  DateTime createdAt;
  String createdBy;
  String dni;
  int groupBusinessId;
  String groupName;
  int idEmployeeIntern;
  String lastname;
  String nameUser;
  String names;
  String observations;
  dynamic photo;
  String position;
  String status;
  DateTime updatedAt;
  String updatedBy;

  EmployeeIntern({
    required this.createdAt,
    required this.createdBy,
    required this.dni,
    required this.groupBusinessId,
    required this.groupName,
    required this.idEmployeeIntern,
    required this.lastname,
    required this.nameUser,
    required this.names,
    required this.observations,
    required this.photo,
    required this.position,
    required this.status,
    required this.updatedAt,
    required this.updatedBy,
  });

  factory EmployeeIntern.fromJson(Map<String, dynamic> json) => EmployeeIntern(
    createdAt: DateTime.parse(json["created_at"]),
    createdBy: json["created_by"],
    dni: json["dni"],
    groupBusinessId: json["group_business_id"],
    groupName: json["group_name"],
    idEmployeeIntern: json["id_employee_intern"],
    lastname: json["lastname"],
    nameUser: json["name_user"],
    names: json["names"],
    observations: json["observations"],
    photo: json["photo"],
    position: json["position"],
    status: json["status"],
    updatedAt: DateTime.parse(json["updated_at"]),
    updatedBy: json["updated_by"],
  );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "dni": dni,
    "group_business_id": groupBusinessId,
    "group_name": groupName,
    "id_employee_intern": idEmployeeIntern,
    "lastname": lastname,
    "name_user": nameUser,
    "names": names,
    "observations": observations,
    "photo": photo,
    "position": position,
    "status": status,
    "updated_at": updatedAt.toIso8601String(),
    "updated_by": updatedBy,
  };
}
