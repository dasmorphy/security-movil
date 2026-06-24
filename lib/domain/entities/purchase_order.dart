class PurchaseOrder {
  DateTime createdAt;
  String createdBy;
  int destinyId;
  String destinyName;
  DateTime endDate;
  int idOrder;
  String numberOrder;
  String observations;
  String provider;
  double quantity;
  DateTime startDate;
  int statusId;
  String statusName;
  String typeOrder;
  DateTime updatedAt;
  String updatedBy;

  PurchaseOrder({
    required this.createdAt,
    required this.createdBy,
    required this.destinyId,
    required this.destinyName,
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

  factory PurchaseOrder.fromJson(Map<String, dynamic> json) => PurchaseOrder(
    createdAt: DateTime.parse(json["created_at"]),
    createdBy: json["created_by"],
    destinyId: json["destiny_id"],
    destinyName: json["destiny_name"],
    endDate: DateTime.parse(json["end_date"]),
    idOrder: json["id_order"],
    numberOrder: json["number_order"],
    observations: json["observations"],
    provider: json["provider"],
    quantity: json["quantity"],
    startDate: DateTime.parse(json["start_date"]),
    statusId: json["status_id"],
    statusName: json["status_name"],
    typeOrder: json["type_order"],
    updatedAt: DateTime.parse(json["updated_at"]),
    updatedBy: json["updated_by"],
  );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "destiny_id": destinyId,
    "destiny_name": destinyName,
    "end_date": endDate.toIso8601String(),
    "id_order": idOrder,
    "number_order": numberOrder,
    "observations": observations,
    "provider": provider,
    "quantity": quantity,
    "start_date": startDate.toIso8601String(),
    "status_id": statusId,
    "status_name": statusName,
    "type_order": typeOrder,
    "updated_at": updatedAt.toIso8601String(),
    "updated_by": updatedBy,
  };
}
