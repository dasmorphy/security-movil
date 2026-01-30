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
