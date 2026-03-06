class Authorized {
  DateTime createdAt;
  int idAuthorized;
  String name;
  DateTime updatedAt;

  Authorized({
    required this.createdAt,
    required this.idAuthorized,
    required this.name,
    required this.updatedAt,
  });

  factory Authorized.fromJson(Map<String, dynamic> json) => Authorized(
    createdAt: DateTime.parse(json["created_at"]),
    idAuthorized: json["id_authorized"],
    name: json["name"],
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt.toIso8601String(),
    "id_authorized": idAuthorized,
    "name": name,
    "updated_at": updatedAt.toIso8601String(),
  };
}
