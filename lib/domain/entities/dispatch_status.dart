class DispatchStatus {
  DateTime createdAt;
  int idStatus;
  String name;

  DispatchStatus({
    required this.createdAt,
    required this.idStatus,
    required this.name,
  });

  factory DispatchStatus.fromJson(Map<String, dynamic> json) => DispatchStatus(
    createdAt: DateTime.parse(json["created_at"]),
    idStatus: json["id_status"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt.toIso8601String(),
    "id_status": idStatus,
    "name": name,
  };
}
