class AllDispatch {
  DateTime createdAt;
  String createdBy;
  String driver;
  int idDispatch;
  List<Image> images;
  String nameDestiny;
  String nameVehicleType;
  String observations;
  String orderNumber;
  List<Skus> skus;
  String status;
  String truckLicense;
  DateTime updatedAt;
  String updatedBy;
  dynamic weight;

  AllDispatch({
    required this.createdAt,
    required this.createdBy,
    required this.driver,
    required this.idDispatch,
    required this.images,
    required this.nameDestiny,
    required this.nameVehicleType,
    required this.observations,
    required this.orderNumber,
    required this.skus,
    required this.status,
    required this.truckLicense,
    required this.updatedAt,
    required this.updatedBy,
    required this.weight,
  });

  factory AllDispatch.fromJson(Map<String, dynamic> json) => AllDispatch(
    createdAt: DateTime.parse(json["created_at"]),
    createdBy: json["created_by"],
    driver: json["driver"],
    idDispatch: json["id_dispatch"],
    images: List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
    nameDestiny: json["name_destiny"],
    nameVehicleType: json["name_vehicle_type"],
    observations: json["observations"],
    orderNumber: json["order_number"],
    skus: List<Skus>.from(json["skus"].map((x) => Skus.fromJson(x))),
    status: json["status"],
    truckLicense: json["truck_license"],
    updatedAt: DateTime.parse(json["updated_at"]),
    updatedBy: json["updated_by"],
    weight: json["weight"],
  );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "driver": driver,
    "id_dispatch": idDispatch,
    "images": List<dynamic>.from(images.map((x) => x.toJson())),
    "name_destiny": nameDestiny,
    "name_vehicle_type": nameVehicleType,
    "observations": observations,
    "order_number": orderNumber,
    "skus": List<dynamic>.from(skus.map((x) => x.toJson())),
    "status": status,
    "truck_license": truckLicense,
    "updated_at": updatedAt.toIso8601String(),
    "updated_by": updatedBy,
    "weight": weight,
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

class Skus {
  int idSku;
  List<Product> products;
  String typeSku;

  Skus({required this.idSku, required this.products, required this.typeSku});

  factory Skus.fromJson(Map<String, dynamic> json) => Skus(
    idSku: json["id_sku"],
    products: List<Product>.from(
      json["products"].map((x) => Product.fromJson(x)),
    ),
    typeSku: json["type_sku"],
  );

  Map<String, dynamic> toJson() => {
    "id_sku": idSku,
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
    "type_sku": typeSku,
  };
}

class Product {
  int idProduct;
  String name;
  int quantity;

  Product({
    required this.idProduct,
    required this.name,
    required this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
