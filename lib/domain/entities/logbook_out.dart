class LogbookOut {
  String authorizedBy;
  int categoryId;
  DateTime createdAt;
  String createdBy;
  String destiny;
  int groupBusinessId;
  String groupName;
  int idLogbookOut;
  int idSector;
  List<String>? imagesOut;
  String? lat;
  String? long;
  String nameCategory;
  String nameDriver;
  String nameSector;
  String nameUser;
  String observations;
  String? personWithdraws;
  dynamic quantity;
  String? shippingGuide;
  String status;
  String truckLicense;
  dynamic unityId;
  DateTime updatedAt;
  String updatedBy;
  dynamic weight;
  String workday;

  LogbookOut({
    required this.authorizedBy,
    required this.categoryId,
    required this.createdAt,
    required this.createdBy,
    required this.destiny,
    required this.groupBusinessId,
    required this.groupName,
    required this.idLogbookOut,
    required this.idSector,
    this.imagesOut,
    this.lat,
    this.long,
    required this.nameCategory,
    required this.nameDriver,
    required this.nameSector,
    required this.nameUser,
    required this.observations,
    this.personWithdraws,
    required this.quantity,
    this.shippingGuide,
    required this.status,
    required this.truckLicense,
    required this.unityId,
    required this.updatedAt,
    required this.updatedBy,
    required this.weight,
    required this.workday,
  });

  factory LogbookOut.fromJson(Map<String, dynamic> json) => LogbookOut(
    authorizedBy: json["authorized_by"],
    categoryId: json["category_id"],
    createdAt: DateTime.parse(json["created_at"]),
    createdBy: json["created_by"],
    destiny: json["destiny"],
    groupBusinessId: json["group_business_id"],
    groupName: json["group_name"],
    idLogbookOut: json["id_logbook_out"],
    idSector: json["id_sector"],
    imagesOut: json["images_out"] == null
      ? []
      : List<String>.from(json["images_out"]!.map((x) => x)),
    lat: json["lat"],
    long: json["long"],
    nameCategory: json["name_category"],
    nameDriver: json["name_driver"],
    nameSector: json["name_sector"],
    nameUser: json["name_user"],
    observations: json["observations"],
    personWithdraws: json["person_withdraws"],
    quantity: json["quantity"],
    shippingGuide: json["shipping_guide"],
    status: json["status"],
    truckLicense: json["truck_license"],
    unityId: json["unity_id"],
    updatedAt: DateTime.parse(json["updated_at"]),
    updatedBy: json["updated_by"],
    weight: json["weight"],
    workday: json["workday"],
  );

  Map<String, dynamic> toJson() => {
    "authorized_by": authorizedBy,
    "category_id": categoryId,
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "destiny": destiny,
    "group_business_id": groupBusinessId,
    "group_name": groupName,
    "id_logbook_out": idLogbookOut,
    "id_sector": idSector,
    "images_out": imagesOut == null
      ? []
      : List<dynamic>.from(imagesOut!.map((x) => x)),
    "lat": lat,
    "long": long,
    "name_category": nameCategory,
    "name_driver": nameDriver,
    "name_sector": nameSector,
    "name_user": nameUser,
    "observations": observations,
    "person_withdraws": personWithdraws,
    "quantity": quantity,
    "shipping_guide": shippingGuide,
    "status": status,
    "truck_license": truckLicense,
    "unity_id": unityId,
    "updated_at": updatedAt.toIso8601String(),
    "updated_by": updatedBy,
    "weight": weight,
    "workday": workday,
  };
}
