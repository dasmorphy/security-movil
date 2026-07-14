class AllLogbook {
  String authorizedBy;
  int categoryId;
  DateTime createdAt;
  String createdBy;
  String? description;
  String destiny;
  int groupBusinessId;
  String groupName;
  int? idSector;
  List<String> images;
  String? lat;
  int? logbookOutId;
  String? long;
  String nameCategory;
  String nameDriver;
  String? nameSector;
  String nameUser;
  dynamic dniDriver;
  bool isBlacklist;
  String observations;
  AllLogbook? out;
  String? personWithdraws;
  String? provider;
  dynamic quantity;
  int recordId;
  String recordType;
  String? shippingGuide;
  String? status;
  String truckLicense;
  dynamic unityId;
  DateTime updatedAt;
  String updatedBy;
  dynamic weight;
  String workday;

  AllLogbook({
    required this.authorizedBy,
    required this.categoryId,
    required this.createdAt,
    required this.createdBy,
    this.description,
    required this.destiny,
    required this.groupBusinessId,
    required this.groupName,
    this.idSector,
    required this.images,
    this.lat,
    this.logbookOutId,
    this.long,
    required this.nameCategory,
    required this.dniDriver,
    required this.isBlacklist,
    required this.nameDriver,
    this.nameSector,
    required this.nameUser,
    required this.observations,
    this.out,
    required this.personWithdraws,
    this.provider,
    required this.quantity,
    required this.recordId,
    required this.recordType,
    this.shippingGuide,
    this.status,
    required this.truckLicense,
    required this.unityId,
    required this.updatedAt,
    required this.updatedBy,
    required this.weight,
    required this.workday,
  });

  factory AllLogbook.fromJson(Map<String, dynamic> json) => AllLogbook(
    authorizedBy: json["authorized_by"],
    categoryId: json["category_id"],
    createdAt: DateTime.parse(json["created_at"]),
    createdBy: json["created_by"],
    description: json["description"],
    destiny: json["destiny"],
    groupBusinessId: json["group_business_id"],
    groupName: json["group_name"],
    idSector: json["id_sector"],
    images: List<String>.from(json["images"].map((x) => x)),
    lat: json["lat"],
    logbookOutId: json["logbook_out_id"],
    long: json["long"],
    nameCategory: json["name_category"],
    nameDriver: json["name_driver"],
    nameSector: json["name_sector"],
    nameUser: json["name_user"],
    observations: json["observations"],
    out: json["out"] == null ? null : AllLogbook.fromJson(json["out"]),
    personWithdraws: json["person_withdraws"],
    provider: json["provider"],
    quantity: json["quantity"],
    recordId: json["record_id"],
    recordType: json["record_type"],
    shippingGuide: json["shipping_guide"],
    status: json["status"],
    truckLicense: json["truck_license"],
    unityId: json["unity_id"],
    updatedAt: DateTime.parse(json["updated_at"]),
    updatedBy: json["updated_by"],
    weight: json["weight"],
    workday: json["workday"], 
    dniDriver: json["dni_driver"], 
    isBlacklist: json["is_blacklist"],
  );

  Map<String, dynamic> toJson() => {
    "authorized_by": authorizedBy,
    "category_id": categoryId,
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "description": description,
    "destiny": destiny,
    "group_business_id": groupBusinessId,
    "group_name": groupName,
    "id_sector": idSector,
    "images": List<dynamic>.from(images.map((x) => x)),
    "lat": lat,
    "logbook_out_id": logbookOutId,
    "long": long,
    "name_category": nameCategory,
    "name_driver": nameDriver,
    "is_blacklist": isBlacklist,
    "dni_driver": dniDriver,
    "name_sector": nameSector,
    "name_user": nameUser,
    "observations": observations,
    "out": out?.toJson(),
    "person_withdraws": personWithdraws,
    "provider": provider,
    "quantity": quantity,
    "record_id": recordId,
    "record_type": recordType,
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
