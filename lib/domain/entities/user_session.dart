class UserSession {
  final String userId;
  final String email;
  final String token;
  final String role;

  const UserSession({
    required this.userId,
    required this.email,
    required this.token,
    required this.role,
  });

  bool get isAuthenticated => token.isNotEmpty;
}

class User {
    Attributes attributes;
    String email;
    String idUser;
    bool isActive;
    String user;

    User({
        required this.attributes,
        required this.email,
        required this.idUser,
        required this.isActive,
        required this.user,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        attributes: Attributes.fromJson(json["attributes"]),
        email: json["email"],
        idUser: json["id_user"],
        isActive: json["is_active"],
        user: json["user"],
    );

    Map<String, dynamic> toJson() => {
        "attributes": attributes.toJson(),
        "email": email,
        "id_user": idUser,
        "is_active": isActive,
        "user": user,
    };
}

class Attributes {
    Attributes();

    factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
    );

    Map<String, dynamic> toJson() => {
    };
}
