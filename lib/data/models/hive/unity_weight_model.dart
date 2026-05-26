import 'package:hive/hive.dart';

part 'unity_weight_model.g.dart';

@HiveType(typeId: 4)
class UnityWeightModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String code;

  @HiveField(3)
  final String createdAt;

  @HiveField(4)
  final String updatedAt;

  UnityWeightModel({
    required this.id,
    required this.name,
    required this.code,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UnityWeightModel.fromEntity(
    int id,
    String name,
    String code,
    String createdAt,
    String updatedAt,
  ) {
    return UnityWeightModel(
      id: id,
      name: name,
      code: code,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'code': code,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}
