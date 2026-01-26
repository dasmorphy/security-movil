class Category {
  final int idCategory;
  final String nameCategory;
  final String createdAt;
  final String updatedAt;

  Category({
    required this.idCategory, 
    required this.nameCategory, 
    required this.createdAt, 
    required this.updatedAt
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    idCategory: json['id_category'],
    nameCategory: json['name_category'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
  );

}