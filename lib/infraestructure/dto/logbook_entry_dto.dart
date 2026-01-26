class CategoryDto {
  int idCategory;
  String nameCategory;
  String code;
  String createdAt;
  String updatedAt;

  CategoryDto({
    required this.idCategory,
    required this.nameCategory,
    required this.code,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryDto.fromJson(Map<String, dynamic> json) => CategoryDto(
    idCategory: json["id_category"],
    nameCategory: json["name_category"],
    code: json["code"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id_category": idCategory,
    "name_category": nameCategory,
    "code": code,
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

class LogbookEntry {
  int idLogbookEntry;
  int unityId;
  int categoryId;
  String shippingGuide;
  String description;
  int quantity;
  int weight;
  String provider;
  String destinyIntern;
  String authorizedBy;
  String observations;
  String createdAt;
  String updatedAt;
  String createdBy;
  String updatedBy;

  LogbookEntry({
    required this.idLogbookEntry,
    required this.unityId,
    required this.categoryId,
    required this.shippingGuide,
    required this.description,
    required this.quantity,
    required this.weight,
    required this.provider,
    required this.destinyIntern,
    required this.authorizedBy,
    required this.observations,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.updatedBy,
  });

  factory LogbookEntry.fromJson(Map<String, dynamic> json) => LogbookEntry(
    idLogbookEntry: json["id_logbook_entry"],
    unityId: json["unity_id"],
    categoryId: json["category_id"],
    shippingGuide: json["shipping_guide"],
    description: json["description"],
    quantity: json["quantity"],
    weight: json["weight"],
    provider: json["provider"],
    destinyIntern: json["destiny_intern"],
    authorizedBy: json["authorized_by"],
    observations: json["observations"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    createdBy: json["created_by"],
    updatedBy: json["updated_by"],
  );

  Map<String, dynamic> toJson() => {
    "id_logbook_entry": idLogbookEntry,
    "unity_id": unityId,
    "category_id": categoryId,
    "shipping_guide": shippingGuide,
    "description": description,
    "quantity": quantity,
    "weight": weight,
    "provider": provider,
    "destiny_intern": destinyIntern,
    "authorized_by": authorizedBy,
    "observations": observations,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "created_by": createdBy,
    "updated_by": updatedBy,
  };
}
