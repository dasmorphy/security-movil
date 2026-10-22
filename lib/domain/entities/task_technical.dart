class TaskTechnical {
  String client;
  int clientId;
  String code;
  DateTime createdAt;
  String createdBy;
  String? description;
  DateTime? endDate;
  int idTask;
  int? inspectionId;
  bool isSupport;
  String location;
  int locationId;
  String name;
  String? nameResponsible;
  List<RecordTechnical>? recordTechnical;
  dynamic requestedBy;
  String? responsible;
  DateTime? startDate;
  String status;
  List<TechnicalsAssignment>? technicalsAssignments;
  DateTime updatedAt;
  String updatedBy;

  TaskTechnical({
    required this.client,
    required this.clientId,
    required this.code,
    required this.createdAt,
    required this.createdBy,
    this.description,
    this.endDate,
    required this.idTask,
    this.inspectionId,
    required this.isSupport,
    required this.location,
    required this.locationId,
    required this.name,
    this.nameResponsible,
    this.recordTechnical,
    required this.requestedBy,
    this.responsible,
    this.startDate,
    required this.status,
    this.technicalsAssignments,
    required this.updatedAt,
    required this.updatedBy,
  });

  factory TaskTechnical.fromJson(Map<String, dynamic> json) => TaskTechnical(
    client: json["client"],
    clientId: json["client_id"],
    code: json["code"],
    createdAt: DateTime.parse(json["created_at"]),
    createdBy: json["created_by"],
    description: json["description"],
    endDate: json["end_date"] == null
      ? null
      : DateTime.parse(json["end_date"]),
    idTask: json["id_task"],
    inspectionId: json["inspection_id"],
    isSupport: json["is_support"],
    location: json["location"],
    locationId: json["location_id"],
    name: json["name"],
    nameResponsible: json["name_responsible"],
    recordTechnical: (json["record_technical"] as List?)
      ?.map((x) => RecordTechnical.fromJson(x))
      .toList(),
    requestedBy: json["requested_by"],
    responsible: json["responsible"],
    startDate: json["start_date"] == null
      ? null
      : DateTime.parse(json["start_date"]),
    status: json["status"],
    technicalsAssignments: json["technicals_assignments"] == null ? [] : List<TechnicalsAssignment>.from(json["technicals_assignments"]!.map((x) => TechnicalsAssignment.fromJson(x))),
    updatedAt: DateTime.parse(json["updated_at"]),
    updatedBy: json["updated_by"],
  );

  Map<String, dynamic> toJson() => {
    "client": client,
    "client_id": clientId,
    "code": code,
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "description": description,
    "end_date": endDate?.toIso8601String(),
    "id_task": idTask,
    "inspection_id": inspectionId,
    "is_support": isSupport,
    "location": location,
    "location_id": locationId,
    "name": name,
    "name_responsible": nameResponsible,
    "record_technical": recordTechnical == null
      ? null
      : List<dynamic>.from(
          recordTechnical!.map((x) => x.toJson()),
        ),
    "requested_by": requestedBy,
    "responsible": responsible,
    "start_date": startDate?.toIso8601String(),
    "status": status,
    "technicals_assignments": technicalsAssignments == null ? [] : List<dynamic>.from(technicalsAssignments!.map((x) => x.toJson())),
    "updated_at": updatedAt.toIso8601String(),
    "updated_by": updatedBy,
  };
}

class RecordTechnical {
  int clientId;
  String createdAt;
  String createdBy;
  int idRecord;
  int locationId;
  String resume;
  List<String> images;

  RecordTechnical({
    required this.clientId,
    required this.createdAt,
    required this.createdBy,
    required this.idRecord,
    required this.locationId,
    required this.resume,
    required this.images,
  });

  factory RecordTechnical.fromJson(Map<String, dynamic> json) =>
      RecordTechnical(
        clientId: json["client_id"],
        createdAt: json["created_at"],
        createdBy: json["created_by"],
        idRecord: json["id_record"],
        locationId: json["location_id"],
        resume: json["resume"],
        images: List<String>.from(json["images"] ?? []),
      );

  Map<String, dynamic> toJson() => {
    "client_id": clientId,
    "created_at": createdAt,
    "created_by": createdBy,
    "id_record": idRecord,
    "location_id": locationId,
    "resume": resume,
    "images": images,
  };
}


class TechnicalsAssignment {
  String? fullnameUser;
  int? idAssignment;
  int? taskId;
  String user;
  String userTechId;

  TechnicalsAssignment({
    this.fullnameUser,
    this.idAssignment,
    this.taskId,
    required this.user,
    required this.userTechId,
  });

  factory TechnicalsAssignment.fromJson(Map<String, dynamic> json) => TechnicalsAssignment(
    fullnameUser: json["fullname_user"],
    idAssignment: json["id_assignment"],
    taskId: json["task_id"],
    user: json["user"],
    userTechId: json["user_tech_id"],
  );

  Map<String, dynamic> toJson() => {
    "fullname_user": fullnameUser,
    "id_assignment": idAssignment,
    "task_id": taskId,
    "user": user,
    "user_tech_id": userTechId,
  };
}
