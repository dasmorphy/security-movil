import 'package:hive/hive.dart';

part 'destiny_intern_model.g.dart';

@HiveType(typeId: 3)
class DestinyInternModel {
  @HiveField(0)
  final int idDestiny;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String createdAt;

  @HiveField(3)
  final String updatedAt;

  DestinyInternModel({
    required this.idDestiny,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DestinyInternModel.fromEntity(
    int idDestiny,
    String name,
    String createdAt,
    String updatedAt,
  ) {
    return DestinyInternModel(
      idDestiny: idDestiny,
      name: name,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id_destiny': idDestiny,
    'name': name,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}
