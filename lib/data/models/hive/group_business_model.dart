import 'package:hive/hive.dart';

part 'group_business_model.g.dart';

@HiveType(typeId: 6)
class GroupBusinessModel {
  @HiveField(0)
  final int idGroupBusiness;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int businessId;

  @HiveField(3)
  final int sectorId;

  @HiveField(4)
  final String createdAt;

  @HiveField(5)
  final String updatedAt;

  GroupBusinessModel({
    required this.idGroupBusiness,
    required this.name,
    required this.businessId,
    required this.sectorId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GroupBusinessModel.fromEntity(
    int idGroupBusiness,
    String name,
    int businessId,
    int sectorId,
    String createdAt,
    String updatedAt,
  ) {
    return GroupBusinessModel(
      idGroupBusiness: idGroupBusiness,
      name: name,
      businessId: businessId,
      sectorId: sectorId,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id_group_business': idGroupBusiness,
    'name': name,
    'business_id': businessId,
    'sector_id': sectorId,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}
