class TaskTechnical {
  String client;
  int clientId;
  String code;
  DateTime createdAt;
  String createdBy;
  String? description;
  int idTask;
  String location;
  int locationId;
  String name;
  List<RecordTechnical>? recordTechnical;
  String status;
  DateTime updatedAt;
  String updatedBy;

  TaskTechnical({
    required this.client,
    required this.clientId,
    required this.code,
    required this.createdAt,
    required this.createdBy,
    this.description,
    required this.idTask,
    required this.location,
    required this.locationId,
    required this.name,
    this.recordTechnical,
    required this.status,
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
    idTask: json["id_task"],
    location: json["location"],
    locationId: json["location_id"],
    name: json["name"],
    recordTechnical: (json["record_technical"] as List?)
      ?.map((x) => RecordTechnical.fromJson(x))
      .toList(),
    status: json["status"],
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
    "id_task": idTask,
    "location": location,
    "location_id": locationId,
    "name": name,
    "record_technical": recordTechnical == null
      ? null
      : List<dynamic>.from(
          recordTechnical!.map((x) => x.toJson()),
        ),
    "status": status,
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

  RecordTechnical({
    required this.clientId,
    required this.createdAt,
    required this.createdBy,
    required this.idRecord,
    required this.locationId,
    required this.resume,
  });

  factory RecordTechnical.fromJson(Map<String, dynamic> json) =>
      RecordTechnical(
        clientId: json["client_id"],
        createdAt: json["created_at"],
        createdBy: json["created_by"],
        idRecord: json["id_record"],
        locationId: json["location_id"],
        resume: json["resume"],
      );

  Map<String, dynamic> toJson() => {
    "client_id": clientId,
    "created_at": createdAt,
    "created_by": createdBy,
    "id_record": idRecord,
    "location_id": locationId,
    "resume": resume,
  };
}
