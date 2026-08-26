class User {
  Attributes attributes;
  DateTime createdAt;
  String email;
  String idUser;
  bool isActive;
  String platform;
  String role;
  DateTime updatedAt;
  String user;

  User({
    required this.attributes,
    required this.createdAt,
    required this.email,
    required this.idUser,
    required this.isActive,
    required this.platform,
    required this.role,
    required this.updatedAt,
    required this.user,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    attributes: Attributes.fromJson(json["attributes"]),
    createdAt: DateTime.parse(json["created_at"]),
    email: json["email"],
    idUser: json["id_user"],
    isActive: json["is_active"],
    platform: json["platform"],
    role: json["role"],
    updatedAt: DateTime.parse(json["updated_at"]),
    user: json["user"],
  );

  Map<String, dynamic> toJson() => {
    "attributes": attributes.toJson(),
    "created_at": createdAt.toIso8601String(),
    "email": email,
    "id_user": idUser,
    "is_active": isActive,
    "platform": platform,
    "role": role,
    "updated_at": updatedAt.toIso8601String(),
    "user": user,
  };
}

class Attributes {
  String fullname;
  int idBusiness;

  Attributes({required this.fullname, required this.idBusiness});

  factory Attributes.fromJson(Map<String, dynamic> json) =>
      Attributes(fullname: json["fullname"], idBusiness: json["id_business"]);

  Map<String, dynamic> toJson() => {
    "fullname": fullname,
    "id_business": idBusiness,
  };
}
