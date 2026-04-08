class AllDispatch {
  String orderNumber;
  DateTime createdAt;
  String createdBy;
  String driver;
  int idDispatch;
  String nameDestiny;
  String nameVehicleType;
  dynamic observations;
  List<ProductsSku> productsSku;
  int skuId;
  String status;
  String truckLicense;
  String typeSku;
  DateTime updatedAt;
  String updatedBy;
  List<Image> images;
  dynamic weight;

  AllDispatch({
    required this.orderNumber,
    required this.createdAt,
    required this.createdBy,
    required this.driver,
    required this.idDispatch,
    required this.nameDestiny,
    required this.nameVehicleType,
    required this.observations,
    required this.productsSku,
    required this.skuId,
    required this.status,
    required this.truckLicense,
    required this.typeSku,
    required this.updatedAt,
    required this.updatedBy,
    required this.weight,
    required this.images
  });

  factory AllDispatch.fromJson(Map<String, dynamic> json) => AllDispatch(
    orderNumber: json["order_number"],
    createdAt: DateTime.parse(json["created_at"]),
    createdBy: json["created_by"],
    driver: json["driver"],
    idDispatch: json["id_dispatch"],
    nameDestiny: json["name_destiny"],
    nameVehicleType: json["name_vehicle_type"],
    observations: json["observations"],
    productsSku: List<ProductsSku>.from(
      json["products_sku"].map((x) => ProductsSku.fromJson(x)),
    ),
    images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
    skuId: json["sku_id"],
    status: json["status"],
    truckLicense: json["truck_license"],
    typeSku: json["type_sku"],
    updatedAt: DateTime.parse(json["updated_at"]),
    updatedBy: json["updated_by"],
    weight: json["weight"],
  );

  Map<String, dynamic> toJson() => {
    "order_number": orderNumber,
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "driver": driver,
    "images": List<dynamic>.from(images.map((x) => x.toJson())),
    "id_dispatch": idDispatch,
    "name_destiny": nameDestiny,
    "name_vehicle_type": nameVehicleType,
    "observations": observations,
    "products_sku": List<dynamic>.from(productsSku.map((x) => x.toJson())),
    "sku_id": skuId,
    "status": status,
    "truck_license": truckLicense,
    "type_sku": typeSku,
    "updated_at": updatedAt.toIso8601String(),
    "updated_by": updatedBy,
    "weight": weight,
  };
}

class ProductsSku {
  int idProduct;
  String name;
  int quantity;

  ProductsSku({
    required this.idProduct,
    required this.name,
    required this.quantity,
  });

  factory ProductsSku.fromJson(Map<String, dynamic> json) => ProductsSku(
    idProduct: json["id_product"],
    name: json["name"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "id_product": idProduct,
    "name": name,
    "quantity": quantity,
  };
}

class Image {
  String imagePath;
  String process;

  Image({required this.imagePath, required this.process});

  factory Image.fromJson(Map<String, dynamic> json) =>
      Image(imagePath: json["image_path"], process: json["process"]);

  Map<String, dynamic> toJson() => {
    "image_path": imagePath,
    "process": process,
  };
}