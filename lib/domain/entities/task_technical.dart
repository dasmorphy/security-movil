class TaskTechnical {
  String client;
  String code;
  DateTime createdAt;
  String createdBy;
  String? description;
  int idTask;
  String location;
  String name;
  String status;
  DateTime updatedAt;
  String updatedBy;

  TaskTechnical({
    required this.client,
    required this.code,
    required this.createdAt,
    required this.createdBy,
    this.description,
    required this.idTask,
    required this.location,
    required this.name,
    required this.status,
    required this.updatedAt,
    required this.updatedBy,
  });

  factory TaskTechnical.fromJson(Map<String, dynamic> json) => TaskTechnical(
    client: json["client"],
    code: json["code"],
    createdAt: DateTime.parse(json["created_at"]),
    createdBy: json["created_by"],
    description: json["description"],
    idTask: json["id_task"],
    location: json["location"],
    name: json["name"],
    status: json["status"],
    updatedAt: DateTime.parse(json["updated_at"]),
    updatedBy: json["updated_by"],
  );

  Map<String, dynamic> toJson() => {
    "client": client,
    "code": code,
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "description": description,
    "id_task": idTask,
    "location": location,
    "name": name,
    "status": status,
    "updated_at": updatedAt.toIso8601String(),
    "updated_by": updatedBy,
  };
}
