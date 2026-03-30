class DispatchProducts {
  DateTime createdAt;
  String createdBy;
  int idProduct;
  String name;
  String presentationType;
  dynamic price;
  dynamic stock;
  DateTime updatedAt;
  String updatedBy;

  DispatchProducts({
    required this.createdAt,
    required this.createdBy,
    required this.idProduct,
    required this.name,
    required this.presentationType,
    required this.price,
    required this.stock,
    required this.updatedAt,
    required this.updatedBy,
  });

  factory DispatchProducts.fromJson(Map<String, dynamic> json) => DispatchProducts(
    createdAt: DateTime.parse(json["created_at"]),
    createdBy: json["created_by"],
    idProduct: json["id_product"],
    name: json["name"],
    presentationType: json["presentation_type"],
    price: json["price"],
    stock: json["stock"],
    updatedAt: DateTime.parse(json["updated_at"]),
    updatedBy: json["updated_by"],
  );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "id_product": idProduct,
    "name": name,
    "presentation_type": presentationType,
    "price": price,
    "stock": stock,
    "updated_at": updatedAt.toIso8601String(),
    "updated_by": updatedBy,
  };
}
