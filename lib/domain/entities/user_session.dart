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
  final Map<String, dynamic> attributes;
  String email;
  String idUser;
  bool isActive;
  String user;
  String role;

  User({
    required this.attributes,
    required this.email,
    required this.idUser,
    required this.isActive,
    required this.user,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    attributes: json['attributes'] ?? {},
    email: json["email"],
    idUser: json["id_user"],
    isActive: json["is_active"],
    user: json["user"],
    role: json["role"],
  );
}
