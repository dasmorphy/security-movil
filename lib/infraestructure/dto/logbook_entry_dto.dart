class CategoryDto {
    int idCategory;
    String nameCategory;
    String createdAt;
    String updatedAt;

    CategoryDto({
        required this.idCategory,
        required this.nameCategory,
        required this.createdAt,
        required this.updatedAt,
    });

    factory CategoryDto.fromJson(Map<String, dynamic> json) => CategoryDto(
        idCategory: json["id_category"],
        nameCategory: json["name_category"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id_category": idCategory,
        "name_category": nameCategory,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}

class UnityWeightDto {
    int idUnity;
    String name;
    String createdAt;
    String updatedAt;

    UnityWeightDto({
        required this.idUnity,
        required this.name,
        required this.createdAt,
        required this.updatedAt,
    });

    factory UnityWeightDto.fromJson(Map<String, dynamic> json) => UnityWeightDto(
        idUnity: json["id_unity"],
        name: json["name"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id_unity": idUnity,
        "name": name,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}