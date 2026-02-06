class GroupBusiness {
  int businessId;
  DateTime createdAt;
  int idGroupBusiness;
  String name;
  int sectorId;
  DateTime updatedAt;

  GroupBusiness({
    required this.businessId,
    required this.createdAt,
    required this.idGroupBusiness,
    required this.name,
    required this.sectorId,
    required this.updatedAt,
  });

  factory GroupBusiness.fromJson(Map<String, dynamic> json) => GroupBusiness(
    businessId: json["business_id"],
    createdAt: DateTime.parse(json["created_at"]),
    idGroupBusiness: json["id_group_business"],
    name: json["name"],
    sectorId: json["sector_id"],
    updatedAt: DateTime.parse(json["updated_at"]),
  );
}
