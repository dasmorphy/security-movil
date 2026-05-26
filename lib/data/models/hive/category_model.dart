import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 1)
class CategoryModel {
  @HiveField(0)
  final int idCategory;

  @HiveField(1)
  final String nameCategory;

  @HiveField(2)
  final String createdAt;

  @HiveField(3)
  final String updatedAt;

  CategoryModel({
    required this.idCategory,
    required this.nameCategory,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convertir desde la entidad Category al modelo Hive
  factory CategoryModel.fromEntity(
    int idCategory,
    String nameCategory,
    String createdAt,
    String updatedAt,
  ) {
    return CategoryModel(
      idCategory: idCategory,
      nameCategory: nameCategory,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Convertir modelo Hive de vuelta a datos de entidad
  Map<String, dynamic> toJson() => {
    'id_category': idCategory,
    'name_category': nameCategory,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}
