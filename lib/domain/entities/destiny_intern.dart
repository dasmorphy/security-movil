class DestinyIntern {
  DateTime createdAt;
  int idDestiny;
  String name;
  DateTime updatedAt;

  DestinyIntern({
    required this.createdAt,
    required this.idDestiny,
    required this.name,
    required this.updatedAt,
  });

  factory DestinyIntern.fromJson(Map<String, dynamic> json) => DestinyIntern(
    createdAt: DateTime.parse(json["created_at"]),
    idDestiny: json["id_destiny"],
    name: json["name"],
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt.toIso8601String(),
    "id_destiny": idDestiny,
    "name": name,
    "updated_at": updatedAt.toIso8601String(),
  };
}
