import 'package:hive/hive.dart';

part 'authorized_model.g.dart';

@HiveType(typeId: 2)
class AuthorizedModel {
  @HiveField(0)
  final int idAuthorized;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String createdAt;

  @HiveField(3)
  final String updatedAt;

  AuthorizedModel({
    required this.idAuthorized,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AuthorizedModel.fromEntity(
    int idAuthorized,
    String name,
    String createdAt,
    String updatedAt,
  ) {
    return AuthorizedModel(
      idAuthorized: idAuthorized,
      name: name,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id_authorized': idAuthorized,
    'name': name,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}
