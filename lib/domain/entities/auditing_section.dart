class AuditingSection {
  DateTime createdAt;
  String createdBy;
  int idSection;
  List<Item> items;
  String name;
  int orderNumber;

  AuditingSection({
    required this.createdAt,
    required this.createdBy,
    required this.idSection,
    required this.items,
    required this.name,
    required this.orderNumber,
  });

  factory AuditingSection.fromJson(Map<String, dynamic> json) =>
      AuditingSection(
        createdAt: DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
        idSection: json["id_section"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
        name: json["name"],
        orderNumber: json["order_number"],
      );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "id_section": idSection,
    "items": List<dynamic>.from(items.map((x) => x.toJson())),
    "name": name,
    "order_number": orderNumber,
  };
}

class Item {
  DateTime createdAt;
  String createdBy;
  int idItem;
  String name;
  int orderNumber;

  Item({
    required this.createdAt,
    required this.createdBy,
    required this.idItem,
    required this.name,
    required this.orderNumber,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    createdAt: DateTime.parse(json["created_at"]),
    createdBy: json["created_by"],
    idItem: json["id_item"],
    name: json["name"],
    orderNumber: json["order_number"],
  );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "id_item": idItem,
    "name": name,
    "order_number": orderNumber,
  };
}
