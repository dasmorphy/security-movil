class TaskTechnical {
  String client;
  int clientId;
  String code;
  DateTime createdAt;
  String createdBy;
  dynamic description;
  int idTask;
  String location;
  int locatonId;
  String name;
  String status;
  DateTime updatedAt;
  String updatedBy;

  TaskTechnical({
    required this.client,
    required this.clientId,
    required this.code,
    required this.createdAt,
    required this.createdBy,
    required this.description,
    required this.idTask,
    required this.location,
    required this.locatonId,
    required this.name,
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
    locatonId: json["locaton_id"],
    name: json["name"],
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
    "locaton_id": locatonId,
    "name": name,
    "status": status,
    "updated_at": updatedAt.toIso8601String(),
    "updated_by": updatedBy,
  };
}
