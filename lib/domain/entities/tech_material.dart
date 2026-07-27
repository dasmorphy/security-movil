class TechMaterial {
  dynamic basePrice;
  dynamic code;
  DateTime createdAt;
  String createdBy;
  dynamic description;
  int idEquipment;
  dynamic model;
  dynamic price;
  dynamic product;
  dynamic profitMargin;
  dynamic profitMarginDollar;
  dynamic provider;
  dynamic stock;
  dynamic unit;
  DateTime updatedAt;
  String updatedBy;

  TechMaterial({
    required this.basePrice,
    required this.code,
    required this.createdAt,
    required this.createdBy,
    required this.description,
    required this.idEquipment,
    required this.model,
    required this.price,
    required this.product,
    required this.profitMargin,
    required this.profitMarginDollar,
    required this.provider,
    required this.stock,
    required this.unit,
    required this.updatedAt,
    required this.updatedBy,
  });

  factory TechMaterial.fromJson(Map<String, dynamic> json) => TechMaterial(
    basePrice: json["base_price"],
    code: json["code"],
    createdAt: DateTime.parse(json["created_at"]),
    createdBy: json["created_by"],
    description: json["description"],
    idEquipment: json["id_equipment"],
    model: json["model"],
    price: json["price"],
    product: json["product"],
    profitMargin: json["profit_margin"],
    profitMarginDollar: json["profit_margin_dollar"],
    provider: json["provider"],
    stock: json["stock"],
    unit: json["unit"],
    updatedAt: DateTime.parse(json["updated_at"]),
    updatedBy: json["updated_by"],
  );

  Map<String, dynamic> toJson() => {
    "base_price": basePrice,
    "code": code,
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "description": description,
    "id_equipment": idEquipment,
    "model": model,
    "price": price,
    "product": product,
    "profit_margin": profitMargin,
    "profit_margin_dollar": profitMarginDollar,
    "provider": provider,
    "stock": stock,
    "unit": unit,
    "updated_at": updatedAt.toIso8601String(),
    "updated_by": updatedBy,
  };
}
