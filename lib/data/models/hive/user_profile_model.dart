import 'package:hive/hive.dart';

part 'user_profile_model.g.dart';

@HiveType(typeId: 0)
class UserProfileModel {
  @HiveField(0)
  final String email;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String photoPath;

  @HiveField(3)
  final DateTime createdAt;

  UserProfileModel({
    required this.email,
    required this.name,
    required this.photoPath,
    required this.createdAt,
  });
}
