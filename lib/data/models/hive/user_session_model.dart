import 'package:hive/hive.dart';

part 'user_session_model.g.dart';

@HiveType(typeId: 1)
class UserSessionModel {
  @HiveField(0)
  final String userId;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String token;

  @HiveField(3)
  final String role;

  @HiveField(4)
  final Map<String, dynamic> attributes;

  @HiveField(5)
  final String user;

  @HiveField(6)
  final bool isActive;

  UserSessionModel({
    required this.userId,
    required this.email,
    required this.token,
    required this.role,
    required this.attributes,
    required this.user,
    required this.isActive,
  });
}
