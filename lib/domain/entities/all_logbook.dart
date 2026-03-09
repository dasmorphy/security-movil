import 'package:zentinel/domain/entities/logbook_out.dart';

class AllLogbook {
  String authorizedBy;
  int categoryId;
  DateTime createdAt;
  String createdBy;
  int groupBusinessId;
  String groupName;
  int idSector;
  int? idLogbookOut;
  int? idLogbookEntry;
  List<String>? imagesEntry;
  String? lat;
  String? long;
  String? nameCategory;
  String? nameDriver;
  String? nameSector;
  String nameUser;
  String? observations;
  LogbookOut? out;
  int? quantity;
  String? personWithdraws;
  String? shippingGuide;
  String status;
  String truckLicense;
  int unityId;
  DateTime updatedAt;
  String updatedBy;
  int? weight;
  String workday;
  String? destiny;
  List<String>? imagesOut;

  AllLogbook({
    required this.authorizedBy,
    required this.categoryId,
    required this.createdAt,
    required this.createdBy,
    required this.groupBusinessId,
    required this.groupName,
    required this.idSector,
    this.idLogbookOut,
    this.idLogbookEntry,
    this.imagesEntry,
    this.imagesOut,
    this.lat,
    this.long,
    this.nameCategory,
    this.nameDriver,
    this.nameSector,
    required this.nameUser,
    this.observations,
    this.out,
    required this.quantity,
    this.personWithdraws,
    this.shippingGuide,
    required this.status,
    required this.truckLicense,
    required this.unityId,
    required this.updatedAt,
    required this.updatedBy,
    this.weight,
    required this.workday,
    this.destiny,
  });

  factory AllLogbook.fromJson(Map<String, dynamic> json) => AllLogbook(
    authorizedBy: json["authorized_by"],
    categoryId: json["category_id"],
    createdAt: DateTime.parse(json["created_at"]),
    createdBy: json["created_by"],
    groupBusinessId: json["group_business_id"],
    groupName: json["group_name"],
    idSector: json["id_sector"],
    idLogbookOut: json["id_logbook_out"],
    idLogbookEntry: json["id_logbook_entry"],
    imagesEntry: json["images_entry"] == null
        ? []
        : List<String>.from(json["images_entry"]!.map((x) => x)),
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
    out: json["out"] == null ? null : LogbookOut.fromJson(json["out"]),
    quantity: json["quantity"],
    personWithdraws: json["person_withdraws"],
    shippingGuide: json["shipping_guide"],
    status: json["status"],
    truckLicense: json["truck_license"],
    unityId: json["unity_id"],
    updatedAt: DateTime.parse(json["updated_at"]),
    updatedBy: json["updated_by"],
    weight: json["weight"],
    workday: json["workday"],
    destiny: json["destiny"]
  );

  Map<String, dynamic> toJson() => {
    "authorized_by": authorizedBy,
    "category_id": categoryId,
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "group_business_id": groupBusinessId,
    "group_name": groupName,
    "id_sector": idSector,
    "id_logbook_out": idLogbookOut,
    "id_logbook_entry": idLogbookEntry,
    "images_entry": imagesEntry == null
      ? []
      : List<dynamic>.from(imagesEntry!.map((x) => x)),
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
    "out": out?.toJson(),
    "quantity": quantity,
    "person_withdraws": personWithdraws,
    "shipping_guide": shippingGuide,
    "status": status,
    "truck_license": truckLicense,
    "unity_id": unityId,
    "updated_at": updatedAt.toIso8601String(),
    "updated_by": updatedBy,
    "weight": weight,
    "workday": workday,
    "destiny": destiny
  };
}
