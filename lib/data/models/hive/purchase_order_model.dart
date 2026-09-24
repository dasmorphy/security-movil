import 'package:hive/hive.dart';

part 'purchase_order_model.g.dart';

@HiveType(typeId: 8)
class PurchaseOrderModel {
  @HiveField(0)
  final String createdAt;
  @HiveField(1)
  final String createdBy;
  @HiveField(2)
  final String endDate;
  @HiveField(3)
  final int idOrder;
  @HiveField(4)
  final String numberOrder;
  @HiveField(5)
  final dynamic observations;
  @HiveField(6)
  final String provider;
  @HiveField(7)
  final double quantity;
  @HiveField(8)
  final String startDate;
  @HiveField(9)
  final int statusId;
  @HiveField(10)
  final String statusName;
  @HiveField(11)
  final String typeOrder;
  @HiveField(12)
  final String updatedAt;
  @HiveField(13)
  final String updatedBy;

  const PurchaseOrderModel({
    required this.createdAt,
    required this.createdBy,
    required this.endDate,
    required this.idOrder,
    required this.numberOrder,
    required this.observations,
    required this.provider,
    required this.quantity,
    required this.startDate,
    required this.statusId,
    required this.statusName,
    required this.typeOrder,
    required this.updatedAt,
    required this.updatedBy,
  });
}
