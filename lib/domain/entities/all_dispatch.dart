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
  dynamic reception;
  List<Skus> skus;
  String status;
  String truckLicense;
  DateTime updatedAt;
  String updatedBy;
  String typeProcess;
  dynamic weight;

  AllDispatch({
    required this.createdAt,
    required this.createdBy,
    required this.driver,
    required this.idDispatch,
    required this.images,
    required this.nameDestiny,
    required this.nameVehicleType,
    required this.typeProcess,
    required this.observations,
    required this.orderNumber,
    required this.reception,
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
    typeProcess: json["type_process"],
    nameVehicleType: json["name_vehicle_type"],
    observations: json["observations"],
    orderNumber: json["order_number"],
    reception: json["reception"],
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
    "type_process": typeProcess,
    "observations": observations,
    "order_number": orderNumber,
    "reception": reception,
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

  factory Image.fromJson(Map<String, dynamic> json) => Image(
    imagePath: json["image_path"],
    process: json["process"],
  );

  Map<String, dynamic> toJson() => {
    "image_path": imagePath,
    "process": process,
  };
}

class Reception {
  DateTime createdAt;
  int idReception;
  bool isCorrect;
  String observations;
  List<dynamic> receptionDetail;

  Reception({
    required this.createdAt,
    required this.idReception,
    required this.isCorrect,
    required this.observations,
    required this.receptionDetail,
  });

  factory Reception.fromJson(Map<String, dynamic> json) => Reception(
    createdAt: DateTime.parse(json["created_at"]),
    idReception: json["id_reception"],
    isCorrect: json["is_correct"],
    observations: json["observations"],
    receptionDetail: List<dynamic>.from(json["reception_detail"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt.toIso8601String(),
    "id_reception": idReception,
    "is_correct": isCorrect,
    "observations": observations,
    "reception_detail": List<dynamic>.from(receptionDetail.map((x) => x)),
  };
}

class Skus {
  int idSku;
  String typeSku;

  Skus({required this.idSku, required this.typeSku});

  factory Skus.fromJson(Map<String, dynamic> json) => Skus(
    idSku: json["id_sku"],
    typeSku: json["type_sku"],
  );

  Map<String, dynamic> toJson() => {
    "id_sku": idSku,
    "type_sku": typeSku,
  };
}

class Product {
  int idProduct;
  int idProductSku;
  String name;
  int quantity;

  Product({
    required this.idProduct,
    required this.idProductSku,
    required this.name,
    required this.quantity,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    idProduct: json["id_product"],
    idProductSku: json["id_product_sku"],
    name: json["name"],
    quantity: json["quantity"],
  );

  Map<String, dynamic> toJson() => {
    "id_product": idProduct,
    "id_product_sku": idProductSku,
    "name": name,
    "quantity": quantity,
  };
}
