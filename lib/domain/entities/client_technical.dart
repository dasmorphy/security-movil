class ClientTechnical {
  DateTime createdAt;
  String createdBy;
  int idClient;
  String name;
  DateTime updatedAt;
  String updatedBy;

  ClientTechnical({
    required this.createdAt,
    required this.createdBy,
    required this.idClient,
    required this.name,
    required this.updatedAt,
    required this.updatedBy,
  });

  factory ClientTechnical.fromJson(Map<String, dynamic> json) =>
      ClientTechnical(
        createdAt: DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
        idClient: json["id_client"],
        name: json["name"],
        updatedAt: DateTime.parse(json["updated_at"]),
        updatedBy: json["updated_by"],
      );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "id_client": idClient,
    "name": name,
    "updated_at": updatedAt.toIso8601String(),
    "updated_by": updatedBy,
  };
}
